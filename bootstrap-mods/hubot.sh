PACKAGES="npm icu libicu libicu-devel"

yum -y install ${PACKAGES}

npm install -g hubot coffee-script

# TO CREATE the Hubot Instance:
# 
# hubot --create hubot
# cd hubot 
# npm insall
# Link StackStorm hubot scripts to hubot
# ln -s /vagrant/code/stackaton/hubot/scripts/staction.coffee ./scripts/staction.coffee
