---
layout: blog-post
title: Some notes on installing Arch Linux
author: Duc A. Hoang
categories:
  - linux
<!--comment: true-->
description: This post contains some notes of Duc A. Hoang on installing Arch Linux
keywords: arch linux, installation, Duc A. Hoang
<!--published: false-->
---

<div class="alert alert-info" markdown="1">
<h1 class="alert-heading">Summary</h1>
This post contains some notes I want to remember when installing Arch Linux. 
</div>

# Install Arch Linux

The official Arch Linux can be downloaded from [https://www.archlinux.org/download/](https://www.archlinux.org/download/). 
If you are new to Arch Linux, it is better to install [Manjaro Linux](https://manjaro.org/) or [Anarchy-Linux](https://anarchy-linux.org/).
The installation guide can be found at [https://wiki.archlinux.org/index.php/installation_guide](https://wiki.archlinux.org/index.php/installation_guide).
Here, I describe how I install Arch Linux to my [ASUS X44H laptop](https://www.asus.com/Laptops/X44H/).

## Create live USB of Arch Linux

I download the latest ISO from [https://www.archlinux.org/download/](https://www.archlinux.org/download/) and create a live USB with that iso file.
In a Linux system, you can use the `dd` command
```bash
dd bs=4M if=/path/to/archlinux.iso of=/dev/sdx status=progress && sync
```
In a Windows system, my recommendation is [Rufus](https://rufus.akeo.ie/) or [Ventoy](https://www.ventoy.net/).
You can also [remaster the install ISO](https://wiki.archlinux.org/index.php/Remastering_the_Install_ISO).

## Keyboard

I have the default console keymap (i.e., US), so I do not need to re-configure the keyboard layout. 
To list all available layouts, use
```bash
ls /usr/share/kbd/keymaps/**/*.map.gz
```
To set a layout, use `loadkeys` command.

## Boot mode

To verify if your computer supports [UEFI](https://wiki.archlinux.org/index.php/Unified_Extensible_Firmware_Interface), use
```bash
ls /sys/firmware/efi/efivars 
```
If the directory does not exist, your computer does not support UEFI.
In fact, my computer supports both [UEFI](https://wiki.archlinux.org/index.php/Unified_Extensible_Firmware_Interface) and [BIOS](https://en.wikipedia.org/wiki/BIOS) boot modes.

## Internet connection

If you connect to the internet using wired network devices (as I do) then you can verify the connection (which is enabled on boot by the installation image) using `ping` command. 
See [this page](https://wiki.archlinux.org/index.php/Network_configuration) for more details on how to configure a network connection.

## Time settings

Use the command
```bash
timedatectl set-ntp true
```
to ensure the system clock is accurate.

**Update (2019-12-31):** I use the package `tz-data 2016j-1` (downloaded from [here](https://archive.org/download/archlinux_pkg_tzdata/tzdata-2016j-1-any.pkg.tar.xz)) in order to get an old representation of time zones (e.g., `date +%Z` will output `ICT` for the `Asia/Ho_Chi_Minh` timezone, and the latter version of `tz-data` will output `+07`). 

## Disk partitions

The command `fdisk -l` lists all available storage devices and its partitions.
Suppose that I install the system in `/dev/sda`.
To create/delete/re-size a partition in a storage device, I use [cfdisk](https://jlk.fjfi.cvut.cz/arch/manpages/man/cfdisk.8) (DOS partition tables). 
I created three partitions for `/`, `/home`, and swap. 
It is recommended that if you have less than 1GB RAM then you should spend 1GB for swap, if you have 2-4GB RAM then you should spend half of the size of RAM for swap, and otherwise you should spend 2GB for swap.
To format a partition, use the command `mkfs.filsystem_type /dev/sdax`, here `filesystem_type` can be `ext2`, `ext4`, `jfs`, etc., and `/dev/sdax` is the partiton number.
You should also format and enable the swap partition with the `mkswap` and `swapon` commands.

## Mount the system

For example,
* Mount the root partition (mount point `/`) at `/mnt`.
* Create `/mnt/home` for mounting the home partition (mount point `/home`). 
* I have Windows OS installed in a partition, so I create `/mnt/windows` directory for mounting the partition.

## Basic packages

```bash
pacstrap /mnt base base-devel linux-lts linux-lts-headers linux-firmware
```
It might be safer to use the [Linux LTS kernel](https://www.archlinux.org/packages/core/x86_64/linux-lts/) instead of the latest one.

**Update (2020-03-13):** When using LTS kernel versions `>= 5.4.17-1`, the webcam of my ASUS X44H laptop only shows a black screen. Downgrading to version `4.19.101-2` resovles this issue.

I also want to use `wifi-menu` (a part of the [netctl](https://wiki.archlinux.org/index.php/Netctl) package) in my newly installed system, so I also use:

```bash
pacstrap /mnt netctl iw dialog wpa_supplicant
```

## Generate a `fstab` file

A `fstab` file defines how disk partitions, block devices or remote file systems are mounted into the filesystem.
```bash
genfstab -U /mnt >> /mnt/etc/fstab
```
The option `-U` indicates defining by [UUID](https://en.wikipedia.org/wiki/Universally_unique_identifier).
To define by labels, use option `-L`.

## Configure new system

### Change root into the new system with

```bash
arch-chroot /mnt
```

### Set timezone

```bash
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc # generate /etc/adjtime
```
For Vietnamese, the Region is `Asia`, and the City is `Ho_Chi_Minh`.

### Locale

Uncomment `en_US.UTF-8 UTF-8` and other needed localizations in `/etc/locale.gen`, and generate them with:
```bash
locale-gen
```
Set the `LANG` variable in `/etc/locale.conf` accordingly, for example `LANG=en_US.UTF-8`.

### Hostname

Create `/etc/hostname` 
```bash
echo my_hostname > /etc/hostname
```
and matching entries to `/etc/hosts`
```bash
127.0.0.1 localhost
::1 localhost
127.0.1.1 my_hostname.localdomain my_hostname
```

### Users

To change root password, use `passwd` command. 
To create a new user, use `useradd` command.
For example, 
```bash
useradd -m -g users -G audio,lp,optical,storage,video,wheel,games,power,scanner -k /etc/skel/ -s /bin/bash user
```
See [this page](https://wiki.archlinux.org/index.php/users_and_groups) for more details.
 
### Boot loader

My ASUS laptop has *Intel(R) Pentium(R) CPU B950 @ 2.10GHz* (use `cat /proc/cpuinfo` to show CPU info), so I need to first install `intel-ucode` package using

```bash
pacman -S intel-ucode
```

I also have Windows partition, so I need `os-prober` package.

```bash
pacman -S os-prober
```

I also edit `/etc/default/grub` by changing

```bash
GRUB_CMDLINE_LINUX_DEFAULT="quiet"
```
into

```bash
GRUB_CMDLINE_LINUX_DEFAULT=""
```

Now, I can run the grub installation using

```bash
grub-install /dev/sda
```

and finally generate the grub configuration file

```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

### Initramfs

I modify `/etc/mkinitcpio.conf` by changing 

```bash
HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)
```

into

```bash
HOOKS=(base udev autodetect modconf block filesystems keyboard fsck shutdown)
```

and recreate the initramfs image with

```bash
mkinitcpio -p linux-lts
```

## Reboot

Exit the chroot environment by typing `exit` or press <kbd>Ctrl</kbd> + <kbd>D</kbd>.
Unmount all the partitions with `umount -R /mnt`.
Type `reboot` to restart the system.
Remove the installation media and then login into the new system with the root account.

# Packages and Configuration

## Desktop Environments

```bash
sudo pacman -S --needed --noconfirm gnome gnome-extra gnome-flashback
sudo pacman -S --needed --noconfirm xorg xorg-server
```

## Enable Networking

```bash
sudo systemctl start NetworkManager
sudo systemctl enable NetworkManager
```

## Enable Printing Service

You must install `cups` before doing this.

```bash
sudo systemctl start org.cups.cupsd.service
sudo systemctl enable org.cups.cupsd.service
```

## Time Setting

To avoid time display error between Arch Linux and Windows, use

```bash
sudo timedatectl set-local-rtc 1 --adjust-system-clock
```

**Note:** If you log in as a normal user, run `timedatectl set-local-rtc 1 --adjust-system-clock` (without `sudo`).

## Archive Formats

```bash
yay -S --needed --noconfirm rsync unace unrar unzip zip lrzip p7zip sharutils uudeview mpack arj cabextract file-roller
```

## Packer/Yaourt/Pamac

In Arch Linux, users can add and install their favorite packages from [AUR](https://aur.archlinux.org/), aka Arch User Repository via the [pacman package manager](https://www.archlinux.org/pacman/). 
Since AUR contains about 44,000 packages, for most of them, one need to manually download, check, and install. 
This is where [packer](https://aur.archlinux.org/packages/packer/) or [yaourt](https://aur.archlinux.org/packages/yaourt/) come in handy. 
Here is how I install `yaourt`. 
(The original guide is [here](https://www.ostechnix.com/install-yaourt-arch-linux/)).

```bash
sudo pacman -S --needed --noconfirm base-devel git wget yajl
git clone https://aur.archlinux.org/package-query.git
cd package-query
makepkg -si
cd ..
git clone https://aur.archlinux.org/yaourt.git
cd yaourt
makepkg -si
cd ..
sudo rm -dR yaourt/ package-query/
```

If you need a GUI, install [pamac-aur](https://aur.archlinux.org/packages/pamac-aur/).

**Update (2018-11-14)**: Both `packer` and `yaourt` are outdated and discontinued. Use [yay](https://aur.archlinux.org/packages/yay/) (**y**et **a**nother **y**ogurt) instead.

## Theme

```bash
yay -S --needed --noconfirm arc-gtk-theme paper-icon-theme
```

## Media Codecs

```bash
yay -S --needed --noconfirm exfat-utils fuse-exfat a52dec faac faad2 flac jasper lame libdca libdv gst-libav libmad libmpeg2 libtheora libvorbis libxv wavpack x264 xvidcore gstreamer0.10-plugins flashplugin libdvdcss libdvdread libdvdnav dvd+rw-tools dvdauthor dvgrab
```

## Fonts and Keyboards

```bash
yay -S --needed --noconfirm ibus ibus-unikey ibus-anthy ttf-vietnamese-tcvn3 ttf-vietnamese-vni ttf-hannom ttf-mac-fonts ttf-monaco
```

## Enable GDM

To enable GDM (GNOME Display Manager), use

```bash
sudo systemctl start gdm
sudo systemctl enable gdm
```

##  Oracle Java & Eclipse

```bash
yay -S --needed --noconfirm jdk jdk8 jre8
sudo archlinux-java set java-11-jdk # set default Java environment
sudo pacman -S --needed --noconfirm eclipse-java
```

As `eclipse-java` and `eclipse-cpp` are in conflict, to use C/C++ Development Tools, I install [CDT 9.5.5 for Eclipse Photon and 2018-09](https://www.eclipse.org/cdt/downloads.php) in `eclipse-java` by choosing `Help > Install New Software...`, add the CDT repository [http://download.eclipse.org/tools/cdt/releases/9.5](http://download.eclipse.org/tools/cdt/releases/9.5), and install the `CDT Main Features` and `CDT Optional Features`.

## SoftMaker FreeOffice 2018

Download from [http://www.freeoffice.com/en/download](http://www.freeoffice.com/en/download).
You need to *register* to get a product key (free of charge).
Let say you download `softmaker-freeoffice-2018-931-amd64.tgz`, then the installation steps are
```bash
tar -xvzf softmaker-freeoffice-2018-931-amd64.tgz
sudo ./installfreeoffice
```
If you want to uninstall FreeOffice 2018, you can just simply run `/usr/bin/uninstall_smfreeoffice2018`.
For more information, see [this page](https://www.freeoffice.com/en/tips-and-tricks-linux).

## Missing Firmware

When running `mkinitcpio -p linux-lts`, if you get the warning

```bash
==> WARNING: Possibly missing firmware for module: wd719x
==> WARNING: Possibly missing firmware for module: aic94xx
```

then simply install the `wd719x-firmware` and `aic94xx-firmware` packages using `yay` and run `mkinitcpio -p linux-lts` again.

## Downgrade

Install the [downgrade](https://aur.archlinux.org/packages/downgrade/) package using `yay`. 
This package helps you install some previous version of a current package, which is very useful in case of conflicted dependencies. 
If you want a specific version of a package, say `netpbm-10.73-1-x86_64.pkg.tar.xz` (a dependency for `latex2html`), you can go to [https://archive.archlinux.org/packages/](https://archive.archlinux.org/packages/) to look for the package at [https://archive.archlinux.org/packages/n/netpbm](https://archive.archlinux.org/packages/n/netpbm) and install using

```bash
sudo pacman -U https://archive.archlinux.org/packages/n/netpbm/netpbm-10.73-1-x86_64.pkg.tar.xz
```

**Update (2019-12-31):** Another place to look for old Arch Linux packages is [Internet Archive](https://archive.org/search.php?query=subject%3A%22archlinux+package%22).

## (Vanilla) TeXLive 2017

There is no trouble installing Vanilla TeXLive, but I want to add some note: Install [texlive-dummy](https://aur.archlinux.org/packages/texlive-dummy/) via `yaourt` in order to tell `pacman` that you've already installed TeXLive. 
You can also install TeXLive with 

```bash
sudo pacman -S --needed --noconfirm texlive-most texlive-lang texmaker biber
```

## LaTeX2HTML

If you use `perl >= 5.26.0`, you need a workaround: add `PERL5LIB=$PERL5LIB:.; export PERL5LIB` to `/etc/bash.bashrc`. 
The reason is that LaTeX2HTML uses module `cfgcache.pm` from the installation directory, but since version `5.26.0`, `perl` no longer includes the current directory in `@INC` path (see [this page](http://search.cpan.org/dist/perl-5.26.0/pod/perldelta.pod\#Removal_of_the_current_directory_(\%22.\%22)_from_@INC)).

## pdf2htmlEX (Update: 2019-12-31)

To compile and install pdf2htmlEX (in Arch Linux 64-bit version), I use `poppler` and `poppler-glib` version `0.59.0-1`, `fontforge` version `20141126-3`, together with the [pdf2htmlex-git](https://aur.archlinux.org/packages/pdf2htmlex-git/) package. 

First, install some necessary packages

```bash
sudo pacman -S --needed --noconfirm poppler-data
wget https://archive.org/download/archlinux_pkg_automake/automake-1.15-1-any.pkg.tar.xz && sudo pacman -U automake-1.15-1-any.pkg.tar.xz
wget https://archive.org/download/archlinux_pkg_poppler-glib/poppler-glib-0.59.0-1-x86_64.pkg.tar.xz && wget https://archive.org/download/archlinux_pkg_poppler/poppler-0.59.0-1-x86_64.pkg.tar.xz && sudo pacman -U poppler-0.59.0-1-x86_64.pkg.tar.xz poppler-glib-0.59.0-1-x86_64.pkg.tar.xz 
sudo pacman -S --needed --noconfirm libxi pango giflib libtool desktop-file-utils gtk-update-icon-cache libunicodenames gc python shared-mime-info openjpeg2 qt5-base poppler-qt5
```

Then, install `poppler 0.59.0-1` from source

```bash
wget https://poppler.freedesktop.org/poppler-0.59.0.tar.xz
tar -xvf poppler-0.59.0.tar.xz
cd poppler-0.59.0/
./configure --prefix=/usr --enable-xpdf-headers
make
sudo make install
```

Next, install `fontforge 20141126-3` along with its dependencies

```bash
yay -S readline6 # for `libreadline.so.6`
wget https://archive.org/download/archlinux_pkg_libsodium/libsodium-0.7.1-1-x86_64.pkg.tar.xz && sudo pacman -U libsodium-0.7.1-1-x86_64.pkg.tar.xz
wget https://archive.org/download/archlinux_pkg_zeromq/zeromq-4.0.6-1-x86_64.pkg.tar.xz && sudo pacman -U zeromq-4.0.6-1-x86_64.pkg.tar.xz
wget https://archive.org/download/archlinux_pkg_libxkbui/libxkbui-1.0.2-6-x86_64.pkg.tar.xz && sudo pacman -U libxkbui-1.0.2-6-x86_64.pkg.tar.xz
wget https://archive.org/download/archlinux_pkg_libspiro/libspiro-1%3A0.5.20150702-2-x86_64.pkg.tar.xz && sudo pacman -U libspiro-1:0.5.20150702-2-x86_64.pkg.tar.xz
wget https://archive.org/download/archlinux_pkg_fontforge/fontforge-20141126-3-x86_64.pkg.tar.xz && sudo pacman -U fontforge-20141126-3-x86_64.pkg.tar.xz
```

Finally, install `pdf2htmlex-git` with the command `yay -S pdf2htmlex-git` and install the latest `poppler` package using `sudo pacman -S poppler poppler-glib` (otherwise, you may get an error when using the latest `pdflatex`).

## Tor Browser

When I installed [tor-browser](https://aur.archlinux.org/packages/tor-browser-en/) (via `yay`), the following error occurred

```bash
tor-browser-linux64-7.0.8_en-US.tar.xz ... FAILED (unknown public key D1483FA6C3C07136)
```

To fix this, simply import the missing PGP key, as follows.

```bash
gpg --recv-keys D1483FA6C3C07136
```

## Foxit Reader

```bash
git clone https://aur.archlinux.org/gstreamer0.10.git
cd gstreamer0.10
makepkg -si
cd ..
git clone https://aur.archlinux.org/gstreamer0.10-base.git
cd gstreamer0.10-base
makepkg -si
cd ..
git clone https://aur.archlinux.org/foxitreader.git
cd foxitreader
makepkg -si
cd ..
rm -r gstreamer0.10 gstreamer0.10-base foxitreader
```

**Update (2020-02-14):** Some errors occurred when I compiled `gstreamer0.10-base` in my recent updated Arch Linux, and I cannot figure out the reason. This installation may also not work for you.

## VMWare Horizon Client

```bash
yay -S --needed --noconfirm openssl098 gstreamer0.10-base vmware-horizon-client
```

**Update (2020-02-14):** `gstreamer0.10-base` may not be compiled, as mentioned above.

## IPE extensible drawing editor

I often use [IPE](http://ipe.otfried.org/) for drawing graphs in my papers. To install IPE in Arch Linux, you can just simply use `yay -S --needed --noconfirm ipe` (assuming you've already installed `yay`). Several useful tools (`pdftoipe`, `figtoipe`, `ipe5toxml`, `svgtoipe`) for IPE can be found in the `ipe-tools-git` package. I also use the ipelet [ipe2tikz](https://github.com/QBobWatson/ipe2tikz) to export IPE pictures to [TikZ](https://sourceforge.net/projects/pgf/) code. One thing you may want to remember when using the generated TikZ pictures is [how to scale your TikZ picture to fit the paper size](https://tex.stackexchange.com/a/11536). Several other useful ipelets are also [available](https://github.com/otfried/ipe-wiki/wiki/Ipelets). Finally, for convenience, I also create the file `/usr/share/applications/ipe.desktop` and make it executable.

```bash
[Desktop Entry]
Type=Application
Encoding=UTF-8
Name=IPE
Comment=IPE extensible drawing editor
Exec=/usr/bin/ipe
Icon=/usr/share/ipe/7.2.7/icons/ipe.png
Terminal=false
Categories=Graphics
```

**Update (2020-02-14):** I failed to build and install `ipe-tools-git` in my recent updated Arch Linux.

## ClamAV

```bash
sudo pacman -S --needed --noconfirm clamav clamtk # installation
sudo systemctl enable clamav-daemon # enable clamav-daemon
sudo systemctl start clamav-daemon # start clamav-daemon
sudo freshclam # update virus database
```

## Docker

```bash
sudo pacman -S --needed --noconfirm docker
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER # if the group `docker` does not exist then create it using `sudo groupadd docker`
```

## `pass` password manager

```bash
yay -S --noconfirm tree pass pass-import dmenu
```

If you get the error

```bash
pass-import-2.3.tar.gz ... FAILED (unknown public key C5469996F0DF68EC)
```

then run 

```bash
gpg --recv-keys C5469996F0DF68EC
```

One can also install the latest `pass-import` from its GitHub repository as follows

```bash
git clone https://github.com/roddhjav/pass-import/
cd pass-import 
sudo make install
```

See [this page](https://github.com/docker/docker-credential-helpers) for a guide on how to use `pass` with `docker`.

## Some other packages

A non-exhaustive list of some packages I installed (using `yay`) are: 

```bash
tlp lsb-release smartmontools ethtool
guake firefox thunderbird google-chrome gedit-plugins
gparted testdisk partimage xfsprogs reiserfsprogs jfsutils ntfs-3g dosfstools mtools grub-customizer hwinfo
openssh subversion git git-lfs mercurial gufw filezilla openvpn 
mlocate cups cups-pdf system-config-printer 
gnupg1 veracrypt secure-delete tree authenticator-git
goldendict pdfarranger calibre djview shutter shotwell
vlc mplayer alsa-utils pulseaudio ytmdesktop-git
dropbox-cli nautilus-dropbox skypeforlinux-stable-bin telegram-desktop pidgin irssi caprine zoom2
zotero visual-studio-code-bin
sagemath octave
windows2usb multisystem multibootusb
julia atom asymptote
tikzit # TikZiT
grive-git onedrive-abraunegg-git dislocker-git
gnome-shell-extension-appindicator libappindicator-gtk3
```

For a recommendation, see [this page](https://wiki.archlinux.org/index.php/general_recommendations) or [this page](https://novelist.xyz/tech/things-to-do-after-installing-arch-linux/). 
See [this page](https://wiki.archlinux.org/index.php/List_of_applications) for a list of available applications.

## List of installed packages

Keeping a list of installed packages is useful when you want to speed up installation on a new system or backup a working system. The command

```bash
pacman -Qqe > pkglist.txt
```

generates a list of installed packages (including packages from [AUR](https://wiki.archlinux.org/index.php/AUR)). 
The command

```bash
yay -S --needed - < pkglist.txt
```

One can also use the [reflector](https://www.archlinux.org/packages/community/any/reflector/) package for retrieving and filtering the latest Pacman mirror list.
See [pacman/Tips and tricks](https://wiki.archlinux.org/index.php/Pacman/Tips_and_tricks) for more information.


# Extra configuration and resolving issues

## Error ``Pacman is currently in use, please wait''

```bash
sudo rm /var/lib/pacman/db.lck
```

## Accessing `JAIST` or `eduroam` wifi in JAIST

[JAIST](https://www.jaist.ac.jp/) provides two wireless network services with SSIDs `JAIST` and `eduroam`. 
The [instruction](https://www.jaist.ac.jp/iscenter/en/network/wireless/) is for Windows, MacOS X, and Android. 
I figure that it can also be used for Arch Linux (and maybe some other Linux distribution). 
Basically, the wifi security information for accessing these wifi SSIDs (I use [NetworkManager](https://wiki.archlinux.org/index.php/NetworkManager) for managing network connection) is as follows.

* Security type : WPA & WPA2 Enterprise
* Authentication : TLS
* Identity : [Your JAIST account]@jaist.ac.jp (for students, sXXXXXXX@jaist.ac.jp)
* Domain : [Leave it empty]
* CA certificate : Use the file `/etc/ssl/ca-certificates.crt` (make sure that the package [ca-certificates-utils](https://www.archlinux.org/packages/core/any/ca-certificates-utils/) is installed)
* User certificate : Use the [digital certificate](https://www.jaist.ac.jp/iscenter/en/digital-certificate/) provided from JAIST
* User private key : Use the [digital certificate](https://www.jaist.ac.jp/iscenter/en/digital-certificate/) provided from JAIST
* User key password : [Your password for reading the provided digital certificate]

**Note:** Put your [digital certificate](https://www.jaist.ac.jp/iscenter/en/digital-certificate/) in some place where the path to it contains no file/folder whose name containing blank space.

## Using JAIST's SSL-VPN service

[JAIST](https://www.jaist.ac.jp/) also provides [an SSL-VPN gateway system](https://www.jaist.ac.jp/iscenter/en/remote-access/ssl-vpn/).
In Arch Linux, I download {% include files.html name="linuxsslvpn.gz" text="F5 Linux CLI (command line interface) Edge Client Installer" %} (file `linuxsslvpn.gz`) and install as follows.

```bash
tar -xvf linuxsslvpn.tgz 
sudo ./Install.sh # Answer `yes` for both questions
```

To use JAIST SSL-VPN, from the Terminal, you can use the command

```bash
f5fpc --start --host vpn.jaist.ac.jp --cert /path/to/your/jaist/digital/certificate
```

You will have to input your password for reading your digital certificate (provided from JAIST), your username (for student, sXXXXXXX), and the password of your JAIST's account.
After you successfully start the connection, you can use `f5fpc --info` to check the connection status.
At the time of writing this post, JAIST provides two VPN networks `/Common/jaist-vpn1-na` and `/Common/jaist-vpn2-na` (as shown when using `f5fpc --info`).
The `vpn1` only passes accesses to JAIST through VPN, while `vpn2` passes all accesses through VPN.

{% include image.html name="fp_jaistvpn1and2.png" caption="The difference between JAIST <code>vpn1</code> and <code>vpn2</code> (&copy; JAIST RCACI)" width="40%" %}

To use, say `vpn2`, you can use the command

```bash
f5fpc --start --host vpn.jaist.ac.jp --cert /path/to/your/jaist/digital/certificate --fname "/Common/jaist-vpn2-na"
```

To stop using JAIST SSL-VPN, use the command

```bash
f5fpc --stop
```

## Using Kyutech VPN

To use [Kyutech VPN](https://onlineguide.isc.kyutech.ac.jp/guide2017/index.php/home/2017-02-24-00-51-59/vpn.html) <span style="color:red;">[Username and Password Required]</span>, I installed `networkmanager-l2tp`, `xl2tpd`, `strongswan` and `networkmanager-strongswan` as follows (assuming that `yay` was installed).

```bash
yay -S networkmanager-l2tp xl2tpd strongswan networkmanager-strongswan
```

Then, enable and start `strongswan` and `xl2tpd`

```bash
sudo systemctl enable strongswan
sudo systemctl start strongswan
sudo systemctl enable xl2tpd
sudo systemctl start xl2tpd
```

The information for setting up VPN are as follows

* Name: Any name you want, for instance, `KIT VPN`.
* Gateway: Enter the server name as instructed by Kyutech [here](https://onlineguide.isc.kyutech.ac.jp/guide2017/index.php/home/2017-02-24-00-51-59/vpn.html).
* Username: Your username provided by Kyutech.
* Password: The password of your Kyutech account.
* IPsec Settings: Choose `Enable IPsec Tunnel to L2TP host` and enter the pre-shared key as instructed by Kyutech [here](https://onlineguide.isc.kyutech.ac.jp/guide2017/index.php/home/2017-02-24-00-51-59/vpn.html). In the `Advanced` section, click `Legacy Proposals`. 

**Update (2020-02-14):** In my recent system, clicking `Legacy Proposals` is not required.

## Anjuta opens my folders

To fix this, use the command

```bash
xdg-mime default org.gnome.Nautilus.desktop inode/directory
```

## Visual Studio Code (VS Code) opens my folders

After installing VS Code (`visual-studio-code-bin`), anything opened using the "Places" extension in GNOME opens VS Code instead of the default folder/path (as described [here](https://github.com/Microsoft/vscode/issues/41037)). To resolve this issue, I simply add the lines

```bash
[Default Applications]
inode/directory=org.gnome.Nautilus.desktop
```

to `~/.config/mimeapps.list` (or just the second line if `[Default Applications]` already exists).

## Auto reconnect Bluetooth devices at boot

The original instruction is available [here](https://bbs.archlinux.org/viewtopic.php?id=223949).

* Enable `bluetooth` service: `sudo systemctl enable bluetooth.service`.
* Set bluetooth adapter to automatically power on: edit `/etc/bluetooth/main.conf` and set `AutoEnable=true`.
* Set paired devices as trusted: Type `bluetoothctl`, it will open a new console. In that console, type `trust XX:XX:XX:XX:XX:XX` for each paired device (replace `XX...` with mac address).

## Pairing bluetooth devices on dual boot of Windows and Linux

Recently, I've bought a [HP X4000b Bluetooth Mouse](https://support.hp.com/vn-en/product/hp-x4000b-bluetooth-mouse/5286917) and having trouble when I have to re-pair the device again and again every time I switch between Arch Linux and Windows 10. Luckily, I found [this instruction](https://unix.stackexchange.com/a/255510). I describe the steps here.

* Pair all Bluetooth devices with Arch Linux.
* Pair all Bluetooth devices with Windows 10.
* Copy the Windows pairing keys
  * Install `chntpw` using `sudo pacman -S --needed --noconfirm chntpw`.
  * Mount Windows system drive.
  * `cd /[windowsSystemDrive]/Windows/System32/config`.
  * `chntpw -e SYSTEM` opens up a console. Run the following commands in that console.
  
	```bash
	cd ControlSet001\Services\BTHPORT\Parameters\Keys
	ls 
	# shows your bluetooth port's mac address, 
	# for example, the output is as follows
	# Node has 1 subkeys and 0 values
	#   key name
	#   <aa1122334455>
	cd aa1122334455  # CD into the folder
	ls # lists of existing devices' MAC addresses
	# for example, the output is as follows
	# Node has 0 subkeys and 1 values
	# size     type            value name             [value if type DWORD]
	#   16  REG_BINARY        <001f20eb4c9a>
	hex 001f20eb4c9a
	# the output is of the form
	# :00000 XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX ...ignore..chars..
	# the XXs are the pairing key
	```
  
  * Make a note of which Bluetooth device MAC address matches which paring key. In Arch Linux, we won't need the spaces in-between. Ignore the `:00000`.
  * Add the windows key to Linux config entries.
    * Switch to root `su -`.
    * `cd` to your bluetooth config location `/var/lib/bluetooth/[bth port  mac addresses)]`.
    * Here you'll find folders for each device you've paired with. The folder names being the Bluetooth devices mac address and contain a single file `info`. In these files, you'll see the link key you need to replace with your windows ones like so.
    
	```bash
	[LinkKey]
	Key=B99999999FFFFFFFFF999999999FFFFF
	```
    
  * Once updated, restart the bluetooth service `sudo systemctl restart bluetooth`.
  
* **Note:** If you Pair all Bluetooth devices with Windows 10 first, and then with Arch Linux, then the key for all systems should be the key of the last system the devices were paired, which is Arch Linux in this case.

## GnuPG

### Missing PGP keys when installing `gnupg1`

If you get the error

```bash
==> PGP keys need importing:
 -> D8692123C4065DEA5E0F3AB5249B39D24F25E3B6, required by: gnupg1
 -> 46CC730865BB5C78EBABADCF04376F3EE0856959, required by: gnupg1
 -> 031EC2536E580D8EA286A9F22071B08A33BD3F06, required by: gnupg1
 -> D238EA65D64C67ED4C3073F28A861B1C7EFD60D9, required by: gnupg1
```

when installing `gnupg1` then you can import the missing keys with the command

```bash
gpg --keyserver pgp.mit.edu --recv-keys D8692123C4065DEA5E0F3AB5249B39D24F25E3B6 46CC730865BB5C78EBABADCF04376F3EE0856959 031EC2536E580D8EA286A9F22071B08A33BD3F06 D238EA65D64C67ED4C3073F28A861B1C7EFD60D9 
```

### Remove passphrase of a secret key

Let say you want to remove the passphrase of a secret key named `PGP-key.asc`.

```bash
gpg1 --import PGP-key.asc
gpg1 --edit-key [imported PGP key fingerprint]
```

Then, type `passwd` in the `gpg>` command prompt, enter the old passhrase of the imported PGP key, and press <kbd>Enter</kbd> for the new passhrase. Answer `y` when you were asked `You don't want a passphrase - this is probably a *bad* idea! Do you really want to do this? (y/N)`. Finally, type `save` to save the result and exit the command prompt.

## Backup `$HOME` folder with `rsync`

```bash
cd /path/to/backup/directory
rsync -arvz -H --progress --numeric-ids $HOME/ .
```

## Full backup with `rsync`

See also the [ArchWiki](https://wiki.archlinux.org/index.php/Rsync#Full_system_backup).

```bash
rsync -aAXHv --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} / /path/to/backup
```

## Error "Failed to start User Manager for UID 120. See `systemctl status user@120.service` for details"

To resolve this error, simply press <kbd>Alt</kbd> + <kbd>F2</kbd>, login to the TTY shell as `root`, and run `systemctl restart gdm`. See [this page](https://bbs.archlinux.org/viewtopic.php?id=225817) for more information.

## [Laptop] Cannot enable "Tap to click" function of a touchpad

One way is to try to remove `xf86-input-synaptics` and install `xf86-input-libinput`. Also, in GNOME, enable "Tap to click" using `gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true` and `gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false`. To ensure the touchpad events are being sent to the GNOME desktop, use `gsettings set org.gnome.desktop.peripherals.touchpad send-events enabled`.

## Change the directory where `cups-pdf` outputs printed files

Edit `/etc/cups/cups-pdf.conf` by adding `Out ${HOME}/Documents/cups-pdf`. The output will be in your `$HOME/Documents/cups-pdf` directory.

## Backup and restore wired/wireless/vpn/hotspot connections with NetworkManager

By default, [NetworkManager](https://wiki.archlinux.org/index.php/NetworkManager) stores all connection files at `/etc/NetworkManager/system-connections/`, and I just simply backup all of them to, say, the `/home/[username]/NetworkConnections/` folder (where `[username]` is my username, using

```bash
sudo -s # switch to `root` user
rsync -arv /etc/NetworkManager/system-connections/* /home/[username]/NetworkConnections
```

To restore the connection files, simply copy (as `root` user) all the backup files to `/etc/NetworkManager/system-connections/`, and restart NetworkManager with `systemctl restart NetworkManager`. Note that if you want to restore these files in *a different computer*, you also need to change the corresponding MAC addresses of the devices using the commands `cd /etc/NetworkManager/system-connections && sed -i -e 's/[old mac]/[new mac]/ *`, as described [here](https://unix.stackexchange.com/a/442633). To list all network connnections, use `nmcli connection show`.

## Rollback/Restore a `pacman -Su` sytem update/upgrade with `aura`

Install the `aura` or `aura-bin` or `aura-git` package using `yay`. 
(I would suggest `aura-bin`.)
To save the list of installed packages and versions, run `sudo aura -B`.
To select a previous restore point from date-stamped list, run `sudo aura -B --restore`.
To remove all but the last 3 restore points, run `sudo aura -Bc 3`.
For more details, see [The Aura User Guide](https://fosskers.github.io/aura/).

## WebDAV

I wanted to setup a simple WebDAV configuration with my pre-installed [Apache HTTP Server](https://wiki.archlinux.org/index.php/Apache_HTTP_Server), following [this instruction](https://wiki.archlinux.org/index.php/WebDAV). 

As in the instruction, with root permission, run 

```bash
mkdir -p /home/httpd/DAV
chown -R http:http /home/httpd/DAV
mkdir -p /home/httpd/html/dav
chown -R http:http /home/httpd/html/dav
```

Now, to setup authentication, run `sudo htpasswd -c /etc/httpd/conf/passwd username`.

Then, I created `/etc/httpd/conf/http-dav.conf` with the following contents.

```bash
LoadModule dav_module modules/mod_dav.so
LoadModule dav_fs_module modules/mod_dav_fs.so
LoadModule dav_lock_module modules/mod_dav_lock.so

DAVLockDB /home/httpd/DAV/DAVLock

Alias /dav "/home/httpd/html/dav"

<Directory "/home/httpd/html/dav">
  DAV On
  AllowOverride None
  Options Indexes FollowSymLinks
  AuthType Basic
  AuthName "WebDAV"
  AuthBasicProvider file
  AuthUserFile /etc/httpd/conf/passwd
  Require valid-user
</Directory>
```

then added `Include conf/httpd-dav.conf` to `/etc/httpd/conf/httpd.conf` and finally `sudo systemctl restart httpd`. To test if these settings work, go to [http://localhost/dav](http://localhost/dav).
