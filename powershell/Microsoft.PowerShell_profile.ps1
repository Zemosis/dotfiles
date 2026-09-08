# PowerShell 7 profile

# Prompt: gruvbox oh-my-posh (same theme as the Windows PowerShell 5.1 profile)
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\gruvbox.omp.json" | Invoke-Expression

# Interactive-only line-editor features. PSReadLine's predictions and PSFzf's
# key bindings need a real terminal; guarding on IsOutputRedirected keeps
# non-interactive pwsh calls (scripts, tools) from erroring on them.
if (-not [Console]::IsOutputRedirected) {
    # History autosuggestions: fish/zsh-autosuggestions-style ghost text plus a
    # scrollable prediction list drawn from history (and prediction plugins).
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd

    # PSFzf: fuzzy finder key bindings (uses the fzf binary already on PATH).
    #   Ctrl+t -> fuzzy-pick files/paths into the command line
    #   Ctrl+r -> fuzzy search command history
    if (Get-Module -ListAvailable -Name PSFzf) {
        Import-Module PSFzf
        Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
    }
}
