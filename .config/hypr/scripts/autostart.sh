#!/usr/bin/bash
for file in $XDG_CONFIG_HOME/autostart/*
do
  gio launch $file
done
