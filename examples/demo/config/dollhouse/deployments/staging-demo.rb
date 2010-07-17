deployment :staging do
  server "staging-server" do
    instance_type "512mb"
    first_boot {
      babushka 'geelen:geelen server configured'
    }
  end
end
