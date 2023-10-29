# INGCAPADEV PS Profile
# -----------------------------------------
# Functions
# -----------------------------------------

function blog {
    cd C:\my-blog\
}

function dev {
    cd C:\Users\FTACapa\VSCodeProjects\
}

function work {
    cd C:\Users\FTACapa\WorkProjects\
}

function commit {
    param (
        [string]$Message
    )

    # Check the number of unnamed parameters (args)
    if ($args.Count -gt 0) {
        Write-Host ""
        Write-Host "Error: Incorrect number of arguments." -ForegroundColor Red
        Write-Host "Usage: commit 'message'" -ForegroundColor Blue
        Write-Host ""

        return
    }

    if (-not $Message) {
        Write-Host ""
        Write-Host "Error: No commit message specified. Aborting commit..." -ForegroundColor Red
        Write-Host ""
        return
    }

    $conventionalCommits = @("fix", "feat", "refactor", "build", "chore", "ci", "docs", "style", "test", "BREAKING CHANGE")

    Write-Host "`nStaged files:"
    $stagedFiles = git diff --name-only --cached 2>$null
    if (-not [string]::IsNullOrWhiteSpace($stagedFiles)) {
        $stagedFiles.Split([Environment]::NewLine) | ForEach-Object { Write-Host $_ -ForegroundColor Green }
    }
    else {
        Write-Host "No staged files" -ForegroundColor Yellow
        Write-Host "Aborting commit..." -ForegroundColor Red
        Write-Host ""
        return
    }
    Write-Host ""

    Write-Host "Do you want to add a context?" -NoNewLine -ForegroundColor Blue
    Write-Host " (Y) " -NoNewLine -ForegroundColor Green
    Write-Host "[Press any key to skip] : " -NoNewLine -ForegroundColor Red
    $KeyInfo = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    if ($KeyInfo.VirtualKeyCode -eq 89) {
        # 89 is the virtual key code for 'Y'
        $response = "Y"
    }
    else {
        $response = "N"
    }
    Write-Host ""
    


    while ($true) {
        Write-Host ""
        for ($i = 0; $i -lt $conventionalCommits.Length; $i++) {
            Write-Host "$($i+1): $($conventionalCommits[$i])"
        }
        Write-Host ""
        Write-Host "Select commit type: " -ForegroundColor Blue -NoNewLine
    

        $choice = [int](Read-Host)
        if ($choice -ge 1 -and $choice -le $conventionalCommits.Length) {
            $conventionalOption = $conventionalCommits[$choice - 1]
            if ($response -eq "Y" -or $response -eq "y") {
                Write-Host ""
                Write-Host "Enter the context: " -ForegroundColor Yellow -NoNewLine
                $context = Read-Host
                $commitMessage = "{0}({1}): {2}" -f $conventionalOption, $context, $Message
            }
            else {
                $commitMessage = "{0}: {1}" -f $conventionalOption, $Message
            }
            Write-Host ""
            git commit -m $commitMessage
            Write-Host "Commit successful: $commitMessage" -ForegroundColor Green
            Write-Host ""
            return
        }
        else {
            Write-Host ""
            Write-Host "Invalid option, please select a valid commit type..." -ForegroundColor Red
            Write-Host ""
        }
    }
}

function print_custom_banner {
    Write-Host "  ___ _  _  ___  ___"
    Write-Host " |_ _| \| |/ __|/ __|__ _ _ __  __ _|   \ _____ __"
    Write-Host "  | || .\` | (_ | (__/ _\` | '_ \/ _\` | |) / -_) V /"
    Write-Host " |___|_|\_|\___|\___\__,_| .__/\__,_|___/\___|\_/ "
    Write-Host "                         |_|"
}

function SSH-Keys {
    Write-Host "`n`nWelcome INGCapaDEV! Please enter your SSH keys.`n" -ForegroundColor Yellow
    Write-Host "Github (INGCapaDEV) [Press enter to skip]" -ForegroundColor Blue
    ssh-add "$env:USERPROFILE\.ssh\id_rsa"
    Write-Host ""
}

function Ask-To-Add-SSH-Keys {
    Write-Host "`nDo you want to add your SSH keys?" -NoNewLine -ForegroundColor Blue
    Write-Host " (Y) " -NoNewLine -ForegroundColor Green
    Write-Host "[Press any key to skip] : " -NoNewLine -ForegroundColor Red

    while ($true) {
        if ([System.Console]::KeyAvailable) {
            $key = [System.Console]::ReadKey($true).Key
            if ($key -eq [System.ConsoleKey]::Y) {
                SSH-Keys
            } 
            Write-Host ""
            break
        }
    }
    
}


# -----------------------------------------
# Oh-My-Posh
# -----------------------------------------
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/sim-web.omp.json" | Invoke-Expression

# -----------------------------------------
# Aliases Functions
# -----------------------------------------
function git_status {
    git status
}

function git_add_all {
    git add .
}

function git_push_origin_main {
    git push -u origin main
}

function git_push_origin_master {
    git push -u origin master
}

function git_push_origin_dev {
    git push -u origin develop
}

function git_branch {
    param(
        [string]$BranchName
    )

     if ($args.Count -gt 0) {
        git branch
        return
    }
    
    git branch $BranchName
    
}

function git_ls {
    git log --pretty=format:'%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn]' --decorate
}

function git_ll {
    git log --pretty=format:'%C(yellow)%h%C(red)%d %C(reset)%s%C(blue) [%cn]' --decorate --numstat
}

function git_pull {
    git pull
}

function git_switch {
    param(
        [string]$BranchName
    )

     if ($args.Count -gt 0) {
        Write-Host ""
        Write-Host "Error: Incorrect number of arguments." -ForegroundColor Red
        Write-Host "Usage: gsw 'branch'" -ForegroundColor Blue
        Write-Host ""

        return
    }
    
    if (-not $BranchName) {
         Write-Host ""
        Write-Host "Error: No branch specified. Aborting switch..." -ForegroundColor Red
        Write-Host "Usage: gsw 'branch'" -ForegroundColor Blue
        Write-Host ""
        return
    }

    git switch $BranchName
}

# -----------------------------------------
# Aliases
# -----------------------------------------
Set-Alias -Name gaa -Value git_add_all
Set-Alias -Name gpom -Value git_push_origin_main
Set-Alias -Name gpode -Value git_push_origin_dev
Set-Alias -Name gpoma -Value git_push_origin_master
Set-Alias -Name gbr -Value git_branch
Set-Alias -Name gs -Value git_status
Set-Alias -Name gls -Value git_ls
Set-Alias -Name gll -Value git_ll
Set-Alias -Name gpl -Value git_pull
Set-Alias -Name gsw -Value git_switch 
Set-Alias -Name sshk -Value SSH-Keys

# -----------------------------------------
# Modules
# -----------------------------------------
Import-Module -Name Terminal-Icons
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineOption -PredictionViewStyle ListView

# -----------------------------------------
# Prompt
# -----------------------------------------
print_custom_banner

