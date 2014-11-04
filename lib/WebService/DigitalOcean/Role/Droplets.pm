package WebService::DigitalOcean::Role::Droplets;
# ABSTRACT: Droplets role for DigitalOcean WebService
use utf8;
use Moo::Role;
use feature 'state';
use Types::Standard qw/Str Object Dict ArrayRef Optional Bool Int/;
use Type::Utils;
use Type::Params qw/compile/;

requires 'make_request';

# VERSION

sub droplet_create {
    state $check = compile(Object,
        Dict[
            name               => Str,
            region             => Str,
            size               => Str,
            image              => Str,
            ssh_keys           => Optional[ ArrayRef ],
            backups            => Optional[ Bool ],
            ipv6               => Optional[ Bool ],
            private_networking => Optional[ Bool ],
        ],
    );
    my ($self, $opts) = $check->(@_);

    return $self->make_request(POST => '/droplets', $opts);
}

sub droplet_list {
    state $check = compile(Object);
    my ($self) = $check->(@_);

    return $self->make_request(GET => '/droplets');
}

sub droplet_get {
    state $check = compile(Object, Int);
    my ($self, $id) = $check->(@_);

    return $self->make_request(GET => "/droplets/$id");
}

sub droplet_delete {
    state $check = compile(Object, Int);
    my ($self, $id) = $check->(@_);

    return $self->make_request(DELETE => "/droplets/$id");
}

1;

=head1 DESCRIPTION

Implements the droplets methods.

=method droplet_create

=method droplet_list

=method droplet_get

=method droplet_delete

See main documentation in L<WebService::DigitalOcean>.
