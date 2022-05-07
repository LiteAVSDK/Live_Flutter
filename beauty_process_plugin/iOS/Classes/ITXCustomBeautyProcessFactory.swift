//
//  ITXCustomBeautyProcessFactory.swift
//  live_flutter_plugin
//
//  Created by adams on 2022/4/29.
//

import UIKit

public protocol ITXCustomBeautyProcessFactory: NSObject {
    /// 创建美颜实例
    func createBeautyInstance() -> ITXCustomBeautyProcesser
    
    /// 销毁美颜实例
    func destroyBeautyInstance()
}

public protocol ITXCustomBeautyProcesser: NSObject {
    /// 获取第三方美颜 PixelFormat
    func getSupportedPixelFormat() -> ITXCustomBeautyPixelFormat
    
    /// 获取第三方美颜 BufferType
    func getSupportedBufferType() -> ITXCustomBeautyBufferType
    
    /// 回调NativeSDK视频自定义处理
    /// - Returns: 返回经过第三方美颜SDK处理后的视频帧对象
    func onProcessVideoFrame(srcFrame: ITXCustomBeautyVideoFrame, dstFrame: ITXCustomBeautyVideoFrame) -> ITXCustomBeautyVideoFrame
}
