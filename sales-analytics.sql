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


WITH FeedbackComparison AS (
    SELECT 
        ProductName, StoreType, 
        ROUND(AVG(FeedbackScore),3) AS AvgFeedbackScore,
        COUNT(*) AS TotalTransactions
    FROM sales_data
    WHERE ProductName IS NOT NULL AND StoreType IS NOT NULL
    GROUP BY ProductName, StoreType
), 

ProductReturnRate AS (
    SELECT 
        ProductName, 
        COUNT(*) AS TotalOrders,
        SUM(CASE WHEN Returned = 'Yes' THEN 1 ELSE 0 END) AS ReturnedOrders,
        ROUND((SUM(CASE WHEN Returned = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)),2)  AS ReturnRate
    FROM sales_data
    GROUP BY ProductName
    ORDER BY ReturnRate DESC
    LIMIT 1
), 

PopularProducts AS (
    SELECT 
        ProductName, 
        SUM(Quantity) AS TotalQuantitySold,
        SUM(TransactionAmount) AS TotalRevenue
    FROM sales_data
    WHERE ProductName IS NOT NULL
    GROUP BY ProductName
    ORDER BY TotalQuantitySold DESC
    LIMIT 10
), 

TopPaymentMethods AS (
    SELECT PaymentMethod, COUNT(*) AS TotalOrders
    FROM sales_data
    GROUP BY PaymentMethod
    ORDER BY TotalOrders DESC
    LIMIT 3
), 

TopCities AS (
    SELECT City, COUNT(*) AS TotalOrders
    FROM sales_data
    GROUP BY City
    ORDER BY TotalOrders DESC
    LIMIT 3
), 

TopCustomer AS (
    SELECT CustomerID, COUNT(*) AS TotalOrders
    FROM sales_data
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
    ORDER BY TotalOrders DESC
    LIMIT 1
), 

OrdersByAge AS (
    SELECT 
        CASE 
            WHEN CustomerAge BETWEEN 18 AND 25 THEN '18-25'
            WHEN CustomerAge BETWEEN 26 AND 35 THEN '26-35'
            WHEN CustomerAge BETWEEN 36 AND 45 THEN '36-45'
            WHEN CustomerAge BETWEEN 46 AND 60 THEN '46-60'
            WHEN CustomerAge IS NULL THEN '0'
            ELSE '60+'
        END AS AgeRange,
        COUNT(*) AS TotalOrders
    FROM sales_data
    GROUP BY AgeRange
    ORDER BY TotalOrders DESC
    LIMIT 5
), 

OrdersByGender AS (
    SELECT CustomerGender, COUNT(*) AS TotalOrders
    FROM sales_data
    GROUP BY CustomerGender
    ORDER BY TotalOrders DESC
    LIMIT 1
), 

TopRegions AS (
    SELECT Region, COUNT(*) AS TotalOrders
    FROM sales_data
    GROUP BY Region
    ORDER BY TotalOrders DESC
    LIMIT 3
), 

SalesByRegion AS (
    SELECT 
        Region, 
        SUM(TransactionAmount) AS TotalRevenue, 
        COUNT(*) AS TotalTransactions
    FROM sales_data
    WHERE Region IS NOT NULL
    GROUP BY Region
    ORDER BY TotalRevenue DESC
), 

StorePerformance AS (
    SELECT StoreType, SUM(TransactionAmount) AS Revenue
    FROM sales_data
    WHERE StoreType IS NOT NULL
    GROUP BY StoreType
    ORDER BY Revenue DESC
), 

ProductReturnCounts AS (
    SELECT ProductName, COUNT(*) AS ReturnCount
    FROM sales_data
    WHERE Returned = 'Yes'
    GROUP BY ProductName
    ORDER BY ReturnCount DESC
), 

TopLoyaltyCustomers AS (
    SELECT CustomerID, SUM(LoyaltyPoints) AS TotalPoints
    FROM sales_data
    GROUP BY CustomerID
    ORDER BY TotalPoints DESC
    LIMIT 5
)

--1
SELECT * FROM FeedbackComparison;
-- OUTPUT:
-- "productname"  "storetype"   "avgfeedbackscore" "totaltransactions"
-- "Apple"        "In-Store"    3.006              44793
-- "Apple"        "Online"      3.001              45177
-- "Laptop"       "In-Store"    3.003              44867
-- "Laptop"       "Online"      2.990              44942
-- "Notebook"     "Online"      3.009              45251
-- "Notebook"     "In-Store"    2.996              45043

--2
SELECT * FROM ProductReturnRate;
-- OUTPUT:
-- "productname"  "totalorders"  "returnedorders"  "returnrate"
-- "Apple"        89970         45033             50.05


--3
SELECT * FROM PopularProducts;
-- OUTPUT:
-- "productname"  "totalquantitysold"  "totalrevenue"
-- "Apple"       2296713               22300717.86
-- "Notebook"    498649                 24079586.12
-- "T-Shirt"     270545                102306079.47
-- "Laptop"      89809                 6231220430.24
-- "Sofa"        89740                 3777022903.56

--4
SELECT * FROM TopPaymentMethods;
-- OUTPUT:
-- "paymentmethod"  "totalorders"
-- "Debit Card"     113015
-- "Cash"           112625
-- "UPI"            112517

--5
SELECT * FROM TopCities;
-- OUTPUT:
-- "city"         "totalorders"
-- "Bangalore"    50319
-- "Delhi"        50215
-- "Lucknow"      50190

--6
SELECT * FROM TopCustomer;
-- OUTPUT:
-- "customerid"  "totalorders"
-- 39402        24

--7
SELECT * FROM OrdersByAge;
-- OUTPUT:
-- "agerange"  "totalorders"
-- "46-60"     118833
-- "60+"       110116
-- "36-45"     79103
-- "26-35"     79001
-- "18-25"     62947

--8
SELECT * FROM OrdersByGender;
-- OUTPUT:
-- "customergender"  "totalorders"
-- "Other"          150257
-- "Male"          149970
-- "Female"        149773

--9
SELECT * FROM TopRegions;
-- OUTPUT:
-- "region"  "totalorders"
-- "South"   146124
-- "East"    118910
-- "West"    96167

--10
SELECT * FROM SalesByRegion;
-- OUTPUT:
-- "region"  "totalrevenue"     "totaltransactions"
-- "South"   3177273109.38      146124
-- "East"    2654969082.59      118910
-- "North"   2171502697.87      96166
-- "West"    2159911845.88      96167

--11
SELECT * FROM StorePerformance;
-- OUTPUT:
-- "storetype"  "revenue"
-- "In-Store"   5078881502.74
-- "Online"     5078048214.51

--12
SELECT * FROM ProductReturnCounts;
-- OUTPUT:
-- "productname"  "returncount"
-- "Notebook"     45061
-- "Apple"        45033
-- "Laptop"       44904
-- "T-Shirt"      44783
-- "Sofa"         44696

--13
SELECT * FROM TopLoyaltyCustomers;
-- OUTPUT:
-- "customerid"  "totalpoints"
-- 13497         132369
-- 15834         131318
-- 39402         130699
-- 24925         128162
-- 44185         123424
