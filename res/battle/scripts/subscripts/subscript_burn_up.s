#include "macros/btlcmd.inc"

_000:
    RemoveBattlerType BTLSCR_ATTACKER, TYPE_FIRE
    PrintGlobalMessage BattleStrings_Text_PokemonBurnedItselfOut_Ally, TAG_NICKNAME, BTLSCR_ATTACKER
    Wait
    WaitButtonABTime 30
    End
