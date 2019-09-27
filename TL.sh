#!/bin/bash
main() {
	echo "Type your lottery numbers... (Multiple numbers are supported by space-sparated.)"
	read NUMBER
	echo

	echo "Won numbers for matching with 3-digits front-rear or 2-digits rear:"
	for x in $NUMBER
	do
			y=`echo $x | tail -c 3`
			cat $SOURCE | head -n 4 | tail -n 1 | tail -c +4 | grep -oq $y
			if [ $? = 0 ]; then echo "$x (2-digits rear) "; continue; fi
			y=`echo $x | head -c 3`
			cat $SOURCE | head -n 2 | tail -n 1 | tail -c +4 | grep -oq $y
			if [ $? = 0 ]; then echo "$x (3-digits front-rear) "; continue; fi
			y=`echo $x | tail -c 4`
			cat $SOURCE | head -n 3 | tail -n 1 | tail -c +4 | grep -oq $y
			if [ $? = 0 ]; then echo "$x (3-digits front-rear) "; fi
	done

	echo "Won Whole Numbers :"
	for x in $NUMBER
	do
		cat $SOURCE | tail -n +6 | grep -o $x
	done

	echo
	echo "Finished checking if your number has appeared, means you're won!"
	echo "Thanks you for using NP-chaonay script."
	echo
}

read -d '\' -t 1.5
echo
echo "Thai Lottery Checking"
echo "Read data from text with defined format."
read -d '\' -t 2
echo

if [ -z $1 ]; then
	echo "Script instructions :"
	echo '+ Select database location as first parameter, or type "-" as first parameter then input text from database to stdin instead'
	exit 0
elif [ -r $1 ] && [ ! -d $1 ]; then
	SOURCE=$1
	main
	exit 0
elif [ $1 = "-" ]; then
	echo "Input text from database to stdin, then press Ctrl+D..."
	cat > /dev/shm/TL.txt
	SOURCE=/dev/shm/TL.txt
	echo
	main
	rm /dev/shm/TL.txt
	exit 0
elif [ -e $1 ] && [ ! -d $1 ]; then
	echo "Error : Selected file can't be read."
	echo "Solution : Make sure that the selected file is be able to read by this script."
	exit 1
elif [ -d $1 ]; then
	echo "Error : Selected file is the directory."
	echo "Solution : Make sure you are typed correct filename and location."
	exit 1
else
	echo "Error : Script's parameter syntex is incorrect or selected file isn't found."
	echo "Solution : Follow one of these instructions :"
	echo '+ Select database location as first parameter, or type "-" as first parameter then input text from database to stdin instead'
	echo '+ Make sure that the selected file is available to be read.'
	exit 1
fi
}
