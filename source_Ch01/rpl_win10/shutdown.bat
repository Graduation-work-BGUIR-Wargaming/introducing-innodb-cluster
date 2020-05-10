@echo off
REM
REM Introducing MySQL InnoDB Cluster - Chapter 1 : Shutdown Replication
REM
REM This file contains a script you can use to shutdown replication and stop the
REM MySQL instances on a local machine. These instances can be started using the
REM setup.sh script.
REM
REM The steps to shutdown replication include:
REM 1) issue STOP SLAVE on all slaves
REM 2) shutdown all mysqld instances
REM 3) destroy the data directories
REM
REM Notes:
REM - You must change the path for the DATADIR to match your system configuration.
REM
REM Dr. Charles Bell, 2018
REM
set NL=^&echo.
set DATADIR=C:\Users\<user>\Documents\source\rpl_win10
echo %NL%%NL%Introduction to MySQL InnoDB Cluster - Ch01 : Shutdown MySQL Replication%NL%
echo ====== Step 1 of 3: STOP REPLICATION ON SLAVES ======
echo - Stopping the slave threads on slave1 ...
mysql -uroot -h 127.0.0.1 --port=13002 -e "STOP SLAVE"
echo - Stopping the slave threads on slave2 ...
mysql -uroot -h 127.0.0.1 --port=13003 -e "STOP SLAVE"
echo - Stopping the slave threads on slave3 ...
mysql -uroot -h 127.0.0.1 --port=13004 -e "STOP SLAVE"
echo %NL%
echo ====== Step 2 of 3: SHUTDOWN mysqld INSTANCES ======
echo - Stopping the MySQL instance for slave1 ..."
mysql -uroot -h 127.0.0.1 --port=13002 -e "SHUTDOWN
echo - Stopping the MySQL instance for slave2 ..."
mysql -uroot -h 127.0.0.1 --port=13003 -e "SHUTDOWN
echo - Stopping the MySQL instance for slave3 ..."
mysql -uroot -h 127.0.0.1 --port=13004 -e "SHUTDOWN
echo - Stopping the MySQL instance for the master ...
mysql -uroot -h 127.0.0.1 --port=13001 -e "SHUTDOWN"
echo %NL%
echo ====== Step 3 of 3: DESTROY THE DATA DIRECTORIES ======
echo - Removing data directories and the root ...
cd %DATADIR%
rmdir %DATADIR%\data
echo Done.

