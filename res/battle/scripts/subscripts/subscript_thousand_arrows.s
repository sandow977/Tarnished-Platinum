#include "macros/btlcmd.inc"

_000:
    CompareMonDataToValue OPCODE_EQU, BTLSCR_DEFENDER, BATTLEMON_CUR_HP, 0, _end
    CheckSubstitute BTLSCR_DEFENDER, _end

    CompareMonDataToValue OPCODE_NEQ, BTLSCR_DEFENDER, BATTLEMON_MAGNET_RISE_TURNS, 0, _clear_magnet_rise
    CompareMonDataToValue OPCODE_FLAG_SET, BTLSCR_DEFENDER, BATTLEMON_MOVE_EFFECTS_MASK, MOVE_EFFECT_AIRBORNE, _clear_airborne
    GoTo _ground

_clear_magnet_rise:
    UpdateMonData OPCODE_SET, BTLSCR_DEFENDER, BATTLEMON_MAGNET_RISE_TURNS, 0
    UpdateMonData OPCODE_FLAG_OFF, BTLSCR_DEFENDER, BATTLEMON_MOVE_EFFECTS_MASK, MOVE_EFFECT_MAGNET_RISE
    GoTo _ground

_clear_airborne:
    UnlockMoveChoice BTLSCR_DEFENDER
    ToggleVanish BTLSCR_DEFENDER, FALSE
    Wait

_ground:
    UpdateMonData OPCODE_FLAG_ON, BTLSCR_DEFENDER, BATTLEMON_MOVE_EFFECTS_MASK, MOVE_EFFECT_THOUSAND_ARROWS_GROUNDED
    PrintMessage BattleStrings_Text_PokemonWasKnockedDownToTheGround_Ally, TAG_NICKNAME, BTLSCR_DEFENDER
    Wait
    WaitButtonABTime 30
    End

_end:
    End
