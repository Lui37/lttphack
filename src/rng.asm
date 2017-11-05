; Pokeys
org $0688E9
    ; 0688e9 jsl $0dba71
    ; 0688ed and #$03
    ; 0688ef tay
    ; 0688f0 lda $88d7,y
    ; 0688f3 sta $0d50,x
    ; 0688f6 lda $88db,y
    ; 0688f9 sta $0d40,x
    ; 0688fc rts
    JSL rng_pokey_hook
    RTS

; Agahnim
org $01ED6EF
    ; 1ed6ef jsl $0dba71
    JSL rng_agahnim_hook

; Helmasaur
org $01E8262
	; 1e8262 jsl $0dba71
	JSL rng_helmasaur_hook

; Ganon warp location
org $1D9488
    ; 1d9488 jsl $0dba71
    JSL rng_ganon_warp_location

; Ganon warp
org $1D91E3
    ; 1d91e3 jsl $0dba71
    JSL rng_ganon_warp


org $288000

tbl_pokey_speed:
    ; 00
    db -16, -16, -16, -16 ; ul ul
    db -16,  16, -16, -16 ; ur ul
    db  16,  16, -16, -16 ; dr ul
    db  16, -16, -16, -16 ; dl ul

    ; 10
    db -16, -16, -16,  16 ; ul ur
    db -16,  16, -16,  16 ; ur ur
    db  16,  16, -16,  16 ; dr ur
    db  16, -16, -16,  16 ; dl ur

    ; 20
    db -16, -16,  16,  16 ; ul dr
    db -16,  16,  16,  16 ; ur dr
    db  16,  16,  16,  16 ; dr dr
    db  16, -16,  16,  16 ; dl dr

    ; 30
    db -16, -16,  16, -16 ; ul dl
    db -16,  16,  16, -16 ; ur dl
    db  16,  16,  16, -16 ; dr dl
    db  16, -16,  16, -16 ; dl dl

tbl_real_pokey_x:
    db 16, -16,  16, -16
tbl_real_pokey_y:
    db 16,  16, -16, -16

rng_pokey_hook:
    PHB : PHK : PLB

    LDA !ram_pokey_rng : BEQ .random

    LDA !ram_rng_counter : ASL : STA !lowram_draw_tmp
    LDA !ram_pokey_rng : DEC : ASL #2 : CLC : ADC !lowram_draw_tmp : TAY

    LDA tbl_pokey_speed, Y : STA $0D40, X
    LDA tbl_pokey_speed+1, Y : STA $0D50, X

    LDA !ram_rng_counter : INC : STA !ram_rng_counter
    BRA .done

  .random
    JSL !RandomNumGen : AND #$03 : TAY
    LDA tbl_real_pokey_x, Y : STA $0D50, X
    LDA tbl_real_pokey_y, Y : STA $0D40, X

  .done
    PLB
    RTL


; == Agahnim ==

rng_agahnim_hook:
    LDA !ram_agahnim_rng : BEQ .random
    CMP #$01 : BEQ .done
	LDA #$00
    RTL

  .random
	JSL !RandomNumGen
    RTL

  .done
    RTL


; == Helmasaur ==

rng_helmasaur_hook:
    LDA !ram_helmasaur_rng : BEQ .random
    DEC
    RTL

  .random
	JSL !RandomNumGen
    RTL


; == Ganon Warp Location ==

rng_ganon_warp_location:
    LDA !ram_ganon_warp_location_rng : BEQ .random
    DEC
    RTL

  .random
    JSL !RandomNumGen
    RTL


; == Ganon Warp ==

rng_ganon_warp:
    LDA !ram_ganon_warp_rng : BEQ .random
    DEC
    RTL

  .random
    JSL !RandomNumGen
    RTL