package;

import openfl.display.Tile;
import openfl.geom.Rectangle;

class TileButton extends Tile
{
    var isPressed:Bool = false;
    var isToggled:Bool = false;
    var upID:Int;
    var downID:Int;
    var toggledUpID:Int;
    var toggledDownID:Int;
    public var onPress:()->Void = null;
    public var hitArea(default, null):Rectangle;

    public function new(_upID:Int, _downID:Int, _hitArea:Rectangle, ?_toggledUpID:Int, ?_toggledDownID:Int)
    {
        super();

        downID = _downID;
        upID = _upID;

        if (_toggledUpID != null && _toggledDownID != null) {
            toggledUpID = _toggledUpID;
            toggledDownID = _toggledDownID;
        }
        // Default to pause button sort of behavior
        else {
            toggledUpID = toggledDownID = downID;
        }

        hitArea = _hitArea;

        x = hitArea.x;
        y = hitArea.y;
        
        updateID();
    }

    public function updateID():Void
    {
        id = if (isToggled) {
            if (isPressed) toggledDownID;
            else toggledUpID;
        } else {
            if (isPressed) downID;
            else upID;
        }
    }

    public function press():Void
    {
        isPressed = true;
        updateID();
    }

    public function release():Void
    {
        isPressed = false;
        updateID();
        if (onPress != null) onPress();
    }

    public function setToggled(_isToggled:Bool):Void
    {
        isToggled = _isToggled;
        updateID();
    }
}