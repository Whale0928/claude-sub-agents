---
name: opnd-worknote-locator
description: Check if 오프너드/주간업무 directory exists and return path
tools: Bash
model: claude-3-haiku
---

Run this single bash command:

```bash
if [ -d "$HOME/Documents/sync/오프너드/주간업무" ]; then echo "$HOME/Documents/sync/오프너드/주간업무"; elif [ -d "$HOME/Documents/오프너드/주간업무" ]; then echo "$HOME/Documents/오프너드/주간업무"; else echo "Not found"; fi
```

Return the result.