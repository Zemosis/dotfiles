# Neovim Config

Personal Neovim setup built on **NvChad v2.5**, tuned for C/C++, Python, Lua,
Java, web development (TypeScript/React, Vue, Svelte), and **Common Lisp**.

- Neovim 0.11.5 · lazy.nvim · gruvbox theme · 4-space indents
- Format on save (conform.nvim) · lint on open/save/insert-leave (nvim-lint)
- LSP via the native `vim.lsp.config` API + mason-lspconfig v2

## Layout

| File | Purpose |
|---|---|
| `init.lua` | bootstrap lazy.nvim + NvChad |
| `lua/chadrc.lua` | NvChad theme/UI settings |
| `lua/options.lua` | editor options (indent, folding, whitespace, python provider) |
| `lua/mappings.lua` | custom keymaps |
| `lua/plugins/init.lua` | plugin list |
| `lua/configs/lspconfig.lua` | LSP servers + per-server overrides |
| `lua/configs/conform.lua` | formatters |
| `lua/configs/lint.lua` | linters |
| `lua/configs/treesitter.lua` | parsers + treesitter indent |
| `lua/configs/slimv.lua` | Common Lisp (slimv/paredit/which-key labels) |
| `lua/configs/molten.lua` | Jupyter cells (molten settings, cell helper, keymaps) |
| `lua/configs/cmdline.lua` | `:` and `/` completion (nvim-cmp) |
| `lua/configs/whichkey.lua` | which-key categories + sorter for the Lisp menu |

## Language tooling

| Language | LSP | Linter | Formatter |
|---|---|---|---|
| Python | pyright | ruff | ruff_format (100 cols) |
| C / C++ | clangd (`--clang-tidy`) | — | clang-format (custom style) |
| Lua | lua_ls (diagnostics off) | selene | stylua |
| Java | jdtls | — | google-java-format (`--aosp`, 4 spaces) |
| TS / JS / React | ts_ls | eslint_d | prettier |
| Vue | vue_ls + ts_ls (`@vue/typescript-plugin`) | eslint_d | prettier |
| Svelte | svelte | eslint_d | prettier |
| HTML / CSS | html, cssls, emmet_ls, tailwindcss | — | prettier |
| JSON / YAML / Markdown | jsonls + SchemaStore (JSON) | — | prettier |
| Common Lisp | — (SWANK instead) | — (SBCL compiler) | slimv indentation |

"—" under Linter means the LSP already provides diagnostics.

## Custom keymaps

| Keys | Action |
|---|---|
| `;` | enter command mode |
| `jk` (insert) | escape |
| `Space s` | replace word under cursor everywhere (prefills `:%s`) |
| `Space s` (visual) | replace selection everywhere |
| `Space ts` | toggle whitespace dots (`:set list!`) |
| `gcc` / `gc` | comment (built-in) |
| `Space ra` | LSP rename symbol (project-wide) |
| `,` … | Slimv commands (Lisp buffers) |
| `Space l` … | Paredit commands (Lisp buffers) |

Press `Space` or `,` and pause — which-key shows every available key. The
`,` menu is grouped by category (Eval, Compile, REPL, Docs, Macro, Debug,
Profile, Threads, Edit) rather than by key, via a custom sorter in
`configs/whichkey.lua`.
Typing in `:` or `/` pops up completions as you go (`Tab` / `S-Tab` to pick,
`C-e` to dismiss).

## Plugins

**Added on top of NvChad:** nvim-lspconfig + mason-lspconfig · SchemaStore.nvim ·
molten-nvim + image.nvim · cmp-cmdline + cmp-omni · conform.nvim ·
nvim-lint · nvim-treesitter (main branch) · nvim-ts-autotag · nvim-autopairs ·
trouble.nvim · slimv (Common Lisp).

**Bundled with NvChad:** telescope · nvim-tree · gitsigns · which-key ·
nvim-cmp + LuaSnip · mason · indent-blankline · base46 themes · terminal
manager · nvim-web-devicons.

### Telescope (fuzzy finder)

| Keys | Action |
|---|---|
| `Space ff` | find files |
| `Space fa` | find all files (incl. hidden/ignored) |
| `Space fw` | live grep (search text in project) |
| `Space fb` | open buffers |
| `Space fz` | fuzzy search in current buffer |
| `Space fo` | recently opened files |
| `Space fh` | search help pages |
| `Space cm` / `Space gt` | git commits / git status |
| `Space ma` | marks |
| `Space th` | theme picker |

