#include "macros/scrcmd.inc"
#include "res/text/bank/twinleaf_town.h"
#include "res/field/events/events_twinleaf_town.h"


    ScriptEntry TwinleafTown_OnTransition
    ScriptEntry TwinleafTown_RivalThudTrigger
    ScriptEntry TwinleafTown_Guitarist
    ScriptEntry TwinleafTown_RivalWasLookingForYouTrigger
    ScriptEntry TwinleafTown_Collector
    ScriptEntry TwinleafTown_BreederF
    ScriptEntry TwinleafTown_MapSign
    ScriptEntry TwinleafTown_LandmarkSignPlayerMailbox
    ScriptEntry TwinleafTown_LandmarkSignRivalMailbox
    ScriptEntryEnd

TwinleafTown_OnTransition:
    CallIfEq VAR_UNK_0x40F4, 1, _004F
    CallIfEq VAR_PLAYER_HOUSE_STATE, 4, TwinleafTown_SetPlayerHouseState5
    CallIfEq VAR_PLAYER_HOUSE_STATE, 6, TwinleafTown_SetPlayerHouseState7
    End

_004F:
    SetVar VAR_UNK_0x40F4, 2
    Return

TwinleafTown_SetPlayerHouseState7:
    SetVar VAR_PLAYER_HOUSE_STATE, 7
    Return

TwinleafTown_SetPlayerHouseState5:
    SetVar VAR_PLAYER_HOUSE_STATE, 5
    Return

