module Auth
  KEYPAIR = Dir.glob(File.expand_path "~/.ssh/id_[dr]sa").first
  DB_USER_PASSWORD = "sekret"
  SERVER_PASSWORD = "evenmoarsekret"
end
