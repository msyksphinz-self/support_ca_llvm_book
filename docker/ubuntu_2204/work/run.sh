#!/bin/sh

echo "---------------------------------"
echo " Running Docker ..."
echo "---------------------------------"

docker pull msyksphinz/support_llvm:ubuntu_2204
docker run --rm -it support_llvm:ubuntu_2204 "/bin/bash"
