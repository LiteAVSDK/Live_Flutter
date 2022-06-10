//
//  ITXCustomBeautyVideoFrame.swift
//  live_flutter_plugin
//
//  Created by adams on 2022/4/25.
//

import Foundation
import TXLiteAVSDK_Live

@objc public enum ITXCustomBeautyBufferType: Int {
    case Unknown = 0
    case PixelBuffer = 1
    case Data = 2
    case Texture = 3
}

@objc public enum ITXCustomBeautyPixelFormat: Int {
    case Unknown = 0
    case I420 = 1
    case Texture2D = 2
    case BGRA = 3
    case NV12 = 4
}

@objcMembers
public class ITXCustomBeautyVideoFrame: NSObject {
    
    public enum ITXCustomBeautyRotation: Int {
        case rotation_0 = 0
        case rotation_90 = 1
        case rotation_180 = 2
        case rotation_270 = 3
    }
    
    /// 【字段含义】视频帧像素格式
    public var pixelFormat: ITXCustomBeautyPixelFormat?

    /// 【字段含义】视频数据包装格式
    public var bufferType: ITXCustomBeautyBufferType?

    /// 【字段含义】bufferType 为 Data 时的视频数据
    public var data: Data?

    /// 【字段含义】bufferType 为 PixelBuffer 时的视频数据
    public var pixelBuffer: CVPixelBuffer?

    /// 【字段含义】视频宽度
    public var width: UInt = 0

    /// 【字段含义】视频高度
    public var height: UInt = 0

    /// 【字段含义】视频帧的顺时针旋转角度
    public var rotation: ITXCustomBeautyRotation = .rotation_0

    /// 【字段含义】视频纹理ID
    public var textureId: GLuint = 0
    
    ///【字段含义】视频帧的时间戳，单位毫秒
    public var timestamp: UInt64 = 0

}
