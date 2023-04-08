package XMPputer::Commands::Parameters;

use strict;
use warnings;

use AnyEvent::XMPP::Util qw/node_jid res_jid split_jid bare_jid/;

sub new {
    my $cls = shift;
    my $self = bless {}, $cls;
    my %args = @_;
    foreach my $arg (keys %args) {
	$self->{"_$arg"} = $args{$arg};
    }
    return $self;
}

sub msg {
    my $self = shift;
    return $self->{_msg};
}

sub from {
    my $self = shift;
    return $self->{_from};
}

sub jid {
    my $self = shift;
    return $self->{_jid} if $self->{_jid};
    $self->{_jid} = bare_jid($self->from);
    return $self->{_jid};
}

sub acl {
    my $self = shift;
    return $self->{_acl};
}

sub room_member {
    my $self = shift;
    return $self->{_room_member};
}

sub room_member_withor_jid {
    my $self = shift;
    if ($self->room_member) {
	return $self->room_member." (".$self->jid.")";
    } else {
	return $self->jid
    }
}

1;