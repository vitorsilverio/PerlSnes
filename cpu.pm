package CPU;

use strict;
use warnings;
use Moose;

has 'A' => (is => 'rw');
has 'X' => (is => 'rw');
has 'Y' => (is => 'rw');
has 'P' => (is => 'rw');
has 'S' => (is => 'rw');
has 'PC' => (is => 'rw');

sub new {
    my ($class, %args) = @_;
    return bless { %args }, $class;
}