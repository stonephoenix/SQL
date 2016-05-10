## Rank
## Largest in each group
## Top 3 in each group
## find numbers appear at least three times consecutively
## Cancellation Rate

## Rank
# Variable
SELECT
  Score,
  @rank := @rank + (@prev <> (@prev := Score)) Rank
FROM
  Scores,
  (SELECT @rank := 0, @prev := -1) init
ORDER BY Score desc

## Rank
# Cartesian, takes longer time than above
SELECT Scores.Score, COUNT(Ranking.Score) AS RANK
  FROM Scores
     , (
       SELECT DISTINCT Score
         FROM Scores
       ) Ranking
 WHERE Scores.Score <= Ranking.Score
 GROUP BY Scores.Id, Scores.Score
 ORDER BY Scores.Score DESC;

## Largest in each group
select d.Name, e.Name, e.Salary
from Department d, Employee e,
  (select MAX(Salary) as Salary,  DepartmentId as DepartmentId 
  from Employee GROUP BY DepartmentId) h
where
  e.Salary = h.Salary and
  e.DepartmentId = h.DepartmentId and
  e.DepartmentId = d.Id;
  
## Top 3 in each group
# Write your MySQL query statement below
SELECT d.Name AS Department, se.Name AS Employee, se.Salary 
FROM Department d,
 ( SELECT e.Name, e.DepartmentId, e.Salary,
          @Rank := (CASE 
                    WHEN @PrevDept != e.DepartmentId THEN 1
                    WHEN @PrevSalary = e.Salary THEN @Rank
                    ELSE @Rank + 1 END) AS Rank, 
          @PrevDept := e.DepartmentId,
          @PrevSalary := e.Salary
    FROM Employee e, (SELECT @Rank := 0, @PrevDept := 0, @PrevSalary := 0) r
    ORDER BY DepartmentId ASC, Salary DESC
  ) se
WHERE d.Id = se.DepartmentId AND se.Rank <= 3

## find numbers appear at least three times consecutively
select distinct (t1.Num) ConsecutiveNums from 
    (select Num, 
        case when @last = Num then @counts:=@counts+1
             when @last <> @last := Num then @counts:=1
        end as counts
    from Logs) as t1,
    (select @counts:=0, @last := (select Num from Logs limit 1)) as t2
where t1.counts >= 3

## Cancellation Rate
# sum(1) get row number
SELECT Trips.Request_at Day,
       round(sum(if(status != 'completed', 1, 0)) / sum(1), 2) 'Cancellation Rate'
FROM Trips
JOIN Users
  ON Trips.Client_Id = Users.Users_Id
WHERE Users.Banned = 'No' 
  AND Trips.Request_at between '2013-10-01' AND '2013-10-03'   
GROUP BY Trips.Request_at
