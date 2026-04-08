#include "macros/btlanimcmd.inc"

L_0:
    LoadParticleResource 0, wrap_spa
    BeginLoop 2
    PlayLoopedSoundEffectR SEQ_SE_DP_W020B, 4, 2
    CreateEmitter 0, 0, EMITTER_CB_SET_POS_TO_ATTACKER
    Func_RevolveBattler BATTLE_ANIM_ATTACKER, 1, 12
    WaitForAnimTasks
    EndLoop
    WaitForAllEmitters
    UnloadParticleSystem 0
    End
