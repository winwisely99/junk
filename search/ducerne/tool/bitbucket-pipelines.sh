#!/usr/bin/env bash

apt-get update
apt-get -y install zip

DART_VERSION=1.24.0

curl -O https://storage.googleapis.com/dart-archive/channels/stable/release/$DART_VERSION/sdk/dartsdk-linux-x64-release.zip

unzip dartsdk-linux-x64-release.zip

export DART_SDK=$PWD/dart-sdk
export PATH=$DART_SDK/bin:$PATH

dart --version

ls -al

pub get 

pub run test test/
