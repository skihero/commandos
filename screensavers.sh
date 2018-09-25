#!/bin/bash
cd /usr/lib/xscreensaver/
for f in `ls`; 
do
./$f
done
