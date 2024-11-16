//
//  Camera.swift
//  Tentzo-App
//
//  Created by Miranda Colorado Arróniz on 14/11/24.
//

import SwiftUI
import Photos
import Foundation
import AVFoundation

struct PlantIdentificationResponse: Codable {
    struct Result: Codable {
        struct Classification: Codable {
            struct Suggestion: Codable {
                let name: String
            }
            let suggestions: [Suggestion]
        }
        let classification: Classification
    }
    let result: Result
}

class PlantIdentificationService: ObservableObject {
    @Published var identifiedPlantName: String?
    @Published var error: String?
    
    func identifyPlant(imageBase64: String, latitude: Double? = nil, longitude: Double? = nil, apiKey: String) {
        let url = URL(string: "https://plant.id/api/v3/identification")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(apiKey, forHTTPHeaderField: "Api-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Prepare request body
        var bodyDict: [String: Any] = [
            "images": ["data:image/jpg;base64,\(imageBase64)"],
            "similar_images": true
        ]
        
        if let latitude = latitude, let longitude = longitude {
            bodyDict["latitude"] = latitude
            bodyDict["longitude"] = longitude
        }
        
        // Convert dictionary to JSON data
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: bodyDict)
        } catch {
            DispatchQueue.main.async {
                self.error = "Error preparing request: \(error.localizedDescription)"
            }
            return
        }
        
        // Make the network request
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.error = "Network error: \(error.localizedDescription)"
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                DispatchQueue.main.async {
                    self?.error = "Invalid response"
                }
                return
            }
            
            print("HTTP Status Code: \(httpResponse.statusCode)")
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("Server error: \(httpResponse.statusCode)")
                if let data = data,
                   let errorJson = try? JSONSerialization.jsonObject(with: data) {
                    print("Error Response: \(errorJson)")
                }
                DispatchQueue.main.async {
                    self?.error = "Server error: \(httpResponse.statusCode)"
                }
                return
            }
            
            guard let data = data else {
                print("No data received")
                DispatchQueue.main.async {
                    self?.error = "No data received"
                }
                return
            }
            
            // Print raw response data
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw API Response:")
                print(jsonString)
            }
            
            // Pretty print the JSON response
            if let jsonObject = try? JSONSerialization.jsonObject(with: data),
               let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
               let prettyString = String(data: prettyData, encoding: .utf8) {
                print("\nFormatted API Response:")
                print(prettyString)
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(PlantIdentificationResponse.self, from: data)
                
                if let firstSuggestion = response.result.classification.suggestions.first {
                    print("\nFirst Plant Suggestion: \(firstSuggestion.name)")
                    DispatchQueue.main.async {
                        self?.identifiedPlantName = firstSuggestion.name
                    }
                } else {
                    print("No plant suggestions found in the response")
                    DispatchQueue.main.async {
                        self?.error = "No plant suggestions found"
                    }
                }
                
                // Print all suggestions
                print("\nAll Suggestions:")
                response.result.classification.suggestions.forEach { suggestion in
                    print("- \(suggestion.name)")
                }
                
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                print("JSON Decoding Error Details: \(error)")
                DispatchQueue.main.async {
                    self?.error = "Decoding error: \(error.localizedDescription)"
                }
            }
        }
        
        task.resume()
    }
}

struct Camera: View {
    @StateObject var camera = CamModel()
    @StateObject private var plantService = PlantIdentificationService()
    @State private var showSaveAlert = false
    @State private var showPhotoPicker = false
    @State private var selectedImage: UIImage?
    @State private var showPlantAlert = false
    let customGreen = Color(red: 83/255, green: 135/255, blue: 87/255)

    
    // API Key for Plant.id service
    private let apiKey = "0B3G3gYo0gziMjliprpRFc5XVB2EbG9swngse8W4ZbnKOdNUOu" // Replace with your actual API key
    
    private let cameraFrameHeight: CGFloat = 805
    
