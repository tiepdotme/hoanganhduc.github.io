---
layout: blog-post
title: "Some Beamer Tips"
author: "Duc A. Hoang"
categories:
  - tex
<!--comment: true-->
description: This post contains some tips of Duc A. Hoang on using LaTeX Beamer
keywords: tex, beamer, usage, tips, Duc A. Hoang
<!--published: false-->
---

<div class="alert alert-info" markdown="1">
<h1 class="alert-heading">Summary</h1>
This post contains some tips for using Beamer.
</div>

# Some Basic Information on Beamer Usage

* [LaTeX Wikibook](https://en.wikibooks.org/wiki/LaTeX/Presentations).

* [Beamer User Guide](http://tug.ctan.org/macros/latex/contrib/beamer/doc/beameruserguide.pdf).

* [Charles Batts Beamer Tutorial](https://www.uncg.edu/cmp/reu/presentations/Charles\%20Batts\%20-\%20Beamer\%20Tutorial.pdf).

* [Beamer Theme Gallery](http://www.deic.uab.es/~iblanes/beamer_gallery/).

# Beamer Bibliography Icon with Biblatex

The original source is at [https://tex.stackexchange.com/a/68084](https://tex.stackexchange.com/a/68084).

Add the followings to the preamble.

```latex
\documentclass{beamer}
\usepackage[style=authoryear,backend=bibtex]{biblatex}
\usepackage{hyperref}

\setbeamertemplate{bibliography item}{
  \ifboolexpr{ test {\ifentrytype{book}} or test {\ifentrytype{mvbook}}
    or test {\ifentrytype{collection}} or test {\ifentrytype{mvcollection}}
    or test {\ifentrytype{reference}} or test {\ifentrytype{mvreference}} }
    {\setbeamertemplate{bibliography item}[book]}
    {\ifentrytype{online}
       {\setbeamertemplate{bibliography item}[online]}
       {\setbeamertemplate{bibliography item}[article]}}%
  \usebeamertemplate{bibliography item}}

\defbibenvironment{bibliography}
  {\list{}
     {\settowidth{\labelwidth}{\usebeamertemplate{bibliography item}}%
      \setlength{\leftmargin}{\labelwidth}%
      \setlength{\labelsep}{\biblabelsep}%
      \addtolength{\leftmargin}{\labelsep}%
      \setlength{\itemsep}{\bibitemsep}%
      \setlength{\parsep}{\bibparsep}}}
  {\endlist}
  {\item}

\addbibresource{biblatex-examples.bib}

\nocite{glashow,markey,knuth:ct:a,knuth:ct:b,companion,bertram,ctan}
\begin{frame}[noframenumbering,plain,allowframebreaks]{References}
\printbibliography
\end{frame}

```

# Insert Logo on The Upper Right of Every Frame

Add the followings to the preamble.

```latex
\newcommand\AtPagemyUpperLeft[1]{\AtPageLowerLeft{
\put(\LenToUnit{0.88\paperwidth},\LenToUnit{0.92\paperheight}){#1}}}
\AddToShipoutPictureFG{
	\AtPagemyUpperLeft{
	{
		\includegraphics[width=1.5cm,keepaspectratio]{fig/logo.jpg}
	}
	}
}%
```

It is better to re-define ``frametitle'' to put logo on the upper-right corner, as follows:

```latex
\setbeamertemplate{frametitle}
{
    \begin{beamercolorbox}[rounded=true,sep=0.3cm,ht=1.7em,wd=\paperwidth]{frametitle}
        \insertframetitle
        \hfill
        \raisebox{-0.8mm}{\includegraphics[width=1cm]{fig/logo.png}}
    \end{beamercolorbox}
}
```

# Table of Contents at The Beginning of Every Section and Subsection

```latex
\AtBeginSection[]
{
\begin{frame}
\frametitle{Outline}
\tableofcontents[currentsection]
\end{frame}
}
\AtBeginSubsection[]
{
\begin{frame}
\frametitle{Outline}
\tableofcontents[currentsection,
		 currentsubsection,
		 hideothersubsections,
		 sectionstyle=show/shaded,
		 subsectionstyle=show/shaded,]
\end{frame}
}
```

# My Own Configuration of Some Boxes Using The `tcolorbox` Package

A manual for the `tcolorbox` package can be found [here](http://mirror.hmc.edu/ctan/macros/latex/contrib/tcolorbox/tcolorbox.pdf).

```latex
\usepackage[most]{tcolorbox}
% Highlight Oval Box
\newtcbox{\xmybox}[1][red]{on line,
arc=7pt,colback=#1!10!white,colframe=#1!50!black,
before upper={\rule[-3pt]{0pt}{10pt}},boxrule=1pt,
boxsep=0pt,left=6pt,right=6pt,top=2pt,bottom=2pt}
%% Usage: \xmybox[green]{<some content>}
% Box for stating problems
\newtcolorbox{defbox}[1]{
    enhanced,
    attach boxed title to top   left={xshift=2mm,yshift=-3mm,yshifttext=-1mm},
    colback=blue!5!white,
    colframe=blue!75!black,
    coltitle=blue!80!black,
    left=1mm,right=1mm,top=2mm,bottom=0mm,
    title={#1},
    fonttitle=\bfseries,
    boxed title style={size=small,colback=blue!5!white,colframe=blue!75!black}
}%
%% Usage \begin{defbox}{<title>} <some content> \end{defbox}
% Box for announcement
\newtcolorbox{infobox}[1]{
    enhanced,
    attach boxed title to top   left={xshift=2mm,yshift=-3mm,yshifttext=-1mm},
    colback=green!5!white,
    colframe=green!75!black,
    coltitle=green!80!black,
    left=1mm,right=1mm,top=2mm,bottom=0mm,
    title={#1},
    fonttitle=\bfseries,
    boxed title style={size=small,colback=green!5!white,colframe=green!75!black}
}%
%% Usage \begin{infobox}{<title>} <some content> \end{infobox}
% Theorem Box
\newtcbtheorem[number within=section]{thrm}%
  {Theorem}{theorem style=plain,
    enhanced jigsaw,
    top=0mm,bottom=0mm,
     fonttitle=\bfseries\upshape,fontupper=\slshape,
     colframe=blue!75!black,colback=blue!5!white,coltitle=blue!50!blue!75!black}{thrm}%
%% Usage \begin{thrm}{<title>}{<label>} <some content> \end{thrm}
%% For citation, use ref{thrm:<label>}
%% If you don't want to use numbering: \begin{thrm*}{<title>}{<label>} <some content> \end{thrm*}
```

# Creating Handout using `pgfpages`

```latex
% For Handout
\usepackage{pgfpages}
\pgfpagesuselayout{4 on 1}[a4paper,landscape=true]
```

# Several Authors with Different Institutions

The original source is at [https://tex.stackexchange.com/a/17963](https://tex.stackexchange.com/a/17963).

```latex
\author[shortname]{author1 \inst{1} \and author2 \inst{2}}
\institute[shortinst]{\inst{1} affiliation for author1 \and %
                      \inst{2} affiliation for author2}
```

# Remove Footer in the Title Page

```latex
{
\setbeamertemplate{footline}{}  % Remove footer in the title page
 
}
\addtocounter{framenumber}{-1} % Do not count the title page in frame numbering
```

# Customize Beamer Titlepage

The original tutorial is at [https://tex.stackexchange.com/a/25318](https://tex.stackexchange.com/a/25318). The idea is to use `\defbeamertemplate`.

```latex
\documentclass{beamer}
\defbeamertemplate*{title page}{customized}[1][]
{
  \usebeamerfont{title}\inserttitle\par
  \usebeamerfont{subtitle}\usebeamercolor[fg]{subtitle}\insertsubtitle\par
  
  \usebeamerfont{author}\insertauthor\par
  \usebeamerfont{institute}\insertinstitute\par
  \usebeamerfont{date}\insertdate\par
  \usebeamercolor[fg]{titlegraphic}\inserttitlegraphic
}
\title{A customized title page}
\subtitle{for demonstration}
\author{Stefan Kottwitz}
\date{\today}

```

# Adjust space between frametitle and content

The original source is at [https://latex.org/forum/viewtopic.php?t=15137](https://latex.org/forum/viewtopic.php?t=15137).

You can set the distances that fit your need.

```latex
% The first \vspace* moves the frametitle, and the second one moves the text coming after the frame title
\addtobeamertemplate{frametitle}{\vspace*{0cm}}{\vspace*{-0.5cm}}
```

You can also use \\vspace command to manually ``adjust'' your Beamer frames when using overlay and other animation stuffs.

# Different contents in presentation slide and handout 

```latex

\mode<beamer|second|trans|article>{
\setbeamercolor{background canvas}{bg=}
% insert stuffs used in the presentation slide only
}

\mode<handout>{
\setbeamercolor{background canvas}{bg=}
% insert stuffs used in the handout only
}
```

# Insert PDF file

To insert a PDF file, in the preamble, add the `pdfpages` package.

```latex
% Include PDF
\usepackage{pdfpages}
```

For instance, to insert `file.pdf`:

```latex
\includepdf[pages=-]{file.pdf}
```

For more information, see the package's [documentation](https://ctan.org/pkg/pdfpages).

# Handle overlays while printing handout

The original source is at [https://tex.stackexchange.com/a/129165](https://tex.stackexchange.com/a/129165).

In specifying overlay options, you can add the `handout:<number>` option. For example, `\only<1-3| handout:1>{content-1}` will print `content-1` that appears in frames 1 to 3 as the first page of the handout; `\only<4-5| handout:2>{content-2}` prints `content-2` which appears in frames 4 and 5 as the second page of the handout; and `\only<6-| handout:0>{content-3}` will instruct beamer not to print `content-3` that appears on frame 6 onwards. Notice that a space is needed between `|` and `handout`.

To not show an item/graphic in the handout, simply set `handout:0`.
