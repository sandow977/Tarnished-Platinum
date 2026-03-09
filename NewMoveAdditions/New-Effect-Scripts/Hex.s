#include "macros/btlcmd.inc"


_000:
    CheckSubstitute BTLSCR_DEFENDER, _022
    CompareMonDataToValue OPCODE_FLAG_SET, BTLSCR_DEFENDER, BATTLEMON_STATUS, MON_CONDITION_ANY, _014
    UpdateVar OPCODE_SET, BTLVAR_POWER_MULTI, 10
    GoTo _022

_014:
    UpdateVar OPCODE_SET, BTLVAR_POWER_MULTI, 20

_022:
    CalcCrit 
    CalcDamage 
    End 