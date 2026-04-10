#include "macros/btlcmd.inc"


_000:
    PlayBattleAnimation BTLSCR_MSG_TEMP, BATTLE_ANIMATION_HELD_ITEM
    Wait
    PrintMessage BattleStrings_Text_PokemonCuredItsStatusUsingItsMentalHerb, TAG_NICKNAME_ITEM, BTLSCR_MSG_TEMP, BTLSCR_MSG_TEMP
    Wait
    WaitButtonABTime 30
    Call BATTLE_SUBSCRIPT_PLUCK_CHECK
    End
