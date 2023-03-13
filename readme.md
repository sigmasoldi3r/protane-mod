# The Lore of the King God

This repository contains the mod files, scripts and other things found in
the modpack of _The Lore of the King God_, and other assets related to the
official server of the pack.

## Structure

There are three major branches that contain this information (Excluding main):

- The `mod` branch
  - Contains the _KubeJS_ files that add items to the game.
- The `docs` branch
  - Contains future web files for further information.
- The `computercraft` branch
  - Contains _ComputerCraft_ scripts that are being used in the official server.

```mermaid
---
title: Repository structure
---
gitGraph
   commit id: "Root Commit"
   branch "docs"
   commit
   commit tag: "Web files and future content"
   checkout main
   branch "mod"
   commit
   commit tag: "Modfiles and future content"
   checkout main
   branch "computercraft"
   commit
   commit tag: "Scripts and future content"
   checkout main
   commit id: "This readme"
```

Also there is this `main` branch which is used as a root branch, starting point
and template for future blank branches.

Also contains some documents like this one.
