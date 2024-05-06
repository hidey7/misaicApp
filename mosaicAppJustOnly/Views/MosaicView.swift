import Cocoa

class MosaicView: NSView {
    var startPoint: NSPoint?
    var endPoint: NSPoint?
    var image: NSImage?
    var mosaicImage: NSImage?
    var mosaicRect: NSRect?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        image?.draw(in: bounds)
        NSColor.red.setStroke()
        if let start = startPoint, let end = endPoint {
            let rect = NSRect(x: min(start.x, end.x),
                              y: min(start.y, end.y),
                              width: abs(start.x - end.x),
                              height: abs(start.y - end.y))
            NSBezierPath(rect: rect).stroke()
        }
        
        // モザイク処理された画像を描画
        if let mosaicImage = mosaicImage {
            mosaicImage.draw(at: mosaicRect!.origin, from: NSRect(origin: .zero, size: mosaicImage.size), operation: .sourceOver, fraction: 1.0)
        }
    }

    
    override func mouseDown(with event: NSEvent) {
        startPoint = convert(event.locationInWindow, from: nil)
    }
    
    override func mouseDragged(with event: NSEvent) {
        endPoint = convert(event.locationInWindow, from: nil)
        needsDisplay = true
    }
    
    override func mouseUp(with event: NSEvent) {
        endPoint = convert(event.locationInWindow, from: nil)
        applyMosaic()
        startPoint = nil
        endPoint = nil
        needsDisplay = true
        print(#function)
    }
    

    
    func applyMosaic() {
        guard let image = image, let start = startPoint, let end = endPoint else { return }

        let rect = NSRect(x: min(start.x, end.x),
                          y: min(start.y, end.y),
                          width: abs(start.x - end.x),
                          height: abs(start.y - end.y))
        self.mosaicRect = rect
        // 範囲を切り抜く
        guard let croppedImage = cropImage(image, toRect: rect) else {
            print("Failed to crop the image.")
            return
        }

        // モザイク処理を適用
        let mosaicSize: CGFloat = 50 // モザイクのサイズを調整
        guard let mosaicImage = applyMosaicFilter(to: croppedImage, mosaicSize: mosaicSize) else {
            print("Failed to apply mosaic filter.")
            return
        }
        
        // モザイク処理が適用された画像をログに出力
        if let cgMosaicImage = mosaicImage.cgImage(forProposedRect: nil, context: nil, hints: nil) {
            print("Mosaic image: \(cgMosaicImage)")
        } else {
            print("Failed to get CGImage of mosaic image.")
        }

        // 元の画像にモザイク処理された画像を重ねて描画
        mosaicImage.draw(at: rect.origin, from: NSRect(origin: .zero, size: mosaicImage.size), operation: .sourceOver, fraction: 1.0)

        // startPoint と endPoint をリセット
        startPoint = nil
        endPoint = nil
        
        self.mosaicImage = mosaicImage
    }



    
    func applyMosaicFilter(to image: NSImage, mosaicSize: CGFloat) -> NSImage? {
        
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            print("Failed to get CGImage.")
            return nil
        }
        
        let ciImage = CIImage(cgImage: cgImage)
        
        // モザイクフィルターの作成
        guard let filter = CIFilter(name: "CIPixellate") else {
            print("Failed to create CIFilter.")
            return nil
        }
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(mosaicSize, forKey: kCIInputScaleKey)
        
        // フィルターを適用して処理された画像を取得
        guard let outputCIImage = filter.outputImage else {
            print("Failed to get output CIImage.")
            return nil
        }
        
        // CIContextを使用して処理されたCIImageをNSImageに変換
        let context = CIContext(options: nil)
        guard let cgImageOutput = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {
            print("Failed to create CGImage from output CIImage.")
            return nil
        }
        
        return NSImage(cgImage: cgImageOutput, size: image.size)
        
    }
    
    func cropImage(_ image: NSImage, toRect rect: NSRect) -> NSImage? {
        let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)
        let croppedCGImage = cgImage?.cropping(to: rect)
        return NSImage(cgImage: croppedCGImage!, size: rect.size)
    }
}

