#include "macros/btlcmd.inc"


_000:
    TopsyTurvy _010
    Call BATTLE_SUBSCRIPT_ATTACK_MESSAGE_AND_ANIMATION
    // {0} inverted all stat changes affecting {1}!
    PrintGlobalMessage BattleStrings_Text_PokemonInvertedAllStatChangesAffectingPokemon_AllyAlly, TAG_NICKNAME_NICKNAME, BTLSCR_ATTACKER, BTLSCR_DEFENDER
    Wait
    WaitButtonABTime 30
    End

_010:
    UpdateVar OPCODE_FLAG_ON, BTLVAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End
