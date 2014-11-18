sudo adduser --disabled-password --gecos "" stanley
sudo mkdir -p /home/stanley/.ssh
ssh-keygen -f /vagrant/.ssh/stanley_rsa -P ""
sudo sh -c 'cat /vagrant/.ssh/stanley_rsa.pub >> /home/stanley/.ssh/authorized_keys'
sudo chown -R stanley:stanley /home/stanley/.ssh/
sudo sh -c 'echo "stanley    ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/st2'
ssh -q -i /vagrant/.ssh/stanley_rsa stanley@localhost exit
