package;

import haxe.io.BytesInput;
import haxe.io.Input;
import haxe.Resource;
import haxe.zip.Reader;
import openfl.display.BitmapData;
#if sys
import sys.io.File;
#end

class Skin
{
    public var cButtonsBitmap(default, null):BitmapData;
    public var eqBitmap(default, null):BitmapData;
    public var mainBitmap(default, null):BitmapData;
    public var shufRepBitmap(default, null):BitmapData;
    public var titlebarBitmap(default, null):BitmapData;

    public var normalTextColor:Int = 0xa6c1df;
    public var currentTextColor:Int = 0xeeeeee;
    public var normalBGColor:Int = 0x000000;
    public var selectedBGColor:Int = 0x666666;
    public var fontName:String = 'helvetica';
    public var miniBrowserBGColor:Int = 0xeeeeee;
    public var miniBrowserFGColor:Int = 0x666666;

    private function new()
    {
    }

    private function processPledit(text:String):Void
    {
        var pairMatcher = ~/^(\w+)\s*=\s*#(\w+)\s*$/;
        for (line in text.split('\n')) {
            if (pairMatcher.match(line)) {
                trace('${line}\n\tcolor: 0x${pairMatcher.matched(2)}\n\t${pairMatcher.matched(1).toLowerCase()}');
                var val:Int = Std.parseInt('0x${pairMatcher.matched(2)}');
                switch pairMatcher.matched(1).toLowerCase() {
                    case 'normal':
                        normalTextColor = val;
                    case 'current':
                        currentTextColor = val;
                    case 'normalbg':
                        normalBGColor = val;
                    case 'selectedbg':
                        selectedBGColor = val;
                    case 'font':
                        fontName = pairMatcher.matched(2);
                    case 'mbbg':
                        miniBrowserBGColor = val;
                    case 'mbfg':
                        miniBrowserFGColor = val;
                }
            }
            else {
                trace('Line didn\'t match: ${line}');
            }
        }
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
                case 'pledit.txt':
                    skin.processPledit(data.toString());
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

    #if sys
    public static function fromFilename(filename:String):Skin
    {
        var input = File.read(filename);
        return fromInput(input);
    }
    #end
}