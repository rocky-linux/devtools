#!/bin/sh

export PATH="/usr/local/bin/:$PATH"

rockyget $PACKAGE
rockyprep $PACKAGE
rockybuild $PACKAGE
