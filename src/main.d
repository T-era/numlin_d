import std.stdio;
import std.string;

import field;
import cell;
import dead_end;
import input.stdin;
import input.json;

void main(string[] args) {
    bool interactive = false;
    string fileName = null;
    for (int i = 1; i < args.length; i ++) {
        string lower = args[i].toLower();
        if (lower == "-i") {
            interactive = true;
        } else if (lower == "-f") {
            fileName = args[++i];
        } else {
            throw new Exception("Error");
        }
    }
    Field field = null;
    if (fileName) {
        field = readJson(fileName);
    }
    if (interactive) {
        Session session = new Session(field);
        do {
        } while(session.continueSession());
    } else {
        if (field is null) {
            showUsage();
        } else {
            DeadEnd.bury(field);
            writeln(field);
        }
    }
}

void showUsage() {
    writeln("Usage: numlin [OPTION]");
    writeln("OPTION:");
    writeln("\t-i: Run as interactive mode.");
    writeln("\t-f filename: Read JSON in {filename}");
}
