package editorClasses
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;

    /**
     * Simple UI for "drag&drop" control of particles direction
     */
    public class DirectionEditor extends Sprite
    {

        public var xDirection: Number;
        public var yDirection: Number;

        private const MAX_DIR_EDITOR_SPEED: Number = 20;

        private var mouseDown: Boolean = false;
        private var startPoint: Point = new Point();
        private var maxDirectionLength: Number;

        public function DirectionEditor(width: Number, height: Number)
        {
            var mouseSprite: Sprite = new Sprite();
            addChild(mouseSprite);
            mouseSprite.graphics.beginFill(0x000000, 0);
            mouseSprite.graphics.drawRect(0, 0, width, height);

            mouseSprite.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            mouseSprite.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
            mouseSprite.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);

            maxDirectionLength = Math.min(width, height);

        }

        private function mouseDownHandler(event: MouseEvent): void
        {
            mouseDown = true;
            startPoint.x = event.localX;
            startPoint.y = event.localY;
        }

        private function mouseUpHandler(event: MouseEvent): void
        {
            mouseDown = false;
            this.graphics.clear();

            xDirection = (event.localX - startPoint.x) / maxDirectionLength * MAX_DIR_EDITOR_SPEED;
            yDirection = (event.localY - startPoint.y) / maxDirectionLength * MAX_DIR_EDITOR_SPEED;

            // MAX_DIR_EDITOR_SPEED exceeded - scale it
            if (xDirection > MAX_DIR_EDITOR_SPEED || yDirection > MAX_DIR_EDITOR_SPEED)
            {
                var overlappingDirectionValue: Number = Math.max(xDirection, yDirection);
                var ratio: Number = MAX_DIR_EDITOR_SPEED / overlappingDirectionValue;
                xDirection *= ratio;
                yDirection *= ratio;
            }

            dispatchEvent(new Event(Event.CHANGE));

        }

        private function mouseMoveHandler(event: MouseEvent): void
        {
            if (!mouseDown)
                return;

            this.graphics.clear();
            this.graphics.lineStyle(10, 0xFF1493, 0.4);
            this.graphics.moveTo(startPoint.x, startPoint.y);
            this.graphics.lineTo(event.localX, event.localY);
        }
    }
}
