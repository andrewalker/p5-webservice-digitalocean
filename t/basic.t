#!/usr/bin/env perl
use Test::More;
use Test::Fatal;
use warnings;
use strict;
use utf8;
use WebService::DigitalOcean;

my $do;

is(
    exception { $do = WebService::DigitalOcean->new(token => '855eed5572651530a92557f2426eb1f3b3b2120c6eda19d371c5b7d04c777aa0') },
    undef,
    '$do builds ok',
);

isa_ok( $do, 'WebService::DigitalOcean', '$do' );

for (qw/
  domain_record_create
  domain_record_list
  domain_record_get
  domain_record_delete
  domain_create
  domain_list
  domain_get
  domain_delete
/) {
    ok( $do->can($_), '$do can ' . $_ );
}

done_testing;
