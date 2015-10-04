package engineClasses
{
    public class RandomEmitter extends ParticleEmitter
    {
        public function RandomEmitter()
        {
            super();
        }

        override public function updateVOs(): void
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

        /**
         *  Creates desired number of particle VOs
         */
        override protected function createParticleVOs(): void
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
                particle.rotationSpeed = minAnimSpeed + Math.random() * (maxAnimSpeed - minAnimSpeed);
                if (animateBothDirections && Math.random() < 0.5)
                    particle.rotationSpeed *= -1;

                particle.nextParticle = _currentParticle;
                _currentParticle = particle;
            }
            _firstParticle = particle;
        }
    }
}
