#!/bin/bash
sudo netstat -ntlp|grep sshd:
if [ $? -eq 0 ]; then
	echo "All sshd tunnel was killed"
	sudo kill -9 $(sudo netstat -ntlp|grep sshd:|awk '{ print $7 }'|cut -d'/' -f 1)
else
	echo "No sshd tunnel"
fi
