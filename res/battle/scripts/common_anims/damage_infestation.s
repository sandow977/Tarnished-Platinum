#include "macros/btlanimcmd.inc"

.data

L_0:
    LoadParticleResource 0, attack_order_spa
    CreateEmitter 0, 2, EMITTER_CB_SET_POS_TO_ATTACKER
    CreateEmitter 0, 3, EMITTER_CB_SET_POS_TO_ATTACKER
    CreateEmitter 0, 0, EMITTER_CB_SET_POS_TO_ATTACKER
    CreateEmitter 0, 1, EMITTER_CB_SET_POS_TO_ATTACKER
    PlaySoundEffectL SEQ_SE_DP_W109
    PlayDelayedSoundEffectL SEQ_SE_DP_W025B, 20
    PlayDelayedSoundEffectL SEQ_SE_DP_W025B, 24
    Func_Shake 2, 0, 1, 12, BATTLE_ANIM_BATTLER_SPRITE_ATTACKER
    WaitForAllEmitters
    UnloadParticleSystem 0
    End
