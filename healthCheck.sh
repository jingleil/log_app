free -m | awk '{if (NR==2){ if ( $4 < 200 ) {print "Memory full: " $2 " " $3 " " $4}} }'
df -h| awk '{if (NR!=1) { {sp=sprintf("%d",$5)} if (sp > 98) { print "Disk full: " $5 " " $6 } } }'
