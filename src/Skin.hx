package;

import haxe.io.Input;
import haxe.zip.Reader;
import openfl.display.BitmapData;
#if (!js || hxnodejs)
import sys.io.File;
#end

class Skin
{
    public var cButtonsBitmap(default, null):BitmapData;
    public var eqBitmap(default, null):BitmapData;
    public var mainBitmap(default, null):BitmapData;

    private function new()
    {
    }

    public static function fromInput(input:Input):Skin
    {
        var skin = new Skin();
        for (entry in Reader.readZip(input)) {
            var data = Reader.unzip(entry);
            if (data == null) {
                throw 'Can\'t uncompress ${entry.fileName}';
            }
            switch entry.fileName.toLowerCase() {
                case 'cbuttons.bmp':
                    skin.cButtonsBitmap = BitmapData.fromImage(BMP.decode(data));
                case 'eqmain.bmp':
                    skin.eqBitmap = BitmapData.fromImage(BMP.decode(data));
                case 'main.bmp':
                    skin.mainBitmap = BitmapData.fromImage(BMP.decode(data));
                default:
                    trace('*');
            }
        }
        return skin;
    }

    public static function fromFilename(filename:String):Skin
    {
        #if (!js || hxnodejs)
        var input = File.read(filename);
        return fromInput(input);
        #else
        return null; // let's get something from assets in this case
        #end
    }
}