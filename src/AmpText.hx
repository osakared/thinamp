package;

import openfl.Assets;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;

class AmpText extends Sprite
{
    var textField = new TextField();

    var textLength:Int;
    var text:String;
    var currentPosition:Int = 0;
    var scrolling:Bool;

    public function new(textLength:Int, width:Int, height:Int, color:Int, scrolling:Bool)
    {
        super();

        this.scrolling = scrolling;

        // this.width = width * 1.5;
        // this.height = height * 1.5;

        this.textLength = textLength;

        var emptyText = '';
        for (i in 0...(textLength+1)) emptyText += 'a';
        textField.text = emptyText;
        // All width and height seem to do is clip so just give the fields some extra breathing room
        textField.width = width * 1.5;
        textField.height = height * 1.5;
        // textField.autoSize = TextFieldAutoSize.LEFT;
        textField.textColor = color;
        textField.background = false;
        textField.type = TextFieldType.DYNAMIC;
        textField.border = false;
        var textFormat = new TextFormat();
        // textFormat.size = 10;
        textFormat.font = Assets.getFont('fonts/osakamono.ttf').fontName;
        textField.setTextFormat(textFormat);
        textField.selectable = false;

        var scaleX:Float = width / textField.textWidth;
        var scaleY:Float = height / textField.textHeight;
        textField.scaleX = scaleX;
        textField.scaleY = scaleY;
        textField.text = '';

        if (scrolling) {
            addEventListener(Event.ENTER_FRAME, (event) -> {
                if (textLength > text.length) return;
                currentPosition++;
                if (currentPosition == text.length) currentPosition = 0;
                wrapText();
            });
        }

        addChild(textField);
    }

    private function wrapText():Void
    {
        var remainingInString = text.length - currentPosition;
        var fromRemainingString = remainingInString > textLength ? textLength : remainingInString;
        var fromStart = textLength - fromRemainingString;
        textField.text = text.substr(currentPosition, fromRemainingString) + text.substr(0, fromStart);
    }

    public function setText(text:String):Void
    {
        if (scrolling) {
            this.text = text.toUpperCase();
            currentPosition = 0;
            if (text.length > textLength) this.text += ' *** ';
            else textField.text = this.text;
        }
        else {
            this.text = text;
            // Add elipses if it's too long
        }
    }
}