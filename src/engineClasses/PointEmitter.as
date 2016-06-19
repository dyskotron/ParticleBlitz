package engineClasses
{
    public class PointEmitter extends ParticleEmitter
    {
        public function PointEmitter()
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
                _currentParticle.lifeTime++;

                if (_currentParticle.lifeTime >= 0)
                {
                    //if (_currentParticle.lifeTime == 0)
                    _currentParticle.renderEnabled = true;

                    _currentParticle.y += _currentParticle.speedY;
                    _currentParticle.x += _currentParticle.speedX;
                    _currentParticle.speedY += gravityY;
                    _currentParticle.speedX += gravityX;
                    _currentParticle.rotation = (360 + (_currentParticle.rotation + _currentParticle.rotationSpeed)) % 360;
                    _currentParticle.rotationIndex = Math.floor(_currentParticle.rotation / 360 * animSmooth);

                    //when out of stage recycle _currentParticle
                    if (_currentParticle.lifeTime > maxLifeTime)
                        resetParticle(_currentParticle);
                }
                else
                {

                }

                _currentParticle = _currentParticle.nextParticle;
            }
        }

        override protected function resetParticle(currentParticle: ParticleVO): void
        {
            currentParticle.lifeTime = 0;
            currentParticle.x = initX + (Math.random() * 2 - 1) * varianceInitX;
            currentParticle.y = initY + (Math.random() * 2 - 1) * varianceInitY;
            currentParticle.speedX = (minSpeedX + Math.random() * (maxSpeedX - minSpeedX));
            currentParticle.speedY = (minSpeedY + Math.random() * (maxSpeedY - minSpeedY));
        }

        /**
         *  Creates desired number of particle VOs
         */
        override protected function createParticleVOs(): void
        {
            for (var i: int = 0; i < numParticles; i++)
            {
                var particle: ParticleVO = new ParticleVO();

                particle.lifeTime = -maxLifeTime * (i / numParticles);
                particle.renderEnabled = false;

                particle.x = initX + (Math.random() * 2 - 1) * varianceInitX;
                particle.y = initY + (Math.random() * 2 - 1) * varianceInitY;

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
