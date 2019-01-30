# PlateBuffer

### Please note that this is a BETA release and it might at times print a message to your chat if it's lacking data for a spell. Please report these to me here or on Discord: null#0010 so that I can add the spells to the database!

![Screenshot](PlateBuffer.png)

## What does it do

PlateBuffer adds aura icons to enemy unit nameplates. You can choose which buffs and debuffs you want to see. It will track auras that have a duration. The addon does not change your nameplates, only adds buffs to them so it works with the default nameplates, Aloft, ElvUI and others.

## How to configure

Type /pb or /platebuffer in game to bring up the config menu. To track new spells click inside the editbox and press enter to make a new line, type in the name of the spell followed by '/mine' or '/all' depending whose auras you want to track. E.g: 'Curse of Agony/mine'. 
For dots and other spells that can have multiple instances I recommend only tracking your own.

## How to install

Since this is a beta release, you will have to clone/download this repo, rename the folder to PlateBuffer and place it in your AddOns folder.

## How does it work

To display auras on a nameplate we need to identify the nameplate first. This is done by targeting a unit, mouseovering a nameplate, by unit name (only for players) or raid target markers. If a unit walks offscreen or you turn the camera so that the nameplate is hidden, it needs to be identified again before auras can be shown!

Spell durations and DRs are tracked by listening to the UNIT_AURA event as well as combat log events. A database of spell durations and debufftypes is utilized for this.

## Technical limitations

The TBC client's API is quite limited compared to later versions with both the Combatlog and UnitBuff missing a lot of data. This means we can only track one instance of each spell and we need to rely on a database for durations outside of our own auras. We also can not account for talented durations.

## Known issues

* The cooldown texture will flicker when a nameplate moves. You have the option to disable it in the config.

## To-do

* Identifying units by raid marker
* Revisit the config later as it was patched together in a hurry

## Credits and acknowledgements

* Much love to Elyne for helping me with testing the addon and for gathering and filling aura data.
* Pyralis for letting me butcher his config GUI code.
* Cyprias for his LibAuraInfo, which I based my aura database on.
* Theroxis for helping me debug!
