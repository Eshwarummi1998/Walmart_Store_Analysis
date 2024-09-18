
-- --------------  Featured Engineering  ---------------------------------------------------------
-- Adding Time_of_day Column

UPDATE salesdata
SET
Time_of_day = (
Case 
	when time between "00:00:00" AND "12:00:00" THEN "Morning"
    when time between "12:00:01" AND "17:00:00" THEN "Afternoon"
    when time between "17:00:01" AND "23:59:59" THEN "Evening"
END 
);

-- Adding Day_name ---

UPDATE salesdata
SET
Day_name = dayname(date);

-- Adding Month Name
UPDATE salesdata
SET
Month_name = monthname(date);


-- Answering Business Questions ----------------------------------------

### Generic Question

-- 1) How many unique cities does the data have?

select count(distinct(City))
from salesdata;

-- 2) In Which City is the each branch located ?

select distinct(city), Branch
from salesdata;


### Product
-- 1. How many unique product lines does the data have?

select count(distinct(Product_line)) as Unique_product_lines
from salesdata;

-- 2. What is the most common payment method?
select payment,count(Payment) as times_Used
from salesdata
group by payment
order by times_Used desc
limit 1;

-- 3. What is the most selling product line?
select Product_line, count(Product_line) as Times_Sold
from salesdata
group by Product_line
order by Times_Sold desc
limit 1;

-- 4. What is the total revenue by month?
select Month_name, round(sum(Total),2) as Revenue
from salesdata
group by Month_name
order by Revenue Desc;

-- 5. What month had the largest COGS?
select Month_name, round(sum(cogs),2) as total_cogs
from salesdata
group by Month_name
order by total_cogs Desc
Limit 1;

-- 6. What product line had the largest revenue?
select Product_line, round(sum(total),2) as Revenue
from salesdata
group by Product_line
order by Revenue Desc
Limit 1;

-- 7. What is the city with the largest revenue?
select city, round(sum(total)) as Revenue
from salesdata
group by city
order by Revenue Desc
Limit 1;

-- 8. What product line had the largest VAT?
select Product_line, AVG(`Tax 5%`) as Total_Tax
from salesdata
group by Product_line
order by Total_Tax ASC;

-- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
select Product_line,
		(case
			when sum(total) > (select avg(total) from salesdata) then "Good"
            else "Bad"
		END
        ) as Product_quality
from salesdata
group by Product_line;


-- 10. Which branch sold more products than average product sold?

select Branch, sum(Quantity) as qty_sold
from salesdata
group by branch
having sum(Quantity) > (select avg(Quantity) from salesdata);

-- 11. What is the most common product line by gender?
select gender, product_line, count(product_line) as total_cnt
from salesdata
group by gender, product_line
order by Gender Desc , Total_cnt Desc;

-- 12. What is the average rating of each product line?
select Product_line, avg(Rating) as Avg_Rating
from salesdata
group by Product_line
order by Avg_Rating Desc;


-- ### Sales  ### -------------------------------------------------------
-- 1. Number of sales made in each time of the day per weekday
select Time_of_day, count(Invoice_ID) as Sales_cnt
from salesdata
group by Time_of_day
order by Sales_cnt Desc;

-- 2. Which of the customer types brings the most revenue?
 select Customer_type, sum(Total) as Total_Revenue
 from salesdata
 group by Customer_type
 order by Total_Revenue Desc;
 
 -- 3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?
select City, sum(Tax) as Tax_revenue
from salesdata
group by city
order by Tax_revenue Desc;

-- 4. Which customer type pays the most in VAT?
select Customer_type, sum(tax) as Total_tax
from salesdata
group by Customer_type
order by Total_tax Desc;


-- ### Customer -- ------------------------------------------------------------

-- 1. How many unique customer types does the data have?
select distinct Customer_type as Customer_types
from salesdata;

-- 2. How many unique payment methods does the data have?
select distinct Payment as Payment_types
from salesdata;

-- 3. What is the most common customer type?
select Customer_type, count(Customer_type) as Type
from salesdata
group by Customer_type;

-- 4. Which customer type buys the most?
select Customer_type, round(sum(total),2) as Total_amount
from salesdata
group by Customer_type;

-- 5. What is the gender of most of the customers?
select Gender, count( gender) as cnt_Gender
from salesdata
group by Gender
order by cnt_Gender Desc;

-- 6. What is the gender distribution per branch?
select branch, gender, count(gender) as Cnt_Gender
from salesdata
group by Branch, Gender
order by branch, cnt_gender Desc;

-- 7. Which time of the day do customers give most ratings?
select Time_of_day, avg(rating)
from salesdata
group by Time_of_day;

-- 8. Which time of the day do customers give most ratings per branch?
select branch, Time_of_day, avg(rating)
from salesdata
group by branch, Time_of_day
order by branch asc, avg(rating) desc;

-- 9. Which day fo the week has the best avg ratings?
select Day_name, avg(Rating) as Rating
from salesdata
group by Day_name
order by Day_name Desc;


-- 10. Which day of the week has the best average ratings per branch?
select branch, Day_name, round(avg(rating),2)
from salesdata
group by branch, Day_name
order by branch asc, avg(rating) desc;