TwinleafTown_Guitarist:
    LockAll
    FacePlayer
    PlayFanfare SEQ_SE_CONFIRM
    MakePartyMonShiny 0, VAR_RESULT
    GivePokedex
    AddItem ITEM_ABILITY_CAPSULE, 999, VAR_RESULT
    AddItem ITEM_IRON_BALL, 999, VAR_RESULT
    AddItem ITEM_LIFE_ORB, 999, VAR_RESULT
    AddItem ITEM_LIGHT_BALL, 999, VAR_RESULT
    AddItem ITEM_METRONOME, 999, VAR_RESULT
    AddItem ITEM_FIGY_BERRY, 999, VAR_RESULT
    FillSinnohDexCaught
    GoTo _TwinleafTown_Guitarist_AfterDexFill
    SetSpeciesSeen SPECIES_SQUIRTLE
    SetSpeciesSeen SPECIES_WARTORTLE
    SetSpeciesSeen SPECIES_BLASTOISE
    SetSpeciesSeen SPECIES_CATERPIE
    SetSpeciesSeen SPECIES_METAPOD
    SetSpeciesSeen SPECIES_BUTTERFREE
    SetSpeciesSeen SPECIES_WEEDLE
    SetSpeciesSeen SPECIES_KAKUNA
    SetSpeciesSeen SPECIES_BEEDRILL
    SetSpeciesSeen SPECIES_PIDGEY
    SetSpeciesSeen SPECIES_PIDGEOTTO
    SetSpeciesSeen SPECIES_PIDGEOT
    SetSpeciesSeen SPECIES_SPEAROW
    SetSpeciesSeen SPECIES_FEAROW
    SetSpeciesSeen SPECIES_EKANS
    SetSpeciesSeen SPECIES_ARBOK
    SetSpeciesSeen SPECIES_PICHU
    SetSpeciesSeen SPECIES_PIKACHU
    SetSpeciesSeen SPECIES_RAICHU
    SetSpeciesSeen SPECIES_RAICHU_ALOLAN
    SetSpeciesSeen SPECIES_PIKACHU_BELLE
    SetSpeciesSeen SPECIES_PIKACHU_LIBRE
    SetSpeciesSeen SPECIES_PIKACHU_POP_STAR
    SetSpeciesSeen SPECIES_PIKACHU_ROCK_STAR
    SetSpeciesSeen SPECIES_SANDSHREW
    SetSpeciesSeen SPECIES_SANDSLASH
    SetSpeciesSeen SPECIES_NIDORAN_F
    SetSpeciesSeen SPECIES_NIDORINA
    SetSpeciesSeen SPECIES_NIDOQUEEN
    SetSpeciesSeen SPECIES_NIDORAN_M
    SetSpeciesSeen SPECIES_NIDORINO
    SetSpeciesSeen SPECIES_NIDOKING
    SetSpeciesSeen SPECIES_CLEFFA
    SetSpeciesSeen SPECIES_CLEFAIRY
    SetSpeciesSeen SPECIES_CLEFABLE
    SetSpeciesSeen SPECIES_VULPIX
    SetSpeciesSeen SPECIES_NINETALES
    SetSpeciesSeen SPECIES_SHELLDER
    SetSpeciesSeen SPECIES_CLOYSTER
    SetSpeciesSeen SPECIES_IGGLYBUFF
    SetSpeciesSeen SPECIES_JIGGLYPUFF
    SetSpeciesSeen SPECIES_WIGGLYTUFF
    SetSpeciesSeen SPECIES_ODDISH
    SetSpeciesSeen SPECIES_GLOOM
    SetSpeciesSeen SPECIES_VILEPLUME
    SetSpeciesSeen SPECIES_BELLOSSOM
    SetSpeciesSeen SPECIES_PARAS
    SetSpeciesSeen SPECIES_PARASECT
    SetSpeciesSeen SPECIES_VENONAT
    SetSpeciesSeen SPECIES_VENOMOTH
    SetSpeciesSeen SPECIES_DIGLETT
    SetSpeciesSeen SPECIES_DUGTRIO
    SetSpeciesSeen SPECIES_MEOWTH
    SetSpeciesSeen SPECIES_PERSIAN
    SetSpeciesSeen SPECIES_PSYDUCK
    SetSpeciesSeen SPECIES_MANKEY
    SetSpeciesSeen SPECIES_PRIMEAPE
    SetSpeciesSeen SPECIES_MACHOP
    SetSpeciesSeen SPECIES_MACHOKE
    SetSpeciesSeen SPECIES_MACHAMP
    SetSpeciesSeen SPECIES_TENTACOOL
    SetSpeciesSeen SPECIES_TENTACRUEL
    SetSpeciesSeen SPECIES_BELLSPROUT
    SetSpeciesSeen SPECIES_WEEPINBELL
    SetSpeciesSeen SPECIES_VICTREEBEL
    SetSpeciesSeen SPECIES_GEODUDE
    SetSpeciesSeen SPECIES_GRAVELER
    SetSpeciesSeen SPECIES_GOLEM
    SetSpeciesSeen SPECIES_PONYTA
    SetSpeciesSeen SPECIES_RAPIDASH
    SetSpeciesSeen SPECIES_SLOWPOKE
    SetSpeciesSeen SPECIES_SLOWKING
    SetSpeciesSeen SPECIES_MAGNEMITE
    SetSpeciesSeen SPECIES_MAGNETON
    SetSpeciesSeen SPECIES_MAGNEZONE
    SetSpeciesSeen SPECIES_DODUO
    SetSpeciesSeen SPECIES_DODRIO
    SetSpeciesSeen SPECIES_SEEL
    SetSpeciesSeen SPECIES_DEWGONG
    SetSpeciesSeen SPECIES_HORSEA
    SetSpeciesSeen SPECIES_SEADRA
    SetSpeciesSeen SPECIES_KINGDRA
    SetSpeciesSeen SPECIES_DROWZEE
    SetSpeciesSeen SPECIES_HYPNO
    SetSpeciesSeen SPECIES_KRABBY
    SetSpeciesSeen SPECIES_KINGLER
    SetSpeciesSeen SPECIES_VOLTORB
    SetSpeciesSeen SPECIES_ELECTRODE
    SetSpeciesSeen SPECIES_EXEGGCUTE
    SetSpeciesSeen SPECIES_EXEGGUTOR
    SetSpeciesSeen SPECIES_CUBONE
    SetSpeciesSeen SPECIES_MAROWAK
    SetSpeciesSeen SPECIES_TYROGUE
    SetSpeciesSeen SPECIES_HITMONLEE
    SetSpeciesSeen SPECIES_HITMONCHAN
    SetSpeciesSeen SPECIES_HITMONTOP
    SetSpeciesSeen SPECIES_LICKITUNG
    SetSpeciesSeen SPECIES_LICKILICKY
    SetSpeciesSeen SPECIES_KOFFING
    SetSpeciesSeen SPECIES_WEEZING
    SetSpeciesSeen SPECIES_KANGASKHAN
    SetSpeciesSeen SPECIES_GOLDEEN
    SetSpeciesSeen SPECIES_SEAKING
    SetSpeciesSeen SPECIES_MIME_JR
    SetSpeciesSeen SPECIES_MR_MIME
    SetSpeciesSeen SPECIES_SMOOCHUM
    SetSpeciesSeen SPECIES_JYNX
    SetSpeciesSeen SPECIES_MAGBY
    SetSpeciesSeen SPECIES_MAGMAR
    SetSpeciesSeen SPECIES_MAGMORTAR
    SetSpeciesSeen SPECIES_PINSIR
    SetSpeciesSeen SPECIES_TAUROS
    SetSpeciesSeen SPECIES_SCYTHER
    SetSpeciesSeen SPECIES_SCIZOR
    SetSpeciesSeen SPECIES_EEVEE
    SetSpeciesSeen SPECIES_FLAREON
    SetSpeciesSeen SPECIES_LEAFEON
    SetSpeciesSeen SPECIES_UMBREON
    SetSpeciesSeen SPECIES_KABUTO
    SetSpeciesSeen SPECIES_KABUTOPS
    SetSpeciesSeen SPECIES_CHIKORITA
    SetSpeciesSeen SPECIES_BAYLEEF
    SetSpeciesSeen SPECIES_MEGANIUM
    SetSpeciesSeen SPECIES_HOOTHOOT
    SetSpeciesSeen SPECIES_NOCTOWL
    SetSpeciesSeen SPECIES_LEDYBA
    SetSpeciesSeen SPECIES_LEDIAN
    SetSpeciesSeen SPECIES_SPINARAK
    SetSpeciesSeen SPECIES_ARIADOS
    SetSpeciesSeen SPECIES_CHINCHOU
    SetSpeciesSeen SPECIES_LANTURN
    SetSpeciesSeen SPECIES_NATU
    SetSpeciesSeen SPECIES_XATU
    SetSpeciesSeen SPECIES_MAREEP
    SetSpeciesSeen SPECIES_FLAAFFY
    SetSpeciesSeen SPECIES_AMPHAROS
    SetSpeciesSeen SPECIES_MARILL
    SetSpeciesSeen SPECIES_AZUMARILL
    SetSpeciesSeen SPECIES_BONSLY
    SetSpeciesSeen SPECIES_SUDOWOODO
    SetSpeciesSeen SPECIES_HOPPIP
    SetSpeciesSeen SPECIES_SKIPLOOM
    SetSpeciesSeen SPECIES_JUMPLUFF
    SetSpeciesSeen SPECIES_AIPOM
    SetSpeciesSeen SPECIES_AMBIPOM
    SetSpeciesSeen SPECIES_DUNSPARCE
    SetSpeciesSeen SPECIES_MURKROW
    SetSpeciesSeen SPECIES_HONCHKROW
    SetSpeciesSeen SPECIES_GIRAFARIG
    SetSpeciesSeen SPECIES_PINECO
    SetSpeciesSeen SPECIES_FORRETRESS
    SetSpeciesSeen SPECIES_SNUBBULL
    SetSpeciesSeen SPECIES_GRANBULL
    SetSpeciesSeen SPECIES_TEDDIURSA
    SetSpeciesSeen SPECIES_URSARING
    SetSpeciesSeen SPECIES_SLUGMA
    SetSpeciesSeen SPECIES_MAGCARGO
    SetSpeciesSeen SPECIES_CORSOLA
    SetSpeciesSeen SPECIES_REMORAID
    SetSpeciesSeen SPECIES_OCTILLERY
    SetSpeciesSeen SPECIES_DELIBIRD
    SetSpeciesSeen SPECIES_HOUNDOUR
    SetSpeciesSeen SPECIES_HOUNDOOM
    SetSpeciesSeen SPECIES_PHANPY
    SetSpeciesSeen SPECIES_DONPHAN
    SetSpeciesSeen SPECIES_STANTLER
    SetSpeciesSeen SPECIES_POOCHYENA
    SetSpeciesSeen SPECIES_MIGHTYENA
    SetSpeciesSeen SPECIES_WURMPLE
    SetSpeciesSeen SPECIES_SILCOON
    SetSpeciesSeen SPECIES_BEAUTIFLY
    SetSpeciesSeen SPECIES_CASCOON
    SetSpeciesSeen SPECIES_DUSTOX
    SetSpeciesSeen SPECIES_LOTAD
    SetSpeciesSeen SPECIES_LOMBRE
    SetSpeciesSeen SPECIES_LUDICOLO
    SetSpeciesSeen SPECIES_SEEDOT
    SetSpeciesSeen SPECIES_NUZLEAF
    SetSpeciesSeen SPECIES_SHIFTRY
    SetSpeciesSeen SPECIES_WINGULL
    SetSpeciesSeen SPECIES_PELIPPER
    SetSpeciesSeen SPECIES_RALTS
    SetSpeciesSeen SPECIES_KIRLIA
    SetSpeciesSeen SPECIES_GALLADE
    SetSpeciesSeen SPECIES_SURSKIT
    SetSpeciesSeen SPECIES_MASQUERAIN
    SetSpeciesSeen SPECIES_NINCADA
    SetSpeciesSeen SPECIES_NINJASK
    SetSpeciesSeen SPECIES_WHISMUR
    SetSpeciesSeen SPECIES_LOUDRED
    SetSpeciesSeen SPECIES_EXPLOUD
    SetSpeciesSeen SPECIES_MAKUHITA
    SetSpeciesSeen SPECIES_HARIYAMA
    SetSpeciesSeen SPECIES_SKITTY
    SetSpeciesSeen SPECIES_DELCATTY
    SetSpeciesSeen SPECIES_MEDITITE
    SetSpeciesSeen SPECIES_MEDICHAM
    SetSpeciesSeen SPECIES_ELECTRIKE
    SetSpeciesSeen SPECIES_MANECTRIC
    SetSpeciesSeen SPECIES_PLUSLE
    SetSpeciesSeen SPECIES_MINUN
    SetSpeciesSeen SPECIES_ILLUMISE
    SetSpeciesSeen SPECIES_BUDEW
    SetSpeciesSeen SPECIES_ROSELIA
    SetSpeciesSeen SPECIES_ROSERADE
    SetSpeciesSeen SPECIES_GULPIN
    SetSpeciesSeen SPECIES_SWALOT
    SetSpeciesSeen SPECIES_CARVANHA
    SetSpeciesSeen SPECIES_SHARPEDO
    SetSpeciesSeen SPECIES_WAILMER
    SetSpeciesSeen SPECIES_WAILORD
    SetSpeciesSeen SPECIES_NUMEL
    SetSpeciesSeen SPECIES_CAMERUPT
    SetSpeciesSeen SPECIES_SPOINK
    SetSpeciesSeen SPECIES_GRUMPIG
    SetSpeciesSeen SPECIES_CACNEA
    SetSpeciesSeen SPECIES_CACTURNE
    SetSpeciesSeen SPECIES_SEVIPER
    SetSpeciesSeen SPECIES_ZANGOOSE
    SetSpeciesSeen SPECIES_LUNATONE
    SetSpeciesSeen SPECIES_SOLROCK
    SetSpeciesSeen SPECIES_BARBOACH
    SetSpeciesSeen SPECIES_WHISCASH
    SetSpeciesSeen SPECIES_SWABLU
    SetSpeciesSeen SPECIES_ALTARIA
    SetSpeciesSeen SPECIES_BALTOY
    SetSpeciesSeen SPECIES_CLAYDOL
    SetSpeciesSeen SPECIES_LILEEP
    SetSpeciesSeen SPECIES_CRADILY
    SetSpeciesSeen SPECIES_ANORITH
    SetSpeciesSeen SPECIES_ARMALDO
    SetSpeciesSeen SPECIES_CASTFORM
    SetSpeciesSeen SPECIES_KECLEON
    SetSpeciesSeen SPECIES_SHUPPET
    SetSpeciesSeen SPECIES_BANETTE
    SetSpeciesSeen SPECIES_DUSKULL
    SetSpeciesSeen SPECIES_DUSCLOPS
    SetSpeciesSeen SPECIES_DUSKNOIR
    SetSpeciesSeen SPECIES_TROPIUS
    SetSpeciesSeen SPECIES_CHINGLING
    SetSpeciesSeen SPECIES_CHIMECHO
    SetSpeciesSeen SPECIES_ABSOL
    SetSpeciesSeen SPECIES_WYNAUT
    SetSpeciesSeen SPECIES_WOBBUFFET
    SetSpeciesSeen SPECIES_SNORUNT
    SetSpeciesSeen SPECIES_GLALIE
    SetSpeciesSeen SPECIES_FROSLASS
    SetSpeciesSeen SPECIES_SPHEAL
    SetSpeciesSeen SPECIES_SEALEO
    SetSpeciesSeen SPECIES_WALREIN
    SetSpeciesSeen SPECIES_RELICANTH
    SetSpeciesSeen SPECIES_CLAMPERL
    SetSpeciesSeen SPECIES_HUNTAIL
    SetSpeciesSeen SPECIES_GOREBYSS
    SetSpeciesSeen SPECIES_PIPLUP
    SetSpeciesSeen SPECIES_PRINPLUP
    SetSpeciesSeen SPECIES_EMPOLEON
    SetSpeciesSeen SPECIES_KRICKETOT
    SetSpeciesSeen SPECIES_KRICKETUNE
    SetSpeciesSeen SPECIES_BIDOOF
    SetSpeciesSeen SPECIES_BIBAREL
    SetSpeciesSeen SPECIES_SHINX
    SetSpeciesSeen SPECIES_LUXIO
    SetSpeciesSeen SPECIES_LUXRAY
    SetSpeciesSeen SPECIES_CRANIDOS
    SetSpeciesSeen SPECIES_RAMPARDOS
    SetSpeciesSeen SPECIES_BURMY
    SetSpeciesSeen SPECIES_WORMADAM
    SetSpeciesSeen SPECIES_MOTHIM
    SetSpeciesSeen SPECIES_COMBEE
    SetSpeciesSeen SPECIES_VESPIQUEN
    SetSpeciesSeen SPECIES_PACHIRISU
    SetSpeciesSeen SPECIES_BUIZEL
    SetSpeciesSeen SPECIES_FLOATZEL
    SetSpeciesSeen SPECIES_CHERUBI
    SetSpeciesSeen SPECIES_CHERRIM
    SetSpeciesSeen SPECIES_GLAMEOW
    SetSpeciesSeen SPECIES_PURUGLY
    SetSpeciesSeen SPECIES_STUNKY
    SetSpeciesSeen SPECIES_SKUNTANK
    SetSpeciesSeen SPECIES_CHATOT
    SetSpeciesSeen SPECIES_CROAGUNK
    SetSpeciesSeen SPECIES_TOXICROAK
    SetSpeciesSeen SPECIES_YANMEGA
    SetSpeciesSeen SPECIES_CARNIVINE
    SetSpeciesSeen SPECIES_FINNEON
    SetSpeciesSeen SPECIES_LUMINEON
    SetSpeciesSeen SPECIES_SNOVER
    SetSpeciesSeen SPECIES_ABOMASNOW
    SetSpeciesSeen SPECIES_DRIFLOON
    SetSpeciesSeen SPECIES_DRIFBLIM
    SetSpeciesSeen SPECIES_CRESSELIA
    SetSpeciesSeen SPECIES_SEWADDLE
    SetSpeciesSeen SPECIES_SWADLOON
    SetSpeciesSeen SPECIES_LEAVANNY
    SetSpeciesSeen SPECIES_DUCKLETT
    SetSpeciesSeen SPECIES_SWANNA
    SetSpeciesSeen SPECIES_SOLOSIS
    SetSpeciesSeen SPECIES_DUOSION
    SetSpeciesSeen SPECIES_REUNICLUS
    SetSpeciesSeen SPECIES_SNIVY
    SetSpeciesSeen SPECIES_SERVINE
    SetSpeciesSeen SPECIES_SERPERIOR
    SetSpeciesSeen SPECIES_TEPIG
    SetSpeciesSeen SPECIES_PIGNITE
    SetSpeciesSeen SPECIES_EMBOAR
    SetSpeciesSeen SPECIES_OSHAWOTT
    SetSpeciesSeen SPECIES_DEWOTT
    SetSpeciesSeen SPECIES_SAMUROTT
    SetSpeciesSeen SPECIES_CUBCHOO
    SetSpeciesSeen SPECIES_BEARTIC
    SetSpeciesSeen SPECIES_EMOLGA
    SetSpeciesSeen SPECIES_DEERLING
    SetSpeciesSeen SPECIES_SAWSBUCK
    SetSpeciesSeen SPECIES_SAWSBUCK_WINTER
    SetSpeciesSeen SPECIES_PURRLOIN
    SetSpeciesSeen SPECIES_LIEPARD
    SetSpeciesSeen SPECIES_STUNFISK
    SetSpeciesSeen SPECIES_DRUDDIGON
    SetSpeciesSeen SPECIES_HEATMOR
    SetSpeciesSeen SPECIES_BISHARP
    SetSpeciesSeen SPECIES_GRENINJA
    SetSpeciesSeen SPECIES_AMAURA
    SetSpeciesSeen SPECIES_AURORUS
    SetSpeciesSeen SPECIES_LITLEO
    SetSpeciesSeen SPECIES_NOIBAT
    SetSpeciesSeen SPECIES_NOIVERN
    SetSpeciesSeen SPECIES_PANCHAM
    SetSpeciesSeen SPECIES_PANGORO
    SetSpeciesSeen SPECIES_BUNNELBY
    SetSpeciesSeen SPECIES_DIGGERSBY
    SetSpeciesSeen SPECIES_SKRELP
    SetSpeciesSeen SPECIES_DRAGALGE
    SetSpeciesSeen SPECIES_ROWLET
    SetSpeciesSeen SPECIES_DARTRIX
    SetSpeciesSeen SPECIES_DECIDUEYE
    SetSpeciesSeen SPECIES_ROCKRUFF
    SetSpeciesSeen SPECIES_LYCANROC
    SetSpeciesSeen SPECIES_PHANTUMP
    SetSpeciesSeen SPECIES_TREVENANT
    SetSpeciesSeen SPECIES_MEOWTH_GALARIAN
    SetSpeciesSeen SPECIES_PERSIAN_ALOLAN
    SetSpeciesSeen SPECIES_CUTIEFLY
    SetSpeciesSeen SPECIES_RIBOMBEE
    SetSpeciesSeen SPECIES_MORELULL
    SetSpeciesSeen SPECIES_SHIINOTIC
    SetSpeciesSeen SPECIES_BOUNSWEET
    SetSpeciesSeen SPECIES_STEENEE
    SetSpeciesSeen SPECIES_TSAREENA
    SetSpeciesSeen SPECIES_PIKIPEK
    SetSpeciesSeen SPECIES_TRUMBEAK
    SetSpeciesSeen SPECIES_TOUCANNON
    SetSpeciesSeen SPECIES_VULPIX_ALOLAN
    SetSpeciesSeen SPECIES_NINETALES_ALOLAN
    SetSpeciesSeen SPECIES_GEODUDE_ALOLAN
    SetSpeciesSeen SPECIES_GRAVELER_ALOLAN
    SetSpeciesSeen SPECIES_GOLEM_ALOLAN
    SetSpeciesSeen SPECIES_MUK_ALOLAN
    SetSpeciesSeen SPECIES_SANDSHREW_ALOLAN
    SetSpeciesSeen SPECIES_SANDSLASH_ALOLAN
    SetSpeciesSeen SPECIES_HATENNA
    SetSpeciesSeen SPECIES_HATTREM
    SetSpeciesSeen SPECIES_HATTERENE
    SetSpeciesSeen SPECIES_YAMPER
    SetSpeciesSeen SPECIES_BOLTUND
    SetSpeciesSeen SPECIES_GRAPPLOCT
    SetSpeciesSeen SPECIES_CARKOL
    SetSpeciesSeen SPECIES_COALOSSAL
    SetSpeciesSeen SPECIES_ZIGZAGOON_GALARIAN
    SetSpeciesSeen SPECIES_LINOONE_GALARIAN
    SetSpeciesSeen SPECIES_OBSTAGOON
    SetSpeciesSeen SPECIES_PONYTA_GALARIAN
    SetSpeciesSeen SPECIES_RAPIDASH_GALARIAN
    SetSpeciesSeen SPECIES_MEOWTH_ALOLAN
    SetSpeciesSeen SPECIES_PERRSERKER
    SetSpeciesSeen SPECIES_BLIPBUG
    SetSpeciesSeen SPECIES_DOTTLER
    SetSpeciesSeen SPECIES_ORBEETLE
    SetSpeciesSeen SPECIES_CUFANT
    SetSpeciesSeen SPECIES_COPPERAJAH
    SetSpeciesSeen SPECIES_TOXEL
    SetSpeciesSeen SPECIES_TOXTRICITY
    SetSpeciesSeen SPECIES_APPLIN
    SetSpeciesSeen SPECIES_APPLETUN
    SetSpeciesSeen SPECIES_FLAPPLE
    SetSpeciesSeen SPECIES_LECHONK
    SetSpeciesSeen SPECIES_OINKOLOGNE
    SetSpeciesSeen SPECIES_FIDOUGH
    SetSpeciesSeen SPECIES_DACHSBUN
    SetSpeciesSeen SPECIES_TINKATUFF
    SetSpeciesSeen SPECIES_TINKATINK
    SetSpeciesSeen SPECIES_TINKATON
    SetSpeciesSeen SPECIES_TOEDSCOOL
    SetSpeciesSeen SPECIES_TOEDSCRUEL
    SetSpeciesSeen SPECIES_KLAWF
    SetSpeciesSeen SPECIES_WYRDEER
    SetSpeciesSeen SPECIES_DECIDUEYE_HISUIAN
    SetSpeciesSeen SPECIES_ELECTRODE_HISUIAN
    SetSpeciesSeen SPECIES_KLEAVOR
    SetSpeciesSeen SPECIES_SAMUROTT_HISUIAN
    SetSpeciesSeen SPECIES_FLAMIGO
    SetSpeciesSeen SPECIES_SMOLIV
    SetSpeciesSeen SPECIES_DOLLIV
    SetSpeciesSeen SPECIES_ARBOLIVA
    SetSpeciesSeen SPECIES_WIGLETT
    SetSpeciesSeen SPECIES_WUGTRIO
