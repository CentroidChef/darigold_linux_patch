#
# Cookbook:: darigold_linux_patch
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# Create patching log directory
directory '/chef_patch_logs' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Create patching run-state directory - used to handle reboot and restart of cookbook run.
directory '/chef_patch_run_state' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Read Flag from File - used to determine steps to run in this recipe (reboot, etc.)
include_recipe 'darigold_linux_patch::_patching_process' unless ::File.exist?("/chef_patch_run_state/reboot.chef")

# TODO: Verify update - HOW DO I VERIFY? WHAT IS THE CRITERIA?

# TODO: Rollback (if necessary)
# yum history list
# yum history undo <ID FROM LIST>

# Execute startup script as applmgr
execute 'startup service' do
  command '/home/applmgr/startapp.ssl.sh'
  user 'applmgr'
  ignore_failure true
end
