#!/bin/bash
USERNAME=$1
PASSWORD=$2

useradd -m -s /bin/bash -p "$PASSWORD" "$USERNAME"

sudo -u "$USERNAME" mkdir -p /home/"$USERNAME"/Maildir/{new,cur,tmp}
echo "User $USERNAME created with Maildir."

