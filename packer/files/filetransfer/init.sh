#!/bin/bash

# Create a incoming folder
mkdir -p /home/filetransfer

# Give it to root
chown -R root:root /home/filetransfer

# Create a File Transfer User
useradd --shell /bin/false --create-home --home /home/filetransfer/incoming filetransfer

# Create a directory for the File Transfer User SSH Stuff
mkdir -p /home/filetransfer/incoming/.ssh
touch /home/filetransfer/incoming/.ssh/authorized_keys
chown -R filetransfer:filetransfer /home/filetransfer/incoming/.ssh
chown filetransfer:filetransfer /home/filetransfer/incoming/.ssh/authorized_keys

# Place the SSHD Config
cp /home/ubuntu/files/filetransfer/sshd_config /etc/ssh/sshd_config

# Set up the file deletion cronjob
echo -e "27 * * * * filetransfer bash find /home/filetransfer/incoming/*.csv -mtime +7 | xargs rm" | tee /etc/cron.d/delete_old_file_transfers

# Place the file status check script
cp /home/ubuntu/files/filetransfer/check_incoming_status.sh /home/filetransfer/check_incoming_status.sh
chmod 755 /home/filetransfer/check_incoming_status.sh
echo -e "13 * * * * root bash /home/filetransfer/check_incoming_status.sh" | tee /etc/cron.d/check_incoming_status

# Set up the incoming file import
echo -e "14 * * * * root bash /home/peacecorps/manage.sh sync_accounting `ls -t1 /home/filetransfer/incoming/*.csv | head -n 1`" | tee /etc/cron.d/sync_accounting