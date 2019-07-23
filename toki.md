Setup notes
===========

Setup notes for projection machine (ubuntu 19.04)



```bash

snap install docker --channel=edge
# TODO: add current user to docker group

sudo apt-get install python3-dev python3-pip git make nano curl
pip3 install docker-compose

ssh-keygen -t rsa
echo >>EOF
Host violet
	HostName violet.shishnet.org
	User xxx
EOF > ~/.ssh/config
ssh-copy-id -i ~/.ssh/id_rsa.pub violet

echo >>EOF
export PATH_HOST_media=/home/toki/superlimitbreak.uk
EOF > ~/.bash_toki
echo ". ~/.bash_toki" >> ~/.bashrc
. ~/.bash_toki

mkdir -p ~/code
cd ~/code
git clone https://github.com/superLimitBreak/superLimitBreakSetup.git

mkdir -p ~/superlimitbreak.uk
#TODO: rsync media

make run_production

```

TODO:
* matrox 4 head drivers
* multiple screens agregated into 1 display
* google-chome on startup at url
