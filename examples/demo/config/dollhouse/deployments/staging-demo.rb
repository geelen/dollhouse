deployment :staging do
  server "staging-server" do
    instance_type "512mb"
    os "Ubuntu 10.04"
    first_boot {
      babushka 'geelen:geelen server configured'
      as "app" do
        babushka "geelen:complete staging environment"
      end
    }
  end
end
