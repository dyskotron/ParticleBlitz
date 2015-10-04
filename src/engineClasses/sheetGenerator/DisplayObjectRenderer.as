package engineClasses.sheetGenerator
{
    import engineClasses.*;

    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Sprite;

    public class DisplayObjectRenderer extends SpriteSheetRenderer
    {
        private var _particleClass: Class;

        public function DisplayObjectRenderer(aParticleClass: Class)
        {
            _particleClass = aParticleClass;
        }

        override protected function renderSpriteSheet(): void
        {
            var particle: DisplayObject = new _particleClass();
            var flakeSprite: Sprite = new Sprite();
            flakeSprite.addChild(particle);

            _animSpriteSheet = new BitmapData(maxSize * animSmooth, maxSize * sizeSmooth, true, 0x000000);
            var flakeBitmapData: BitmapData = new BitmapData(maxSize, maxSize, true, 0x000000);
            var size: Number;

            //default scale of particle with max size
            var defaultScale: Number = maxSize / Math.max(particle.width, particle.height);

            for (var iSize: int = 0; iSize < sizeSmooth; iSize++)
            {
                for (var iRotation: int = 0; iRotation < animSmooth; iRotation++)
                {
                    size = minSize + (maxSize - minSize) / sizeSmooth * iSize;
                    particle.scaleX = particle.scaleY = size / maxSize * defaultScale;
                    particle.x = particle.y = size / 2;
                    particle.rotation = 360 / animSmooth * iRotation;

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
