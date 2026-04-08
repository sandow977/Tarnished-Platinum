#include "macros/btlcmd.inc"

_000:
    TryShedTail _036
    TryReplaceFaintedMon BTLSCR_ATTACKER, TRUE, _036
    Call BATTLE_SUBSCRIPT_ATTACK_MESSAGE_AND_ANIMATION
    PlayBattleAnimation BTLSCR_ATTACKER, BATTLE_ANIMATION_SUBSTITUTE_IN
    Wait
    UpdateMonData OPCODE_FLAG_ON, BTLSCR_ATTACKER, BATTLEMON_VOLATILE_STATUS, VOLATILE_CONDITION_SUBSTITUTE
    UpdateVar OPCODE_FLAG_ON, BTLVAR_BATTLE_CTX_STATUS, SYSCTL_SKIP_SPRITE_BLINK
    UpdateVarFromVar OPCODE_SET, BTLVAR_MSG_BATTLER_TEMP, BTLVAR_ATTACKER
    Call BATTLE_SUBSCRIPT_UPDATE_HP
    // {0} shed its tail to create a decoy!
    PrintGlobalMessage BattleStrings_Text_PokemonShedItsTailToCreateADecoy_Ally, TAG_NICKNAME, BTLSCR_ATTACKER
    Wait
    WaitButtonABTime 30
    TryRestoreStatusOnSwitch BTLSCR_ATTACKER, _023
    UpdateMonData OPCODE_SET, BTLSCR_ATTACKER, BATTLEMON_STATUS, MON_CONDITION_NONE

_023:
    DeletePokemon BTLSCR_ATTACKER
    Wait
    HealthbarSlideOut BTLSCR_ATTACKER
    Wait
    UpdateVarFromVar OPCODE_SET, BTLVAR_SWITCHED_MON, BTLVAR_ATTACKER
    UpdateVar OPCODE_FLAG_ON, BTLVAR_BATTLE_CTX_STATUS, SYSCTL_BATON_PASS
    IfSameSide BTLSCR_ATTACKER, BTLSCR_PLAYER, _player_switch
    SwitchAndUpdateMon BTLSCR_SWITCHED_MON
    Wait
    PrintSendOutMessage BTLSCR_SWITCHED_MON
    Wait
    PokemonSendOut BTLSCR_SWITCHED_MON
    WaitTime 72
    HealthbarSlideIn BTLSCR_SWITCHED_MON
    Wait
    Call BATTLE_SUBSCRIPT_HAZARDS_CHECK
    End

_player_switch:
    GoToSubscript BATTLE_SUBSCRIPT_SHOW_PARTY_LIST

_036:
    PrintAttackMessage
    Wait
    CompareMonDataToValue OPCODE_FLAG_SET, BTLSCR_ATTACKER, BATTLEMON_VOLATILE_STATUS, VOLATILE_CONDITION_SUBSTITUTE, _051
    TryReplaceFaintedMon BTLSCR_ATTACKER, TRUE, _058
    // It was too weak to make a substitute!
    PrintMessage BattleStrings_Text_ItWasTooWeakToMakeASubstitute, TAG_NONE
    GoTo _056

_051:
    // {0} already has a substitute!
    PrintGlobalMessage BattleStrings_Text_PokemonAlreadyHasASubstitute_Ally, TAG_NICKNAME, BTLSCR_ATTACKER

_056:
    Wait
    WaitButtonABTime 30
    UpdateVar OPCODE_FLAG_ON, BTLVAR_MOVE_STATUS_FLAGS, MOVE_STATUS_NO_MORE_WORK
    End

_058:
    UpdateVar OPCODE_FLAG_ON, BTLVAR_MOVE_STATUS_FLAGS, MOVE_STATUS_FAILED
    End
