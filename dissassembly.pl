use warnings;
use strict;
use autodie;


my $offset = 0;
my $buffer;

my @bytes;
open (FILE, "emulator.pl");
binmode FILE;

while ( read(FILE, $buffer, 1, $offset++) ) {
    push(@bytes, $buffer);
    $buffer = "";
}

