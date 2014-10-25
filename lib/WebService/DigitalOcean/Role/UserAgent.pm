package WebService::DigitalOcean::Role::UserAgent;
# ABSTRACT: User Agent Role for DigitalOcean WebService
use Moo::Role;
use LWP::UserAgent;
use JSON ();
use DateTime;
use utf8;

# VERSION

has ua => (
    is => 'lazy',
);

sub _build_ua {
    my ($self) = @_;

    my $version = __PACKAGE__->VERSION;
    $version ||= 'devel';

    my $ua = LWP::UserAgent->new(
        agent => 'WebService::DigitalOcean/' . $version,
    );

    $ua->default_header('Authorization' => 'Bearer ' . $self->token);
    $ua->default_header('Content-Type' => 'application/json; charset=utf-8');

    return $ua;
}

sub make_request {
    my ($self, $method, $uri, $data) = @_;

    my $response = $self->ua->request(
        HTTP::Request->new(
            $method,
            $self->api_base_url . $uri,
            undef,
            $data ? JSON::encode_json($data) : undef
        )
    );

    my $result = {
        response_object => $response,
        is_success      => $response->is_success,
        status_line     => $response->status_line,
    };

    if ($response->content_type eq 'application/json') {
        $result->{content} = JSON::decode_json($response->decoded_content);
    }

    if (my $ratelimit = $response->header('RateLimit-Limit')) {
        $result->{ratelimit} = {
            limit     => $ratelimit,
            remaining => $response->header('RateLimit-Remaining'),
            reset     => DateTime->from_epoch(
                epoch => $response->header('RateLimit-Reset')
            ),
        };
    }

    return $result;
}

1;

=head2 DESCRIPTION

Role used to make requests to the DigitalOcean API, and to format their response.

=method $res = $do->make_request($method, $path[, $data)

=head3 Arguments

=over

=item C<Str> $method

The HTTP verb, such as POST, GET, PUT, etc.

=item C<Str> $path

Path to the resource in the URI, to be prepended with $self->api_base_url.

=item C<HashRef> $data (optional)

The content to be JSON encoded and sent to DigitalOcean's API.

=back

=head3 Returns

HashRef containing:

=over

=item L<HTTP::Response> response_object

=item C<Bool> is_success

Shortcut to $res->{response_object}{is_success}.

=item C<Str> status_line

Shortcut to $res->{response_object}{status_line}.

=item C<HashRef> content

The JSON decoded content the API has responded with.

=item C<HashRef> ratelimit

RateLimit headers parsed.

=over

=item C<Int> limit

=item C<Int> remaining

=item L<DateTime> reset

=back

=back

Makes requests to the DigitalOcean, and parses the response.

All requests made from other methods use L</make_request> to make them.

    my $res = $self->make_request(POST => '/domains', {
        name       => 'example.com',
        ip_address => '12.34.56.78',
    });

B<Note:> this is how L<WebService::DigitalOcean::Role::Domains/domain_create>
is implemented. You shouldn't use this method directly in your application
whenever possible. It's kept as a public method only because the API isn't
entirely implemented in the module yet.

More info: L<< https://developers.digitalocean.com/#introduction >>.
