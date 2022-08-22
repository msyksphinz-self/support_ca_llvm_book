#!/bin/sh

echo "---------------------------------"
echo " Running Docker ..."
echo "---------------------------------"

docker pull msyksphinz/support_llvm:ubuntu_2204_onlyenv
docker run --rm -it support_llvm:ubuntu_2204_onlyenv "/bin/bash"
