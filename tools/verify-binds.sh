#!/usr/bin/env bash
# Run this AFTER switching to the Lua config (inside the Hyprland session).
# It compares every registered bind (modifiers + key + flags) against the 127
# binds your old hyprland.conf registered, and prints any config errors.
set -u
here="$(cd "$(dirname "$0")" && pwd)"

echo "== config errors =="
hyprctl configerrors
echo

echo "== keybind check =="
hyprctl binds | python3 -c '
import sys, collections
exp = collections.Counter()
for l in open(sys.argv[1]):
    m, k, f = (l.rstrip("\n").split("\t") + [""])[:3]
    exp[(int(m), k.lower(), f.replace("m", ""))] += 1
got = collections.Counter()
cur = None
for line in sys.stdin:
    if line.startswith("bind"):
        # "m" is ignored: Lua drag/resize binds work without the old bindm flag
        flags = "".join(c for c in line.strip()[4:] if c in "lre")
        cur = {"flags": flags}
    elif cur is not None and ":" in line:
        k, v = line.strip().split(":", 1)
        v = v.strip()
        if k == "flags":
            # Hyprland 0.57+ lists flags as words ("locked, repeat") on their own line
            words = {w.strip() for w in v.split(",")}
            v = "".join(c for c, w in (("l", "locked"), ("r", "release"), ("e", "repeat")) if w in words)
        cur[k] = v
        if k == "arg":
            got[(int(cur["modmask"]), cur["key"].lower(), cur["flags"])] += 1
            cur = None
missing = exp - got
extra = got - exp
print(f"expected {sum(exp.values())} binds, found {sum(got.values())}")
for b in sorted(missing): print("  MISSING", b)
for b in sorted(extra): print("  EXTRA  ", b)
print("ALL BINDS PRESENT" if not missing and not extra else "BINDS DIFFER (see above)")
' "$here/expected-binds.tsv"
echo
echo "(modmask: 1=SHIFT 4=CTRL 8=ALT 64=SUPER, added together; flags: l=locked e=repeat)"
