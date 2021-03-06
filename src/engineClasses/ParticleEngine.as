package engineClasses
{

    import engineClasses.sheetGenerator.DisplayObjectRenderer;
    import engineClasses.sheetGenerator.MovieClipRenderer;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    /**
     * Main Engine Class responsible for updating particle properties and rendering them
     */
    public final class ParticleEngine extends Sprite
    {
        // rendering area
        private var _width: int = 740;
        private var _height: int = 640;

        //// --------------------------------------------------------------------- ////

        private var _emitter: ParticleEmitter;

        private var _screenBitMap: Bitmap;
        private var _screenBitmapData: BitmapData;

        private var _screenRect: Rectangle;

        //emitter vars
        //protected var _firstParticle: ParticleVO;
        protected var _currentParticle: ParticleVO;
        protected var _sourceRect: Rectangle;
        protected var _destPoint: Point = new Point();
        protected var _alphaPoint: Point = new Point();
        private var _particlesBitmapSheet: BitmapData;
        private var _alphaBitmapSheet: BitmapData;

        /**
         * Constructor
         */
        public function ParticleEngine(width: Number, height: Number)
        {
            _width = width;
            _height = height;
            _screenRect = new Rectangle(0, 0, _width, _height);
            super();
        }

        /**
         * Initialize particle engineClasses
         */
        public function init(aAnimator: ParticleEmitter, aParticleDO: DisplayObject): void
        {
            _emitter = aAnimator;

            //CREATE SCREEN BITMAP
            _screenBitmapData = new BitmapData(_width, _height, true);
            _screenBitmapData.fillRect(_screenRect, 0x0000000);
            _screenBitMap = new Bitmap(_screenBitmapData);
            addChild(_screenBitMap);

            //INIT EMMITER
            _emitter.particleAreaWidth = _width;
            _emitter.particleAreaHeight = _height;

            var isMovieClip: Boolean = aParticleDO is MovieClip && MovieClip(aParticleDO).totalFrames > 1;
            if (aParticleDO is MovieClip && MovieClip(aParticleDO).totalFrames > 1)
                _emitter.animSmooth = MovieClip(aParticleDO).totalFrames;

            _emitter.init();

            //spriteSheet renderer
            var generator: SpriteSheetRenderer = isMovieClip ? new MovieClipRenderer(MovieClip(aParticleDO)) : new DisplayObjectRenderer(aParticleDO);
            generator.minSize = _emitter.minParticleSize;
            generator.maxSize = _emitter.maxParticleSize;
            generator.sizeSmooth = _emitter.sizeSmooth;
            generator.minAlpha = _emitter.minAlpha;
            generator.maxAlpha = _emitter.maxAlpha;
            generator.alphaSmooth = _emitter.alphaSmooth;
            generator.animSmooth = _emitter.animSmooth;
            generator.render();

            _particlesBitmapSheet = generator.animSpriteSheet;
            _alphaBitmapSheet = generator.alphaSpriteSheet;

            _sourceRect = new Rectangle(0, 0, _emitter.maxParticleSize, _emitter.maxParticleSize);

            addEventListener(Event.ENTER_FRAME, enterFrameHandler);
        }

        /**
         * Engine Destructor
         */
        public function destroy(): void
        {
            removeEventListener(Event.ENTER_FRAME, enterFrameHandler);

            if (_screenBitMap)
            {
                removeChild(_screenBitMap);
                _screenBitMap = null;
            }
            _screenBitmapData = null;
            if (_emitter)
                _emitter.destroy();
        }

        /**
         * All particle rendering happen here.
         *               `
         * @param event
         */
        private function enterFrameHandler(event: Event): void
        {
            _screenBitmapData.lock();

            //erase screen
            _screenBitmapData.fillRect(_screenRect, 0x00000000);

            _emitter.updateVOs();

            //===========================================
            _currentParticle = _emitter._firstParticle;

            while (_currentParticle)
            {
                //draw
                if (_currentParticle.renderEnabled)
                {
                    _destPoint.x = _currentParticle.x;
                    _destPoint.y = _currentParticle.y;

                    _sourceRect.width = _sourceRect.height = _currentParticle.size;
                    _sourceRect.x = _currentParticle.rotationIndex * _emitter.maxParticleSize;
                    _sourceRect.y = _currentParticle.scaleIndex * _emitter.maxParticleSize;

                    _alphaPoint.x = _currentParticle.alphaIndex * _emitter.maxParticleSize;

                    _screenBitmapData.copyPixels(_particlesBitmapSheet, _sourceRect, _destPoint, _alphaBitmapSheet, _alphaPoint, true);
                }
                _currentParticle = _currentParticle.nextParticle;
            }

            //===========================================

            _screenBitmapData.unlock();
        }

        override public function get width(): Number
        {
            return _width;
        }

        override public function get height(): Number
        {
            return _height;
        }
    }
}
