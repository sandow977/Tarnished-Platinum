#include "macros/btlcmd.inc"


_000:
    UpdateMonData OPCODE_SET, BTLSCR_MSG_ATTACKER, BATTLEMON_STATUS, MON_CONDITION_NONE
    SetHealthbarStatus BTLSCR_MSG_ATTACKER, BATTLE_ANIMATION_NONE
    PrintMessage BattleStrings_Text_PokemonsAbilityCuredItsStatus_Ally, TAG_NICKNAME_ABILITY_STATUS, BTLSCR_MSG_BATTLER_TEMP, BTLSCR_MSG_BATTLER_TEMP, BTLSCR_MSG_TEMP
    Wait
    WaitButtonABTime 30
    End
