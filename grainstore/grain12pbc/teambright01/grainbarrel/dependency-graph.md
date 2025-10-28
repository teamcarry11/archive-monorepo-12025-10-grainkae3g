# Dependency Graph

**Generated from grainstore.edn** - Do not edit manually!

```mermaid
graph TD
    grainicons[grainicons] --> babashka[babashka]
    grainweb[grainweb] --> clojure-s6[clojure-s6]
    grainweb[grainweb] --> clojure-sixos[clojure-sixos]
    grainweb[grainweb] --> clojure-icp[clojure-icp]
    grainweb[grainweb] --> clotoko[clotoko]
    grainweb[grainweb] --> grainclay[grainclay]
    grainweb[grainweb] --> grain-metatypes[grain-metatypes]
    grainmusic[grainmusic] --> clojure-icp[clojure-icp]
    grainmusic[grainmusic] --> clotoko[clotoko]
    grainmusic[grainmusic] --> grain-metatypes[grain-metatypes]
    grainspace[grainspace] --> clojure-icp[clojure-icp]
    grainspace[grainspace] --> grainweb[grainweb]
    grainspace[grainspace] --> grainmusic[grainmusic]
    grainbarrel[grainbarrel] --> babashka[babashka]
    grainclay[grainclay] --> clojure-sixos[clojure-sixos]
    grainclay[grainclay] --> grain-metatypes[grain-metatypes]
    clojure-sixos[clojure-sixos] --> clojure-s6[clojure-s6]
    graindaemon[graindaemon] --> clojure-s6[clojure-s6]
    graindaemon[graindaemon] --> clojure-sixos[clojure-sixos]
    grainwifi[grainwifi] --> clojure-s6[clojure-s6]
    clotoko[clotoko] --> clojure-icp[clojure-icp]
    graindisplay[graindisplay] --> graindaemon[graindaemon]
    graindisplay[graindisplay] --> humbleui[humbleui]
    graindisplay[graindisplay] --> grainneovedic[grainneovedic]
    graindisplay[graindisplay] --> grainclay[grainclay]
    graindrive[graindrive] --> clojure-s6[clojure-s6]
    graindrive[graindrive] --> clojure-sixos[clojure-sixos]
    graindrive[graindrive] --> clojure-google-drive-mcp[clojure-google-drive-mcp]
    graindrive[graindrive] --> grainclay[grainclay]
    graindrive[graindrive] --> grain-metatypes[grain-metatypes]
    grain-nightlight[grain-nightlight] --> graindaemon[graindaemon]
    graincasks[graincasks] --> grainicons[grainicons]
    graincasks[graincasks] --> graindisplay[graindisplay]
    graincasks[graincasks] --> babashka[babashka]
    grainconv[grainconv] --> grain-metatypes[grain-metatypes]
```

## Legend

- **Solid arrows**: Direct dependencies
- **Module names**: Click to see module details

---

*Generated on 2025-10-22T17:21:58.059423686*
