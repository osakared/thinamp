package state;

import coconut.data.Model;

enum TransportState {
    Playing;
    Stopped;
    Paused;
}

class Player implements Model
{
    @:editable var state:TransportState;

    static function new() {
        this = {
            state: Stopped
        };
    }
}