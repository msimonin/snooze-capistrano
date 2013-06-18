# Deploy Snooze using Capistrano on Grid'5000

## 1. Have a correct ruby environment

This deployment assume ruby 1.9.3 and bundler installed. Check rvm if you need to deal with several ruby environments.
Once it's done, you just have to launch :

    bundle install

## 2. Automatic deployment

For the master version of Snooze

    cap automatic
    
For the testing version of Snooze

    cap testing automatic
    





