-- 1) What was the earliest timestamp when Biden was leading Trump overall by more than 100,000 votes? (i.e. in all precincts)
Select Min(Timestamp) as MinTimestamp
From Penna -- testDB.penna -- Penna_fully_sorted
Group by Timestamp
Having (sum(Biden) - sum(Trump) >=100000)
Order by Timestamp Limit 1

-- 2) Show the earliest timestamp t when first vote was casted. Return also all precincts which got their first vote counted at t. 
Select Timestamp, precinct from Penna P where (P.precinct, P.Timestamp) in (select precinct, Timestamp from Penna group by precinct) and totalvotes > 0
Order by Timestamp LIMIT 86;

-- 3) Which precinct(s) showed smallest *final* vote difference between Biden and Trump. 
Select precinct -- , Timestamp, Biden, Trump 
from Penna 
where Timestamp in (select max(Timestamp) from Penna) AND Biden = Trump and ABS(Biden=Trump) 

-- 4) At which timestamp the difference between total vote for Biden and total vote for Trump was the largest
Select Timestamp
From  Penna
Group by Timestamp
Order by abs(sum(Biden)-sum(Trump)) desc
limit 2

-- 5) List all timestamps t, total vote for Trump and total vote for Biden such  that total vote for Trump was larger than total vote for Biden at t.
Select Timestamp, Sum(Trump), Sum(Biden)
From  Penna
Group by Timestamp
Having (sum(Trump) > Sum(Biden))

-- 6) Who won all Township precincts, who won all Borough precincts? Who won all the Wards?  In all three cases show how many votes both candidates recieved in all such precincts as well
Select precinct, Sum(Trump), Sum(Biden)
from Penna where precinct Like "%Township%"
Group by precinct
Order by MAX(totalvotes) desc

Select precinct, Sum(Trump), Sum(Biden)
from Penna where precinct Like "%Borough%"
Group by precinct
Order by MAX(totalvotes) desc

Select precinct, Sum(Trump), Sum(Biden)
from Penna where precinct Like "%Ward%"
Group by precinct
Order by MAX(totalvotes) desc


-- 7) Write a query returning the name and number of votes of the candidate who won election according to all precincts in this database? Who won the first day?  Who won the last day? (had more votes gained just in the last day, Nov, 11)
Select Sum(Trump), Sum(Biden)
from Penna

Select Min(Timestamp), Sum(Trump), Sum(Biden)
From Penna

Select Max(Timestamp), Sum(Trump), Sum(Biden)
From Penna


-- 8) How many precincts did Trump win?
Select COUNT(*) OVER () as precinct -- , Max(Trump) as MaxT, Max(Biden) as MaxB
from Penna
Group by precinct
Having Max(Trump) > Max(Biden) Limit 1


-- 9) Write an interesting query yourself - query which would show something suprising?

-- Which county has the most precincts? 

Select distinct locality as County, COUNT(precinct) as Amount
from Penna
Group by locality
Having (COUNT(precinct))
Order by Max(precinct) Limit 1














