# BASTION Server Setup

# Access to the ec2 server in private subnet from bastion host

1. Add private key to ssh so that it can be used in subsequent command.

For mac book:
```
ssh-add -K tuto.pem
```

2. Connect to Bastion server
```
ssh -A ubuntu@<IP>.<REGION>.compute.amazonaws.com     
```

3. From bastion host connect to ec2 server using private ip of that instance.
```
ssh ubuntu@<PRIVATE-IP>
```

# References
1. https://www.youtube.com/watch?v=rn9kAXz6qxA&t=372s