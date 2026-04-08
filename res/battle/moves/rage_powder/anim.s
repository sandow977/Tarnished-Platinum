#include "macros/btlanimcmd.inc"

L_0:
    LoadParticleResource 0, bide_spa
    PlayLoopedSoundEffectL SEQ_SE_DP_W036, 3, 4
    CreateEmitter 0, 0, EMITTER_CB_SET_POS_TO_ATTACKER
    Func_Shake 1, 0, 1, 4, BATTLE_ANIM_BATTLER_SPRITE_ATTACKER
    Func_FadeBattlerSprite BATTLE_ANIM_ATTACKER, 0, 1, BATTLE_COLOR_RED, 10, 0
    WaitForAnimTasks
    WaitForAllEmitters
    UnloadParticleSystem 0
    End
