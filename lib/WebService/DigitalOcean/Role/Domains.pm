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
    my ($self, $opts) = $check->(@_);

    return $self->make_request(POST => '/domains', $opts);
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
    my ($self, $opts) = $check->(@_);

    return $self->make_request(GET => "/domains/$opts->{domain}");
}

sub domain_delete {
    state $check = compile(Object,
        slurpy Dict[
            domain => Str,
        ],
    );
    my ($self, $opts) = $check->(@_);

    return $self->make_request(DELETE => "/domains/$opts->{domain}");
}

1;

=method domain_create

=head3 Arguments

=over

=item Str name

The domain name.

=item Str ip_address

The IP address the domain will point to.

=back

Creates a new domain name.

    $do->domain_create(
        name => 'example.com',
        ip_address => '12.34.56.78',
    );

=method domain_delete

=head3 Arguments

=over

=item Str domain

The domain name.

=back

Deletes the specified domain.

    $do->domain_delete(
        domain => 'example.com',
    );

=method domain_get

=head3 Arguments

=over

=item Str domain

The domain name.

=back

Retrieves the specified domain.

    my $response = $do->domain_get(
        domain => 'example.com',
    );

=method domain_list

Lists all domains for this account.

    my $response = $do->domain_list();

    for (@{ $response->{content}{domains} }) {
        print $_->{id};
    }
