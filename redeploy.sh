#!/bin/zsh

# parse args before error checks
build_type="uberjar"
if [ -n "$1" ]; then
    build_type="$1"
fi

# enable shell error checks
set -euxo pipefail


# clean up previous builds
if [[ -a function.zip ]]
then
    rm function.zip
fi
if [[ -a lamed-sample-app.jar ]]
then
    rm lamed-sample-app.jar
fi


# build
if [ $build_type = "native-image" ]; then
    echo "building native-image"
    clj -A:native-image
    zip function.zip bootstrap lamed-sample-app
else
    echo "building uberjar"
    clj -A:uberjar
fi

(cd terraform &&
     terraform apply -auto-approve)
