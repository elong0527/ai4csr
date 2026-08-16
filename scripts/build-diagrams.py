#!/usr/bin/env python3
"""Render every diagrams/*.excalidraw file to assets/diagrams/*.svg.

Run automatically by Quarto as a pre-render step, so the SVG files are build
artifacts and never committed. The .excalidraw JSON is the only source of truth.

Standard library only, so the book build needs no extra dependency.
"""

from __future__ import annotations

import glob
import html
import json
import math
import os
import sys

SANS = "Helvetica, Arial, sans-serif"
MONO = "ui-monospace, SFMono-Regular, Menlo, monospace"
LINE_HEIGHT = 1.25
ARROWHEAD = 14.0
PAD = 24.0


def font_for(family: int) -> str:
    # Excalidraw family 3 is the code font; everything else renders as sans.
    return MONO if family == 3 else SANS


def dash_for(style: str, width: float) -> str:
    if style == "dashed":
        return ' stroke-dasharray="%g,%g"' % (width * 4, width * 3)
    if style == "dotted":
        return ' stroke-dasharray="%g,%g" stroke-linecap="round"' % (width, width * 2.5)
    return ""


def corner_radius(e: dict) -> float:
    # Excalidraw "adaptive radius": a quarter of the short side, capped at 32.
    r = e.get("roundness")
    if not r:
        return 0.0
    return min(min(e["width"], e["height"]) * 0.25, 32.0)


def bounds(elements: list) -> tuple:
    xs, ys, xe, ye = [], [], [], []
    for e in elements:
        if e.get("isDeleted"):
            continue
        x, y, w, h = e["x"], e["y"], e.get("width", 0), e.get("height", 0)
        if e["type"] == "arrow":
            px = [p[0] for p in e["points"]]
            py = [p[1] for p in e["points"]]
            xs.append(x + min(px)); ys.append(y + min(py))
            xe.append(x + max(px)); ye.append(y + max(py))
        else:
            xs.append(x); ys.append(y); xe.append(x + w); ye.append(y + h)
    if not xs:
        return (0.0, 0.0, 100.0, 100.0)
    return (min(xs) - PAD, min(ys) - PAD,
            max(xe) - min(xs) + 2 * PAD, max(ye) - min(ys) + 2 * PAD)


def draw_rect(e: dict) -> list:
    r = corner_radius(e)
    return ['<rect x="%g" y="%g" width="%g" height="%g" rx="%g" ry="%g" '
            'fill="%s" stroke="%s" stroke-width="%g" opacity="%g"%s/>'
            % (e["x"], e["y"], e["width"], e["height"], r, r,
               e.get("backgroundColor") or "none", e["strokeColor"],
               e["strokeWidth"], e.get("opacity", 100) / 100.0,
               dash_for(e.get("strokeStyle", "solid"), e["strokeWidth"]))]


def draw_ellipse(e: dict) -> list:
    return ['<ellipse cx="%g" cy="%g" rx="%g" ry="%g" fill="%s" stroke="%s" '
            'stroke-width="%g" opacity="%g"%s/>'
            % (e["x"] + e["width"] / 2, e["y"] + e["height"] / 2,
               e["width"] / 2, e["height"] / 2,
               e.get("backgroundColor") or "none", e["strokeColor"],
               e["strokeWidth"], e.get("opacity", 100) / 100.0,
               dash_for(e.get("strokeStyle", "solid"), e["strokeWidth"]))]


def head(x: float, y: float, angle: float, colour: str, width: float) -> list:
    out = []
    for spread in (2.5, -2.5):
        out.append('<line x1="%g" y1="%g" x2="%g" y2="%g" stroke="%s" '
                   'stroke-width="%g" stroke-linecap="round"/>'
                   % (x, y, x + ARROWHEAD * math.cos(angle + spread),
                      y + ARROWHEAD * math.sin(angle + spread), colour, width))
    return out


