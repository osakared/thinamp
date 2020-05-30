package;

import format.bmp.Reader;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import lime.graphics.Image;

class BMP
{   
    public static function decode(bytes:Bytes):Image
    {
        var input = new BytesInput(bytes);
        var reader = new Reader(input);
        var data = reader.read();

        var image = new Image(null, 0, 0, data.header.width, data.header.height, 0xff);
        input = new BytesInput(data.pixels);
        var padding = Std.int(data.header.paddedStride - ((data.header.bpp * data.header.width) / 32) * 4);
        for (iterY in 0...data.header.height) {
            var y = data.header.topToBottom ? iterY : data.header.height - iterY - 1;
            for (x in 0...data.header.width) {
                image.setPixel(x, y, input.readInt24() << 8, RGBA32);
            }
            input.read(padding);
        }
        return image;
    }
}