_TwinleafTown_Guitarist_AfterDexFill:
    SetVar VAR_LEVEL_CAP, 100
    AddItem ITEM_RARE_CANDY, 1, VAR_RESULT
    AddItem ITEM_WHITE_HERB, 1, VAR_RESULT
    AddItem ITEM_POWER_HERB, 1, VAR_RESULT
    AddItem ITEM_BIG_ROOT, 1, VAR_RESULT
    AddItem ITEM_HEART_SCALE, 999, VAR_RESULT
    AddItem ITEM_MASTER_BALL, 999, VAR_RESULT
    Message TwinleafTown_Text_IVIntro
    InitLocalTextListMenu 1, 1, 0, VAR_RESULT
    AddListMenuEntry TwinleafTown_Text_IVHP, 0
    AddListMenuEntry TwinleafTown_Text_IVAtk, 1
    AddListMenuEntry TwinleafTown_Text_IVDef, 2
    AddListMenuEntry TwinleafTown_Text_IVSpeed, 3
    AddListMenuEntry TwinleafTown_Text_IVSpAtk, 4
    AddListMenuEntry TwinleafTown_Text_IVSpDef, 5
    ShowListMenu
    GoToIfEq VAR_RESULT, 0, TwinleafTown_GuitaristMaxHP
    GoToIfEq VAR_RESULT, 1, TwinleafTown_GuitaristMaxAtk
    GoToIfEq VAR_RESULT, 2, TwinleafTown_GuitaristMaxDef
    GoToIfEq VAR_RESULT, 3, TwinleafTown_GuitaristMaxSpeed
    GoToIfEq VAR_RESULT, 4, TwinleafTown_GuitaristMaxSpAtk
    GoToIfEq VAR_RESULT, 5, TwinleafTown_GuitaristMaxSpDef
    GoTo TwinleafTown_GuitaristCancel

