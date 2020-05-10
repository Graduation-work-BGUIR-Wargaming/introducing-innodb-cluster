# Introducing InnoDB Cluster
#
# This Python script is designed to perform an orderly shutdown of an InnoDB Cluster.
# 
# Note: Change the cluster directory to match your preferred directory setup.
#
# The steps include:
# 1) connect to one of the instances
# 2) retrieve the cluster
# 3) remove the instances from the cluster
# 4) kill all instances
# 5) delete the sandbox directory
#
# Dr. Charles Bell, 2018
#
import shutil
import time

# Method to remove instance
def remove_instance(cluster, port):
    try:
        cluster.remove_instance('root@localhost:{0}'.format(port), {'password':'root', 'force':True})
    except:
        pass
    time.sleep(1)
 
# Method to kill the instance
def kill_instance(port):
    try:
        dba.kill_sandbox_instance(port, {'sandboxDir':'c://idc_sandbox'})
    except:
        pass
    time.sleep(1)
   

my_cluster = None 
try:
    print("##### STEP 1 of 5 : CONNECT TO ONE INSTANCE (3314) #####")
    shell.connect('root:root@localhost:3314')
    print("##### STEP 2 of 5 : GET THE CLUSTER #####")
    my_cluster = dba.get_cluster('MyCluster')
    time.sleep(1)
except:
    print("ERROR: cannot connect to or remove instances from cluster.")
if my_cluster:
    print("##### STEP 3 of 5 : REMOVE INSTANCES FROM THE CLUSTER #####")
    remove_instance(my_cluster, 3311)
    remove_instance(my_cluster, 3312)
    remove_instance(my_cluster, 3313)
    remove_instance(my_cluster, 3314)

print("##### STEP 4 of 5 : KILL THE INSTANCES #####")
kill_instance(3311)
kill_instance(3312)
kill_instance(3313)
kill_instance(3314)

print("##### STEP 5 of 5 : REMOVE THE SANDBOX DIRECTORY #####")
try:
    shutil.rmtree('c://idc_sandbox')
except:
    print("Cannot remove directory!")