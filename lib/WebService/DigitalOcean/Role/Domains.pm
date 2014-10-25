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

=head2 DESCRIPTION

Implements the domain resource.

More info: L<< https://developers.digitalocean.com/#domains >>.

=method $do->domain_create(\%args)

=head3 Arguments

=over

=item C<Str> $args{name}

The domain name.

=item C<Str> $args{ip_address}

The IP address the domain will point to.

=back

Creates a new domain name.

    $do->domain_create({
        name       => 'example.com',
        ip_address => '12.34.56.78',
    });

More info: L<< https://developers.digitalocean.com/#create-a-new-domain >>.

=method $do->domain_delete($domain)

=head3 Arguments

=over

=item C<Str> $domain

The domain name.

=back

Deletes the specified domain.

    $do->domain_delete('example.com');

More info: L<< https://developers.digitalocean.com/#delete-a-domain >>.

=method $do->domain_get($domain)

=head3 Arguments

=over

=item C<Str> $domain

The domain name.

=back

Retrieves the specified domain.

    my $response = $do->domain_get('example.com');

More info: L<< https://developers.digitalocean.com/#retrieve-an-existing-domain >>.

=method $do->domain_list()

Lists all domains for this account.

    my $response = $do->domain_list();

    for (@{ $response->{content}{domains} }) {
        print $_->{id};
    }

More info: L<< https://developers.digitalocean.com/#list-all-domains >>.