TwinleafTown_GuitaristMaxHP:
    SetPartyMonIVPerfect VAR_RESULT, 0, 0
    GoTo TwinleafTown_GuitaristCheckResult

TwinleafTown_GuitaristMaxAtk:
    SetPartyMonIVPerfect VAR_RESULT, 0, 1
    GoTo TwinleafTown_GuitaristCheckResult

TwinleafTown_GuitaristMaxDef:
    SetPartyMonIVPerfect VAR_RESULT, 0, 2
    GoTo TwinleafTown_GuitaristCheckResult

TwinleafTown_GuitaristMaxSpeed:
    SetPartyMonIVPerfect VAR_RESULT, 0, 3
    GoTo TwinleafTown_GuitaristCheckResult

TwinleafTown_GuitaristMaxSpAtk:
    SetPartyMonIVPerfect VAR_RESULT, 0, 4
    GoTo TwinleafTown_GuitaristCheckResult

TwinleafTown_GuitaristMaxSpDef:
    SetPartyMonIVPerfect VAR_RESULT, 0, 5
    GoTo TwinleafTown_GuitaristCheckResult

TwinleafTown_GuitaristCheckResult:
    GoToIfEq VAR_RESULT, FALSE, TwinleafTown_GuitaristAlreadyPerfect
    Message TwinleafTown_Text_IVSuccess
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

