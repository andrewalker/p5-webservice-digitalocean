package WebService::DigitalOcean::Role::Domains;
# ABSTRACT: Domains role for DigitalOcean WebService
use utf8;
use Moo::Role;
use feature 'state';
use Types::Standard qw/Str Object Dict/;
use Type::Utils;
use Type::Params qw/compile/;

requires 'make_request';

# VERSION

sub domain_create {
    state $check = compile(Object,
        Dict[
            name       => Str,
            ip_address => Str,
        ],
    );
    my ($self, $opts) = $check->(@_);

    return $self->make_request(POST => '/domains', $opts);
}

sub domain_list {
    state $check = compile(Object);
    my ($self) = $check->(@_);

    return $self->make_request(GET => '/domains');
}

sub domain_get {
    state $check = compile(Object, Str);
    my ($self, $domain) = $check->(@_);

    return $self->make_request(GET => "/domains/$domain");
}

sub domain_delete {
    state $check = compile(Object, Str);
    my ($self, $domain) = $check->(@_);

    return $self->make_request(DELETE => "/domains/$domain");
}

1;

=head1 DESCRIPTION

Implements the domain methods.

=method domain_create

=method domain_delete

=method domain_get

=method domain_list

See main documentation in L<WebService::DigitalOcean>.
