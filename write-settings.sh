sudo scp -i factorio.pem server-settings.json ec2-user@ec2-18-133-239-115.eu-west-2.compute.amazonaws.com:/opt/factorio/config/server-settings.json
sudo ssh -i factorio.pem ec2-user@ec2-18-133-239-115.eu-west-2.compute.amazonaws.com 'docker stop factorio; docker start factorio'