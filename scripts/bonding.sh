#!/bin/bash
ethtool eth0 |grep "Link detected: yes"> /dev/null
if [ $? -ne 0 ] ;then
    echo Can not detect the link of eth0
    exit 1
fi

ethtool eth1 |grep "Link detected: yes"> /dev/null
if [ $? -ne 0 ] ;then
    echo Can not detect the link of eth1
    exit 1
fi

set_rhel6_bond_config_static ()
{
    bond_name=$1
    bond_mode=$2
    ip=$3
    mask=$4
    gateway=$5
    bond_mii=$6
    bond_config_file="/etc/sysconfig/network-scripts/ifcfg-$bond_name"
    echo $bond_config_file
    if [ -f $bond_config_file ]; then
        echo "Backup original $bond_config_file to bondhelper.$bond_name"
        mv $bond_config_file /etc/sysconfig/network-scripts/bondhelper.$bond_name -f
    fi

cat << EOF > $bond_config_file
DEVICE=$bond_name
ONBOOT=yes
BOOTPROTO=static
IPADDR=$ip
NETMASK=$mask
USERCTL=no
BONDING_OPTS="mode=$bond_mode miimon=$bond_mii primary=eth0"
NM_CONTROLLED=no
EOF
    if [ -n $gateway ]; then
    echo GATEWAY=$gateway >> $bond_config_file
    fi
}
set_rhel6_bond_config_static bond0 1 192.168.1.1 255.255.255.0 192.168.1.1 100
set_rhel6_ethx_config()  {
    bond_name=$1
    eth_name=$2

    eth_config_file="/etc/sysconfig/network-scripts/ifcfg-$eth_name"
    if [ -f $eth_config_file ]; then
        echo "Backup original $eth_config_file to bondhelper.$eth_name"
        mv $eth_config_file /etc/sysconfig/network-scripts/bondhelper.$eth_name -f
    fi

    cat << EOF  > $eth_config_file
DEVICE=$eth_name
BOOTPROTO=none
ONBOOT=yes
MASTER=$bond_name
SLAVE=yes
USERCTL=no
NM_CONTROLLED=no
EOF
}

set_rhel6_ethx_config bond0 eth0
set_rhel6_ethx_config bond0 eth1

echo "Network service will be restarted."
service network restart
cat /proc/net/bonding/bond0