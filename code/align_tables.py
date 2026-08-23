#!/usr/bin/env python3
"""Pad Markdown tables on stdin so the raw text is readable (CLAUDE.md).

Copied from compbench.report.render so the live report can align tables
produced by the PINNED tool, whose checkout must not change while a sweep
is running. Delete this once the study re-pins to a tool that aligns its
own output.
"""
import sys

def align_markdown_tables(text: str) -> str:
    """Pad every Markdown table in `text` so the raw file is readable.

    These reports are read in terminals, diffs and PR reviews far more often
    than they are rendered, and a ragged table is unreadable there. Alignment
    colons in the separator row are preserved and drive per-column padding:
    ``---:`` right-aligns the column's values, ``:---:`` centres them.

    Applied to the finished document rather than at each call site, so every
    table in it is covered — including any added later.
    """
    def split_row(line):
        return [c.strip() for c in line.strip().strip("|").split("|")]

    def is_sep(cells):
        return bool(cells) and all(
            c and set(c) <= set(":-") and "-" in c for c in cells)

    lines = text.split("\n")
    out: list[str] = []
    i = 0
    while i < len(lines):
        # a table is a header row followed by a separator row
        if (lines[i].lstrip().startswith("|")
                and i + 1 < len(lines)
                and lines[i + 1].lstrip().startswith("|")
                and is_sep(split_row(lines[i + 1]))):
            block = []
            while i < len(lines) and lines[i].lstrip().startswith("|"):
                block.append(split_row(lines[i]))
                i += 1
            ncol = max(len(r) for r in block)
            block = [r + [""] * (ncol - len(r)) for r in block]
            seps = block[1]
            aligns = [
                "c" if c.startswith(":") and c.endswith(":")
                else "r" if c.endswith(":")
                else "l"
                for c in seps
            ]
            # the separator's own dashes never dictate the column width
            widths = [
                max(len(row[c]) for k, row in enumerate(block) if k != 1)
                for c in range(ncol)
            ]
            widths = [max(w, 3) for w in widths]
            for k, row in enumerate(block):
                cells = []
                for c in range(ncol):
                    w = widths[c]
                    if k == 1:
                        a = aligns[c]
                        bar = "-" * (w - (2 if a == "c" else 1 if a == "r" else 0))
                        cells.append(
                            f":{bar}:" if a == "c"
                            else f"{bar}:" if a == "r"
                            else bar.ljust(w))
                    else:
                        v = row[c]
                        a = aligns[c]
                        cells.append(
                            v.center(w) if a == "c"
                            else v.rjust(w) if a == "r"
                            else v.ljust(w))
                out.append("| " + " | ".join(cells) + " |")
        else:
            out.append(lines[i])
            i += 1
    return "\n".join(out)

if __name__ == "__main__":
    sys.stdout.write(align_markdown_tables(sys.stdin.read()))
