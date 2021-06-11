//
//  VideoCapture.swift
//  CWKSemua
//
//  Created by Leo nardo on 07/06/21.
//

import Foundation
import AVFoundation
import UIKit
import Combine

typealias Frame = CMSampleBuffer
typealias FramePublisher = AnyPublisher<Frame, Never>

protocol VideoCaptureDelegate: AnyObject {
    func videoCapture(_ videoCapture: VideoCapture, didCreate framePublisher: FramePublisher)
}

class VideoCapture: NSObject {
    
    var delegate: VideoCaptureDelegate! {
        didSet { createVideoFramePublisher() }
    }
    
    var cameraPosition = AVCaptureDevice.Position.front {
        didSet { createVideoFramePublisher() }
    }
    
    var orientation = AVCaptureVideoOrientation.portrait {
        didSet { createVideoFramePublisher() }
    }
    
    var framePublisher: PassthroughSubject<Frame, Never>?
    let captureSession = AVCaptureSession()
    let videoCaptureQueue = DispatchQueue(label: "Video Capture Queue",
                                          qos: .userInitiated)
    var videoStabilizationEnabled = false
    
    /// A Boolean that indicates whether the video capture minimize camera shake.
//    private var videoStabilizationEnabled = false

    /// Changes the camera selection between the front- and back-facing cameras.
    func toggleCameraSelection() {
        cameraPosition = cameraPosition == .back ? .front : .back
    }

    /// Adjusts the video orientation to match the device's orientation.
    func updateDeviceOrientation() {
        let currentPhysicalOrientation = UIDevice.current.orientation

        switch currentPhysicalOrientation {

        case .portrait, .faceUp, .faceDown, .unknown:
            orientation = .portrait
        case .portraitUpsideDown:
            orientation = .portraitUpsideDown
        case .landscapeLeft:
            orientation = .landscapeRight
        case .landscapeRight:
            orientation = .landscapeLeft

        @unknown default:
            orientation = .portrait
        }
    }
    
    private func enableCaptureSession() {
        if !captureSession.isRunning { captureSession.startRunning() }
    }

    private func disableCaptureSession() {
        if captureSession.isRunning { captureSession.stopRunning() }
    }
    
}

extension VideoCapture: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput frame: Frame,
                       from connection: AVCaptureConnection) {

        // Forward the frame through the publisher.
        framePublisher?.send(frame)
    }
}

    extension VideoCapture {
        /// Creates a video frame publisher by starting or reconfiguring the
        /// video capture session.
        /// - Tag: createVideoFramePublisher
        private func createVideoFramePublisher() {
            // (Re)configure the capture session.
            guard let videoDataOutput = configureCaptureSession() else { return }

            // Create a new passthrough subject that publishes frames to subscribers.
            let passthroughSubject = PassthroughSubject<Frame, Never>()

            // Keep a reference to the publisher.
            framePublisher = passthroughSubject

            // Set the video capture as the video output's delegate.
            videoDataOutput.setSampleBufferDelegate(self, queue: videoCaptureQueue)

            // Create a generic publisher by type erasing the passthrough publisher.
            let genericFramePublisher = passthroughSubject.eraseToAnyPublisher()

            // Send the publisher to the `VideoCapture` instance's delegate.
            delegate.videoCapture(self, didCreate: genericFramePublisher)
        }

        /// Configures or reconfigures the session to the new camera settings.
        /// - Tag: configureCaptureSession
        private func configureCaptureSession() -> AVCaptureVideoDataOutput? {
            disableCaptureSession()

//            guard isEnabled else {
//                // Leave the camera disabled.
//                return nil
//            }

            // (Re)start the capture session after this method returns.
            defer { enableCaptureSession() }

            // Tell the capture session to start configuration.
            captureSession.beginConfiguration()

            // Finalize the configuration after this method returns.
            defer { captureSession.commitConfiguration() }

            // Set the video camera to run at the action classifier's frame rate.
            let modelFrameRate = 30.0

            let input = AVCaptureDeviceInput.createCameraInput(position: cameraPosition,
                                                               frameRate: modelFrameRate)

            let output = AVCaptureVideoDataOutput.withPixelFormatType(kCVPixelFormatType_32BGRA)

            let success = configureCaptureConnection(input, output)
            return success ? output : nil
        }

        /// Sets the connection's orientation, image mirroring, and video stabilization.
        /// - Tag: configureCaptureConnection
        private func configureCaptureConnection(_ input: AVCaptureDeviceInput?,
                                                _ output: AVCaptureVideoDataOutput?) -> Bool {

            guard let input = input else { return false }
            guard let output = output else { return false }

            // Clear inputs and outputs from the capture session.
            captureSession.inputs.forEach(captureSession.removeInput)
            captureSession.outputs.forEach(captureSession.removeOutput)

            guard captureSession.canAddInput(input) else {
                print("The camera input isn't compatible with the capture session.")
                return false
            }

            guard captureSession.canAddOutput(output) else {
                print("The video output isn't compatible with the capture session.")
                return false
            }

            // Add the input and output to the capture session.
            captureSession.addInput(input)
            captureSession.addOutput(output)

            // This capture session must only have one connection.
            guard captureSession.connections.count == 1 else {
                let count = captureSession.connections.count
                print("The capture session has \(count) connections instead of 1.")
                return false
            }

            // Configure the first, and only, connection.
            guard let connection = captureSession.connections.first else {
                print("Getting the first/only capture-session connection shouldn't fail.")
                return false
            }

            if connection.isVideoOrientationSupported {
                // Set the video capture's orientation to match that of the device.
                connection.videoOrientation = orientation
            }

//            if connection.isVideoMirroringSupported {
//                connection.isVideoMirrored = horizontalFlip
//            }

            if connection.isVideoStabilizationSupported {
                if videoStabilizationEnabled {
                    connection.preferredVideoStabilizationMode = .standard
                } else {
                    connection.preferredVideoStabilizationMode = .off
                }
            }

            // Discard newer frames if the app is busy with an earlier frame.
            output.alwaysDiscardsLateVideoFrames = true

            return true
        }
    }


