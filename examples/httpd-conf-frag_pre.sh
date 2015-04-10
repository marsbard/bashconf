BANNER="\
=============================================\n\
Example to create a small httpd.conf fragment\n\
============================================="

# in this case when we cancel we don't want to write the output file
# the answers file is written in either case
WRITE_ON_QUIT=0

PROMPT="When finished editing, choose 'W' to write the file, or 'C' to cancel"

INSTALL_LETTER=W
QUIT_LETTER=C

function wait_echo {
  BULLET='*'
  MSG=$*

  echo -e "${YELLOW}${BULLET} ${GREEN}${MSG}${RESET}"
  echo
  sleep 1
}

  
echo
echo
echo -e "=== Example to create a small httpd.conf fragment ==="
echo
sleep 1

wait_echo "In this example we abuse the 'install' script to provide 'write' function"
wait_echo "Basically the install script exists but does nothing"
wait_echo "Because a side effect of the install stage is to eval required params"
wait_echo "Accordingly the 'quit' function is mapped to 'C'ancel"
wait_echo "It also shows an example of using the pre script to show text (this!)"

sleep 3