### Files, buffers, windows

| Keys | Action |
|---|---|
| `Ctrl-n` | toggle file tree · `Space e` focus it |
| `Tab` / `Shift-Tab` | next / previous buffer |
| `Space b` / `Space x` | new buffer / close buffer |
| `Ctrl-h/j/k/l` | jump between windows (works from file tree/REPL too) |
| `Ctrl-s` | save · `Ctrl-c` copy whole file · `Esc` clear search highlight |

### Terminals

| Keys | Action |
|---|---|
| `Space h` / `Space v` | new horizontal / vertical terminal |
| `Alt-h` / `Alt-v` / `Alt-i` | toggle horizontal / vertical / floating terminal |
| `Ctrl-x` | leave terminal insert mode |
| `Space pt` | pick a hidden terminal |

### LSP & diagnostics

| Keys | Action |
|---|---|
| `K` | hover docs |
| `gd` / `gD` | go to definition / declaration |
| `grr` / `gra` | references / code actions (Neovim builtins) |
| `Space ra` | rename symbol project-wide |
| `Space D` | go to type definition |
| `Space fm` | format file now |
| `Space ds` | diagnostics list · `:Trouble diagnostics` pretty version |

Gitsigns shows add/change/delete marks in the gutter; use
`:Gitsigns preview_hunk`, `:Gitsigns reset_hunk`, `:Gitsigns blame_line` etc.
`Space ch` opens NvChad's cheatsheet with every mapping.

## Common Lisp

Components: **SBCL 2.6.7** (user-space, `~/.local/bin/sbcl`), **QuickLisp**
(`~/quicklisp`, auto-loaded via `~/.sbclrc`), **Slimv** (SLIME port: REPL,
eval, debugger, profiler) with **Paredit**, SWANK auto-started in a terminal
split, `commonlisp` treesitter parser.

### Workflow

1. Open a `.lisp` file.
2. `,c` — starts SBCL+SWANK in a bottom terminal and connects (takes a few
   seconds the first time). A REPL buffer opens.
3. `,d` evals the function under cursor · `,e` current expression ·
   `,b` whole buffer · `,r` selection.
4. Switch windows with `Ctrl-w w`, type directly into the REPL in insert mode.

Completion comes from the live image: slimv sets
`omnifunc=SlimvOmniComplete` and cmp-omni routes it into the normal
completion popup, so it needs a connected REPL (`,c`) to return anything.

### Everyday Slimv keys

| Keys | Action |
|---|---|
| `,c` | connect / start REPL |
| `,d` / `,e` / `,b` / `,r` | eval defun / expression / buffer / region |
| `,h` | HyperSpec docs for symbol under cursor |
| `,s` | describe symbol · `,j` find definition · `,i` inspect |
| `,1` / `,m` | macroexpand once / all |
| `,t` / `,T` | trace / untrace function |
| `,a` `,n` `,q` | debugger: abort / continue / quit level |
| `,-` | clear REPL · `,Q` quit REPL |

### Paredit (structural editing, `Space l`)

Parens stay balanced automatically. `Space l W` wrap form · `l S` splice
(remove parens) · `l I` raise · `l J`/`l O` join/split · `l <`/`l >` move
paren (slurp/barf) · `l (` toggle paredit off/on.

### Installing QuickLisp packages

In any REPL (the Slimv one or `sbcl` in a terminal):

```lisp
(ql:quickload "alexandria")     ; download (first time) + load
(ql:system-apropos "socket")    ; search available packages
(ql:update-all-dists)           ; update package index
```

Packages install to `~/quicklisp` once and load from disk afterwards.
`quickload` returns the package ready to use — no separate install step.

### Documentation

| Command | Contents |
|---|---|
| `:help slimv-keyboard` | every Slimv keybinding explained |
| `:help slimv` | full Slimv manual (REPL, debugger, profiler) |
| `:help slimv-hyperspec` | how `,h` doc lookup works |
| `:help slimv-faq` | common problems |
| `:help paredit-keys` | every Paredit key with examples |
| `:help paredit-mode` | Paredit's balancing rules |

