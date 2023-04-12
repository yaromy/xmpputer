package XMPputer::Command::Roll;

use warnings;
use strict;

use Games::Dice qw(roll roll_array);

use base "XMPputer::Command";

sub new {
    my $cls = shift;
    my $self = $cls->SUPER::new(@_);
    return $self;
}

sub match {
    my ($self, $msg) = @_;

    if ($msg =~ m/^\s*roll(?:a?)\s+[^\s]+/i) {
	return $self;
    }
    return undef;
}

sub answer {
    my $self = shift;
    my $params = shift;

    if ($params->msg =~ m/^\s*roll(a?)\s+([^\s].*?)\s*$/i) {
	my $array = $1;
	my $dice = $2;
	if ($array) {
	    my @throws = roll_array $dice;
	    return join(" + ", @throws)." = ".List::Util::sum(@throws);
	} else {
	    return roll $dice;
	}
    }

    return "Bad roll command\n";
}

sub allow {
    my $self = shift;
    my $params = shift;

    return $params->acl->allow("roll", $params);
}

sub name {
    return "roll";
}

1;
