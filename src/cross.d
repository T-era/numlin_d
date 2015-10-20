import std.conv;
import std.algorithm;
import std.array;

import common;
import wall;
import field;

class Cross {
    private Field field;
    int x;
    int y;

    this(Field field, int x, int y) {
        this.field = field;
        this.x = x;
        this.y = y;

    }
    void wallDecided(State newState) {
        Wall[] unknownWalls = this.walls()
            .remove!(w=> state(w) != State.Unknown);
        ulong countOfUnknown = unknownWalls.length;
        ulong countOfWall = this.walls()
            .remove!(w=> state(w) != State.Wall)
            .length;
        if (countOfWall == 2) {
            foreach (Wall w; unknownWalls) {
                w.setState(State.Empty);
            }
        } else if (countOfWall == 1) {
            if (countOfUnknown == 1) {
                unknownWalls[0].setState(State.Wall);
            }
            if (newState == State.Wall
                && this.minWallId() > 1) {
                foreach (Wall w; unknownWalls) {
                    if (this.minWallId() > 1
                        && w.isBetweenSameId()) {
                        w.setState(State.Empty);
                    }
                }
            }
        } else {
            if (countOfUnknown == 1) {
                unknownWalls[0].setState(State.Empty);
            }
        }
    }
    int minWallId() {
        Wall[] fillWalls = this.walls()
            .remove!(w => state(w) != State.Wall);
        if (fillWalls.length > 0) {
            return fillWalls
                .map!(w => w.wallId)
                .reduce!((a, b) => a > b ? b : a);
        } else {
            return -1;
        }
    }

    void wallIdChain() {
        Wall[] fillWalls = this.walls()
            .remove!(w => state(w) != State.Wall);
        int minWallId = fillWalls
            .map!(w => w.wallId)
            .reduce!((a, b) => a > b ? b : a);
        foreach (Wall w; fillWalls) {
            if (w.wallId > minWallId) {
                w.setWallId(minWallId);
            }
        }
    }

    Wall[] walls() {
        return [
            this.northWall(),
            this.southWall(),
            this.westWall(),
            this.eastWall()];
    }
    Wall northWall() {
        return field.getVerWall(this.x, this.y-1);
    }
    Wall southWall() {
        return field.getVerWall(this.x, this.y);
    }
    Wall westWall() {
        return field.getHorWall(this.x-1, this.y);
    }
    Wall eastWall() {
        return field.getHorWall(this.x, this.y);
    }
    override string toString() {
        return "+";
    }
}
