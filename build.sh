#! /bin/bash

export SRCDIR=src/
export DESTDIR=dest/

if test "$1" = "test"
then
  rdmd -unittest -main ${SRCDIR}tests.d
elif test "$1" = "run"
then
  shift
  rdmd ${SRCDIR}main.d $@
else
 dmd -release -od$DESTDIR -of${DESTDIR}numlin $SRCDIR*.d ${SRCDIR}input/*.d
fi
