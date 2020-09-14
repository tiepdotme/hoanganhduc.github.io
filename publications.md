---
layout: default
title: "Publications"
permalink: /publications/
date: 2020-04-01
mathjax: true
description: This page contains a list of Duc A. Hoang's publications
keywords: publication, journal, conference, preprint, research, Duc A. Hoang
---

# Research Interests

* Graph Algorithms.
* [Combinatorial Reconfiguration](http://www.ecei.tohoku.ac.jp/alg/core/).

# Co-authors 

{% for author in site.data.coauthors %}{% if author.homepage != "" %}{% if author == site.data.coauthors.last %}<a href="{{ author.homepage }}">{{ author.name}}</a>. {% else %}<a href="{{ author.homepage }}">{{ author.name}}</a>, {% endif %}{% else %}{% if author == site.data.coauthors.last %}{{ author.name | append: ". " }}{% else %}{{ author.name | append: ", " }}{% endif %}{% endif %}{% endfor %}

# List of Publications

* [DBLP](https://dblp.uni-trier.de/pers/ht/h/Hoang:Duc_A=). 
* [Google Scholar](https://scholar.google.com/citations?hl=en&user=-YS4WfIAAAAJ&view_op=list_works&sortby=pubdate).
* Preprints on [arXiv](https://arxiv.org/a/hoang_d_1.html).
* [researchmap](https://researchmap.jp/hoanganhduc). 

<!-- * [BibBase](https://bibbase.org/show?bib=https%3A%2F%2Fhoanganhduc.github.io%2Fpubs.bib&theme=default&groupby=pubtype&fullnames=1&authorFirst=1&sort=-year). -->

<div class="publication">

{% bibliography --template pub_style --style pub_style --file pubs.bib %}

</div>

<!-- {% raw %} -->
<!-- <script src="https://bibbase.org/show?bib=https%3A%2F%2Fhoanganhduc.github.io%2Fpubs.bib&theme=default&groupby=pubtype&jsonp=1&css=https://hoanganhduc.github.io/static/css/custom.css"></script> -->
<!-- {% endraw %} -->
