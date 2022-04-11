-- #1 
Select * from Sells where bar = "Gecko Grill" and beer != "Hefeweizen";

-- #2 
select distinct drinker from Likes l, (select beer from Likes l where l.drinker = "Justin") ppl where l.beer = ppl.beer and l.drinker != "Justin"

-- #3
select distinct f.drinker, f.bar from Frequents f where f.bar in (select distinct s.bar from Sells s where s.beer in (select distinct l.beer from Likes l where l.drinker = f.drinker))

-- #4
select bar from Frequents where drinker = "Justin" or drinker = "Rebecca" Group by bar HAVING COUNT(*) < 2

-- #5
select distinct f.drinker from Frequents f where f.bar in (select distinct s.bar from Sells s where s.beer in (select distinct l.beer from Likes l where l.drinker = f.drinker))

-- #6
Select bar from (select price, bar from (select l.beer from Likes l where l.drinker = "John" or l.drinker= "Rebecca") couple, Sells where Sells.beer = couple.beer) 
fprice where fprice.price <5;

-- #7
select drinker from Likes where beer = "Hefeweizen" or beer= "Killian's" Group by drinker HAVING COUNT(*) > 1

-- #8
select * from Bars where name like '%The%'











