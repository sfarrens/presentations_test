---
---
## What this tests

- Multiple reveal.js presentations in one repo
- Per-presentation Jekyll builds with the correct `baseurl`
- A `_slides/` collection instead of date-stamped `_posts/`
- Light / dark mode that matches [sfarrens.github.io](https://sfarrens.github.io)

---

## Slide naming

Files in `_slides/` are ordered alphabetically, so use zero-padded names:

```
_slides/
  slide_01.md   ← this file
  slide_02.md
  slide_10.md
  slide_11.md
```

Add a new slide by creating the next numbered `.md` file — no configuration needed.
