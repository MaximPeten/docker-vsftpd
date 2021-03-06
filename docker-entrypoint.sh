#!/bin/bash

set -e

mkdir -p "/home/vsftpd/${FTP_USER}" \
	&& chown -R ftp:ftp /home/vsftpd/ \
	&& echo -e "${FTP_USER}\n${FTP_PASS}" > /etc/vsftpd/virtual_users.txt \
	&& /usr/bin/db_load -T -t hash -f /etc/vsftpd/virtual_users.txt /etc/vsftpd/virtual_users.db \
	&& export PASV_ADDRESS=$(/sbin/ip route|awk '/src/ { print $9 }')

echo "pasv_address=${PASV_ADDRESS}" >> /etc/vsftpd/vsftpd.conf
echo "pasv_max_port=${PASV_MAX_PORT}" >> /etc/vsftpd/vsftpd.conf
echo "pasv_min_port=${PASV_MIN_PORT}" >> /etc/vsftpd/vsftpd.conf
echo "pasv_addr_resolve=${PASV_ADDR_RESOLVE}" >> /etc/vsftpd/vsftpd.conf
echo "pasv_enable=${PASV_ENABLE}" >> /etc/vsftpd/vsftpd.conf
echo "file_open_mode=${FILE_OPEN_MODE}" >> /etc/vsftpd/vsftpd.conf
echo "local_umask=${LOCAL_UMASK}" >> /etc/vsftpd/vsftpd.conf
echo "xferlog_std_format=${XFERLOG_STD_FORMAT}" >> /etc/vsftpd/vsftpd.conf
echo "reverse_lookup_enable=${REVERSE_LOOKUP_ENABLE}" >> /etc/vsftpd/vsftpd.conf

&>/dev/null /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
