package engineClasses
{
    public class ParticleEmitter
    {
        public var numParticles: Number = 250;

        //position
        public var initX: Number;
        public var initY: Number;
        public var varianceInitX: Number = 20;
        public var varianceInitY: Number = 200;

        //size
        public var minParticleSize: Number = 10;
        public var maxParticleSize: Number = 20;

        //alpha
        public var minAlpha: Number = 0.3;
        public var maxAlpha: Number = 1;
        public var alphaSmooth: int = 10;
        public var sizeSmooth: Number = 10;

        //speed
        public var minSpeedX: Number = 0.5;
        public var maxSpeedX: Number = 1.5;
        public var minSpeedY: Number = 1;
        public var maxSpeedY: Number = 2.5;

        //animation(rotation)
        public var minAnimSpeed: Number = -3;
        public var maxAnimSpeed: Number = -3;
        public var animSmooth: Number = 60;
        public var animateBothDirections: Boolean;

        public var _particleAreaMinX: int;
        public var _particleAreaMaxX: int;
        public var _particleAreaMinY: int;
        public var _particleAreaMaxY: int;

        //=========//

        protected var _particleAreaHeight: Number;
        protected var _particleAreaWidth: Number;

        internal var _firstParticle: ParticleVO;
        protected var _currentParticle: ParticleVO;


        //TODO: currently not supported by editor
        public var maxLifeTime: Number = 90;
        public var gravityX: Number = 0;
        public var gravityY: Number = 0;


        public function ParticleEmitter()
        {

        }

        public function set particleAreaWidth(particleAreaWidth: int): void
        {
            _particleAreaWidth = particleAreaWidth;
        }

        public function set particleAreaHeight(particleAreaHeight: int): void
        {
            _particleAreaHeight = particleAreaHeight;
        }

        public function init(): void
        {
            _particleAreaMinX = -maxParticleSize;
            _particleAreaMaxX = _particleAreaWidth + maxParticleSize;
            _particleAreaMinY = -maxParticleSize;
            _particleAreaMaxY = _particleAreaHeight + maxParticleSize;

            initX ||= _particleAreaMinX + _particleAreaWidth / 2;
            initY ||= _particleAreaMinY + _particleAreaHeight / 2;

            createParticleVOs();
        }

        public function updateVOs(): void
        {

        }

        public function destroy(): void
        {
            _currentParticle = null;
        }

        /**
         * Respawns particle
         * @param currentParticle
         */
        protected function resetParticle(currentParticle: ParticleVO): void
        {

        }

        /**
         *  Creates desired number of particle VOs
         */
        protected function createParticleVOs(): void
        {

        }
    }
}
