# Introducing InnoDB Cluster
#
# This Python script is designed to setup an InnoDB Cluster in a sandbox.
# 
# Note: Change the cluster directory to match your preferred directory setup.
#
# The steps include:
# 1) create the sandbox directory
# 2) deploy instances
# 3) create the cluster
# 4) add instances to the cluster
# 5) show the cluster status
#
# Dr. Charles Bell, 2018
#
import os
import time

# Method to deploy sandbox instance
def deploy_instance(port):
    try:
        dba.deploy_sandbox_instance(port, {'sandboxDir':'c://idc_sandbox', 'password':'root'})
    except:
        print("ERROR: cannot setup the instance in the sandbox.")
    time.sleep(1)

# Add instance to cluster
def add_instance(cluster, port):
    try:
        cluster.add_instance('root:root@localhost:{0}'.format(port))
    except:
        print("ERROR: cannot add instance to cluster.")
    time.sleep(1)

print("##### STEP 1 of 5 : CREATE SANDBOX DIRECTORY #####")
os.mkdir('c://idc_sandbox')
        
print("##### STEP 2 of 5 : DEPLOY INSTANCES #####")
deploy_instance(3311)
deploy_instance(3312)
deploy_instance(3313)
deploy_instance(3314)

print("##### STEP 3 of 5 : CREATE CLUSTER #####")
shell.connect('root:root@localhost:3311')
my_cluster = dba.create_cluster('MyCluster', {'multiMaster':False})
time.sleep(1)

print("##### STEP 4 of 5 : ADD INSTANCES TO CLUSTER #####")
add_instance(my_cluster, 3312)
add_instance(my_cluster, 3313)
add_instance(my_cluster, 3314)

print("##### STEP 5 of 5 : SHOW CLUSTER STATUS #####")
shell.connect('root:root@localhost:3311')
time.sleep(1)
my_cluster = dba.get_cluster('MyCluster')
time.sleep(1)
status = my_cluster.status()
print(status)