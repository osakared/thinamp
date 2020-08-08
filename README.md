# Thinamp

EARLY STAGE OF DEVELOPMENT, PROOF-OF-CONCEPT

Winamp-skin compatible client for MusicPD and other remote-controllable music players

Put a winamp classic skin in `skins/winamp.wsz` so that this can build. Many won't work yet because the bmp reader is only supporting 24-bit for now.

```
lix run openfl test PLATFORM
```

## TODO

* Get bmp reader supporting all common formats, possibly spin-off as separate lib
* Implement events on the buttons so I can start firing off pause, play, etc.
* Use my haxe-mpd lib to start controlling mpd!
* Support Winamp 3-style skins too