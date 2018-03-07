#
# Cookbook:: darigold_linux_patch
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# Create patching log directory
directory node['linux_patching']['log_directory'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Create patching run-state directory - used to handle reboot and restart of cookbook run.
directory node['linux_patching']['run_state_directory'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Read Flag from File - used to determine steps to run in this recipe (reboot, etc.)
include_recipe 'darigold_linux_patch::_patching_process' unless ::File.exist?("#{node['linux_patching']['run_state_directory']}/#{node['linux_patching']['run_state_reboot']}")

# Read Flag from File - used to determine steps to run in this recipe (reboot, etc.)
include_recipe 'darigold_linux_patch::_post_reboot' if ::File.exist?("#{node['linux_patching']['run_state_directory']}/#{node['linux_patching']['run_state_reboot']}")
