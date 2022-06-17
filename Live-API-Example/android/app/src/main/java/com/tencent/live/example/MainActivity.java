package example.android.app.src.main.java.com.tencent.live.example;

import android.opengl.GLES20;
import android.os.Bundle;

import androidx.annotation.Nullable;

import com.tencent.live.TXLivePluginManager;
import com.tencent.live.beauty.custom.ITXCustomBeautyProcesserFactory;
import com.tencent.live.beauty.custom.ITXCustomBeautyProcesser;
import com.tencent.live.example.opengl.FrameBuffer;
import com.tencent.live.example.opengl.GpuImageGrayscaleFilter;
import com.tencent.live.example.opengl.OpenGlUtils;
import com.tencent.live.example.opengl.Rotation;

import java.nio.FloatBuffer;

import io.flutter.embedding.android.FlutterActivity;

import static com.tencent.live.beauty.custom.TXCustomBeautyDef.TXCustomBeautyBufferType;
import static com.tencent.live.beauty.custom.TXCustomBeautyDef.TXCustomBeautyPixelFormat;
import static com.tencent.live.beauty.custom.TXCustomBeautyDef.TXCustomBeautyVideoFrame;

public class MainActivity extends FlutterActivity {

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        TXLivePluginManager.register(new TXThirdBeauty());
    }

    class TXThirdBeauty implements ITXCustomBeautyProcesserFactory {

        private BeautyProcessor customBeautyProcesser;
        
        @Override
        public ITXCustomBeautyProcesser createCustomBeautyProcesser() {
            customBeautyProcesser = new BeautyProcessor();
            return customBeautyProcesser;
        }

        @Override
        public void destroyCustomBeautyProcesser() {
            if (null != customBeautyProcesser) {
                customBeautyProcesser.destroy();
                customBeautyProcesser = null;
            }
        }
    }

    class BeautyProcessor implements ITXCustomBeautyProcesser {

        private FrameBuffer mFrameBuffer;
        private GpuImageGrayscaleFilter mGrayscaleFilter;
        private FloatBuffer mGLCubeBuffer;
        private FloatBuffer mGLTextureBuffer;

        public void destroy() {
            if (mFrameBuffer != null) {
                mFrameBuffer.uninitialize();
                mFrameBuffer = null;
            }
            if (mGrayscaleFilter != null) {
                mGrayscaleFilter.destroy();
                mGrayscaleFilter = null;
            }
        }

        @Override
        public TXCustomBeautyPixelFormat getSupportedPixelFormat() {
            return TXCustomBeautyPixelFormat.TXCustomBeautyPixelFormatTexture2D;
        }

        @Override
        public TXCustomBeautyBufferType getSupportedBufferType() {
            return TXCustomBeautyBufferType.TXCustomBeautyBufferTypeTexture;
        }

        @Override
        public void onProcessVideoFrame(TXCustomBeautyVideoFrame srcFrame, TXCustomBeautyVideoFrame dstFrame) {
            final int width = srcFrame.width;
            final int height = srcFrame.height;
            if (mFrameBuffer == null || mFrameBuffer.getWidth() != width || mFrameBuffer.getHeight() != height) {
                if (mFrameBuffer != null) {
                    mFrameBuffer.uninitialize();
                }
                mFrameBuffer = new FrameBuffer(width, height);
                mFrameBuffer.initialize();
            }
            if (mGrayscaleFilter == null) {
                mGrayscaleFilter = new GpuImageGrayscaleFilter();
                mGrayscaleFilter.init();
                mGrayscaleFilter.onOutputSizeChanged(width, height);

                mGLCubeBuffer = OpenGlUtils.createNormalCubeVerticesBuffer();
                mGLTextureBuffer = OpenGlUtils.createTextureCoordsBuffer(Rotation.NORMAL, false, false);
            }
            GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER, mFrameBuffer.getFrameBufferId());
            GLES20.glViewport(0, 0, width, height);
            mGrayscaleFilter.onDraw(srcFrame.texture.textureId, mGLCubeBuffer, mGLTextureBuffer);
            dstFrame.texture.textureId = mFrameBuffer.getTextureId();
            GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER, 0);
        }
    }
}
