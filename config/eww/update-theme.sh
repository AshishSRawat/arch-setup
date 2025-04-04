#!/bin/bash

# hack to avoid flicker when eww kills the window
eww update bar_enabled=false
sleep 1
eww reload
sleep 1
eww update bar_enabled=true
