# Tobii Hub Reset for Talon

This script power-cycles your Tobii eye tracker (including via Talon voice command), useful if the tracker has crashed and needs to be reset.

Resetting the EyeChip directly usually doesn't cycle its power, so this tool finds the parent USB hub and resets that instead. It uses a Scheduled Task to run silently as Admin, meaning no annoying UAC popups stealing your focus. Technically this doesn't need talon at all, so if you are using the eye tracker and want to reset it by script without talon, you can still install this and just trigger running the scheduled task by whatever your preferred means are, for example auto hotkey.

**Linux**: This repository is Windows only, for a Linux equivalent see [#linux](#linux).

**OSX**: No OSX version yet. You might be able to plug something together with hard coding using `uhubctl`.

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

## Linux

The script that does the equivalent reset of the Tobii parent hub is available [here](https://github.com/BlueDrink9/env/blob/master/shell/scripts/reset-tobii-hub.py) (permalink)[https://github.com/BlueDrink9/env/blob/61f264574c91af67d3983bbfd9b95dd3571d41af/shell/scripts/reset-tobii-hub.py]

To run this with talon, that script needs to be available on your PATH and runnable with sudo without a password. 
For example on NixOS, I use [this script](https://github.com/BlueDrink9/env/blob/master/nix/root_scripts.nix) to automatically copy the python file as an executable that is runnable as pseudo without a password.

Then in talon, have a voice command

```talon
reset hub: user.system_command('sudo reset-tobii-hub')
```

If you are on another distro, you can do [something similar](https://github.com/BlueDrink9/env/blob/61f264574c91af67d3983bbfd9b95dd3571d41af/nix/system-manager/modules/default.nix#L54-L64) with system-manager.
Otherwise modify the sudoers file yourself.

