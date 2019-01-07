#!/bin/bash -e

curl -i -v http://127.1:8080/words
curl -i -v -X POST -H 'Content-Type: application/json' -d '{ "wordId": 12 , "wordLanguage": "EN" , "wordWord": "wordWord" , "wordKeywords": [] , "wordDefinition": "wordDefinition" , "wordDifficulty": 2 }' http://127.1:8080/words
