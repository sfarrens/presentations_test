---
layout: slide
title: "What this tests"
---

# First topic

- Multiple reveal.js presentations in one repo
- Per-presentation Jekyll builds with the correct `baseurl`
- A `_slides/` collection instead of date-stamped `_posts/`
- Light / dark mode matching [sfarrens.github.io](https://sfarrens.github.io)
- Three named layouts: **title**, **slide**, **graphic**

## Slide naming

Files in `_slides/` are ordered alphabetically — use zero-padded names:

```bash
_slides/
  slide_01.md    ← layout: title
  slide_02.md    ← layout: slide
  slide_10.md
```

Add a new slide by creating the next numbered `.md` file.