    // Function to convert UIImage to Base64 string
    func convertImageToBase64(_ image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return nil }
        return imageData.base64EncodedString()
    }
    
    // Function to convert Data to Base64 string
    func convertDataToBase64(_ data: Data) -> String {
        return data.base64EncodedString()
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack {
                    CameraPreview(camera: camera)
                        .frame(width: geometry.size.width, height: cameraFrameHeight)
                        .clipped()
                        .opacity((camera.isTaken || selectedImage != nil) ? 0 : 1)
                        .ignoresSafeArea(edges: .top)
                    
                    if camera.isTaken && selectedImage == nil {
                        ImageView(imageData: camera.picData)
                            .frame(width: geometry.size.width, height: cameraFrameHeight)
                            .clipped()
                            .transition(.opacity)
                            .opacity(camera.isTaken ? 1 : 0)
                            .ignoresSafeArea(edges: .top)
                    }
                    
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: cameraFrameHeight)
                            .clipped()
                            .transition(.opacity)
                            .opacity(selectedImage != nil ? 1 : 0)
                            .ignoresSafeArea(edges: .top)
                    }
                }
                .frame(width: geometry.size.width, height: cameraFrameHeight, alignment: .top)
                .position(x: geometry.size.width / 2, y: cameraFrameHeight / 2)
                
                // Plant Identification Results
                if let plantName = plantService.identifiedPlantName {
                    Text("Especie Identificada: \(plantName)")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(red: 83/255, green: 135/255, blue: 87/255))
                        .cornerRadius(10)
                        .padding(.top, 20)
                    
                } else if let error = plantService.error {
                    Text("Error: \(error)")
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.top, 20)
                }
                
                Spacer()
                
                bottomBar()
                    .frame(height: 75)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
            .ignoresSafeArea(edges: .top)
            .overlay(
                topBar()
                    .frame(width: geometry.size.width, alignment: .leading)
                    .padding(.top, 20)
                , alignment: .top
            )
            .onAppear {
                camera.check()
            }
            .alert(isPresented: $camera.alert) {
                Alert(
                    title: Text("Permission Denied"),
                    message: Text("Please allow access to the camera and photo library in settings."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func topBar() -> some View {
        HStack {
            if camera.isTaken || selectedImage != nil {
                Button(action: {
                    if selectedImage != nil {
                        selectedImage = nil
                        camera.isSaved = false
                        plantService.identifiedPlantName = nil
                        plantService.error = nil
                    } else {
                        camera.reTake()
                        plantService.identifiedPlantName = nil
                        plantService.error = nil
                    }
                }, label: {
                    Image(systemName: "chevron.left.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40) // Adjust size as needed
                        .foregroundColor(.white)
                        .padding()
                        .clipShape(Circle())

                })
                .padding(.leading, 8)
                .transition(.move(edge: .leading))
            }
            Spacer()
        }
    }
    
    
    private func bottomBar() -> some View {
        HStack {
            if selectedImage != nil {
                Button(action: {
                    if let image = selectedImage,
                       let base64String = convertImageToBase64(image) {
                        plantService.identifyPlant(imageBase64: base64String, apiKey: apiKey)
                        showPlantAlert = true
                    }
                }, label: {
                    HStack {
                        Image(systemName: "qrcode.viewfinder")
                            .foregroundColor(.white)

                        Text("Identificar")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .cornerRadius(10)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .foregroundColor(.white)
                    .background(Color(red: 83/255, green: 135/255, blue: 87/255))
                })
                .clipShape(Capsule())
                .padding(.top, 50)
                .padding(.leading, 25)
                
                Spacer()
            } else if camera.isTaken && camera.isPhotoFromCamera {
                Button(action: {
                    if !camera.isSaved {
                        camera.savePic { success in
                            if success {
                                showSaveAlert = true
                            }
                        }
                    }
                }, label: {
                    HStack {
                        Image(systemName: camera.isSaved ? "checkmark.circle" : "square.and.arrow.down")
                            .foregroundColor(.white)
                        Text(camera.isSaved ? "Guardada" : "Guardar")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(customGreen)
                    .clipShape(Capsule())
                })
                .padding(.leading, 25)
                .padding(.top, 50)
                
                Button(action: {
                    let base64String = convertDataToBase64(camera.picData)
                    plantService.identifyPlant(imageBase64: base64String, apiKey: apiKey)
                    showPlantAlert = true
                }, label: {
                    HStack {
                        Image(systemName: "qrcode.viewfinder")
                            .foregroundColor(.white)
                        Text("Identificar")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .cornerRadius(10)
                            .background(Color(red: 83/255, green: 135/255, blue: 87/255))
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(customGreen)
                    .foregroundColor(.white)
                })
                .clipShape(Capsule())
                .padding(.leading, 10)
                .padding(.top, 50)
                
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
                        .foregroundColor(.white)
                        .padding()
                        .background(customGreen)
                        .clipShape(Circle())
                })
                .padding(.leading)
                .sheet(isPresented: $showPhotoPicker) {
                    PhotoPicker(selectedImage: $selectedImage, isPresented: $showPhotoPicker)
                        .onChange(of: selectedImage) { newImage in
                            if newImage != nil {
                                camera.isTaken = true
                                camera.isPhotoFromCamera = false
                                camera.isSaved = false
                            }
                        }
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

struct Camera_Previews: PreviewProvider {
    static var previews: some View {
        Camera()
    }
}
