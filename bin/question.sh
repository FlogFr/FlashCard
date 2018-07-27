#!/bin/bash

function syntax {
  echo "Syntax:"
  echo "  $0 #SUBJECT#"
}

if [[ $# != 1 ]]; then
  echo "Wrong number of parameters"
  syntax
fi

SUBJECT=$1

echo "Question on subject $SUBJECT"
