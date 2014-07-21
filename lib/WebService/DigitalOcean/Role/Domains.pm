package WebService::DigitalOcean::Role::Domains;
# ABSTRACT: Domains role for DigitalOcean WebService
use utf8;
use Moo::Role;
use feature 'state';
use Types::Standard qw/Str Object slurpy Dict/;
use Type::Utils;
use Type::Params qw/compile/;

requires 'make_request';

# VERSION

sub domain_create {
    state $check = compile(Object,
        slurpy Dict[
            name => Str,
            ip_address => Str,
        ],
    );
    my ($self, %opts) = $check->(@_);

    return $self->make_request(POST => '/domains', \%opts);
}

sub domain_list {
    state $check = compile(Object);
    my ($self) = $check->(@_);

    return $self->make_request(GET => '/domains');
}

sub domain_get {
    state $check = compile(Object,
        slurpy Dict[
            domain => Str,
        ],
    );
    my ($self, %opts) = $check->(@_);

    return $self->make_request(GET => "/domains/$opts{domain}");
}

sub domain_delete {
    state $check = compile(Object,
        slurpy Dict[
            domain => Str,
        ],
    );
    my ($self, %opts) = $check->(@_);

    return $self->make_request(DELETE => "/domains/$opts{domain}");
}

1;

=method domain_create

=method domain_delete

=method domain_get

=method domain_list
