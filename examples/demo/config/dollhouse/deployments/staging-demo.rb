deployment :staging do
  server "staging_server" do
    task "stats", &STATS

    task 'setup' do
      bootstrap
      babushka 'benhoskings:system'
      babushka 'geelen:user set up from root',
               :username            => 'applol',
               :password            => Auth::SERVER_PASSWORD,
               :your_ssh_public_key => File.read(Auth::KEYPAIR + '.pub'),
               :fixed_uid_and_gid   => 1001

      as "applol", :password => Auth::SERVER_PASSWORD do
        babushka 'benhoskings:user setup',
                 :your_ssh_public_key => File.read(Auth::KEYPAIR + '.pub'),
                 :github_user => 'geelen'
        babushka 'geelen:time zone set', :timezone => 'Australia/Melbourne'
        babushka 'your_deps:rails_app', COMMON_OPTIONS.merge({
          :server_name => name_in_cloud
        })
      end
    end
  end
end
