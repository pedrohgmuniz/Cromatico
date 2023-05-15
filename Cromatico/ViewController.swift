//
//  ViewController.swift
//  Cromatico
//
//  Created by Pedro Muniz on 15/05/23.
//
// AVFoundation is needed for us to be able to access the camera

import UIKit
import SwiftUI
import AVFoundation

// The following class is going to contain all the logic to present the feed on the screen.
// It has two main tasks: 1. It checks if the app has permission to use the camera;
// 2. If it does, it sets up a capture session to present the camera feed.

// We start creating the Controller by defining some variables
class ViewController: UIViewController {
    private var permissionGranted = false // Handles the controll flow (if the app has permission or not)
    private let captureSession = AVCaptureSession() // These two are responsible for accessing the camera
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private var previewLayer = AVCaptureVideoPreviewLayer() // These two present the camera feed
    var screenRect: CGRect! = nil // For View dimension

    // Override the viewDidLoad method to check for cam permission and start cam session:
    override func viewDidLoad() {
        checkPermission()

        sessionQueue.async { [unowned self] in
            guard permissionGranted else { return }
            self.setupCaptureSession()
            self.captureSession.startRunning()
        }
    }

    // We create the func below in case the user changes the phone's position
    // from portrait to landscape and vice versa and the feed doesn't break
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        screenRect = UIScreen.main.bounds
        self.previewLayer.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)

        switch UIDevice.current.orientation {
            // Home button at the top
        case UIDeviceOrientation.portraitUpsideDown:
            self.previewLayer.connection?.videoOrientation = .portraitUpsideDown
            // Home button on the right
        case UIDeviceOrientation.landscapeLeft:
            self.previewLayer.connection?.videoOrientation = .landscapeRight
            // Home button on the left
        case UIDeviceOrientation.landscapeRight:
            self.previewLayer.connection?.videoOrientation = .landscapeLeft
            // Home button at the bottom
        case UIDeviceOrientation.portrait:
            self.previewLayer.connection?.videoOrientation = .portrait
        default:
            break
        }
    }

    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {

        case .authorized:
            permissionGranted = true

        case .notDetermined:
            requestPermission()

        default:
            permissionGranted = false
        }
    }

    // In case the user has not given permission before, we prompt them to do so:
    func requestPermission() {
        sessionQueue.suspend() // Checking permission is async, so we suspend the session til we've made the request
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { [unowned self] granted in
            self.permissionGranted = granted
            self.sessionQueue.resume() // The session is configured only once the decision's been made
        })
    } // The requestPermission func can be seen as a permission handler

    // The captureSession lets us access devices just as camera and provide data for other objects,
    // such as the previewLayer, in our case
    func setupCaptureSession() {
        guard let videoDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }

        guard captureSession.canAddInput(videoDeviceInput) else { return }
        captureSession.addInput(videoDeviceInput)

        // Below the preview layer.
        screenRect = UIScreen.main.bounds // We save here the screen dimensions to use them for the frame

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill

        previewLayer.connection?.videoOrientation = .portrait

        // All of this setup is handled on our session queue. Since updates to the UI must be on the main queue,
        // we add our previewLayer to the main queue:
        DispatchQueue.main.async { [weak self] in
            self?.view.layer.addSublayer(self!.previewLayer)
        }
    }

}

// In order to add the ViewController above to SwiftUI, we need to create a UIControllerRepresentable,
// which wraps the ViewController in a SwiftUI view.
// It returns the content of that ViewController as a View that is here called ViewController():
struct HostedViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return ViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}
