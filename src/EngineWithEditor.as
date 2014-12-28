package
{

    import editorClasses.ParticleEditor;

    import engineClasses.ParticleEngine;

    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;

    import net.hires.debug.Stats;

    [SWF(width="1140", height="640", frameRate="60", backgroundColor=0x000000)]
    public class EngineWithEditor extends Sprite
    {
        private var engine: ParticleEngine;
        private var editor: ParticleEditor;

        public function EngineWithEditor()
        {
            //setup stage
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP;

            //create engine
            engine = new ParticleEngine();
            engine.init();
            addChild(engine);

            //draw engine bacground
            this.graphics.beginFill(0x333333);
            this.graphics.drawRect(0, 0, engine.particleAreaWidth, engine.particleAreaHeight);

            //create editor
            editor = new ParticleEditor(engine);
            editor.x = 740;
            addChild(editor);

            //add stats
            var stats: Stats = new Stats();
            addChild(stats);

        }

    }
}
