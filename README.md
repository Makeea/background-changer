# OSx Background Changer

This tool, when installed, will grab images from [Unsplash](https://unsplash.com).
It will the apply different images to the background of each of your desktops,
virtual or otherwise once daily at 5 AM. If your computer is asleep at that time,
it will run when it wakes up.

## Installation

The following instructions presume you have git installed:

1. Open up a terminal session
2. Run the following set of commands, move to step 3 when you get a prompt:

```bash
cd ~
git clone https://github.com/brainomite/background-changer.git
cd background-changer
chmod u+x background-changer.sh
chmod u+x wait.sh
chmod u+x setup.sh
./setup.sh
```

3. When prompted, go to System Preferences" > Desktop & Screen Savers
4. For each (doesn't have to be every) desktop you wish to have changed
   automatically daily. Select a picture to be a background, using the + sign on
   the bottom left of the windows where you can change the desktop. Please note
   _EACH_ picture must be different, if any two (or more) are the same, they will
   get the same unsplash image.
5. Press any key in the terminal that is waiting.
6. Shortly you will see your desktop images change.
7. Installation Complete!

# How to remove:

Running the following set of commands in the terminal will remove all traces.

```bash
cd ~
launchctl unload Library/LaunchAgents/local.backgroundchanger.plist
rm /Users/aaronyoung/Library/LaunchAgents/local.backgroundchanger.plist
rm -fr background-changer
```
