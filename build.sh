#! /bin/bash

export SRCDIR=src/
export DESTDIR=dest/

#rdmd -unittest -main ${SRCDIR}tests.d
dmd -release -od$DESTDIR -of${DESTDIR}numlin $SRCDIR*.d ${SRCDIR}input/*.d

