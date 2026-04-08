#include "macros/btlcmd.inc"


_000:
    TryBelch _fail
    CalcCrit
    CalcDamage
    End

_fail:
    UpdateVar OPCODE_FLAG_ON, BTLVAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End