package engineClasses
{
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class ParticleAnimator
    {
        public var numParticles: Number = 250;

        //size
        public var minParticleSize: Number = 10;
        public var maxParticleSize: Number = 20;
        public var sizeSmooth: Number = 10;

        //speed
        public var minSpeedX: Number = 0.5;
        public var maxSpeedX: Number = 1.5;
        public var minSpeedY: Number = 1;
        public var maxSpeedY: Number = 2.5;

        //alpha
        public var minAlpha: Number = 0.3;
        public var maxAlpha: Number = 1;
        public var alphaSmooth: int = 10;

        //rotation
        public var minRotationSpeed: Number = -3;
        public var maxRotationSpeed: Number = -3;

        public var rotationSegmentSmooth: Number = 60;
        public var animateBothDirections: Boolean;

        public var _particleAreaMinX: int;
        public var _particleAreaMaxX: int;
        public var _particleAreaMinY: int;
        public var _particleAreaMaxY: int;

        protected var _rotationSegments: Number = 6;
        protected var rotationSegmentMaxDegree: Number = 360 / _rotationSegments;

        //=========//

        private var _particleAreaHeight: Number;
        private var _particleAreaWidth: Number;

        protected var _firstParticle: ParticleVO;
        protected var _currentParticle: ParticleVO;
        protected var _sourceRect: Rectangle;
        protected var _destPoint: Point = new Point();
        protected var _alphaPoint: Point = new Point();

        protected var _particleDOClass: Class = SnowFlake;
        protected var _particlesBitmapSheet: BitmapData;
        protected var _alphaBitmapSheet: BitmapData;
        protected var _screenBitmapData: BitmapData;


        public function ParticleAnimator()
        {

        }

        public function set particleDOClass(value: Class): void
        {
            _particleDOClass = value;
        }

        public function set particleAreaWidth(particleAreaWidth: int): void
        {
            _particleAreaWidth = particleAreaWidth;
        }

        public function set particleAreaHeight(particleAreaHeight: int): void
        {
            _particleAreaHeight = particleAreaHeight;
        }

        public function init(screenBitmapData: BitmapData): void
        {
            this._screenBitmapData = screenBitmapData;
            _particleAreaMinX = -maxParticleSize;
            _particleAreaMaxX = _particleAreaWidth + maxParticleSize;
            _particleAreaMinY = -maxParticleSize;
            _particleAreaMaxY = _particleAreaHeight + maxParticleSize;
            _sourceRect = new Rectangle(0, 0, maxParticleSize, maxParticleSize);

            createSpriteSheet();
            createAlphaBitmapData();
            createParticleVOs();
        }

        public function drawFrame(): void
        {

            //update & draw all particles
            _currentParticle = _firstParticle;

            while (_currentParticle)
            {
                //update properties
                _currentParticle.y += _currentParticle.speedY;
                _currentParticle.x += _currentParticle.speedX;
                _currentParticle.rotation = (rotationSegmentMaxDegree + (_currentParticle.rotation + _currentParticle.rotationSpeed)) % rotationSegmentMaxDegree;
                _currentParticle.rotationIndex = Math.floor(_currentParticle.rotation / rotationSegmentMaxDegree * rotationSegmentSmooth);

                //when out of stage recycle _currentParticle
                if (_currentParticle.y > _particleAreaMaxY || _currentParticle.y < _particleAreaMinY || _currentParticle.x > _particleAreaMaxX || _currentParticle.x < _particleAreaMinX)
                    resetParticle(_currentParticle);

                //draw
                _destPoint.x = _currentParticle.x;
                _destPoint.y = _currentParticle.y;

                _sourceRect.width = _sourceRect.height = _currentParticle.size;
                _sourceRect.x = _currentParticle.rotationIndex * maxParticleSize;
                _sourceRect.y = _currentParticle.scaleIndex * maxParticleSize;

                _alphaPoint.x = _currentParticle.alphaIndex * maxParticleSize;

                _screenBitmapData.copyPixels(_particlesBitmapSheet, _sourceRect, _destPoint, _alphaBitmapSheet, _alphaPoint, true);

                _currentParticle = _currentParticle.nextParticle;
            }
        }

        public function destroy(): void
        {
            _currentParticle = null;
            _particlesBitmapSheet = null;
            _alphaBitmapSheet = null;
        }

        /**
         * Respawns particle
         * @param currentParticle
         */
        protected function resetParticle(currentParticle): void
        {

        }

        /**
         * Creates sprite sheet
         */
        protected function createSpriteSheet(): void
        {

        }

        /**
         * Creates sprite sheet of rectangles with default alpha values
         * used in rendering particles
         */
        protected function createAlphaBitmapData(): void
        {
            _alphaBitmapSheet = new BitmapData(maxParticleSize * alphaSmooth, maxParticleSize, true, 0xff000000);

            var rect: Rectangle = new Rectangle(0, 0, maxParticleSize, maxParticleSize);
            var alpha: Number;

            for (var i: int = 0; i <= alphaSmooth; i++)
            {
                alpha = minAlpha + (i / alphaSmooth) * (maxAlpha - minAlpha);
                rect.x = i * maxParticleSize;
                _alphaBitmapSheet.fillRect(rect, (alpha * 255 << 24) | 0x000000);
            }
        }

        /**
         *  Creates desired number of particle VOs
         */
        private function createParticleVOs(): void
        {
            for (var i: int = 0; i < numParticles; i++)
            {
                var particle: ParticleVO = new ParticleVO();

                particle.x = _particleAreaMinX + Math.random() * (_particleAreaMaxX - _particleAreaMinX);
                particle.y = _particleAreaMinY + Math.random() * (_particleAreaMaxY - _particleAreaMinY);

                particle.scaleIndex = Math.floor(Math.random() * sizeSmooth);

                particle.size = minParticleSize + particle.scaleIndex * (maxParticleSize - minParticleSize) / sizeSmooth;

                particle.alphaIndex = Math.floor(Math.random() * alphaSmooth);

                particle.speedX = (minSpeedX + Math.random() * (maxSpeedX - minSpeedX));
                particle.speedY = (minSpeedY + Math.random() * (maxSpeedY - minSpeedY));

                particle.rotation = Math.random() * 360;
                particle.rotationSpeed = minRotationSpeed + Math.random() * (maxRotationSpeed - minRotationSpeed);
                if (animateBothDirections && Math.random() < 0.5)
                    particle.rotationSpeed *= -1;

                particle.nextParticle = _currentParticle;
                _currentParticle = particle;
            }
            _firstParticle = particle;
        }

        public function set rotationSegments(value: Number): void
        {
            _rotationSegments = value;
            rotationSegmentMaxDegree = 360 / _rotationSegments
        }
    }
}