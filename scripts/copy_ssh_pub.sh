#! /usr/bin/env bash

user_name=$USER_NAME
ssh_pub_origin_path=$SSH_PUB_FILE_ORIGIN_PATH
ssh_pub_file_name=$SSH_PUB_FILE_NAME

USER_HOME=/home/$user_name/


mkdir -p $USER_HOME/.ssh/
chmod 700 $USER_HOME/.ssh/
cat $ssh_pub_origin_path/$ssh_pub_file_name >> $USER_HOME/.ssh/authorized_keys
chown -R $user_name:$user_name $USER_HOME/.ssh
chmod 600 $USER_HOME/.ssh/authorized_keys
rm -rf $ssh_pub_origin_path/$ssh_pub_file_name
