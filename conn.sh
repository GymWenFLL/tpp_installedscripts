#conn.sh - Connection-Wrapper-Script
#
#This file is part of teampcphone.
#
#Copyright (C) 2015  Dario Dorando
#
#teampcphone is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.

#!/bin/bash

ver="0.1"			#Version
log="tmp/run.log"		#Logfile
tmp="tmp/"			#Temp Folder
exc="/connection"		#The folder where to wait for an incoming connection.
gex="/sys/class/gpio/export"	#GPIO Export
gux="/sys/class/gpio/unexport"	#GPIO Unexport

function mktmp {		#makes the temporary folder
	if [ -e tmp/ ]
	then
		rm -r tmp/
	fi
	mkdir tmp
}

mktmp				#executes the mktemp function
echo "INFO: mktmp done."

function errorOut {		#gives out an error
	echo "ERROR: ${1}"
	echo "ERROR: ${1}" >> $log
}

function infoOut {		#gives out an info
	echo "INFO: ${1}"
	echo "INFO: ${1}" >> $log
}

function warnOut {		#gives out an warning
	echo "WARN: ${1}"
	echo "WARN: ${1}" >> $log
}

function version {		#shows the version
	echo "INFO: conn.sh Version ${ver}"
	echo "INFO: conn.sh Version ${ver}" >> $log
}

version
sleep .5
infoOut StartUp...

function unimplementedfwe {	#gives out an error, that an unimplemented function is called
	echo "ERROR: Unimplemented Function: ${1}"
	echo "ERROR: Unimplemented Function: ${1}" >> $log
	infoOut "Clean Up..."
	clean
	exit 3
}

function unimplementedf {	#gives out an error, that an unimplemented function is called
	echo "ERROR: Unimplemented Function: ${1}"
	echo "ERROR: Unimplemented Function: ${1}" >> $log
}

function unimplemented {
	echo "ERROR: Unimplemented use of this program: ${1}"
	echo "ERROR: Unimplemented use of this program: ${1}" >> $log
	infoOut "Clean Up..."
	clean
	exit 3
}

function gpioClose {
	echo $1 >> $gux
}

function clean {
	infoOut "Clean GPIO's"
	bash ${tmp}cleanUpGPIO.sh
}

function deprecated {		#gives out an info, that an function/program is deprecated
	echo "INFO: This function or program is deprecated: ${1}"
	echo "INFO: This function or program is deprecated: ${1}" >> $log
}

sleep 1

function exitFunc {
	exit $1
}

function gpioOpen {
	echo "$1" >> /sys/class/gpio/export
	if [ -e $tmp/cleanUp.sh ]
	then
		infoOut "Found CleanUp script..."
	else
		touch $tmp/cleanUp.sh
		chmod 777 $tmp/cleanUp.sh
	fi
	echo "echo ${1} >> /sys/class/gpio/unexport" >> $tmp/cleanUp.sh
	if [ -e $tmp/cleanUp.sh ]
	then
		infoOut "Test succeded..."
	else
		errorOut "Failed to write to the filesystem. GPIO's will not cleaned up at the end of this program!"
	fi
}

function exfile {
	infoOut "Found new File: _main"
	chmod 775 $exc/_main
	$exc/_main
}

infoOut Writing GPIO-Export...
sleep .5
gpioOpen 22
gpioOpen 23
gpioOpen 24
gpioOpen 25
gpioOpen 1
gpioOpen 2
gpioOpen 127
infoOut Done.
i=1
while (i=1) do
	if [ -e $exc/assets/ ]
	then
		infoOut "Found Assets"
	fi
	if [ -e $exc/_main ]
	then
		infoOut "Found _main entry point of the Program"
	fi
done
		


function showHelp {
	infoOut "Detected str help."
	infoOut "Loading help..."
	sleep 1
	echo "#include <iostream>" > /tmp/connhelp.cpp
	echo "int main() {" >> /tmp/connhelp.cpp
	echo "	std::cout << "Help of conn.sh:" << std::endl; " >> /tmp/connhelp.cpp
	echo "	std::cout << std::endl;" >> /tmp/connhelp.cpp
	echo "	std::cout << std::endl;" >> /tmp/connhelp.cpp
	echo "	std::cout << "conn.sh help			-	shows the help" << std::endl;" >> /tmp/connhelp.cpp
	echo "	std::cout << "conn.sh wait <tty>		-	waits for an incoming connection" << std::endl;" >> /tmp/connhelp.cpp
	echo "	std::cout << "conn.sh conn <tty>		-	activates an outgoing connection" << std::endl;" >> /tmp/connhelp.cpp
	echo "	std::cout << "conn.sh list [tty] [filter]	-	lists all active connections/the connections on the specified tty" << std::endl;" >> /tmp/connhelp.cpp
	echo "	std::cout << std::endl;" >> /tmp/connhelp.cpp
	echo "	std::cout << std::endl;" >> /tmp/connhelp.cpp
	echo "	std::cout << std::endl;" >> /tmp/connhelp.cpp
	echo "	std::cout << "Copyright (C) 2015 FLL-Team Gymnasium Wendelstein (Dario Dorando)" << std::endl;" >> /tmp/connhelp.cpp
	echo "}" >> /tmp/connhelp.cpp
	c++ /tmp/connhelp.cpp
	infoOut "Done."
	infoOut "Show help..."
	/tmp/connhelp
	/tmp/connhelp >> $log
	infoOut "Done."
	infoOut "Cleaning Up..."
	rm /tmp/connhelp
}

function waitForConnection {
	wfc=0
	
}

function paramhandler {
	if [ $1 = "help" ]
	then
		showHelp
		exitFunc 0
	else
		if [ $1 = "wait" ]
		then
			waitForConnection $2
		else
			if [ $1 = "conn" ]
			then
				connectTo $2
			else
				if [ $1 = "list" ]
				then
					if [ -n $2 ]
					then
						if [ -n $3 ]
						then
							listConnectionsDefTTYFilter $2 $3
						else
							listConnectionsDefTTY $2
						fi
					else
						listConnections
					fi
				fi
			fi
		fi
	fi
}

paramhandler $1 $2 $3

# Exits the Program because of an "unimplemented function", where only the rest of the program is unimplemented.
unimplementedf program
