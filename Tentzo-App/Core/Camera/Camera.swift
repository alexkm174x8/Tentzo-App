//
//  Camera.swift
//  Tentzo-App
//
//  Created by Miranda Colorado Arróniz on 14/11/24.
//

import SwiftUI
import Photos

struct Camera: View {
    @StateObject var camera = CamModel()
    @State private var showSaveAlert = false
    @State private var showPhotoPicker = false
    @State private var selectedImage: UIImage?

    var body: some View {
        ZStack {
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
                .opacity((camera.isTaken || selectedImage != nil) ? 0 : 1)
            
            if camera.isTaken && selectedImage == nil {
                ImageView(imageData: camera.picData)
                    .transition(.opacity)
            }
            
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(.all, edges: .all)
                    .transition(.opacity)
            }

            VStack {
                topBar()
                Spacer()
                bottomBar()
            }
        }
        .onAppear {
            camera.check()
        }
        .alert(isPresented: $camera.alert) {
            Alert(
                title: Text("Permiso denegado"),
                message: Text("Por favor permita el acceso a la cámara y a la biblioteca de fotos en la configuración."),
                dismissButton: .default(Text("OK"))
            )
        }
        .alert(isPresented: $showSaveAlert) {
            Alert(
                title: Text("Éxito"),
                message: Text("Imagen guardada con éxito."),
                dismissButton: .default(Text("OK"), action: {
                    camera.isSaved = false
                })
            )
        }
    }

    private func topBar() -> some View {
        HStack {
            if camera.isTaken || selectedImage != nil {
                Button(action: {
                    if selectedImage != nil {
                        selectedImage = nil
                        camera.isSaved = false
                    } else {
                        camera.reTake()
                    }
                }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                })
                .padding(.leading, 25)
                .transition(.move(edge: .leading))
            }
            Spacer()
        }
    }

    private func bottomBar() -> some View {
        HStack {
            if camera.isTaken || selectedImage != nil {
                Button(action: {
                    if !camera.isSaved {
                        if let imageToSave = selectedImage {
                            saveImage(imageToSave, camera: camera)
                        } else {
                            camera.savePic { success in
                                if success {
                                    showSaveAlert = true
                                }
                            }
                        }
                    }
                }, label: {
                    HStack {
                        Image(systemName: camera.isSaved ? "checkmark.circle" : "square.and.arrow.down")
                            .foregroundColor(.black)
                        Text(camera.isSaved ? "Guardada" : "Guardar")
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color.white)
                    .clipShape(Capsule())
                })
                .padding(.leading, 25)
                
                Button(action: {
                    // Placeholder for scan functionality
                }, label: {
                    HStack {
                        Image(systemName: "doc.text.viewfinder")
                            .foregroundColor(.black)
                        Text("Escanear")
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color.white)
                    .clipShape(Capsule())
                })
                .padding(.leading, 10)
                
                Spacer()
            } else {
                Button(action: camera.takePic, label: {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 65, height: 65)
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 75, height: 75)
                    }
                })
                
                Button(action: {
                    showPhotoPicker = true
                }, label: {
                    Image(systemName: "photo.on.rectangle")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                })
                .padding(.leading)
                .sheet(isPresented: $showPhotoPicker) {
                    PhotoPicker(selectedImage: $selectedImage, isPresented: $showPhotoPicker)
                }
            }
        }
        .frame(height: 75)
    }

    func saveImage(_ image: UIImage, camera: CamModel) {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            if status == .authorized || status == .limited {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }) { success, error in
                    DispatchQueue.main.async {
                        if success {
                            camera.isSaved = true
                            print("Selected image saved successfully...")
                        } else {
                            camera.alert = true
                            print("Error saving selected image: \(error?.localizedDescription ?? "Unknown error")")
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    camera.alert = true
                }
            }
        }
    }
}