TwinleafTown_GuitaristAlreadyPerfect:
    CloseMessage
    Message TwinleafTown_Text_IVAlreadyPerfect
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

TwinleafTown_GuitaristCancel:
    CloseMessage
    ReleaseAll
    End

TwinleafTown_EveryoneGoesOnAdventures:
    Message TwinleafTown_Text_EveryoneGoesOnAdventures
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

TwinleafTown_RivalWentTearingOffOuch:
    BufferRivalName 0
    Message TwinleafTown_Text_RivalWentTearingOffOuch
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

TwinleafTown_RivalWentTearingOff:
    BufferPlayerName 0
    BufferRivalName 1
    Message TwinleafTown_Text_RivalWentTearingOff
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

TwinleafTown_RivalWasLookingForYouTrigger:
    LockAll
    ApplyMovement LOCALID_GUITARIST, TwinleafTown_Movement_GuitaristNoticePlayer
    WaitMovement
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    GoToIfEq VAR_0x8004, 108, TwinleafTown_GuitaristStopPlayerX108
    GoToIfEq VAR_0x8004, 109, TwinleafTown_GuitaristStopPlayerX109
    GoToIfEq VAR_0x8004, 110, TwinleafTown_GuitaristStopPlayerX110
    GoToIfEq VAR_0x8004, 111, TwinleafTown_GuitaristStopPlayerX111
    GoToIfEq VAR_0x8004, 112, TwinleafTown_GuitaristStopPlayerX112
    GoToIfEq VAR_0x8004, 113, TwinleafTown_GuitaristStopPlayerX113
    GoToIfEq VAR_0x8004, 114, TwinleafTown_GuitaristStopPlayerX114
    GoTo TwinleafTown_GuitaristStopPlayerX115

