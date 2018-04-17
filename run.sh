#!/bin/bash 

sudo cp -v service_files/dummy.service /etc/systemd/system/dummy.service
sudo cp -v service_files/dummy.socket /etc/systemd/system/dummy.socket 

sudo systemctl daemon-reload
sudo systemctl enable dummy.service 
sudo systemctl start dummy.service 
