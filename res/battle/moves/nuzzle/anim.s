#include "macros/btlanimcmd.inc"

L_0:
    LoadParticleResource 0, thunder_wave_spa
    Func_PlayfulHops
    BeginLoop 3
    PlaySoundEffectL SEQ_SE_DP_W204
    Delay 8
    EndLoop
    PlaySoundEffectL SEQ_SE_DP_W204
    WaitForAnimTasks
    CreateEmitter 0, 0, EMITTER_CB_SET_POS_TO_DEFENDER
    CreateEmitter 0, 1, EMITTER_CB_SET_POS_TO_DEFENDER
    Delay 5
    PlaySoundEffectR SEQ_SE_DP_W085C
    Func_FadeBattlerSprite BATTLE_ANIM_DEFENDER, 0, 1, BATTLE_COLOR_LIGHT_YELLOW1, 14, 0
    Func_Shake 1, 0, 1, 2, BATTLE_ANIM_BATTLER_SPRITE_DEFENDER
    WaitForAllEmitters
    UnloadParticleSystem 0
    End
