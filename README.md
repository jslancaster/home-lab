# home-lab-k8s
Home lab k8s files

## SDM
Basic image burning command:
```bash
sudo sdm --burn /dev/sda --hostname kube-agent-001 --expand-root 2024-11-19-raspios-bookworm-arm64-lite.img
```

Setting networking information
```bash
sudo sdm --burn /dev/sda --hostname kube-agent-001 --plugin network:"ipv4-static-ip=192.168.50.201|ipv4-static-gateway=192.168.50.1|ipv4-static-dns=192.168.50.11,192.168.50.12" --expand-root 2024-11-19-raspios-bookworm-arm64-lite.img
```

## Disable Swap
```bash
sudo dphys-swapfile swapoff \
&& sudo dphys-swapfile uninstall \
&& sudo update-rc.d dphys-swapfile remove
```

# Setup kube-vip

## Generate Manifest

### Setup values for manifest generation
```bash
export VIP=192.168.50.100; export INTERFACE=eth0; KVVERSION=$(curl -sL https://api.github.com/repos/kube-vip/kube-vip/releases | jq -r ".[0].name"); alias kube-vip="ctr image pull ghcr.io/kube-vip/kube-vip:$KVVERSION; ctr run --rm --net-host ghcr.io/kube-vip/kube-vip:$KVVERSION vip /kube-vip"
```

### Generate
```bash
kube-vip manifest daemonset \
--interface $INTERFACE \
--address $VIP \
--inCluster \
--taint \
--controlplane \
--services \
--arp \
--leaderElection
```

# Ansible
Ansible is used to setup and config the cluster

## Magic Command
```bash
ansible-playbook k3s.orchestration.site -i inventory.yaml
```