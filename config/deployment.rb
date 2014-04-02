# G5K global parameters
set :site, ENV['site'] || "rennes"
set :walltime, ENV['walltime'] || "01:30:00"
set :subnet, ENV['subnet'] || "slash_18"
set :vlan, ENV['vlan'] || "-1"
# For nodes reservation, see config/deploy/xp5k
