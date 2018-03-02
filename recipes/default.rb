#
# Cookbook:: darigold_linux_patch
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# TODO: Determine OS Version

# Execute shutdown script as applmgr
execute 'shutdown service' do
  command '/home/applmgr/stopapp.ssl.sh'
  user 'applmgr'
  ignore_failure true
end

# TODO: Utilize proper exit codes for script above.

# Create patching log directory
directory '/patch_logs' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Log current server state - before patching.
bash 'uname' do
  user 'root'
  cwd '/patch_logs'
  code <<-EOH
  uname -a | tee -a os_level_before_2018Q1_patching
  EOH
end

bash 'system-release' do
  user 'root'
  cwd '/patch_logs'
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
  cwd '/patch_logs'
  code <<-EOH
  echo 'PATCH COMPLETE' | tee -a os_level_before_2018Q1_patching
  EOH
end

# Log current server state - after patching.
bash 'uname' do
  user 'root'
  cwd '/patch_logs'
  code <<-EOH
  uname -a | tee -a os_level_before_2018Q1_patching
  EOH
end

bash 'system-release' do
  user 'root'
  cwd '/patch_logs'
  code <<-EOH
  cat /etc/system-release | tee -a os_level_before_2018Q1_patching
  EOH
end

# TODO: Reboot Server

# TODO: Verify update - HOW DO I VERIFY? WHAT IS THE CRITERIA?

# TODO: Rollback (if necessary)
# yum history list
# yum history undo <ID FROM LIST>
