package XMPputer::Command::Authorize;

use warnings;
use strict;

use AnyEvent::XMPP::Util qw/node_jid res_jid split_jid bare_jid/;

sub new {
    my $cls = shift;
    my %args = @_;
    my $self = bless {}, $cls;
    $self->{acl} = $args{acl};
    return $self;
}

sub match {
    my ($self, $msg) = @_;

    if ($msg =~ m/^\s*(de)?authorize\s+[^\s]+\s+[^\s]+\s*$/) {
	return $self;
    }
    return undef;
}

sub answer {
    my $self = shift;
    my $params = shift;

    if ($params->msg =~ m/^\s*(de)?authorize\s+([^\s]+)\s+([^\s]+)\s*$/) {
	my $deauth = $1;
	my $who = $2;
	my $what = $3;
	$self->{acl}{acl}{$what} //= [];
	if ($params->room_member and index($who, "@") < 0) {
	    $who = join("/", bare_jid($params->room_member), $who);
	}
	if ($deauth) {
	    $self->{acl}{acl}{$what} = [grep {$_ ne $who} @{$self->{acl}{acl}{$what}}];
	    return "$who deauthorized from $what";
	} else {
	    push @{$self->{acl}{acl}{$what}}, $who;
	    return "$who authorized to $what";
	}
    }

    return "Bad (de)authorize command\n";
}

sub allow {
    my $self = shift;
    my $params = shift;

    return $params->acl->allow($params->msg =~ s/^\s*((?:de)?authorize)\s+.*/$1/r, $params);
}

sub name {
    my ($self, $msg) = @_;
    return $msg =~ s/^\s*([^\s]+).*/$1/r;
}

1;
