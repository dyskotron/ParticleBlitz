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

        private var mouseDown: Boolean = false;
        private var startPoint: Point = new Point();
        private var _width: Number;
        private var _height: Number;

        public function DirectionEditor(width: Number, height: Number)
        {
            var mouseSprite: Sprite = new Sprite();
            addChild(mouseSprite);
            mouseSprite.graphics.beginFill(0x000000, 0);
            mouseSprite.graphics.drawRect(0, 0, width, height);

            mouseSprite.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            mouseSprite.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
            mouseSprite.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);

            _width = width;
            _height = height;
        }

        public function get emmiterX(): Number
        {
            return startPoint.x;
        }

        public function get emmiterY(): Number
        {
            return startPoint.y;
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

            xDirection = (event.localX - startPoint.x) / _width;
            yDirection = (event.localY - startPoint.y) / _height;

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
