//
//  CamModel.swift
//  Tentzo-App
//
//  Created by Miranda Colorado Arróniz on 14/11/24.
//

import SwiftUI
import AVFoundation
import Photos

class CamModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCapturePhotoOutput()
    @Published var preview: AVCaptureVideoPreviewLayer!
    @Published var isSaved = false
    @Published var isPhotoFromCamera = false
    @Published var picData = Data(count: 0)
    
    func check() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { status in
                if status { self.setUp() }
                else { DispatchQueue.main.async { self.alert = true } }
            }
        case .denied, .restricted:
            DispatchQueue.main.async { self.alert = true }
        @unknown default: break
        }
    }
    
    func setUp() {
        do {
            session.beginConfiguration()
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
                print("No front camera available")
                return
            }
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) { session.addInput(input) }
            if session.canAddOutput(output) { session.addOutput(output) }
            session.commitConfiguration()
            DispatchQueue.global(qos: .background).async { self.session.startRunning() }
        } catch { print("Error during setup: \(error.localizedDescription)") }
    }
    
    func takePic() {
        DispatchQueue.global(qos: .background).async {
            if !self.session.isRunning { self.session.startRunning() }
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            self.output.capturePhoto(with: settings, delegate: self)
        }
    }
    
    func reTake() {
        DispatchQueue.main.async {
            withAnimation {
                self.isTaken = false
                self.isSaved = false
                self.isPhotoFromCamera = false
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        DispatchQueue.main.async {
            self.picData = imageData
            withAnimation { self.isTaken = true; self.isPhotoFromCamera = true }
        }
    }
    
    func savePic(completion: @escaping (Bool) -> Void) {
        guard !picData.isEmpty else { completion(false); return }
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        if status == .authorized || status == .limited { saveImageToPhotoLibrary(completion: completion) }
        else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
                if newStatus == .authorized || newStatus == .limited { self.saveImageToPhotoLibrary(completion: completion) }
                else { DispatchQueue.main.async { self.alert = true; completion(false) } }
            }
        } else { DispatchQueue.main.async { self.alert = true; completion(false) } }
    }
    
    private func saveImageToPhotoLibrary(completion: @escaping (Bool) -> Void) {
        guard let image = UIImage(data: picData) else { completion(false); return }
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { success, error in
            DispatchQueue.main.async { self.isSaved = success; completion(success) }
        }
    }
}
