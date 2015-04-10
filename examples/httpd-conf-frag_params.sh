IDX=0

params[$IDX]="status_uri"
descr[$IDX]="The URI of the server-status handler"
default[$IDX]="/server-status"
required[$IDX]=1

IDX=$(( $IDX + 1 ))
params[$IDX]="monitor_ip"
descr[$IDX]="The IP or range of IPs which is/are allowed to view this status URI. E.g. \"10.1 172.20 192.168.2\", \"10.1.0.0/16\""
required[$IDX]=1
