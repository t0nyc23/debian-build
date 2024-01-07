#!/bin/bash

mkdir -p $HOME/Tools && cd $HOME/Tools
#apt update && apt -y install nmap git vim htop tmux recon-ng

git clone https://github.com/blechschmidt/massdns.git
cd massdns && make && sudo make install && cd $HOME/Tools

git clone https://github.com/redsiege/EyeWitness && cd $HOME/Tools/EyeWitness
apt install -y python3-venv && python3 -m venv eyewitness-venv
source eyewitness-venv/bin/activate
bash $HOME/Tools/EyeWitness/Python/setup/setup.sh
echo "source $HOME/Tools/EyeWitness/eyewitness-venv/bin/activate && $HOME/Tools/EyeWitness/Python/EyeWitness.py $@" | tee -a /usr/local/bin/eyewitness
chmod +x /usr/local/bin/eyewitness

git clone https://github.com/nsonaniya2010/SubDomainizer.git
apt install -y python3-{termcolor,bs4,requests,htmlmin,tldextract,colorama,cffi}
ln -sf $HOME/Tools/SubDomainizer/SubDomainizer.py /usr/local/bin/subdomainizer

go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/tomnomnom/httprobe@latest
go install github.com/d3mondev/puredns/v2@latest
go install github.com/OJ/gobuster/v3@latest
go install github.com/ffuf/ffuf/v2@latest
go install github.com/hakluke/hakrawler@latest
