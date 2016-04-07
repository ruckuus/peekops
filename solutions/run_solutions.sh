#!/usr/bin/env bash
SLEEP=5

clear
echo 'Running'
echo "Getting Vagrant Box ubuntu/trusty64"
cd solutions

vagrant box add ubuntu/trusty64
for A in web postgresql cache application
do
	echo "=> Preparing $A Server in $SLEEP secs ..."
	sleep $SLEEP
	vagrant up $A
	echo ""
done
