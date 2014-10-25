package WebService::DigitalOcean::Role::Regions;
# ABSTRACT: Regions role for DigitalOcean WebService
use utf8;
use Moo::Role;
use feature 'state';
use Types::Standard qw/Object/;
use Type::Utils;
use Type::Params qw/compile/;

requires 'make_request';

# VERSION

sub region_list {
    state $check = compile(Object);
    my ($self, $opts) = $check->(@_);

    return $self->make_request(GET => "/regions");
}

1;

=head2 DESCRIPTION

Implements the Regions resource.

More info: L<< https://developers.digitalocean.com/#regions >>.

=method $do->region_list()

Retrieves all the regions available in Digital Ocean.

    my $regions = $do->region_list();

    for my $r (@{ $regions->{content}{regions} }) {
        if ($r->{available}) {
            say "$r->{name} is available";
        }
    }

More info: L<< https://developers.digitalocean.com/#list-all-regions >>.
