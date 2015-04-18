#!/bin/sh

# This is designed to remove software from a mac in preparation
# to send it to Surplus.

# Uninstalling script

# Vars
filemakerver="`ls /Applications | grep 'FileMaker'`"
filemaker="/Applications/${filemakerver}"
sophos="/Library/Sophos Anti-Virus/Remove Sophos Anti-Virus.pkg"
iworkver="`ls /Applications | grep 'iWork'`"
iWork="/Applications/${iworkver}"

# Remove Office
echo "Enter the user of the old machine"
read USER

sudo rm /Library/Preferences/com.microsoft*
sudo rm -rf /Applications/Microsoft*
sudo rm -rf /Library/Application\ Support/Microsoft
sudo rm /Library/LaunchDaemons/com.microsoft*
sudo rm /Library/PrivilegedHelperTools/com.microsoft*
sudo rm -rf /Library/Receipts/Office*
sudo rm /private/var/db/receipts/com.microsoft*
sudo rm -rf /Users/$USER/Library/Application\ Support/Microsoft/Office
sudo rm -rf /Library/Fonts/Microsoft
sudo rm -rf /Users/$USER/Library/Application\ Support/Microsoft
sudo rm -rf /Users/$USER/Library/Caches/Metadata/Microsoft
sudo rm -rf /Users/$USER/Library/Preferences/Microsoft
sudo rm -rf /Users/$USER/Documents/Microsoft\ User\ Data

# Check and remove FileMaker
if [ -e "${filemaker}" ]; then
	echo "Removing Filemaker"
	sudo rm -rf /Applications/FileMaker*
fi

# Check and remove iWork
if [ -e "${iWork}" ]; then
	echo "Removing ${iworkver}....."
	sudo rm -rf /Applications/iWork*
fi

# Check for Sophos and run uninstaller
if [ -e "${sophos}" ]; then
	echo "Running Sophos uninstaller...."
	sudo installer -pkg "${sophos}" -target /
fi

# Removing printers

for printer in `lpstat -p | awk '{print $2}'`
do
	echo Deleting $printer
	sudo lpadmin -x $printer
done

sudo launchctl stop org.cups.cupsd
sudo rm /etc/cups/cupsd.conf
sudo cp /etc/cups/cupsd.conf.default /etc/cups/cupsd.conf
sudo rm /etc/cups/printers.conf
sudo launchctl start org.cups.cupsd

# Reset Docks to original state
find /Users -name com.apple.dock.plist -delete

# Close sudo
sudo -k

echo "Clean up finished."

exit 0