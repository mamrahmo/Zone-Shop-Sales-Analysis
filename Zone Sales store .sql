use [project store] ;
select top 100 * from [project store] ;

-- show if there is nulls --
select *
from [project store]
where Row_ID is null or
 Order_ID is null or
  Order_Date is null or
  Ship_Date is null or
  Ship_Mode is null or
  Customer_ID is null or
  Customer_Name is null or
  Segment is null or
  Country is null or
  City is null or
  State is null or
  Postal_Code is null or
  Region is null or
  Product_ID is null or
  Product_Name is null or
  Category is null or
  Sub_Category is null or
  Sales is null or
  Quantity is null or
  Discount is null or
 Profit is null or
 Profit_Margin  is null or
  Financial_Status is null or
 Days_to_Ship is null or
  Shipping_Status is null or
 Year is null or
 MonthNumber is null or
 MonthName is null ;

  -- duplicates (no duplicates) --
 SELECT 
    Order_ID,
    Product_ID,
    Quantity,
    Sales,
    Customer_ID,
    COUNT(*) AS Duplicate_Count
FROM [project store]
GROUP BY 
    Order_ID,
    Product_ID,
    Quantity,
    Sales,
    Customer_ID
HAVING COUNT(*) > 1; 

-- replace null & empty values --
alter table [project store]
  alter column Postal_Code varchar (20) ;

update [project store]
set Postal_Code = 'Unknown'
where Postal_Code is null  ;

update [project store]
set Customer_Name = 'Unknown'
where Customer_Name is null or Customer_Name = '' ;

update [project store]
set City = 'Unknown'
where City is null or City = '' ;

update [project store]
set Product_Name = 'Unknown'
where Product_Name is null or Product_Name = '' ;

-- negative values --
select *
from [project store]
where Sales < 0 ;

-- outliers (review only) --
  select *
   from [project store]
  where Sales >10000 ;
  -- two values 11199.9 , 10499.97--

select top 100 *
   from [project store]
  where Ship_Date < Order_Date ;

-- wrong dates --
select *
from [project store]
where Ship_Date < Order_Date ;

update [project store]
set Ship_Date = Order_Date
where Ship_Date < Order_Date ;

-- capitalization (first letters is capital)--
update [project store]
set 
City = upper(left(City,1)) + lower(substring(City,2,len(City))),
Ship_Mode = upper(left(Ship_Mode,1)) + lower(substring(Ship_Mode,2,len(Ship_Mode))),
Customer_Name = upper(left(Customer_Name,1)) + lower(substring(Customer_Name,2,len(Customer_Name))),
Segment = upper(left(Segment,1)) + lower(substring(Segment,2,len(Segment))),
Country = upper(left(Country,1)) + lower(substring(Country,2,len(Country))),
Region = upper(left(Region,1)) + lower(substring(Region,2,len(Region))),
State = upper(left(State,1)) + lower(substring(State,2,len(State))),
Category = upper(left(Category,1)) + lower(substring(Category,2,len(Category))),
Sub_Category = upper(left(Sub_Category,1)) + lower(substring(Sub_Category,2,len(Sub_Category))),
Product_Name = upper(left(Product_Name,1)) + lower(substring(Product_Name,2,len(Product_Name)));

-- fix country values--
update [project store]
set Country = 'United States'
where Country in ('US','USA','U.S.A') ;

-- extra spaces check--
select Customer_Name from [project store] where Customer_Name like '%  %' ;
select City from [project store] where City like '%  %' ;
select Product_Name from [project store] where Product_Name like '%  %' ;
select Category from [project store] where Category like '%  %' ;
select Ship_Mode from [project store] where Ship_Mode like '%  %' ;
-- 12 in product name --

-- remove extra spaces--
update [project store]
set 
Customer_Name = trim(replace(replace(Customer_Name,'  ',' '),'  ',' ')),
City = trim(replace(replace(City,'  ',' '),'  ',' ')),
Product_Name = trim(replace(replace(Product_Name,'  ',' '),'  ',' ')),
Category = trim(replace(replace(Category,'  ',' '),'  ',' ')),
Ship_Mode = trim(replace(replace(Ship_Mode,'  ',' '),'  ',' '));

