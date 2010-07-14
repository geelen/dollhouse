deployment :staging do
  server "staging-server" do
    instance_type "512mb"
    first_boot {
      babushka 'envato server configured'
    }
  end
end
