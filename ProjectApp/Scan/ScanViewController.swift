//
//  ScanViewController.swift
//  ProjectApp
//
//  Created by Николай Рыбин on 29.03.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import UIKit

import AVFoundation
import Alamofire

class ScanViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var scanButton: UIButton!
    
    var imageOrientation: AVCaptureVideoOrientation?
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    
    var uuid: String?
    
    var isScanning: Bool = false
    
    @IBAction func scanQR(_ sender: UIButton) {
        
        if isScanning{
            TurnOffScanning()
        }else{
            TurnOnScaning()
        }
        view.bringSubviewToFront(scanButton)
    }
    
    func TurnOnScaning(){
        scanButton.setTitle("Отмена", for: .normal)
        view.layer.addSublayer(videoPreviewLayer!)
        captureSession?.startRunning()
        isScanning = true
    }
    
    func TurnOffScanning(){
        scanButton.setTitle("Сканировать", for: .normal)
        videoPreviewLayer!.removeFromSuperlayer()
        captureSession?.stopRunning()
        isScanning = false
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanButton.setTitleColor(scanButton.currentTitleColor.withAlphaComponent(0.5), for: .highlighted)
        scanButton.layer.cornerRadius = 30
        connectCamera()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
         TurnOffScanning()
    }
    
    func connectCamera(){
        // Get an instance of the AVCaptureDevice class to initialize a
        // device object and provide the video as the media type parameter
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("No video device found")
        }
        // handler chiamato quando viene cambiato orientamento
        self.imageOrientation = AVCaptureVideoOrientation.portrait
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous deivce object
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session
            captureSession?.addInput(input)
            
            // Get an instance of ACCapturePhotoOutput class
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
            
            // Set the output on the capture session
            captureSession?.addOutput(capturePhotoOutput!)
            captureSession?.sessionPreset = .high
            
            // Initialize a AVCaptureMetadataOutput object and set it as the input device
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            //Initialise the video preview layer and add it as a sublayer to the viewPreview view's layer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            videoPreviewLayer?.cornerRadius = 20
            //cameraView.layer.addSublayer(videoPreviewLayer!)
            
            //start video capture
            
            
        } catch {
            //If any error occurs, simply print it out
            print(error)
            return
        }
    }
    
    // Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        for device in discoverySession.devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "Show Guest Info" {
            let vc = segue.destination as! GuestInfoViewController
            vc.personUuid = uuid
        }
    }
    
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        
        // Check if the metadataObjects array is contains at least one object.
        if metadataObjects.count == 0 {
            return
        }
                
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            if let outputString = metadataObj.stringValue {
                DispatchQueue.main.async {
                    self.uuid = outputString
                    self.performSegue(withIdentifier: "Show Guest Info", sender: nil)
                    self.TurnOffScanning()
                }
            }
        }
    }
}
