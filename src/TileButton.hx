package;

import openfl.display.Tile;
import openfl.geom.Rectangle;

class TileButton extends Tile
{
    var upID:Int;
    var downID:Int;
    public var hitArea(default, null):Rectangle;

    public function new(_upID:Int, _downID:Int, _hitArea:Rectangle)
    {
        super();

        downID = _downID;
        upID = _upID;
        hitArea = _hitArea;

        x = hitArea.x;
        y = hitArea.y;
        
        id = upID;
    }

    public function press():Void
    {
        id = downID;
    }

    public function release():Void
    {
        id = upID;
    }
}