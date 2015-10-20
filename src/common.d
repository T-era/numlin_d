import wall;
import cell;

enum State {
    Unknown, Empty, Wall
}

State state(Wall wall) {
    if (wall is null) return State.Empty;
    else return wall._state;
}
int number(Cell cell) {
    if (cell is null) return -1;
    else return cell._number;
}
