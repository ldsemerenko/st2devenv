PACKAGES="nodejs npm coffee-script"

yum -y install ${PACKAGES}

npm install -g hubot

# TO CREATE the Hubot Instance:
# 
# hubot --create hubot
# cd hubot 
# npm insall
# Link StackStorm hubot scripts to hubot
# ln -s /vagrant/code/stackaton/hubot/scripts/staction.coffee ./scripts/staction.coffee
