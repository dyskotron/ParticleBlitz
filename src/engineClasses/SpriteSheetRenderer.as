package engineClasses
{
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class SpriteSheetRenderer
    {
        //needs to be set ===========================

        public var minSize: Number;
        public var maxSize: Number;
        public var sizeSmooth: Number;

        public var minAlpha: Number;
        public var maxAlpha: Number;
        public var alphaSmooth: Number;

        public var animSmooth: Number;
        //===========================================

        protected var _animSpriteSheet: BitmapData;
        protected var _alphaSpriteSheet: BitmapData;

        //rendering helper vars
        protected var _destPoint: Point = new Point();
        protected var _alphaPoint: Point = new Point();

        /**
         * Renders Bitmapdata needed for bitmap blitting in particle engine
         */
        public function SpriteSheetRenderer()
        {

        }

        public function render(): void
        {
            renderSpriteSheet();
            renderAlphaSheet();
        }

        public function get animSpriteSheet(): BitmapData
        {
            return _animSpriteSheet;
        }

        public function get alphaSpriteSheet(): BitmapData
        {
            return _alphaSpriteSheet;
        }

        /**
         * Renders sprite sheet with animating one attribute(rotation) in x axis and second attribute(size) in y axis
         * used in rendering particles
         */
        protected function renderSpriteSheet(): void
        {

        }

        /**
         * Renders sprite sheet of rectangles with default alpha values
         * used in rendering particles
         */
        protected function renderAlphaSheet(): void
        {
            _alphaSpriteSheet = new BitmapData(maxSize * alphaSmooth, maxSize, true, 0xff000000);

            var rect: Rectangle = new Rectangle(0, 0, maxSize, maxSize);
            var alpha: Number;

            for (var i: int = 0; i <= alphaSmooth; i++)
            {
                alpha = minAlpha + (i / alphaSmooth) * (maxAlpha - minAlpha);
                rect.x = i * maxSize;
                _alphaSpriteSheet.fillRect(rect, (alpha * 255 << 24) | 0x000000);
            }
        }
    }
}
