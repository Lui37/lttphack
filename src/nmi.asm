; NMI
;
; Expands the NMI (code run at the end of each frame)

; NMI hook
org $0080CC
    ; 0080cc pha
    ; 0080cd phx
    ; 0080ce phy
    ; 0080cf phd
    ; 0080d0 phb
    ; 0080d1 lda #$0000 <-- we'll jump back here
    JMP nmi_hook


; HUD update hook
org $008B6B
    ; 008b6b ldx $0219
    ; 008b6e stx $2116
    JSL nmi_hud_update
    NOP : NOP

; NMI HOOK
org $0089C2
nmi_hook:
    PHA : PHX : PHY : PHD : PHB

    JSL nmi_expand
  %ai16()
    JMP $80D1


org !ORG
nmi_expand:
   ; Enters AI=16
  %a8()
    INC !lowram_nmi_counter
    LDA !lowram_last_frame_did_saveload : BNE .dont_update_counters

    JSR nmi_do_update_counters
    RTL

  .dont_update_counters
    STZ !lowram_last_frame_did_saveload
    RTL


nmi_do_update_counters:
  %a16()
    INC !lowram_room_realtime
    INC !lowram_seg_frames

    ; Check if frames == 60
    LDA !lowram_seg_frames : CMP.w #60 : BNE .end

    ; If so, reset frames and +1 secs
    STZ !lowram_seg_frames : INC !lowram_seg_seconds

    ; Check if secs == 60
    LDA !lowram_seg_seconds : CMP.w #60 : BNE .end

    ; If so, reset secs and +1 mins.
    STZ !lowram_seg_seconds : INC !lowram_seg_minutes

  .end
  %a8()
    RTS


nmi_hud_update:
    LDX #$6360 : STX $2116

    ; $7EC700 is the WRAM buffer for this data
    LDX.w #!ram_movie_hud : STX $4302
    LDA.b #!ram_movie_hud>>16 : STA $4304

    ; number of bytes to transfer is 330
    LDX #$0040 : STX $4305

    ; refresh BG3 tilemap data with this transfer on channel 0
    LDA #$01 : STA $420B

    LDX #$6040
    STX $2116
    RTL
