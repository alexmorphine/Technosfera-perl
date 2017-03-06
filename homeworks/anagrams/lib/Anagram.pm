package Anagram;

use 5.010;
use strict;
use warnings;
use feature "fc";
use DDP;
use Encode;

=encoding UTF8

=head1 SYNOPSIS

Поиск анаграмм

=head1 anagram($arrayref)

Функцию поиска всех множеств анаграмм по словарю.

Входные данные для функции: ссылка на массив - каждый элемент которого - слово на русском языке в кодировке utf8

Выходные данные: Ссылка на хеш множеств анаграмм.

Ключ - первое встретившееся в словаре слово из множества
Значение - ссылка на массив, каждый элемент которого слово из множества, в том порядке в котором оно встретилось в словаре в первый раз.

Множества из одного элемента не должны попасть в результат.

Все слова должны быть приведены к нижнему регистру.
В результирующем множестве каждое слово должно встречаться только один раз.
Например

anagram(['пятак', 'ЛиСток', 'пятка', 'стул', 'ПяТаК', 'слиток', 'тяпка', 'столик', 'слиток'])

должен вернуть ссылку на хеш


{
    'пятак'  => ['пятак', 'пятка', 'тяпка'],
    'листок' => ['листок', 'слиток', 'столик'],
}

=cut

sub anagram {
    my $words_list = shift;
    my %result;
    my %results;
    my @a;
    my $j;

    for my $i (0..$#$words_list)
    {
        if ($j = isanagram(decode('utf8', ${$words_list}[$i]), \@a)) 
            {;
               push @{$results{"$a[$j-1]"}}, encode('utf8', fc(decode('utf8', ${$words_list}[$i])));
             }
        else
            {
                $a[$i] =  join "", sort split(//, fc(decode('utf8', ${$words_list}[$i])));
                $results{$a[$i]} = [encode('utf8', fc(decode('utf8', ${$words_list}[$i])))];

            }  
    }
    for $j (keys %results)
        {
            if ($#{$results{$j}} <= 0) {delete $results{$j};}
        }
    for my $k (keys %results)
        {
            my %uniq;
            $result{${$results{$k}}[0]} = [sort grep {!$uniq{$_}++} @{$results{$k}}];
        }
    p %result;
    return \%result;
}
1;


sub isanagram {
    my ($word, $list) = @_;
    for my $i (0..$#$list)
    {   
        if (${$list}[$i] eq (join "", sort split(//, fc($word))))
            {
                return $i+1;
            }
    }
    return 0;
}

