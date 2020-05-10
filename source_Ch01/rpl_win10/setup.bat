@echo off
REM
REM Introducing MySQL InnoDB Cluster - Chapter 1 : Setup Replication (Linux)
REM
REM This file contains a script you can use to setup replication on a computer
REM that has MySQL 5.7 or 8.0 installed. The script creates one master and three
REM slaves. The instances are master (master), slave1, slave2, slave3 (slaves).
REM Each is started with a corresponding config file, which is expected to be in
REM the base folder. Each instance uses a different port but runs on the local
REM machine.
REM
REM The steps to setup replication include:
REM 1) initializing the data directories
REM 2) launch all mysqld instances
REM 3) create the replication user
REM 4) start rpl 
REM 5) check rpl
REM 6) create initial data
REM
REM Prerequisite: You must have a MySQL instance installed and running.
REM
REM Notes on usage:
REM
REM - If you use a folder with spaces in the name, you will have to modify this
REM   script to allow the use of spaces in the name (e.g. properly quoted strings).
REM - You should change the variables at the top of this script to match your
REM   choice of folder. For example, change /Users/<user> to your folder.
REM - You must change the BIN and BASEDIR paths below to match the BASEDIR
REM   and binary executable files location for the installed MySQL instance.
REM - You can use the shutdown.sh script to orderly shutdown replication and
REM   stop the MySQL instances.
REM
REM Dr. Charles Bell, 2018
REM
set BIN="C:\Program Files\MySQL\MySQL Server 8.0\bin"
set BASEDIR="C:\Program Files\MySQL\MySQL Server 8.0"
set DATADIR=C:\Users\<user>\Documents\source\rpl_win10
set NL=^&echo.
echo %NL%%NL%Introduction to MySQL InnoDB Cluster - Ch01 : Setup MySQL Replication%NL%
echo ====== Step 1 of 6: INITIALIZE DATA DIRECTORIES ======
echo - Creating data directory root ...
cd %DATADIR%
rmdir /S /Q %DATADIR%\data
mkdir %DATADIR%\data
echo - Initializing the master ...
%BIN%\mysqld --no-defaults --console --user=<user> --initialize-insecure --basedir=%BASEDIR% --datadir=%DATADIR%/data/master
echo Initializing slave1 ...
%BIN%\mysqld --no-defaults --console --user=<user> --initialize-insecure --basedir=%BASEDIR% --datadir=%DATADIR%/data/slave1
echo - Initializing slave2 ...
%BIN%\mysqld --no-defaults --console --user=<user> --initialize-insecure --basedir=%BASEDIR% --datadir=%DATADIR%/data/slave2
echo - Initializing slave3 ...
%BIN%\mysqld --no-defaults --console --user=<user> --initialize-insecure --basedir=%BASEDIR% --datadir=%DATADIR%/data/slave3
echo ====== Step 2 of 6: START ALL INSTANCES ======
echo - Removing old socket file ...
cd %DATADIR%
del *.sock*
echo - Starting master ...
start "Master"  /D "C:\Program Files\MySQL\MySQL Server 8.0\bin"  mysqld.exe --defaults-file=%DATADIR%/master.cnf
echo - Starting slave1 ...
start "Slave1"  /D "C:\Program Files\MySQL\MySQL Server 8.0\bin"  mysqld.exe --defaults-file=%DATADIR%/slave1.cnf 
echo - Starting slave2 ...
start "Slave2"  /D "C:\Program Files\MySQL\MySQL Server 8.0\bin"  mysqld.exe --defaults-file=%DATADIR%/slave2.cnf 
echo - Starting slave3 ...
start "Slave3"  /D "C:\Program Files\MySQL\MySQL Server 8.0\bin"  mysqld.exe --defaults-file=%DATADIR%/slave3.cnf 
timeout /t 5 /nobreak
echo ====== Step 3 of 6: CREATE THE REPLICATION USER ======
echo - Creating replication user on the master ...
mysql -uroot -h 127.0.0.1 -e "source C:\Users\<user>\Documents\source\rpl_win10\create_rpl_user.sql" --port=13001
echo - Creating replication user on slave1 ...
mysql -uroot -h 127.0.0.1 -e "source C:\Users\<user>\Documents\source\rpl_win10\create_rpl_user.sql" --port=13002
echo - Creating replication user on slave2 ...
mysql -uroot -h 127.0.0.1 -e "source C:\Users\<user>\Documents\source\rpl_win10\create_rpl_user.sql" --port=13003
echo - Creating replication user on slave3 ...
mysql -uroot -h 127.0.0.1 -e "source C:\Users\<user>\Documents\source\rpl_win10\create_rpl_user.sql" --port=13004
echo ====== Step 4 of 6: START RPL ======
echo - Showing the master status ...
mysql -uroot -h 127.0.0.1 -e "SHOW MASTER STATUS" --port=13001
echo - Executing CHANGE MASTER on slave1 ...
mysql -uroot -h 127.0.0.1 -e "source C:\Users\<user>\Documents\source\rpl_win10\change_master.sql" --port=13002
echo - Executing START SLAVE on slave1 ...
mysql -uroot -h 127.0.0.1 -e "START SLAVE" --port=13002
echo - Executing CHANGE MASTER on slave2 ...
mysql -uroot -h 127.0.0.1 -e "source C:\Users\<user>\Documents\source\rpl_win10\change_master.sql" --port=13003
echo - Executing START SLAVE on slave2 ...
mysql -uroot -h 127.0.0.1 -e "START SLAVE" --port=13003
echo - Executing CHANGE MASTER on slave3 ...
mysql -uroot -h 127.0.0.1 -e "source C:\Users\<user>\Documents\source\rpl_win10\change_master.sql" --port=13004
echo - Executing START SLAVE on slave3 ...
mysql -uroot -h 127.0.0.1 -e "START SLAVE" --port=13004
echo ====== Step 5 of 6: CHECK RPL ======
echo - Checking replication setup ...
mysql -uroot -h 127.0.0.1 -e "source C:\Users\<user>\Documents\source\rpl_win10\check_rpl.sql" --port=13001
echo ====== Step 6 of 6: CREATE SOME DATA ======
echo - Creating data ...
mysql -uroot -h 127.0.0.1 -e "source C:\Users\<user>\Documents\source\rpl_win10\sample_data.sql" --port=13001
echo Done.%NL%
