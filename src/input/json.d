module input.json;

import std.file;
import std.json;
import std.stdio;
import std.conv;

import field;

Field readJson(string fileName) {
    JSONValue setting = parseJSON(readText(fileName));
    Field field = new Field();
    field.setSize(
        cast(int) setting["width"].integer,
        cast(int) setting["height"].integer);
    foreach (JSONValue number; setting["numbers"].array()) {
        sizediff_t x = to!sizediff_t(number["x"].integer);
        sizediff_t y = to!sizediff_t(number["y"].integer);
        int num = cast(int) number["number"].integer;

        field.cells[y][x].setNumber(num);
    }
    return field;
}
