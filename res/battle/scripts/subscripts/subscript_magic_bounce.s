#include "macros/btlcmd.inc"


_000:
    PrintAttackMessage
    Wait
    WaitButtonABTime 15
    PrintMessage BattleStrings_Text_PokemonsAbilityBouncedBackMove_Ally, TAG_NICKNAME_ABILITY_MOVE, BTLSCR_DEFENDER, BTLSCR_DEFENDER, BTLSCR_ATTACKER
    Wait
    WaitButtonABTime 30
    MagicCoat
    UpdateVar OPCODE_FLAG_OFF, BTLVAR_BATTLE_CTX_STATUS, SYSCTL_PLAYED_MOVE_ANIMATION
    End
