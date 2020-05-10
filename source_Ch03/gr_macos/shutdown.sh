# This file contains commands to shutdown and destroy the test GR cluster as
# setup by the commands in gr_meb_setup.txt.
#
# Note: the primary is expected to be p1, but it doesn't matter as the data
#       directories are destroyed at the end
#
# The steps include:
# 1) issue STOP GROUP_REPLICATION on all secondary servers
# 2) issue STOP GROUP_REPLICATION on the primary
# 3) shutdown all mysqld instances
# 4) destroy the data directories

echo ====== Step 1 of 4: STOP GROUP REPLICATION ON SECONDARIES ======
mysql -uroot -h 127.0.0.1 --port=24802 -e "STOP GROUP_REPLICATION"
mysql -uroot -h 127.0.0.1 --port=24803 -e "STOP GROUP_REPLICATION"
mysql -uroot -h 127.0.0.1 --port=24804 -e "STOP GROUP_REPLICATION"

echo ====== Step 2 of 4: STOP GROUP REPLICATION ON PRIMARY ======

mysql -uroot -h 127.0.0.1 --port=24801 -e "STOP GROUP_REPLICATION"

echo ====== Step 3 of 4: SHUTDOWN mysqld INSTANCES ======

mysql -uroot -h 127.0.0.1 --port=24802 -e "SHUTDOWN"
mysql -uroot -h 127.0.0.1 --port=24803 -e "SHUTDOWN"
mysql -uroot -h 127.0.0.1 --port=24804 -e "SHUTDOWN"
mysql -uroot -h 127.0.0.1 --port=24801 -e "SHUTDOWN"

echo ====== Step 4 of 4: DESTROY THE DATA DIRECTORIES ======

cd /Volumes/Macintosh_Data/cbell/source/gr_macos
rm -rf data/

echo ====== SHUTDOWN COMPLETE ======
