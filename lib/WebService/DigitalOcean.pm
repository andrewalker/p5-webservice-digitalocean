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

    my $do = WebService::DigitalOcean->new({ token => $TOKEN });

    my $res = $do->domain_create({
        name => 'example.com',
        ip_address => '127.0.0.1',
    });

    if ($res->{is_success}) {
        say $res->{content}{name};
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

=head1 METHODS

=head2 $do->domain_create(\%args)

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

=head2 $do->domain_delete($domain)

=head3 Arguments

=over

=item C<Str> $domain

The domain name.

=back

Deletes the specified domain.

    $do->domain_delete('example.com');

More info: L<< https://developers.digitalocean.com/#delete-a-domain >>.

=head2 $do->domain_get($domain)

=head3 Arguments

=over

=item C<Str> $domain

The domain name.

=back

Retrieves the specified domain.

    my $response = $do->domain_get('example.com');

More info: L<< https://developers.digitalocean.com/#retrieve-an-existing-domain >>.

=head2 $do->domain_list()

Lists all domains for this account.

    my $response = $do->domain_list();

    for (@{ $response->{content} }) {
        print $_->{id};
    }

More info: L<< https://developers.digitalocean.com/#list-all-domains >>.

=head2 $do->domain_record_create(\%args)

=head3 Arguments

=over

=item C<Str> $args{domain}

The domain under which the record will be created.

=item C<Str> $args{type}

The type of the record (eg MX, CNAME, A, etc).

=item C<Str> $args{name} (optional)

The name of the record.

=item C<Str> $args{data} (optional)

The data (such as the IP address) of the record.

=item C<Int> $args{priority} (optional)

Priority, for MX or SRV records.

=item C<Int> $args{port} (optional)

The port, for SRV records.

=item C<Int> $args{weight} (optional)

The weight, for SRV records.

=back

Creates a new record for a domain.

    my $response = $do->domain_record_create({
        domain => 'example.com',
        type   => 'A',
        name   => 'www2',
        data   => '12.34.56.78',
    });

    my $id = $response->{content}{id};

More info: L<< https://developers.digitalocean.com/#create-a-new-domain-record >>.

=head2 $do->domain_record_delete(\%args)

=head3 Arguments

=over

=item C<Str> $args{domain}

The domain to which the record belongs.

=item C<Int> $args{id}

The id of the record.

=back

Deletes the specified record.

    $do->domain_record_delete({
        domain => 'example.com',
        id     => 1215,
    });

More info: L<< https://developers.digitalocean.com/#delete-a-domain-record >>.

=head2 $do->domain_record_get(\%args)

=head3 Arguments

=over

=item C<Str> $args{domain}

The domain to which the record belongs.

=item C<Int> $args{id}

The id of the record.

=back

Retrieves details about a particular record, identified by id.

    my $response = $do->domain_record_get({
        domain => 'example.com',
        id     => 1215,
    });

    my $ip = $response->{content}{data};

More info: L<< https://developers.digitalocean.com/#retrieve-an-existing-domain-record >>.

=head2 $do->domain_record_list($domain)

=head3 Arguments

=over

=item C<Str> $domain

The domain to which the records belong.

=back

Retrieves all the records for a particular domain.

    my $response = $do->domain_record_list('example.com');

    for (@{ $response->{content} }) {
        print "$_->{name} => $_->{data}\n";
    }

More info: L<< https://developers.digitalocean.com/#list-all-domain-records >>.

=head2 $do->droplet_create(\%args)

=head3 Arguments

=over

=item C<Str> $args{name}

=item C<Str> $args{region}

=item C<Str> $args{size}

=item C<Str> $args{image}

=item C<ArrayRef> $args{ssh_keys} (optional)

=item C<Bool> $args{backups} (optional)

=item C<Bool> $args{ipv6} (optional)

=item C<Bool> $args{private_networking} (optional)

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

More info: L<< https://developers.digitalocean.com/#create-a-new-droplet >>.

=head2 $do->droplet_delete($id)

=head3 Arguments

=over

=item C<Int> $id

=back

Deletes the specified droplet.

    $do->droplet_delete(1250928);

More info: L<< https://developers.digitalocean.com/#delete-a-droplet >>.

=head2 $do->droplet_get($id)

=head3 Arguments

=over

=item C<Int> $id

=back

Retrieves the specified droplet.

    my $response = $do->droplet_get(15314123);

More info: L<< https://developers.digitalocean.com/#retrieve-an-existing-droplet-by-id >>.

=head2 $do->droplet_list()

Lists all droplets for this account.

    my $response = $do->droplet_list();

    for (@{ $response->{content} }) {
        print $_->{id};
    }

More info: L<< https://developers.digitalocean.com/#list-all-droplets >>.

=head2 $do->droplet_resize(\%args)

=head3 Arguments

=over

=item C<Int> $args{droplet}

=item C<Str> $args{size}

=back

Resizes a droplet.

    $do->droplet_resize({
        droplet => 123456,
        size    => '1gb',
    });

More info: L<< https://developers.digitalocean.com/#resize-a-droplet >>.

=head2 $do->droplet_change_kernel(\%args)

=head3 Arguments

=over

=item C<Int> $args{droplet}

=item C<Int> $args{kernel}

=back

Changes the kernel of a droplet.

    $do->droplet_change_kernel({
        droplet => 123456,
        kernel  => 654321,
    });

More info: L<< https://developers.digitalocean.com/#change-the-kernel >>.

=head2 $do->droplet_rebuild(\%args)

=head3 Arguments

=over

=item C<Int> $args{droplet}

=item C<Str> $args{image}

=back

Rebuilds a droplet.

    $do->droplet_rebuild({
        droplet => 123456,
        image   => 654321,
    });

More info: L<< https://developers.digitalocean.com/#rebuild-a-droplet >>.

=head2 $do->droplet_restore(\%args)

=head3 Arguments

=over

=item C<Int> $args{droplet}

=item C<Str> $args{image}

=back

Restores a droplet to an image backup.

    $do->droplet_rebuild({
        droplet => 123456,
        image   => 654321,
    });

More info: L<< https://developers.digitalocean.com/#restore-a-droplet >>.

=head2 $do->droplet_rename(\%args)

=head3 Arguments

=over

=item C<Int> $args{droplet}

=item C<Str> $args{name}

=back

Renames a droplet, thus setting the reverse DNS.

    $do->droplet_rename({
        droplet => 123456,
        name    => 'new-name',
    });

More info: L<< https://developers.digitalocean.com/#rename-a-droplet >>.

=head2 $do->droplet_snapshot(\%args)

=head3 Arguments

=over

=item C<Int> $args{droplet}

=item C<Str> $args{name}

=back

Saves a snapshopt of the droplet.

    $do->droplet_rebuild({
        droplet => 123456,
        name    => 'snapshot-name',
    });

More info: L<< https://developers.digitalocean.com/#rebuild-a-droplet >>.

=head2 $do->droplet_reboot($droplet_id)

=head3 Arguments

=over

=item C<Int> $droplet_id

=back

Reboots droplet.

    $do->droplet_reboot(123456);

More info: L<< https://developers.digitalocean.com/#reboot-a-droplet >>.

=head2 $do->droplet_power_cycle($droplet_id)

=head3 Arguments

=over

=item C<Int> $droplet_id

=back

Power cycles droplet.

    $do->droplet_power_cycle(123456);

More info: L<< https://developers.digitalocean.com/#power-cycle-a-droplet >>.

=head2 $do->droplet_power_on($droplet_id)

=head3 Arguments

=over

=item C<Int> $droplet_id

=back

Powers on droplet.

    $do->droplet_power_on(123456);

More info: L<< https://developers.digitalocean.com/#power-on-a-droplet >>.

=head2 $do->droplet_power_off($droplet_id)

=head3 Arguments

=over

=item C<Int> $droplet_id

=back

Powers off droplet.

    $do->droplet_power_off(123456);

More info: L<< https://developers.digitalocean.com/#power-off-a-droplet >>.

=head2 $do->droplet_password_reset($droplet_id)

=head3 Arguments

=over

=item C<Int> $droplet_id

=back

Resets the root password of the droplet.

    $do->droplet_password_reset(123456);

More info: L<< https://developers.digitalocean.com/#password-reset-a-droplet >>.

=head2 $do->droplet_shutdown($droplet_id)

=head3 Arguments

=over

=item C<Int> $droplet_id

=back

Shuts down a droplet

    $do->droplet_shutdown(123456);

More info: L<< https://developers.digitalocean.com/#shutdown-a-droplet >>.

=head2 $do->droplet_enable_ipv6($droplet_id)

=head3 Arguments

=over

=item C<Int> $droplet_id

=back

Enables IPv6 in a droplet.

    $do->droplet_enable_ipv6(123456);

More info: L<< https://developers.digitalocean.com/#enable-ipv6 >>.

=head2 $do->droplet_enable_private_networking($droplet_id)

=head3 Arguments

=over

=item C<Int> $droplet_id

=back

Enables private networking for a droplet.

    $do->droplet_enable_private_networking(123456);

More info: L<< https://developers.digitalocean.com/#enable-private-networking >>.

=head2 $do->droplet_disable_backups($droplet_id)

=head3 Arguments

=over

=item C<Int> $droplet_id

=back

Disables backups for the droplet.

    $do->droplet_disable_backups(123456);

More info: L<< https://developers.digitalocean.com/#disable-backups >>.

=head2 $do->droplet_action_get(\%args)

=head3 Arguments

=over

=item C<Int> $args{droplet}

=item C<Int> $args{action}

=back

Retrieve details from a specific action.

    $do->droplet_action_get({
        droplet => 123456,
        action  => 53,
    });

More info: L<< https://developers.digitalocean.com/#retrieve-a-droplet-action >>.

=head2 $do->key_create(\%args)

=head3 Arguments

=over

=item C<Str> $args{name}

=item C<Str> $args{public_key}

=back

Creates a new ssh key for this account.

    my $response = $do->key_create({
        name       => 'my public key',
        public_key => <$public_key_fh>,
    });

More info: L<< https://developers.digitalocean.com/#create-a-new-key >>.

=head2 $do->key_delete(\%args)

=head3 Arguments

=over

=item C<Int> $args{id} I<OR>

=item C<Str> $args{fingerprint}

=back

Deletes the specified ssh key.

    $do->key_delete({ id => 146432 });

More info: L<< https://developers.digitalocean.com/#destroy-a-key >>.

=head2 $do->key_get(\%args)

=head3 Arguments

=over

=item C<Int> $args{id} I<OR>

=item C<Str> $args{fingerprint}

=back

Retrieves details about a particular ssh key, identified by id or fingerprint (pick one).

    my $response = $do->key_get({ id => 1215 });

More info: L<< https://developers.digitalocean.com/#retrieve-an-existing-key >>.

=head2 $do->key_list()

Retrieves all the keys for this account.

More info: L<< https://developers.digitalocean.com/#list-all-keys >>.

=head2 $do->region_list()

Retrieves all the regions available in Digital Ocean.

    my $regions = $do->region_list();

    for my $r (@{ $regions->{content} }) {
        if ($r->{available}) {
            say "$r->{name} is available";
        }
    }

More info: L<< https://developers.digitalocean.com/#list-all-regions >>.

=head2 $do->size_list()

Retrieves all the sizes available in Digital Ocean.

    my $sizes = $do->size_list();

    for my $s (@{ $sizes->{content} }) {
        say "Size $s->{slug} costs $s->{price_hourly} per hour.";
    }

More info: L<< https://developers.digitalocean.com/#list-all-sizes >>.

=head1 SEE ALSO

=over

=item L<DigitalOcean>

First DigitalOcean module, uses v1 API. It has a more OO
approach than this module, and might have a more stable interface at the
moment.

=item L<< https://developers.digitalocean.com >>

Documentation for API v2, in DigitalOcean's website.

=back

=head1 CAVEATS

This is alpha software. The interface is unstable, and may change without
notice.

Also, there are no real unit tests. We currently only test compilation and
instantiation of the module.
