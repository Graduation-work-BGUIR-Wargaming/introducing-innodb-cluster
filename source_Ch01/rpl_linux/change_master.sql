CHANGE MASTER TO MASTER_USER='rpl_user', MASTER_PASSWORD='rpl_pass', MASTER_HOST='localhost', MASTER_PORT=13001, MASTER_LOG_FILE='master_binlog.000001', MASTER_LOG_POS=150;
# GTID option:
# CHANGE MASTER TO MASTER_USER='rpl_user', MASTER_PASSWORD='rpl_pass', MASTER_HOST='localhost', MASTER_PORT=13001, MASTER_AUTO_POSITION = 1;
