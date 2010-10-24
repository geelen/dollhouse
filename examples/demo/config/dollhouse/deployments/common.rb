# Defining constants for simple reuse of variables or tasks

STATS = lambda {
  shell "hostname"
  shell "df -h"
  shell "ifconfig"
  shell "monit status"
}

COMMON_OPTIONS = {
  :app_name => 'applol',
  :rails_root => '/data/applol/current',
  :db_name => 'applol',
  :db_username => 'marketplace',
  :db_password => Auth::DB_USER_PASSWORD,
  :db_encoding => 'utf8',
  :symlink => '~/current_app'
}
