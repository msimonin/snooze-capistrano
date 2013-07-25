# Deploy Snooze using Capistrano on Grid'5000

## 1. Have a correct ruby environment

This deployment assume ruby 1.9.3 and bundler installed. Check rvm if you need to deal with several ruby environments.
Once it's done, you just have to launch :

    bundle install

## 2. Look into the capfile the recipes you want to install

This will install a rabbitmq server, a cassandra cluster, a nfs shared directory and ... snooze. 

    recipes = ["rabbitmq", "cassandra", "nfs", "snooze"]


## 3. Automatic deployment

For the master version of Snooze

    cap automatic
    
For the testing version of Snooze

    cap testing automatic


