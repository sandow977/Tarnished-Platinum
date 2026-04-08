#include "macros/btlcmd.inc"

_000:
    CheckItemHoldEffect CHECK_HAVE, BTLSCR_MSG_TEMP, HOLD_EFFECT_CHARGE_SKIP, _power_herb
    UpdateMonData OPCODE_FLAG_ON, BTLSCR_MSG_TEMP, BATTLEMON_MOVE_EFFECTS_MASK, MOVE_EFFECT_CHARGE
    UpdateMonData OPCODE_SET, BTLSCR_MSG_TEMP, BATTLEMON_CHARGED_TURNS, 2
    UpdateVar OPCODE_SET, BTLVAR_MSG_MOVE_TEMP, MOVE_BEAK_BLAST
    PlayMoveAnimationOnMons BTLSCR_MSG_TEMP, BTLSCR_MSG_TEMP, BTLSCR_MSG_TEMP
    Wait
    // {0} started heating up its beak!
    PrintGlobalMessage BattleStrings_Text_PokemonStartedHeatingUpItsBeak_Ally, TAG_NICKNAME, BTLSCR_MSG_TEMP
    Wait
    WaitButtonABTime 30
    GoTo _prime

_power_herb:
    PlayBattleAnimation BTLSCR_MSG_TEMP, BATTLE_ANIMATION_HELD_ITEM
    Wait
    // {0} became fully charged due to its {1}!
    PrintGlobalMessage BattleStrings_Text_PokemonBecameFullyChargedDueToItsItem_Ally, TAG_NICKNAME_ITEM, BTLSCR_MSG_TEMP, BTLSCR_MSG_TEMP
    Wait
    WaitButtonABTime 30
    RemoveItem BTLSCR_MSG_TEMP

_prime:
    UpdateMonData OPCODE_FLAG_ON, BTLSCR_MSG_TEMP, BATTLEMON_MOVE_EFFECTS_MASK, MOVE_EFFECT_BEAK_BLAST_PRIMED
    End
