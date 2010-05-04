server_type :frontend do
  requires :appname, :password, :db_root_password, :db_password, :github_project
  optionally :pulls_from
  optionally :db_location, :default => '/mnt/mysql'

  stage :to_start do
    locally do
      babushka 'EC2 Bootup',  :size => 'c1.medium',
                              :region => 'us-east-1a',
                              :ami => 'ami-19a34270',
                              :key => Auth::EC2_ROOT_KEY
    end
  end
  stage :bootup, :from => :envato_default
  stage :app_start do
    define_var :alias, :default => appname
    locally do
      babushka 'SSH alias', :alias => var(:alias),
                            :host => hostname,
                            :user => 'app',
                            :auth => Auth::EC2_APP_KEY
    end
    if pulls_from
      # sync up the keypair used
      locally { rsync "~/.ssh/#{pulls_from[:auth].name}*", "#{var(:alias)}:~/.ssh/" }
      as 'app' do
        babushka 'SSH alias', :alias => 'github',
                              :host => 'github.com',
                              :user => 'git',
                              :auth => pulls_from[:auth].name
        babushka 'add remote and switch to tracking branch',
          :repo => '~/current',
          :remote => 'origin',
          :remote_url => "github:/#{pulls_from[:github_project]}.git",
          :branch => 'master'
      end
    else
      locally do
        babushka 'Push master to remote', :remote_name => var(:alias),
                                          :remote => "var(:remote_alias):~/current"
      end
    end

    #done to avoid sudoing later - shouldn't have to do this
    babushka 'www user and group'
    babushka 'mysql software'
    # only needed for EC2
    babushka 'mysql db in correct location', :db_location => db_location

    as 'app' do
      babushka 'rails app db yaml present' #copies config/database.yml.production into place
      babushka 'git submodules up-to-date', :repo => '~/current'
      babushka 'rails app', :domain => appname,
                            :db => "mysql",
                            :db_admin_password => root_db_password,
                            :db_password => db_password
    end
  end
end

server_type :envato_default do
  stage :bootup do
    Babushka::Sources.add "geelen"
    babushka 'switch babushka install to fork', :fork => 'geelen', :branch => 'master'
    babushka 'reverse babushka sources order'
    babushka 'system', :hostname => appname
    babushka 'writable install location' #circumvents a bug in Babushka, should go away soon.
    babushka 'webserver installed'
    babushka 'user exists', :username => 'app',
                            :password => password,
                            :home_dir => '/srv/http'
    as 'app' do
      babushka 'user setup',  :github_user => 'geelen',
                              :your_ssh_public_key => Auth::EC2_APP_KEY.public_key
      babushka 'passenger deploy repo'
    end
  end
end
