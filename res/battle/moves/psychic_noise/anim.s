#include "macros/btlanimcmd.inc"

L_0:
    LoadParticleResource 0, metal_sound_spa
    PlayDelayedSoundEffectC SEQ_SE_DP_W103, 1
    PlayDelayedSoundEffectC SEQ_SE_DP_W103, 3
    PlayDelayedSoundEffectC SEQ_SE_DP_W103, 5
    PlayDelayedSoundEffectC SEQ_SE_DP_W103, 7
    PlayDelayedSoundEffectC SEQ_SE_DP_W103, 10
    PlayDelayedSoundEffectC SEQ_SE_DP_W103, 15
    PlayDelayedSoundEffectC SEQ_SE_DP_W103, 20
    Func_Shake 1, 0, 1, 2, BATTLE_ANIM_BATTLER_SPRITE_ATTACKER
    CreateEmitter 0, 0, EMITTER_CB_SET_POS_TO_ATTACKER
    Func_MoveEmitterA2BLinear 0, 0, 0, 0, 20, 64
    WaitForAllEmitters
    UnloadParticleSystem 0
    StopSoundEffect SEQ_SE_DP_W103
    End
