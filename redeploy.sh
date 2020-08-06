#!/bin/zsh
set -euxo pipefail

clj -A:native-image

if [[ -a function.zip ]]
then
    rm function.zip
fi
zip function.zip bootstrap lamed-sample-app

(cd terraform &&
     terraform apply -auto-approve)
