package editorClasses
{
    import engineClasses.ParticleEmitter;
    import engineClasses.ParticleEngine;
    import engineClasses.PointEmitter;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Rectangle;

    public class ParticleEditor extends Sprite
    {

        /*
         TODO scale speed checkbox
         */

        private var engine: ParticleEngine;
        private var animator: ParticleEmitter;
        private var emmiterClass: Class;
        private var editorUI: EditorUI;
        private var valuesChanged: Boolean = false;

        /**
         * Constructor
         */
        public function ParticleEditor(aEngine: ParticleEngine)
        {
            engine = aEngine;

            //Editor UI
            editorUI = new EditorUI(new Rectangle(aEngine.x, aEngine.y, aEngine.width, aEngine.height));
            editorUI.addEventListener(Event.CHANGE, editorUI_changeHandler);
            addChild(editorUI);
        }

        /**
         * Don't reset engineClasses immediately to prevent reseting during moving with sliders
         */
        private function editorUI_changeHandler(event: Event): void
        {
            resetEngine();
        }

        /**
         * Resets particle engineClasses
         */
        private function resetEngine(): void
        {
            //TODO potunit disablovani rotate/alpha/size v editoru
            valuesChanged = false;

            if (!editorUI.configComplete)
                return;

            engine.destroy();
            if (animator)
                animator.destroy();

            emmiterClass = PointEmitter;

            animator = new emmiterClass();

            // PARTICLES
            animator.animateBothDirections = editorUI.animateBothDirectionsCheckbox.selected;
            animator.numParticles = editorUI.numParticlesSlider.value;

            //Spawn position
            animator.initX = editorUI.particleSpawnXSlider.value;
            animator.initX = editorUI.particleSpawnYSlider.value;
            animator.initXSpread = editorUI.particleSpawnSpreadXSlider.value;
            animator.initYSpread = editorUI.particleSpawnSpreadYSlider.value;

            //speed
            var speedX: Number = editorUI.particleSpeedXSlider.value;
            var spreadX: Number = editorUI.particleSpreadXSlider.value;
            var speedY: Number = editorUI.particleSpeedYSlider.value;
            var spreadY: Number = editorUI.particleSpreadYSlider.value;

            animator.minSpeedX = speedX - spreadX / 2;
            animator.maxSpeedX = speedX + spreadX / 2;
            animator.minSpeedY = speedY - spreadY / 2;
            animator.maxSpeedY = speedY + spreadY / 2;

            //size
            animator.minParticleSize = editorUI.particleSizeRangeSlider.lowValue;
            animator.maxParticleSize = editorUI.particleSizeRangeSlider.highValue;
            animator.sizeSmooth = editorUI.particleSizeSmoothSlider.value;

            if (!editorUI.particleSizeCheckbox.selected)
            {
                animator.sizeSmooth = 1;
                animator.minParticleSize = animator.maxParticleSize;
            }

            //alpha
            animator.minAlpha = editorUI.particleAlphaRangeSlider.lowValue;
            animator.maxAlpha = editorUI.particleAlphaRangeSlider.highValue;
            animator.alphaSmooth = editorUI.particleAlphaSmoothSlider.value;
            if (!editorUI.particleAlphaCheckbox.selected)
            {
                animator.alphaSmooth = animator.minAlpha = animator.maxAlpha = 1;
            }

            //rotation
            animator.minAnimSpeed = editorUI.particleRotationRangeSlider.lowValue;
            animator.maxAnimSpeed = editorUI.particleRotationRangeSlider.highValue;
            animator.animSmooth = editorUI.particleRotationSmoothSlider.value;

            if (!editorUI.particleRotationCheckbox.selected)
            {
                animator.animSmooth = 1;
                animator.minAnimSpeed = animator.maxAnimSpeed = 0;
            }

            animator.initX = editorUI.particleSpawnXSlider.value;
            animator.initY = editorUI.particleSpawnYSlider.value;

            /*
             try
             {
             engine.init(animator, new editorUI.ParticleKindClass());
             } catch (e: Error)
             {
             editorUI.showMessage("Sprite sheet is too big, lower particle size, size smooth, rotation smooth or alpha smooth");
             }*/

            engine.init(animator, new editorUI.ParticleKindClass());
        }

    }
}
