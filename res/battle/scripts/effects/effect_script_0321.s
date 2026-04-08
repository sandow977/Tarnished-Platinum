#include "macros/btlcmd.inc"


_000:
    CompareMonDataToValue OPCODE_EQU, BTLSCR_DEFENDER, BATTLEMON_HELD_ITEM, ITEM_NONE, _fail
    CalcCrit
    CalcDamage
    PrintAttackMessage
    Wait
    WaitButtonABTime 30
    PrintGlobalMessage BattleStrings_Text_PokemonIsAboutToBeAttackedByItsItem, TAG_NICKNAME_ITEM, BTLSCR_DEFENDER, BTLSCR_DEFENDER
    Wait
    WaitButtonABTime 30
    PlayMoveAnimation BTLSCR_ATTACKER
    Wait
    End

_fail:
    UpdateVar OPCODE_FLAG_ON, BTLVAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End
