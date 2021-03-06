# WEB Server Setup - Ubuntu Server 20.04 LTS (HVM), SSD Volume Type

## Access to the instance using SSM

1. Install SSM plugin for the AWS CLI

- For Mac
```
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac/sessionmanager-bundle.zip" -o "sessionmanager-bundle.zip"

unzip sessionmanager-bundle.zip

sudo ./sessionmanager-bundle/install -i /usr/local/sessionmanagerplugin -b /usr/local/bin/session-manager-plugin
```

2. Access to the instance
```
aws ssm start-session --target <INSTANCE_ID>
```

3. Go to ssm-user directory
```
cd
```

## Installing open source NGINX Software and configure

1. Download the NGINX signing key:
```
sudo wget http://nginx.org/keys/nginx_signing.key
```

2. Add the key:
```
sudo apt-key add nginx_signing.key
```

3. Change directory to /etc/apt.
```
cd /etc/apt
```

4. Edit the sources.list file.
```
sudo vim sources.list
```

5. Appending this text at the end
```
deb http://nginx.org/packages/ubuntu focal nginx
deb-src http://nginx.org/packages/ubuntu focal nginx
```
`Note: The focal keyword in each of these lines corresponds to Ubuntu 20.04. If you are using a different version of Ubuntu, substitute the first word of its release code name (for example, bionic for Ubuntu 18.04)`.

6. Update the NGINX software:
```
sudo apt-get update
```

7. Install NGINX:
```
sudo apt-get install nginx
```

8. Start NGINX:
```
sudo systemctl start nginx.service
```

9. Check its status:
```
sudo systemctl status nginx.service
```

10. Reboot instance
```
sudo reboot
```

11. Check default nginx webpage from ec2 public ip at browser

## Install Node.js, npm and yarn

1. Before starting, Node.js and NPM must be installed on your server. If they aren't, you'll need to add the Nodesource repository to your system. 
```
curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
```

2. Run below command to install Node.js 14.x and npm
```
sudo apt-get install -y nodejs
```

3. To install the Yarn package manager, run:
```
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null

echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt-get update && sudo apt-get install yarn
```

4. check version
```
node --version && npm --version && yarn --version
```

## Preparing the Web App - Next Js

1. git clone the repo
```
git clone https://github.com/pringtest/demo_web_server.git
```

2. go to project folder and install dependencies
```
cd demo_web_server
sudo yarn install
```

3. Copy next.config.example.js to next.config.js and fill all the environment variable
```
sudo cp next.config.example.js next.config.js
sudo vim next.config.js
```

4. build the web app
```
sudo yarn build
```

## Install PM2 and run Web App

1. Install PM2 using npm globally
```
sudo npm install pm2 -g
```

2. check version
```
pm2 --version
```

3. Run web app using PM2
```
sudo pm2 start server.config.js
```

4. Save PM2 process for when a machine was restart, PM2 can running the same configuration.
```
sudo pm2 save
sudo pm2 startup
```

5. Reboot Instance
```
sudo reboot
```

6. Check running web server
```
sudo pm2 list
```

7. Check web server locally
```
curl localhost:3000
```

## Copy nginx config to default nginx config

1. Edit nginx config file
```
sudo vim demo_web_server/nginx/nginx.conf
```

2. Copy and overwrite nginx config as default
```
sudo cp demo_web_server/nginx/nginx.conf /etc/nginx/conf.d/default.conf
```

2. To verify nginx configuration
```
sudo nginx -t
```

3. Restart nginx
```
sudo service nginx restart
```

4. Test webpage from from ec2 public ip at browser

# References
1. https://www.nginx.com/blog/setting-up-nginx/#install-nginx
2. https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html
