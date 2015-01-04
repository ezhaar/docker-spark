This is my minimal spark image (based on hadoop-2.4.0, scala-2.10.4)


## Run the Containers

### SSH keys Container

First we fire up the keys_host so that we can mount the **.ssh** volume in
spark container.

```bash

sudo docker run --name keyhost ezhaar/key-host

```

#### Spark Container

Now we run the Spark container

```bash

    sudo docker run -it \
    --volumes-from keyhost \
    --name spark-test \
    -h master.localdomain \
    --dns-search=localdomain \
    ezhaar/spark-1.2.0

```

* **-h** sets the hostname and adds an entry in the **/etc/hosts** file.
* **--dns-search** updates the **/etc/resolve.conf** for reverse DNS lookups.

Once the container has started, format the namenode the namenode, we are ready
to play with hadoop and spark.

```bash

hdfs namenode -format
hdfs dfs -mkdir /user
hdfs dfs -mkdir /user/root
hdfs dfs -ls
spark-shell

```

Note: Make sure to edit the *spark-env.sh*.

## Create a Spark Cluster on a Single Host

Start a couple of slaves and the master:

```bash

    # start the first slave
    sudo docker run -d \
    --volumes-from keyhost \
    --name slave1 \
    -h slave1.localdomain \
    --dns-search=localdomain \
    ezhaar/spark-1.2.0

    # start the second slave
    sudo docker run -d \
    --volumes-from keyhost \
    --name slave2 \
    -h slave2.localdomain \
    --dns-search=localdomain \
    ezhaar/spark-1.2.0

    # start the master and link the slaves
    sudo docker run -d \
    --volumes-from keyhost \
    --name master \
    -h master.localdomain \
    --link slave1:slave1 \
    --link slave2:slave2 \
    --dns-search=localdomain \
    ezhaar/spark-1.2.0

    # Now get a terminal on master
    sudo docker exec -it master /bin/bash

```
Now, all we need to do is edit the **slaves** file in **HADOOP_CONF** and
**SPARK_CONF** directories and then start the services as usual.

