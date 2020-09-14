---
layout: default
title: "Homepage of Duc A. Hoang (Hoàng Anh Đức)"
permalink: "/"
mathjax: true
---

{% include author-info.html %}

-----

# News 

<div class="table-noborder">
<table>
{% for item in site.data.news %}    
<tr style="padding: 10px;">
    <td style="width: 20%;"><strong>{{ item.time }}</strong></td> 
    <td style="width: 80%;">{{ item.text }}</td>
</tr>
{% endfor %}
</table>
</div>
