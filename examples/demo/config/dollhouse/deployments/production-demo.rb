deployment :production do
  server "db_master" do
    task 'setup' do
      bootstrap # installs Babushka if it is't already. You need to do this at least once on every server.
      babushka 'benhoskings:system'
      babushka 'geelen:user set up from root'
    end
  end
end
