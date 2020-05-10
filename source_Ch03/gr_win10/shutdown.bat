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
REM Dr. Charles Bell, 2018
REM
set NL=^&echo.
set DATADIR=C:\Users\olias\Documents\source\gr_win10
echo %NL%%NL%Introduction to MySQL InnoDB Cluster - Ch01 : Shutdown MySQL Replication%NL%
echo ====== Step 1 of 3: STOP REPLICATION ON SLAVES ======
echo - Stopping the slave threads on secondary1 ...
mysql -uroot -h 127.0.0.1 --port=24802 -e "STOP SLAVE"
echo - Stopping the slave threads on secondary2 ...
mysql -uroot -h 127.0.0.1 --port=24803 -e "STOP SLAVE"
echo - Stopping the slave threads on secondary3 ...
mysql -uroot -h 127.0.0.1 --port=24804 -e "STOP SLAVE"
echo %NL%
echo ====== Step 2 of 3: SHUTDOWN mysqld INSTANCES ======
echo - Stopping the MySQL instance for secondary1 ...
mysql -uroot -h 127.0.0.1 --port=24802 -e "SHUTDOWN"
echo - Stopping the MySQL instance for secondary2 ...
mysql -uroot -h 127.0.0.1 --port=24803 -e "SHUTDOWN"
echo - Stopping the MySQL instance for secondary3 ...
mysql -uroot -h 127.0.0.1 --port=24804 -e "SHUTDOWN"
echo - Stopping the MySQL instance for the primary ...
mysql -uroot -h 127.0.0.1 --port=24801 -e "SHUTDOWN"
echo %NL%
echo ====== Step 3 of 3: DESTROY THE DATA DIRECTORIES ======
echo - Removing data directories and the root ...
cd %DATADIR%
rmdir %DATADIR%\data
echo Done.

