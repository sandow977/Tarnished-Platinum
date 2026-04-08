#include "macros/btlcmd.inc"


_000:
    PrintMessage BattleStrings_Text_ThroatChopPreventsMove_Ally, TAG_NICKNAME_MOVE, BTLSCR_ATTACKER, BTLSCR_ATTACKER
    Wait
    WaitButtonABTime 30
    UnlockMoveChoice BTLSCR_ATTACKER
    End
