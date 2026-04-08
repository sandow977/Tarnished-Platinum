#include "macros/btlanimcmd.inc"

L_0:
    LoadParticleResource 0, shadow_ball_spa
    LoadParticleResource 1, twineedle_spa
    CreateEmitter 0, 4, EMITTER_CB_NONE
    CreateEmitter 0, 0, EMITTER_CB_NONE
    CreateEmitter 0, 1, EMITTER_CB_NONE
    PlayLoopedSoundEffectC SEQ_SE_DP_W028, 2, 12
    Delay 30
    WaitForAllEmitters
    Func_MoveBattler BATTLE_ANIM_BATTLER_SPRITE_ATTACKER, 14, -8, 2
    WaitForAnimTasks
    CreateEmitter 1, 1, EMITTER_CB_GENERIC
    SetExtraParams 0, 2, 6, 1, 0, 0
    CreateEmitter 1, 0, EMITTER_CB_SET_POS_TO_DEFENDER
    CreateEmitter 0, 3, EMITTER_CB_SET_POS_TO_DEFENDER
    Func_MoveBattler BATTLE_ANIM_BATTLER_SPRITE_ATTACKER, -14, 8, 2
    Delay 5
    PlaySoundEffectR SEQ_SE_DP_161
    PlayDelayedSoundEffectR SEQ_SE_DP_480, 1
    Func_FadeBattlerSprite BATTLE_ANIM_DEFENDER, 0, 1, BATTLE_COLOR_DARK_PURPLE, 14, 0
    Func_Shake 1, 0, 1, 2, BATTLE_ANIM_BATTLER_SPRITE_DEFENDER
    PlayDelayedSoundEffectR SEQ_SE_DP_186, 3
    PlayDelayedSoundEffectR SEQ_SE_DP_186, 6
    WaitForAnimTasks
    WaitForAllEmitters
    UnloadParticleSystem 1
    UnloadParticleSystem 0
    End
