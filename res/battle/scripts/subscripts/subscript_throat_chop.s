#include "macros/btlcmd.inc"


_000:
    CheckSubstitute BTLSCR_SIDE_EFFECT_MON, _end
    CompareMonDataToValue OPCODE_NEQ, BTLSCR_SIDE_EFFECT_MON, BATTLEMON_THROAT_CHOP_TURNS, 0, _end
    UpdateMonData OPCODE_SET, BTLSCR_SIDE_EFFECT_MON, BATTLEMON_THROAT_CHOP_TURNS, 3

_end:
    End
