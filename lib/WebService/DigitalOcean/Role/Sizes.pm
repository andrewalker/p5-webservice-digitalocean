package WebService::DigitalOcean::Role::Sizes;
# ABSTRACT: Sizes role for DigitalOcean WebService
use utf8;
use Moo::Role;
use feature 'state';
use Types::Standard qw/Object/;
use Type::Utils;
use Type::Params qw/compile/;

requires 'make_request';

# VERSION

sub size_list {
    state $check = compile(Object);
    my ($self, $opts) = $check->(@_);

    return $self->make_request(GET => "/sizes");
}

1;

=head2 DESCRIPTION

Implements the Sizes resource.

More info: L<< https://developers.digitalocean.com/#sizes >>.

=method $do->size_list()

Retrieves all the sizes available in Digital Ocean.

    my $sizes = $do->size_list();

    for my $s (@{ $sizes->{content}{sizes} }) {
        say "Size $s->{slug} costs $s->{price_hourly} per hour.";
    }

More info: L<< https://developers.digitalocean.com/#list-all-sizes >>.
