#include "macros/btlcmd.inc"


_000:
    PrintAttackMessage
    Wait
    WaitButtonABTime 15
    PrintMessage BattleStrings_Text_PokemonsAbilityBlocksMove_Ally, TAG_NICKNAME_ABILITY_MOVE, BTLSCR_MSG_TEMP, BTLSCR_MSG_BATTLER_TEMP, BTLSCR_ATTACKER
    Wait
    WaitButtonABTime 30
    End
