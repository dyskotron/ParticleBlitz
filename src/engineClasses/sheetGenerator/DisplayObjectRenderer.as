package engineClasses.sheetGenerator
{
    import engineClasses.*;

    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Sprite;

    public class DisplayObjectRenderer extends SpriteSheetRenderer
    {
        private var _particleDO: DisplayObject;

        public function DisplayObjectRenderer(aParticleDO: DisplayObject)
        {
            _particleDO = aParticleDO;
        }

        override protected function renderSpriteSheet(): void
        {
            var particleSprite: Sprite = new Sprite();
            particleSprite.addChild(_particleDO);

            _animSpriteSheet = new BitmapData(maxSize * animSmooth, maxSize * sizeSmooth, true, 0x000000);
            var particleBitmapData: BitmapData = new BitmapData(maxSize, maxSize, true, 0x000000);
            var size: Number;

            //default scale of particle with max size
            var defaultScale: Number = maxSize / Math.max(_particleDO.width, _particleDO.height);

            for (var iSize: int = 0; iSize < sizeSmooth; iSize++)
            {
                for (var iRotation: int = 0; iRotation < animSmooth; iRotation++)
                {
                    size = minSize + (maxSize - minSize) / sizeSmooth * iSize;
                    _particleDO.scaleX = _particleDO.scaleY = size / maxSize * defaultScale;
                    _particleDO.x = _particleDO.y = size / 2;
                    _particleDO.rotation = 360 / animSmooth * iRotation;

                    particleBitmapData.fillRect(particleBitmapData.rect, 0x000000);
                    particleBitmapData.draw(particleSprite, null, null, null, null, false);

                    _destPoint.x = iRotation * maxSize;
                    _destPoint.y = iSize * maxSize;
                    _animSpriteSheet.copyPixels(particleBitmapData, particleBitmapData.rect, _destPoint);
                }
            }
        }
    }
}
