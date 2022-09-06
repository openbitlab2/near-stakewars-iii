# near-stakewars-iii
### Stakewars iii challenge 14 scripts

#### How to backup

This is an example on how to use the backup script, the script takes 3 arguments, the first (**-d**) that is the folder to backup the data from (in our example the data folder of our near node is located in `/root/.near/data/`), the second param (**-b**) is used to specify the folder where to save the archive (in our case we created a folder named *backups*), and the last param (**-s**) is used to specify the name of the service used to run the node (like in our case the service name is `neard.service`)

`./backup.sh -d /root/.near/data/ -b /root/chall14/backups/ -s neard.service`

#### How to restore from backup

This is an example on how to use the backup script, the script takes 3 arguments, the first (**-d**) that is the folder where to restore the data (in our example the data folder of our near node is located in `/root/.near/data/`), the second param (**-b**) is used to specify the backup archive to restore from, and the last param (**-s**) is used to specify the name of the service used to run the node (like in our case the service name is `neard.service`)

`./restore.sh -d /root/.near/data/ -b /root/chall14/backups/near_2022-09-06-14-05/data.tar.gz -s neard.service`
