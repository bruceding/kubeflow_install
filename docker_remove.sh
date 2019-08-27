systemctl stop docker

rpm -qa | grep docker | xargs yum remove -y
