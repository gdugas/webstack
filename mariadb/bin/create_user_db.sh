#!/bin/bash

username=$1

function help {
    echo "$0 username"
    echo ""
    echo "  Create username, grant all privileges on \$username databases and print generated random password."
    echo ""
}

function error {
    (>&2 echo $1)
    exit $2
}

if [ ! "$username" ]; then
    help && exit 1
fi

if [ ! "$MYSQL_ROOT_PASSWORD" ]; then
    read -s -p "Enter mysql root password: " MYSQL_ROOT_PASSWORD
fi

user_password=`pwgen -scaB 64 1`

histfile_backup=$HISTFILE
unset HISTFILE

echo "CREATE USER '$username'@'%' IDENTIFIED BY '$user_password';" | mysql -uroot -p$MYSQL_ROOT_PASSWORD \
    || error "Error while creating username '$username'" 2

echo "CREATE DATABASE IF NOT EXISTS $username;" | mysql -uroot -p$MYSQL_ROOT_PASSWORD \
    || error "Error while creating database '$username'" 3

echo "GRANT ALL ON $username.* TO '$username'@'%';" | mysql -uroot -p$MYSQL_ROOT_PASSWORD \
    || error "Error while granting privileges on database" 4

echo "FLUSH PRIVILEGES;" | mysql -uroot -p$MYSQL_ROOT_PASSWORD \
    || error "Error on privileges flush" 5

echo "Generated password: $user_password"

HISTFILE=$histfile_backup

