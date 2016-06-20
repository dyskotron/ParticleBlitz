package editorClasses
{

    import com.bit101.components.CheckBox;
    import com.bit101.components.HRangeSlider;
    import com.bit101.components.HSlider;
    import com.bit101.components.Label;
    import com.bit101.components.RadioButton;
    import com.bit101.utils.MinimalConfigurator;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.geom.Rectangle;
    import flash.utils.Timer;

    import particles.Badger;
    import particles.Banana;
    import particles.CoinAnim;
    import particles.GoldAnim;
    import particles.Shoe;
    import particles.SnowFlake;

    /**
     * UI for particle engine settings
     */
    public class EditorUI extends Sprite
    {
        //main public vars
        public var directionEditor: DirectionEditor;
        public var configComplete: Boolean;

        //Sliders
        public var numParticlesSlider: HSlider;

        public var particleSizeRangeSlider: HRangeSlider;
        public var particleSizeSmoothSlider: HSlider;

        public var particleAlphaRangeSlider: HRangeSlider;
        public var particleAlphaSmoothSlider: HSlider;

        public var particleSpeedXSlider: HSlider;
        public var particleSpreadXSlider: HSlider;
        public var particleSpeedYSlider: HSlider;
        public var particleSpreadYSlider: HSlider;

        public var particleSpawnXSlider: HSlider;
        public var particleSpawnSpreadXSlider: HSlider;
        public var particleSpawnYSlider: HSlider;
        public var particleSpawnSpreadYSlider: HSlider;

        public var particleRotationRangeSlider: HRangeSlider;
        public var particleRotationSegmentsSlider: HSlider;
        public var particleRotationSmoothSlider: HSlider;

        //RadioButtons
        public var snowFlake: RadioButton;
        public var banana: RadioButton;
        public var shoe: RadioButton;
        public var circle: RadioButton;
        public var gold: RadioButton;
        public var coin: RadioButton;

        //Labels
        public var numParticlesLabel: Label;

        public var particleSizeRangeLabel: Label;
        public var particleSizeSmoothLabel: Label;
        public var particleAlphaRangeLabel: Label;
        public var particleAlphaSmoothLabel: Label;

        public var particleRotationRangeLabel: Label;
        public var particleRotationSegmentsLabel: Label;
        public var particleRotationSmoothLabel: Label;

        public var particleSpeedYLabel: Label;
        public var particleSpreadYLabel: Label;
        public var particleSpeedXLabel: Label;
        public var particleSpreadXLabel: Label;

        public var particleSpawnYLabel: Label;
        public var particleSpawnSpreadYLabel: Label;
        public var particleSpawnXLabel: Label;
        public var particleSpawnSpreadXLabel: Label;

        //CheckBoxes
        public var particleSizeCheckbox: CheckBox;
        public var particleAlphaCheckbox: CheckBox;
        public var particleRotationCheckbox: CheckBox;
        public var animateBothDirectionsCheckbox: CheckBox;

        private var warningPopUp: Sprite;
        private var directionEditorRect: Rectangle;

        [Embed(source="UIConfig.xml", mimeType="application/octet-stream")]
        private const UI_XML: Class;
        private var changeEventTimer: Timer;

        private var _emmiterX: Number;
        private var _emmiterY: Number;

        //TODO disablovaci checkboxy prehodit za labely dat jim label animate enabled, a dat za ne enabled jednoduchej slider misto range slideru
        //nebo este lip vymenit ho misto range slideru vcetne zmeny labelu atd
        //poladit range slidery aby ukazovaly spravne cisla
        /**
         * Constructor
         * @param directionEditorRect
         */
        public function EditorUI(directionEditorRect: Rectangle)
        {
            changeEventTimer = new Timer(300, 1);
            changeEventTimer.addEventListener(TimerEvent.TIMER, changeEventTimerListener);
            this.directionEditorRect = directionEditorRect;

            //graphics
            this.graphics.beginFill(0x005566);
            this.graphics.drawRect(0, 0, 400, 640);

            //config MinimalComps
            var config: MinimalConfigurator = new MinimalConfigurator(this);
            config.parseXML(XML(new UI_XML));
            configComplete = true;

            //direction editor
            directionEditor = new DirectionEditor(directionEditorRect.width, directionEditorRect.height);
            addChild(directionEditor);
            directionEditor.x = -directionEditorRect.width;
            directionEditor.addEventListener(Event.CHANGE, directionEditor_changeHandler);

            particleSpawnXSlider.maximum = directionEditorRect.width;
            particleSpawnYSlider.maximum = directionEditorRect.height;
            particleSpawnSpreadXSlider.maximum = directionEditorRect.width / 2;
            particleSpawnSpreadYSlider.maximum = directionEditorRect.height / 2;
        }

        public function get emmiterX(): Number
        {
            return _emmiterX;
        }

        public function get emmiterY(): Number
        {
            return _emmiterY;
        }

        //ALERT
        public function showMessage(text: String): void
        {
            var label: Label = new Label(this, 10, 10, text);
            label.textField.textColor = 0xff0000;
            warningPopUp = new Sprite();
            warningPopUp.addChild(label);
            warningPopUp.graphics.beginFill(0x000000, 0.8);
            warningPopUp.graphics.drawRect(0, 0, label.width + 20, label.height + 20);
            warningPopUp.x = -directionEditorRect.width / 2 - warningPopUp.width / 2;
            warningPopUp.y = directionEditorRect.height / 2 - warningPopUp.height / 2;
            warningPopUp.mouseEnabled = false;
            addChild(warningPopUp);
        }

        public function hideMessage(): void
        {
            if (!warningPopUp)
                return;

            removeChild(warningPopUp);
            warningPopUp = null;
        }

        // GET KIND CLASS
        public function get ParticleKindClass(): Class
        {
            var KindClass: Class = Badger;

            if (snowFlake.selected)
                KindClass = SnowFlake;
            else if (banana.selected)
                KindClass = Banana;
            else if (shoe.selected)
                KindClass = Shoe;
            else if (circle.selected)
                KindClass = CircleGradient;
            else if (coin.selected)
                KindClass = CoinAnim;
            else if (gold.selected)
                KindClass = GoldAnim;

            return KindClass;
        }

        //region ========================================== UI EVENT HANDLERS =========================================

        // NUM PARTICLES
        public function onNumParticlesChange(e: Event): void
        {
            numParticlesLabel.text = "Particles quantity: " + numParticlesSlider.value;
            enginePropertyChanged();
        }

        // SIZE
        public function particleSizeCheckboxChange(e: Event): void
        {
            particleSizeRangeLabel.enabled = particleSizeSmoothLabel.enabled = particleSizeRangeSlider.enabled = particleSizeSmoothSlider.enabled = particleSizeSmoothSlider.enabled = particleSizeCheckbox.selected;
            enginePropertyChanged();
        }

        public function onParticleSizeSmoothChange(e: Event): void
        {
            particleSizeSmoothLabel.text = "Smooth: " + particleSizeSmoothSlider.value;
            enginePropertyChanged();
        }

        // ALPHA
        public function particleAlphaCheckboxChange(e: Event): void
        {
            particleAlphaRangeLabel.enabled = particleAlphaSmoothLabel.enabled = particleAlphaRangeSlider.enabled = particleAlphaSmoothSlider.enabled = particleAlphaSmoothSlider.enabled = particleAlphaCheckbox.selected;
            enginePropertyChanged();
        }

        public function onParticleAlphaSmoothChange(e: Event): void
        {
            particleAlphaSmoothLabel.text = "Smooth: " + particleAlphaSmoothSlider.value;
            enginePropertyChanged();
        }

        // ROTATION
        public function particleRotationCheckboxChange(e: Event): void
        {
            particleRotationRangeLabel.enabled = particleRotationSegmentsLabel.enabled = particleRotationSmoothLabel.enabled = particleRotationRangeSlider.enabled = particleRotationSmoothSlider.enabled = particleRotationSegmentsSlider.enabled = particleRotationSmoothSlider.enabled = particleRotationCheckbox.selected;
            enginePropertyChanged();
        }

        public function onParticleRotationSegmentsChange(e: Event): void
        {
            particleRotationSegmentsLabel.text = "Segments: " + particleRotationSegmentsSlider.value;
            enginePropertyChanged();
        }

        public function onParticleRotationSmoothChange(e: Event): void
        {
            particleRotationSmoothLabel.text = "Smooth: " + particleRotationSmoothSlider.value;
            enginePropertyChanged();
        }

        public function animateBothDirectionsCheckboxChange(e: Event): void
        {
            enginePropertyChanged();
        }

        // KIND
        public function onParticleKindChange(e: Event): void
        {
            enginePropertyChanged();
        }

        // SPAWN
        public function onParticleSpawnXChange(e: Event): void
        {
            particleSpawnXLabel.text = "Spawn X: " + Math.floor(particleSpawnXSlider.value);
            enginePropertyChanged();
        }

        public function onParticleSpawnSpreadXChange(e: Event): void
        {
            particleSpawnSpreadXLabel.text = "Spread X: " + Math.floor(particleSpawnSpreadXSlider.value);
            enginePropertyChanged();
        }

        public function onParticleSpawnYChange(e: Event): void
        {
            particleSpawnYLabel.text = "Spread X: " + Math.floor(particleSpawnYSlider.value);
            enginePropertyChanged();
        }

        public function onParticleSpawnSpreadYChange(e: Event): void
        {
            particleSpawnSpreadYLabel.text = "Spread X: " + Math.floor(particleSpawnSpreadYSlider.value);
            enginePropertyChanged();
        }

        // MOVE
        public function onParticleSpeedXChange(e: Event): void
        {
            particleSpeedXLabel.text = "Speed X: " + Math.floor(particleSpeedXSlider.value * 10) / 10;
            enginePropertyChanged();
        }

        public function onParticleSpreadXChange(e: Event): void
        {
            particleSpreadXLabel.text = "Spread X: " + Math.floor(particleSpreadXSlider.value * 10) / 10;
            enginePropertyChanged();
        }

        public function onParticleSpeedYChange(e: Event): void
        {
            particleSpeedYLabel.text = "Speed Y: " + Math.floor(particleSpeedYSlider.value * 10) / 10;
            enginePropertyChanged();
        }

        public function onParticleSpreadYChange(e: Event): void
        {
            particleSpreadYLabel.text = "Spread Y: " + Math.floor(particleSpreadYSlider.value * 10) / 10;
            enginePropertyChanged();
        }

        public function onRangeSliderChange(e: Event): void
        {
            enginePropertyChanged();
        }

        //endregion

        //DIRECTION EDITOR
        private function directionEditor_changeHandler(event: Event): void
        {
            particleSpeedXSlider.value = directionEditor.xDirection * particleSpeedXSlider.maximum;
            particleSpeedXLabel.text = "Speed X: " + Math.floor(particleSpeedXSlider.value * 10) / 10;

            particleSpeedYSlider.value = directionEditor.yDirection * particleSpeedYSlider.maximum;
            particleSpeedYLabel.text = "Speed Y: " + Math.floor(particleSpeedYSlider.value * 10) / 10;

            particleSpawnXSlider.value = directionEditor.emmiterX;
            particleSpawnYSlider.value = directionEditor.emmiterY;

            particleSpawnXSlider.value = directionEditor.emmiterX;
            onParticleSpawnXChange(null);
            particleSpawnYSlider.value = directionEditor.emmiterY;
            onParticleSpawnYChange(null);

            enginePropertyChanged();
        }

        //ENGINE SETTINGS CHANGED
        private function enginePropertyChanged(): void
        {
            changeEventTimer.stop();
            changeEventTimer.start();
            hideMessage();
        }

        //DISPATCH CHANGE EVENT
        private function changeEventTimerListener(event: TimerEvent): void
        {
            dispatchEvent(new Event(Event.CHANGE));
        }
    }
}
