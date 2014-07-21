package WebService::DigitalOcean::Role::Droplets;
# ABSTRACT: Droplets role for DigitalOcean WebService
use utf8;
use Moo::Role;
use feature 'state';
use Types::Standard qw/Str Object slurpy Dict ArrayRef Optional Bool Int/;
use Type::Utils;
use Type::Params qw/compile/;

requires 'make_request';

# VERSION

sub droplet_create {
    state $check = compile(Object,
        slurpy Dict[
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
    state $check = compile(Object,
        slurpy Dict[
            id => Int,
        ],
    );
    my ($self, $opts) = $check->(@_);

    return $self->make_request(GET => "/droplets/$opts->{id}");
}

sub droplet_delete {
    state $check = compile(Object,
        slurpy Dict[
            id => Str,
        ],
    );
    my ($self, $opts) = $check->(@_);

    return $self->make_request(DELETE => "/droplets/$opts->{id}");
}

1;

=method droplet_create

=head3 Arguments

=over

=item Str name

=item Str region

=item Str size

=item Str image

=item Optional[ ArrayRef ] ssh_keys

=item Optional[ Bool ] backups

=item Optional[ Bool ] ipv6

=item Optional[ Bool ] private_networking

=back

Creates a new droplet.

    $do->droplet_create(
        name               => "My-Droplet",
        region             => "nyc1",
        size               => "512mb",
        image              => 449676389,
        ssh_keys           => [ 52341234, 215124, 64325534 ],
        backups            => 0,
        ipv6               => 1,
        private_networking => 0,
    );

=method droplet_delete

=head3 Arguments

=over

=item Int id

=back

Deletes the specified droplet.

    $do->droplet_delete(
        id => 1250928,
    );

=method droplet_get

=head3 Arguments

=over

=item Int id

=back

Retrieves the specified droplet.

    my $response = $do->droplet_get(
        droplet => 15314123,
    );

=method droplet_list

Lists all droplets for this account.

    my $response = $do->droplet_list();

    for (@{ $response->{content}{droplets} }) {
        print $_->{id};
    }
