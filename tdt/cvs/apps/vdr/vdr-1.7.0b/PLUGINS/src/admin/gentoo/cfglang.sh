#!/bin/bash
#
source /etc/vdr.d/conf/vdr

XKBD="De"
CKBD="de-latin1-nodeadkeys"
if [ "$KBD_LAYOUT" = "US" ]; then
   XKBD="US"
   CKBD="us"
fi   
sed -i /etc/X11/xorg.conf -e "s/InputDevice.*\"Keyboard.*/InputDevice \"Keyboard${XKBD}\" \"CoreKeyboard\"/"
sed -i /etc/conf.d/keymaps -e "s/^KEYMAP[= ].*/KEYMAP=\"$CKBD\"/"
