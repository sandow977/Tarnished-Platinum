#include "macros/btlcmd.inc"


_000:
    PrintAttackMessage
    Wait
    WaitButtonABTime 15
    PrintMessage BattleStrings_Text_PokemonAvoidedDamageByUsingAbility_Ally, TAG_NICKNAME_ABILITY, BTLSCR_DEFENDER, BTLSCR_DEFENDER
    Wait
    WaitButtonABTime 30
    End
