package;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;

class AmpWindow extends Sprite
{
    var titleRect = new Rectangle(0, 0, 275, 14);
    var startClickX:Float = 0;
    var startClickY:Float = 0;
    var dragging = false;

    private function onAdd(event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAdd);
        stage.addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent) {
            if (titleRect.contains(event.stageX, event.stageY)) {
                dragging = true;
                startClickX = event.localX;
                startClickY = event.localY;    
            }
        });

        stage.addEventListener(MouseEvent.MOUSE_UP, function(event:MouseEvent) {
            dragging = false;
        });

        stage.addEventListener(MouseEvent.MOUSE_MOVE, function(event:MouseEvent) {
            if (dragging) {
                stage.window.move(stage.window.x + Std.int(event.localX - startClickX), stage.window.y + Std.int(event.localY - startClickY));
            }
        });
    }

    public function new()
    {
        super();
        addEventListener(Event.ADDED_TO_STAGE, onAdd);
	}

    public function initSkin(skin:Skin):Void
    {
    }
}