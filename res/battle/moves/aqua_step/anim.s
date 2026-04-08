#include "macros/btlanimcmd.inc"

L_0:
    LoadParticleResource 0, waterfall_spa
    LoadParticleResource 1, aqua_tail_spa
    PlaySoundEffectL SEQ_SE_DP_W152
    Func_RevolveBattler BATTLE_ANIM_ATTACKER, 3, 10
    BeginLoop 3
    CreateEmitter 0, 0, EMITTER_CB_SET_POS_TO_ATTACKER
    Delay 10
    EndLoop
    WaitForAnimTasks
    Func_MoveBattler BATTLE_ANIM_BATTLER_SPRITE_ATTACKER, 14, -8, 2
    WaitForAnimTasks
    PlaySoundEffectR SEQ_SE_DP_W291
    CreateEmitter 1, 1, EMITTER_CB_SET_POS_TO_DEFENDER
    Func_Shake 1, 0, 1, 10, BATTLE_ANIM_BATTLER_SPRITE_DEFENDER
    Func_MoveBattler BATTLE_ANIM_BATTLER_SPRITE_ATTACKER, -14, 8, 2
    WaitForAnimTasks
    WaitForAllEmitters
    UnloadParticleSystem 1
    UnloadParticleSystem 0
    End
