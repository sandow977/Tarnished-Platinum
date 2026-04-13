#include "macros/btlcmd.inc"


_000:
    UpdateMonData OPCODE_SET, BTLSCR_ATTACKER, BATTLEMON_ABILITY, ABILITY_LINGERING_AROMA
    PrintMessage BattleStrings_Text_PokemonAcquiredAbility_Ally, TAG_NICKNAME_ABILITY, BTLSCR_ATTACKER, BTLSCR_ATTACKER
    Wait
    WaitButtonABTime 30
    End
