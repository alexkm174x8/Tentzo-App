func savePic() {
    guard !self.picData.isEmpty else {
        print("Error: No image data to save")
        return
    }
    
    guard let image = UIImage(data: self.picData) else {
        print("Error: Could not create image from data")
        return
    }
    
    PHPhotoLibrary.requestAuthorization { status in
        switch status {
        case .authorized:
            // Save the image to the photo library
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }, completionHandler: { success, error in
                if let error = error {
                    print("Error saving photo: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        self.isSaved = true
                        print("Photo saved successfully.")
                    }
                }
            })
        case .denied, .restricted:
            print("Permission to access photo library denied.")
            DispatchQueue.main.async {
                self.alert = true
            }
        case .notDetermined:
            // This should not happen as we've just requested authorization
            break
        @unknown default:
            break
        }
    }
}

