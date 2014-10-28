package WebService::DigitalOcean::Role::DropletActions;
# ABSTRACT: Droplet Actions role for DigitalOcean WebService
use utf8;
use Moo::Role;
use feature 'state';
use Types::Standard qw/Str Enum Object Dict Int/;
use Type::Utils;
use Type::Params qw/compile multisig/;

requires 'make_request';

# VERSION

sub droplet_resize {
    state $check = compile(
        Object,
        Dict[
            droplet => Int,
            size    => Str,
        ],
    );
    my ($self, $opts) = $check->(@_);

    $opts->{type} = 'resize';

    return $self->_droplet_action_start($opts);
}

sub droplet_change_kernel {
    state $check = compile(
        Object,
        Dict[
            droplet => Int,
            kernel  => Int,
        ],
    );
    my ($self, $opts) = $check->(@_);

    $opts->{type} = 'change_kernel';

    return $self->_droplet_action_start($opts);
}

sub droplet_rebuild {
    state $check = compile(
        Object,
        Dict[
            droplet => Int,
            image   => Str,
        ],
    );
    my ($self, $opts) = $check->(@_);

    $opts->{type} = 'rebuild';

    return $self->_droplet_action_start($opts);
}

sub droplet_restore {
    state $check = compile(
        Object,
        Dict[
            droplet => Int,
            image   => Str,
        ],
    );
    my ($self, $opts) = $check->(@_);

    $opts->{type} = 'restore';

    return $self->_droplet_action_start($opts);
}

sub droplet_rename {
    state $check = compile(
        Object,
        Dict[
            droplet => Int,
            name    => Str,
        ],
    );
    my ($self, $opts) = $check->(@_);

    $opts->{type} = 'rename';

    return $self->_droplet_action_start($opts);
}

sub droplet_snapshot {
    state $check = compile(
        Object,
        Dict[
            droplet => Int,
            name    => Str,
        ],
    );
    my ($self, $opts) = $check->(@_);

    $opts->{type} = 'snapshot';

    return $self->_droplet_action_start($opts);
}

{
    my $Check_Self_and_ID = compile( Object, Int );

    sub droplet_reboot {
        my ($self, $id) = $Check_Self_and_ID->(@_);

        return $self->_droplet_action_start({
            droplet => $id,
            action  => 'reboot',
        });
    }

    sub droplet_power_cycle {
        my ($self, $id) = $Check_Self_and_ID->(@_);

        return $self->_droplet_action_start({
            droplet => $id,
            action  => 'power_cycle',
        });
    }

    sub droplet_power_on {
        my ($self, $id) = $Check_Self_and_ID->(@_);

        return $self->_droplet_action_start({
            droplet => $id,
            action  => 'power_on',
        });
    }

    sub droplet_power_off {
        my ($self, $id) = $Check_Self_and_ID->(@_);

        return $self->_droplet_action_start({
            droplet => $id,
            action  => 'power_off',
        });
    }

    sub droplet_password_reset {
        my ($self, $id) = $Check_Self_and_ID->(@_);

        return $self->_droplet_action_start({
            droplet => $id,
            action  => 'password_reset',
        });
    }

    sub droplet_shutdown {
        my ($self, $id) = $Check_Self_and_ID->(@_);

        return $self->_droplet_action_start({
            droplet => $id,
            action  => 'shutdown',
        });
    }

    sub droplet_enable_ipv6 {
        my ($self, $id) = $Check_Self_and_ID->(@_);

        return $self->_droplet_action_start({
            droplet => $id,
            action  => 'enable_ipv6',
        });
    }

    sub droplet_enable_private_networking {
        my ($self, $id) = $Check_Self_and_ID->(@_);

        return $self->_droplet_action_start({
            droplet => $id,
            action  => 'enable_private_networking',
        });
    }

    sub droplet_disable_backups {
        my ($self, $id) = $Check_Self_and_ID->(@_);

        return $self->_droplet_action_start({
            droplet => $id,
            action  => 'disable_backups',
        });
    }
}

sub droplet_action_get {
    state $check = compile(
        Object,
        Dict[
            droplet => Int,
            action  => Int,
        ],
    );

    my ($self, $opts) = $check->(@_);

    return $self->make_request(GET => "/droplets/$opts->{droplet}/actions/$opts->{action}");
}

sub _droplet_action_start {
    my ($self, $opts) = @_;

    my $droplet = delete $opts->{droplet};

    return $self->make_request(POST => "/droplets/$droplet/actions", $opts);
}

1;

=head2 DESCRIPTION

Implements the droplets actions resource.

More info: L<< https://developers.digitalocean.com/#droplet-actions >>.

=method $do->droplet_resize(\%args)

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

=method $do->droplet_change_kernel(\%args)

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

=method $do->droplet_rebuild(\%args)

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

=method $do->droplet_restore(\%args)

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

=method $do->droplet_rename(\%args)

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

=method $do->droplet_snapshot(\%args)

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

=method $do->droplet_reboot($droplet_id)

=head3 Arguments

=over

=item C<Int> $droplet_id

=back

Reboots droplet.

    $do->droplet_reboot(123456);

More info: L<< https://developers.digitalocean.com/#reboot-a-droplet >>.

=method $do->droplet_power_cycle($droplet_id)

=head3 Arguments

=over

=item C<Int> $droplet_id

=back

Power cycles droplet.

    $do->droplet_power_cycle(123456);

More info: L<< https://developers.digitalocean.com/#power-cycle-a-droplet >>.

=method $do->droplet_power_on($droplet_id)

=head3 Arguments

=over

=item C<Int> $droplet_id

=back

Powers on droplet.

    $do->droplet_power_on(123456);

More info: L<< https://developers.digitalocean.com/#power-on-a-droplet >>.

=method $do->droplet_power_off($droplet_id)

=head3 Arguments

=over

=item C<Int> $droplet_id

=back

Powers off droplet.

    $do->droplet_power_off(123456);

More info: L<< https://developers.digitalocean.com/#power-off-a-droplet >>.

=method $do->droplet_password_reset($droplet_id)

=head3 Arguments

=over

=item C<Int> $droplet_id

=back

Resets the root password of the droplet.

    $do->droplet_password_reset(123456);

More info: L<< https://developers.digitalocean.com/#password-reset-a-droplet >>.

=method $do->droplet_shutdown($droplet_id)

=head3 Arguments

=over

=item C<Int> $droplet_id

=back

Shuts down a droplet

    $do->droplet_shutdown(123456);

More info: L<< https://developers.digitalocean.com/#shutdown-a-droplet >>.

=method $do->droplet_enable_ipv6($droplet_id)

=head3 Arguments

=over

=item C<Int> $droplet_id

=back

Enables IPv6 in a droplet.

    $do->droplet_enable_ipv6(123456);

More info: L<< https://developers.digitalocean.com/#enable-ipv6 >>.

=method $do->droplet_enable_private_networking($droplet_id)

=head3 Arguments

=over

=item C<Int> $droplet_id

=back

Enables private networking for a droplet.

    $do->droplet_enable_private_networking(123456);

More info: L<< https://developers.digitalocean.com/#enable-private-networking >>.

=method $do->droplet_disable_backups($droplet_id)

=head3 Arguments

=over

=item C<Int> $droplet_id

=back

Disables backups for the droplet.

    $do->droplet_disable_backups(123456);

More info: L<< https://developers.digitalocean.com/#disable-backups >>.

=method $do->droplet_action_get(\%args)

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
