#!/bin/bash
set -e

# Install Vault
curl -fsSL -o /tmp/vault.zip https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip
unzip -o -d /usr/local/bin/ /tmp/vault.zip
sudo chown root:root /usr/local/bin/vault
vault -autocomplete-install
complete -C /usr/local/bin/vault vault
setcap cap_ipc_lock=+ep /usr/local/bin/vault

# Install Consul
curl -fsSL -o /tmp/consul.zip https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip
unzip -o -d /usr/bin/ /tmp/consul.zip
chown root:root /usr/bin/consul
consul -autocomplete-install
complete -C /usr/bin/consul consul

# Copy additional files.
cp /tmp/resources/vault.service /etc/systemd/system/vault.service
cp /tmp/resources/consul.service /etc/systemd/system/consul.service

# Create groups and users
useradd --system --home /etc/vault.d --shell /bin/false vault
useradd --system --home /etc/consul.d --shell /bin/false consul

# Make directories and empty configuration files
mkdir --parents /etc/vault.d
touch /etc/vault.d/vault.hcl
chown --recursive vault:vault /etc/vault.d
chmod 640 /etc/vault.d/vault.hcl
mkdir --parents /etc/consul.d
touch /etc/consul.d/consul.hcl
chown --recursive consul:consul /etc/consul.d
chmod 640 /etc/consul.d/consul.hcl

# Create Consul data directory
mkdir --parents /opt/consul
chown --recursive consul:consul /opt/consul

# Enable servcices
systemctl daemon-reload
systemctl enable vault.service
systemctl enable consul.service
