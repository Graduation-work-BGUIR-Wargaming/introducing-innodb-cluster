#!/bin/sh
# This file contains the setup commands used to start the tests for using MEB'
# with GR. Specifically, this file contains commands to start (4) mysqld
# instances and establish group replication among them.
#
# Note: All of the files reside in a local directory such as /Volumes/Macintosh_Data/cbell/source/gr_macos. If
#       you wish to run these commands, substitute the correct directory in the
#       commands.
#
# Note: Change the user to your user account or appropriate surrogate.
#
# The instances are primary (primary), secondary1, secondary2, secondary3 (secondaries). Each is started with
# a corresponding config file, which is expected to be in the base directory.
# Each instance uses a different port but runs on the local machine.
#
# The steps include:
# 1) initializing the data directories
# 2) launch all mysqld instances
# 3) install the GR plugin
# 4) create the replication user
# 5) start GR
# 6) check GR
# 7) create initial data

echo ====== Step 1 of 7: INITIALIZE DATA DIRECTORIES ======

cd /Volumes/Macintosh_Data/cbell/source/gr_macos
rm -rf /Volumes/Macintosh_Data/cbell/source/gr_macos/data
mkdir /Volumes/Macintosh_Data/cbell/source/gr_macos/data
mysqld --no-defaults --user=cbell --initialize-insecure --basedir=/usr/local/mysql-8.0.3-rc-macos10.12-x86_64/ --datadir=/Volumes/Macintosh_Data/cbell/source/gr_macos/data/primary
mysqld --no-defaults --user=cbell --initialize-insecure --basedir=/usr/local/mysql-8.0.3-rc-macos10.12-x86_64/ --datadir=/Volumes/Macintosh_Data/cbell/source/gr_macos/data/secondary1
mysqld --no-defaults --user=cbell --initialize-insecure --basedir=/usr/local/mysql-8.0.3-rc-macos10.12-x86_64/ --datadir=/Volumes/Macintosh_Data/cbell/source/gr_macos/data/secondary2
mysqld --no-defaults --user=cbell --initialize-insecure --basedir=/usr/local/mysql-8.0.3-rc-macos10.12-x86_64/ --datadir=/Volumes/Macintosh_Data/cbell/source/gr_macos/data/secondary3

echo ====== Step 2 of 7: START ALL INSTANCES ======

cd /Volumes/Macintosh_Data/cbell/source/gr_macos
rm *.sock*
mysqld --defaults-file=/Volumes/Macintosh_Data/cbell/source/gr_macos/primary.cnf > primary_output.txt 2>&1 &
mysqld --defaults-file=/Volumes/Macintosh_Data/cbell/source/gr_macos/secondary1.cnf > secondary1_output.txt 2>&1 &
mysqld --defaults-file=/Volumes/Macintosh_Data/cbell/source/gr_macos/secondary2.cnf > secondary2_output.txt 2>&1 &
mysqld --defaults-file=/Volumes/Macintosh_Data/cbell/source/gr_macos/secondary3.cnf > secondary3_output.txt 2>&1 &

sleep 5

echo ====== Step 3 of 7: INSTALL THE GR PLUGIN ======

mysql -uroot -h 127.0.0.1 -e "INSTALL PLUGIN group_replication SONAME 'group_replication.so'" --port=24801
mysql -uroot -h 127.0.0.1 -e "INSTALL PLUGIN group_replication SONAME 'group_replication.so'" --port=24802
mysql -uroot -h 127.0.0.1 -e "INSTALL PLUGIN group_replication SONAME 'group_replication.so'" --port=24803
mysql -uroot -h 127.0.0.1 -e "INSTALL PLUGIN group_replication SONAME 'group_replication.so'" --port=24804

echo ====== Step 4 of 7: CREATE THE REPLICATION USER ======

mysql -uroot -h 127.0.0.1 -e "source create_rpl_user.sql" --port=24801
mysql -uroot -h 127.0.0.1 -e "source create_rpl_user.sql" --port=24802
mysql -uroot -h 127.0.0.1 -e "source create_rpl_user.sql" --port=24803
mysql -uroot -h 127.0.0.1 -e "source create_rpl_user.sql" --port=24804

echo ====== Step 5 of 7: START GR ======

mysql -uroot -h 127.0.0.1 -e "source start_gr_primary.sql" --port=24801
mysql -uroot -h 127.0.0.1 -e "source change_master.sql" --port=24802
mysql -uroot -h 127.0.0.1 -e "START GROUP_REPLICATION" --port=24802
mysql -uroot -h 127.0.0.1 -e "source change_master.sql" --port=24803
mysql -uroot -h 127.0.0.1 -e "START GROUP_REPLICATION" --port=24803
mysql -uroot -h 127.0.0.1 -e "source change_master.sql" --port=24804
mysql -uroot -h 127.0.0.1 -e "START GROUP_REPLICATION" --port=24804

echo ====== Step 6 of 7: CHECK GR ======

echo "Waiting for GR to start and reconcile..."
sleep 5

mysql -uroot -h 127.0.0.1 -e "source check_gr.sql" --port=24801

echo ====== Step 7 of 7: CREATE SOME DATA ======

sleep 3

mysql -uroot -h 127.0.0.1 -e "source sample_data.sql" --port=24801
mysql -uroot -h 127.0.0.1 -e "SELECT * FROM test.t1" --port=24801

echo ====== SETUP COMPLETE ======
