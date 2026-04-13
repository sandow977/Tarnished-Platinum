#include "macros/btlcmd.inc"


_000:
    PlayBattleAnimation BTLSCR_MSG_BATTLER_TEMP, BATTLE_ANIMATION_HELD_ITEM
    Wait
    PrintMessage BattleStrings_Text_TheItemWasActivated, TAG_ITEM, BTLSCR_MSG_BATTLER_TEMP
    Wait
    RemoveItem BTLSCR_MSG_BATTLER_TEMP
    PrintMessage BattleStrings_Text_PokemonIsExertingItsAbility_Ally, TAG_NICKNAME_ABILITY, BTLSCR_MSG_BATTLER_TEMP, BTLSCR_MSG_BATTLER_TEMP
    Wait
    WaitButtonABTime 30
    End
