#include "macros/btlanimcmd.inc"

L_0:
    LoadParticleResource 0, solar_beam_spa
    LoadParticleResource 1, hyper_beam_spa
    BtlAnimCmd_013 L_1, L_2
    End

L_1:
    Func_FadeBg FADE_BG_TYPE_BASE, 1, 0, 12, BATTLE_COLOR_BLACK
    WaitForAnimTasks
    CreateEmitter 0, 19, EMITTER_CB_SET_POS_TO_ATTACKER
    Delay 10
    PlaySoundEffectL SEQ_SE_DP_SHUSHU
    Delay 20
    Func_FadeBattlerSprite BATTLE_ANIM_ATTACKER, 0, 2, BATTLE_COLOR_LIGHT_YELLOW1, 10, 0
    WaitForAllEmitters
    UnloadParticleSystem 0
    WaitForAnimTasks
    Func_FadeBg FADE_BG_TYPE_BASE, 1, 12, 0, BATTLE_COLOR_BLACK
    WaitForAnimTasks
    End

L_2:
    SetVar BATTLE_ANIM_VAR_BG_FADE_TYPE, 0
    SetVar BATTLE_ANIM_VAR_BG_MOVE_STEP_X, 0
    SetVar BATTLE_ANIM_VAR_BG_MOVE_STEP_Y, 1
    SwitchBg 56, BATTLE_BG_SWITCH_MODE_FADE | BATTLE_BG_SWITCH_FLAG_MOVE
    WaitForBgSwitch
    Func_ShakeBg 0, 3, 0, 20, 0
    CreateEmitter 1, 9, EMITTER_CB_SET_POS_TO_ATTACKER
    CreateEmitterForMove 1, 0, 1, 2, 3, 4, 5, 18
    CreateEmitterForMove 1, 10, 10, 10, 11, 11, 11, 18
    Delay 5
    PlayMovingSoundEffectAtkDef SEQ_SE_DP_W062D, BATTLE_SOUND_PAN_LEFT, BATTLE_SOUND_PAN_RIGHT, 4, 2
    Func_Shake 4, 0, 1, 20, BATTLE_ANIM_BATTLER_SPRITE_DEFENDER
    Func_FadeBattlerSprite BATTLE_ANIM_DEFENDER, 0, 1, BATTLE_COLOR_RED, 12, 0
    WaitForAllEmitters
    UnloadParticleSystem 0
    UnloadParticleSystem 1
    ResetVars
    SetVar BATTLE_ANIM_VAR_BG_FADE_TYPE, 0
    SetVar BATTLE_ANIM_VAR_BG_MOVE_STEP_X, 0
    SetVar BATTLE_ANIM_VAR_BG_MOVE_STEP_Y, 1
    RestoreBg 56, BATTLE_BG_SWITCH_MODE_FADE | BATTLE_BG_SWITCH_FLAG_STOP
    WaitForBgSwitch
    End
