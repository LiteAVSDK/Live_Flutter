import UIKit
import Flutter
import live_flutter_plugin
import TXCustomBeautyProcesserPlugin

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        lazy var customBeautyInstance: TRTCVideoCustomPreprocessor = {
            let customBeautyInstance = TRTCVideoCustomPreprocessor()
            customBeautyInstance.brightness = 0.5
            return customBeautyInstance
        }()
        
        GeneratedPluginRegistrant.register(with: self)
        TXLivePluginManager.register(customBeautyProcesserFactory: customBeautyInstance)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

extension TRTCVideoCustomPreprocessor: ITXCustomBeautyProcesserFactory {
    public func createCustomBeautyProcesser() -> ITXCustomBeautyProcesser {
        return self
    }
    
    public func destroyCustomBeautyProcesser() {
        invalidateBindedTexture()
    }
}

extension TRTCVideoCustomPreprocessor: ITXCustomBeautyProcesser {
    public func getSupportedPixelFormat() -> ITXCustomBeautyPixelFormat {
        return .Texture2D
    }
    
    public func getSupportedBufferType() -> ITXCustomBeautyBufferType {
        return .Texture
    }
    
    public func onProcessVideoFrame(srcFrame: ITXCustomBeautyVideoFrame, dstFrame: ITXCustomBeautyVideoFrame) -> ITXCustomBeautyVideoFrame {
        let outPutTextureId = processTexture(srcFrame.textureId, width: UInt32(srcFrame.width), height: UInt32(srcFrame.height))
        dstFrame.textureId = outPutTextureId
        return dstFrame
    }
}
