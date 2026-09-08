# Neovim Config (Windows)

Personal Neovim setup built on **NvChad v2.5**, tuned for C/C++, Python, Lua,
Java, web development (TypeScript/React, Vue, Svelte), and **Common Lisp**. This
is the Windows counterpart of `nvim-linux` and is kept at parity with it; only a
few platform-specific values differ (see [Windows specifics](#windows-specifics)).

- Neovim 0.11.7 · lazy.nvim · gruvbox theme · 4-space indents
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

## Language tooling

| Language | LSP | Linter | Formatter |
|---|---|---|---|
| Python | pyright | ruff | ruff_format (100 cols) |
| C / C++ | clangd (`--clang-tidy`, MinGW query-driver) | — | clang-format (custom style) |
| Lua | lua_ls (diagnostics off) | selene | stylua |
| Java | jdtls | — | google-java-format (`--aosp`, 4 spaces) |
| TS / JS / React | ts_ls | eslint_d | prettier |
| Vue | vue_ls + ts_ls (`@vue/typescript-plugin`) | eslint_d | prettier |
| Svelte | svelte | eslint_d | prettier |
| HTML / CSS | html, cssls, emmet_ls, tailwindcss | — | prettier |
| JSON / YAML / Markdown | jsonls + SchemaStore (JSON) | — | prettier |
| Common Lisp | — (SWANK instead) | — | slimv indentation |

"—" under Linter means the LSP already provides diagnostics.

## Windows specifics

Everything else is identical to `nvim-linux`. These are the only intentional
differences:

- **python3 provider** points at `~/.venvs/nvim/Scripts/python.exe` (Windows venv
  layout; Linux uses `bin/python`). See `lua/options.lua`.
- **clangd** is launched with `--header-insertion=never` and a
  `--query-driver=C:/ProgramData/mingw64/bin/gcc.exe;.../g++.exe` so it resolves
  the MinGW system headers. See `lua/configs/lspconfig.lua`.
- **molten kernel autodetect** looks in `~/AppData/Roaming/jupyter/kernels`
  (Windows) instead of `~/.local/share/jupyter/kernels`. See `lua/configs/molten.lua`.
- **molten images use the `wezterm` provider, not image.nvim.** The kitty
  graphics protocol image.nvim relies on is blocked on native Windows, so the
  Windows config drops image.nvim, depends on `willothy/wezterm.nvim`, and sets
  `molten_image_provider = "wezterm"` (plots go to a WezTerm split via
  `wezterm imgcat`). See [Python notebooks](#python-notebooks-molten). nvim must
  run inside WezTerm for plots.

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

Press `Space` or `,` and pause — which-key shows every available key.
Typing in `:` or `/` pops up completions as you go (`Tab` / `S-Tab` to pick,
`C-e` to dismiss).

## Plugins

**Added on top of NvChad:** nvim-lspconfig + mason-lspconfig · SchemaStore.nvim ·
molten-nvim + wezterm.nvim · cmp-cmdline · conform.nvim ·
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

Components: **SBCL 2.6.8** (installed with `winget install SBCL.SBCL`, on the
system PATH at `C:\Program Files\Steel Bank Common Lisp\`), **QuickLisp**
(`~/quicklisp`, auto-loaded via `~/.sbclrc`), **Slimv** (SLIME port: REPL, eval,
debugger, profiler) with **Paredit**, SWANK auto-started in a terminal split,
`commonlisp` treesitter parser.

### Workflow

1. Open a `.lisp` file.
2. `,c` — starts SBCL+SWANK in a bottom terminal and connects (takes a few
   seconds the first time). A REPL buffer opens.
3. `,d` evals the function under cursor · `,e` current expression ·
   `,b` whole buffer · `,r` selection.
4. Switch windows with `Ctrl-w w`, type directly into the REPL in insert mode.

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

### Documentation

| Command | Contents |
|---|---|
| `:help slimv-keyboard` | every Slimv keybinding explained |
| `:help slimv` | full Slimv manual (REPL, debugger, profiler) |
| `:help paredit-keys` | every Paredit key with examples |

Language docs: `,h` on any symbol (HyperSpec), plus
[Practical Common Lisp](https://gigamonkeys.com/book/).

## Python notebooks (molten)

Run `# %%` cells against a Jupyter kernel without leaving the editor; output
renders in a window under the cell.

```python
# %%
import pandas as pd
df = pd.read_csv("data.csv")   # slow -- run once, stays in memory

# %%
df.describe()                  # re-run freely against the loaded frame
```

`Space ji` boots the kernel, picking the activated conda env when a kernelspec
of that name exists and otherwise prompting with the list.

Pyright is separate from the kernel and resolves imports from the interpreter it
finds at startup, so either `conda activate <env>` before nvim, or drop a
`pyrightconfig.json` in the project root:

```json
{ "venvPath": "C:/Users/<you>/anaconda3/envs", "venv": "cs484" }
```

| Keys | Action |
|---|---|
| `Space ji` | init kernel (active conda env) |
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

Export is **not** automatic and does **not** create the notebook: molten opens an
existing `.ipynb`, matches its code cells against the executed ones, and writes
the outputs in. Create the notebook first with jupytext, then `Space jx` fills in
the outputs.

### Images (matplotlib plots) — WezTerm

image.nvim's kitty graphics protocol is **blocked on native Windows** (Windows
swallows the escape codes), and Kitty/Ghostty have no native Windows build. So
this config uses molten's built-in **`wezterm` image provider** instead: run
nvim inside **WezTerm** (`winget install wez.wezterm`) and plots are rendered in
a **WezTerm split** via `wezterm imgcat`, driven by `wezterm.nvim`.

Because the wezterm provider requires `molten_auto_open_output = false`, text
output no longer pops open automatically — `molten_virt_text_output = true`
keeps a short text result visible inline, and `Space jo` opens the full output
window. Text output works in any terminal; only the plots need WezTerm.

The repo's WezTerm config lives at `../wezterm/wezterm.lua` (copied to
`~/.wezterm.lua`). If you prefer not to use WezTerm, molten's dependency-free
`:MoltenImagePopup` (with `vim.g.molten_auto_image_popup = true`) shows plots in
an external pop-up window instead.

### Requirements (already set up)

- **Provider venv** at `~/.venvs/nvim` holding `pynvim`, `jupyter_client` and
  `nbformat`. `vim.g.python3_host_prog` points here — **not** the system python
  and **not** the conda env (a `conda activate` exports `PYTHONNOUSERSITE` into
  nvim and would hide `--user` packages). Rebuild with:
  ```sh
  python -m venv ~/.venvs/nvim
  ~/.venvs/nvim/Scripts/python.exe -m pip install pynvim jupyter_client nbformat
  ```
- **Anaconda** provides the kernels (a default `python3` kernel is registered).
  Register a new env's kernel with:
  ```sh
  conda activate <env>
  python -m ipykernel install --user --name <env> --display-name "Python (<env>)"
  ```
- **WezTerm** (`winget install wez.wezterm`) — run nvim inside it for inline
  plots. `wezterm.nvim` (a molten dependency) shells them out to `wezterm imgcat`.
- After changing `python3_host_prog`, open a `.py` file and run
  `:UpdateRemotePlugins` — the manifest records the host. (molten is a remote
  plugin, so `rplugin` is left enabled in `lua/configs/lazy.lua`.)

## Java

`jdtls` is used through nvim-lspconfig's bundled config — no nvim-jdtls. It
detects a project from `pom.xml` / `build.gradle` / `.git` and caches its index
under `stdpath('cache')/jdtls/workspace`, so the **first open in a new project
takes about a minute** while the JVM starts and indexes; later opens are fast. If
a project's diagnostics go stale, delete that workspace directory to force a
re-index.

> **Requires Neovim ≥ 0.11.3.** nvim-lspconfig's `jdtls.lua` uses a
> `cmd = function(dispatchers, config)` form that only receives `config` on
> 0.11.3+. On 0.11.1 it errors with `attempt to index local 'config' (a nil
> value)`. This config targets **0.11.7**.

No linter: jdtls already reports compiler errors, unused imports and type
mismatches.

## Maintenance

- `:Lazy sync` — update plugins · `:Mason` — manage LSP/lint/format tools ·
  `:TSUpdate` — update treesitter parsers
- **nvim-treesitter is pinned** to `main @ 90cd6580` — the last commit
  supporting Neovim 0.11. After upgrading to Neovim 0.12+: delete the
  `commit = ...` line in `lua/plugins/init.lua`, then `:Lazy sync` and
  `:TSUpdate`.
- **The nvim-treesitter main branch requires the `tree-sitter` CLI** to build
  parsers. On Windows, install it and make sure a real **`tree-sitter.exe`** is
  on PATH — the npm global shim (`npm i -g tree-sitter-cli`) drops an
  extensionless launcher that libuv cannot spawn, which makes parsers with
  external scanners (java, vue, svelte, commonlisp) fail to build. This config
  copies the real exe out of the npm package to `~/.local/bin/tree-sitter.exe`
  (on PATH) so `vim.fn.exepath('tree-sitter')` resolves to the `.exe`.

### System packages this config expects (Windows)

| Tool | Install |
|---|---|
| Neovim 0.11.7 | `winget install Neovim.Neovim --version 0.11.7` |
| Anaconda | `winget install Anaconda.Anaconda3 --scope user` |
| SBCL | `winget install SBCL.SBCL` (+ QuickLisp, see above) |
| WezTerm | `winget install wez.wezterm` (for molten plots) |
| tree-sitter CLI | `npm i -g tree-sitter-cli` then copy the real `.exe` onto PATH |
| Maven | `choco install maven` (jdtls also bundles Maven for imports) |
| MinGW gcc/g++ | `C:\ProgramData\mingw64` (for treesitter + clangd) |
| JDK 21 | Eclipse Adoptium (for jdtls) |
| ripgrep / fd | telescope live-grep / fast file finding |
| Node.js | prettier / eslint_d / vue_ls / ts_ls |

Mason installs the per-language servers/formatters/linters (clangd, ruff,
stylua, selene, prettier, eslint_d, google-java-format, pyright, jdtls,
vue-language-server, svelte-language-server, …) into `nvim-data/mason` on first
use.
