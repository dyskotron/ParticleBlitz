package engineClasses
{

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    /**
     * Main Engine Class responsible for updating particle properties and rendering them
     */
    public final class ParticleEngine extends Sprite
    {

        /////////////////////////////////////
        ///   PARTICLE ENGINE SETTINGS    ///
        /////////////////////////////////////

        // PARTICLES
        public var ParticleDOClass: Class = SnowFlake;
        public var numFlakes: Number = 250;

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
        public var rotationSegments: Number = 6;
        public var rotationSegmentSmooth: Number = 60;
        public var rotationSegmentMaxDegree: Number = 360 / rotationSegments;

        // STAGE
        public var particleAreaWidth: int = 740;
        public var particleAreaHeight: int = 640;
        public var particleAreaMargin: int = maxParticleSize;

        public var particleAreaMinX: int = -particleAreaMargin;
        public var particleAreaMaxX: int = particleAreaWidth + particleAreaMargin;
        public var particleAreaMinY: int = -particleAreaMargin;
        public var particleAreaMaxY: int = particleAreaHeight + particleAreaMargin;

        // AREA WITHOUT RENDERING
        public var ignoreOmitRenderingArea: Boolean = true; //ignore not rendering area
        public var omitRenderingAreaX: int = 110;
        public var omitRenderingAreaEndX: int = 630;
        public var omitRenderingAreaY: int = 120;
        public var omitRenderingAreaEndY: int = 440;

        //// --------------------------------------------------------------------- ////

        private var screenBitMap: Bitmap;
        private var screenBitmapData: BitmapData;
        private var particlesBitmapSheet: BitmapData;
        private var alphaBitmapSheet: BitmapData;

        private var firstParticle: ParticleVO;
        private var actualParticle: ParticleVO;
        private var sourceRect: Rectangle = new Rectangle(0, 0, maxParticleSize, maxParticleSize);
        private var screenRect: Rectangle = new Rectangle(0, 0, particleAreaWidth, particleAreaHeight);
        private var destPoint: Point = new Point();
        private var alphaPoint: Point = new Point();

        /**
         * Constructor
         */
        public function ParticleEngine()
        {
            super();
        }

        /**
         * Initialize particle engineClasses
         */
        public function init(): void
        {

            screenBitmapData = new BitmapData(particleAreaWidth, particleAreaHeight, true);
            screenBitmapData.fillRect(screenRect, 0x00000000);
            screenBitMap = new Bitmap(screenBitmapData);

            addChild(screenBitMap);

            createFlakeSheet();

            createAlphaBitmapData();

            createParticleVOs();

            addEventListener(Event.ENTER_FRAME, enterFrameHandler);

        }

        /**
         * Engine Destructor
         */
        public function destroy(): void
        {

            removeEventListener(Event.ENTER_FRAME, enterFrameHandler);

            removeChild(screenBitMap);
            screenBitMap = null;
            screenBitmapData = null;
            particlesBitmapSheet = null;
            alphaBitmapSheet = null;
            actualParticle = null;

        }

        /**
         * Creates sprite sheet
         */
        private function createFlakeSheet(): void
        {

            var flake: DisplayObject = new ParticleDOClass();
            var flakeSprite: Sprite = new Sprite();
            flakeSprite.addChild(flake);

            particlesBitmapSheet = new BitmapData(maxParticleSize * rotationSegmentSmooth, maxParticleSize * sizeSmooth, true, 0x000000);
            var flakeBitmapData: BitmapData = new BitmapData(maxParticleSize, maxParticleSize, true, 0x000000);
            var size: Number;

            //default scale of particle with max size
            var defaultScale: Number = maxParticleSize / Math.max(flake.width, flake.height);


            for (var iSize: int = 0; iSize < sizeSmooth; iSize++)
            {
                for (var iRotation: int = 0; iRotation < rotationSegmentSmooth; iRotation++)
                {
                    size = minParticleSize + (maxParticleSize - minParticleSize) / sizeSmooth * iSize;
                    flake.scaleX = flake.scaleY = size / maxParticleSize * defaultScale;
                    flake.x = flake.y = size / 2;
                    flake.rotation = 360 / rotationSegments / rotationSegmentSmooth * iRotation;

                    flakeBitmapData.fillRect(flakeBitmapData.rect, 0x000000);
                    flakeBitmapData.draw(flakeSprite, null, null, null, null, false);

                    destPoint.x = iRotation * maxParticleSize;
                    destPoint.y = iSize * maxParticleSize;
                    particlesBitmapSheet.copyPixels(flakeBitmapData, flakeBitmapData.rect, destPoint);
                }
            }
        }

        /**
         * Creates sprite sheet of rectangles with default alpha values
         * used in rendering particles
         */
        private function createAlphaBitmapData(): void
        {
            alphaBitmapSheet = new BitmapData(maxParticleSize * alphaSmooth, maxParticleSize, true, 0xff000000);

            var rect: Rectangle = new Rectangle(0, 0, maxParticleSize, maxParticleSize);
            var alpha: Number;

            for (var i: int = 0; i <= alphaSmooth; i++)
            {
                alpha = minAlpha + (i / alphaSmooth) * (maxAlpha - minAlpha);
                rect.x = i * maxParticleSize;
                alphaBitmapSheet.fillRect(rect, (alpha * 255 << 24) | 0x000000);
            }
        }

        /**
         *  Creates desired number of particle VOs
         */
        private function createParticleVOs(): void
        {
            for (var i: int = 0; i < numFlakes; i++)
            {
                var particle: ParticleVO = new ParticleVO();

                particle.x = particleAreaMinX + Math.random() * (particleAreaMaxX - particleAreaMinX);
                particle.y = particleAreaMinY + Math.random() * (particleAreaMaxY - particleAreaMinY);

                particle.scaleIndex = Math.floor(Math.random() * sizeSmooth);

                particle.size = minParticleSize + particle.scaleIndex * (maxParticleSize - minParticleSize) / sizeSmooth;

                particle.alphaIndex = Math.floor(Math.random() * alphaSmooth);

                particle.speedX = (minSpeedX + Math.random() * (maxSpeedX - minSpeedX));
                particle.speedY = (minSpeedY + Math.random() * (maxSpeedY - minSpeedY));

                particle.rotation = Math.random() * 360;
                particle.rotationSpeed = minRotationSpeed + Math.random() * (maxRotationSpeed - minRotationSpeed);

                particle.nextParticle = actualParticle;
                actualParticle = particle;
            }
            firstParticle = particle;
        }

        /**
         * All particle rendering happen here.
         * @param event
         */
        private function enterFrameHandler(event: Event): void
        {
            screenBitmapData.lock();

            //erase screen
            screenBitmapData.fillRect(screenRect, 0x00000000);

            //update & draw all particles
            actualParticle = firstParticle;

            while (actualParticle)
            {
                //update properties
                actualParticle.y += actualParticle.speedY;
                actualParticle.x += actualParticle.speedX;
                actualParticle.rotation = (rotationSegmentMaxDegree + (actualParticle.rotation + actualParticle.rotationSpeed)) % rotationSegmentMaxDegree;
                actualParticle.rotationIndex = Math.floor(actualParticle.rotation / rotationSegmentMaxDegree * rotationSegmentSmooth);

                //if out of stage recycle actualParticle
                if (actualParticle.y > particleAreaMaxY)
                    actualParticle.y = particleAreaMinY;

                if (actualParticle.y < particleAreaMinY)
                    actualParticle.y = particleAreaMaxY;

                if (actualParticle.x > particleAreaMaxX)
                    actualParticle.x = particleAreaMinX;

                if (actualParticle.x < particleAreaMinX)
                    actualParticle.x = particleAreaMaxX;

                //test not drawing area
                if (actualParticle.x < omitRenderingAreaX || actualParticle.x > omitRenderingAreaEndX || actualParticle.y < omitRenderingAreaY || actualParticle.y > omitRenderingAreaEndY || ignoreOmitRenderingArea)
                {
                    //draw
                    destPoint.x = actualParticle.x;
                    destPoint.y = actualParticle.y;

                    sourceRect.width = sourceRect.height = actualParticle.size;
                    sourceRect.x = actualParticle.rotationIndex * maxParticleSize;
                    sourceRect.y = actualParticle.scaleIndex * maxParticleSize;

                    alphaPoint.x = actualParticle.alphaIndex * maxParticleSize;

                    screenBitmapData.copyPixels(particlesBitmapSheet, sourceRect, destPoint, alphaBitmapSheet, alphaPoint, true);

                }

                actualParticle = actualParticle.nextParticle;
            }

            screenBitmapData.unlock();
        }
    }
}
