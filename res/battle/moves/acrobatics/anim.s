#include "macros/btlanimcmd.inc"

L_0:
    LoadParticleResource 0, bounce_spa
    CreateEmitter 0, 1, EMITTER_CB_SET_POS_TO_ATTACKER
    CreateEmitter 0, 3, EMITTER_CB_SET_POS_TO_ATTACKER
    PlaySoundEffectL SEQ_SE_DP_W327
    Delay 8
    PlaySoundEffectL SEQ_SE_DP_W019
    Func_HideBattler BATTLE_ANIM_ATTACKER, TRUE
    WaitForAnimTasks
    CreateEmitter 0, 2, EMITTER_CB_SET_POS_TO_DEFENDER
    Delay 10
    PlaySoundEffectR SEQ_SE_DP_W029
    Delay 10
    PlaySoundEffectR SEQ_SE_DP_030
    Func_Shake 2, 0, 1, 2, BATTLE_ANIM_BATTLER_SPRITE_DEFENDER
    WaitForAllEmitters
    UnloadParticleSystem 0
    Func_HideBattler BATTLE_ANIM_ATTACKER, FALSE
    End
