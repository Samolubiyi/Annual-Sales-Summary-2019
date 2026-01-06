/* =====================================================
   SALES MANAGER DASHBOARD – SQL (2019)
   Goal:
   - Run each query
   - Export results to Excel
   - Use Excel in Tableau
   ===================================================== */


/* =========================
   1. KPI SUMMARY
   Used for big number cards:
   - Total Revenue
   - Total Profit
   - Total Orders
   ========================= */

SELECT
    SUM(Revenue) AS Total_Revenue_2019,
    SUM(Profit) AS Total_Profit_2019,
    COUNT(DISTINCT [Order ID]) AS Total_Orders_2019
FROM SalesManger..sales_data$
WHERE YEAR(TRY_CAST([Order Date] AS DATE)) = 2019;


/* =========================
   2. MONTHLY REVENUE
   Used for:
   - Line or bar chart
   - Jan to Dec trend
   ========================= */

SELECT
    MONTH(TRY_CAST([Order Date] AS DATE)) AS Order_Month,
    SUM(Revenue) AS Monthly_Revenue
FROM SalesManger..sales_data$
WHERE YEAR(TRY_CAST([Order Date] AS DATE)) = 2019
GROUP BY MONTH(TRY_CAST([Order Date] AS DATE))
ORDER BY Order_Month;


/* =========================
   3. REVENUE BY CATEGORY
   Used for:
   - Category / Brand chart
   ========================= */

SELECT
    Category,
    SUM(Revenue) AS Category_Revenue
FROM SalesManger..sales_data$
WHERE YEAR(TRY_CAST([Order Date] AS DATE)) = 2019
GROUP BY Category
ORDER BY Category_Revenue DESC;


/* =========================
   4. TOP 10 PRODUCTS
   Used for:
   - Top products chart
   - Revenue vs Quantity
   ========================= */

SELECT TOP 10
    Product,
    SUM(Revenue) AS Product_Revenue,
    SUM([Quantity ]) AS Quantity_Sold
FROM SalesManger..sales_data$
WHERE YEAR(TRY_CAST([Order Date] AS DATE)) = 2019
GROUP BY Product
ORDER BY Product_Revenue DESC;


/* =========================
   5. MASTER DATASET
   Use if you want:
   - One Excel file
   - All calculations in Tableau
   ========================= */

SELECT
    TRY_CAST([Order Date] AS DATE) AS Order_Date,
    [Order ID] AS Order_ID,
    Product,
    Category,
    [Quantity ] AS Quantity,
    Revenue,
    Profit
FROM SalesManger..sales_data$
WHERE YEAR(TRY_CAST([Order Date] AS DATE)) = 2019;


/* =========================
   DATA CLEANING – CATEGORY
   Fix encoding issues
   ========================= */

-- Check category values
SELECT DISTINCT Category
FROM SalesManger..sales_data$;

-- Fix common encoding issue
UPDATE SalesManger..sales_data$
SET Category = REPLACE(Category, 'Ã‰', 'É');

-- Fix remaining broken value
UPDATE SalesManger..sales_data$
SET Category = N'Vêtements'
WHERE Category = 'VÃªtements';
