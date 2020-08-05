package;

import format.bmp.Reader;
import format.bmp.Tools;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import lime.graphics.Image;
import lime.math.Rectangle;

class BMP
{   
    public static function decode(bytes:Bytes):Image
    {
        var input = new BytesInput(bytes);
        var reader = new Reader(input);
        var data = reader.read();

        var image = new Image(null, 0, 0, data.header.width, data.header.height);
        image.setPixels(new Rectangle(0, 0, data.header.width, data.header.height), Tools.extractARGB(data), ARGB32, BIG_ENDIAN);
        return image;
    }
}
