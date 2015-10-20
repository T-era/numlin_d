module input.stdin_command;

import std.stdio;
import std.conv;
import std.string;
import std.exception;

import field;
import dead_end;
import input.stdin_command_help;
import input.stdin_command_continuity;
import input.stdin;

interface Command {
    static Command[] ALL = [new CommandContinuity(), new CommandShow(), new CommandReset(), new CommandBury(), new CommandQuit(), new CommandHelp()];
    static int INDEX_HELP = 5;

    static Command read(string s)
    in {
        enforce(s.startsWith("-"));
    }
    body {
        foreach (Command cmd; ALL) {
            if (s.startsWith(cmd.commandString())) {
                return cmd;
            }
        }
        return ALL[INDEX_HELP];
    }

    final string commandString() {
        return "-" ~ this.commandSign();
    }

    bool apply(Field field, string args);
    string commandSign();
}
class CommandShow :Command {
    string commandSign() { return "s"; }
    bool apply(Field field, string args) {
        if (args && args.length > 0) {
            writeln("Error");
        } else {
            writeln(field);
        }
        return true;
    }
}
class CommandBury :Command {
    string commandSign() { return "b"; }
    bool apply(Field field, string args) {
        if (args && args.length > 0) {
            writeln("Error");
        } else {
            DeadEnd.bury(field);
        }
        return true;
    }
}
class CommandQuit :Command {
    string commandSign() { return "q"; }
    bool apply(Field field, string args) {
        writeln("Bye!");
        return false;
    }
}
class CommandReset :Command {
    string commandSign() { return "r"; }
    bool apply(Field field, string args) {
        if (args && args.length > 0) {
            writeln("Error");
        } else {
            resetField(field);
        }
        return true;
    }
}
