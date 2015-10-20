import std.algorithm;
import std.array;
import std.conv;

import common;
import field;
import cross;
import wall;

class Position {
    int x;
    int y;
    this(int x, int y) {
        this.x = x;
        this.y = y;
    }
    override hash_t toHash() {
        return x * 13
            + y * 17;
    }
    override bool opEquals(Object arg) {
        Position pos = cast(Position)arg;
        return pos
            && this.x == pos.x
            && this.y == pos.y;
    }
    override int opCmp(Object arg) {
        Position pos = cast(Position)arg;
        if (pos) {
            if (this.x == pos.x) {
                return this.y - pos.y;
            } else {
                return this.x - pos.y;
            }
        }
        return -1;
    }
    override string toString() {
        return "(" ~ to!(string)(x)  ~ ", " ~ to!(string)(y) ~ ")";
    }
}

class DeadEnd {
    private bool[Position] checked;
    private Field field;

    this(Field field) {
        this.field = field;
    }
    private bool isChecked(Position pos) {
        return (pos in checked) !is null
            && checked[pos];
    }
    private bool isDeadEnd(Wall w, Cross cross) {
        Cross firstCross = w.getBothCrosses()
            .remove!(c=> c == cross)[0];
        checked[toPos(cross)] = true;
        return ! findAnotherEdge(firstCross);
    }
    private bool findAnotherEdge(Cross cross) {
        if (isChecked(toPos(cross))) {
            return false;
        }
        checked[toPos(cross)] = true;
        ulong countOfWall = cross.walls()
            .remove!(w=> state(w) != State.Wall)
            .length;

        if (countOfWall == 1) {
            return true;
        } else {
            Cross[] neighbors = neighborCrosses(cross);
            foreach (Cross n; neighbors) {
                if (findAnotherEdge(n)) {
                    return true;
                }
            }
            return false;
        }
    }
    Cross[] neighborCrosses(Cross cross) {
        Cross[] ret = [];
        addIf(ret, cross.northWall(), cross.x, cross.y - 1);
        addIf(ret, cross.southWall(), cross.x, cross.y + 1);
        addIf(ret, cross.westWall(), cross.x - 1, cross.y);
        addIf(ret, cross.eastWall(), cross.x + 1, cross.y);

        return ret;
    }
    void addIf(ref Cross[] list, Wall wall, int x, int y) {
        if (state(wall) == State.Unknown) {
            list ~= field.getCross(x, y);
        }
    }

    static void bury(Field field) {
        foreach (Cross[] line; field.crosses) {
            foreach (Cross c; line) {
                ulong countOfWall = c.walls()
                    .remove!(w=> state(w) != State.Wall)
                    .length;
                if (countOfWall == 1) {
                    foreach (Wall w; c.walls()) {
                        if (state(w) == State.Unknown
                            && new DeadEnd(field).isDeadEnd(w, c)) {
                            w.setState(State.Empty);
                        }
                    }
                }
            }
        }
    }
    private static Position toPos(Cross cr) {
        return new Position(cr.x, cr.y);
    }
}
