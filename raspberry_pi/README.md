# SSH "Connection Refused"
Reason: As of November 2016 release, Raspbian has the SSH server disabled by default. You will have to enable it manually.

Solution: 
`sudo raspi-config` >> interface options >> enable or disable ssh server >> enable

# UK to US Keyboard Layout
`sudo dpkg-reconfigure keyboard-configuration`

Choose "US" and then reboot using:

`invoke-rc.d keyboard-setup start`

# Set Static IP Address

Add/uncomment the following into the following file:

`sudo vim /etc/dhcpcd.conf`

```
interface eth0
static ip_address=192.168.1.XX (replace XX with whatever you want)
static router=192.168.1.1 (probably)
static domain_name_servers= 192.168.1.1 (probably; same as router)
```

To find your gateway:

`route -n`

Use the `eth0` Iface.

reboot machine to take effect.

# Mount <device> <destination> wrong fs type, bad option, bad superblock error

## Set Disk Partition
```
sudo fdisk <device>
d
n
<return>
<return>
<return>
g
w
```

## Make the File System
This example uses NTFS. Notice that the device has a '1' at the end after creating the disk partition using `fdisk`:
```
sudo mkfs.ntfs /dev/sdX1
```

This may take awhile. 12 hours for a 4TB HDD.

