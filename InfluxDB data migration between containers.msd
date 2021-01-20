InfluxDB data from Docker container on one host to Docker container on another host (only the data)

I know there are otehr, most likely with less steps, options out there, but this worked for me. 

Find the container ID of the relevant container. It looks a bit like this: 62e1e1b9142f

sudo docker ps

Connect to Bash in the docker container do you can run commands within the docker container:

sudo docker exec -t -i <containerID> /bin/bash

You're now in the container, now perform the back-up of the influxDB to file with the command below. If you add the "-database mydatabase" option it will backup everything.

influxd backup -portable <path-to-backup>

Example: influxd backup -portable /root/hassio.bku
Documentation from influx: https://docs.influxdata.com/influxdb/v1.8/administration/backup_and_restore/

This creates a folder (hassio.bku) with many back-up files in it.

Next we need to get the data out of the docker container since it's not persistent. If your container has rsync installed you can skip this step it think. 

sudo rsync -a /home/matthijs/hassio.bku matthijs@<targetHostIP>:/home/matthijs/hassio.bku

Note that this is performed from the originating host to the target host. 

now change to the target host and see if all files are there. 

Find the target container ID:

sudo docker ps

Next we need to copy the files into the target container

docker cp <src-path> <container>:<dest-path> 

Example: sudo docker cp /home/matthijs/hassio/hassio.bku c54e5a21448d:/root/ 
Documentation: https://kb.sitecore.net/articles/383441

ssh into the target container:

sudo docker exec -t -i c54e5a21448d /bin/bash

restore the database:

influxd restore -portable /root/hassio.bku/
