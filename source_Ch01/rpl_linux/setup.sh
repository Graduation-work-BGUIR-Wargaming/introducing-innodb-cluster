#!/bin/bash
#
# Introducing MySQL InnoDB Cluster - Chapter 1 : Setup Replication (Linux)
#
# This file contains a script you can use to setup replication on a computer
# that has MySQL 5.7 or 8.0 installed. The script creates one master and three
# slaves. The instances are master (master), slave1, slave2, slave3 (slaves).
# Each is started with a corresponding config file, which is expected to be in
# the base folder. Each instance uses a different port but runs on the local
# machine.
#
# The steps to setup replication include:
# 1) initializing the data directories
# 2) launch all mysqld instances
# 3) create the replication user
# 4) start rpl 
# 5) check rpl
# 6) create initial data
#
# Prerequisite: You must have a MySQL instance installed and running.
#
# Notes on usage:
#
# - If you use a folder with spaces in the name, you will have to modify this
#   script to allow the use of spaces in the name (e.g. properly quoted strings).
# - You should change the variables at the top of this script to match your
#   choice of folder. For example, change /Users/<user> to your folder.
# - You must change the BIN and BASEDIR paths below to match the BASEDIR
#   and binary executable files location for the installed MySQL instance.
# - You can use the shutdown.sh script to orderly shutdown replication and
#   stop the MySQL instances.
#
# Dr. Charles Bell, 2018
#
BIN='/usr/sbin'
BASEDIR='/usr/'
DATADIR='/home/<user>/rpl_linux'

echo
echo Introduction to MySQL InnoDB Cluster - Ch01 : Setup MySQL Replication
echo
echo ====== Step 1 of 6: INITIALIZE DATA DIRECTORIES ======
echo "> Creating data directory root ..."
cd "$DATADIR"
rm -rf "$DATADIR/data"
mkdir "$DATADIR/data"
echo "> Initializing the master ..."
echo
$BIN/mysqld --no-defaults --user=<user> --initialize-insecure --basedir=$BASEDIR --datadir="$DATADIR/data/master"
echo
echo "> Initializing slave1 ..."
echo
$BIN/mysqld --no-defaults --user=<user> --initialize-insecure --basedir=$BASEDIR --datadir="$DATADIR/data/slave1"
echo
echo "> Initializing slave2 ..."
echo
$BIN/mysqld --no-defaults --user=<user> --initialize-insecure --basedir=$BASEDIR --datadir="$DATADIR/data/slave2"
echo
echo "> Initializing slave3 ..."
echo
$BIN/mysqld --no-defaults --user=<user> --initialize-insecure --basedir=$BASEDIR --datadir="$DATADIR/data/slave3"
echo
echo ====== Step 2 of 6: START ALL INSTANCES ======
echo "> Removing old socket file ..."
cd $DATADIR
rm *.sock*
echo "> Starting master ..."
$BIN/mysqld --defaults-file="$DATADIR/master.cnf" > master_output.txt 2>&1 &
echo "> Starting slave1 ..."
$BIN/mysqld --defaults-file="$DATADIR/slave1.cnf" > slave1_output.txt 2>&1 &
echo "> Starting slave2 ..."
$BIN/mysqld --defaults-file="$DATADIR/slave2.cnf" > slave2_output.txt 2>&1 &
echo "> Starting slave3 ..."
$BIN/mysqld --defaults-file="$DATADIR/slave3.cnf" > slave3_output.txt 2>&1 &
sleep 5
echo
echo ====== Step 3 of 6: CREATE THE REPLICATION USER ======
echo "> Creating replication user on the master ..."
mysql -uroot -h 127.0.0.1 -e "source /home/<user>/rpl_linux/create_rpl_user.sql" --port=13001
echo "> Creating replication user on slave1 ..."
mysql -uroot -h 127.0.0.1 -e "source /home/<user>/rpl_linux/create_rpl_user.sql" --port=13002
echo "> Creating replication user on slave2 ..."
mysql -uroot -h 127.0.0.1 -e "source /home/<user>/rpl_linux/create_rpl_user.sql" --port=13003
echo "> Creating replication user on slave3 ..."
mysql -uroot -h 127.0.0.1 -e "source /home/<user>/rpl_linux/create_rpl_user.sql" --port=13004
echo
echo ====== Step 4 of 6: START RPL ======
echo "> Executing CHANGE MASTER on slave1 ..."
mysql -uroot -h 127.0.0.1 -e "source /home/<user>/rpl_linux/change_master.sql" --port=13002
echo "> Executing START SLAVE on slave1 ..."
mysql -uroot -h 127.0.0.1 -e "START SLAVE" --port=13002
mysql -uroot -h 127.0.0.1 -e "source /home/<user>/rpl_linux/change_master.sql" --port=13003
echo "> Executing START SLAVE on slave2 ..."
mysql -uroot -h 127.0.0.1 -e "START SLAVE" --port=13003
mysql -uroot -h 127.0.0.1 -e "source /home/<user>/rpl_linux/change_master.sql" --port=13004
echo "> Executing START SLAVE on slave3 ..."
mysql -uroot -h 127.0.0.1 -e "START SLAVE" --port=13004
echo
echo ====== Step 5 of 6: CHECK RPL ======
echo "> Checking replication setup ..."
mysql -uroot -h 127.0.0.1 -e "source /home/<user>/rpl_linux/check_rpl.sql" --port=13001
echo
echo ====== Step 6 of 6: CREATE SOME DATA ======
echo "> Creating data ..."
mysql -uroot -h 127.0.0.1 -e "source /home/<user>/rpl_linux/sample_data.sql" --port=13001
sleep 3
mysql -uroot -h 127.0.0.1 -e "SELECT * FROM test.t1" --port=13003
echo Done.
echo
