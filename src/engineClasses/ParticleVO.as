package engineClasses
{
    /**
     * Particle VO, there we store all particle properties
     */
    public final class ParticleVO
    {

        public var x: Number;
        public var y: Number;
        public var size: Number;

        public var speedX: Number;
        public var speedY: Number;

        public var rotation: Number;
        public var rotationSpeed: Number;
        public var rotationIndex: int;

        public var alphaIndex: Number;
        public var nextParticle: ParticleVO;
        public var scaleIndex: int;

        public var lifeTime: Number;
        public var renderEnabled: Boolean = true;

        /**
         * Constructor
         */
        public function ParticleVO()
        {

        }

    }
}
