package;

import flash.geom.Rectangle;
import openfl.display.Bitmap;
import openfl.display.Tilemap;
import openfl.display.Tileset;
// import openfl.display.Window;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;

class MainWindow extends AmpWindow
{
    private var buttons = new Array<TileButton>();

    // handy pointers to certain buttons, also in above array
    private var playButton:TileButton = null;
    private var pauseButton:TileButton = null;

    private var titleBar:CollapsibleTitleBar = null;

    private var currentButton:TileButton = null;

    public function new()
    {
        super();

        var skin = Skin.fromResource('skins/winamp.wsz');
        initSkin(skin);

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

        // FIXME adding windows seems to create a jankiness, probably multiple event issue
        // var eqContainingWindow = stage.application.createWindow({borderless: true, resizable: false, width: stage.window.width, height: stage.window.height});
        // var eqWindow = new EQWindow();
        // eqContainingWindow.stage.addChild(eqWindow);
        // eqWindow.initSkin(skin);
    }

    private static function addButton(tileset:Tileset, tilemap:Tilemap, buttons:Array<TileButton>, placement:Rectangle,
        up:Rectangle, down:Rectangle):TileButton
    {
        var upID = tileset.addRect(up);
        var downID = tileset.addRect(down);

        var button = new TileButton(upID, downID, placement);
        tilemap.addTile(button);
        buttons.push(button);
        return button;
    }

    private static function addToggleButton(tileset:Tileset, tilemap:Tilemap, buttons:Array<TileButton>, placement:Rectangle,
        up:Rectangle, down:Rectangle, toggleUp:Rectangle, toggleDown:Rectangle):TileButton
    {
        var upID = tileset.addRect(up);
        var downID = tileset.addRect(down);
        var toggleUpID = tileset.addRect(toggleUp);
        var toggleDownID = tileset.addRect(toggleDown);

        var button = new TileButton(upID, downID, placement, toggleUpID, toggleDownID);

        // Temporary - for testing. Simple toggle until we can have this just reflecting the state from the server
        var isToggled = false;
        button.onPress = () -> {
            isToggled = !isToggled;
            button.setToggled(isToggled);
        }

        tilemap.addTile(button);
        buttons.push(button);
        return button;
    }

