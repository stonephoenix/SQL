### Nth largest
### Duplicate, find duplicate, group then count(*)
### Deplicate, delete duplicate, NOT IN or JOIN
### Not Exist, LEFT JOIN instead of NOT IN
### Increasing number, ID shifted by 1

### Nth largest
### [LIMIT {[offset,] row_count | row_count OFFSET offset}]
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  set N = N-1;
  RETURN (
      select distinct Salary from Employee order by Salary desc limit N, 1 
  );
END

### Duplicate, find duplicate
SELECT Email from Person
Group By Email
Having Count(*) > 1;
### or join (more time)
SELECT distinct p1.Email from Person p1
INNER JOIN Person p2
ON p1.Email = p2.Email
WHERE p1.Id <> p2.Id;

### Deplicate, delete duplicate
delete from Person where
Id not in
(   select min_ID from 
    (   select min(Id) as min_ID from Person group by Email 
    ) as Unique_Index
)
### or join (doulbe the time of above)
DELETE p2 FROM Person p1, Person p2 WHERE p1.Email = p2. Email AND p1.Id < p2.Id

### Not Exist, LEFT JOIN instead of NOT IN
SELECT Name as Customers from Customers
LEFT JOIN Orders
ON Customers.Id = Orders.CustomerId
WHERE Orders.CustomerId IS NULL;

### Increasing number
SELECT t1.Id
FROM Weather t1
INNER JOIN Weather t2
ON TO_DAYS(t1.Date) = TO_DAYS(t2.Date) + 1
WHERE t1.Temperature > t2.Temperature
