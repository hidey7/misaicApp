//
//  ViewController.swift
//  mosaicAppJustOnly



import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var imageView: NSImageView!
    
    let mosaicView = MosaicView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        mosaicView.frame = self.view.frame
        mosaicView.image = NSImage(named: "image")
        self.view = mosaicView
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
//    override func mouseDragged(with event: NSEvent) {
//        //ここに画像処理を入れれば良さそう
//        //リアルタイムで処理させたら動き遅くなる？→とりあえずやってみる
//        
//        guard let ciImage = CIImage(data: self.imageView.image!.tiffRepresentation!) else {
//            print("Failed to convert ")
//            return
//        }
//        
//        let filter = CIFilter(name: "CIPixellate")
//        filter?.setValue(ciImage, forKey: kCIInputImageKey)
//        
//        let mosaicSize: CGFloat = 20 //モザイクのサイズを調整 値が小さいほどモザイクのサイズが大きくなる
//        filter?.setValue(mosaicSize, forKey: kCIInputScaleKey)
//        
//        guard let outputCIImage = filter?.outputImage else {
//            print("Failed to get output CIImage.")
//            return
//        }
//        
//        let context = CIContext(options: nil)
//        guard let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {
//            print("Failed to create CGImage.")
//            return
//        }
//        
//        let mosaicImage = NSImage(cgImage: cgImage, size: self.imageView.image!.size)
//        
//        self.imageView.image = mosaicImage
//        
////        print(event.locationInWindow)
//    }


}

