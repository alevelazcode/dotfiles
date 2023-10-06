# Import-Module posh-git

# # Fzf
# Import-Module PSFzf
# Set-PsFzfOption -PSReadLineChordProvider 'Ctrl+f' -PSReadLineChordReverseHistory 'Ctrl+r'
#
#
# Alias
Set-Alias -Name vim -Value nvim
Set-Alias ll ls
Set-Alias tt tree
Set-Alias vim nvim
Set-Alias vi nvim
Set-Alias g git
Set-Alias cat bat
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'

#Prompt 
oh-my-posh init pwsh | Invoke-Expression
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/bubbles.omp.json" | Invoke-Expression


Import-Module -Name Terminal-Icons

# PSReadLine
Set-PSReadLineOption -EditMode Vi
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView



#Functions
# Emulate which
function which ($command) {
	Get-Command -Name $command -ErrorAction SilentlyContinue |
	Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

# Emulate rm -rf
function rmrf ($path) {
    Remove-Item $path -Recurse -Force
}
# Emulate mkcd
function mkcd {
    mkdir $args[0] | Set-Location
}

function ns {
	npm run serve $args
	}