update [project store]
set 
Customer_Name = trim(Customer_Name),
City = trim(City),
Product_Name = trim(Product_Name);

-- final check--
select *
from [project store]
where 
(Financial_Status = 'Profit' and Profit < 0)
or
(Financial_Status = 'Loss' and Profit > 0);

select * from [project store] ;

--analysis questions--

--1 what is total sales--
select 
sum(sales) 
from [project store];
--1082910.83--

--2 what is num of orders--
select 
count (distinct Order_ID)
FROM [project store];
--4922--

--3 what is the total num of sales--
select count(*) as Total_sales
from [project store]
-- 4922 --

--4 what is the avg order--
select avg(sales) 
from [project store];
--220.0143904916--

--5 which product has the highest sales -- 
select top 10 Product_Name ,
sum (sales) as Total_Sales 
from [project store] 
group by Product_Name
order by Total_Sales DESC ;
--canon imageclass 2200 advanced copier 30099.92--

--6 What are the top-selling products ranked by total sales--
select top 5
Product_Name,
sum(Sales) AS Total_Sales,
Rank() OVER (order by sum(Sales) DESC) AS Rank
from [project store]
group by Product_Name;
--cannon imagclass 30099.92 1 , Gbc ibimaster 500 manual proclick binding system 16437.17 2,...--

--7 which product has the lowest sales--
select top 10 Product_Name ,sum (sales) as Total_Sales
from [project store]
group by Product_Name
order by Total_Sales ASC ;
--Avery binder labels 1.17--

--8 what is the best customer--
select top 10 Customer_Name , sum(sales)
from [project store]
group by Customer_Name
order by sum(sales) DESC;
--Adrian barton 12120.59--

--9 which customers generate most profit--
select top 10 Customer_Name,
sum(Profit) as Total_Profit
from [project store]
group by Customer_Name
order by Total_Profit desc;
--tom ashbrook 4659.69 / sanjit engle 4184.84 ....--

--10 which customers generate losses--
select top 10 Customer_Name,
sum(Profit) as Total_Profit
from [project store]
group by Customer_Name
having sum(Profit) < 0
order by Total_Profit asc;
--christopher conant -3187.12 / max jones -1393.59 ....--

--11 which city has high sales--
select top 10 City , sum(sales)
from [project store]
group by City
order by sum(sales) DESC;
--new york city 116870.04--

--12 what is the top region--
select Region , sum(sales)
from [project store]
group by Region
order by sum(sales) DESC;
--WEST 325811.31--

--13 which region generates highest profit--
select Region,
sum(Profit) as Total_Profit
from [project store]
group by Region
order by Total_Profit desc;
--east 78427.37 of total profit--

--14 which region has highest loss ratio--
select Region,
sum(case when Profit < 0 then 1 else 0 end) * 1.0 / count(*) as Loss_Ratio
from [project store]
group by Region
order by Loss_Ratio desc;
--east 0.160701241782 of loss_ratio--

--15 which year has high sales--
select Year(Order_Date) , sum(sales) 
from [project store]
group by Year(Order_Date)
order by sum(sales) DESC;
--2018 351186.28--

--16 Has the store's sales grown year-over-year--
select 
Year(Order_Date) AS Year, sum(Sales) AS Total_Sales
from [project store]
group by Year(Order_Date)
order by Year;
-- sales increased significantly in the following years--

--17 which months has high sales--
select Month(Order_Date) , sum(sales)
from [project store]
group by Month(Order_Date)
order by sum(sales) DESC;
--11 172808.11 , 12 170925.25--


--18 which month has highest profit--
select MonthName,
sum(Profit) as Total_Profit
from [project store]
group by MonthName
order by Total_Profit desc;
--novamber 44045.23 /december 35235.56 /september 31165.02 ...--

--19 does the shipping mode effect sales/which shipping mode is the best & cheapest--
select Ship_Mode, sum(sales)
from [project store]
group by Ship_Mode
order by sum(sales) DESC;
--standard class 634727.77--

select Ship_Mode, count(*) as Order_Count
from [project store]
group by Ship_Mode
order by count(*) DESC;
--standers class 2945 (customer performance)--

--20 which shipping mode is most profitable--
select Ship_Mode,
avg(Profit) as Avg_Profit
from [project store]
group by Ship_Mode;
--first class 60.4024481865--

