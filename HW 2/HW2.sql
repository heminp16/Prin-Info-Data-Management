-- 1.  Beers which are not served by Gecko Grill bar
Select beer from Sells where bar <> "Gecko Grill" and beer != "Hefeweizen" and beer != "Budweiser" Group by beer 

-- 2.  Drinkers who like all beers which Justin likes
Select distinct drinker from Likes l, (select beer from Likes l where l.drinker = "Justin") ppl where l.beer = ppl.beer and l.drinker != "Justin"

-- 3.  Pairs of drinkers and bars such that a drinker frequents the bar and the bar serves no beer which the drinker likes //should be 12
select distinct f.drinker, f.bar from Frequents f where f.drinker in (select distinct d.drinker from Frequents d where not exists (select * from Sells s, Likes l where d.bar= s.bar and d.drinker= l.drinker AND s.beer = l.beer));

-- 4.  Bars which are frequented by neither Justin nor Rebecca //7 results 
select distinct bar from Frequents where drinker != "Justin" and drinker != "Rebecca"

-- 5.  Drinkers who frequent only these bars which sell beers that they like 
select distinct f.drinker from Frequents f where f.drinker in (select distinct d.drinker from Frequents d where  exists (select * from Sells s, Likes l where d.bar=s.bar and d.drinker=l.drinker and s.beer = l.beer))

-- 6.  Bars which serve no beer cheaper than $5 
Select bar from Sells Group by bar having MIN(price)>=5

-- 7.  What is the bar with the highest average price of beer that it sells
Select bar, Round(AVG(price),3) from Sells Group by bar Order by AVG(price) desc LIMIT 1;

-- 8.  Order all bars by the average price of beer that they sell (in descending order)
Select bar, Round(AVG(price),3) from Sells Group by bar Order by AVG(price) desc

-- 9.  Find all bars whose names consist of more than one word
Select name from Bars where name Like "% %"

-- 10.  Which drinker(s) like the most beers
Select drinker From Likes
Group by drinker 
HAVING COUNT(drinker)>1
Order by COUNT(drinker) desc LIMIT 1;

-- 11.  Which beer has the highest average price over all bars //, Round(AVG(price),2) to get price of beer // after Sel beer
Select beer from Sells Group by beer HAVING AVG(price) >= ALL ( SELECT AVG(price)) Order by AVG(price) desc LIMIT 1;


-- 12.  Find bar(s) which charge the smallest price for Budweiser (Bud) 
Select bar 
From Sells where beer= "Budweiser"
Group by bar
Having Min(price)
Order by MIN(price) Limit 1;


-- 13.  Using outer join (left/right - your choice) Find drinkers who do not  frequentany bar which sells Budweiser
Select distinct f.drinker from Frequents f Left Join Sells s on f.bar = s.bar and s.beer <> "Budweiser"


-- 14.  Using outerjoin find a beer which is not sold by any bar which Mike frequents 
Select distinct name as beer_name from Beers B
left outer join
(Select S.bar as bar, S.beer as beer from Sells S join Frequents F ON (S.bar=F.bar) where F.drinker= "Mike") 
S1 ON (B.name=S1.beer) where S1.beer is null; 

-- 15.  Write a query which returns "Yes" if there is any beer which all drinkers like, and "No" otherwise.
select distinct 'Yes' as 'nonempty'  from Sells where EXISTS(select * from Sells) UNION select distinct 'No' as 'nonempty'  from Sells where NOT EXISTS(select * from Sells);

-- 16.  Write a query like the one above which either returns such a beer, or if there is no such beer, returns "No such a beer exists".
select distinct beer from Sells where EXISTS(select * from Sells where beer='Budweiser') UNION select 'No such beer exists' as beer  from Sells where  NOT EXISTS(select * from Sells where beer='Budweiser')