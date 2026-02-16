#!/bin/bash
_MODEL=$(tr -d '\0' </proc/device-tree/model)
if [[ $_MODEL == *"Raspberry Pi 4"* ]]; then
  setpci -s 01:00.0 0xD4.B=0x41
fi
