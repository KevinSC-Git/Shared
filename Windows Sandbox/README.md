Source: https://github.com/firefart/sandbox

First download all files by executing .\downloadFiles.ps1 inside powershell. This will grab all setups needed. Then run .\createSandboxConfig.ps1 once to create the .wsb file. This is needed because relative paths are currently not supported by Windows Sandbox.

Based on this article I've a few scripts to create wsb-files

1. Download ZIP with all scripts in it
2. Run Create_Structure.ps1 to setup the same structure as used in the script.
3. Run CreateSandboxConfig.ps1 to create the WSB-file.

Currently the files you downloaded are saved wherever you like.
The folder "ConfigFiles" is being used to save configfiles.
In this folder I have put an example of what can be used to start.
Currently I'm using a CMD file that needs to be ran inside my sandbox environment which set the executionpolicy and runs a script called AutoStart.ps1 with installs a few packages. You can add if you want, where you put those?

Well the structure is setup so all installers can be added in "SandboxFiles".
Additionally there is a script called 'downloadFiles.ps1" which is being used in the original article to download software. I only adjusted the location to save after downloading.

The last folder is called "WSB", this the folder where the WSB-file will be saved.

Last step is then simply doubleclick the WSB-file you created to launch the sandbox. This will install all needed software on start.