TwinleafTown_GuitaristStopPlayerX108:
    ApplyMovement LOCALID_PLAYER, TwinleafTown_Movement_PlayerGetPushedBackX108
    ApplyMovement LOCALID_GUITARIST, TwinleafTown_Movement_GuitaristStopPlayerX108
    WaitMovement
    GoTo TwinleafTown_RivalWasLookingForYou

TwinleafTown_GuitaristStopPlayerX109:
    ApplyMovement LOCALID_PLAYER, TwinleafTown_Movement_PlayerGetPushedBackX109
    ApplyMovement LOCALID_GUITARIST, TwinleafTown_Movement_GuitaristStopPlayerX109
    WaitMovement
    GoTo TwinleafTown_RivalWasLookingForYou

TwinleafTown_GuitaristStopPlayerX110:
    ApplyMovement LOCALID_PLAYER, TwinleafTown_Movement_PlayerGetPushedBackX110
    ApplyMovement LOCALID_GUITARIST, TwinleafTown_Movement_GuitaristStopPlayerX110
    WaitMovement
    GoTo TwinleafTown_RivalWasLookingForYou

TwinleafTown_GuitaristStopPlayerX111:
    ApplyMovement LOCALID_PLAYER, TwinleafTown_Movement_PlayerGetPushedBackX111
    ApplyMovement LOCALID_GUITARIST, TwinleafTown_Movement_GuitaristStopPlayerX111
    WaitMovement
    GoTo TwinleafTown_RivalWasLookingForYou

TwinleafTown_GuitaristStopPlayerX112:
    ApplyMovement LOCALID_PLAYER, TwinleafTown_Movement_PlayerGetPushedBackX112
    ApplyMovement LOCALID_GUITARIST, TwinleafTown_Movement_GuitaristStopPlayerX112
    WaitMovement
    GoTo TwinleafTown_RivalWasLookingForYou

TwinleafTown_GuitaristStopPlayerX113:
    ApplyMovement LOCALID_PLAYER, TwinleafTown_Movement_PlayerGetPushedBackX113
    ApplyMovement LOCALID_GUITARIST, TwinleafTown_Movement_GuitaristStopPlayerX113
    WaitMovement
    GoTo TwinleafTown_RivalWasLookingForYou

TwinleafTown_GuitaristStopPlayerX114:
    ApplyMovement LOCALID_PLAYER, TwinleafTown_Movement_PlayerGetPushedBackX114
    ApplyMovement LOCALID_GUITARIST, TwinleafTown_Movement_GuitaristStopPlayerX114
    WaitMovement
    GoTo TwinleafTown_RivalWasLookingForYou

TwinleafTown_GuitaristStopPlayerX115:
    ApplyMovement LOCALID_PLAYER, TwinleafTown_Movement_PlayerGetPushedBackX115
    ApplyMovement LOCALID_GUITARIST, TwinleafTown_Movement_GuitaristStopPlayerX115
    WaitMovement
    GoTo TwinleafTown_RivalWasLookingForYou

TwinleafTown_RivalWasLookingForYou:
    BufferPlayerName 0
    BufferRivalName 1
    Message TwinleafTown_Text_RivalWasLookingForYou1
    CloseMessage
    GoToIfEq VAR_0x8004, 108, TwinleafTown_GuitaristWalkBackX108
    GoToIfEq VAR_0x8004, 109, TwinleafTown_GuitaristWalkBackX109
    GoToIfEq VAR_0x8004, 110, TwinleafTown_GuitaristWalkBackX110
    GoToIfEq VAR_0x8004, 111, TwinleafTown_GuitaristWalkBackX111
    GoToIfEq VAR_0x8004, 112, TwinleafTown_GuitaristWalkBackX112
    GoToIfEq VAR_0x8004, 113, TwinleafTown_GuitaristWalkBackX113
    GoToIfEq VAR_0x8004, 114, TwinleafTown_GuitaristWalkBackX114
    GoTo TwinleafTown_GuitaristWalkBackX115

TwinleafTown_GuitaristWalkBackX108:
    ApplyMovement LOCALID_GUITARIST, TwinleafTown_Movement_GuitaristWalkBackX108
    WaitMovement
    GoTo TwinleafTown_GuitaristRelease

TwinleafTown_GuitaristWalkBackX109:
    ApplyMovement LOCALID_GUITARIST, TwinleafTown_Movement_GuitaristWalkBackX109
    WaitMovement
    GoTo TwinleafTown_GuitaristRelease

