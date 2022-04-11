-- 1. Decompose Penna to BCNF scheme (2 tables). Use Create table statement to define and populate these tables from Penna.  

-- location Timestamp // Precinct == entity

-- Location Table 
drop table if exists Location;
Create table testDB.Location
As Select distinct p.precinct, p.locality, p.geo, p.state 
From testDB.penna p

Delete from testDB.Location where geo is null; #removing null geo values

-- Votes Table
drop table if exists Votes;
Create table testDB.Votes
As Select distinct p.precinct, p.totalvotes, p.Biden, p.Trump, p.Timestamp, p.filestamp
From testDB.penna p


-- 2. Define foreign key constraint on your new tables in mySQL (using proper commands)

# Making precinct the primary key in Location Table
delete from Location where precinct = "Morris Voting Precinct" #encountered error when I reuploaded penna table, got 3 more rows today than yesterday 
	# encountered more rows when I reuploaded penna table, had to del 2 rows to make pk

ALTER TABLE testDB.Location
ADD PRIMARY KEY (precinct (255));

# Making precinct the foreign key in Votes Table
# Make sure to add FK_VotesPrecinct in Index as Unique 
Alter table testDB.Votes
Add constraint FK_VotesPrecinct
Foreign key (precinct)
References location(precinct)

-- 3. Write a query in MySQL veryfing that your foreign key constraint is satisfied by the instances of tables in your decomposition (for the current data which you have uploaded).
use testDB
Select Votes.precinct
From Votes
Right join Location ON Votes.precinct = Location.precinct
where Location.precinct is null;

-- 4. Implement cascade option for your foreign key constraint using a TRIGGER.
-- When you delete a precinct from referenced table, all tuples with this precinct should be deleted from the referencing table.
use testDB

delimiter $$
Create Trigger del_Precinct
	After Delete on Votes
    For each row
    Begin
		Delete from Location
        Where Location.precinct = old.precinct;
    End $$
DELIMITER ; 

################################################################################
-- Testing - Works, deletes from both Location and Votes Table 
-- Delete From Votes where precinct= '01-01'
-- Set foreign_key_checks=0 #disable foreign key, 1= enable // Don't need to do, needed it the first time I ran the code 
################################################################################

-- 5. Implement a trigger with two functions:

-- a) Triggered by updates of Trump or Biden votes in any tuple, a new tuple is added  into separate table called VoteChangeLog. 
-- VotechangeLog will store precinct name, timestamp, old vote, new vote and candidate name for any update which changes votes for either of the two candidates. 

-- For example, adding 100 votes to Biden from old value of 500 to new value of 600,  for Precinct A at timestamp T, will result in adding the following tuple
-- to VotechangeLog:  <A, T, 500, 600, Biden>
--          precinct, timestamp, oldVote, newVote, candidate 

Create table testDB.VotechangeLog(
	precinct varchar(50), 
	Timestamp varchar(225), 
	oldVote int, 
	newVote int, 
	candidate text)


delimiter $$
create trigger update_VotechangeLog
	Before update on Votes
    For each row
    Begin 
                if(NEW.Trump > OLD.Trump + 1) then
                set @gg = NEW.Trump + OLD.Trump;
                insert into  VotechangeLog
                values(NEW.precinct, NEW.Timestamp, OLD.Trump, @gg, 'Trump');
            elseif (NEW.Biden > OLD.Biden + 1) THEN
                set @gg = NEW.Biden + OLD.Biden;
                insert into  VotechangeLog
                values(NEW.precinct, NEW.Timestamp, OLD.Biden, @gg, 'Biden');
             end if;
	End$$ 
delimiter ;

################################################################################
-- Testing 
-- UPDATE Votes set Biden = 9999


-- delete from VotechangeLog where newVote

################################################################################
-- b) The number of votes which were added (or removed)  for any candidate (Trump/Biden) have to be removedd (or added) to another candidate field as well.

-- For example adding 100 votes to Biden will result in removing 100 votes from Trump. In other words the only updates will theoretically correct misattribution of votes to any of the candidates.