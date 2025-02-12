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

