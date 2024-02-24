#!/usr/bin/env bash

user_name=$USER_NAME
password=$USER_PW

useradd -m $user_name -s /bin/bash
echo "$user_name:$password"|chpasswd

# Sudo without password
echo "$user_name ALL=(ALL) NOPASSWD:ALL"| tee /etc/sudoers.d/$user_name

# Add user on sudo group
usermod -aG sudo $user_name

