# PlateBuffer

### Please note that this is a BETA release and as such it might at times print a message to your chat if it's lacking data for a spell. Please report these to me here or on Discord: null#0010 so that I can add the spells to the database!

![Screenshot](PlateBuffer.png)

## What does it do

PlateBuffer adds aura icons to enemy unit nameplates. You can configure what buffs and debuffs you want to track; if you want to see only yours or ones applied by others also. Currently it will only track auras that have a duration. The addon does not change your nameplates, only adds buffs to them, so you can use it with the default nameplates, Aloft, ElvUI or others.

## How to configure

Type /pb or /platebuffer in game to bring up the config menu. To track new spells click inside the editbox and press enter to make a new line, type in the spells name followed by '/mine' or '/all' depending whose auras you want to track. E.g: 'Curse of Agony/mine'. For dots and other spells that can have multiple instances I recommend only tracking your own.

## How to install

Since this is a beta release, you will have to clone/download this repo, rename the folder to PlateBuffer and place it in your AddOns folder.

## How does it work - Technical details

To display buffs on a nameplate we need to identify the nameplate first. This is possible by targeting a unit, mouseovering a nameplate, by unit name (only for players) or raid target markers. If a unit walks off screen or you turn the camera so that the nameplate disappears, it needs to be identified again.

Naturally we need to track unit buffs as well, this is done by parsing the combatlog events and Unitbuff calls on the UNIT_AURA event. The TBC client does not have aura durations for anything but the players spells so we need to have a database of those and also track diminishing returns so those can be applied to the durations also.

## Technical limitations

There are many limitations with the TBC client compared to later versions, which makes an addon such as this more difficult to achieve. The TBC client's Combatlog events are incomplete with some not firing and others lacking source guids. UnitBuff is lacking caster data and durations also. Due to these limitations, we can only track one instance of each spell and we need to rely on a database for durations outside of our own auras. We also can't account for talented durations.

## Known issues

The cooldown texture will flicker when a nameplate moves. This seems to be unfixable without creating a custom texture. I will add an option to disable the texture soon.

## To-do

* Identifying units by raid marker
* Revisit the config later as it was patched together in a hurry

## Credits and acknowledgements

* Much love to Elyne from the Netherwing discord for helping me with testing the addon and for gathering and filling aura data.
* Pyralis for letting me butcher his config GUI code.
* Cyprias for his LibAuraInfo, which I based my aura database on.
