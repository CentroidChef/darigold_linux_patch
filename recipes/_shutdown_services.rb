# Execute shutdown script as applmgr
execute 'shutdown service' do
  command '/home/applmgr/stopapp.ssl.sh'
  user 'applmgr'
end

# Verify process is no longer running
