SELECT * FROM performance_schema.replication_group_members \G
#SELECT * FROM performance_schema.replication_group_members;
#SELECT * FROM performance_schema.replication_group_member_stats;
#SELECT * FROM performance_schema.replication_connection_status;
#SELECT * FROM performance_schema.replication_applier_status;
SELECT member_id, member_host, member_port FROM performance_schema.global_status JOIN performance_schema.replication_group_members ON VARIABLE_VALUE=member_id WHERE VARIABLE_NAME='group_replication_primary_member';