TwinleafTown_GuitaristWalkBackX110:
    ApplyMovement LOCALID_GUITARIST, TwinleafTown_Movement_GuitaristWalkBackX110
    WaitMovement
    GoTo TwinleafTown_GuitaristRelease

TwinleafTown_GuitaristWalkBackX111:
    ApplyMovement LOCALID_GUITARIST, TwinleafTown_Movement_GuitaristWalkBackX111
    WaitMovement
    GoTo TwinleafTown_GuitaristRelease

TwinleafTown_GuitaristWalkBackX112:
    ApplyMovement LOCALID_GUITARIST, TwinleafTown_Movement_GuitaristWalkBackX112
    WaitMovement
    GoTo TwinleafTown_GuitaristRelease

TwinleafTown_GuitaristWalkBackX113:
    ApplyMovement LOCALID_GUITARIST, TwinleafTown_Movement_GuitaristWalkBackX113
    WaitMovement
    GoTo TwinleafTown_GuitaristRelease

TwinleafTown_GuitaristWalkBackX114:
    ApplyMovement LOCALID_GUITARIST, TwinleafTown_Movement_GuitaristWalkBackX114
    WaitMovement
    GoTo TwinleafTown_GuitaristRelease

TwinleafTown_GuitaristWalkBackX115:
    ApplyMovement LOCALID_GUITARIST, TwinleafTown_Movement_GuitaristWalkBackX115
    WaitMovement
    GoTo TwinleafTown_GuitaristRelease

TwinleafTown_GuitaristRelease:
    ReleaseAll
    End

    .balign 4, 0
TwinleafTown_Movement_PlayerGetPushedBackX108:
    Delay4 6
    LockDir
    WalkNormalSouth
    UnlockDir
    WalkOnSpotFastNorth
    EndMovement

    .balign 4, 0
TwinleafTown_Movement_PlayerGetPushedBackX109:
    Delay4 5
    LockDir
    WalkNormalSouth
    UnlockDir
    WalkOnSpotFastNorth
    EndMovement

    .balign 4, 0
TwinleafTown_Movement_PlayerGetPushedBackX110:
    Delay4 6
    LockDir
    WalkNormalSouth
    UnlockDir
    WalkOnSpotFastNorth
    EndMovement

    .balign 4, 0
TwinleafTown_Movement_PlayerGetPushedBackX111:
    Delay4 7
    LockDir
    WalkNormalSouth
    UnlockDir
    WalkOnSpotFastNorth
    EndMovement

    .balign 4, 0
TwinleafTown_Movement_PlayerGetPushedBackX112:
    Delay4 8
    LockDir
    WalkNormalSouth
    UnlockDir
    WalkOnSpotFastNorth
    EndMovement

    .balign 4, 0
TwinleafTown_Movement_PlayerGetPushedBackX113:
    Delay4 9
    LockDir
    WalkNormalSouth
    UnlockDir
    WalkOnSpotFastNorth
    EndMovement

    .balign 4, 0
TwinleafTown_Movement_PlayerGetPushedBackX114:
    Delay4 10
    LockDir
    WalkNormalSouth
    UnlockDir
    WalkOnSpotFastNorth
    EndMovement

    .balign 4, 0
TwinleafTown_Movement_PlayerGetPushedBackX115:
    Delay4 11
    LockDir
    WalkNormalSouth
    UnlockDir
    WalkOnSpotFastNorth
    EndMovement

    .balign 4, 0
TwinleafTown_Movement_GuitaristNoticePlayer:
    WalkOnSpotFastNorth
    EmoteExclamationMark
    Delay8
    Delay4
    EndMovement

    .balign 4, 0
TwinleafTown_Movement_GuitaristStopPlayerX108:
    WalkFastNorth
    WalkFastEast
    WalkFastNorth 2
    WalkFastWest
    WalkOnSpotFastSouth
    WalkNormalSouth
    EndMovement

    .balign 4, 0
TwinleafTown_Movement_GuitaristStopPlayerX109:
    WalkFastNorth 3
    WalkFastEast
    WalkOnSpotFastSouth
    WalkNormalSouth
    EndMovement

    .balign 4, 0
TwinleafTown_Movement_GuitaristStopPlayerX110:
    WalkFastNorth 3
    WalkFastEast 2
    WalkOnSpotFastSouth
    WalkNormalSouth
    EndMovement

    .balign 4, 0
TwinleafTown_Movement_GuitaristStopPlayerX111:
    WalkFastNorth 3
    WalkFastEast 3
    WalkOnSpotFastSouth
    WalkNormalSouth
    EndMovement

    .balign 4, 0
TwinleafTown_Movement_GuitaristStopPlayerX112:
    WalkFastNorth 3
    WalkFastEast 4
    WalkOnSpotFastSouth
    WalkNormalSouth
    EndMovement

    .balign 4, 0
TwinleafTown_Movement_GuitaristStopPlayerX113:
    WalkFastNorth 3
    WalkFastEast 5
    WalkOnSpotFastSouth
    WalkNormalSouth
    EndMovement

    .balign 4, 0
TwinleafTown_Movement_GuitaristStopPlayerX114:
    WalkFastNorth 3
    WalkFastEast 6
    WalkOnSpotFastSouth
    WalkNormalSouth
    EndMovement

    .balign 4, 0
TwinleafTown_Movement_GuitaristStopPlayerX115:
    WalkFastNorth 3
    WalkFastEast 7
    WalkOnSpotFastSouth
    WalkNormalSouth
    EndMovement

    .balign 4, 0
TwinleafTown_Movement_GuitaristWalkBackX108:
    WalkNormalEast
    WalkNormalSouth 2
    WalkNormalWest
    EndMovement

    .balign 4, 0
TwinleafTown_Movement_GuitaristWalkBackX109:
    WalkNormalWest
    WalkNormalSouth 2
    EndMovement

    .balign 4, 0
TwinleafTown_Movement_GuitaristWalkBackX110:
    WalkNormalWest 2
    WalkNormalSouth 2
    EndMovement

    .balign 4, 0
TwinleafTown_Movement_GuitaristWalkBackX111:
    WalkNormalWest 3
    WalkNormalSouth 2
    EndMovement

    .balign 4, 0
