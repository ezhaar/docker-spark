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

Once the container has started, start the ssh service and then after formatting
the namenode, we are ready to play with hadoop and spark.

Note: Make sure to edit the *spark-env.sh*.

```bash

service ssh start
hdfs namenode -format
hdfs dfs -mkdir /user
hdfs dfs -mkdir /user/root
hdfs dfs -ls
spark-shell

```
