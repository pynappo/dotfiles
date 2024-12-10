oh-my-posh init pwsh --config "$HOME/.files/pynappo.omp.yaml" | Invoke-Expression
Import-Module scoop-completion
Import-Module cd-extras
Import-Module gsudoModule
Invoke-Expression (& { (zoxide init powershell | Out-String) })
function IsVirtualTerminalProcessingEnabled
{
    $MethodDefinitions = @'
[DllImport("kernel32.dll", SetLastError = true)]
public static extern IntPtr GetStdHandle(int nStdHandle);
[DllImport("kernel32.dll", SetLastError = true)]
public static extern bool GetConsoleMode(IntPtr hConsoleHandle, out uint lpMode);
'@
    $Kernel32 = Add-Type -MemberDefinition $MethodDefinitions -Name 'Kernel32' -Namespace 'Win32' -PassThru
    $hConsoleHandle = $Kernel32::GetStdHandle(-11) # STD_OUTPUT_HANDLE
    $mode = 0
    $Kernel32::GetConsoleMode($hConsoleHandle, [ref]$mode) >$null
    if ($mode -band 0x0004)
    { # 0x0004 ENABLE_VIRTUAL_TERMINAL_PROCESSING
        return $true
    }
    return $false
}

function CanUsePredictionSource
{
    return (! [System.Console]::IsOutputRedirected) -and (IsVirtualTerminalProcessingEnabled)
}

if (CanUsePredictionSource)
{
    Import-Module PSReadLine
    Set-PSReadLineOption -PredictionViewStyle ListView -PredictionSource HistoryAndPlugin -HistoryNoDuplicates
    Import-Module -Name Terminal-Icons
}


$env:FZF_DEFAULT_COMMAND="fd --hidden --follow --exclude .git --color=always --strip-cwd-prefix"
$env:FZF_CTRL_T_COMMAND=$env:FZF_DEFAULT_COMMAND
$env:FZF_DEFAULT_OPTS = "--height=80% --layout=reverse --ansi --info=inline --tabstop=2 -m --cycle --scroll-off=4"
$env:XDG_CONFIG_HOME = "$HOME\.config"
$env:MPV_HOME = "$HOME\.config\mpv"
$env:ANIMDL_CONFIG = "$HOME\.config\animdl\config.yml"
Function fzfb
{ fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}' @Args
}
Set-Alias -Name f -Value fzfb
$env:PYTHONIOENCODING="utf-8"
$env:PATH="$env:USERPROFILE\scoop\shims;$env:PATH"
$env:PATH="$env:APPDATA\Python\Python39\Scripts;$env:PATH"
# this doesn't work b/c powershell suck
$env:PATH=".\node_modules\.bin;$env:PATH"

# add stuff

Function Reload-Path
{
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}
Function Notepad
{ Notepads @Args
}
Function Dotfiles
{
    git -C $HOME/.files.git/ --work-tree=$HOME @Args
}
Function Jammers
{
    mpv "https://www.youtube.com/playlist?list=PLg-SQpG3Qf59d1hzWtxsFqZt9n0e2llep" --no-video @Args
}
Function Add-VSVars
{
    pushd "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools"
    cmd /c "VsDevCmd.bat&set" |
        foreach {
            if ($_ -match "=")
            {
                $v = $_.split("=", 2); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
            }
        }
    popd
    Write-Host "`nVisual Studio 2022 Command Prompt variables set." -ForegroundColor Yellow
}
Function Dotwindows
{
    if ($Args -and ($Args[0].ToString().ToLower() -eq "link"))
    {
        if ($Args.Count -ne 3)
        {"Please supply a link path AND a link target, respectively."
        } else
        {
            if (!(Test-Path $Args[1]))
            { Return Write-Error("Path invalid.")
            }
            if (!(Test-Path $Args[2]))
            { Return Write-Error("Target invalid.")
            }
            $Path = (Resolve-Path $Args[1]).ToString()
            $Target = (Resolve-Path $Args[2]).ToString()

            Move-Item $Path $Target -Force
            $Path = $Path.TrimEnd('\/')
            New-Item -ItemType SymbolicLink -Path $Path -Value ($Target + (Split-Path $Path -Leaf).ToString())
            Dotwindows add $Path
            Dotfiles add $Target
        }
    } else
    {
      git -C $HOME/.windows.git/ --work-tree=$HOME @Args
    }
}
Function Lazy-Dotfiles
{ lazygit -C $HOME/.files.git/ --work-tree=$HOME @Args
}
Function Lazy-Dotwindows
{ lazygit -C $HOME/.windows.git/ --work-tree=$HOME @Args
}

Function Pacup ([string]$Path = "$Home\.files\")
{
    scoop export > ($Path + 'scoop.json')
    winget export -o ($Path + 'winget.json') --accept-source-agreements
    pip freeze > ($Path + 'requirements.txt')
}

Function New-Link ($Path, $Target)
{
    New-Item -ItemType SymbolicLink -Path $Path -Value $Target
}

Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
    $Local:word = $wordToComplete.Replace('"', '""')
    $Local:ast = $commandAst.ToString().Replace('"', '""')
    winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}
