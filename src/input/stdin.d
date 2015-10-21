module input.stdin;

import std.stdio;
import std.conv;
import std.string;
import std.exception;

import field;
import dead_end;
import input.stdin_command;

void resetField(Field field) {
    write("Width:");
    int width = to!(int)(readln().strip());
    write("Height:");
    int height = to!(int)(readln().strip());
    field.setSize(width, height);
}

class Session {
    private bool finish = false;
    private Field field;
    this(Field field) {
        this.field = field;
    }

    bool continueSession() {
        if (! field) {
            initField();
            return true;
        } else {
            return talkWith();
        }
    }
    void initField() {
        this.field = new Field();
        resetField(field);
    }
    bool talkWith() {
        string input = readln().strip();
        if (input && input.length > 0) {
            if (input.startsWith("-")) {
                Command cmd = Command.read(input);
                return cmd.apply(field, "");
            } else {
                return readPosition(field, input);
            }
        } else {
            return true;
        }
    }
    bool readPosition(Field field, string input) {
        string temp = input;
        try {
            munch(temp, "( ");
            int x = parse!(int)(temp);
            munch(temp, ", ");
            int y = parse!(int)(temp);
            munch(temp, "): ");
            int num = parse!(int)(temp);
            field.cells[y][x].setNumber(num);
        } catch (Exception ex) {
            writeln("Parse error: ", input, ex);
        }
        return true;
    }
}
