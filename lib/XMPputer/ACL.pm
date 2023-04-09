package XMPputer::ACL;

use warnings;
use strict;

use List::Util qw(any);
use AnyEvent::XMPP::Util qw/node_jid res_jid split_jid bare_jid/;

sub new {
    my $cls = shift;
    my $self = bless {}, $cls;
    $self->read_file("/dev/null");
    return $self;
}

sub read_file {
    my $self = shift;
    my $file = shift;

    $self->{acl} = {ALL => []};
    open(ACL, "<$file") or die "can't read acl file";
    foreach my $acl (<ACL>) {
	my ($key, $value) = split /\s+/, $acl, 2;
	chomp($value);
	$self->{acl}{$key} //= [];
	push @{$self->{acl}{$key}}, $value;
    }
    close(ACL);
}

sub allow {
    my ($self, $command, $params) = @_;

    $self->{acl}{$command} //= [];
    return any { 0
		   or $params->jid eq $_
		   or "ALL" eq $_
		   or ($params->room_member and $params->room_member eq $_)
		   or ($params->room_member and bare_jid($params->room_member)."/*" eq $_)
	       } (@{$self->{acl}{$command}}, @{$self->{acl}{ALL}});
}

1;
