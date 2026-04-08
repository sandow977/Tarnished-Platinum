#include "macros/btlanimcmd.inc"

L_0:
    LoadParticleResource 0, solar_beam_spa
    LoadParticleResource 1, leaf_blade_spa
    BtlAnimCmd_013 L_1, L_2
    End

L_1:
    Func_FadeBg FADE_BG_TYPE_BASE, 1, 0, 12, BATTLE_COLOR_BLACK
    WaitForAnimTasks
    CreateEmitter 0, 19, EMITTER_CB_SET_POS_TO_ATTACKER
    Delay 10
    PlaySoundEffectL SEQ_SE_DP_SHUSHU
    Delay 20
    Func_FadeBattlerSprite BATTLE_ANIM_ATTACKER, 0, 2, BATTLE_COLOR_LIGHT_YELLOW1, 10, 0
    WaitForAllEmitters
    WaitForAnimTasks
    Func_FadeBg FADE_BG_TYPE_BASE, 1, 12, 0, BATTLE_COLOR_BLACK
    WaitForAnimTasks
    End

L_2:
    Func_FadeBg FADE_BG_TYPE_BASE, 1, 0, 12, BATTLE_COLOR_BLACK
    WaitForAnimTasks
    CreateEmitter 0, 0, EMITTER_CB_SET_POS_TO_ATTACKER
    CreateEmitter 0, 8, EMITTER_CB_SET_POS_TO_ATTACKER
    CreateEmitter 0, 9, EMITTER_CB_SET_POS_TO_ATTACKER
    Delay 10
    PlayMovingSoundEffectAtkDef SEQ_SE_DP_W076B, BATTLE_SOUND_PAN_LEFT, BATTLE_SOUND_PAN_RIGHT, 4, 2
    CreateEmitter 1, 2, EMITTER_CB_SET_POS_TO_DEFENDER
    CreateEmitter 1, 3, EMITTER_CB_SET_POS_TO_DEFENDER
    CreateEmitter 1, 4, EMITTER_CB_SET_POS_TO_DEFENDER
    CreateEmitter 1, 1, EMITTER_CB_SET_POS_TO_DEFENDER
    CreateEmitter 1, 0, EMITTER_CB_SET_POS_TO_DEFENDER
    Delay 5
    Func_FadeBattlerSprite BATTLE_ANIM_DEFENDER, 0, 2, BATTLE_COLOR_LIGHT_YELLOW1, 14, 0
    Func_Shake 4, 0, 1, 10, BATTLE_ANIM_BATTLER_SPRITE_DEFENDER
    WaitForAllEmitters
    UnloadParticleSystem 1
    UnloadParticleSystem 0
    Func_FadeBg FADE_BG_TYPE_BASE, 1, 12, 0, BATTLE_COLOR_BLACK
    WaitForAnimTasks
    End
