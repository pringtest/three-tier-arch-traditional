# AWS RDS Database Setup

## Connect to a private RDS instance using SSH & AWS SSM (Systems Manager)

1. Generate an SSH key with following command
```
cd /tmp
ssh-keygen -f my_rsa
```

2. Push your SSH Public Key to the target instance
```
aws ec2-instance-connect send-ssh-public-key \
  --instance-id <INSTANCE_ID> \
  --availability-zone <INTANCE_AZ> \
  --instance-os-user ubuntu \
  --ssh-public-key file:///tmp/my_rsa.pub
```

`Note: The SSH public keys are only available for one-time use for 60 seconds in the instance metadata. To connect to the instance successfully, you must connect using SSH within this time window. Because the keys expire, there is no need to track or manage these keys directly, as you did previously.`

3. Start SSM session and forward port 9999 on your local machine to port 22 on the target instance.
```
aws ssm start-session \
   --target <INSTANCE_ID> \
   --document-name AWS-StartPortForwardingSession \
   --parameters '{"portNumber":["22"], "localPortNumber":["9999"]}'
```

`Note: This will appear to hang because it is maintaining a tunnelling connection from port 9999 on localhost to port 22 on <INSTANCE_ID>`

4. Open tunnel to RDS via the SSM session you created above. (In another terminal)
```
ssh -i /tmp/my_rsa ubuntu@localhost \
   -p 9999 \
   -N \
   -L 3388:<RDS_ENDPOINT>:3306
```

`Note: This will appear to hang because it is maintaining a tunnelling connection between port 3388 on localhost to port 3306 on <RDS_ENDPOINT> via <INSTANCE_ID>`

5. install mariadb or mysql client on your PC.

6. Connect to the RDS instance using following command. `Password: admin123`
```
mysql -u admin -p -h 127.0.0.1 -P 3388
```

7. Create Database and Table.
```
CREATE DATABASE userdb;
SHOW DATABASES;
USE userdb;

CREATE TABLE usertable (email varchar(255), username varchar(255), PRIMARY KEY (email));

SHOW TABLES;

INSERT INTO usertable (email, username)
VALUES ('syamim_nsl@yahoo.com', 'syamim');

INSERT INTO usertable (email, username)
VALUES ('john_doe@gmail.com', 'john doe');

INSERT INTO usertable (email, username)
VALUES ('dark_vader@gmail.com', 'dark vader');

SELECT * FROM usertable;
```

8. Done and exit.