def draw_arrow(e: dict) -> list:
    pts = [(e["x"] + px, e["y"] + py) for px, py in e["points"]]
    if len(pts) < 2:
        return []
    d = "M %g %g " % pts[0] + " ".join("L %g %g" % p for p in pts[1:])
    out = ['<path d="%s" fill="none" stroke="%s" stroke-width="%g" '
           'stroke-linejoin="round" stroke-linecap="round" opacity="%g"%s/>'
           % (d, e["strokeColor"], e["strokeWidth"], e.get("opacity", 100) / 100.0,
              dash_for(e.get("strokeStyle", "solid"), e["strokeWidth"]))]
    if e.get("endArrowhead"):
        a = math.atan2(pts[-1][1] - pts[-2][1], pts[-1][0] - pts[-2][0])
        out += head(pts[-1][0], pts[-1][1], a, e["strokeColor"], e["strokeWidth"])
    if e.get("startArrowhead"):
        a = math.atan2(pts[0][1] - pts[1][1], pts[0][0] - pts[1][0])
        out += head(pts[0][0], pts[0][1], a, e["strokeColor"], e["strokeWidth"])
    return out


def draw_text(e: dict, by_id: dict) -> list:
    size = e["fontSize"]
    lines = e["text"].split("\n")
    block = len(lines) * size * LINE_HEIGHT

    container = by_id.get(e.get("containerId"))
    if container:
        # Bound text is centred inside its container.
        x0, y0, w = container["x"], container["y"], container["width"]
        top = y0 + (container["height"] - block) / 2
        anchor, tx = "middle", x0 + w / 2
    else:
        align = e.get("textAlign", "left")
        top = e["y"]
        anchor = {"center": "middle", "right": "end"}.get(align, "start")
        tx = {"center": e["x"] + e["width"] / 2,
              "right": e["x"] + e["width"]}.get(align, e["x"])

    out = []
    for i, line in enumerate(lines):
        baseline = top + size * 0.95 + i * size * LINE_HEIGHT
        out.append('<text x="%g" y="%g" font-family="%s" font-size="%g" '
                   'fill="%s" text-anchor="%s" opacity="%g" '
                   'style="white-space:pre">%s</text>'
                   % (tx, baseline, font_for(e.get("fontFamily", 1)), size,
                      e["strokeColor"], anchor, e.get("opacity", 100) / 100.0,
                      html.escape(line)))
    return out


DRAW = {"rectangle": draw_rect, "ellipse": draw_ellipse, "diamond": draw_rect}


def convert(path: str) -> str:
    scene = json.load(open(path, encoding="utf-8"))
    elements = [e for e in scene["elements"] if not e.get("isDeleted")]
    by_id = {e["id"]: e for e in elements}
    bg = (scene.get("appState") or {}).get("viewBackgroundColor") or "#ffffff"
    x, y, w, h = bounds(elements)

    body = []
    for e in elements:                      # shapes and arrows first
        if e["type"] in DRAW:
            body += DRAW[e["type"]](e)
        elif e["type"] in ("arrow", "line"):
            body += draw_arrow(e)
    for e in elements:                      # text on top
        if e["type"] == "text":
            body += draw_text(e, by_id)

    return ('<?xml version="1.0" encoding="UTF-8"?>\n'
            '<svg xmlns="http://www.w3.org/2000/svg" width="%g" height="%g" '
            'viewBox="%g %g %g %g">\n'
            '<rect x="%g" y="%g" width="%g" height="%g" fill="%s"/>\n'
            % (w, h, x, y, w, h, x, y, w, h, bg)
            + "\n".join(body) + "\n</svg>\n")


def main() -> int:
    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    out_dir = os.path.join(root, "assets", "diagrams")
    sources = sorted(glob.glob(os.path.join(root, "diagrams", "*.excalidraw")))
    if not sources:
        print("build-diagrams: no .excalidraw files found", file=sys.stderr)
        return 0
    os.makedirs(out_dir, exist_ok=True)
    for src in sources:
        name = os.path.basename(src)[: -len(".excalidraw")] + ".svg"
        dst = os.path.join(out_dir, name)
        with open(dst, "w", encoding="utf-8") as fh:
            fh.write(convert(src))
        print("build-diagrams: %s -> %s"
              % (os.path.relpath(src, root), os.path.relpath(dst, root)))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
