#!/bin/bash

cat message.txt | while read line
do
    cd ../llvm-myriscvx120 && git log --oneline --grep="${line}"
done
