#include "macros/btlcmd.inc"


_000:
    PrintAttackMessage
    Wait
    WaitButtonABTime 15
    PrintMessage BattleStrings_Text_PokemonIsNotAffectedByMoveThanksToItsItem, TAG_NICKNAME_ITEM_MOVE, BTLSCR_MSG_TEMP, BTLSCR_MSG_TEMP, BTLSCR_MSG_TEMP
    Wait
    PrintMessage BattleStrings_Text_ButItFailed, TAG_NONE
    Wait
    WaitButtonABTime 30
    End
