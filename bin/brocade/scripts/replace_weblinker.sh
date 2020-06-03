#!/bin/sh
# File: replace_weblinker.sh
# Replace current weblinker.fcg with new one in /tmp/ folder


cd /fabos/webtools/htdocs/
mv weblinker.fcg weblinker.fcg.old
mv /tmp/weblinker.fcg .
reboot -s
