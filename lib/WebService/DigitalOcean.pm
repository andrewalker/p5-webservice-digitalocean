package WebService::DigitalOcean;
# ABSTRACT: Access the DigitalOcean RESTful API (v2)
use Moo;
use Types::Standard qw/Str/;
use LWP::UserAgent;
use JSON ();
use DateTime;
use utf8;

with
    'WebService::DigitalOcean::Role::UserAgent',
    'WebService::DigitalOcean::Role::Domains',
    'WebService::DigitalOcean::Role::DomainRecords',
    'WebService::DigitalOcean::Role::Droplets',
    'WebService::DigitalOcean::Role::DropletActions',
    'WebService::DigitalOcean::Role::Keys',
    'WebService::DigitalOcean::Role::Regions',
    'WebService::DigitalOcean::Role::Sizes';

# VERSION

has api_base_url => (
    is      => 'ro',
    isa     => Str,
    default => sub { 'https://api.digitalocean.com/v2' }
);

has token => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

1;

__END__

=head1 SYNOPSIS

    use WebService::DigitalOcean;

    my $do = WebService::DigitalOcean->new(
        token => $TOKEN,
    );

    my $res = $do->domain_create(
        name => 'example.com',
        ip_address => '127.0.0.1',
    );

    if ($res->{is_success}) {
        say $res->{content}{domain}{name};
    }
    else {
        say "Could not create domain";
    }

=head1 DESCRIPTION

This module implements DigitalOceans new RESTful API.

It's on a very early stage of development, so expect new features, better docs
and tests very soon.

Patches welcome: L<< https://github.com/andrewalker/p5-webservice-digitalocean >>

=attr api_base_url

A string prepended to all API endpoints. By default, it's
https://api.digitalocean.com/v2. This can be adjusted to facilitate tests.

=attr token

The authorization token. It can be retrieved by logging into one's DigitalOcean
account, and generating a personal token here:
L<< https://cloud.digitalocean.com/settings/applications >>.

=head1 SEE ALSO

=over

=item *

L<DigitalOcean>: original DigitalOcean module, for v1 API.

=item *

L<< https://developers.digitalocean.com >>: Documentation for API v2, in DigitalOcean's website.

=item *

L<< Droplets role|WebService::DigitalOcean::Role::Droplets >>: Manage droplets with this module.

=item *

L<< Droplet Actions role|WebService::DigitalOcean::Role::DropletActions >>: Execute actions in droplets with this module.

=item *

L<< Domains role|WebService::DigitalOcean::Role::Domains >>: Manage domains with this module.

=item *

L<< Domain Records role|WebService::DigitalOcean::Role::DomainRecords >>: Manage domain records with this module.

=item *

L<< Keys role|WebService::DigitalOcean::Role::Keys >>: Manage SSH Keys with this module.

=item *

L<< Regions role|WebService::DigitalOcean::Role::Regions >>: Lists regions with this module.

=item *

L<< Sizes role|WebService::DigitalOcean::Role::Sizes >>: Lists sizes with this module.

=back

=head1 CAVEATS

This is alpha software. The interface is unstable, and may change without
notice.

Also, there are no real unit tests. We currently only test compilation and
instantiation of the module.
