#!/bin/bash
#
# Introducing MySQL InnoDB Cluster - Chapter 1 : Shutdown Replication
#
# This file contains a script you can use to shutdown replication and stop the
# MySQL instances on a local machine. These instances can be started using the
# setup.sh script.
#
# The steps to shutdown replication include:
# 1) issue STOP SLAVE on all slaves
# 2) shutdown all mysqld instances
# 3) destroy the data directories
#
# Notes:
# - You must change the path for the DATADIR to match your system configuration.
#
# Dr. Charles Bell, 2018
#
DATADIR='/home/<user>/rpl_linux'
echo
echo Introduction to MySQL InnoDB Cluster - Ch01 : Shutdown MySQL Replication
echo
echo ====== Step 1 of 3: STOP REPLICATION ON SLAVES ======
echo "> Stopping the slave threads on slave1 ..."
mysql -uroot -h 127.0.0.1 --port=13002 -e "STOP SLAVE"
echo "> Stopping the slave threads on slave2 ..."
mysql -uroot -h 127.0.0.1 --port=13003 -e "STOP SLAVE"
echo "> Stopping the slave threads on slave3 ..."
mysql -uroot -h 127.0.0.1 --port=13004 -e "STOP SLAVE"
echo
echo ====== Step 2 of 3: SHUTDOWN mysqld INSTANCES ======
echo "> Stopping the MySQL instance for slave1 ..."
mysql -uroot -h 127.0.0.1 --port=13002 -e "SHUTDOWN"
echo "> Stopping the MySQL instance for slave2 ..."
mysql -uroot -h 127.0.0.1 --port=13003 -e "SHUTDOWN"
echo "> Stopping the MySQL instance for slave3 ..."
mysql -uroot -h 127.0.0.1 --port=13004 -e "SHUTDOWN"
echo "> Stopping the MySQL instance for the master ..."
mysql -uroot -h 127.0.0.1 --port=13001 -e "SHUTDOWN"
echo
echo ====== Step 3 of 3: DESTROY THE DATA DIRECTORIES ======
echo "> Removing data directories and the root ..."
cd "$DATADIR"
rm -rf "$DATADIR/data"
echo Done.

