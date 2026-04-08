#include "macros/btlcmd.inc"


_000:
    CheckSubstitute BTLSCR_SIDE_EFFECT_MON, _end
    CompareMonDataToValue OPCODE_NEQ, BTLSCR_SIDE_EFFECT_MON, BATTLEMON_HEAL_BLOCK_TURNS, 0, _end
    UpdateMonData OPCODE_FLAG_ON, BTLSCR_SIDE_EFFECT_MON, BATTLEMON_MOVE_EFFECTS_MASK, MOVE_EFFECT_HEAL_BLOCK
    UpdateMonData OPCODE_SET, BTLSCR_SIDE_EFFECT_MON, BATTLEMON_HEAL_BLOCK_TURNS, 2
    // {0} was prevented from healing!
    PrintMessage BattleStrings_Text_PokemonWasPreventedFromHealing_Ally, TAG_NICKNAME, BTLSCR_SIDE_EFFECT_MON
    Wait 
    WaitButtonABTime 30

_end:
    End 
