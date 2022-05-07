package com.tencent.live.beauty.custom;

import static com.tencent.live.beauty.custom.TXCustomBeautyDef.TXCustomBeautyBufferType;
import static com.tencent.live.beauty.custom.TXCustomBeautyDef.TXCustomBeautyPixelFormat;
import static com.tencent.live.beauty.custom.TXCustomBeautyDef.TXCustomBeautyVideoFrame;

public interface ITXCustomBeautyProcess {

    TXCustomBeautyPixelFormat getPixelFormat();

    TXCustomBeautyBufferType getBufferType();

    void onProcessVideoFrame(TXCustomBeautyVideoFrame srcFrame, TXCustomBeautyVideoFrame dstFrame);
}
