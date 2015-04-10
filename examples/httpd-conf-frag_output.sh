#!/bin/bash

# http://pempek.net/articles/2013/07/08/bash-sh-as-template-engine/
function render_template {
  eval "echo \"$(cat $1)\""
}

OUTPUT=httpd-conf-frag.out.txt

STATUS_URI=`get_param status_uri`
MONITOR_IP=`get_param monitor_ip`


echo -e "${PURPLE}Writing ${YELLOW}${OUTPUT}${RESET}"
render_template ${CONF}_template.txt > httpd-conf-frag.out.txt
