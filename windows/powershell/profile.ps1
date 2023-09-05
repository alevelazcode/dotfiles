
# Alias
Set-Alias -Name vim -Value nvim
Set-Alias ll ls
Set-Alias tt tree
Set-Alias vim nvim
Set-Alias vi nvim
Set-Alias g git
Set-Alias grep findstr
Set-Alias cat gc

#Prompt 
oh-my-posh init pwsh | Invoke-Expression
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/bubbles.omp.json" | Invoke-Expression


Import-Module -Name Terminal-Icons

# PSReadLine
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History


#Functions 
function whereis ($command) {
	Get-Command -Name $command -ErrorAction SilentlyContinue |
	Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

#Emulate rm -rf
function rmrf ($path) {
    Remove-Item $path -Recurse -Force
}

# Emulate mkcd
function mkcd {
    mkdir $args[0] | Set-Location
}
