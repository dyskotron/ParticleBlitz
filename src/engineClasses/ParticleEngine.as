package engineClasses
{

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Rectangle;

    /**
     * Main Engine Class responsible for updating particle properties and rendering them
     */
    public final class ParticleEngine extends Sprite
    {

        // rendering area
        public var particleAreaWidth: int = 740;
        public var particleAreaHeight: int = 640;

        //// --------------------------------------------------------------------- ////

        private var animator: ParticleAnimator;

        private var screenBitMap: Bitmap;
        private var screenBitmapData: BitmapData;

        private var screenRect: Rectangle = new Rectangle(0, 0, particleAreaWidth, particleAreaHeight);

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
        public function init(aAnimator: ParticleAnimator): void
        {
            animator = aAnimator;

            //CREATE SCREEN BITMAP
            screenBitmapData = new BitmapData(particleAreaWidth, particleAreaHeight, true);
            screenBitmapData.fillRect(screenRect, 0x0000000);
            screenBitMap = new Bitmap(screenBitmapData);
            addChild(screenBitMap);

            //INIT EMMITER
            animator.particleAreaWidth = particleAreaWidth;
            animator.particleAreaHeight = particleAreaHeight;
            animator.init(screenBitmapData);

            addEventListener(Event.ENTER_FRAME, enterFrameHandler);
        }

        /**
         * Engine Destructor
         */
        public function destroy(): void
        {
            removeEventListener(Event.ENTER_FRAME, enterFrameHandler);

            if (screenBitMap)
            {
                removeChild(screenBitMap);
                screenBitMap = null;
            }
            screenBitmapData = null;
            if (animator)
                animator.destroy();
        }

        /**
         * All particle rendering happen here.
         * @param event
         */
        private function enterFrameHandler(event: Event): void
        {
            screenBitmapData.lock();

            //erase screen
            screenBitmapData.fillRect(screenRect, 0x20ff0000);

            animator.drawFrame();

            screenBitmapData.unlock();
        }
    }
}
