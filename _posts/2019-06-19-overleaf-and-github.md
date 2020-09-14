---
layout: blog-post
title: Overleaf and GitHub
author: Duc A. Hoang
categories:
  - linux
  - LaTeX
<!--comment: true-->
description: This post contains some notes of Duc A. Hoang on how to use Overleaf with GitHub
keywords: overleaf, github, Duc A. Hoang
<!--published: false-->
---

<div class="alert alert-info" markdown="1">
<h1 class="alert-heading">Summary</h1>
In this post, I describe how I sync LaTeX papers between [GitHub](https://github.com/) and [Overleaf](https://www.overleaf.com/).
</div>

Suppose you have an Overleaf project <a href="https://www.overleaf.com/project/5ce5fb7abb7ad36e4a0f60bf">https://www.overleaf.com/project/<span style="color:red">5ce5fb7abb7ad36e4a0f60bf</span></a>. Overleaf will also provide you a link <a href="https://git.overleaf.com/5ce5fb7abb7ad36e4a0f60bf">https://git.overleaf.com/<span style="color:red">5ce5fb7abb7ad36e4a0f60bf</span></a> for using with `git`.
Create a Github repository called, say `paper`, at the address, say `git@github.com/[your-github-username]/paper.git`.

# Clone Overleaf project

```bash
git clone https://git.overleaf.com/5ce5fb7abb7ad36e4a0f60bf paper
```

Overleaf may asks you to input your Overleaf's username and password. To enable credentials storage in `git`, use `git config --global credential.helper store`. For convenience, I want to rename the `origin` endpoint to `overleaf` using `git remote rename origin overleaf`. Then, when pushing and pulling Overleaf's project, I can simply use `git push -u overleaf master` and `git pull overleaf master`.

# Pushing to GitHub

```bash
git remote add github git@github.com/[your-github-username]/paper.git
git add --all .
git commit -S -m "initial commit"
git push -u github master
```

# Other configuration

I also created a `Makefile` but do not want to put it in the repository. A simple way is to create `.gitignore` file and put the name `Makefile` in that file. An example of a `Makefile` I created may be as follows.

```bash
update:
	git pull overleaf master

push:
	@read -p "Commit message: " MESSAGE; git add --all .; git commit -S -m "$$MESSAGE"; git push -u overleaf master; git push -u github master

pdf:
	pdflatex main.tex
	bibtex main.aux
	pdflatex main.tex

clean:
	rm -rf *.bbl *.pdf *.dvi *.log *.bak *.aux *.blg *.idx *.ps *.eps *.toc *.out *.snm *.nav *.xml *.bcf *.spl *.synctex.gz *~
```