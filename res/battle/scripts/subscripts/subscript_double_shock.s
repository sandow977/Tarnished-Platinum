#include "macros/btlcmd.inc"

_000:
    RemoveBattlerType BTLSCR_ATTACKER, TYPE_ELECTRIC
    PrintGlobalMessage BattleStrings_Text_PokemonUsedUpAllItsElectricity_Ally, TAG_NICKNAME, BTLSCR_ATTACKER
    Wait
    WaitButtonABTime 30
    End
