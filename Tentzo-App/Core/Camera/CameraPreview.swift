//
//  CameraPreview.swift
//  Tentzo-App
//
//  Created by Miranda Colorado Arróniz on 14/11/24.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera: CamModel

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.bounds
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
