#include "macros/btlanimcmd.inc"

L_0:
    LoadParticleResource 0, rapid_spin_spa
    PlaySoundEffectL SEQ_SE_DP_207
    CreateEmitter 0, 1, EMITTER_CB_SET_POS_TO_ATTACKER
    CreateEmitter 0, 2, EMITTER_CB_SET_POS_TO_ATTACKER
    WaitForAllEmitters
    UnloadParticleSystem 0
    End
