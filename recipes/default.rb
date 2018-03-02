#
# Cookbook:: darigold_linux_patch
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# Shutdown software services.
include_recipe 'darigold_linux_patch::_shutdown_services'

# Determine OS Version

# Store current OS Level information into log file prior to patching.
# uname -a | tee -a os_level_before_2018Q1_patching
# cat /etc/system-release | tee -a os_level_before_2018Q1_patching

# Update the yum.repo file with the latest (create backup file)
# /etc/yum.repos.d/yum.repo

# Clear out yum cache
# yum clean all

# Check update file
# yum check-update

# Execute update of patching
# yum update --exclude=kexec-tools* --exclude=system-config-kdump*

# Reboot Server

# Verify update
