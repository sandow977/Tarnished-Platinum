#include "macros/btlanimcmd.inc"

L_0:
    LoadParticleResource 0, guard_swap_spa
    LoadParticleResource 1, teeter_dance_spa
    SetVar BATTLE_ANIM_VAR_BG_MOVE_STEP_X, 0
    SetVar BATTLE_ANIM_VAR_BG_MOVE_STEP_Y, 0
    SetVar BATTLE_ANIM_VAR_BG_ANIM_MODE, 0
    SetVar BATTLE_ANIM_VAR_BG_SCREEN_MODE, 0
    SetVar BATTLE_ANIM_VAR_BG_BLEND_TYPE, 1
    SwitchBg 57, BATTLE_BG_SWITCH_MODE_BLEND
    WaitForBgSwitch
    PlayDelayedSoundEffectC SEQ_SE_DP_W179, 1
    PlayDelayedSoundEffectC SEQ_SE_DP_W179, 15
    PlayDelayedSoundEffectC SEQ_SE_DP_W179, 30
    PlayDelayedSoundEffectC SEQ_SE_DP_W179, 45
    BeginLoop 2
    CreateEmitterEx 0, 0, 0, EMITTER_CB_SET_POS_TO_ATTACKER
    Func_MoveEmitterA2BParabolic 0, 0, 0, 0, 12, 32, EMITTER_ANIMATION_MODE_DEF_TO_ATK
    Delay 3
    CreateEmitterEx 0, 1, 0, EMITTER_CB_SET_POS_TO_ATTACKER
    Func_MoveEmitterA2BParabolic 1, 0, 0, 0, 12, 32, EMITTER_ANIMATION_MODE_DEF_TO_ATK
    Delay 3
    CreateEmitterEx 0, 4, 0, EMITTER_CB_SET_POS_TO_ATTACKER
    Func_MoveEmitterA2BParabolic 4, 0, 0, 0, 12, -32, EMITTER_ANIMATION_MODE_ATK_TO_DEF
    Delay 3
    CreateEmitterEx 0, 5, 0, EMITTER_CB_SET_POS_TO_ATTACKER
    Func_MoveEmitterA2BParabolic 5, 0, 0, 0, 12, -32, EMITTER_ANIMATION_MODE_ATK_TO_DEF
    Delay 3
    EndLoop
    PlayLoopedSoundEffectR SEQ_SE_DP_W298, 4, 4
    CreateEmitter 1, 0, EMITTER_CB_SET_POS_TO_DEFENDER
    Func_MoveBattlerX2 6, 12, BATTLE_ANIM_BATTLER_SPRITE_DEFENDER
    WaitForAnimTasks
    Func_MoveBattlerX2 6, -24, BATTLE_ANIM_BATTLER_SPRITE_DEFENDER
    WaitForAnimTasks
    Func_MoveBattlerX2 6, 12, BATTLE_ANIM_BATTLER_SPRITE_DEFENDER
    WaitForAnimTasks
    WaitForAllEmitters
    UnloadParticleSystem 1
    UnloadParticleSystem 0
    SetVar BATTLE_ANIM_VAR_BG_MOVE_STEP_X, 0
    SetVar BATTLE_ANIM_VAR_BG_MOVE_STEP_Y, 0
    SetVar BATTLE_ANIM_VAR_BG_ANIM_MODE, 0
    SetVar BATTLE_ANIM_VAR_BG_SCREEN_MODE, 0
    SetVar BATTLE_ANIM_VAR_BG_BLEND_TYPE, 2
    RestoreBg 57, BATTLE_BG_SWITCH_MODE_BLEND
    WaitForBgSwitch
    End
