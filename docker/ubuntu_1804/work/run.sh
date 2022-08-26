#!/bin/sh

echo "---------------------------------"
echo " Running Docker ..."
echo "---------------------------------"

docker pull msyksphinz/support_llvm:ubuntu_1804
docker run --rm -it support_llvm:ubuntu_1804 "/bin/bash"
