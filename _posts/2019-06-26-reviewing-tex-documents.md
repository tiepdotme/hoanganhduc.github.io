---
layout: blog-post
title: "Reviewing TeX Documents"
author: "Duc A. Hoang"
mathjax: true
categories:
  - tex
<!--comment: true-->
description: This post contains some information collected by Duc A. Hoang on reviewing and editing TeX documents
keywords: tex, easyReview, edit, Duc A. Hoang
<!--published: false-->
---

<div class="alert alert-info" markdown="1">
<h1 class="alert-heading">Summary</h1>
This post contains some information I collected on reviewing and editing \\(\TeX\\) documents.
</div>

# `latexdiff`

`latexdiff` is a Perl script for vi­sual mark up and re­vi­sion of sig­nif­i­cant dif­fer­ences be­tween two $\LaTeX$ files. A short introduction on how to use `latexdiff` can be found [here](https://www.overleaf.com/learn/latex/Articles/Using_Latexdiff_For_Marking_Changes_To_Tex_Documents).

# `easyReview` package

Another option for editing $\TeX$ documents is to use the [`easyReview` package](https://ctan.org/pkg/easyreview). See the package's [documentation](http://mirrors.ctan.org/macros/latex/contrib/easyreview/doc/easyReview.pdf) to know how to use this package.

# `todonotes` package

The [`todonotes` pack­age](https://ctan.org/pkg/todonotes) allows the user to mark things to do later, in a sim­ple and vi­su­ally ap­peal­ing way. See its [documentation](http://ftp.jaist.ac.jp/pub/CTAN/macros/latex/contrib/todonotes/todonotes.pdf) for more information.

# `minorrevision` package

The [`minorrevision` package](https://ctan.org/pkg/minorrevision) sup­ports those who pub­lish ar­ti­cles in peer-re­viewed jour­nals. In the fi­nal stages of the re­view pro­cess, the au­thors typ­i­cally have to pro­vide an ad­di­tional doc­u­ment (such as a let­ter to the ed­i­tors), in which they pro­vide a list of mod­i­fi­ca­tions that they made to the manuscript. The pack­age au­to­mat­i­cally pro­vides line num­bers and quo­ta­tions from the manuscript, for this let­ter.
The pack­age loads the pack­age [`lineno`](https://ctan.org/pkg/lineno), so (in ef­fect) shares `lineno`'s in­com­pat­i­bil­i­ties.
