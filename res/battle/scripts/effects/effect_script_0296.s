#include "macros/btlcmd.inc"

_000:
    CompareMonDataToValue OPCODE_FLAG_NOT, BTLSCR_ATTACKER, BATTLEMON_MOVE_EFFECTS_MASK, MOVE_EFFECT_CHARGE, _check_item
    CompareMonDataToValue OPCODE_FLAG_SET, BTLSCR_ATTACKER, BATTLEMON_VOLATILE_STATUS, VOLATILE_CONDITION_MOVE_LOCKED, _attack
    LockMoveChoice BTLSCR_ATTACKER
    UpdateVar OPCODE_FLAG_ON, BTLVAR_BATTLE_CTX_STATUS, SYSCTL_SKIP_ATTACK_MESSAGE|SYSCTL_CHECK_LOOP_ONLY_ONCE|SYSCTL_FIRST_OF_MULTI_TURN|SYSCTL_PLAYED_MOVE_ANIMATION
    End

_check_item:
    CheckItemHoldEffect CHECK_HAVE, BTLSCR_ATTACKER, HOLD_EFFECT_CHARGE_SKIP, _power_herb
    GoTo _attack

_power_herb:
    // {0} started heating up its beak!
    PrintGlobalMessage BattleStrings_Text_PokemonStartedHeatingUpItsBeak_Ally, TAG_NICKNAME, BTLSCR_ATTACKER
    Wait
    WaitButtonABTime 30
    PlayBattleAnimation BTLSCR_ATTACKER, BATTLE_ANIMATION_HELD_ITEM
    Wait
    // {0} became fully charged due to its {1}!
    PrintMessage BattleStrings_Text_PokemonBecameFullyChargedDueToItsItem_Ally, TAG_NICKNAME_ITEM, BTLSCR_ATTACKER, BTLSCR_ATTACKER
    Wait
    WaitButtonABTime 30
    RemoveItem BTLSCR_ATTACKER

_attack:
    UpdateMonData OPCODE_FLAG_OFF, BTLSCR_ATTACKER, BATTLEMON_MOVE_EFFECTS_MASK, MOVE_EFFECT_BEAK_BLAST_PRIMED
    CalcCrit
    CalcDamage
    Call BATTLE_SUBSCRIPT_CHARGE_MOVE_CLEANUP
    End
