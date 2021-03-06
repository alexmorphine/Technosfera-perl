#!/usr/bin/perl

use strict;
use warnings;

=encoding UTF8
=head1 SYNOPSYS

Шифр Цезаря https://ru.wikipedia.org/wiki/%D0%A8%D0%B8%D1%84%D1%80_%D0%A6%D0%B5%D0%B7%D0%B0%D1%80%D1%8F

=head1 encode ($str, $key)

Функция шифрования ASCII строки $str ключем $key.
Пачатает зашифрованную строку $encoded_str в формате "$encoded_str\n"

Пример:

encode('#abc', 1) - печатает '$bcd'

=cut

#my $f = undef;
#print("specify function N: 1. encode, 2. decode\n");
#$f = <STDIN>;

#if ($f == "1"){
#    &encode();}
#elsif ($f == "2") {&decode();}
#else {print "no such number";}
 
sub encode {
    my ($str, $key) = @_;
    my $encoded_str = "";
    my @enc;
    for (my $i = 0; $i < length($str); $i++) {        
        push(@enc, chr( ((ord(substr($str, $i, 1))) + $key)% 127));}
    $encoded_str = join("", @enc);    
    print "$encoded_str\n";
}
#&encode();
=head1 decode ($encoded_str, $key)

Функция дешифрования ASCII строки $encoded_str ключем $key.
Пачатает дешифрованную строку $str в формате "$str\n"

Пример:

decode('$bcd', 1) - печатает '#abc'

=cut

sub decode {
    my ($encoded_str, $key) = @_;
    my $str = "";
    my @enc;
    for (my $i = 0; $i < length($encoded_str); $i++) {        
        push( @enc, chr(((ord(substr($encoded_str, $i, 1))) - $key%127)) );}
    $str = join("", @enc);
    print "$str\n";
}
#&decode();
1;
