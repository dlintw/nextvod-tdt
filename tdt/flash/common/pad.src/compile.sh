#!/bin/bash

if [  -e pad ]; then
  rm pad
fi

if [  -e pad.exe ]; then
  rm pad.exe
fi

g++ -m32 -o pad pad.c
