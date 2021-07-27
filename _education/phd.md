---
date: 9999-01-01
start: 2019-09-23
organisation: Queen's University Belfast
role: PhD Student
---
Specialising in Solar Physics

*Astrophysics Research Centre,  
School of Mathematics and Physics*

- [University Profile](https://pure.qub.ac.uk/en/persons/conor-macbride)
- [School Profile](https://www.qub.ac.uk/schools/SchoolofMathematicsandPhysics/Research/PhDResearchStudents/ConorMacBride-StudentProfile/)
- <div itemscope itemtype="https://schema.org/Person"><a itemprop="sameAs" content="https://orcid.org/0000-0002-9901-8723" href="https://orcid.org/0000-0002-9901-8723" target="orcid.widget" rel="me noopener noreferrer" style="vertical-align:top;"><img src="{{ site.baseurl }}/img/orcid.svg" width="18" height="18" style="width:1em;margin-right:.5em;vertical-align:middle;" alt="ORCID iD icon">https://orcid.org/0000-0002-9901-8723</a></div>

## Publications

{% assign sorted_projects = site.education | where: "parent", "phd" | reverse %}
{% for item in sorted_projects %}

  {% include publication.html entry=item %}

{% endfor %}

