#include "macros/btlcmd.inc"


_000:
    PrintAttackMessage
    Wait
    PrintMessage BattleStrings_Text_TheItemStrengthenedMovesPower, TAG_ITEM_MOVE, BTLSCR_MSG_BATTLER_TEMP, BTLSCR_ATTACKER
    Wait
    RemoveItem BTLSCR_MSG_TEMP
    PlayMoveAnimation BTLSCR_ATTACKER
    Wait
    End
