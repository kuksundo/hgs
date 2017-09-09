pgScene.pas

  Project: Pyro
  Module: Core Document Engine

  Description:
  
  implementation of scene objects:
  - paintable (fill, fillrule, stroke, strokewidth, fontsize, opacity, fillopacity,
      fontfamily, fontstretch*, fontstyle*, fontweight*, letterspacing, wordspacing
      strokeopacity, strokelinecap*, strokelinejoin*, strokemiterlimit,
      strokedasharray, strokedashoffset, textanchor*
  - group (transform, editoroptions)
  - viewport (preserveaspect, meetorslice, x, y, width, height, viewbox)
  - shapes:
    - rectangle (x, y, width, height, rx, ry)
    - circle (cx, cy, r)
    - ellipse (cx, cy, rx, ry)
    - line (x1, y1, x2, y2)
    - polyline (points)
    - polygon (points)
    - path (path)
  - resource (data, uri, mimetype)
  - image
  - text (x, y, dx, dy. text)

  *: not implemented yet

  Author: Nils Haeck (n.haeck@simdesign.nl)
  Creation Date: 17oct2005
  
  Copyright (c) 2005 - 2012 SimDesign BV

  Modified:
  20jun2011: pgScene based on NativeXml
  20jun2011: placed all scene objects in this unit
  01sep2012: TpgElement renamed to TpgItem (pgDocument.pas)

}