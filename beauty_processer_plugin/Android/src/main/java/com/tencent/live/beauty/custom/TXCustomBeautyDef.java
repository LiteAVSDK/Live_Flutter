package com.tencent.live.beauty.custom;

import com.tencent.live2.V2TXLiveDef;
import com.tencent.trtc.TRTCCloudDef;

import java.nio.ByteBuffer;

import javax.microedition.khronos.egl.EGLContext;

import static com.tencent.live2.V2TXLiveDef.V2TXLiveBufferType.V2TXLiveBufferTypeByteArray;
import static com.tencent.live2.V2TXLiveDef.V2TXLiveBufferType.V2TXLiveBufferTypeByteBuffer;
import static com.tencent.live2.V2TXLiveDef.V2TXLiveBufferType.V2TXLiveBufferTypeTexture;
import static com.tencent.live2.V2TXLiveDef.V2TXLiveBufferType.V2TXLiveBufferTypeUnknown;
import static com.tencent.live2.V2TXLiveDef.V2TXLivePixelFormat.V2TXLivePixelFormatI420;
import static com.tencent.live2.V2TXLiveDef.V2TXLivePixelFormat.V2TXLivePixelFormatTexture2D;
import static com.tencent.live2.V2TXLiveDef.V2TXLivePixelFormat.V2TXLivePixelFormatUnknown;
import static com.tencent.trtc.TRTCCloudDef.TRTC_VIDEO_BUFFER_TYPE_BYTE_ARRAY;
import static com.tencent.trtc.TRTCCloudDef.TRTC_VIDEO_BUFFER_TYPE_BYTE_BUFFER;
import static com.tencent.trtc.TRTCCloudDef.TRTC_VIDEO_BUFFER_TYPE_TEXTURE;
import static com.tencent.trtc.TRTCCloudDef.TRTC_VIDEO_BUFFER_TYPE_UNKNOWN;
import static com.tencent.trtc.TRTCCloudDef.TRTC_VIDEO_PIXEL_FORMAT_I420;
import static com.tencent.trtc.TRTCCloudDef.TRTC_VIDEO_PIXEL_FORMAT_Texture_2D;
import static com.tencent.trtc.TRTCCloudDef.TRTC_VIDEO_PIXEL_FORMAT_UNKNOWN;

public class TXCustomBeautyDef {

    public static enum TXCustomBeautyBufferType {
        TXCustomBeautyBufferTypeUnknown,
        TXCustomBeautyBufferTypeByteBuffer,
        TXCustomBeautyBufferTypeByteArray,
        TXCustomBeautyBufferTypeTexture;

        private TXCustomBeautyBufferType() {

        }

        public V2TXLiveDef.V2TXLiveBufferType convertV2LiveBufferType() {
            switch (this) {
                case TXCustomBeautyBufferTypeUnknown:
                    return V2TXLiveBufferTypeUnknown;
                case TXCustomBeautyBufferTypeByteBuffer:
                    return V2TXLiveBufferTypeByteBuffer;
                case TXCustomBeautyBufferTypeByteArray:
                    return V2TXLiveBufferTypeByteArray;
                case TXCustomBeautyBufferTypeTexture:
                    return V2TXLiveBufferTypeTexture;
                default:
                    return V2TXLiveBufferTypeUnknown;
            }
        }

        public int convertTRTCBufferType() {
            switch (this) {
                case TXCustomBeautyBufferTypeUnknown:
                    return TRTC_VIDEO_BUFFER_TYPE_UNKNOWN;
                case TXCustomBeautyBufferTypeByteBuffer:
                    return TRTC_VIDEO_BUFFER_TYPE_BYTE_BUFFER;
                case TXCustomBeautyBufferTypeByteArray:
                    return TRTC_VIDEO_BUFFER_TYPE_BYTE_ARRAY;
                case TXCustomBeautyBufferTypeTexture:
                    return TRTC_VIDEO_BUFFER_TYPE_TEXTURE;
                default:
                    return TRTC_VIDEO_BUFFER_TYPE_UNKNOWN;
            }
        }
    }

    public static enum TXCustomBeautyPixelFormat {

        TXCustomBeautyPixelFormatUnknown,
        TXCustomBeautyPixelFormatI420,
        TXCustomBeautyPixelFormatTexture2D;

        private TXCustomBeautyPixelFormat() {

        }

        public V2TXLiveDef.V2TXLivePixelFormat convertV2LivePixelFormat() {
            switch (this) {
                case TXCustomBeautyPixelFormatUnknown:
                    return V2TXLivePixelFormatUnknown;
                case TXCustomBeautyPixelFormatI420:
                    return V2TXLivePixelFormatI420;
                case TXCustomBeautyPixelFormatTexture2D:
                    return V2TXLivePixelFormatTexture2D;
                default:
                    return V2TXLivePixelFormatUnknown;
            }
        }

        public int convertTRTCPixelFormat() {
            switch (this) {
                case TXCustomBeautyPixelFormatUnknown:
                    return TRTC_VIDEO_PIXEL_FORMAT_UNKNOWN;
                case TXCustomBeautyPixelFormatI420:
                    return TRTC_VIDEO_PIXEL_FORMAT_I420;
                case TXCustomBeautyPixelFormatTexture2D:
                    return TRTC_VIDEO_PIXEL_FORMAT_Texture_2D;
                default:
                    return TRTC_VIDEO_PIXEL_FORMAT_UNKNOWN;
            }
        }
    }

