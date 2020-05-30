package;

import openfl.display.Bitmap;
import openfl.display.BitmapData;

class EQWindow extends AmpWindow
{
    public function new()
    {
        super();
    }

    public override function initSkin(skin:Skin):Void
    {
        var bitmap = new Bitmap(skin.eqBitmap);
        addChild(bitmap);
        bitmap.x = bitmap.y = 0;
    }
}