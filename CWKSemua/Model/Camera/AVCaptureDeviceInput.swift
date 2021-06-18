//
//  AVCaptureDeviceInput.swift
//  CWKSemua
//
//  Created by Leo nardo on 11/06/21.
//
import AVFoundation

extension AVCaptureDeviceInput {
    /// Creates a camera input set at the configuration's frame rate.
    /// - Tag: createCameraInput
    static func createCameraInput(position: AVCaptureDevice.Position,
                                  frameRate: Double) -> AVCaptureDeviceInput? {
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: AVMediaType.video,
                                                   position: position) else {
            return nil
        }

        guard camera.configureFrameRate(frameRate) else { return nil }

        do {
            let cameraInput = try AVCaptureDeviceInput(device: camera)

            return cameraInput
        } catch {
            print("Unable to create an input from the camera: \(error)")
            return nil
        }
    }
}
