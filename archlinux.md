---
layout: blog-post
title: Arch Linux
author: Duc A. Hoang
permalink: /archlinux/
date: 2020-03-15
updated: 2020-03-15
<!--comment: true-->
description: This page contains some personal Arch Linux settings of Duc A. Hoang
keywords: arch linux, repository, installation, live ISO
published: false
---

## User Repository Information

* **Maintainer:** Duc A. Hoang.
* **Description:** A repo containing [packages I often use]({% post_url 2018-05-26-some-notes-on-installing-arch-linux %}), following [this ArchWiki tutorial](https://wiki.archlinux.org/index.php/Pacman/Tips_and_tricks#Custom_local_repository). (Packages of size larger than 100MB are not available due to [GitHub's file size limit](https://help.github.com/en/github/managing-large-files/what-is-my-disk-quota#file-and-repository-size-limitations).)
* **PGP Key ID:** [FBEAAAD6C193858F7D9BCFD73D544026D4E51506](https://keybase.io/hoanganhduc/pgp_keys.asc?fingerprint=fbeaaad6c193858f7d9bcfd73d544026d4e51506).
* **Upstream page:** [https://hoanganhduc.github.io/archlinux](https://hoanganhduc.github.io/archlinux).
* **Usage:**
  * Run the following as `root`.
```bash
pacman-key --recv-keys FBEAAAD6C193858F7D9BCFD73D544026D4E51506
pacman-key --lsign-key FBEAAAD6C193858F7D9BCFD73D544026D4E51506
```
  * Add the following to `/etc/pacman.conf`.
```bash
[hoanganhduc]
Server = https://hoanganhduc.github.io/archlinux/$arch
```

## Build Live Arch ISO

Using this repository, [Archiso](https://wiki.archlinux.org/index.php/Archiso) and some additional configurations, one can build a live Arch ISO image. To recreate what I have built, download [livearch.tar.gz]({{ site.baseurl }}/misc/livearch.tar.gz), extract it with `tar -xvf livearch.tar.gz` to obtain the `livearch` folder, then `sudo chown -R root:root livearch`, and run `./build.sh -v` inside the `livearch` folder as `root`. (You may need around 25 - 30 GB of free disk space.)

### archlinux-2020.03.14-x86_64.iso [unofficial]

* **Dowload:** [Google Drive](https://drive.google.com/open?id=1AlQm9OnWJ24AY5R69Q7vGyxFGzUVBNN4) (4.3 GB - 4,261,412,864 bytes)
* **Created:** 2020-03-15 00:46:18.699853700 +0900
* **Included Kernel:** linux-lts 4.19.101-2
* **PGP Signature:** [archlinux-2020.03.14-x86_64.iso.sig]({{ site.baseurl }}/archlinux/iso/archlinux-2020.03.14-x86_64.iso.sig)
* **MD5:** a6de7d31ddabad70a9cc693d3bf022af
* **SHA1SUM:** 40458b4d2fd6ce0a8aba6b3b328c54f2d670847d










