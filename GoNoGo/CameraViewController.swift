//
//  CameraViewController.swift
//  GoNoGo
//
//  Created by Jeel on 7/24/16.
//  Copyright © 2016 Ismael. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    @IBOutlet var LiveView: UIView!

 //   @IBOutlet weak var ImageView: UIImageView!
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.captureSession = AVCaptureSession()
        self.stillImageOutput = AVCaptureStillImageOutput()
       
        
        if let sio  = self.stillImageOutput{
            sio.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            self.captureSession?.addOutput(sio)
        }
       
        self.captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    
        
        
        do{
         let input = try  AVCaptureDeviceInput(device: backCamera)
        
            if  let canAdd = self.captureSession?.canAddInput(input)
            {
                if canAdd
                {
                    self.captureSession?.addInput(input)
                }
            }
        }catch
        {
            
        }
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.LiveView.layer.addSublayer(self.previewLayer!)
        self.previewLayer!.frame = self.LiveView.bounds
        self.captureSession?.startRunning()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Capture(sender: UIButton) {
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
