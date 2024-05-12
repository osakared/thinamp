package state;

import mpd.MusicPD;

class MPDAdapter
{
    var connection:MusicPD;
    var state:Player;

    public function new(state:Player, connection:MusicPD) {
        this.connection = connection;
        this.state = state;
    }

    public function callback() {
        connection.idle(/*[mpd.Subsystem.PlayerSubsystem, mpd.Subsystem.PlaylistSubsystem]*/).handle((outcome) -> {
            var values = [];
            switch outcome {
                case Success(response):
                    values = response.values;
                case Failure(error):
                    trace(error);
            }
            for (value in values) {
                if (value.value == 'player' && value.name == 'changed') {
                    getState();
                    return;
                }
            }
            callback();
        });
    }

    private function getState() {
        connection.getStatus().handle((outcome) -> {
            switch outcome {
                case Success(status):
                    switch (status.state) {
                        case Play:
                            state.state = Playing;
                        case Stop:
                            state.state = Stopped;
                        case Pause:
                            state.state = Paused;
                    }
                case Failure(error):
                    trace(error);
            }
            callback();
        });
    }
}