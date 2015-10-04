package engineClasses.sheetGenerator
{
    import engineClasses.*;

    import flash.display.BitmapData;
    import flash.display.MovieClip;
    import flash.display.Sprite;

    public class MovieClipRenderer extends SpriteSheetRenderer
    {
        private var _particleMC: MovieClip;

        public function MovieClipRenderer(aParticleMC: MovieClip)
        {
            _particleMC = aParticleMC;
        }

        override protected function renderSpriteSheet(): void
        {
            var flakeSprite: Sprite = new Sprite();
            flakeSprite.addChild(_particleMC);
            var totalFrames: int = _particleMC.totalFrames;

            _animSpriteSheet = new BitmapData(maxSize * totalFrames, maxSize * sizeSmooth, true, 0x000000);
            var flakeBitmapData: BitmapData = new BitmapData(maxSize, maxSize, true, 0x000000);
            var size: Number;

            //default scale of particle with max size
            var defaultScale: Number = maxSize / Math.max(_particleMC.width, _particleMC.height);

            for (var iSize: int = 0; iSize <= sizeSmooth; iSize++)
            {
                for (var iRotation: int = 0; iRotation < totalFrames; iRotation++)
                {
                    size = minSize + (maxSize - minSize) / sizeSmooth * iSize;
                    _particleMC.scaleX = _particleMC.scaleY = size / maxSize * defaultScale;
                    _particleMC.x = _particleMC.y = size / 2;
                    _particleMC.gotoAndStop(iRotation + 1);

                    flakeBitmapData.fillRect(flakeBitmapData.rect, 0x000000);
                    flakeBitmapData.draw(flakeSprite, null, null, null, null, false);

                    _destPoint.x = iRotation * maxSize;
                    _destPoint.y = iSize * maxSize;
                    _animSpriteSheet.copyPixels(flakeBitmapData, flakeBitmapData.rect, _destPoint);
                }
            }
        }
    }
}
