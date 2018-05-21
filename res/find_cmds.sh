#!/bin/sh

grep '\\[a-z]\+' `find . -name '*.tex'` -o -h | sort -u
