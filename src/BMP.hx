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
        if (data.header.bpp <= 8) {
            var colorTable = new Array<Int>();
            var colorTableInput = new BytesInput(data.colorTable);
            for (_ in 0...Std.int(data.colorTable.length / 4)) {
                colorTable.push(colorTableInput.readInt24() << 8);
                colorTableInput.readByte();
            }
            var x = 0;
            var y = data.header.topToBottom ? 0 : data.header.height - 1;
            while (input.length > input.position) {
                var count = input.readByte();
                var index = input.readByte();
                if (count == 0) {
                    if (index == 0) {
                        x = 0;
                        y += data.header.topToBottom ? 1 : -1;
                    } else if (index == 1) {
                        break;
                    } else if (index == 2) {
                        x += input.readByte();
                        y += input.readByte();
                    } else {
                        count = index;
                        for (i in 0...count) {
                            index = input.readByte();
                            image.setPixel(x + i, y, colorTable[index], RGBA32);
                        }
                        if (input.position % 2 != 0) input.readByte();
                        x += count;
                    }
                } else {
                    for (i in 0...count) {
                        image.setPixel(x + i, y, colorTable[index], RGBA32);
                    }
                    x += count;
                }
            }
        } else {
            for (iterY in 0...data.header.height) {
                var y = data.header.topToBottom ? iterY : data.header.height - iterY - 1;
                for (x in 0...data.header.width) {
                    if (data.header.bpp == 16) {
                        image.setPixel(x, y, input.readInt24() << 8, RGBA32);
                    } else if (data.header.bpp == 24) {
                        image.setPixel(x, y, input.readInt24() << 8, RGBA32);
                    } else if (data.header.bpp == 32) {
                        image.setPixel(x, y, input.readInt32(), RGBA32);
                    }
                }
                input.read(padding);
            }
        }
        return image;
    }
}
