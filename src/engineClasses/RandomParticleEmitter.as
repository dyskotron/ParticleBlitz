package engineClasses
{
    public class RandomParticleEmitter extends ParticleEmitter
    {
        public function RandomParticleEmitter()
        {
            super();
        }

        override public function drawFrame(): void
        {

            //update & draw all particles
            _currentParticle = _firstParticle;

            while (_currentParticle)
            {
                //update properties
                _currentParticle.y += _currentParticle.speedY;
                _currentParticle.x += _currentParticle.speedX;
                _currentParticle.rotation = (360 + (_currentParticle.rotation + _currentParticle.rotationSpeed)) % 360;
                _currentParticle.rotationIndex = Math.floor(_currentParticle.rotation / 360 * animSmooth);

                //when out of stage recycle _currentParticle
                if (_currentParticle.y > _particleAreaMaxY || _currentParticle.y < _particleAreaMinY || _currentParticle.x > _particleAreaMaxX || _currentParticle.x < _particleAreaMinX)
                    resetParticle(_currentParticle);

                _currentParticle = _currentParticle.nextParticle;
            }
        }

        override protected function resetParticle(currentParticle: ParticleVO): void
        {
            //if out of stage recycle currentParticle
            if (currentParticle.y > _particleAreaMaxY)
                currentParticle.y = _particleAreaMinY;

            if (currentParticle.y < _particleAreaMinY)
                currentParticle.y = _particleAreaMaxY;

            if (currentParticle.x > _particleAreaMaxX)
                currentParticle.x = _particleAreaMinX;

            if (currentParticle.x < _particleAreaMinX)
                currentParticle.x = _particleAreaMaxX;
        }
    }
}
