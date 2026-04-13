options = {
    {   default = 1,
        label = "Unused Slot Resources",
        help = "Unused slot resources can be removed or stay available",
        key = "unusedSlotResources",
        pref = "unusedSlotResources",
        values = {
            { text = "Despawn", help = "Unused slot resources must be despawned", key = 0 },
            { text = "Untouch", help = "Unused slot resources stay available", key = 1 }
        }
    },

    {   default = 9,
        label = "Limit Mass Deposits Per Spawn",
        help = "Limit mass deposits per each spawn.",
        key = "limitMassDepositsPerSpawn",
        pref = "limitMassDepositsPerSpawn",
        values = {
            { text = "0 deposits", help = "Mass deposits per spawn must be 0", key = 0 },
            { text = "1 deposit",  help = "Mass deposits per spawn must be 1 or less", key = 1 },
            { text = "2 deposits", help = "Mass deposits per spawn must be 2 or less", key = 2 },
            { text = "3 deposits", help = "Mass deposits per spawn must be 3 or less", key = 3 },
            { text = "4 deposits", help = "Mass deposits per spawn must be 4 or less", key = 4 },
            { text = "5 deposits", help = "Mass deposits per spawn must be 5 or less", key = 5 },
            { text = "6 deposits", help = "Mass deposits per spawn must be 6 or less", key = 6 },
            { text = "8 deposits", help = "Mass deposits per spawn must be 8 or less", key = 8 },
            { text = "Unlimited",  help = "Mass deposits per spawn unlimited", key = 99 },
        }
    },

    {   default = 5,
        label = "Limit Hydrocarbons Per Spawn",
        help = "Limit hydrocarbons per each spawn.",
        key = "limitHydrocarbonsPerSpawn",
        pref = "limitHydrocarbonsPerSpawn",
        values = {
            { text = "0 hydrocarbons", help = "Hydrocarbons per spawn must be 0", key = 0 },
            { text = "1 hydrocarbon",  help = "Hydrocarbons per spawn must be 1 or less", key = 1 },
            { text = "2 hydrocarbons", help = "Hydrocarbons per spawn must be 2 or less", key = 2 },
            { text = "3 hydrocarbons", help = "Hydrocarbons per spawn must be 3 or less", key = 3 },
            { text = "Unlimited",      help = "Hydrocarbons per spawn unlimited", key = 99 },
        }
    },

    {   default = 1,
        label = "Common Map Mass Deposits",
        help = "Common map mass deposits can be limited",
        key = "commonMapMassDeposits",
        pref = "commonMapMassDeposits",
        values = {
            { text = "Untouch",   help = "Common map mass deposits spawn chance 100%%", key = 1 },
            { text = "Keep 75%%", help = "Common map mass deposits spawn chance 75%%", key = 0.75 },
            { text = "Keep 50%%", help = "Common map mass deposits spawn chance 50%%", key = 0.5 },
            { text = "Keep 25%%", help = "Common map mass deposits spawn chance 25%%", key = 0.25 },
            { text = "Keep 10%%", help = "Common map mass deposits spawn chance 10%%", key = 0.1 },
            { text = "Despawn",   help = "Common map mass deposits despawn all", key = 0 }
        }
    },

    {   default = 1,
        label = "Common Map Hydrocarbons",
        help = "Common map hydrocarbons can be limited",
        key = "commonMapHydrocarbons",
        pref = "commonMapHydrocarbons",
        values = {
            { text = "Untouch",   help = "Common map hydrocarbons spawn chance 100%%", key = 1 },
            { text = "Keep 75%%", help = "Common map hydrocarbons spawn chance 75%%", key = 0.75 },
            { text = "Keep 50%%", help = "Common map hydrocarbons spawn chance 50%%", key = 0.5 },
            { text = "Keep 25%%", help = "Common map hydrocarbons spawn chance 25%%", key = 0.25 },
            { text = "Keep 10%%", help = "Common map hydrocarbons spawn chance 10%%", key = 0.1 },
            { text = "Despawn",  help = "Common map hydrocarbons despawn all", key = 0 }
        }
    },

    {   default = 3,
        label = "Natural Reclaim Modifier",
        help = "Change mass and energy values of rocks and trees",
        key = "naturalReclaimModifier",
        pref = "naturalReclaimModifier",
        values = {
            { text = "200%%", help = "Natural reclaim doubled of original", key = 2 },
            { text = "150%%", help = "Natural reclaim increased to 150%% of original", key = 1.5 },
            { text = "100%%", help = "Natural reclaim unchanged", key = 1 },
            { text = " 75%%", help = "Natural reclaim reduced to 75%% of original", key = 0.75 },
            { text = " 50%%", help = "Natural reclaim reduced to 50%% of original", key = 0.5 },
            { text = " 25%%", help = "Natural reclaim reduced to 25%% of original", key = 0.25 },
            { text = " 10%%", help = "Natural reclaim reduced to 10%% of original", key = 0.1 },
            { text = "  5%%", help = "Natural reclaim reduced to 5%% of original", key = 0.05 }
        }
    },

    {   default = 5,
        label = "Forest Regrow Chance",
        help = "Regrow chance of trees for each minute after regrow delay is out",
        key = "forestRegrowChance",
        pref = "forestRegrowChance",
        values = {
            { text = "100%%", help = "Trees regrow always just after regrow delay is out", key = 1 },
            { text = " 75%%", help = "Trees regrow with chance 75%% for each minute after regrow delay is out", key = 0.75 },
            { text = " 50%%", help = "Trees regrow with chance 50%% for each minute after regrow delay is out", key = 0.5 },
            { text = " 25%%", help = "Trees regrow with chance 25%% for each minute after regrow delay is out", key = 0.25 },
            { text = " 10%%", help = "Trees regrow with chance 10%% for each minute after regrow delay is out", key = 0.1 },
            { text = "  5%%", help = "Trees regrow with chance 5%% for each minute after regrow delay is out", key = 0.05 },
            { text = "  2%%", help = "Trees regrow with chance 2%% for each minute after regrow delay is out", key = 0.02 },
            { text = "  1%%", help = "Trees regrow with chance 1%% for each minute after regrow delay is out", key = 0.01 },
            { text = "Never", help = "Trees never regrow", key = 0 }
        }
    },

    {   default = 7,
        label = "Forest Regrow Delay",
        help = "Time delay before trees get chance to regrow",
        key = "forestRegrowDelay",
        pref = "forestRegrowDelay",
        values = {
            { text = "30 minutes", help = "Trees get chance to regrow after 30 minutes", key = 30 },
            { text = "20 minutes", help = "Trees get chance to regrow after 20 minutes", key = 20 },
            { text = "15 minutes", help = "Trees get chance to regrow after 15 minutes", key = 15 },
            { text = "10 minutes", help = "Trees get chance to regrow after 10 minutes", key = 10 },
            { text = " 7 minutes", help = "Trees get chance to regrow after 7 minutes", key = 7 },
            { text = " 5 minutes", help = "Trees get chance to regrow after 5 minutes", key = 5 },
            { text = " 3 minutes", help = "Trees get chance to regrow after 3 minutes", key = 3 },
            { text = " 2 minutes", help = "Trees get chance to regrow after 2 minutes", key = 2 },
            { text = " 1 minute",  help = "Trees get chance to regrow after 1 minutes", key = 1 }
        }
    }
};


