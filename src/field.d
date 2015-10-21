import cell;
import wall;
import cross;
import rabit;

class Field {
    int maxWallId = 0;
    int width;
    int height;
    Cell[][] cells;
    VerWall[][] verWalls;
    HorWall[][] horWalls;
    Cross[][] crosses;

    void setSize(int width, int height) {
        this.maxWallId = 0;
        this.width = width;
        this.height = height;
        cells = doubleArray(width, height, (x,y)=> new Cell(this, x, y));
        verWalls = doubleArray(width + 1, height, (x,y)=> Wall.createVerticalWall(this, x, y));
        horWalls = doubleArray(width, height + 1, (x,y)=> Wall.createHorizontalWall(this, x, y));
        crosses = doubleArray(width + 1, height + 1, (x,y)=> new Cross(this, x, y));
        initRabitHeads(cells);
    }

    void initRabitHeads(Cell[][] cells) {
        for (int y = 0; y < height; y ++) {
            for (int x = 0; x < width; x ++) {
                Cell c = cells[y][x];

                new RabitHead(c,
                    getHorWall(x - 1, y),
                    getVerWall(x, y - 1),
                    c.northWall(),
                    c.westWall());
                new RabitHead(c,
                    getHorWall(x + 1, y),
                    getVerWall(x + 1, y - 1),
                    c.northWall(),
                    c.eastWall());
                new RabitHead(c,
                    getHorWall(x - 1, y + 1),
                    getVerWall(x, y + 1),
                    c.southWall(),
                    c.westWall());
                new RabitHead(c,
                    getHorWall(x + 1, y + 1),
                    getVerWall(x + 1, y + 1),
                    c.southWall(),
                    c.eastWall());
            }
        }

    }
    Wall getVerWall(int x, int y) {
        if (0 <= x && x <= width
            && 0 <= y && y < height) {
            return this.verWalls[y][x];
        } else {
            return null;
        }
    }
    Wall getHorWall(int x, int y) {
        if (0 <= x && x < width
            && 0 <= y && y <= height) {
            return this.horWalls[y][x];
        } else {
            return null;
        }
    }
    Cell getCell(int x, int y) {
        if (0 <= x && x < width
            && 0 <= y && y < height) {
            return this.cells[y][x];
        } else {
            return null;
        }
    }
    Cross getCross(int x, int y) {
        if (0 <= x && x <= width
            && 0 <= y && y <= height) {
            return this.crosses[y][x];
        } else {
            return null;
        }
    }

    private static T[][] doubleArray(T)(int width, int height, T delegate(int, int) gen) {
        T[][] ret = [];
        ret.length = height;
        for (int y = 0; y < height; y ++) {
            ret[y] = singleArray(y, width, gen);
        }
        return ret;
    }
    private static T[] singleArray(T)(int y, int width, T delegate(int, int) gen) {
        T[] ret = [];
        ret.length = width;
        for (int x = 0; x < width; x ++) {
            ret[x] = gen(x, y);
        }
        return ret;
    }

    override string toString() {
        string ret = "";
        for (int y = 0; y < 2 * height + 1; y ++) {
            for (int x = 0; x < 2 * width + 1; x ++) {
                if (y % 2) {
                    if (x % 2) {
                        ret ~= cells[y / 2][x / 2].toString();
                    } else {
                        ret ~= verWalls[y / 2][x / 2].toString();
                    }
                } else {
                    if (x % 2) {
                        ret ~= horWalls[y / 2][x / 2].toString();
                    } else {
                        ret ~= crosses[y / 2][x / 2].toString();
                    }
                }
            }
            ret ~= "\n";
        }
        return ret;
    }
}
