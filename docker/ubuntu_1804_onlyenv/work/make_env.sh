#!/bin/sh

# referred by https://qiita.com/takumiabe/items/fee2e76e3a39fd853589

touch .env
echo "UID=$(id -u $USER)" >> .env
echo "GID=$(id -g $USER)" >> .env
echo "UNAME=$USER" >> .env
