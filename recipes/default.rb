#
# Cookbook Name:: kanban
# Recipe:: default
#
# Copyright 2011, ZeddWorks
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

chiliproject = Chef::EncryptedDataBagItem.load("apps", "chiliproject")

chiliproject_url = chiliproject["chiliproject_url"]
chiliproject_path = "/srv/rails/#{chiliproject_url}"

gem_package "aasm"

chiliproject_plugin_path = "#{chiliproject_path}/current/vendor/plugins"

git "#{chiliproject_plugin_path}/redmine_kanban" do
  repository "git://github.com/edavis10/redmine_kanban.git"
  reference "v0.2.0"
  user 'nginx'
  group 'nginx'
  action :checkout
end

execute "migrate_plugins" do
  user 'nginx'
  group 'nginx'
  command "bundle exec rake db:migrate_plugins"
  cwd chiliproject_plugin_path
  environment 'RAILS_ENV' => "production"
end
