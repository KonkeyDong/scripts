# Setup Environment
1. `mkdir -p ~/git_projects`
1. `cd ~/git_projects`
1. `git clone https://github.com/KonkeyDong/scripts.git`
1. `cd ~/git_projects/scripts/setup`
1. `bash run_me.sh`

### Notes:

#### [Markdown File Documentation](https://guides.github.com/features/mastering-markdown/)

---

#### Setting Up Git Account:
```
$ git config --global user.name "<username>"
$ git config --global user.email "<email@address>"
```

---

#### Fixing "No permission on mounted HDD"
I assume the new disk shows in your file manager and can be mounted by clicking on it, correct?

1. Locate the disk you want to set your permissions with using `sudo fdisk -l`
1. Create a mount point at **/media**: `sudo mkdir /media/name_of_your_mount_point`
1. Find your device's **UUID**: `sudo blkid -c /dev/null`
1. Edit your **fstab file** and make the disk's partition mount at boot:
`$ sudo nvim /etc/fstab`
**Inside of the fstab file**, add the following at the bottom:
`UUID=<uuid_from_step_3> /media/name_of_your_mount_point <partition_type> defaults 0 1`
1. Run: `sudo mount -a /dev/sdX /media/name_of_your_mount_point` (where '**X**' is your device from `sudo fdisk -l`)
1. Change ownership: `sudo chown -R <user>:<group> /media/name_of_your_mount_point`
(See [this post](https://forums.linuxmint.com/viewtopic.php?p=1251135#p1251135) for the steps outlined above, if needed.)

---

#### Install & Enable SSH Server
```bash
sudo apt install openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh
```

See [this link](https://www.cyberciti.biz/faq/ubuntu-linux-install-openssh-server/) for reference.

---

#### Generate SSH Key Pair
```bash
mkdir -p ~/.ssh
ssh-keygen -t rsa
```

Leave the file name as the default: `id_rsa`. Enter a passphrase, if you desire.

Cat and copy your local machine's id_rsa.pub file and send/paste that to a remote computer you want connection with. Place the *.pub file's contents inside of `~/.ssh/authorized_keys` on its very own line (usually at the very bottom). 
You may desire having your remote computer have ssh connection to your local machine. The steps are the exact same, but from the remote machine to your local machine.

See [this link](https://www.siteground.com/kb/generate_ssh_key_in_linux/) for reference.

---

#### VS Code Extensions
1. Markdown Preview Enhanced by Yiyi Wang (**Ctrl + k v** to display markdown in separate pane)
1. markdownlint by David Anson
1. Clojure by Andrew Lisin
1. Ruby by Peng Lv
