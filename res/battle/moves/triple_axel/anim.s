#include "macros/btlanimcmd.inc"

L_0:
    LoadParticleResource 0, triple_kick_spa
    LoadParticleResource 1, ice_punch_spa
    PlayLoopedSoundEffectR SEQ_SE_DP_W007, 2, 2
    PlayDelayedSoundEffectR SEQ_SE_DP_W280, 5
    CreateEmitter 0, 0, EMITTER_CB_SET_POS_TO_DEFENDER
    CreateEmitter 0, 1, EMITTER_CB_SET_POS_TO_DEFENDER
    CreateEmitter 1, 0, EMITTER_CB_SET_POS_TO_DEFENDER
    CreateEmitter 1, 1, EMITTER_CB_SET_POS_TO_DEFENDER
    Func_Shake 2, 0, 1, 3, BATTLE_ANIM_BATTLER_SPRITE_DEFENDER
    Func_FadeBattlerSprite BATTLE_ANIM_DEFENDER, 0, 1, BATTLE_COLOR_LIGHT_BLUE, 3, 0
    WaitForAllEmitters
    UnloadParticleSystem 1
    UnloadParticleSystem 0
    WaitForAnimTasks
    End
