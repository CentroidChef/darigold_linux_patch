# TODO: Determine OS Version

# Execute shutdown script as applmgr
execute 'shutdown service' do
  command '/home/applmgr/stopapp.ssl.sh'
  user 'applmgr'
  ignore_failure true
end

# TODO: Utilize proper exit codes for script above.

# Log current server state - before patching.
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

# Yum clean all
bash 'yum_clean_all' do
  user 'root'
  code <<-EOH
  yum clean all
  EOH
end

# Yum repolist
bash 'yum_repolist' do
  user 'root'
  code <<-EOH
  yum repolist
  EOH
end

# Yum update
bash 'yum_update' do
  user 'root'
  code <<-EOH
  yum update -y --exclude=kexec-tools* --exclude=system-config-kdump*
  EOH
end

# Log post update
bash 'system-release' do
  user 'root'
  cwd node['linux_patching']['log_directory']
  code <<-EOH
  echo 'REBOOT SYSTEM' | tee -a os_level_before_2018Q1_patching
  EOH
end

# Create file in chef_patch_run_state to maintain state of chef run after reboot.
file "#{node['linux_patching']['run_state_directory']}/#{node['linux_patching']['run_state_reboot']}" do
  content 'temporary file - maintain chef run state after reboot'
  mode '0755'
  owner 'root'
  group 'root'
end

# Execute chef-client on reboot
cron 'chef-linux-patch-reboot' do
  command 'sleep 60 && chef-client'
  time :reboot
end

# Reboot Server
reboot 'Rebooting to use new patch' do
  reason 'Need to reboot after applying linux patch'
  action :request_reboot
  delay_mins 1
end
