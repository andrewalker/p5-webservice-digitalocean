package WebService::DigitalOcean::Role::Regions;
# ABSTRACT: Regions role for DigitalOcean WebService
use utf8;
use Moo::Role;
use feature 'state';
use Types::Standard qw/Object/;
use Type::Utils;
use Type::Params qw/compile/;

requires 'make_request';

# VERSION

sub region_list {
    state $check = compile(Object);
    my ($self, $opts) = $check->(@_);

    return $self->make_request(GET => "/regions");
}

1;

=head1 DESCRIPTION

Implements the Regions resource.

=method region_list

See main documentation in L<WebService::DigitalOcean>.
