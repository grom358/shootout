#!/bin/sh
(cd c_reference; ./build.sh)
c_reference/mandelbrot 16000 > test16000.pbm