    public override function initSkin(skin:Skin):Void
    {
        // Think about how you're gonna make swapping skins instant/painless
        var bitmap = new Bitmap(skin.mainBitmap);
        addChild(bitmap);
        bitmap.x = bitmap.y = 0;

        var newButtons = new Array<TileButton>();

        var transportTileset = new Tileset(skin.cButtonsBitmap);
        var transportTilemap = new Tilemap(Std.int(stage.width), Std.int(stage.height), transportTileset, false);

        var startRect = new Rectangle(16, 88, 23, 18);
        // back button
        addButton(transportTileset, transportTilemap, newButtons, startRect,
            new Rectangle(0, 0, startRect.width, startRect.height),
            new Rectangle(0, startRect.height, startRect.width, startRect.height));
        // play button
        playButton = addButton(transportTileset, transportTilemap, newButtons,
            new Rectangle(startRect.x + startRect.width, startRect.y, startRect.width, startRect.height),
            new Rectangle(startRect.width, 0, startRect.width, startRect.height),
            new Rectangle(startRect.width, startRect.height, startRect.width, startRect.height));
        // pause button
        pauseButton = addButton(transportTileset, transportTilemap, newButtons,
            new Rectangle(startRect.x + startRect.width * 2, startRect.y, startRect.width, startRect.height),
            new Rectangle(startRect.width * 2, 0, startRect.width, startRect.height),
            new Rectangle(startRect.width * 2, startRect.height, startRect.width, startRect.height));
        // This stuff is for testing; when we hook this up with musicpd, it will only be toggled by state received from the server
        var isToggled = false;
        pauseButton.onPress = () -> {
            isToggled = !isToggled;
            pauseButton.setToggled(isToggled);
        }
        // stop button
        addButton(transportTileset, transportTilemap, newButtons,
            new Rectangle(startRect.x + startRect.width * 3, startRect.y, startRect.width, startRect.height),
            new Rectangle(startRect.width * 3, 0, startRect.width, startRect.height),
            new Rectangle(startRect.width * 3, startRect.height, startRect.width, startRect.height));
        // forward button
        var forwardRect = new Rectangle(startRect.x + startRect.width * 4, startRect.y, 22, startRect.height);
        addButton(transportTileset, transportTilemap, newButtons, forwardRect,
            new Rectangle(startRect.width * 4, 0, forwardRect.width, startRect.height),
            new Rectangle(startRect.width * 4, startRect.height, forwardRect.width, startRect.height));
        // eject button
        var ejectRect = new Rectangle(136, 89, 22, 16);
        addButton(transportTileset, transportTilemap, newButtons, ejectRect,
            new Rectangle(startRect.width * 4 + forwardRect.width, 0, ejectRect.width, ejectRect.height),
            new Rectangle(startRect.width * 4 + forwardRect.width, ejectRect.height, ejectRect.width, ejectRect.height));

        addChild(transportTilemap);

        var shufRepTileset = new Tileset(skin.shufRepBitmap);
        var shufRepTilemap = new Tilemap(Std.int(stage.width), Std.int(stage.height), shufRepTileset, false);

        startRect = new Rectangle(0, 0, 28, 15);
        // repeat toggle button
        addToggleButton(shufRepTileset, shufRepTilemap, newButtons, new Rectangle(211, 89, startRect.width, startRect.height),
            startRect, new Rectangle(startRect.x, startRect.height, startRect.width, startRect.height),
            new Rectangle(startRect.x, startRect.height * 2, startRect.width, startRect.height),
            new Rectangle(startRect.x, startRect.height * 3, startRect.width, startRect.height));
        // shuffle toggle button
        startRect = new Rectangle(28, 0, 47, 15);
        addToggleButton(shufRepTileset, shufRepTilemap, newButtons, new Rectangle(164, 89, startRect.width, startRect.height),
            startRect, new Rectangle(startRect.x, startRect.height, startRect.width, startRect.height),
            new Rectangle(startRect.x, startRect.height * 2, startRect.width, startRect.height),
            new Rectangle(startRect.x, startRect.height * 3, startRect.width, startRect.height));
        // equalizer toggle button
        startRect = new Rectangle(0, 61, 23, 12);
        addToggleButton(shufRepTileset, shufRepTilemap, newButtons, new Rectangle(219, 58, startRect.width, startRect.height),
            startRect, new Rectangle(startRect.width * 2, startRect.y, startRect.width, startRect.height),
            new Rectangle(startRect.x, startRect.y + startRect.height, startRect.width, startRect.height),
            new Rectangle(startRect.width * 2, startRect.y + startRect.height, startRect.width, startRect.height));
        // playlist toggle button
        startRect = new Rectangle(23, 61, 23, 12);
        addToggleButton(shufRepTileset, shufRepTilemap, newButtons, new Rectangle(242, 58, startRect.width, startRect.height),
            startRect, new Rectangle(startRect.x + startRect.width * 2, startRect.y, startRect.width, startRect.height),
            new Rectangle(startRect.x, startRect.y + startRect.height, startRect.width, startRect.height),
            new Rectangle(startRect.x + startRect.width * 2, startRect.y + startRect.height, startRect.width, startRect.height));
        
        addChild(shufRepTilemap);

        var titlebarTileset = new Tileset(skin.titlebarBitmap);
        var titlebarTilemap = new Tilemap(Std.int(stage.width), Std.int(stage.height), titlebarTileset, false);

        startRect = new Rectangle(27, 0, 275, 14);
        var focusedID = titlebarTileset.addRect(startRect);
        startRect.y = startRect.height + 2;
        var blurredID = titlebarTileset.addRect(startRect);
        startRect.y += startRect.height + 1;
        var focusedAndCollapsedID = titlebarTileset.addRect(startRect);
        startRect.y += startRect.height + 1;
        var blurredAndCollapsedID = titlebarTileset.addRect(startRect);

        titleBar = new CollapsibleTitleBar(focusedID, focusedAndCollapsedID, blurredID, blurredAndCollapsedID);
        titlebarTilemap.addTile(titleBar);

        // menu button
        startRect = new Rectangle(0, 0, 9, 9);
        addButton(titlebarTileset, titlebarTilemap, newButtons, new Rectangle(6, 3, startRect.width, startRect.height),
            startRect, new Rectangle(startRect.x, startRect.y + startRect.height, startRect.width, startRect.height));
        // minimize button
        startRect.x += startRect.width;
        addButton(titlebarTileset, titlebarTilemap, newButtons, new Rectangle(244, 3, startRect.width, startRect.height),
            startRect, new Rectangle(startRect.x, startRect.y + startRect.height, startRect.width, startRect.height));
        // close button
        startRect.x += startRect.width;
        var closeButton = addButton(titlebarTileset, titlebarTilemap, newButtons, new Rectangle(264, 3, startRect.width, startRect.height),
            startRect, new Rectangle(startRect.x, startRect.y + startRect.height, startRect.width, startRect.height));
        closeButton.onPress = () -> {
            openfl.system.System.exit(0);
        }
        // collapse button
        startRect = new Rectangle(0, 18, 9, 9);
        addButton(titlebarTileset, titlebarTilemap, newButtons, new Rectangle(254, 3, startRect.width, startRect.height),
            startRect, new Rectangle(startRect.x + startRect.width, startRect.y, startRect.width, startRect.height));
        // expand button
        // startRect = new Rectangle(0, 27, 9, 9);
        // addButton(titlebarTileset, titlebarTilemap, newButtons, new Rectangle(264, 3, startRect.width, startRect.height),
        //     startRect, new Rectangle(startRect.x + startRect.width, startRect.y, startRect.width, startRect.height));

        addChild(titlebarTilemap);

        buttons = newButtons;
    }
}