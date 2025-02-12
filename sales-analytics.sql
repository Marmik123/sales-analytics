--SALES DATA TABLE DDL STATEMENT
CREATE TABLE sales_data (
    TransactionID INT PRIMARY KEY,
    CustomerID INT,
    TransactionDate TIMESTAMP,
    TransactionAmount DECIMAL(10,2),
    PaymentMethod VARCHAR(50),
    Quantity INT,
    DiscountPercent DECIMAL(5,2),
    City VARCHAR(100),
    StoreType VARCHAR(50),
    CustomerAge INT,
    CustomerGender VARCHAR(10),
    LoyaltyPoints INT,
    ProductName VARCHAR(100),
    Region VARCHAR(50),
    Returned VARCHAR(3),  -- Since it's "Yes/No", storing as VARCHAR
    FeedbackScore INT,
    ShippingCost DECIMAL(10,2),
    DeliveryTimeDays INT,
    IsPromotional VARCHAR(3)  -- Since it's "Yes/No"
);


--1.Feedback Comparison (i.e. Average Feedback score of the same product when bought from different channels (Store type)).
SELECT 
    ProductName, 
    StoreType, 
    ROUND(AVG(FeedbackScore),3) AS AvgFeedbackScore,
    COUNT(*) AS TotalTransactions
FROM sales_data
GROUP BY ProductName, StoreType
HAVING productname is not null and storetype is not null
ORDER BY ProductName, AvgFeedbackScore DESC;
--OUTPUT
"productname"	"storetype"	"avgfeedbackscore"	"totaltransactions"
"Apple"	        "In-Store"	    3.006	        44793
"Apple"	        "Online"	    3.001	        45177
"Laptop"	    "In-Store"	    3.003	        44867
"Laptop"	    "Online"	    2.990	        44942
"Notebook"	    "Online"	    3.009	        45251
"Notebook"	    "In-Store"	    2.996	        45043



-- 2. Product with Highest Return rate 
SELECT 
    ProductName, 
    COUNT(*) AS TotalOrders,
    SUM(CASE WHEN Returned = 'Yes' THEN 1 ELSE 0 END) AS ReturnedOrders,
    ROUND((SUM(CASE WHEN Returned = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)),2)  AS ReturnRate
FROM sales_data
GROUP BY ProductName
ORDER BY returnrate DESC
LIMIT 1;
--OUTPUT 2
"productname"	"totalorders"	"returnedorders"	"returnrate"
   "Apple"	        89970	        45033	            50.05