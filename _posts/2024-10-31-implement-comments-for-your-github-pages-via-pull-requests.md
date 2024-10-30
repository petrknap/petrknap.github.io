---
layout: blog.post
title: "Implement comments for your #GitHubPages via pull requests"
category: backend
keywords:
    - development
    - web
    - idea
    - comments
    - discussion
    - GitHub Pages
    - pull request
pull_request_id: 7
---

I wanted to enable **comments for my GitHub Pages** for a long time.
I've considered various third-party services, but none of them suited me.
Anyway...

In the meantime, I started setting up `main` as a protected branch with enforced pull requests.
And then it dawned on me - every **post has to go through a pull request** and every **pull request contains comments**.
So I implemented the comments by **simply adding a link to the pull request** in the template and that's pretty much it.
As a bonus, you can comment in general or pin the comment to a specific line of text.
And **that's great**!

Give it a try. In my opinion it has only one flaw - it's not embeddable.
