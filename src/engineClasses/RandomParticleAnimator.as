package engineClasses
{
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Sprite;

    public class RandomParticleAnimator extends ParticleAnimator
    {
        public function RandomParticleAnimator()
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
                _currentParticle.rotationIndex = Math.floor(_currentParticle.rotation / 360 * rotationSmooth);

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

        override protected function createSpriteSheet(): void
        {

            var particle: DisplayObject = new particleDOClass();
            var flakeSprite: Sprite = new Sprite();
            flakeSprite.addChild(particle);

            particlesBitmapSheet = new BitmapData(maxParticleSize * rotationSmooth, maxParticleSize * sizeSmooth, true, 0x000000);
            var flakeBitmapData: BitmapData = new BitmapData(maxParticleSize, maxParticleSize, true, 0x000000);
            var size: Number;

            //default scale of particle with max size
            var defaultScale: Number = maxParticleSize / Math.max(particle.width, particle.height);

            for (var iSize: int = 0; iSize < sizeSmooth; iSize++)
            {
                for (var iRotation: int = 0; iRotation < rotationSmooth; iRotation++)
                {
                    size = minParticleSize + (maxParticleSize - minParticleSize) / sizeSmooth * iSize;
                    particle.scaleX = particle.scaleY = size / maxParticleSize * defaultScale;
                    particle.x = particle.y = size / 2;
                    particle.rotation = 360 / rotationSmooth * iRotation;

                    flakeBitmapData.fillRect(flakeBitmapData.rect, 0x000000);
                    flakeBitmapData.draw(flakeSprite, null, null, null, null, false);

                    _destPoint.x = iRotation * maxParticleSize;
                    _destPoint.y = iSize * maxParticleSize;
                    particlesBitmapSheet.copyPixels(flakeBitmapData, flakeBitmapData.rect, _destPoint);
                }
            }
        }
    }
}
