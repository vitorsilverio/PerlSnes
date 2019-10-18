package CPU;

use strict;
use warnings;
use Moose;

# A CPU do SNES é uma versão 16 bits da do NES e é a mesma utilizada pelos computadores Apple II
# A cpu executa instruções de maquina
# as operações normalmente são feitas nos registradores e no barramento
# o que vamos entender primeiro são os registradores
# a do SNES tem os seguintes registradores:
# A
# também conhecido como acumulator(acumulador)
# é utilizado para as instruções aritméticas
# X e Y são registradores limitados a indexação
# se você quer acessar algum endereço de memoria você vai jogar o valor dentro de X ou de Y para definir a
# posição de memoria que quer acessar
# temos o registrador P
# é o registrador de flags
# ele guarda status das operações
# por exemplo se uma operação matematica deu 0 ele vai ativar a flag zero
# se deu overflow ele ativa a flag indicando que deu overflow
# cada bit nesse registrador é uma flag
# o registrador PC
# é o program counter
# ele guarda a posição da proxima instrução a ser executada
# lembre-se que o memoria é um array
# se você ta lendo indice por indice voce precisa de um lugar para guardar qual a instrução ta sendo executada
# o registrador S é o registrador de stack (pilha)
# ele guarda o endereço de onde ta o topo da pilha
# tem mais 3 registradores, que são um pouco mais complicados, mas também são para controle de endereços
# eu explico eles depois
# portanto a nossa CPU começa com esses membros inicialmente:

has 'A' => (is => 'rw');
# O registrador X não pode ser usado para contas aritméticas (provavelmente só o A pode)
has 'X' => (is => 'rw');
has 'Y' => (is => 'rw');

# o registrador P é chamado Flags register
# ele não guarda exatamente um valor mas sim estados
# cada um dos oito bits desse registrador tem um significado
# quando o valor do bit for 1
# quer dizer que o status ocorreu anteriormente
# quando 0
# quer dizer que aquele status não aconteceu
#aqui vai a lista dos 8 status que esse registrador representa
#bit 7 - Flag N- negative
#bit 6 - Flag V - Overflow
#bit 5 - Flag M - Acummulator mode (0 - 16 bits, 1 - 8bits)
#bit 4 - Flag X - Index mode (0 - 16 bits, 1 - 8bits)
#bit 3 - Flag D - Decimal (Esse eu explico muito num futuro, é o caso de DAA)
#bit 2 - Flag I - Interrupções ativas (vou explicar na parte de interrupções)
#bit 1 - Flag Z - Zero
#bit 0 - Flag C - Carry
has 'P' => (is => 'rw');
has 'S' => (is => 'rw');
has 'PC' => (is => 'rw');


sub new {
    my ($class, %args) = @_;
    return bless { %args }, $class;
}

# Load/Store Instructions
# Instruction     Description
# LDA     Load accumulator from memory
sub LDA {
    my ($class, $value) = @_;
    # TODO finish this
}

# LDX     Load register X from memory
sub LDX {
    my ($class, $value) = @_;
    # TODO finish this
}

# LDY     Load register Y from memory
sub LDY {
    my ($class, $value) = @_;
    # TODO finish this
}

# STA     Store accumulator in memory
sub STA {
    my ($class, $value) = @_;
    # TODO finish this
}

# STX     Store register X in memory
sub STX {
    my ($class, $value) = @_;
    # TODO finish this
}

# STY     Store register Y in memory
sub STY {
    my ($class, $value) = @_;
    # TODO finish this
}

# STZ     Store zero in memory
sub STZ {
    my ($class, $value) = @_;
    # TODO finish this
}
