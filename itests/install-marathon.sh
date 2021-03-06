#!/bin/bash
set -vxeu

# Default version of marathon to test against if not set by the user
[[ -f /root/marathon-version ]] && source /root/marathon-version
MARATHONVERSION="${MARATHONVERSION:-0.8.2}"

sudo apt-get update -q

# Setup
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)

# Add the repository
echo "deb http://repos.mesosphere.com/${DISTRO} ${CODENAME} main" | 
  sudo tee /etc/apt/sources.list.d/mesosphere.list
sudo apt-get -y update

# Install packages
sudo apt-get -y install oracle-java8-installer
sudo apt-get -y purge oracle-java7-installer
sudo update-java-alternatives -s java-8-oracle
sudo apt-get install oracle-java8-set-default

sudo apt-get -y --force-yes install mesos=0.23.* marathon=$MARATHONVERSION*

# WTF MARATHON?
# Why does the precise version have java7 hardcoded if it requires java8?
sudo mkdir -p /usr/lib/jvm/java-7-oracle/bin/
sudo ln -s /usr/lib/jvm/java-8-oracle/bin/java /usr/lib/jvm/java-7-oracle/bin/java
