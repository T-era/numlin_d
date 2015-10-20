module input.stdin_command_help;

import std.stdio;
import std.conv;
import std.string;
import std.exception;

import field;
import dead_end;
import input.stdin_command;

class CommandHelp :Command {
    static string[string] HELP_MESSAGE;
    static this() {
        HELP_MESSAGE = [
            "h": "Show this help.",
            "i": "Input continuity. (To set [(2,0) 0, (3,0) 1] as line \"  01 \")",
            "r": "Reset & resize field map.",
            "q": "Quit proccess.",
            "s": "Show field map.",
            "b": "Run dead-end-bury proc."
        ];
    }
    string commandSign() { return "h"; }
    bool apply(Field field, string args) {
        writeln("# (x,y) number:");
        writeln("#\tSet number for a cell at (x, y).");
        foreach (Command cmd; Command.ALL) {
            writefln("# %s:\t%s"
                , cmd.commandString()
                , HELP_MESSAGE[cmd.commandSign()]);
        }
        return true;
    }
}
