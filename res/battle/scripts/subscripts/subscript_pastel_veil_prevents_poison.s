#include "macros/btlcmd.inc"


_000:
    CompareVarToValue OPCODE_EQU, BTLVAR_SIDE_EFFECT_TYPE, SIDE_EFFECT_TYPE_INDIRECT, _020
    CompareVarToValue OPCODE_EQU, BTLVAR_SIDE_EFFECT_TYPE, SIDE_EFFECT_TYPE_ABILITY, _020
    CompareVarToValue OPCODE_EQU, BTLVAR_SIDE_EFFECT_TYPE, SIDE_EFFECT_TYPE_MOVE_EFFECT, _020
    CompareVarToValue OPCODE_EQU, BTLVAR_SIDE_EFFECT_TYPE, SIDE_EFFECT_TYPE_TOXIC_SPIKES, _020
    PrintAttackMessage
    Wait
    WaitButtonABTime 30

_020:
    PrintMessage BattleStrings_Text_PokemonsAbilityPreventsPoisoning_Ally, TAG_NICKNAME_ABILITY, BTLSCR_MSG_BATTLER_TEMP, BTLSCR_MSG_TEMP
    Wait
    WaitButtonABTime 30
    End
