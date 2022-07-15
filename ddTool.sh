#!/bin/bash
function tline {
	printf "\n==================================================\n"
}
function mline {
	printf "\n--------------------------------------------------\n"
}
function menu0 {
	tline
	printf "\tddTool, the simplest way to dd"
	mline
	printf "Select the target device:"
	printf "\n$(lsblk | grep sd)"
	tline
}
function menu1 {
	tline
	printf "Select an option:"
	mline
	printf "\n0) Delete data"
	printf "\n1) Flash ISO image"
	printf "\n2) Format device"
	tline
}
function menu2 {
	tline
	printf "Write down the route to the ISO image:"
	tline
}
function menu3 {
	tline
	printf "Select a filesystem:"
	mline
	printf "0) FAT32"
	printf "\n1) vfat"
	printf "\n2) ext2"
	printf "\n3) ext3"
	printf "\n4) ext4"
	tline
}

## Begin Algorithm

menu0
read devSel # Selected device
devRt="/dev/$devSel" # Route to selected device
menu1
read optSel # Option selection
case $optSel in
	0)
		printf "Delete ALL data from $devRt? (y/n)"
		read confirm
		if [ $confirm = "y" ] || [ $confirm = "Y" ]; then
			printf "Deleting in progress..."
			sudo dd if=/dev/zero of=$devRt
		else
			printf "Cancelled operation."
		fi
		;;
	1)
		menu2
		read imgRt
		printf "Route: $imgRt"
		mline
		printf "Target: $devRt"
		mline
		printf "All your data will be lost, ensure you saved it\nbefore. Make bootable device? (y/n)"
		tline
		read confirm
		sudo dd if=$imgRt |pv|dd of=$devRt
		;;
	2)
		menu3
		read fsSel # Filesystem selection
		case $fsSel in
			0)
				printf "Making FAT 32 filesystem..."
				sudo mkdosfs -F 32 -I $devRt
				;;
			1)
				printf "Making vfat filesystem..."
				sudo mkfs.fat -I $devRt
				;;
			2)
				printf "Making filesystem..."
				sudo mkfs.ext2 $devRt
				;;
			3)
				printf "Making filesystem..."
				sudo mkfs.ext3 $devRt
				;;
			4)
				printf "Making filesystem..."
				sudo mkfs.ext4 $devRt
				;;
			*)
				printf "Sorry, invalid option."
		esac
		;;
	*)
		printf "Sorry, invalid option."
esac

## End Algorithm
