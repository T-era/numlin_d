module input.stdin_command_continuity;

import std.stdio;
import std.conv;
import std.string;
import std.exception;
import std.algorithm;

import field;
import dead_end;
import input.stdin;
import input.stdin_command;

class CommandContinuity :Command {
    string commandSign() { return "i"; }
    bool apply(Field field, string args) {
        if (hasNumber(field)) {
            resetField(field);
        }
        for (int y = 0; y < field.height; y ++) {
            string rawInput = readInput();
            if (rawInput.length != field.width) {
                writeln("Error on:", rawInput);
                y --;
            } else {
                for (int x = 0; x < field.width; x ++) {
                    string str = rawInput[x..x+1];
                    if (str != " ") {
                        int num = to!(int)(str);
                        field.cells[y][x].setNumber(num);
                    }
                }
            }
        }
        return true;
    }
    private static bool hasNumber(Field field) {
        return field.cells.remove!(line=>
            line.remove!(cell=>
                cell._number == -1) == []) != [];
    }
    private string readInput() {
        write(">");
        return readln().chomp();
    }
}
