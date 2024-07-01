#!/bin/bash

printf "\e[1mUninstalling\e[0m...\n"

cmd() { sudo security 2>&1 >/dev/null delete-generic-password -D "encrypted volume password" -s "local.corestorage.unlock" "/Library/Keychains/System.keychain"; }

err=`cmd`

while [[ $err == "password has been deleted." ]]; do
	err=`cmd`
done

sudo launchctl stop local.corestorage.unlock.plist
printf "\n\e[1mStopped Unlock\e[0m\n"

if [ -f /Library/LaunchDaemons/local.corestorage.unlock.plist ]; then
	sudo rm /Library/LaunchDaemons/local.corestorage.unlock.plist
	printf "\n\e[1mUninstalled\e[0m /Library/LaunchDaemons/local.corestorage.unlock.plist"
fi

if [ -f /Library/PrivilegedHelperTools/local.corestorage.unlock ]; then
	sudo rm /Library/PrivilegedHelperTools/local.corestorage.unlock
	printf "\n\e[1mUninstalled\e[0m /Library/PrivilegedHelperTools/local.corestorage.unlock"
fi

printf "\n"

if [ -f /var/log/local.corestorage.unlock.log ]; then
	sudo rm /var/log/local.corestorage.unlock.log
	printf "\n\e[1mDeleted\e[0m /var/log/local.corestorage.unlock.log\n"
fi

printf "\n\e[1mFinished\e[0m\n"
