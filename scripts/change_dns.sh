#! /usr/bin/env bash

rm -rf /etc/resolv.conf
touch /etc/resolv.conf
echo "nameserver 8.8.8.8" > /etc/resolv.conf

echo "resolv.conf changed"
cat /etc/resolv.conf
nslookup www.google.com 8.8.8.8