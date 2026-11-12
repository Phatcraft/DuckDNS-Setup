#!/bin/bash

ip=$(hostname -I | awk '{print $1}')

domain="<domain>"
token="<token>"

echo url="https://www.duckdns.org/update?domains=$domain&token=$token&ip=$ip" | curl -k -K -
