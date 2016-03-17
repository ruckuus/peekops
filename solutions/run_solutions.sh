#!/usr/bin/env bash

log(){
  echo "`date` ${1}" >> output.log
}

echo 'Running..'
log 'start'

log 'vagrant up'
cd solutions
vagrant up

log 'preparing test unit'
cd ..
npm install
npm install mocha -g
npm run init

log 'moment of truth!'
npm test

echo 'done!'
echo 'boyke@mas-mas.it'
log 'done'
