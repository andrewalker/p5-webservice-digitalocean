package WebService::DigitalOcean::Role::DomainRecords;
# ABSTRACT: Domain Records role for DigitalOcean WebService
use utf8;
use Moo::Role;
use feature 'state';
use Types::Standard qw/Str Int Object Dict Optional/;
use Type::Utils;
use Type::Params qw/compile/;

requires 'make_request';

# VERSION

sub domain_record_create {
    state $check = compile(Object,
        Dict[
            domain   => Str,
            type     => Str,
            name     => Optional[Str],
            data     => Optional[Str],
            ttl      => Optional[Int],
            priority => Optional[Int],
            port     => Optional[Int],
            weight   => Optional[Int],
        ],
    );
    my ($self, $opts) = $check->(@_);

    my $domain = delete $opts->{domain};

    return $self->make_request(POST => "/domains/$domain/records", $opts);
}

sub domain_record_list {
    state $check = compile(Object, Str);
    my ($self, $domain) = $check->(@_);

    return $self->make_request(GET => "/domains/$domain/records");
}

sub domain_record_get {
    state $check = compile(Object,
        Dict[
            domain => Str,
            id     => Int,
        ],
    );
    my ($self, $opts) = $check->(@_);

    return $self->make_request(GET => "/domains/$opts->{domain}/records/$opts->{id}");
}

sub domain_record_delete {
    state $check = compile(Object,
        Dict[
            domain => Str,
            id     => Int,
        ],
    );
    my ($self, $opts) = $check->(@_);

    return $self->make_request(DELETE => "/domains/$opts->{domain}/records/$opts->{id}");
}

# TODO:
# domain_record_update

1;

=head1 DESCRIPTION

Implements the domain records methods.

=method domain_record_create

=method domain_record_delete

=method domain_record_get

=method domain_record_list

See main documentation in L<WebService::DigitalOcean>.
