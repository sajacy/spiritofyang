#!/bin/bash

# full stop on failure
set -exo pipefail

# This doesn't work because Oracle is run by corporate assholes.
# wget http://download.oracle.com/otn-pub/java/jdk/6u38-b05/jre-6u38-linux-x64-rpm.bin

# Download the Java file from the local network
wget --ftp-user=me ftp://192.168.1.100/jre-6u38-linux-x64-rpm.bin
chmod a+x jre-6u38-linux-x64-rpm.bin 
./jre-6u38-linux-x64-rpm.bin 

# Setup Oracle Java as the default Java runtime, instead of OpenJDK
alternatives --install /usr/bin/java java /usr/java/jre1.6.0_38/bin/java 20000
java -version
alternatives --config java

# Install JNA
yum -y install jna

# Install EPEL for CentOS 5.x
rpm -Uvh http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm

# Setup Cassandra directories
mkdir -p /var/lib/cassandra/data
mkdir -p /var/lib/cassandra/commitlog
mkdir -p /var/lib/cassandra/saved_caches
mkdir -p /var/log/cassandra

# Setup Cassandra user and group
groupadd cassandra
useradd -g cassandra cassandra

# Create the DataStax repo file
echo "[datastax]
name=DataStax Repo for Apache Cassandra
baseurl=http://rpm.datastax.com/community
enabled=1
gpgcheck=0" > /etc/yum.repos.d/datastax.repo

# Install the DataStax Cassandra 1.1 package
yum -y install dsc1.1
