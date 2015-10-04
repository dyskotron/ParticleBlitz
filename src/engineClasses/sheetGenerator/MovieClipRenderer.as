package engineClasses.sheetGenerator
{
    import engineClasses.*;

    import flash.display.BitmapData;
    import flash.display.MovieClip;
    import flash.display.Sprite;

    public class MovieClipRenderer extends SpriteSheetRenderer
    {
        private var _particleClass: Class;

        public function MovieClipRenderer(aParticleClass: Class)
        {
            _particleClass = aParticleClass;
        }

        override protected function renderSpriteSheet(): void
        {
            var particle: MovieClip = new _particleClass();
            var flakeSprite: Sprite = new Sprite();
            flakeSprite.addChild(particle);
            var totalFrames: int = particle.totalFrames;

            _animSpriteSheet = new BitmapData(maxSize * totalFrames, maxSize * sizeSmooth, true, 0x000000);
            var flakeBitmapData: BitmapData = new BitmapData(maxSize, maxSize, true, 0x000000);
            var size: Number;

            //default scale of particle with max size
            var defaultScale: Number = maxSize / Math.max(particle.width, particle.height);

            for (var iSize: int = 0; iSize <= sizeSmooth; iSize++)
            {
                for (var iRotation: int = 0; iRotation < totalFrames; iRotation++)
                {
                    size = minSize + (maxSize - minSize) / sizeSmooth * iSize;
                    particle.scaleX = particle.scaleY = size / maxSize * defaultScale;
                    particle.x = particle.y = size / 2;
                    particle.gotoAndStop(iRotation + 1);

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
