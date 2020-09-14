---
layout: blog-post
title: Manually compile Linux kernel in Manjaro
author: Duc A. Hoang
categories:
  - linux
<!--comment: true-->
description: A quick note on how to compile a Linux kernel manually in Manjaro
keywords: manjaro, linux kernel, compile, Duc A. Hoang
<!--published: false-->
---

<div class="alert alert-info" markdown="1">
<h1 class="alert-heading">Summary</h1>
This post contains a quick note on how to manually compile a [Linux kernel](https://www.kernel.org/) in Manjaro Linux. 
</div>

Let say if I want to compile Linux kernel version 4.19 for a [Manjaro Linux](https://manjaro.org/) system. First, clone the Manjaro's package repo `linux419` using

```bash
git clone https://gitlab.manjaro.org/packages/core/linux419.git
```

Change to the directory `linux419`. Every time you modify or add something to a file, add the corresponding sha256sum of the file to PKGBUILD. Then compile the kernel with the command

```bash
makepkg -s
```
