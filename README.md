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
    ezhaar/docker-spark

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


```bash

    # Start the DNS Server
    sudo docker run -d --name dns-server -h dns-server ezhaar/dnsmasq
    
    # note the ip address of dns-server
    DNS_IP=$(sudo docker inspect --format \
    '{{ .NetworkSettings.IPAddress }}' dns-server)
    
    #Start a couple of slaves and the master:

    # start the first slave
    sudo docker run -d \
    --volumes-from keyhost \
    --name slave1 \
    -h slave1.localdomain \
    --dns-search=localdomain \
    --dns=$DNS_IP
    ezhaar/docker-spark

    # start the second slave
    sudo docker run -d \
    --volumes-from keyhost \
    --name slave2 \
    -h slave2.localdomain \
    --dns-search=localdomain \
    --dns=$DNS_IP
    ezhaar/docker-spark

    # start the master
    sudo docker run -d \
    --volumes-from keyhost \
    --name master \
    -h master.localdomain \
    --dns-search=localdomain \
    --dns=$DNS_IP
    ezhaar/docker-spark

```

Now that our containers have started running, we need to update the hosts
entries on the **dns-server**.

```bash

    # enter the dns-server
    sudo docker exec -it dns-server /bin/bash
    vi /etc/hosts.localdomain
    
```

Our **hosts.localdomain** file on the **dns-server** looks like:

```bash

    172.17.0.3  master.localdomain  master
    172.17.0.4  slave1.localdomain  slave1
    172.17.0.5  slave2.localdomain  slave2

```
Restart the ``dnsmasq`` by using:

.. code-block:: bash

    /root/dnsmasq_sighup.sh

and exit from the ``dns-server``.

### Update Slaves files on Master

Get a terminal on master

```bash

    sudo docker exec -it master /bin/bash

```

Edit the **slaves** file in **HADOOP_CONF** and **SPARK_CON**` directories with
the contents:

``` bash

    slave1
    slave2

```
Now, all we need to do is edit the **slaves** file in **HADOOP_CONF** and
**SPARK_CONF** directories and then start the services as usual.

