if($env:OS -notlike "*Windows*")
{ 
    Write-Host "> This script is only for Windows OS" -ForegroundColor DarkRed
    exit
}

$container = & .\listSetup.ps1 # Importing the list of tools for install

#region Functions
Import-Module ".\library.psm1"

# Imported Functions List:
#  - installerSearch <- (Name, Executable, Path)
#  - installerExe <- (Name, Id, Path)
#  - gitRepoSetup <- (Name, Repo, Path)
#  - scriptSetup <- (Path, File)

#endregion Functions



#region Package Manager Setup
installerSearch "winget list --id" "Winget Install" $container["packManagers"]
# $packManagers

installerExe "Invoke-RestMethod" @(,@("Scoop", "scoop", "get.scoop.sh"))

installerExe "nvm install" $container["npmVersions"]
#endregion Package Manager Setup



#region Setup Installations
# -- Winget
installerSearch "winget list --id" "Winget install" $container["winList"]

# -- Scoop
installerSearch "scoop list" "scoop install" $container["scoopPathList"]

# -- NPM
installerExe "npm install -g" $container["npmList"]
Write-Output '{ "path": "cz-conventional-changelog" }' > ~/.czrc # Set Commitizen Path

# -- Dotnet
installerExe "dotnet tool install -g" $container["dotnetList"]

# -- PIP
installerExe "pip install --upgrade" $container["pipList"]

# -- PowerShell
installerSearch "Get-Module -ListAvailable" "Install-Module -Force" $container["powerList"]
#endregion Setup Tools



#region Git Setups
gitRepoSetup $container["gitDotfileList"]
#endregion Git Setups



#region Terminal Config Setup
scriptSetup $container["scriptDotfileList"]
