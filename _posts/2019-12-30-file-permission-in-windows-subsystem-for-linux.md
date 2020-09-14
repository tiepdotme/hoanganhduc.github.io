---
layout: blog-post
title: "File permission in Windows Subsystem for Linux"
author: "Duc A. Hoang"
categories:
  - windows
comment: true
description: This post describes how to handle file permission in Windows Subsystem for Linux
keywords: file permission, wsl
<!--published: false-->
---

This post was originally from [here](https://www.turek.dev/post/fix-wsl-file-permissions/).
Windows Subsystem for Linux (WSL) usually mounts Windows drives under `/mnt`.
However, the Linux file permission seems to be awful.
To fix this issue, simply add to `/etc/wsl.conf` (if the file does not exist, simply create it):

```bash
[automount]
enabled = true
options = "metadata,umask=22,fmask=11"
```

In short, every files now have permission `0644` and every directories have permission `0755`.

Also, add the following to `~/.profile` to fix the permission of newly created files and directories.

```bash
if [[ "$(umask)" = "0000" ]]; then
	umask 0022
fi
```