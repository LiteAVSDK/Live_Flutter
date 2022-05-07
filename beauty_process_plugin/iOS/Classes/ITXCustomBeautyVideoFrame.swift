//
//  ITXCustomBeautyVideoFrame.swift
//  live_flutter_plugin
//
//  Created by adams on 2022/4/25.
//

import Foundation
import TXLiteAVSDK_Live

public enum ITXCustomBeautyBufferType: Int {
    case Unknown = 0
    case PixelBuffer = 1
    case Data = 2
    case Texture = 3
    
    public func convertV2LiveBufferType() -> V2TXLiveBufferType {
        switch self {
        case .Unknown:
            return .unknown
        case .PixelBuffer:
            return .pixelBuffer
        case .Data:
            return .nsData
        case .Texture:
            return .texture
        }
    }
    
    public func convertTRTCBufferType() -> TRTCVideoBufferType {
        switch self {
        case .Unknown:
            return .unknown
        case .PixelBuffer:
            return .pixelBuffer
        case .Data:
            return .nsData
        case .Texture:
            return .texture
        }
    }
}

public enum ITXCustomBeautyPixelFormat: Int {
    case Unknown = 0
    case I420 = 1
    case Texture2D = 2
    case BGRA = 3
    case NV12 = 4
    
    public func convertV2LivePixelFormat() -> V2TXLivePixelFormat {
        switch self {
        case .Unknown:
            return .unknown
        case .I420:
            return .I420
        case .Texture2D:
            return .texture2D
        case .BGRA:
            return .BGRA32
        case .NV12:
            return .NV12
        }
    }
    
    public func convertTRTCPixelFormat() -> TRTCVideoPixelFormat {
        switch self {
        case .Unknown:
            return ._Unknown
        case .I420:
            return ._I420
        case .Texture2D:
            return ._Texture_2D
        case .BGRA:
            return ._32BGRA
        case .NV12:
            return ._NV12
        }
    }
}

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
    public var width: UInt

    /// 【字段含义】视频高度
    public var height: UInt

    /// 【字段含义】视频帧的顺时针旋转角度
    public var rotation: ITXCustomBeautyRotation

    /// 【字段含义】视频纹理ID
    public var textureId: GLuint
    
    ///【字段含义】视频帧的时间戳，单位毫秒
    public var timestamp: UInt64
    
    public init(v2VideoFrame: V2TXLiveVideoFrame) {
        data = v2VideoFrame.data
        pixelBuffer = v2VideoFrame.pixelBuffer
        width = v2VideoFrame.width
        height = v2VideoFrame.height
        textureId = v2VideoFrame.textureId
        rotation = ITXCustomBeautyRotation(rawValue: v2VideoFrame.rotation.rawValue) ?? .rotation_0
        pixelFormat = ITXCustomBeautyPixelFormat(rawValue: v2VideoFrame.pixelFormat.rawValue) ?? nil
        bufferType = ITXCustomBeautyBufferType(rawValue: v2VideoFrame.bufferType.rawValue) ?? nil
        timestamp = 0
        super.init()
    }
    
    public init(trtcVideoFrame: TRTCVideoFrame) {
        data = trtcVideoFrame.data
        pixelBuffer = trtcVideoFrame.pixelBuffer
        width = UInt(trtcVideoFrame.width)
        height = UInt(trtcVideoFrame.height)
        textureId = trtcVideoFrame.textureId
        rotation = ITXCustomBeautyRotation(rawValue: trtcVideoFrame.rotation.rawValue) ?? .rotation_0
        switch trtcVideoFrame.pixelFormat {
        case ._Unknown:
            pixelFormat = .Unknown
        case ._I420:
            pixelFormat = .I420
        case ._Texture_2D:
            pixelFormat = .Texture2D
        case ._32BGRA:
            pixelFormat = .BGRA
        case ._NV12:
            pixelFormat = .NV12
        default:
            pixelFormat = .Unknown
        }
        bufferType = ITXCustomBeautyBufferType(rawValue: trtcVideoFrame.bufferType.rawValue) ?? .Unknown
        timestamp = trtcVideoFrame.timestamp
        super.init()
    }

}
