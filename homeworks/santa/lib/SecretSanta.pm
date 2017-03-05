package SecretSanta;

use 5.010;
use strict;
use warnings;
use experimental 'smartmatch';
use DDP;


sub calculate {
my @members = @_;
my @mh; #человек + супруг + кому можно + кому дарит
my @names; #все имена для пров вхождения
my %am; #массив для сорт по кол-ву кому можно
my @res;
my $i;
l2:     for $i (0..$#members) 
    {
        if (ref $members[$i]) 
        {
            push (@mh, {name => "${ $members[$i] }[0]", 
                                  sps => "${ $members[$i] }[1]",
                                  gift => "",
                                  rg => "",}
                      );                          
            push (@mh, {  name => "${ $members[$i] }[1]",
                                    sps => "${ $members[$i] }[0]",
                                    gift => "",
                                    rg => "",}
                    ); 
            push @names, ${ $members[$i] }[0];
            push @names, ${ $members[$i] }[1];          
        }
        else 
        {
            push (@mh, {name => "$members[$i]",
                                sps => "",
                                gift => "",
                                rg => "",}
                     ); 
            push @names, $members[$i];                               
         }
    }

       for $i (0..$#mh) 
        {
            for my $j ($i..$#mh) 
            {
                ${ $mh[$j] }{gift} = gifts($mh[$j], \@mh); #список, кому можно дарить
                if (${ $mh[$i] }{sps} ne "" and "$#{${$mh[$i]}{gift}}" == 0) {print "no way to match\n"; return 1}
            }             
                       if ($i == $#mh) { #проверка на неразрешимые сочетания
                           for my $k (0..$#mh-1) 
                            {
                                if (${ $mh[$#mh] }{gift}->[0] eq ${ $mh[$k] }{rg}) 
                                     {@mh = (); @res = (); goto l2;}  #повторный перебор
                            } 
                        }
            my $num = "$#{${$mh[$i]}{gift}}"; #граница диапазона для случ выбора 
            ${ $mh[$i] }{rg} = ran($mh[$i], $num, \@names); #выбор, кому дарить
            push @res, [ "${ $mh[$i] }{name}", "${ $mh[$i] }{rg}" ];
        }
    return @res;
}
1;


sub gifts {
    my ($pers, $gnames) = @_;
    my @tg;
    for my $i (0..$#$gnames) 
    {
        if (( ${$$gnames[$i]}{name} eq $$pers{name}) or  (${$$gnames[$i]}{name} eq $$pers{sps}) or (${$$gnames[$i]}{rg} eq $$pers{name})) {next;} # $$gnames[$i] ~~ ["$$pers{name}", "$$pers{sps}"]
        else {push (@tg, ${$$gnames[$i]}{name});}
    }
    return [@tg];
}



sub ran {
    my ($pers, $num, $gnames) = @_;
l1:    my $j = int rand ($num + 1);    

    if ( $$pers{gift}[$j]~~$gnames) 
    {
        for my $i (0..$#$gnames) 
        {
            if ($$gnames[$i] ~~ $$pers{gift}[$j])
            {
                splice (@$gnames, $i, 1);
                last;
            }
         }
     }
    else {goto l1;}

    return $$pers{gift}[$j];
}