Add-Type -AssemblyName Microsoft.VisualBasic

function Remove-Item-ToRecycleBin($Path)
{
    $item = Get-Item -Path $Path -ErrorAction SilentlyContinue
    if ($null -eq $item)
    {
        Write-Error("'{0}' not found" -f $Path)
    } else
    {
        $fullpath=$item.FullName
        Write-Verbose ("Moving '{0}' to the Recycle Bin" -f $fullpath)
        if (Test-Path -Path $fullpath -PathType Container)
        {
            [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteDirectory($fullpath,'OnlyErrorDialogs','SendToRecycleBin')
        } else
        {
            [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($fullpath,'OnlyErrorDialogs','SendToRecycleBin')
        }
    }
}
Set-Alias -Name dot -Value Dotfiles
Set-Alias -Name dotw -Value Dotwindows
Set-Alias -Name ldot -Value Lazy-Dotfiles
Set-Alias -Name ldotw -Value Lazy-Dotwindows
Set-Alias -Name trash -Value Remove-Item-ToRecycleBin
Function C
{
    Set-Location @Args
    Get-ChildItem
}
Function Mc
{
    mkdir @Args
    Set-Location @Args
}
Function Rmf
{
    Remove-Item -Force @Args
}
# powershell completion for gh                                   -*- shell-script -*-

function __gh_debug
{
    if ($env:BASH_COMP_DEBUG_FILE)
    {
        "$args" | Out-File -Append -FilePath "$env:BASH_COMP_DEBUG_FILE"
    }
}

filter __gh_escapeStringWithSpecialChars
{
    $_ -replace '\s|#|@|\$|;|,|''|\{|\}|\(|\)|"|`|\||<|>|&','`$&'
}

Register-ArgumentCompleter -CommandName 'gh' -ScriptBlock {
    param(
        $WordToComplete,
        $CommandAst,
        $CursorPosition
    )

    # Get the current command line and convert into a string
    $Command = $CommandAst.CommandElements
    $Command = "$Command"

    __gh_debug ""
    __gh_debug "========= starting completion logic =========="
    __gh_debug "WordToComplete: $WordToComplete Command: $Command CursorPosition: $CursorPosition"

    # The user could have moved the cursor backwards on the command-line.
    # We need to trigger completion from the $CursorPosition location, so we need
    # to truncate the command-line ($Command) up to the $CursorPosition location.
    # Make sure the $Command is longer then the $CursorPosition before we truncate.
    # This happens because the $Command does not include the last space.
    if ($Command.Length -gt $CursorPosition)
    {
        $Command=$Command.Substring(0,$CursorPosition)
    }
    __gh_debug "Truncated command: $Command"

    $ShellCompDirectiveError=1
    $ShellCompDirectiveNoSpace=2
    $ShellCompDirectiveNoFileComp=4
    $ShellCompDirectiveFilterFileExt=8
    $ShellCompDirectiveFilterDirs=16

    # Prepare the command to request completions for the program.
    # Split the command at the first space to separate the program and arguments.
    $Program,$Arguments = $Command.Split(" ",2)

    $RequestComp="$Program __complete $Arguments"
    __gh_debug "RequestComp: $RequestComp"

    # we cannot use $WordToComplete because it
    # has the wrong values if the cursor was moved
    # so use the last argument
    if ($WordToComplete -ne "" )
    {
        $WordToComplete = $Arguments.Split(" ")[-1]
    }
    __gh_debug "New WordToComplete: $WordToComplete"


    # Check for flag with equal sign
    $IsEqualFlag = ($WordToComplete -Like "--*=*" )
    if ( $IsEqualFlag )
    {
        __gh_debug "Completing equal sign flag"
        # Remove the flag part
        $Flag,$WordToComplete = $WordToComplete.Split("=",2)
    }

    if ( $WordToComplete -eq "" -And ( -Not $IsEqualFlag ))
    {
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go method.
        __gh_debug "Adding extra empty parameter"
        # We need to use `"`" to pass an empty argument a "" or '' does not work!!!
        $RequestComp="$RequestComp" + ' `"`"'
    }

    __gh_debug "Calling $RequestComp"
    # First disable ActiveHelp which is not supported for Powershell
    $env:GH_ACTIVE_HELP=0

    #call the command store the output in $out and redirect stderr and stdout to null
    # $Out is an array contains each line per element
    Invoke-Expression -OutVariable out "$RequestComp" 2>&1 | Out-Null

    # get directive from last line
    [int]$Directive = $Out[-1].TrimStart(':')
    if ($Directive -eq "")
    {
        # There is no directive specified
        $Directive = 0
    }
    __gh_debug "The completion directive is: $Directive"

    # remove directive (last element) from out
    $Out = $Out | Where-Object { $_ -ne $Out[-1] }
    __gh_debug "The completions are: $Out"

    if (($Directive -band $ShellCompDirectiveError) -ne 0 )
    {
        # Error code.  No completion.
        __gh_debug "Received error from custom completion go code"
        return
    }

    $Longest = 0
    $Values = $Out | ForEach-Object {
        #Split the output in name and description
        $Name, $Description = $_.Split("`t",2)
        __gh_debug "Name: $Name Description: $Description"

        # Look for the longest completion so that we can format things nicely
        if ($Longest -lt $Name.Length)
        {
            $Longest = $Name.Length
        }

        # Set the description to a one space string if there is none set.
        # This is needed because the CompletionResult does not accept an empty string as argument
        if (-Not $Description)
        {
            $Description = " "
        }
        @{Name="$Name";Description="$Description"}
    }


    $Space = " "
    if (($Directive -band $ShellCompDirectiveNoSpace) -ne 0 )
    {
        # remove the space here
        __gh_debug "ShellCompDirectiveNoSpace is called"
        $Space = ""
    }

    if ((($Directive -band $ShellCompDirectiveFilterFileExt) -ne 0 ) -or
       (($Directive -band $ShellCompDirectiveFilterDirs) -ne 0 ))
    {
        __gh_debug "ShellCompDirectiveFilterFileExt ShellCompDirectiveFilterDirs are not supported"

        # return here to prevent the completion of the extensions
        return
    }

    $Values = $Values | Where-Object {
        # filter the result
        $_.Name -like "$WordToComplete*"

        # Join the flag back if we have an equal sign flag
        if ( $IsEqualFlag )
        {
            __gh_debug "Join the equal sign flag back to the completion value"
            $_.Name = $Flag + "=" + $_.Name
        }
    }

    if (($Directive -band $ShellCompDirectiveNoFileComp) -ne 0 )
    {
        __gh_debug "ShellCompDirectiveNoFileComp is called"

        if ($Values.Length -eq 0)
        {
            # Just print an empty string here so the
            # shell does not start to complete paths.
            # We cannot use CompletionResult here because
            # it does not accept an empty string as argument.
            ""
            return
        }
    }

    # Get the current mode
    $Mode = (Get-PSReadLineKeyHandler | Where-Object {$_.Key -eq "Tab" }).Function
    __gh_debug "Mode: $Mode"

    $Values | ForEach-Object {

        # store temporary because switch will overwrite $_
        $comp = $_

        # PowerShell supports three different completion modes
        # - TabCompleteNext (default windows style - on each key press the next option is displayed)
        # - Complete (works like bash)
        # - MenuComplete (works like zsh)
        # You set the mode with Set-PSReadLineKeyHandler -Key Tab -Function <mode>

        # CompletionResult Arguments:
        # 1) CompletionText text to be used as the auto completion result
        # 2) ListItemText   text to be displayed in the suggestion list
        # 3) ResultType     type of completion result
        # 4) ToolTip        text for the tooltip with details about the object

        switch ($Mode)
        {

            # bash like
            "Complete"
            {

                if ($Values.Length -eq 1)
                {
                    __gh_debug "Only one completion left"

                    # insert space after value
                    [System.Management.Automation.CompletionResult]::new($($comp.Name | __gh_escapeStringWithSpecialChars) + $Space, "$($comp.Name)", 'ParameterValue', "$($comp.Description)")

                } else
                {
                    # Add the proper number of spaces to align the descriptions
                    while($comp.Name.Length -lt $Longest)
                    {
                        $comp.Name = $comp.Name + " "
                    }

                    # Check for empty description and only add parentheses if needed
                    if ($($comp.Description) -eq " " )
                    {
                        $Description = ""
                    } else
                    {
                        $Description = "  ($($comp.Description))"
                    }

                    [System.Management.Automation.CompletionResult]::new("$($comp.Name)$Description", "$($comp.Name)$Description", 'ParameterValue', "$($comp.Description)")
                }
            }

            # zsh like
            "MenuComplete"
            {
                # insert space after value
                # MenuComplete will automatically show the ToolTip of
                # the highlighted value at the bottom of the suggestions.
                [System.Management.Automation.CompletionResult]::new($($comp.Name | __gh_escapeStringWithSpecialChars) + $Space, "$($comp.Name)", 'ParameterValue', "$($comp.Description)")
            }

            # TabCompleteNext and in case we get something unknown
            Default
            {
                # Like MenuComplete but we don't want to add a space here because
                # the user need to press space anyway to get the completion.
                # Description will not be shown because that's not possible with TabCompleteNext
                [System.Management.Automation.CompletionResult]::new($($comp.Name | __gh_escapeStringWithSpecialChars), "$($comp.Name)", 'ParameterValue', "$($comp.Description)")
            }
        }

    }
}

Import-Module "$HOME\scoop\apps\gsudo\current\gsudoModule.psd1"
