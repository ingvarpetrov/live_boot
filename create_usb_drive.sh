#!/bin/bash
sudo ./format_usb.sh
eval '[ "$?" = 0 ] || exit '"$?"
sudo ./copy_live_content.sh
