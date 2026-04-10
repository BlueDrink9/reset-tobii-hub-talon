# Tobii Hub Reset for Talon

This script power-cycles your Tobii eye tracker (including via Talon voice command), useful if the tracker has crashed and needs to be reset.

Resetting the EyeChip directly usually doesn't cycle its power, so this tool finds the parent USB hub and resets that instead. It uses a Scheduled Task to run silently as Admin, meaning no annoying UAC popups stealing your focus. Technically this doesn't need talon at all, so if you are using the eye tracker and want to reset it by script without talon, you can still install this and just trigger running the scheduled task by whatever your preferred means are, for example auto hotkey.

### Quick Install

1. Download [install.bat](./install.bat?raw=true) (Right click, save link as...).
2. Right-click the downloaded file and select "Run as administrator".

The script downloads the code, drops it in `%APPDATA%\talon\user\tobii-reset`, and sets up the silent Scheduled Task. No Git required.

### Manual Install

If you'd rather clone it yourself:

```cmd
cd %APPDATA%\talon\user
git clone https://github.com/BlueDrink9/reset-tobii-hub-talon.git tobii-reset
cd tobii-reset

```

Then right-click `install.bat` and "Run as administrator" to register the Scheduled Task.

### Usage in Talon

Once installed, just tell Talon to trigger the task. By default this repo includes the voice command "reset hub".

To create your own command, in a `.talon` file:

```talon
reset tobii: user.system_command('schtasks /run /tn "ResetTobii"')
```
