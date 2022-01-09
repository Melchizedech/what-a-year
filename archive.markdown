---
layout: page
title: Archives
permalink: /archive/
---

<ul class="posts">

    {% assign postsByYear = site.posts | group_by_exp: 'post', 'post.date | date: "%Y"' %}
    {% for year in postsByYear %}
        <li>
            <a class="post-link" style="display:inline-block" href="{{ site.baseurl }}/{{ year.name }}/">{{ year.name }}</a> ({{ year.size }})
        </li>

        {% assign postsByMonth = year.items | group_by_exp: 'post', 'post.date | date: "%m"' %}
        <li>
            <ul>
                {% for month in postsByMonth %}
                    <li>
                        <a class="post-link" style="display:inline-block" href="{{ site.baseurl }}/{{ year.name }}/{{ month.name }}/">{{ month.name }}</a> ({{ month.size }})
                    </li>

                {% endfor %}
            </ul>
        </li>
    {% endfor %}
</ul>
