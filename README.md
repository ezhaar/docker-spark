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
    -h maste.localdomain \
    --dns-search=localdomain \
    ezhaar/docker-spark

```

* **-h** sets the hostname and adds an entry in the **/etc/hosts** file.
* **--dns-search** updates the **/etc/resolve.conf** for reverse DNS lookups.

Once the container has started, format the namenode the namenode, we are ready
to play with hadoop and spark.

```bash

# start hadoop and spark
/root/start-bdas.sh

```

Note: Make sure to verify the *spark-env.sh*.



## Create a Spark Cluster on a Single Host

To create a spark cluster look at my
[github](https://github.com/ezhaar/spark-docker-deploy)
