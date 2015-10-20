import std.conv;
import std.algorithm;
import std.array;

import common;
import field;
import cell;
import cross;
import rabit;
import wall;

class HorWall :Wall {
    this(Field field, int x, int y) {
        super(field, x, y);
    }

    override Wall[] getParaWalls() {
        return [
            field.getHorWall(x, y - 1),
            field.getHorWall(x, y + 1)];
    }
    override Cross[] getBothCrosses() {
        return [
            field.getCross(x, y),
            field.getCross(x+1, y)];
    }
    override Cell[] getNeighborCells() {
        return [
            field.getCell(x, y-1),
            field.getCell(x, y)];
    }
    override string getWallString() {
        return "-";
    }
}
class VerWall :Wall {
    this(Field field, int x, int y) {
        super(field, x, y);
    }

    override Wall[] getParaWalls() {
        return [
            field.getVerWall(x - 1, y),
            field.getVerWall(x + 1, y)];
    }
    override Cross[] getBothCrosses() {
        return [
            field.getCross(x, y),
            field.getCross(x, y+1)];
    }
    override Cell[] getNeighborCells() {
        return [
            field.getCell(x-1, y),
            field.getCell(x, y)];
    }
    override string getWallString() {
        return "|";
    }
}
