#!/usr/bin/fish
swww-daemon
if test (date +%H) -lt 6
  swww img (random choice ~/Pictures/Backgrounds/Dark/*)
else
  swww img (random choice ~/Pictures/Backgrounds/Light/*)
end
