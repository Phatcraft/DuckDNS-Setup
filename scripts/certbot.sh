#!/bin/bash

DOMAIN="_acme-challenge.example.duckdns.org"
TOKEN="<token>"
domain="<domain>"

curl -s "https://www.duckdns.org/update?domains=$domain&token=$TOKEN&txt=$CERTBOT_VALIDATION"
