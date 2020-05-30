package;

import openfl.display.Bitmap;
import openfl.display.Tilemap;
import openfl.display.Tileset;
// import openfl.display.Window;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;

class MainWindow extends AmpWindow
{
    public function new()
    {
        super();

        var skin = Skin.fromFilename('./skins/Neoclassic_V_1_2.wsz');
        initSkin(skin);

        // FIXME adding windows seems to create a jankiness, probably multiple event issue
        // var eqContainingWindow = stage.application.createWindow({borderless: true, resizable: false, width: stage.window.width, height: stage.window.height});
        // var eqWindow = new EQWindow();
        // eqContainingWindow.stage.addChild(eqWindow);
        // eqWindow.initSkin(skin);
    }
    
    public override function initSkin(skin:Skin):Void
    {
        var bitmap = new Bitmap(skin.mainBitmap);
        addChild(bitmap);
        bitmap.x = bitmap.y = 0;

        var tileset = new Tileset(skin.cButtonsBitmap);

        var backRect = new Rectangle(16, 88, 23, 18);
        var backUpID = tileset.addRect(new Rectangle(0, 0, backRect.width, backRect.height));
        var backDownID = tileset.addRect(new Rectangle(0, backRect.height, backRect.width, backRect.height));
        var playRect = new Rectangle(backRect.x + backRect.width, backRect.y, backRect.width, backRect.height);
        var playUpID = tileset.addRect(new Rectangle(backRect.width, 0, playRect.width, playRect.height));
        var playDownID = tileset.addRect(new Rectangle(backRect.width, playRect.height, playRect.width, playRect.height));

        var tilemap = new Tilemap(Std.int(stage.width), Std.int(stage.height), tileset, false);
        addChild(tilemap);

        var buttons = new Array<TileButton>();

        var backButton = new TileButton(backUpID, backDownID, backRect);
        tilemap.addTile(backButton);
        buttons.push(backButton);
        var playButton = new TileButton(playUpID, playDownID, playRect);
        tilemap.addTile(playButton);
        buttons.push(playButton);

        var currentButton:TileButton = null;
        stage.addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent) {
            for (button in buttons) {
                if (button.hitArea.contains(event.stageX, event.stageY)) {
                    currentButton = button;
                    break;
                }
            }
            if (currentButton != null) currentButton.press();
        });

        stage.addEventListener(MouseEvent.MOUSE_UP, function(event:MouseEvent) {
            if (currentButton != null) {
                currentButton.release();
                currentButton = null;
            }
        });
    }
}