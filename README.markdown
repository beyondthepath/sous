# sous

An assistant for chef to handle server provisioning and other related tasks.

## Sample Usage

In a config/cluster.rb file, you'll use a DSL to define your cluster, its environments and their roles.

    # Start by defining and naming the cluster for the application.
    # You can have as many clusters as you like, and each can have
    # as many environments and roles as it needs.
    
    cluster :app_name do
    
      # (TODO) set up properties that all environments will inherit
      # for example, credentials and default instance sizes
      
      environment :production do
      
        # (TODO) set up properties that apply only to this environment
        # and override the otherwise inherited cluster properties
      
        role :app do
          # (TODO) finally, set up any properties that are specific
          # to this role alone, such as number of instances
        end
        
        role :db
        role :worker
        
      end
      
      environment :staging do
        role :app
        role :db
        role :worker
      end
      
    end

## TODO

* Cluster properties
  * DSL support to set cluster, environment and role properties in cluster.rb
  * Modeling to inherit/override properties
* Command-line interface
  * **List** the instances already running, and show their status
  * **Provision** instances for roles that do not have any running
  * **Bootstrap** newly provisioned instances so they can run Chef
  * **Configure** instances by syncing Chef cookbooks and running chef-solo

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2009 Nick Zadrozny. See LICENSE for details.

## Thanks

* [Digitaria Interactive](http://www.digitaria.com/) for sponsoring the development of the initial concept and prototype.
* [Rob Kaufman](http://notch8.com/) for suggesting "sous chef" for the name. Why is naming a project always the hardest part?
