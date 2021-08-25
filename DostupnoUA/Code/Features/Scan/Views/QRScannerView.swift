//
//  QRScannerView.swift
//  DostupnoUA
//
//  Created by admin on 08.07.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit
import AVFoundation

/// Delegate callback for the QRScannerView.
protocol QRScannerViewDelegate: AnyObject {
    func qrScanningDidFail()
    func qrScanningSucceeded(with code: String)
    func qrScanningDidStop()
}

class QRScannerView: UIView {
    
    weak var delegate: QRScannerViewDelegate?
    var captureSession: AVCaptureSession?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    override var layer: CALayer {
        return super.layer as? AVCaptureVideoPreviewLayer ?? super.layer
    }
}

extension QRScannerView {
    
    var isRunning: Bool {
        return captureSession?.isRunning ?? false
    }
    
    func startScanning() {
       captureSession?.startRunning()
    }
    
    func stopScanning() {
        captureSession?.stopRunning()
        delegate?.qrScanningDidStop()
    }
    
    func initSetupIfNeeded() {
        if captureSession == nil {
            initSetup()
        }
    }
    
    private func initSetup() {
        clipsToBounds = true
        captureSession = AVCaptureSession()
        
        guard
            let videoCaptureDevice = AVCaptureDevice.default(for: .video),
            let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
            captureSession?.canAddInput(videoInput) == true
            else {
            scanningDidFail()
            return
        }
        
        captureSession?.addInput(videoInput)
        let metadataOutput = AVCaptureMetadataOutput()
        
        guard captureSession?.canAddOutput(metadataOutput) == true else {
            scanningDidFail()
            return
        }
        
        captureSession?.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr]
        if let layer = layer as? AVCaptureVideoPreviewLayer {
            layer.session = captureSession
            layer.videoGravity = .resizeAspectFill
        }
        captureSession?.startRunning()
    }
    
    func scanningDidFail() {
        captureSession?.stopRunning()
        delegate?.qrScanningDidFail()
        captureSession = nil
    }
    
    func found(code: String) {
        delegate?.qrScanningSucceeded(with: code)
    }
    
}

extension QRScannerView: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        
            guard
                let metadataObject = metadataObjects.first,
                let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                let stringValue = readableObject.stringValue
                else {
                    return
            }
        
            stopScanning()
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
    }
    
}
