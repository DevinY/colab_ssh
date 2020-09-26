#!/bin/bash
#!wget -qO- https://pi4.ccc.tc/colab_sshserver.sh | bash -s
echo "Params = $@"

export SSH_USER=${1}
export SSH_HOST=${2}
export SSH_PORT=${3}
export PUBLIC_KEY="${4} ${5}"

echo ${4}|grep -q 'ssh'
if [ $? -eq 1 ]; then
	echo "Unable to find public key"
	exit
fi

#產生金鑰，如果不存在
if [ ! -f $HOME/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -q -f "$HOME/.ssh/id_rsa" -N ""
fi

#新增遠端主機公鑰
echo ${PUBLIC_KEY} >> /root/.ssh/authorized_keys

#安裝網路工具
apt-get -y install net-tools iputils-ping openssh-server > /dev/null 2>&1 &

grep -q ${SSH_USER} .colab_ssh_success

if [ ! $? -eq 0 ]; then
    ssh-keygen -A
    mkdir -p /run/sshd
    nohup /usr/sbin/sshd -D > /dev/null 2>&1 &

    #可以ssh，建立tunnel
    nohup ssh -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa -NR 0.0.0.0:${SSH_PORT}:0.0.0.0:22 ${SSH_USER}@${SSH_HOST} > /dev/null 2>&1 &
    if [ $? -eq 0 ]; then	
      echo "Tunnel was created, You can issue command as below to connect into your colab vm"
      echo "ssh -o StrictHostKeyChecking=no root@127.0.0.1 -p ${SSH_PORT}"
    fi

    ssh -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa ${SSH_USER}@${SSH_HOST} id > .colab_ssh_success

fi

grep -q ${SSH_USER} .colab_ssh_success

if [ ! $? -eq 0 ]; then
	echo "Issue following command to your server and run again. (${SSH_USER}@${SSH_HOST})"
	echo " "
	echo "新增colab ssh vm公鑰到您的主機，以便建立ssh通道，貼上下方指令到您的主機後，再執行一次"
	echo " "
	echo -n "echo "
	cat $HOME/.ssh/id_rsa.pub|tr -d '\n'
	echo -n " >> ~/.ssh/authorized_keys"
	exit
fi


#可以ssh，建立tunnel
nohup ssh -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa -NR 0.0.0.0:${SSH_PORT}:0.0.0.0:22 ${SSH_USER}@${SSH_HOST} sleep 10 > /dev/null 2>&1 &

echo "Tunnel was created, You can issue command as below to connect into your colab vm"
echo "ssh -o StrictHostKeyChecking=no root@127.0.0.1 -p ${SSH_PORT}"
