//
//  VideoCapture.swift
//  CWKSemua
//
//  Created by Leo nardo on 07/06/21.
//

import Foundation
import AVFoundation

class VideoCapture: NSObject {
    let captureSession = AVCaptureSession()
    let videoOutput = AVCaptureVideoDataOutput()
    
    
    override init() {
        super.init()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video),
              //              let cameraPosition = AVCaptureDevice.Position.front,
              let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            return
        }
        
        
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        captureSession.addInput(input)
        
        captureSession.addOutput(videoOutput)
        videoOutput.alwaysDiscardsLateVideoFrames = true
    }
    
    func startCaptureSession(){
        captureSession.startRunning()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoDispatchQueue"))
    }
}

extension VideoCapture: AVCaptureVideoDataOutputSampleBufferDelegate {
//
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let videoData = sampleBuffer
        print(videoData)

    }
}



