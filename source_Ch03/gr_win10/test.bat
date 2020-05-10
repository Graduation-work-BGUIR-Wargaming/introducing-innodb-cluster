@echo off
REM
REM Introducing MySQL InnoDB Cluster - Chapter 1 : Setup MySQL Group Replication
REM
REM This file contains a script you can use to setup group replication on a computer
REM that has MySQL 5.7 or 8.0 installed. The script creates one primary and three
REM secondaries. The instances are primary, secondary1, secondary2, and secondary3.
REM Each is started with a corresponding config file, which is expected to be in the
REM base folder. Each instance uses a different port but runs on the local machine.
REM
REM The steps to setup replication include:
REM 1) initializing the data directories
REM 2) launch all mysqld instances
REM 3) install the group replication plugin
REM 4) create the replication user
REM 5) start gr
REM 5) check gr
REM 6) create initial data
REM
REM Prerequisite: You must have a MySQL instance installed and running.
REM
REM Notes on usage:
REM
REM - You should place all of the source files for Chapter 1 in a folder.
REM - If you use a folder with spaces in the name, you will have to modify this
REM   script to allow the use of spaces in the name (e.g. properly quoted strings).
REM - You shold change the variables at the top of this script to match your
REM   choice of folder. For example, change /Users/cbell to your folder.
REM - You must change the BIN and BASEDIR paths below to match the BASEDIR
REM   and binary executable files location for the installed MySQL instance.
REM - You can use the shutdown.sh script to orderly shutdown replication and
REM   stop the MySQL instances.
REM
REM Dr. Charles Bell, 2018
REM
set BIN="C:\Program Files\MySQL\MySQL Server 8.0\bin"
set BASEDIR="C:\Program Files\MySQL\MySQL Server 8.0"
set DATADIR=C:\Users\olias\Documents\source\gr_win10
set NL=^&echo.
echo ====== Step 3 of 7: INSTALL GR PLUGIN ======
echo - Installing group replication plugin on primary ...
mysql -uroot -h 127.0.0.1 -e "INSTALL PLUGIN group_replication SONAME 'group_replication.dll'" --port=24801
echo - Installing group replication plugin on secondary1 ...
mysql -uroot -h 127.0.0.1 -e "INSTALL PLUGIN group_replication SONAME 'group_replication.dll'" --port=24802
echo - Installing group replication plugin on secondary2 ...
mysql -uroot -h 127.0.0.1 -e "INSTALL PLUGIN group_replication SONAME 'group_replication.dll'" --port=24803
echo - Installing group replication plugin on secondary3 ...
mysql -uroot -h 127.0.0.1 -e "INSTALL PLUGIN group_replication SONAME 'group_replication.dll'" --port=24804
echo ====== Step 4 of 7: CREATE THE REPLICATION USER ======
echo - Creating replication user on primary ...
mysql -uroot -h 127.0.0.1 -e "source create_rpl_user.sql" --port=24801
echo - Creating replication user on secondary1 ...
mysql -uroot -h 127.0.0.1 -e "source create_rpl_user.sql" --port=24802
echo - Creating replication user on secondary2 ...
mysql -uroot -h 127.0.0.1 -e "source create_rpl_user.sql" --port=24803
echo - Creating replication user on secondary3 ...
mysql -uroot -h 127.0.0.1 -e "source create_rpl_user.sql" --port=24804
echo ====== Step 5 of 7: START GR ======
echo - Starting GR on primary ...
mysql -uroot -h 127.0.0.1 -e "source start_gr_primary.sql" --port=24801
echo - Starting GR on secondary1 ...
mysql -uroot -h 127.0.0.1 -e "source change_master.sql" --port=24802
mysql -uroot -h 127.0.0.1 -e "START GROUP_REPLICATION" --port=24802
echo - Starting GR on secondary2 ...
mysql -uroot -h 127.0.0.1 -e "source change_master.sql" --port=24803
mysql -uroot -h 127.0.0.1 -e "START GROUP_REPLICATION" --port=24803
echo - Starting GR on secondary3 ...
mysql -uroot -h 127.0.0.1 -e "source change_master.sql" --port=24804
mysql -uroot -h 127.0.0.1 -e "START GROUP_REPLICATION" --port=24804
timeout /t 10 /nobreak
echo ====== Step 6 of 7: CHECK GR ======
echo - Checking replication setup ...
mysql -uroot -h 127.0.0.1 -e "source check_gr.sql" --port=24801
echo ====== Step 7 of 7: CREATE SOME DATA ======
echo - Creating data ...
mysql -uroot -h 127.0.0.1 -e "source sample_data.sql" --port=24801
echo Done.%NL%
