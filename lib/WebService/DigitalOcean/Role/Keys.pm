package WebService::DigitalOcean::Role::Keys;
# ABSTRACT: Keys role for DigitalOcean WebService
use utf8;
use Moo::Role;
use feature 'state';
use Types::Standard qw/Str Int Object slurpy Dict Optional/;
use Type::Utils;
use Type::Params qw/compile/;

requires 'make_request';

# VERSION

sub key_create {
    state $check = compile(Object,
        slurpy Dict[
            name       => Str,
            public_key => Str,
        ],
    );
    my ($self, $opts) = $check->(@_);

    return $self->make_request(POST => "/account/keys", $opts);
}

sub key_list {
    state $check = compile(Object);
    my ($self, $opts) = $check->(@_);

    return $self->make_request(GET => "/account/keys");
}

sub key_get {
    state $check = compile(Object,
        slurpy Dict[
            fingerprint => Optional[Str],
            id          => Optional[Int],
        ],
    );
    my ($self, $opts) = $check->(@_);

    my $id = $opts->{id} || $opts->{fingerprint};

    return $self->make_request(GET => "/account/keys/$id");
}

sub key_delete {
    state $check = compile(Object,
        slurpy Dict[
            fingerprint => Optional[Str],
            id          => Optional[Int],
        ],
    );
    my ($self, $opts) = $check->(@_);

    my $id = $opts->{id} || $opts->{fingerprint};

    return $self->make_request(DELETE => "/account/keys/$id");
}

1;

=method key_create

=head3 Arguments

=over

=item Str name

=item Str public_key

=back

Creates a new ssh key for this account.

    my $response = $do->key_create(
        name => 'my public key',
        public_key => <$public_key_fh>,
    );

=method key_delete

=head3 Arguments

=over

=item Int id

=item Str fingerprint

=back

Deletes the specified ssh key.

    $do->key_delete(
        id => 146432
    );

=method key_get

=head3 Arguments

=over

=item Int id

=item Str fingerprint

=back

Retrieves details about a particular ssh key, identified by id or fingerprint (pick one).

    my $response = $do->key_get(
        id => 1215,
    );

=method key_list

Retrieves all the keys for this account.
