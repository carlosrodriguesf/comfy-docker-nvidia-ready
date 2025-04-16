#!/bin/bash

if [ -z "$1" ];then
  echo "Input file not supplied"
  exit 1
fi

if [ -z "$2" ];then
  echo "Output directory not supplied"
  exit 1
fi

LINKS=$(cat "$1" |tr "\n" " ")

for LINK in ${LINKS}; do
	wget -c "$LINK" -P "$2"
done