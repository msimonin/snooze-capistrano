# Deploy Snooze using Capistrano on Grid'5000

## 1. Have a correct ruby environment

This deployment assume ruby 1.9.3 and bundler installed. Check rvm if you need to deal with several ruby environments.
Once it's done, you just have to launch :

    bundle install

## 2. Check available tasks

Different tasks are available for the different version of the snooze software.

For the master version of Snooze

    cap -T  
    or
    cap master -T
    
For the testing version, you just have to adapt a little bit : 

    cap testing -T

## 3. Check the deployment parameters

* Open *config/deploy.rb* and replace the ssh settings with you own settings.
* Open *config/deploy/xp5k/xp5k_[version]* to check the deployment parameters (number of nodes, walltime ...)

## 4. Automatic deployment


You're now ready to launch the deployment : 

    cap [version] automatic

And to start snooze cluster with : 

    cap [version] snooze:cluster:start
    


 



