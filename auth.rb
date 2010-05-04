class Auth
  EC2_GITHUB_KEY = KeyPair.from_file('~/.ssh/github_key')
  EC2_ROOT_KEY = KeyPair.from_file('~/.ssh/ec2_root_key')
  EC2_APP_KEY = KeyPair.from_file('~/.ssh/ec2_app_key')
  SIMPLEAPP_BOX_PASSWORD = "SEKURE"
end