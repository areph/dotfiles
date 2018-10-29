#!/bin/bash

browser_title="Google Chrome"
terminal_title="terminal"

current_window_id=$(xdotool getwindowfocus)
browser_window_id=$(xdotool search --name --onlyvisible "$browser_title")
terminal_window_id=$(xdotool search --name --onlyvisible --class "$terminal_title"|tail -1)

if test $current_window_id -eq $browser_window_id
then
  xdotool windowactivate $terminal_window_id
else
  xdotool windowactivate $browser_window_id
fi
