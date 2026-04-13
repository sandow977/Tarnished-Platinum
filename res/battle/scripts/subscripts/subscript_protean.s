#include "macros/btlcmd.inc"


_000:
    PrintMessage BattleStrings_Text_PokemonsAbilityMadeItType_Ally, TAG_NICKNAME_ABILITY_TYPE, BTLSCR_ATTACKER, BTLSCR_ATTACKER, BTLSCR_MSG_TEMP
    Wait
    WaitButtonABTime 30
    UpdateMonDataFromVar OPCODE_SET, BTLSCR_ATTACKER, BATTLEMON_TYPE_1, BTLVAR_MSG_TEMP
    UpdateMonDataFromVar OPCODE_SET, BTLSCR_ATTACKER, BATTLEMON_TYPE_2, BTLVAR_MSG_TEMP
    End
