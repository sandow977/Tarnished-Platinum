#include "macros/btlcmd.inc"

_000:
    PrintAttackMessage
    Wait
    CompareVarToValue OPCODE_FLAG_SET, BTLVAR_MOVE_STATUS_FLAGS, MOVE_STATUS_MISSED | MOVE_STATUS_SEMI_INVULNERABLE, _done
    CheckSubstitute BTLSCR_DEFENDER, _no_effect

    CompareMonDataToValue OPCODE_EQU, BTLSCR_DEFENDER, BATTLEMON_TYPE_1, TYPE_GRASS, _already_grass
    CompareMonDataToValue OPCODE_EQU, BTLSCR_DEFENDER, BATTLEMON_TYPE_2, TYPE_GRASS, _already_grass

_apply:
    PlayMoveAnimation BTLSCR_ATTACKER
    Wait
    AddBattlerType BTLSCR_DEFENDER, TYPE_GRASS
    UpdateVar OPCODE_SET, BTLVAR_MSG_TEMP, TYPE_GRASS
    PrintGlobalMessage BattleStrings_Text_PokemonTransformedIntoType_Ally, TAG_NICKNAME_TYPE, BTLSCR_DEFENDER, BTLSCR_MSG_TEMP
    Wait
    WaitButtonABTime 30
    End

_no_effect:
    PrintMessage BattleStrings_Text_ButItHadNoEffect, TAG_NONE
    Wait
    WaitButtonABTime 30
    End

_already_grass:
    UpdateVar OPCODE_FLAG_ON, BTLVAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End

_done:
    End
