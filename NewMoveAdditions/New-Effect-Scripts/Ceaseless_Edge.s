#include "macros/btlcmd.inc"


_000:
    TrySpikes _010
    // Spikes were scattered all around your team’s feet!
    BufferMessage BattleStrings_Text_SpikesWereScatteredAllAroundYourTeamsFeet, TAG_NONE_SIDE_CONSCIOUS, BTLSCR_ATTACKER_ENEMY
    UpdateVar OPCODE_SET, BTLVAR_SIDE_EFFECT_FLAGS_INDIRECT, MOVE_SIDE_EFFECT_ON_HIT|MOVE_SUBSCRIPT_PTR_PRINT_MESSAGE_AND_PLAY_ANIMATION
    End

_010:
    CalcCrit
    CalcDamage
    End 
