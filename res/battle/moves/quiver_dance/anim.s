#include "macros/btlanimcmd.inc"

L_0:
    LoadParticleResource 0, lunar_dance_spa
    PlaySoundEffectL SEQ_SE_DP_W080
    CreateEmitter 0, 3, EMITTER_CB_SET_POS_TO_ATTACKER
    CreateEmitter 0, 0, EMITTER_CB_SET_POS_TO_ATTACKER
    Func_RevolveBattler BATTLE_ANIM_ATTACKER, 3, 10
    WaitForAnimTasks
    WaitForAllEmitters
    UnloadParticleSystem 0
    End
