package com.tencent.live.beauty.custom;

public interface ITXCustomBeautyProcessFactory {

    /**
     * 创建美颜实例
     * @return
     */
    ITXCustomBeautyProcess createBeautyInstance();

    /**
     * 销毁美颜实例
     */
    void destroyBeautyInstance();
}
