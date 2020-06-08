package;

import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import lime.app.Application;
import lime.graphics.Image;
import sys.io.File;

class RunTests extends Application
{
    public function new()
    {
        super();
    }

    public static function main()
    {
		// var app = new RunTests();
        // return app.exec();
        
        // var image = new Image(null, 0, 0, 100, 100, 0xFFCCFF);
        // var bytes = BMP.encode(image);
        // var output = new BytesOutput();
        // output.write(bytes);
        // output.close();
        // var image2 = BMP.decode(output.getBytes());

        var input = File.read('~/Downloads/Winamp/cbuttons.bmp');
        var image3 = BMP.decode(input.readAll());
        var output = File.write('main.png');
        output.write(image3.encode());
        output.close();
	}
}