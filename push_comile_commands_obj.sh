#!/bin/bash

[ ! -f ./compile_commands.json ] && "[" > ./compile_commands.json

arguments=none

for arg in $@
do
    case "$arguments" in
            "skip_first")   arguments="\"$arg\"";;
            "none")         arguments="skip_first";;
            *)              arguments="$arguments, \"$arg\"";;
    esac
done


echo "  {" >> ./compile_commands.json

echo "    \"file\": \"$1\"," >> ./compile_commands.json
echo "    \"directory\": \"$(pwd)\"," >> ./compile_commands.json
echo "    \"arguments\": [$arguments]" >> ./compile_commands.json

echo "  }," >> ./compile_commands.json

