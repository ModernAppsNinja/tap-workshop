In the lab environment where this fork of the tap-workshop is used, we are using minikube, and need a service to automatically start minikube after boot or reboots. 
This file documents how to setup the minikubestart service. 

- Enter the following command to create the service file:
```sh
sudo bash -c 'cat << EOF > /etc/systemd/system/minikubestart.service
[Unit]
Description=minikubestart

[Service]
Type=simple
User=viadmin
ExecStart=/usr/local/bin/minikubestart.sh

[Install]
WantedBy=multi-user.target
EOF'
```

- Enter the following command to set the permissions for this file to the correct value:
`chmod 664 /etc/systemd/system/minikubestart.service`

- Enter the following command to create the service ExecStart script:
```
sudo bash -c 'cat << EOF > /usr/local/bin/minikubestart.sh
#!/bin/bash
  
mkdir -p /home/viadmin/logs
echo "the minikubestart service is initiating at: $(date)" > /home/viadmin/logs/minikubestart.log

minikube_running=$( minikube status | grep "apiserver: Running")
if [ -z "$minikube_running" ];
then echo "minikube is not running at: $(date)" >> /home/viadmin/logs/minikubestart.log
else echo "Minikube is running at: $(date)" >> /home/viadmin/logs/minikubestart.log
fi

while [ -z "$minikube_running" ]
do
        echo "attempting to start minikube at $(date)" >> /home/viadmin/logs/minikubestart.log
        minikube start | tee -a /home/viadmin/logs/minikubestart.log
        sleep 10
        minikube_running=$( minikube status | grep "apiserver: Running")
        if [ -z "$minikube_running" ];
        then
                echo "minikube is not running at: $(date)" >> /home/viadmin/logs/minikubestart.log
        else
                echo "Minikube is running at: $(date)" >> /home/viadmin/logs/minikubestart.log
        fi
done
EOF'
```

- Enter the following commands to set the correct ownership and permissions for minikubestart.sh
```
sudo chmod 744 /usr/local/bin/minikubestart.st
# because systemd will run the service as the user viadmin, set viadmin as file owner to prevent permissions error
sudo chown viadmin:viadmin /usr/local/bin/minikubestart.sh
```

- Enable the service with the following commands
```
systemctl daemon-reload
systemctl start minikubestart.service
systemctl enable minikubestart.service
```

- Enter the following command to verify the service loaded correctly:
`systemctl status minikubestart`

- To fully verify the service is working, reboot the host, and after reboot check the `minikube status` and view the minikubestart.log file with the command:
`cat /home/viadmin/logs/minikubestart.log`
- It may take a couple minutes for the minikubestart service to load minikube after a boot. To view the progress of the minikubestart service while it is running, you can `watch cat /home/viadmin/logs/minikubestart.log`

Thats it!
