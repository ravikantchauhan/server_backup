#1/bin/bash
####
freespace=100
pct=.30
subtract=$(bc <<< "$freespace * (1-$pct)")
echo "$subtract"