    public static final class TXThirdTexture {
        public int textureId;
        public EGLContext eglContext10;
        public android.opengl.EGLContext eglContext14;

        public TXThirdTexture() {

        }
    }

    public static final class TXCustomBeautyVideoFrame {

        /// 【字段含义】视频帧像素格式
        public TXCustomBeautyPixelFormat pixelFormat;

        /// 【字段含义】视频数据包装格式
        public TXCustomBeautyBufferType bufferType;

        /// 【字段含义】bufferType 为 byte[] 时的视频数据
        public byte[] data;

        /// 【字段含义】bufferType 为 ByteBuffer 时的视频数据
        public ByteBuffer buffer;

        /// 【字段含义】视频宽度
        public int width;

        /// 【字段含义】视频高度
        public int height;

        /// 【字段含义】视频帧的顺时针旋转角度
        public int rotation;

        /// 【字段含义】视频纹理
        public TXThirdTexture texture;

        ///【字段含义】视频帧的时间戳，单位毫秒
        public long timestamp;

        /**
         * 基于 V2TXLiveVideoFrame 创建
         * @param frame
         */
        public TXCustomBeautyVideoFrame(V2TXLiveDef.V2TXLiveVideoFrame frame) {
            if (frame.pixelFormat == V2TXLivePixelFormatUnknown) {
                pixelFormat = TXCustomBeautyPixelFormat.TXCustomBeautyPixelFormatUnknown;
            } else if (frame.pixelFormat == V2TXLivePixelFormatI420) {
                pixelFormat = TXCustomBeautyPixelFormat.TXCustomBeautyPixelFormatI420;
            } else if (frame.pixelFormat == V2TXLivePixelFormatTexture2D) {
                pixelFormat = TXCustomBeautyPixelFormat.TXCustomBeautyPixelFormatTexture2D;
            }

            if (frame.bufferType == V2TXLiveBufferTypeUnknown) {
                bufferType = TXCustomBeautyBufferType.TXCustomBeautyBufferTypeUnknown;
            } else if (frame.bufferType == V2TXLiveBufferTypeByteArray) {
                bufferType = TXCustomBeautyBufferType.TXCustomBeautyBufferTypeByteArray;
            } else if (frame.bufferType == V2TXLiveBufferTypeByteBuffer) {
                bufferType = TXCustomBeautyBufferType.TXCustomBeautyBufferTypeByteBuffer;
            } else if (frame.bufferType == V2TXLiveBufferTypeTexture) {
                bufferType = TXCustomBeautyBufferType.TXCustomBeautyBufferTypeTexture;
            }

            if (null != frame.texture) {
                texture = new TXThirdTexture();
                texture.textureId = frame.texture.textureId;
                texture.eglContext10 = frame.texture.eglContext10;
                texture.eglContext14 = frame.texture.eglContext14;
            }

            data = frame.data;
            buffer = frame.buffer;
            width = frame.width;
            height = frame.height;
            rotation = frame.rotation;
        }

        /**
         * 基于 TRTCVideoFrame 创建
         * @param frame
         */
        public TXCustomBeautyVideoFrame(TRTCCloudDef.TRTCVideoFrame frame) {
            if (frame.pixelFormat == TRTC_VIDEO_PIXEL_FORMAT_UNKNOWN) {
                pixelFormat = TXCustomBeautyPixelFormat.TXCustomBeautyPixelFormatUnknown;
            } else if (frame.pixelFormat == TRTC_VIDEO_PIXEL_FORMAT_I420) {
                pixelFormat = TXCustomBeautyPixelFormat.TXCustomBeautyPixelFormatI420;
            } else if (frame.pixelFormat == TRTC_VIDEO_PIXEL_FORMAT_Texture_2D) {
                pixelFormat = TXCustomBeautyPixelFormat.TXCustomBeautyPixelFormatTexture2D;
            }

            if (frame.bufferType == TRTC_VIDEO_BUFFER_TYPE_UNKNOWN) {
                bufferType = TXCustomBeautyBufferType.TXCustomBeautyBufferTypeUnknown;
            } else if (frame.bufferType == TRTC_VIDEO_BUFFER_TYPE_BYTE_ARRAY) {
                bufferType = TXCustomBeautyBufferType.TXCustomBeautyBufferTypeByteArray;
            } else if (frame.bufferType == TRTC_VIDEO_BUFFER_TYPE_BYTE_BUFFER) {
                bufferType = TXCustomBeautyBufferType.TXCustomBeautyBufferTypeByteBuffer;
            } else if (frame.bufferType == TRTC_VIDEO_BUFFER_TYPE_TEXTURE) {
                bufferType = TXCustomBeautyBufferType.TXCustomBeautyBufferTypeTexture;
            }

            if (null != frame.texture) {
                texture = new TXThirdTexture();
                texture.textureId = frame.texture.textureId;
                texture.eglContext10 = frame.texture.eglContext10;
                texture.eglContext14 = frame.texture.eglContext14;
            }

            data = frame.data;
            buffer = frame.buffer;
            width = frame.width;
            height = frame.height;
            rotation = frame.rotation;
            timestamp = frame.timestamp;
        }
    }

}
