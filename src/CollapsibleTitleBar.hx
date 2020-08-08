package;

import openfl.display.Tile;
import openfl.geom.Rectangle;

class CollapsibleTitleBar extends Tile
{
    var focused:Bool = true;
    var collapsed:Bool = false;

    var focusedID:Int;
    var focusedAndCollapsedID:Int;
    var blurredID:Int;
    var blurredAndCollapsedID:Int;

    public function new(_focusedID:Int, _focusedAndCollapsedID:Int, _blurredID:Int, _blurredAndCollapsedID:Int)
    {
        super();

        focusedID = _focusedID;
        focusedAndCollapsedID = _focusedAndCollapsedID;
        blurredID = _blurredID;
        blurredAndCollapsedID = _blurredAndCollapsedID;

        x = y = 0;

        updateState();
    }

    private function updateState():Void
    {
        id = if (focused) {
            if (collapsed) focusedAndCollapsedID;
            else focusedID;
        } else {
            if (collapsed) blurredAndCollapsedID;
            else blurredID;
        }
    }
}