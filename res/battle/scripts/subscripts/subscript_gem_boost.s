#include "macros/btlcmd.inc"


_000:
    PlayBattleAnimation BTLSCR_MSG_TEMP, BATTLE_ANIMATION_HELD_ITEM
    Wait
    PrintMessage BattleStrings_Text_TheItemStrengthenedMovesPower, TAG_ITEM_MOVE, BTLSCR_MSG_BATTLER_TEMP, BTLSCR_ATTACKER
    Wait
    RemoveItem BTLSCR_MSG_TEMP
    End
