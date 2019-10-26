use warnings;
use strict;
use autodie;
use Switch;

#modos de endereçamento
my $imm  = '#$00';
my $sr   = '$00,S';
my $dp   = '$00';
my $dpx  = '$00,X';
my $dpy  = '$00,Y';
my $idp  = '($00)';
my $idx  = '($00,X)';
my $idy  = '($00),Y';
my $idl  = '[$00]';
my $idly = '[$00],Y';
my $isy  = '($00,S),Y';
my $abs  = '$0000';
my $abx  = '$0000,X';
my $aby  = '$0000,Y';
my $abl  = '$000000';
my $alx  = '$000000,X';
my $ind  = '($0000)';
my $iax  = '($0000,X)';
my $ial  = '[$000000]';
my $rel  = '$0000 (8 bits PC-relative)';
my $rell = '$0000 (16 bits PC-relative)';
my $bm   = '$00,$00 ';

# instruções seguindo essa tabela http://www.oxyron.de/html/opcodes816.html
my @instructions = (
    {mnemonic => "BRK", address_mode => undef}, #00
    {mnemonic => "ORA", address_mode => $idx}, #01
    {mnemonic => "COP", address_mode => $imm}, #02
    {mnemonic => "ORA", address_mode => $sr}, #03
    {mnemonic => "TSB", address_mode => $dp}, #04
    {mnemonic => "ORA", address_mode => $dp}, #05
    {mnemonic => "ASL", address_mode => $dp}, #06
    {mnemonic => "ORA", address_mode => $idl}, #07
    {mnemonic => "PHP", address_mode => undef}, #08
    {mnemonic => "ORA", address_mode => $imm}, #09
    {mnemonic => "ASL", address_mode => undef}, #0a
    {mnemonic => "PHD", address_mode => undef}, #0b
    {mnemonic => "TSB", address_mode => $abs}, #0c
    {mnemonic => "ORA", address_mode => $abs}, #0d
    {mnemonic => "ASL", address_mode => $abs}, #0e
    {mnemonic => "ORA", address_mode => $abs}, #0f

    {mnemonic => "BPL", address_mode => $rel}, #10
    {mnemonic => "ORA", address_mode => $idy}, #11
    {mnemonic => "ORA", address_mode => $idp}, #12
    {mnemonic => "ORA", address_mode => $isy}, #13
    {mnemonic => "TRB", address_mode => $dp}, #14
    {mnemonic => "ORA", address_mode => $dpx}, #15
    {mnemonic => "ASL", address_mode => $dpx}, #16
    {mnemonic => "ORA", address_mode => $idly}, #17
    {mnemonic => "CLC", address_mode => undef}, #18
    {mnemonic => "ORA", address_mode => $aby}, #19
    {mnemonic => "INC", address_mode => undef}, #1a
    {mnemonic => "TCS", address_mode => undef}, #1b
    {mnemonic => "TRB", address_mode => $abs}, #1c
    {mnemonic => "ORA", address_mode => $abx}, #1d
    {mnemonic => "ASL", address_mode => $abx}, #1e
    {mnemonic => "ORA", address_mode => $alx}, #1f

    {mnemonic => "JSR", address_mode => $abs}, #20
    {mnemonic => "AND", address_mode => $idx}, #21
    {mnemonic => "JSR", address_mode => $abl}, #22
    {mnemonic => "AND", address_mode => $sr}, #23
    {mnemonic => "BIT", address_mode => $dp}, #24
    {mnemonic => "AND", address_mode => $dp}, #25
    {mnemonic => "ROL", address_mode => $dp}, #26
    {mnemonic => "AND", address_mode => $idl}, #27
    {mnemonic => "PLP", address_mode => undef}, #28
    {mnemonic => "AND", address_mode => $imm}, #29
    {mnemonic => "ROL", address_mode => undef}, #2a
    {mnemonic => "PLD", address_mode => undef}, #2b
    {mnemonic => "BIT", address_mode => $abs}, #2c
    {mnemonic => "AND", address_mode => $abs}, #2d
    {mnemonic => "ROL", address_mode => $abs}, #2e
    {mnemonic => "AND", address_mode => $abl}, #2f

    {mnemonic => "BMI", address_mode => $rel}, #30
    {mnemonic => "AND", address_mode => $idy}, #31
    {mnemonic => "AND", address_mode => $idp}, #32
    {mnemonic => "AND", address_mode => $isy}, #33
    {mnemonic => "BIT", address_mode => $dpx}, #34
    {mnemonic => "AND", address_mode => $dpx}, #35
    {mnemonic => "ROL", address_mode => $dpx}, #36
    {mnemonic => "AND", address_mode => $idly}, #37
    {mnemonic => "SEC", address_mode => undef}, #38
    {mnemonic => "AND", address_mode => $aby}, #39
    {mnemonic => "DEC", address_mode => undef}, #3a
    {mnemonic => "TSC", address_mode => undef}, #3b
    {mnemonic => "BIT", address_mode => $abx}, #3c
    {mnemonic => "AND", address_mode => $abx}, #3d
    {mnemonic => "ROL", address_mode => $abx}, #3e
    {mnemonic => "AND", address_mode => $alx}, #3f

    {mnemonic => "RTI", address_mode => undef}, #40
    {mnemonic => "EOR", address_mode => $idx}, #41
    {mnemonic => "WDM", address_mode => undef}, #42
    {mnemonic => "EOR", address_mode => $sr}, #43
    {mnemonic => "MVP", address_mode => $bm}, #44
    {mnemonic => "EOR", address_mode => $dp}, #45
    {mnemonic => "LSR", address_mode => $dp}, #46
    {mnemonic => "EOR", address_mode => $idl}, #47
    {mnemonic => "PHA", address_mode => undef}, #48
    {mnemonic => "EOR", address_mode => $imm}, #49
    {mnemonic => "LSR", address_mode => undef}, #4a
    {mnemonic => "PHK", address_mode => undef}, #4b
    {mnemonic => "JMP", address_mode => $abs}, #4c
    {mnemonic => "EOR", address_mode => $abs}, #4d
    {mnemonic => "LSR", address_mode => $abs}, #4e
    {mnemonic => "EOR", address_mode => $abl}, #4f

    {mnemonic => "BVC", address_mode => $rel}, #50
    {mnemonic => "EOR", address_mode => $idy}, #51
    {mnemonic => "EOR", address_mode => $idp}, #52
    {mnemonic => "EOR", address_mode => $isy}, #53
    {mnemonic => "MVN", address_mode => $bm}, #54
    {mnemonic => "EOR", address_mode => $dpx}, #55
    {mnemonic => "LSR", address_mode => $dpx}, #56
    {mnemonic => "EOR", address_mode => $idly}, #57
    {mnemonic => "CLI", address_mode => undef}, #58
    {mnemonic => "EOR", address_mode => $aby}, #59
    {mnemonic => "PHY", address_mode => undef}, #5a
    {mnemonic => "TCD", address_mode => undef}, #5b
    {mnemonic => "JMP", address_mode => $abl}, #5c
    {mnemonic => "EOR", address_mode => $abx}, #5d
    {mnemonic => "LSR", address_mode => $abx}, #5e
    {mnemonic => "EOR", address_mode => $alx}, #5f
    
    {mnemonic => "RTS", address_mode => undef}, #60
    {mnemonic => "ADC", address_mode => $idx}, #61
    {mnemonic => "PER", address_mode => $rell}, #62
    {mnemonic => "ADC", address_mode => $sr}, #63
    {mnemonic => "STZ", address_mode => $dp}, #64
    {mnemonic => "ADC", address_mode => $dp}, #65
    {mnemonic => "ROR", address_mode => $dp}, #66
    {mnemonic => "ADC", address_mode => $idl}, #67
    {mnemonic => "PLA", address_mode => undef}, #68
    {mnemonic => "ADC", address_mode => $imm}, #69
    {mnemonic => "ROR", address_mode => undef}, #6a
    {mnemonic => "RTL", address_mode => undef}, #6b
    {mnemonic => "JMP", address_mode => $ind}, #6c
    {mnemonic => "ADC", address_mode => $abs}, #6d
    {mnemonic => "ROR", address_mode => $abs}, #6e
    {mnemonic => "ADC", address_mode => $abl}, #6f

    {mnemonic => "BVS", address_mode => $rel}, #70
    {mnemonic => "ADC", address_mode => $idy}, #71
    {mnemonic => "ADC", address_mode => $idp}, #72
    {mnemonic => "ADC", address_mode => $isy}, #73
    {mnemonic => "STZ", address_mode => $dpx}, #74
    {mnemonic => "ADC", address_mode => $dpx}, #75
    {mnemonic => "ROR", address_mode => $dpx}, #76
    {mnemonic => "ADC", address_mode => $idly}, #77
    {mnemonic => "SEI", address_mode => undef}, #78
    {mnemonic => "ADC", address_mode => $aby}, #79
    {mnemonic => "PLY", address_mode => undef}, #7a
    {mnemonic => "TDC", address_mode => undef}, #7b
    {mnemonic => "JMP", address_mode => $ial}, #7c
    {mnemonic => "ADC", address_mode => $abx}, #7d
    {mnemonic => "ROR", address_mode => $abx}, #7e
    {mnemonic => "ADC", address_mode => $alx}, #7f

    {mnemonic => "BRA", address_mode => $rel}, #80
    {mnemonic => "STA", address_mode => $idx}, #81
    {mnemonic => "BRL", address_mode => $rell}, #82
    {mnemonic => "STA", address_mode => $sr}, #83
    {mnemonic => "STY", address_mode => $dp}, #84
    {mnemonic => "STA", address_mode => $dp}, #85
    {mnemonic => "STX", address_mode => $dp}, #86
    {mnemonic => "STA", address_mode => $idl}, #87
    {mnemonic => "DEY", address_mode => undef}, #88
    {mnemonic => "BIT", address_mode => $imm}, #89
    {mnemonic => "TXA", address_mode => undef}, #8a
    {mnemonic => "PHB", address_mode => undef}, #8b
    {mnemonic => "STY", address_mode => $abs}, #8c
    {mnemonic => "STA", address_mode => $abs}, #8d
    {mnemonic => "STX", address_mode => $abs}, #8e
    {mnemonic => "STA", address_mode => $abl}, #8f

    {mnemonic => "BCC", address_mode => $rel}, #90
    {mnemonic => "STA", address_mode => $idy}, #91
    {mnemonic => "STA", address_mode => $idp}, #92
    {mnemonic => "STA", address_mode => $isy}, #93
    {mnemonic => "STY", address_mode => $dpx}, #94
    {mnemonic => "STA", address_mode => $dpx}, #95
    {mnemonic => "STX", address_mode => $dpy}, #96
    {mnemonic => "STA", address_mode => $idly}, #97
    {mnemonic => "TYA", address_mode => undef}, #98
    {mnemonic => "STA", address_mode => $aby}, #99
    {mnemonic => "TXS", address_mode => undef}, #9a
    {mnemonic => "TXY", address_mode => undef}, #9b
    {mnemonic => "STZ", address_mode => $abs}, #9c
    {mnemonic => "STA", address_mode => $abx}, #9d
    {mnemonic => "STZ", address_mode => $abx}, #9e
    {mnemonic => "STA", address_mode => $alx}, #9f
    
    {mnemonic => "LDY", address_mode => $imm}, #a0
    {mnemonic => "LDA", address_mode => $idx}, #a1
    {mnemonic => "LDX", address_mode => $imm}, #a2
    {mnemonic => "LDA", address_mode => $sr}, #a3
    {mnemonic => "LDY", address_mode => $dp}, #a4
    {mnemonic => "LDA", address_mode => $dp}, #a5
    {mnemonic => "LDX", address_mode => $dp}, #a6
    {mnemonic => "LDA", address_mode => $idl}, #a7
    {mnemonic => "TAY", address_mode => undef}, #a8
    {mnemonic => "LDA", address_mode => $imm}, #a9
    {mnemonic => "TAX", address_mode => undef}, #aa
    {mnemonic => "PLB", address_mode => undef}, #ab
    {mnemonic => "LDY", address_mode => $abs}, #ac
    {mnemonic => "LDA", address_mode => $abs}, #ad
    {mnemonic => "LDX", address_mode => $abs}, #ae
    {mnemonic => "LDA", address_mode => $abl}, #af

    {mnemonic => "BCS", address_mode => $rel}, #b0
    {mnemonic => "LDA", address_mode => $idy}, #b1
    {mnemonic => "LDA", address_mode => $idp}, #b2
    {mnemonic => "LDA", address_mode => $isy}, #b3
    {mnemonic => "LDY", address_mode => $dpx}, #b4
    {mnemonic => "LDA", address_mode => $dpx}, #b5
    {mnemonic => "LDX", address_mode => $dpy}, #b6
    {mnemonic => "LDA", address_mode => $idly}, #b7
    {mnemonic => "CLV", address_mode => undef}, #b8
    {mnemonic => "LDA", address_mode => $aby}, #b9
    {mnemonic => "TSX", address_mode => undef}, #ba
    {mnemonic => "TYX", address_mode => undef}, #bb
    {mnemonic => "LDY", address_mode => $abx}, #bc
    {mnemonic => "LDA", address_mode => $abx}, #bd
    {mnemonic => "LDX", address_mode => $aby}, #be
    {mnemonic => "LDA", address_mode => $alx}, #bf
    
    {mnemonic => "CPY", address_mode => $imm}, #c0
    {mnemonic => "CMP", address_mode => $idx}, #c1
    {mnemonic => "REP", address_mode => $imm}, #c2
    {mnemonic => "CMP", address_mode => $sr}, #c3
    {mnemonic => "CPY", address_mode => $dp}, #c4
    {mnemonic => "CMP", address_mode => $dp}, #c5
    {mnemonic => "DEC", address_mode => $dp}, #c6
    {mnemonic => "CMP", address_mode => $idl}, #c7
    {mnemonic => "INY", address_mode => undef}, #c8
    {mnemonic => "CMP", address_mode => $imm}, #c9
    {mnemonic => "DEX", address_mode => undef}, #ca
    {mnemonic => "WAI", address_mode => undef}, #cb
    {mnemonic => "CPY", address_mode => $abs}, #cc
    {mnemonic => "CMP", address_mode => $abs}, #cd
    {mnemonic => "DEC", address_mode => $abs}, #ce
    {mnemonic => "CMP", address_mode => $abl}, #cf

    {mnemonic => "BNE", address_mode => $rel}, #d0
    {mnemonic => "CMP", address_mode => $idy}, #d1
    {mnemonic => "CMP", address_mode => $idp}, #d2
    {mnemonic => "CMP", address_mode => $isy}, #d3
    {mnemonic => "PEI", address_mode => $idp}, #d4
    {mnemonic => "CMP", address_mode => $dpx}, #d5
    {mnemonic => "DEC", address_mode => $dpx}, #d6
    {mnemonic => "CMP", address_mode => $idly}, #d7
    {mnemonic => "CLD", address_mode => undef}, #d8
    {mnemonic => "CMP", address_mode => $aby}, #d9
    {mnemonic => "PHX", address_mode => undef}, #da
    {mnemonic => "STP", address_mode => undef}, #db
    {mnemonic => "JMP", address_mode => $iax}, #dc
    {mnemonic => "CMP", address_mode => $abx}, #dd
    {mnemonic => "DEC", address_mode => $abx}, #de
    {mnemonic => "CMP", address_mode => $alx}, #df
    
    {mnemonic => "CPX", address_mode => $imm}, #e0
    {mnemonic => "SBC", address_mode => $idx}, #e1
    {mnemonic => "SEP", address_mode => $imm}, #e2
    {mnemonic => "SBC", address_mode => $sr}, #e3
    {mnemonic => "CPX", address_mode => $dp}, #e4
    {mnemonic => "SBC", address_mode => $dp}, #e5
    {mnemonic => "INC", address_mode => $dp}, #e6
    {mnemonic => "SBC", address_mode => $idl}, #e7
    {mnemonic => "INX", address_mode => undef}, #e8
    {mnemonic => "SBC", address_mode => $imm}, #e9
    {mnemonic => "NOP", address_mode => undef}, #ea
    {mnemonic => "XBA", address_mode => undef}, #eb
    {mnemonic => "CPX", address_mode => $abs}, #ec
    {mnemonic => "SBC", address_mode => $abs}, #ed
    {mnemonic => "INC", address_mode => $abs}, #ee
    {mnemonic => "SBC", address_mode => $abl}, #ef

    {mnemonic => "BEQ", address_mode => $rel}, #f0
    {mnemonic => "SBC", address_mode => $idy}, #f1
    {mnemonic => "SBC", address_mode => $idp}, #f2
    {mnemonic => "SBC", address_mode => $isy}, #f3
    {mnemonic => "PEA", address_mode => $abs}, #f4
    {mnemonic => "SBC", address_mode => $dpx}, #f5
    {mnemonic => "INC", address_mode => $dpx}, #f6
    {mnemonic => "SBC", address_mode => $idly}, #f7
    {mnemonic => "SED", address_mode => undef}, #f8
    {mnemonic => "SBC", address_mode => $aby}, #f9
    {mnemonic => "PLX", address_mode => undef}, #fa
    {mnemonic => "XCE", address_mode => undef}, #fb
    {mnemonic => "JSR", address_mode => $iax}, #fc
    {mnemonic => "SBC", address_mode => $abx}, #fd
    {mnemonic => "INC", address_mode => $abx}, #fe
    {mnemonic => "SBC", address_mode => $alx}, #ff
    
);


my $offset = 0;
my $buffer;

my @bytes;
open (FILE, "SMW.smc");
binmode FILE;
while ( read(FILE, $buffer, 1) ) {
    push(@bytes, unpack("C",$buffer));
    $buffer = "";
    last if (@bytes > 0xff);
}

for (my $pc = 0; $pc < @bytes; $pc++) {
    my $instruction = $instructions[$bytes[$pc]];
    printf("%06X: %s",$pc+0x8000,$instruction->{'mnemonic'});
    
    switch ($instruction->{'address_mode'}) {
        case ($abs) {
            printf(" \$%04X",( $bytes[$pc+1] | ( $bytes[$pc+2] << 8 ) ));
            $pc += 2
        }
        case ($imm) {
            printf(" #\$%02X", $bytes[$pc+1]);
            $pc++
        }
        # else {
        #     #insira comandos aqui
        # }
    }
    print("\n");
}
