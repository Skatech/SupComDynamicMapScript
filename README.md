# Supreme Commander Dynamic Map Script

Allow players fine adjust map resources for each game

## Features
- Option to remove mass/hydro deposits associated with unused army slots
- Adjust amount of army slots associated mass/hydro deposits
- Adjust amount of common map mass/hydro deposits
- Adjust resource amount in natural reclaim (trees/rocks)
- Forest regrow function with adjustable regrow cooldown and chance

## Performance
- Resource adjust functions finishing before mission init ends and not affects performance
- Forest regrow function thead mostly sleeps, evenly distributed by time and not causes any freeses

## Files
- mapname_options.lua - file with setup options
- mapname_script.lua - file with algorithms, also includes resource setup tables


## Resource setup tables
Two arrays for mass and hydro deposits associated with each army slot, in file mapname_script.lua

```lua
local ArmySlotsMexes = { {1,2}, {3,4}, {5,6} }
local ArmySlotsHydro = { {1}, {2}, {3} }
```

- In this example described three armies, each linked with two mass deposits and one hydrocarbon
- Deposits not listed in this tables script counts as **common map resources**

## Map setup options
- **Unused Slot Resources: Despawn, Untouch** - remove deposits associated with unused army slots
- **Limit Mass Deposits Per Spawn: 0, 1, 2 ... 9, Unlimited** - limit mass deposits per army spawn
- **Limit Hydrocarbons Per Spawn: 0, 1 ... 3, Unlimited** - limit hydrocarbon spots per army spawn
- **Common Map Mass Deposits: Untouch, 75%, 50% ... Despawn"** - limit common map mass deposits
- **Common Map Hydrocarbons: Untouch, 75%, 50% ... Despawn"** - limit common map hydrocarbon spots
- **Natural Reclaim Modifier: 200%, 150% ... 5%** - adjust resource amount in trees/rocks
- **Forest Regrow Chance: 100%, 75%, 50% ... 1%** - tree regrow chance per minute, after cooldown
- **Forest Regrow Delay: 30, 20, 15, 10 ... 1** - tree regrow cooldown in minutes

## Script usage
- Copy mapname_options.lua and mapname_script.lua to your map folder
- Rename files, changing *mapname* prefix to match your map name
- Fill ArmySlotsMexes and ArmySlotsHydro in script file with proper army slots linked resources
- Have FUN!
