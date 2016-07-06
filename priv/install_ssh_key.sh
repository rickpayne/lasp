#!/bin/bash

echo "Starting agent."
eval `ssh-agent -s`

echo "Current SSH_AUTH_SOCK:"
echo $SSH_AUTH_SOCK

echo "Changing permission on keys."
chmod 400 ssh/evaluation

echo "Passphrase"
echo $EVALUATION_PASSPHRASE

echo "Adding key to agent."
./add_key.sh

echo "Now SSH_AUTH_SOCK:"
echo $SSH_AUTH_SOCK

echo "After adding key, agent now contains the following"
ssh-add -l