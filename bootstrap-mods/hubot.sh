PACKAGES="npm icu libicu libicu-devel"
BASEDIR=/home/vagrant
STACKATON=$BASEDIR/code/stackaton/
BOT=bot

yum -y install ${PACKAGES}

npm install -g hubot coffee-script

pushd $BASEDIR
# Create the Hubot Instance:
hubot --create $BOT
cd $BOT 
npm install
# add hipchat dependency into npm package.json config:
npm install hubot-hipchat@~2.6.4 --save
# Link StackStorm hubot scripts to hubot
ln -s $STACKATON/hubot/scripts/staction.coffee ./scripts/staction.coffee
# Link hubot script config
mv hubot-scripts.json hubot-scripts.json.bak
ln -s $STACKATON/hubot/hubot-scripts.json ./hubot-scripts.json
# Link StackStorm hubot starting script to hubot

ln -s $STACKATON/hubot/hubot-hipchat.sh ./hubot-hipchat.sh

# TO launch (after stackaton API server is up): 
# ./hubot-hipchat.sh &> /tmp/hubot.log &

popd


