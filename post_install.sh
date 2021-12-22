#!/bin/sh -x
IP_ADDRESS=$(ifconfig | grep -E 'inet.[0-9]' | grep -v '127.0.0.1' | awk '{ print $2}')

fetch https://github.com/SumGuyV5/iocage-plugin-teamspeak3server/releases/download/3.13.6/teamspeak3-server-3.13.6.1.pkg

pkg install -y teamspeak3-server-3.13.6.1.pkg
rm teamspeak3-server-3.13.6.1.pkg

sysrc teamspeak_enable="YES"
service teamspeak start

#we need to wait for the log files to be built befor we continuing on
while [ -z "$(ls -A /var/log/teamspeak)" ]
do
    sleep 15
done

echo -e "TeamSpeak3 Server now installed.\n" > /root/PLUGIN_INFO
echo -e "\nConnect to your Team Speak server at ${IP_ADDRESS}\n" >> /root/PLUGIN_INFO
cat /var/log/teamspeak/*.log >> /root/PLUGIN_INFO