--21 what is time between order date &ship date--
select avg (datediff (Day,Order_Date,Ship_Date))
as avg_Delivery_Days
from [project store]
--3days--

--22 does delay affect profit--
select 
case 
when DATEDIFF(day,Order_Date,Ship_Date) > 3 then 'Delayed'
else 'On Time'
end as Shipping_Status,
avg(Profit) as Avg_Profit
from [project store]
group by 
case 
when DATEDIFF(day,Order_Date,Ship_Date) > 3 then 'Delayed'
else 'On Time'
end;
--delayed 49.1058003597 , on time 60.2105233291-- 

--23 which segment spends the most--
select Segment , sum(sales)
from [project store]
group by Segment
order by sum(sales) DESC;
--consumer customer 552594.41--   

--24 In which states are orders most likely to be "Delayed--
select State,
count(*) AS Delayed_Orders
FROM [project store]
where DATEDIFF(Day, Order_Date, Ship_Date) > 3
group by State
order by Delayed_Orders DESC;
--states california 668--

--25 what is total profit--
select sum(Profit)
from [project store];
--259310.84--

--26 what is profit margin--
select sum(Profit) * 1.0 / sum(Sales) as Profit_Margin
from [project store];
--0.239457--

--27 is the store mostly profit or loss--
select Financial_Status, count(*) 
from [project store]
group by Financial_Status;
--profit 4173 , less 749--

--28 which product generates highest profit--
select top 10 Product_Name,
sum(Profit) as Total_Profit
from [project store]
group by Product_Name
order by Total_Profit desc;
--hon 5400 series task chairs for big and tall 6252.75--

--29 which product generates most loss--
select top 10 Product_Name,
sum(Profit) as Total_Profit
from [project store]
group by Product_Name
order by Total_Profit asc;
--okidata mb760 printer -1790.72--

--30 Which products have very low profit compared to their sales?--
select top 10 Product_Name,
sum(Sales) as Total_Sales,
sum(Profit) as Total_Profit
from [project store]
group by Product_Name
having sum(Profit) < sum(Sales) * 0.05
order by Total_Sales desc;
--Gbc ibimaster 500 manual proclick binding system 16437.17 of total sales , 760.98 of total profit--


--31 which category has high sales--
select Category ,sum(sales) 
from [project store]
group by Category
order by sum(sales) DESC;
--TECHNOLOGY 378204.61--

--32 which category has highest profit--
select Category,
sum(Profit) as Total_Profit
from [project store]
group by Category
order by Total_Profit desc;
--technology 96083.28 of total profit--

--33 which category causes most loss--
select Category,
sum(Profit) as Total_Profit
from [project store]
group by Category
order by Total_Profit asc;
--office supplies 79853.42 of total profit--

--34 how does discount affect profit--
select Discount,
avg(Profit) as Avg_Profit
from [project store]
group by Discount
order by Discount desc;
--discount 0.8 , avg_profit -96.0614349775--

--35 high risk transactions--
select *
from [project store]
where Profit < 0 
and Discount > 0.2;
--High discounts are a major cause of losses in the dataset--

select 
Discount,
count(*) as Orders,
sum(case when Profit < 0 then 1 else 0 end) as Loss_Orders
from [project store]
group by Discount
order by Discount desc;
--discount 0.8 order 223 loss_order 223/0.7 , 262 , 262/0.5 , 264 , 264/0.3 , 508 , 0 ....--

--36 which customers generate most profit--
select top 10 Customer_Name,
sum(Profit) as Total_Profit
from [project store]
group by Customer_Name
order by Total_Profit desc;
--tom ashbrook 4659.69 / sanjit engle 4184.84 ....--

--37 which customers generate losses--
select top 10 Customer_Name,
sum(Profit) as Total_Profit
from [project store]
group by Customer_Name
having sum(Profit) < 0
order by Total_Profit asc;
--christopher conant -3187.12 / max jones -1393.59 ....--

--38 where are the biggest problems in data--
select *
from [project store]
where Profit < 0 
and Discount > 0.2 
and DATEDIFF(day,Order_Date,Ship_Date) > 3;
--row id (38/87/99/104/126/146/157/164....)--
