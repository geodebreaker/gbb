#!/bin/bash
# SIMPLIFIED VERSION, USE gbb.sh NOT simple.sh UNLESS YOU KNOW WHAT YOU ARE DOING
# by geodebreaker - 4/29/25
p={1:-"ch341a_spi"}
f={2:-"0x80bf"}
i="$(mktemp)"
sudo flashrom -p "$p" -i GBB -r "$i"
sudo futility gbb -s --flags="$f" "$i"
sudo flashrom -p "$p" -i GBB -w "$i"
rm -f "$i"
