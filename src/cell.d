import std.conv;
import std.algorithm;
import std.array;
import std.exception;
import std.string;

import field;
import wall;
import common;
import rabit;

class Cell {
    Field field;
    int x;
    int y;
    int _number = -1;

    Listener[] listeners = [];

    this(Field field, int x, int y) {
        this.field = field;
        this.x = x;
        this.y = y;
    }
    void setNumber(int number)
    in {
        enforce(this._number == -1, "%d != -1".format(this._number));
        enforce(number != -1, "Illegal argument %d != -1".format(number));
    }
    body {
        enforce(this._number == -1, "%d != -1".format(this._number));
        enforce(number != -1, "Illegal argument %d != -1".format(number));
        this._number = number;
        this.numberDecided();
    }
    void numberDecided() {
        decided();
    }
    private void decided() {
        ulong countOfUnknown = this.walls()
            .remove!(w=> state(w) != State.Unknown)
            .length;
        ulong countOfWall = this.walls()
            .remove!(w=> state(w) != State.Wall)
            .length;
        if (countOfWall == this._number) {
            setIf(w=>state(w) == State.Unknown, State.Empty);
        } else if (countOfUnknown + countOfWall == this._number) {
            setIf(w=>state(w) == State.Unknown, State.Wall);
        }
        foreach (Listener l; listeners) {
            l.decided();
        }
    }
    void setIf(bool delegate(Wall) cond, State newState) {
        foreach (Wall w; this.walls().filter!(cond)) {
            if (w !is null) {
                w.setState(newState);
            }
        }
    }
    void wallDecided(State newState) {
        decided();
    }
    void grandDecided() {
        Wall[] emptyWalls = this.walls()
            .remove!(w=> w is null || state(w) != State.Empty);
        Wall[] grandWalls = emptyWalls
            .remove!(w => ! w.grand);
        if (grandWalls.length > 0) {
            foreach (Wall w; emptyWalls) {
                if (! w.grand) {
                    w.setGrand();
                }
            }
        }
    }

    Wall northWall() {
        return field.getHorWall(this.x, this.y);
    }
    Wall southWall() {
        return field.getHorWall(this.x, this.y+1);
    }
    Wall westWall() {
        return field.getVerWall(this.x, this.y);
    }
    Wall eastWall() {
        return field.getVerWall(this.x+1, this.y);
    }
    Wall[] walls() {
        return [
            this.northWall(),
            this.southWall(),
            this.westWall(),
            this.eastWall()];
    }
    void addListener(Listener listener) {
        listeners ~= listener;
    }

    override string toString() {
        if (_number == -1) {
            return " ";
        } else {
            return to!(string)(_number);
        }
    }
}
