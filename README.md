# Deploy Snooze using Capistrano on Grid'5000

## 1. Have a correct ruby environment

This deployment assume ruby 1.9.3 (or newer) and bundler installed. Check rvm if you need to deal with several ruby environments.
Once it's done, you just have to launch :

    bundle install

## 2. Check available tasks


List all the available tasks : 
```
cap -T
```


## 3. Check the deployment parameters

* Open *config/deploy.rb* and replace the ssh settings with you own settings.
* Open *config/deploy/xp5k/xp5k_[version]* to check the deployment parameters (number of nodes, walltime ...)

## 4. Automatic deployment


Install the latest version of snooze cluster and all the dependency : 

```
cap automatic
```

## 5. Customizing the deployment

If you need to add custom steps to the deployment, the prefer way is to add  a new  *stage*. They are some predifined stages (master, latest, experimental, sandbox), but feel free to add yours. Adding a new stage won't conflict (too much) when updating the deployment script.
The following command will launch the task in the stage *yourstage*.

```
cap yourstage task
```



 



