# Setup Environment
1. `mkdir -p ~/git_projects`
1. `cd ~/git_projects`
1. `git clone https://github.com/KonkeyDong/scripts.git`
1. `cd setup`
1. `bash run_me.sh`

### Notes:

#### [Markdown File Documentation](https://guides.github.com/features/mastering-markdown/)

#### Setting Up Git Account:
```
$ git config --global user.name "<username>"
$ git config --global user.email "<email@address>"
```

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

#### VS Code Extensions
1. Markdown Preview Enhanced by Yiyi Wang (**Ctrl + k v** to display markdown in separate pane)
1. markdownlint by David Anson
1. Clojure by Andrew Lisin
1. Ruby by Peng Lv