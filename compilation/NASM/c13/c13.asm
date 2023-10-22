;==============================================================
SECTION header vstart=0
        program_length  dd program_end   ;0x00

        head_len        dd header_end    ;0x04

        stack_seg       dd 0             ;0x08
        stack_len       dd 1             ;0x0c

        prgentry        dd start         ;0x10
        code_seg        dd section.code.start    ;0x14
        code_len        dd code_end              ;0x18

        data_seg        dd section.data.start    ;0x1c
        data_len        dd data_end              ;0x20

;--------------------------------------------------------------


header_end:
;==============================================================
SECTION data vstart=0
;==============================================================
SECTION code vstart=0
start:


;==============================================================
SECTION trail
program_end:
