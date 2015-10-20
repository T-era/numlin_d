import std.conv;
import std.exception;

import common;
import cell;
import wall;

interface Listener {
    void decided();
}
class RabitHead :Listener {
    Cell head;
    Wall ear1;
    Wall ear2;
    Wall dest1;
    Wall dest2;

    this(Cell head,
            Wall ear1,
            Wall ear2,
            Wall dest1,
            Wall dest2)
    in {
        enforce(head !is null);
    }
    body {
        this.head = head;
        this.ear1 = ear1;
        this.ear2 = ear2;
        this.dest1 = dest1;
        this.dest2 = dest2;

        this.head.addListener(this);
        if (ear1 !is null) this.ear1.addListener(this);
        if (ear2 !is null) this.ear2.addListener(this);
    }

    void decided() {
        State state1 = state(this.ear1);
        if (state1 == state(this.ear2)) {
            if (state1 == State.Wall) {
                this.set(State.Empty);
            } else if (state1 == State.Empty) {
                if (number(this.head) == 1) {
                    this.set(State.Empty);
                } else if (number(this.head) == 3) {
                    this.set(State.Wall);
                }
            }
        }
    }
    private void set(State newState) {
        void setImpl(Wall dest) {
            if (state(dest) != newState) {
                dest.setState(newState);
            }
        }
        setImpl(this.dest1);
        setImpl(this.dest2);
    }
}
