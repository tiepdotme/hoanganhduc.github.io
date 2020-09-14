---
layout: blog-post
title: "Zotero, Koofr, and PaperShip"
author: "Duc A. Hoang"
categories:
  - zotero
  - linux
comment: true
description: This post contains some information regarding how to use PaperShip to sync Zotero library via Koofr's WebDAV 
keywords: zotero, webdav, Koofr, PaperShip
<!--published: false-->
---

<div class="alert alert-info" markdown="1">
<h1 class="alert-heading">Summary</h1>
This post contains some information regarding how to use [PaperShip](https://www.papershipapp.com/) to sync [Zotero](https://www.zotero.org/) library via [Koofr](https://koofr.eu/)'s WebDAV.
</div>

# Koofr

[Koofr](https://koofr.eu/) is a storage service that offers up to 10GB of free safe storage (initially you get 2GB and you can get up to 8GB by inviting friends to join Koofr) for your files with affordable upgrades and options to connect multiple cloud accounts. You can sign up to this storage service via my invite link [http://k00.fr/npeutcoc](http://k00.fr/npeutcoc).

# Zotero with Koofr via WebDAV

You can find detail instruction on how to sync Zotero library to your Koofr's account via WebDAV [here](https://koofr.eu/blog/posts/koofr-with-zotero-via-webdav). Basically, the steps I performed in Arch Linux are as follows. One can also find a list of WebDAV services which provide a free plan and which users have reported success using with Zotero [here](https://www.zotero.org/support/kb/webdav_services).

* Open the Zotero desktop client, and open the `Sync` tab via `Edit -> Preferences`.
* In `Settings` section, type in your Zotero Username and Password required in the `Data Syncing` subsection and click `Set up Syncing`.
* In `File Syncing` subsection, tick to the box `Sync attachment files in My Library using`, and then choose `WebDAV` in the dropdown menu. Next, type `app.koofr.net/dav/Koofr` into the URL text box, and type your Koofr's email and password respectively into the Username and Password text boxes.
* Finally, click `Verify Server`. A window will pop-up to let you know that file sync is successfully set up and a folder named `zotero` will be created in Koofr when that happens. Every title you add to your Zotero Library and has an attachment will be synchronised to Koofr and you will find it in `zotero` folder in Koofr as a `.zip` file.

# PaperShip in iOS 13

I use the app [PaperShip](https://www.papershipapp.com/) to sync my Zotero library to my iPhone and iPad. The Koofr's WebDAV server address is `https://app.koofr.net/dav/Koofr`. Note that one needs to create a `lastsync.txt` file (which may be empty) in the `zotero` folder in Koofr as instructed [here](https://forums.zotero.org/discussion/62579/papership-and-zotero-org-online-library-are-not-syncing) in order to make PaperShip correctly verifies the WebDAV server.

