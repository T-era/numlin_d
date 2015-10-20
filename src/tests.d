import std.stdio;

import field;
import cell;
import wall;
import dead_end;

unittest {
    import std.stdio;
    import std.algorithm;
    import std.array;
    import common;
    State e = State.Empty;
    State w = State.Wall;
    State u = State.Unknown;
    Field createField(int width, int height) {
        Field field = new Field();
        field.setSize(width, height);
        return field;
    }
    void set(Field field, int x, int y, int num) {
        field.cells[y][x].setNumber(num);
    }
    State[][] toStateList(T)(T[][] wallList) {
        return wallList.map!(
            line=> line.map!(
                w=> state(w)
            ).array()
        ).array();
    }

    void test1() {
        Field field = createField(4, 4);
        set(field, 0, 0, 0);
        set(field, 1, 0, 2);

        assert(toStateList(field.verWalls) == [
            [e,e,w,u,u],
            [e,w,e,u,u],
            [u,u,u,u,u],
            [u,u,u,u,u]]);
        assert(toStateList(field.horWalls) == [
            [e,e,w,u],
            [e,w,e,u],
            [u,u,u,u],
            [u,u,u,u],
            [u,u,u,u]]);
    }
    void test2() {
        Field field = createField(5, 5);
        set(field, 2, 2, 3);
        set(field, 3, 2, 0);

        assert(toStateList(field.verWalls) == [
            [u,u,u,u,u,u],
            [u,u,e,w,u,u],
            [u,u,w,e,e,u],
            [u,u,e,w,u,u],
            [u,u,u,u,u,u]]);
        assert(toStateList(field.horWalls) == [
            [u,u,u,u,u],
            [u,u,u,u,u],
            [u,e,w,e,u],
            [u,e,w,e,u],
            [u,u,u,u,u],
            [u,u,u,u,u]]);
    }
    void testMiniLoop() {
        Field field = createField(9, 7);
        set(field, 1, 2, 0);
        set(field, 2, 2, 1);
        set(field, 3, 2, 1);
        set(field, 5, 2, 1);
        set(field, 6, 2, 1);
        set(field, 7, 2, 0);
        set(field, 2, 3, 3);
        set(field, 6, 3, 3);
        set(field, 1, 4, 0);
        set(field, 2, 4, 1);
        set(field, 3, 4, 1);
        set(field, 5, 4, 1);
        set(field, 6, 4, 1);
        set(field, 7, 4, 0);

        assert(toStateList(field.verWalls[4..5]) == [
            [u,e,e,e,e,e,e,e,e,u]]);
        assert(toStateList(field.horWalls[3..5]) == [
            [u,e,w,w,w,w,w,e,u],
            [u,e,w,w,w,w,w,e,u]]);
    }
    void testGranded() {
        Field field = createField(6,6);
        set(field, 0, 4, 0);
        set(field, 2, 4, 0);
        set(field, 4, 4, 0);
        set(field, 4, 3, 0);
        set(field, 4, 0, 0);

        Wall closed = field.horWalls[2][4];
        assert(state(closed) == State.Empty);
        assert(closed.grand);
    }
    void testDeadEnd() {
        Field field = createField(10,7);
        set(field, 2, 2, 0);
        set(field, 4, 2, 0);
        set(field, 6, 2, 0);
        set(field, 8, 2, 0);
        set(field, 2, 4, 0);
        set(field, 8, 4, 0);
        set(field, 5, 4, 3);
        set(field, 3, 5, 0);
        set(field, 4, 5, 0);
        set(field, 6, 5, 0);
        set(field, 7, 5, 0);

        assert(field.verWalls[3][5].state == State.Unknown);
        assert(field.verWalls[3][6].state == State.Unknown);
        DeadEnd.bury(field);
        assert(field.verWalls[3][5].state == State.Wall);
        assert(field.verWalls[3][6].state == State.Wall);
    }
    test1();
    test2();
    testMiniLoop();
    testGranded();
    testDeadEnd();
}
