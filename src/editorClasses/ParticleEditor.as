package editorClasses
{
    import engineClasses.ParticleEngine;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Rectangle;

    public class ParticleEditor extends Sprite
    {

        /*
         TODO scale speed checkbox
         */

        private var engine: ParticleEngine;
        private var editorUI: EditorUI;
        private var valuesChanged: Boolean = false;

        /**
         * Constructor
         */
        public function ParticleEditor(engine: ParticleEngine)
        {
            this.engine = engine;

            //Editor UI
            editorUI = new EditorUI(new Rectangle(engine.x, engine.y, engine.width, engine.height));
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

            editorUI.hideMessage();

            engine.destroy();

            // PARTICLES
            engine.ParticleDOClass = editorUI.ParticleKindClass;
            engine.numFlakes = editorUI.numParticlesSlider.value;

            //size
            engine.minParticleSize = editorUI.particleSizeRangeSlider.lowValue;
            engine.maxParticleSize = editorUI.particleSizeRangeSlider.highValue;
            engine.sizeSmooth = editorUI.particleSizeSmoothSlider.value;
            if (!editorUI.particleSizeCheckbox.selected)
            {
                engine.sizeSmooth = 1;
                engine.minParticleSize = engine.maxParticleSize;
            }

            //alpha
            engine.minAlpha = editorUI.particleAlphaRangeSlider.lowValue;
            engine.maxAlpha = editorUI.particleAlphaRangeSlider.highValue;
            engine.alphaSmooth = editorUI.particleAlphaSmoothSlider.value;
            if (!editorUI.particleAlphaCheckbox.selected)
            {
                engine.alphaSmooth = engine.minAlpha = engine.maxAlpha = 1;
            }

            //speed
            var speedX: Number = editorUI.particleSpeedXSlider.value;
            var spreadX: Number = editorUI.particleSpreadXSlider.value;
            var speedY: Number = editorUI.particleSpeedYSlider.value;
            var spreadY: Number = editorUI.particleSpreadYSlider.value;

            engine.minSpeedX = speedX - spreadX / 2;
            engine.maxSpeedX = speedX + spreadX / 2;
            engine.minSpeedY = speedY - spreadY / 2;
            engine.maxSpeedY = speedY + spreadY / 2;

            //rotation
            engine.minRotationSpeed = editorUI.particleRotationRangeSlider.lowValue;
            engine.maxRotationSpeed = editorUI.particleRotationRangeSlider.highValue;
            engine.rotationSegments = editorUI.particleRotationSegmentsSlider.value;
            engine.rotationSegmentSmooth = editorUI.particleRotationSmoothSlider.value;
            engine.rotationSegmentMaxDegree = 360 / engine.rotationSegments;
            if (!editorUI.particleRotationCheckbox.selected)
            {
                engine.rotationSegmentSmooth = 1;
                engine.minRotationSpeed = engine.maxRotationSpeed = 0;
            }

            // STAGE
            engine.particleAreaWidth = 740;
            engine.particleAreaHeight = 640;
            engine.particleAreaMargin = engine.maxParticleSize;
            trace(engine.particleAreaMargin);
            engine.particleAreaMinX = -engine.particleAreaMargin;
            engine.particleAreaMaxX = engine.particleAreaWidth + engine.particleAreaMargin;
            engine.particleAreaMinY = -engine.particleAreaMargin;
            engine.particleAreaMaxY = engine.particleAreaHeight + engine.particleAreaMargin;
            trace(engine.particleAreaMinX);

            // AREA WITHOUT RENDERING
            engine.ignoreOmitRenderingArea = true; //ignore not rendering area
            engine.omitRenderingAreaX = 110;
            engine.omitRenderingAreaEndX = 630;
            engine.omitRenderingAreaY = 120;
            engine.omitRenderingAreaEndY = 440;

            try
            {
                engine.init();
            } catch (e: Error)
            {
                editorUI.showMessage("Sprite sheet is too big, lower particle size, size smooth, rotation smooth or alpha smooth");
            }

            if (!editorUI.particleRotationCheckbox.selected && !speedX && !spreadX && !speedY && !spreadY)
            {
                editorUI.showMessage("Heh, do you really need particle engineClasses for this?");
            }
        }
    }
}
