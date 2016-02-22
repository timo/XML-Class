#!perl6

use v6;

use Test;

use XML::Class;

my $DEBUG = True;

class SimpleClass does XML::Class {
    has Int $.version;
    has Str $.something is xml-attribute('other-name');
    has Str $.thing is xml-element;
    has Rat $.named is xml-element('some-element');
    has Str @.strings;
    has Int @.ints is xml-container is xml-element('int');
    has Str %.hash is xml-element;

}

my $obj = SimpleClass.new(version => 0, thing => 'boom', named => 78/3, something => 'else', strings => <a b c d>, ints => (^5), hash => <A B C D>.map( { $_ => $_.lc}).hash);

my $xml =  $obj.to-xml;

diag $xml if $DEBUG;

my $out;

#lives-ok { 
$out = SimpleClass.from-xml($xml); # }, "from-xml(Str)";

isa-ok $out, SimpleClass, "got back the class we expected";

is $out.version, $obj.version, "got the version we expected";
is $out.thing, $obj.thing, "and the element attribute";
is $out.named, $obj.named, "and a Rat with name over-ride";
is $out.something, $obj.something, "and an attribute attribute with name over-ride";
is-deeply $out.strings.sort, $obj.strings.sort, "and the basic array is good";
is-deeply $out.ints.sort, $obj.ints.sort, "and a contained array too";
is-deeply $out.hash, $obj.hash, "and the contained hash";




done-testing;
# vim: expandtab shiftwidth=4 ft=perl6
