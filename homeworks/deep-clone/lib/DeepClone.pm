package DeepClone;

use 5.010;
use strict;
use warnings;

=encoding UTF8

=head1 SYNOPSIS

Клонирование сложных структур данных

=head1 clone($orig)

Функция принимает на вход ссылку на какую либо структуру данных и отдаюет, в качестве результата, ее точную независимую копию.
Это значит, что ни один элемент результирующей структуры, не может ссылаться на элементы исходной, но при этом она должна в точности повторять ее схему.

Входные данные:
* undef
* строка
* число
* ссылка на массив
* ссылка на хеш
Элементами ссылок на массив и хеш, могут быть любые из указанных выше конструкций.
Любые отличные от указанных типы данных -- недопустимы. В этом случае результатом клонирования должен быть undef.

Выходные данные:
* undef
* строка
* число
* ссылка на массив
* ссылка на хеш
Элементами ссылок на массив или хеш, не могут быть ссылки на массивы и хеши исходной структуры данных.

=cut

sub clone {
	my $orig = shift;
    my $cloned; 
    if (!defined $orig) {
l1:         return ($cloned = undef);}
	$cloned = dumper($orig, $cloned);
	return $cloned;
}

1;


sub dumper {
    my $what = shift; 
    my $old = shift;
    my $cloned;
    if (my $ref = ref $what) {
        if ($ref eq 'ARRAY') {
            $cloned = []; 
            if (ref $old and $what == $old) 
                {return $what;}
            push @$cloned, dumper($_, $what) for @$what;
            return $cloned;
        }
        elsif ($ref eq 'HASH') {
            $cloned = {};

            while (my ($k,$v) = each %$what) {
 
                if (ref $v and $v == $what) 
                {  
                    return {%$what};
                }
                $cloned->{$k} = dumper($v, $what); 
            }
            return $cloned;
        }
#        else {die "unsupported: $ref"; }
        else { print "unsupported: $ref\n"; goto l1;}
    }
    else {
        return $what;

    }
}

