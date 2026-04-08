#include "macros/btlanimcmd.inc"

L_0:
    LoadParticleResource 0, superpower_spa
    LoadParticleResource 1, aqua_tail_spa
    PlaySoundEffectL SEQ_SE_DP_W025
    InitPokemonSpriteManager
    LoadPokemonSpriteDummyResources 0
    AddPokemonSprite BATTLER_ROLE_ATTACKER, FALSE, BATTLE_ANIM_MON_SPRITE_0, 0
    Func_Superpower 0, 0
    CreateEmitter 0, 2, EMITTER_CB_SET_POS_TO_ATTACKER
    CreateEmitter 0, 3, EMITTER_CB_SET_POS_TO_ATTACKER
    WaitForAnimTasks
    Delay 30
    Delay 10
    ResetVars
    SetVar BATTLE_ANIM_VAR_BG_SCREEN_MODE, 1
    SwitchBg 23, BATTLE_BG_SWITCH_MODE_FADE
    Delay 5
    PlaySoundEffectL SEQ_SE_DP_W057
    CreateEmitter 1, 2, EMITTER_CB_SET_POS_TO_ATTACKER
    CreateEmitter 1, 0, EMITTER_CB_SET_POS_TO_ATTACKER
    PlaySoundEffectR SEQ_SE_DP_W025B
    Func_MoveBattler BATTLE_ANIM_BATTLER_SPRITE_ATTACKER, 16, -8, 2
    Delay 2
    CreateEmitter 1, 1, EMITTER_CB_SET_POS_TO_DEFENDER
    PlaySoundEffectR SEQ_SE_DP_W291
    Func_Shake 8, 0, 1, 4, BATTLE_ANIM_BATTLER_SPRITE_DEFENDER
    Func_MoveBattler BATTLE_ANIM_BATTLER_SPRITE_ATTACKER, -16, 8, 2
    WaitForAnimTasks
    WaitForAllEmitters
    UnloadParticleSystem 1
    UnloadParticleSystem 0
    ResetVars
    SetVar BATTLE_ANIM_VAR_BG_SCREEN_MODE, 1
    RestoreBg 23, BATTLE_BG_SWITCH_MODE_FADE
    WaitForBgSwitch
    FreePokemonSpriteManager
    RemovePokemonSprite BATTLE_ANIM_MON_SPRITE_0
    RemovePokemonSprite BATTLE_ANIM_MON_SPRITE_1
    End
