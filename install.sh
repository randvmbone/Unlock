#!/bin/bash

if [[ `whoami` != "root" ]]; then
	curl -L "https://raw.github.com/randvmbone/unlock/main/install.sh" -o install.sh  > /dev/null 2>&1
	chmod +x install.sh
	sudo bash ./install.sh
	rm install.sh
	exit
fi

mkdir unlock
cd unlock

printf "\e[1mDownloading\e[0m...\n"
curl -L "https://raw.github.com/randvmbone/unlock/main/files/local.corestorage.unlock.plist" -o local.corestorage.unlock.plist > /dev/null 2>&1
printf "\n\e[1mDownloaded\e[0m local.corestorage.unlock.plist"
curl -L "https://raw.github.com/randvmbone/unlock/main/files/local.corestorage.unlock" -o local.corestorage.unlock > /dev/null 2>&1
printf "\n\e[1mDownloaded\e[0m local.corestorage.unlock"

printf "\n"

printf "\n\e[1mInstalling\e[0m...\n"

sudo cp local.corestorage.unlock.plist /Library/LaunchDaemons/
sudo chown root:wheel /Library/LaunchDaemons/local.corestorage.unlock.plist
sudo chmod 644 /Library/LaunchDaemons/local.corestorage.unlock.plist
printf "\n\e[1mInstalled\e[0m /Library/LaunchDaemons/local.corestorage.unlock.plist"

sudo mkdir -p /Library/PrivilegedHelperTools/
sudo cp local.corestorage.unlock /Library/PrivilegedHelperTools/
sudo chown root:wheel /Library/PrivilegedHelperTools/local.corestorage.unlock
sudo chmod 755 /Library/PrivilegedHelperTools/local.corestorage.unlock
sudo chmod +X /Library/PrivilegedHelperTools/local.corestorage.unlock
printf "\n\e[1mInstalled\e[0m /Library/PrivilegedHelperTools/local.corestorage.unlock"

printf "\n\n"

vname() { echo `diskutil coreStorage info $1 | grep "LV Name" | cut -d : -f 2 | sed -e 's/^\ *//'`; }

unlock() {
	printf "\e[1mPassphrase:\e[0m"
	read -s password < /dev/tty
    printf "\n"
	# Add the password to the System Keychain
	security add -a "${1}" -D "encrypted volume password" -l "${2}" -s "local.corestorage.unlock" \
		-w "${password}" -T "" -T "/Library/PrivilegedHelperTools/local.corestorage.unlock" -U "/Library/Keychains/System.keychain"
}

ask() {
	# Get the name of the volume with UUID
	name=`vname $1`
	printf "Unlock \e[1m${name}\e[0m during boot? [y/\e[1mN\e[0m] "
	read yn < /dev/tty
	# Make user input lowercase
	answer=`echo ${yn}| awk '{print tolower($0)}'`
	if [[ $answer = "y" || $answer = "yes" ]]; then
		unlock $1 $name
    fi
}

boolUUID=false
bootUUID=`diskutil coreStorage info \`mount | grep " / " | cut -d " " -f 1\` 2>/dev/null | grep UUID | grep -v LV | cut -d : -f 2 | sed -e 's/^\ *//'`

#http://stackoverflow.com/questions/893585/how-to-parse-xml-in-bash#answer-2608159
rdom() { local IFS=\> ; read -d \< E C ;}
CSVs=`diskutil coreStorage list -plist`
echo $CSVs | while rdom; do
	if [[ $E = "string" ]]; then
	# All the important stuff is inside the "string" elements
		echo "$C"
	fi
done | \
while read LINE; do
# Loop through all found LVGs, LVFs, LVs
	if $boolUUID; then
	# If this is a LV's UUID, ask if they want to unlock it
		if [[ $bootUUID != $LINE ]]; then
		# Don't ask about the boot volume, File Vault will take care of that one
			ask $LINE
		fi
	fi
	if [[ $LINE = "LV" ]]; then
	# If true, the next line will be a LV's UUID
		boolUUID=true
	else
		boolUUID=false
	fi
done

sudo launchctl load /Library/LaunchDaemons/local.corestorage.unlock.plist
printf "\n\e[1mStarted Unlock\e[0m\n"

printf "\n\e[1mLog\e[0m /var/log/local.corestorage.unlock.log\n"

cd ..
rm -r unlock

printf "\n\e[1mFinished\e[0m\n"
