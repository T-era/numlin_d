import std.conv;
import std.algorithm;
import std.array;
import std.exception;
import std.string;

import common;
import field;
import cell;
import cross;
import rabit;
public import wall_impl;


abstract class Wall {
    int wallId = -1;
    Field field;
    int x;
    int y;
    State _state = State.Unknown;
    Listener[] listeners = [];
    bool grand = false;

    static VerWall createVerticalWall(Field field, int x, int y) {
        return new VerWall(field, x, y);
    }
    static HorWall createHorizontalWall(Field field, int x, int y) {
        return new HorWall(field, x, y);
    }
    this(Field field, int x, int y) {
        this.field = field;
        this.x = x;
        this.y = y;
    }
    void setState(State newState)
    in {
        enforce(this._state == State.Unknown || this._state == newState
            , { format("Exp %s->%s (%d,%d)", this._state, newState, this.x, this.y); });
        enforce(newState != State.Unknown, "%s".format(newState));
    }
    body {
        if (this._state != newState) {
            this._state = newState;
            if (newState == State.Wall) {
                setWallId(++ field.maxWallId);
            }
            wallDecided(newState);
            if (newState == State.Empty) {
                this.grandDecided();
            }
        }
        foreach (Listener l; listeners) {
            l.decided();
        }
    }
    void setWallId(int newValue) {
        this.wallId = newValue;
        foreach (Cross c; this.getBothCrosses()) {
            c.wallIdChain();
        }
    }
    void addListener(Listener listener) {
        listeners ~= listener;
    }

    void wallDecided(State newState) {
        foreach (Cell cell; this.getNeighborCells()) {
            if (cell !is null) {
                cell.wallDecided(newState);
            }
        }
        foreach (Cross cross; this.getBothCrosses()) {
            if (cross !is null) {
                cross.wallDecided(newState);
            }
        }
        if (newState == State.Empty) {
            ulong countOfGrand = this.getParaWalls()
                .remove!(w => w !is null && (state(w) != State.Empty || ! w.grand))
                .length;
            if (countOfGrand > 0) {
                this.setGrand();
            }
        }
    }
    void setGrand()
    in {
        enforce(state(this) == State.Empty, "%s isn't Empty (%d,%d)".format(this._state, x, y));
    }
    body {
        if (! this.grand) {
            this.grand = true;
            grandDecided();
        }
    }
    void grandDecided() {
        foreach (Wall w; this.getParaWalls()) {
            if (w !is null) {
                if (w.isBetweenGrand() && ! w.grand) {
                    w.setState(State.Empty);
                    w.setGrand();
                }
            }
        }
        foreach (Cell c; this.getNeighborCells()) {
            if (c !is null) c.grandDecided();
        }
    }
    bool isBetweenGrand() {
        return this.getParaWalls()
            .map!(w=> w is null || (state(w) == State.Empty && w.grand))
            .reduce!((a, b)=> a && b);
    }
    bool isBetweenSameId() {
        int[] minIds = this.getBothCrosses()
            .map!(c=> c.minWallId())
            .array();
        enforce(minIds.length == 2, "Length!!?");
        return minIds[0] == minIds[1] && minIds[0] != -1;
    }
    override string toString() {
        final switch(this._state) {
            case State.Unknown:
                return " ";
            case State.Empty:
                if (this.grand) {
                    return "x";
                } else {
                    return ".";
                }
            case State.Wall:
                return this.getWallString();
        }
    }

    abstract Wall[] getParaWalls();
    abstract Cell[] getNeighborCells();
    abstract Cross[] getBothCrosses();
    abstract string getWallString();
}
