#!/bin/bash

#set -e

PASH_TOP=${PASH_TOP:-$(git rev-parse --show-toplevel)}

# another solution for capturing HTTP status code
# https://superuser.com/a/590170
input_files="1M.txt 10M.txt 100M.txt 1G.txt dict.txt 3G.txt 10G.txt 100G.txt all_cmds.txt all_cmdsx100.txt small"

if [ ! -f ./1M.txt ]; then
    curl -sf 'http://ndr.md/data/dummy/1M.txt' > 1M.txt
    if [ $? -ne 0 ]; then
        echo 'cannot find 1M.txt -- please contact the developers of pash'
        exit 1
    fi
fi

if [ ! -f ./10M.txt ]; then
    touch 10M.txt
    for (( i = 0; i < 10; i++ )); do
        cat 1M.txt >> 10M.txt
    done
fi

if [ ! -f ./100M.txt ]; then
    touch 100M.txt
    for (( i = 0; i < 10; i++ )); do
        cat 10M.txt >> 100M.txt
    done
fi

if [ ! -f ./1G.txt ]; then
    curl -sf 'http://ndr.md/data/dummy/1G.txt' > 1G.txt
    if [ $? -ne 0 ]; then
        echo 'cannot find 1G.txt -- please contact the developers of pash'
        exit 1
    fi
fi

# download wamerican-insane dictionary and sort according to machine
if [ ! -f ./dict.txt ]; then
    curl -sf 'http://ndr.md/data/dummy/dict.txt' | sort > dict.txt
    if [ $? -ne 0 ]; then
        echo 'cannot find dict.txt -- please contact the developers of pash'
        exit 1
    fi
fi

if [ ! -f ./all_cmds.txt ]; then
    curl -sf 'http://ndr.md/data/dummy/all_cmds.txt' > all_cmds.txt
    if [ $? -ne 0 ]; then
        # This should be OK for tests, no need for abort
        ls /usr/bin/* > all_cmds.txt
    fi
fi

hdfs dfs -put ./10M.txt /10M.txt
hdfs dfs -put ./100M.txt /100M.txt 
hdfs dfs -put ./1G.txt /1G.txt 
hdfs dfs -put ./all_cmds.txt


if [ "$#" -eq 1 ] && [ "$1" = "--full" ]; then
    echo "Generating full-size inputs"
    # FIXME PR: Do we need all of them?

    # if [ ! -f ./3G.txt ]; then
    #     touch 3G.txt
    #     for (( i = 0; i < 3; i++ )); do
    #         cat 1G.txt >> 3G.txt
    #     done
    # fi
    # hdfs dfs -put ./3G.txt /3G.txt

    # if [ ! -f ./10G.txt ]; then
    #     touch 10G.txt
    #     for (( i = 0; i < 10; i++ )); do
    #         cat 1G.txt >> 10G.txt
    #     done
    # fi
    # hdfs dfs -put ./10G.txt /10G.txt 

    if [ ! -f ./all_cmdsx100.txt ]; then
        touch all_cmdsx100.txt
        for (( i = 0; i < 100; i++ )); do
            cat all_cmds.txt >> all_cmdsx100.txt
        done
    fi
    hdfs dfs -put ./all_cmdsx100.txt /all_cmdsx100.txt 
fi