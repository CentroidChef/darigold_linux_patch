# TODO: Verify update - HOW DO I VERIFY? WHAT IS THE CRITERIA?

# TODO: Rollback (if necessary)
# yum history list
# yum history undo <ID FROM LIST>

# Execute startup script as applmgr
# execute 'startup service' do
#   command '/home/applmgr/startapp.ssl.sh'
#   user 'applmgr'
#   ignore_failure true
# end

# Delete file in chef_patch_run_state to maintain state of chef run after reboot.
file "#{node['linux_patching']['run_state_directory']}/#{node['linux_patching']['run_state_reboot']}" do
  action :delete
end

# Log post update
bash 'system-release' do
  user 'root'
  cwd node['linux_patching']['log_directory']
  code <<-EOH
  echo 'REBOOT COMPLETE' | tee -a os_level_before_2018Q1_patching
  EOH
end

# Log current server state - after patching.
bash 'uname' do
  user 'root'
  cwd node['linux_patching']['log_directory']
  code <<-EOH
  uname -a | tee -a os_level_before_2018Q1_patching
  EOH
end

bash 'system-release' do
  user 'root'
  cwd node['linux_patching']['log_directory']
  code <<-EOH
  cat /etc/system-release | tee -a os_level_before_2018Q1_patching
  EOH
end

# Remove one time run of chef-client on reboot
cron 'chef-linux-patch-reboot' do
  action :delete
  command 'chef-client'
  time :reboot
end
