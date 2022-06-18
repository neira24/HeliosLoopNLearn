//
//  WorkspaceViewController.swift
//  HeliosLoopNLearn
//
//  Created by Lauri Roomere on 18.06.2022.
//

import Foundation
import UIKit
import DSWaveformImage

class WorkspaceViewController : UIViewController {

   
    @IBOutlet var WaveformImageView: UIImageView!

    override func viewDidLoad(){
        super.viewDidLoad()
        // Do any additional setup after loading the view.

          DrawWaveForm()
        
    }
    //https://www.hackingwithswift.com/example-code/media/how-to-control-the-pitch-and-speed-of-audio-using-avaudioengine
    
    
    
    func updateProgressWaveform(_ progress: Double) {
        sleep(1000)
        let fullRect = WaveformImageView.bounds
        let newWidth = Double(fullRect.size.width) * progress

        let maskLayer = CAShapeLayer()
        let maskRect = CGRect(x: 0.0, y: 0.0, width: newWidth, height: Double(fullRect.size.height))

        let path = CGPath(rect: maskRect, transform: nil)
        maskLayer.path = path

        WaveformImageView.layer.mask = maskLayer
    }

    func DrawWaveForm(){
        let waveformImageDrawer = WaveformImageDrawer()
        
        let audioURL = URL.init(string:"https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")!
        
        let task = URLSession.shared.downloadTask(with: audioURL) { [self] downloadedURL, urlResponse, error in
            guard let downloadedURL = downloadedURL else { return }

            let cachesFolderURL = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let audioFileURL = cachesFolderURL!.appendingPathComponent("SoundHelix-Song-1.mp3")
            try? FileManager.default.copyItem(at: downloadedURL, to: audioFileURL)

     
                // need to jump back to main queue
                DispatchQueue.main.async {
           
                    waveformImageDrawer.waveformImage(fromAudioAt: audioFileURL, with: .init(
                        size: self.WaveformImageView.bounds.size,
                                                      style: .filled(UIColor.black),
                                                      position: .top)) { image in
                                                          
                    DispatchQueue.main.async {
                                                     self.WaveformImageView.image = image
                        
                        var prev = 0
                        for i in 1...1000{
                            prev = prev+10
                            updateProgressWaveform(Double(prev))
                        }
                    }
                }
            }
        }
            
            task.resume()
        }
}

