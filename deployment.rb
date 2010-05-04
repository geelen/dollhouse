deployment :simple_app do
  servers [:everything_box]

  server :everything_box do
    based_on :frontend do
      appname "simpleapp.com"
      password Auth::SIMPLEAPP_BOX_PASSWORD
      pulls_from :git => 'company/appname.git', :auth => Auth::EC2_GITHUB_KEY
    end
    after_configuration do
      babushka 'EBS attached', :size => 50.gb, :snapshot_bucket => 'someapp_backups'
    end
  end
end
