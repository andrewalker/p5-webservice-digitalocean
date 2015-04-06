package WebService::DigitalOcean::Role::DropletActions;
# ABSTRACT: Droplet Actions role for DigitalOcean WebService
use utf8;
use Moo::Role;
use feature 'state';
use Types::Standard qw/Str Enum Object Dict Int Bool/;
use Type::Utils;
use Type::Params qw/compile multisig/;

requires 'make_request';

# VERSION

sub droplet_resize {
    state $check = compile(
        Object,
        Dict[
            droplet => Int,
            disk    => Bool,
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
            type    => 'reboot',
        });
    }

    sub droplet_power_cycle {
        my ($self, $id) = $Check_Self_and_ID->(@_);

        return $self->_droplet_action_start({
            droplet => $id,
            type    => 'power_cycle',
        });
    }

    sub droplet_power_on {
        my ($self, $id) = $Check_Self_and_ID->(@_);

        return $self->_droplet_action_start({
            droplet => $id,
            type    => 'power_on',
        });
    }

    sub droplet_power_off {
        my ($self, $id) = $Check_Self_and_ID->(@_);

        return $self->_droplet_action_start({
            droplet => $id,
            type    => 'power_off',
        });
    }

    sub droplet_password_reset {
        my ($self, $id) = $Check_Self_and_ID->(@_);

        return $self->_droplet_action_start({
            droplet => $id,
            type    => 'password_reset',
        });
    }

    sub droplet_shutdown {
        my ($self, $id) = $Check_Self_and_ID->(@_);

        return $self->_droplet_action_start({
            droplet => $id,
            type    => 'shutdown',
        });
    }

    sub droplet_enable_ipv6 {
        my ($self, $id) = $Check_Self_and_ID->(@_);

        return $self->_droplet_action_start({
            droplet => $id,
            type    => 'enable_ipv6',
        });
    }

    sub droplet_enable_private_networking {
        my ($self, $id) = $Check_Self_and_ID->(@_);

        return $self->_droplet_action_start({
            droplet => $id,
            type    => 'enable_private_networking',
        });
    }

    sub droplet_disable_backups {
        my ($self, $id) = $Check_Self_and_ID->(@_);

        return $self->_droplet_action_start({
            droplet => $id,
            type    => 'disable_backups',
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

=head1 DESCRIPTION

Implements the droplets actions methods.

=method droplet_action_get

=method droplet_resize

=method droplet_change_kernel

=method droplet_rebuild

=method droplet_restore

=method droplet_rename

=method droplet_snapshot

=method droplet_reboot

=method droplet_power_cycle

=method droplet_power_on

=method droplet_power_off

=method droplet_password_reset

=method droplet_shutdown

=method droplet_enable_ipv6

=method droplet_enable_private_networking

=method droplet_disable_backups

See main documentation in L<WebService::DigitalOcean>.
