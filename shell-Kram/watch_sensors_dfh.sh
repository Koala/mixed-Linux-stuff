watch -d 'sensors ; echo "================================\n============ df -h =============" ; df -h ; echo "\n ########################## free ########################## \n"; free -h -w ;  echo "\n md5sum: " ; pstree | grep md5sum ; echo "\n tar: " ; pstree | grep tar'