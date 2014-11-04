package WebService::DigitalOcean::Role::Sizes;
# ABSTRACT: Sizes role for DigitalOcean WebService
use utf8;
use Moo::Role;
use feature 'state';
use Types::Standard qw/Object/;
use Type::Utils;
use Type::Params qw/compile/;

requires 'make_request';

# VERSION

sub size_list {
    state $check = compile(Object);
    my ($self, $opts) = $check->(@_);

    return $self->make_request(GET => "/sizes");
}

1;

=head1 DESCRIPTION

Implements the Sizes resource.

=method size_list

See main documentation in L<WebService::DigitalOcean>.
