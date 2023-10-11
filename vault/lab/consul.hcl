datacenter = "dc1"
data_dir = "/opt/consul"
bind_addr = "{{ GetInterfaceIP \"ens4\" }}"
client_addr = "0.0.0.0"
log_level = "INFO"
retry_join = [
  "consul-server-1:8301",
  "consul-server-2:8301",
  "consul-server-3:8301"
]
performance = {
  raft_multiplier = 1
}
