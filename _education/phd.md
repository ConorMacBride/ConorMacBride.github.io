---
date: 2019-09-23
organisation: Queen's University Belfast
role: PhD Student
start: September 2019
end: false
---
Specialising in Solar Physics

*Astrophysics Research Centre,  
School of Mathematics and Physics*

## Publications

{% assign sorted_projects = site.education | where: "parent", "phd" | reverse %}
{% for item in sorted_projects %}

  {% include publication.html entry=item %}

{% endfor %}

