#!/bin/sh

# This is designed to remove software from a mac in preparation
# to send it to Surplus.

#Uninstalling script

#vars
filemakerver="`ls /Applications | grep 'FileMaker'`"
filemaker="/Applications/${filemakerver}"
sophos="/Library/Sophos Anti-Virus/Remove Sophos Anti-Virus.pkg"
iworkver="`ls /Applications | grep 'iWork'`"
iWork="/Applications/${iworkver}"

#check and remove office 04
echo "Enter the user of the old machine"
read USER

rm /Library/Preferences/com.microsoft*
rm -rf /Applications/Microsoft*
rm -rf /Library/Application\ Support/Microsoft
rm /Library/LaunchDaemons/com.microsoft*
rm /Library/PrivilegedHelperTools/com.microsoft*
rm -rf /Library/Receipts/Office*
rm /private/var/db/receipts/com.microsoft*
rm -rf /Users/$USER/Library/Application\ Support/Microsoft/Office
rm -rf /Library/Fonts/Microsoft
rm -rf /Users/$USER/Library/Application\ Support/Microsoft
rm -rf /Users/$USER/Library/Caches/Metadata/Microsoft
rm -rf /Users/$USER/Library/Preferences/Microsoft

cp -rf /Users/$USER/Documents/Microsoft\ User\ Data /Users/$USER/Desktop


#check and remove FileMaker
if [ -e "${filemaker}" ]; then
	echo "Removing Filemaker"
	sudo rm -rf /Applications/FileMaker*
fi

#check and remove iWork
if [ -e "${iWork}" ]; then
	echo "Removing ${iworkver}....."
	sudo rm -rf /Applications/iWork*
fi

#check for Sophos and run uninstaller
if [ -e "${sophos}" ]; then
	echo "Running Sophos uninstaller...."
	sudo installer -pkg "${sophos}" -target /
fi

#Removing printers
sudo launchctl stop org.cups.cupsd
sudo rm /etc/cups/cupsd.conf
sudo cp /etc/cups/cupsd.conf.default /etc/cups/cupsd.conf
sudo rm /etc/cups/printers.conf
sudo launchctl start org.cups.cupsd

#Reset Docks to original state
find /Users -name com.apple.dock.plist -delete

#close sudo
sudo -k

echo "Clean up finished."

exit 0