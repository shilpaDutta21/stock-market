create database stock;
use stock;

CREATE TABLE stock_data (
    stock_id INT AUTO_INCREMENT PRIMARY KEY,
    stock_symbol VARCHAR(10),
    date DATE,
    open_price DECIMAL(10, 2),
    high_price DECIMAL(10, 2),
    low_price DECIMAL(10, 2),
    close_price DECIMAL(10, 2),
    volume BIGINT,
    adj_close DECIMAL(10, 2)
);
INSERT INTO stock_data (stock_symbol, date, open_price, high_price, low_price, close_price, volume, adj_close)
VALUES 
    ('AAPL', '2024-11-01', 150.00, 152.50, 148.75, 151.00, 28000000, 150.75),
    ('AAPL', '2024-11-02', 151.00, 153.00, 149.50, 150.00, 30000000, 149.90),
    ('AAPL', '2024-11-03', 150.00, 155.00, 149.00, 154.00, 25000000, 153.70),
    ('AAPL', '2024-11-04', 154.00, 156.50, 153.00, 155.00, 27000000, 154.90),
    ('AAPL', '2024-11-05', 155.00, 157.00, 152.50, 156.50, 32000000, 156.30),
    ('AAPL', '2024-11-06', 156.50, 159.00, 155.50, 157.00, 31000000, 156.80),
    ('AAPL', '2024-11-07', 157.00, 160.50, 156.00, 159.50, 34000000, 159.20),
    ('AAPL', '2024-11-08', 159.50, 162.00, 158.00, 161.00, 35000000, 160.90),
    ('AAPL', '2024-11-09', 161.00, 163.50, 160.00, 162.50, 36000000, 162.20),
    ('AAPL', '2024-11-10', 162.50, 165.00, 161.50, 164.00, 38000000, 163.80);



-- Queries for stock market analysis
-- Get the daily price range

SELECT 
    date,
    stock_symbol,
    close_price - open_price AS daily_change
FROM 
    stock_data
ORDER BY 
    date;
    
    -- Calculate the Moving Average
    SELECT 
    date,
    stock_symbol,
    close_price,
    AVG(close_price) OVER (PARTITION BY stock_symbol ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS moving_avg_7d
FROM 
    stock_data;

  SELECT 
    stock_symbol,
    MAX(close_price) AS highest_price,
    MIN(close_price) AS lowest_price
FROM 
    stock_data
WHERE 
    date BETWEEN '2024-11-01' AND '2024-1-10'
GROUP BY 
    stock_symbol;
  
  -- calculate monthly return
  SELECT 
    stock_symbol,
    DATE_FORMAT(date, '%Y-%m') AS month,
    (MAX(close_price) - MIN(open_price)) / MIN(open_price) * 100 AS monthly_return_percentage
FROM 
    stock_data
GROUP BY 
    stock_symbol, month;
    
    -- Identify days with usually high volume
    SELECT 
    stock_symbol,
    DATE_FORMAT(date, '%Y-%m') AS month,
    (MAX(close_price) - MIN(open_price)) / MIN(open_price) * 100 AS monthly_return_percentage
FROM 
    stock_data
GROUP BY 
    stock_symbol, month;
    
    -- Calculate yearly performance
    SELECT 
    stock_symbol,
    YEAR(date) AS year,
    (MAX(close_price) - MIN(open_price)) / MIN(open_price) * 100 AS yearly_performance_percentage
FROM 
    stock_data
GROUP BY 
    stock_symbol, year;
    
    -- Identify upward and downward trends
    SELECT 
    date,
    stock_symbol,
    close_price,
    LAG(close_price, 1) OVER (PARTITION BY stock_symbol ORDER BY date) AS prev_close,
    CASE 
        WHEN close_price > LAG(close_price, 1) OVER (PARTITION BY stock_symbol ORDER BY date) THEN 'Upward'
        WHEN close_price < LAG(close_price, 1) OVER (PARTITION BY stock_symbol ORDER BY date) THEN 'Downward'
        ELSE 'No Change'
    END AS trend
FROM 
    stock_data
ORDER BY 
    date;




