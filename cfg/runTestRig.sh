#!/bin/sh
GDK_SCALE=2 java -Dsun.java2d.uiScale.enabled=true -Dsun.java2d.ddscale=true -cp antlr-4.7.1-complete.jar:parser.jar org.antlr.v4.gui.TestRig Euporia start annotation.txt -gui
# oscan4.txt -gui
#-tokens -tree -trace -diagnostics
