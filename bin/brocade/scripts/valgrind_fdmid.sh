#!/bin/bash

VALGRIND_LIB=&quot;/valgrind-3.3.1/.in_place/&quot;
export VALGRIND_LIB

/valgrind-3.13.0/coregrind/valgrind fdmid.real $*
