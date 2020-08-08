package;

import haxe.io.BytesInput;
import haxe.io.Input;
import haxe.Resource;
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
    public var shufRepBitmap(default, null):BitmapData;
    public var titlebarBitmap(default, null):BitmapData;

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
                case 'shufrep.bmp':
                    skin.shufRepBitmap = BitmapData.fromImage(BMP.decode(data));
                case 'titlebar.bmp':
                    skin.titlebarBitmap = BitmapData.fromImage(BMP.decode(data));
                default:
                    trace(entry.fileName);
            }
        }
        return skin;
    }

    public static function fromResource(assetName:String):Skin
    {
        var bytes = Resource.getBytes(assetName);
        var input = new BytesInput(bytes);
        return fromInput(input);
    }

    #if (!js || hxnodejs)
    public static function fromFilename(filename:String):Skin
    {
        var input = File.read(filename);
        return fromInput(input);
    }
    #end
}