#!/bin/bash
# A mini script to avoid locking screen with non-English keyboard, since for some reason i cannot change the keyboard layout in xsecurelock

setxkbmap us; xsecurelock ; setxkbmap us,ru,ee,nl
