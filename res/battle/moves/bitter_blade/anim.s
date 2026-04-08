#include "macros/btlanimcmd.inc"

L_0:
    LoadParticleResource 0, slash_spa
    LoadParticleResource 1, fire_punch_spa
    LoadParticleResource 2, leech_life_spa
    CreateEmitter 0, 0, EMITTER_CB_SET_POS_TO_DEFENDER
    CreateEmitter 0, 2, EMITTER_CB_SET_POS_TO_DEFENDER
    CreateEmitter 0, 0, EMITTER_CB_SET_POS_TO_DEFENDER
    CreateEmitter 1, 0, EMITTER_CB_SET_POS_TO_DEFENDER
    CreateEmitter 1, 2, EMITTER_CB_SET_POS_TO_DEFENDER
    Func_Shake 4, 0, 1, 3, BATTLE_ANIM_BATTLER_SPRITE_DEFENDER
    PlaySoundEffectR SEQ_SE_DP_BASI
    PlayDelayedSoundEffectR SEQ_SE_DP_W053B, 1
    Func_FadeBattlerSprite BATTLE_ANIM_DEFENDER, 0, 1, BATTLE_COLOR_DARK_RED2, 10, 0
    WaitForAnimTasks
    PlaySoundEffectR SEQ_SE_DP_W071
    CreateEmitter 2, 1, EMITTER_CB_SET_POS_TO_DEFENDER
    CreateEmitter 2, 0, EMITTER_CB_GENERIC
    SetExtraParams 0, 2, 2, 1, 16, 0
    SetExtraParams 2, 0, 0, 0, 0
    Delay 10
    PlayMovingSoundEffectAtkDef SEQ_SE_DP_W080B, BATTLE_SOUND_PAN_RIGHT, BATTLE_SOUND_PAN_LEFT, 4, 2
    CreateEmitter 2, 2, EMITTER_CB_SET_POS_TO_ATTACKER
    Delay 75
    PlaySoundEffectL SEQ_SE_DP_W071B
    Func_FadeBattlerSprite BATTLE_ANIM_ATTACKER, 0, 1, BATTLE_COLOR_WHITE, 10, 0
    WaitForAllEmitters
    UnloadParticleSystem 2
    UnloadParticleSystem 1
    UnloadParticleSystem 0
    End
