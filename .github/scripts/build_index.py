#!/usr/bin/env python3
"""Generate _site/index.html from each presentation's _config.yml.

Called by deploy.yml from the repo root.  For each subdirectory that
contains a _config.yml the following fields are read:

  title       Display name shown on the card            (required)
  description Short excerpt shown on the card           (optional)
  type        Badge label / filter key (e.g. Talk, Demo) (optional, default: Talk)

The script replaces the regions between
  <!-- FILTER_BUTTONS_START --> … <!-- FILTER_BUTTONS_END -->
  <!-- CARDS_START -->          … <!-- CARDS_END -->
in index.html and writes the result to _site/index.html.
"""

import html as html_lib
import os
import re
import sys

try:
    import yaml
    def _load_config(path):
        with open(path) as fh:
            return yaml.safe_load(fh) or {}
except ImportError:
    # Fallback: regex parser for simple top-level scalar fields
    def _load_config(path):
        pattern = re.compile(r'^([A-Za-z_][A-Za-z0-9_]*)\s*:\s*(.+)$', re.MULTILINE)
        try:
            with open(path) as fh:
                text = fh.read()
        except OSError:
            return {}
        result = {}
        for key, val in pattern.findall(text):
            result[key] = val.strip().strip('"').strip("'")
        return result


def load_presentations(root):
    entries = []
    for name in sorted(os.listdir(root)):
        config_path = os.path.join(root, name, '_config.yml')
        if not os.path.isfile(config_path):
            continue
        cfg = _load_config(config_path)
        entries.append({
            'slug':        name,
            'title':       str(cfg.get('title', name)),
            'description': str(cfg.get('description', '')),
            'type':        str(cfg.get('type', 'Talk')),
        })
    return entries


def render_filter_buttons(presentations):
    types = sorted({p['type'] for p in presentations})
    if len(types) <= 1:
        return ''
    lines = ['      <span class="pub-filter-label">Filter:</span>']
    for t in types:
        te = html_lib.escape(t)
        lines.append(
            f'      <button class="pub-filter-btn" data-filter-tag="{te}">{te}</button>'
        )
    return '\n'.join(lines)


def render_cards(presentations):
    parts = []
    for p in presentations:
        title = html_lib.escape(p['title'])
        desc  = html_lib.escape(p['description'])
        ptype = html_lib.escape(p['type'])
        slug  = p['slug']
        parts.append(
            f'      <div class="data-card" data-tag="{ptype}">\n'
            f'        <div class="data-card-body">\n'
            f'          <span class="data-card-lang">{ptype}</span>\n'
            f'          <a href="{slug}/" class="data-card-title">{title}</a>\n'
            f'          <p class="data-card-excerpt">{desc}</p>\n'
            f'          <div class="data-card-links">\n'
            f'            <a href="{slug}/">View slides</a>\n'
            f'          </div>\n'
            f'        </div>\n'
            f'      </div>'
        )
    return '\n\n'.join(parts)


def inject(template, marker, content):
    """Replace everything between <!-- MARKER_START --> and <!-- MARKER_END -->."""
    start_tag = f'<!-- {marker}_START -->'
    end_tag   = f'<!-- {marker}_END -->'
    rx = re.compile(
        re.escape(start_tag) + r'.*?' + re.escape(end_tag),
        re.DOTALL,
    )
    replacement = f'{start_tag}\n{content}\n      {end_tag}'
    result, n = rx.subn(lambda _: replacement, template)
    if n == 0:
        raise ValueError(
            f'Markers <!-- {marker}_START/END --> not found in index.html'
        )
    return result


def main():
    root          = os.getcwd()
    template_path = os.path.join(root, 'index.html')
    output_path   = os.path.join(root, '_site', 'index.html')

    with open(template_path) as fh:
        template = fh.read()

    presentations = load_presentations(root)
    if not presentations:
        print('Warning: no presentations found — writing empty index', file=sys.stderr)

    page = inject(template, 'FILTER_BUTTONS', render_filter_buttons(presentations))
    page = inject(page,     'CARDS',          render_cards(presentations))

    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    with open(output_path, 'w') as fh:
        fh.write(page)

    slugs = ', '.join(p['slug'] for p in presentations)
    print(f'Generated {output_path} ({len(presentations)} presentation(s): {slugs})')


if __name__ == '__main__':
    main()