TwinleafTown_Movement_GuitaristWalkBackX112:
    WalkNormalWest 4
    WalkNormalSouth 2
    EndMovement

    .balign 4, 0
TwinleafTown_Movement_GuitaristWalkBackX113:
    WalkNormalWest 5
    WalkNormalSouth 2
    EndMovement

    .balign 4, 0
TwinleafTown_Movement_GuitaristWalkBackX114:
    WalkNormalWest 6
    WalkNormalSouth 2
    EndMovement

    .balign 4, 0
TwinleafTown_Movement_GuitaristWalkBackX115:
    WalkNormalWest 7
    WalkNormalSouth 2
    EndMovement

TwinleafTown_RivalThudTrigger:
    LockAll
    LoadDoorAnimation 3, 27, 9, 11, ANIMATION_TAG_DOOR_1
    PlayDoorOpenAnimation ANIMATION_TAG_DOOR_1
    WaitForAnimation ANIMATION_TAG_DOOR_1
    ClearFlag FLAG_HIDE_TWINLEAF_TOWN_RIVAL
    AddObject LOCALID_RIVAL
    ApplyMovement LOCALID_RIVAL, TwinleafTown_Movement_RivalExitHouse
    ApplyMovement LOCALID_PLAYER, TwinleafTown_Movement_PlayerGetPushedBackByRival
    WaitMovement
    PlayFanfare SEQ_SE_DP_WALL_HIT2
    Message TwinleafTown_Text_BigThud
    WaitTime 30, VAR_RESULT
    Common_SetRivalBGM
    ApplyMovement LOCALID_RIVAL, TwinleafTown_Movement_RivalNoticePlayer
    WaitMovement
    BufferRivalName 0
    BufferPlayerName 1
    Message TwinleafTown_Text_GoingToSeeProfRowan
    CloseMessage
    ApplyMovement LOCALID_PLAYER, TwinleafTown_Movement_PlayerWatchRival
    ApplyMovement LOCALID_RIVAL, TwinleafTown_Movement_RivalWalkAwayAndWalkBack
    WaitMovement
    WaitTime 15, VAR_RESULT
    BufferRivalName 0
    Message TwinleafTown_Text_OhJeezForgotSomething
    CloseMessage
    ApplyMovement LOCALID_RIVAL, TwinleafTown_Movement_RivalEnterHouse
    WaitMovement
    PlayDoorCloseAnimation ANIMATION_TAG_DOOR_1
    WaitForAnimation ANIMATION_TAG_DOOR_1
    UnloadAnimation ANIMATION_TAG_DOOR_1
    RemoveObject LOCALID_RIVAL
    Common_FadeToDefaultMusic2
    SetVar VAR_TWINLEAF_TOWN_GUITARIST_TRIGGER_STATE, 1
    SetVar VAR_TWINLEAF_TOWN_RIVAL_TRIGGER_STATE, 1
    ReleaseAll
    End

    .balign 4, 0
TwinleafTown_Movement_PlayerWatchRival:
    Delay8
    Delay4
    WalkOnSpotNormalEast
    Delay8 5
    WalkOnSpotNormalNorth
    EndMovement

    .balign 4, 0
TwinleafTown_Movement_PlayerGetPushedBackByRival:
    FaceNorth
    LockDir
    WalkNormalSouth
    UnlockDir
    EndMovement

    .balign 4, 0
TwinleafTown_Movement_RivalNoticePlayer:
    EmoteExclamationMark
    EndMovement

    .balign 4, 0
TwinleafTown_Movement_RivalExitHouse:
    WalkFastSouth
    WalkOnSpotFastNorth
    EndMovement

    .balign 4, 0
TwinleafTown_Movement_RivalWalkAwayAndWalkBack:
    WalkFastEast 4
    EmoteExclamationMark
    Delay8
    WalkFastWest 4
    WalkOnSpotFastSouth
    EndMovement

    .balign 4, 0
TwinleafTown_Movement_RivalEnterHouse:
    WalkNormalNorth
    SetInvisible
    EndMovement

TwinleafTown_Collector:
    NPCMessage TwinleafTown_Text_TechnologyBlowsMeAway
    End

TwinleafTown_BreederF:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    GoToIfSet FLAG_HAS_POKEDEX, TwinleafTown_HelpingPutTogetherPokedex
    GoToIfGe VAR_VISITED_LAKE_VERITY_WITH_RIVAL, 1, TwinleafTown_PokemonYouLookGoodTogether
    Message TwinleafTown_Text_WildPokemonAttack
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

TwinleafTown_HelpingPutTogetherPokedex:
    Message TwinleafTown_Text_HelpingPutTogetherPokedex
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

TwinleafTown_PokemonYouLookGoodTogether:
    Message TwinleafTown_Text_PokemonYouLookGoodTogether
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

TwinleafTown_MapSign:
    ShowMapSign TwinleafTown_Text_MapSign
    End

TwinleafTown_LandmarkSignPlayerMailbox:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    GoToIfSet FLAG_OBTAINED_OREBURGH_MINE_B2F_ESCAPE_ROPE, TwinleafTown_MailboxAlreadyRead
    Message TwinleafTown_Text_MailboxScale
    ShowYesNoMenu VAR_RESULT
    GoToIfEq VAR_RESULT, MENU_NO, TwinleafTown_MailboxCancel
    Message TwinleafTown_Text_LetterEnd
    WaitABXPadPress
    SetVar VAR_0x8004, ITEM_HEART_SCALE
    SetVar VAR_0x8005, 1
    CallCommonScript 0x7FC
    CloseMessage
    SetFlag FLAG_OBTAINED_OREBURGH_MINE_B2F_ESCAPE_ROPE
    ReleaseAll
    End

TwinleafTown_LandmarkSignRivalMailbox:
    BufferRivalName 0
    ShowLandmarkSign TwinleafTown_Text_RivalMailbox
    End

TwinleafTown_MailboxCancel:
    CloseMessage 
    ReleaseAll
    End

TwinleafTown_MailboxAlreadyRead:
    BufferPlayerName 0
    ShowLandmarkSign TwinleafTown_Text_PlayerMailbox
    End

    .balign 4, 0
