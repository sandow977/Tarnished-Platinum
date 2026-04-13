#include "macros/btlcmd.inc"


_000:
    PrintMessage BattleStrings_Text_HarshSunlightActivatedPokemonsAbility_Ally, TAG_NICKNAME_ABILITY, BTLSCR_MSG_BATTLER_TEMP, BTLSCR_MSG_BATTLER_TEMP
    Wait
    WaitButtonABTime 30
    PlayBattleAnimation BTLSCR_MSG_BATTLER_TEMP, BATTLE_ANIMATION_STAT_BOOST
    Wait
    PrintMessage BattleStrings_Text_PokemonsStatRose_Ally, TAG_NICKNAME_STAT, BTLSCR_MSG_BATTLER_TEMP, BTLSCR_MSG_TEMP
    Wait
    WaitButtonABTime 30
    End
