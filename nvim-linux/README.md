# Neovim Config

Personal Neovim setup built on **NvChad v2.5**, tuned for C/C++, Python, Lua,
web development (TypeScript/React, Vue, Svelte), and **Common Lisp**.

- Neovim 0.11.5 · lazy.nvim · gruvbox theme · 4-space indents
- Format on save (conform.nvim) · lint on open/save/insert-leave (nvim-lint)
- LSP via the native `vim.lsp.config` API + mason-lspconfig v2

## Layout

| File | Purpose |
|---|---|
| `init.lua` | bootstrap lazy.nvim + NvChad |
| `lua/chadrc.lua` | NvChad theme/UI settings |
| `lua/options.lua` | editor options (indent, folding, python provider) |
| `lua/mappings.lua` | custom keymaps |
| `lua/plugins/init.lua` | plugin list |
| `lua/configs/lspconfig.lua` | LSP servers + per-server overrides |
| `lua/configs/conform.lua` | formatters |
| `lua/configs/lint.lua` | linters |
| `lua/configs/treesitter.lua` | parsers + treesitter indent |
| `lua/configs/slimv.lua` | Common Lisp (slimv/paredit/which-key labels) |

## Language tooling

| Language | LSP | Linter | Formatter |
|---|---|---|---|
| Python | pyright | ruff | ruff_format (100 cols) |
| C / C++ | clangd (clang-tidy built in) | — | clang-format (custom style) |
| Lua | lua_ls (diagnostics off) | selene | stylua |
| TS / JS / React | ts_ls | eslint_d | prettier |
| Vue | vue_ls + ts_ls (`@vue/typescript-plugin`) | eslint_d | prettier |
| Svelte | svelte | eslint_d | prettier |
| HTML / CSS | html, cssls, emmet_ls, tailwindcss | — | prettier |
| JSON / YAML / Markdown | jsonls (JSON) | — | prettier |
| Common Lisp | — (SWANK instead) | — | slimv indentation |

"—" under Linter means the LSP already provides diagnostics.

## Custom keymaps

| Keys | Action |
|---|---|
| `;` | enter command mode |
| `jk` (insert) | escape |
| `Space s` | replace word under cursor everywhere (prefills `:%s`) |
| `Space s` (visual) | replace selection everywhere |
| `gcc` / `gc` | comment (built-in) |
| `Space ra` | LSP rename symbol (project-wide) |
| `,` … | Slimv commands (Lisp buffers) |
| `Space l` … | Paredit commands (Lisp buffers) |

Press `Space` or `,` and pause — which-key shows every available key.

## Plugins

**Added on top of NvChad:** nvim-lspconfig + mason-lspconfig · conform.nvim ·
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

## Maintenance

- `:Lazy sync` — update plugins · `:Mason` — manage LSP/lint/format tools ·
  `:TSUpdate` — update treesitter parsers
- **nvim-treesitter is pinned** to `main @ 90cd6580` — the last commit
  supporting Neovim 0.11. After upgrading to Neovim 0.12+: delete the
  `commit = ...` line in `lua/plugins/init.lua`, then `:Lazy sync` and
  `:TSUpdate`.
- SBCL is a user-space install. To switch to the system package:
  `sudo dnf install sbcl`, then remove `~/.local/bin/sbcl`,
  `~/.local/lib/sbcl`, and `~/.local/share/man/man1/sbcl.1`.