Help navigation: `Ctrl-]` follow link · `Ctrl-o` back · `/text` search ·
`:q` close. Language docs: `,h` on any symbol (HyperSpec), plus
[Practical Common Lisp](https://gigamonkeys.com/book/).

## Python notebooks (molten)

Run `# %%` cells against a Jupyter kernel without leaving the editor; output,
including matplotlib plots, renders in a window under the cell.

```python
# %%
import pandas as pd
df = pd.read_csv("data.csv")   # slow -- run once, stays in memory

# %%
df.describe()                  # re-run freely against the loaded frame
```

`Space j i` boots the kernel, picking the activated conda env when a
kernelspec of that name exists and otherwise prompting with the list.

Pyright is separate from the kernel and resolves imports from the interpreter
it finds at startup, so either `conda activate <env>` before nvim, or drop a
`pyrightconfig.json` in the project root and it works from a cold shell:

```json
{ "venvPath": "/home/turuu/anaconda3/envs", "venv": "cs484" }
```

Conda envs live under `~/anaconda3/envs` no matter where the code is; nothing
needs to sit next to the project.

| Keys | Action |
|---|---|
| `Space ji` | init kernel (cs484) |
| `Space jr` | run cell under cursor · `Space jl` run line |
| `Space jv` | run visual selection |
| `Space ja` | run every cell in the file |
| `Space jc` / `Space jA` | re-run cell / re-run already-evaluated cells |
| `Space jo` / `Space jh` | show / hide output |
| `Space je` | enter output window (to scroll) |
| `Space jn` / `Space jp` | next / previous cell |
| `Space jk` / `Space jR` | interrupt / restart kernel |
| `Space jd` | delete cell output |
| `Space jx` / `Space jm` | export / import outputs to a `.ipynb` |

Export is **not** automatic and does **not** create the notebook: molten opens
an existing `.ipynb`, matches its code cells against the executed ones, and
writes the outputs in. Create the notebook first with jupytext (installed in
the `cs484` env):

```sh
jupytext --to notebook hw1.py     # hw1.py -> hw1.ipynb, no outputs yet
```

then `Space jx` in nvim fills in the outputs. `jupytext --sync` keeps the
pair up to date afterwards.

Cell boundaries are found by `configs/molten.lua` (molten itself only
evaluates motions and selections).

Requirements, all already set up: `pynvim` + `jupyter_client` in the
provider venv at `~/.venvs/nvim` -- `pynvim`, `jupyter_client` and
`nbformat` (the last only for `.ipynb` import/export)
(`vim.g.python3_host_prog` points there --
**not** the system python and **not** the conda env, because `conda activate`
exports `PYTHONNOUSERSITE` into nvim and would hide `--user` packages),
ImageMagick, `set -g allow-passthrough on` in `~/.tmux.conf` so image escapes
reach ghostty, a terminal that speaks the kitty graphics protocol, and
`rplugin` left **enabled** in `configs/lazy.lua` -- molten is a remote plugin.

Register a kernel for a new conda env with:

```sh
conda activate <env>
python -m ipykernel install --user --name <env> --display-name "Python (<env>)"
```

Rebuild the provider venv with:

```sh
python3 -m venv ~/.venvs/nvim && ~/.venvs/nvim/bin/pip install pynvim jupyter_client
```

After changing `python3_host_prog`, open a `.py` file and run
`:UpdateRemotePlugins` -- the manifest records the host.

## Java

`jdtls` is used through nvim-lspconfig's bundled config — no nvim-jdtls. It
detects a project from `pom.xml` / `build.gradle` / `.git` and caches its index
in `~/.cache/nvim/jdtls/workspace`, so the **first open in a new project takes
about a minute** while the JVM starts and indexes; later opens are fast. If a
project's diagnostics go stale, delete that workspace directory to force a
re-index.

No linter: jdtls already reports compiler errors, unused imports and type
mismatches. checkstyle is style-only and refuses to run without a per-project
config, so it is left out.

## Maintenance

- `:Lazy sync` — update plugins · `:Mason` — manage LSP/lint/format tools ·
  `:TSUpdate` — update treesitter parsers
- **nvim-treesitter is pinned** to `main @ 90cd6580` — the last commit
  supporting Neovim 0.11. After upgrading to Neovim 0.12+: delete the
  `commit = ...` line in `lua/plugins/init.lua`, then `:Lazy sync` and
  `:TSUpdate`.
- **System packages this config expects:** a JDK (21) for jdtls, `maven` for
  Java dependency resolution, `ripgrep` for telescope live-grep, and `fd` for
  fast gitignore-aware file finding.
- SBCL is a user-space install. To switch to the system package:
  `sudo dnf install sbcl`, then remove `~/.local/bin/sbcl`,
  `~/.local/lib/sbcl`, and `~/.local/share/man/man1/sbcl.1`.
