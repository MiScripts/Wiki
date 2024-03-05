@echo off

set scriptFileName=%~n0
set scriptFolderPath=%~dp0
set powershellScriptFileName=USB_Script.ps1

powershell -Command "Start-Process powershell \"-ExecutionPolicy RemoteSigned -WindowStyle hidden -NoProfile -NoExit -Command `\"cd \`\"%scriptFolderPath%`\"; & \`\".\%powershellScriptFileName%\`\"`\"\" -Verb RunAs"
