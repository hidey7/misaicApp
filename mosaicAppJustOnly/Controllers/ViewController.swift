//
//  ViewController.swift
//  mosaicAppJustOnly



import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var imageView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        imageView.image = NSImage(named: "image")
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        //ここに画像処理を入れれば良さそう
        //リアルタイムで処理させたら動き遅くなる？→とりあえずやってみる
        print(event.locationInWindow)
    }


}

