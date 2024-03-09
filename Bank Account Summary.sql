-- Bank Account Summary using SQL
-- Write a query that produces a bank account summary according to the total balance after considering the transaction history for each account.
CREATE DATABASE Transactions;
USE transactions;

DROP TABLE IF EXISTS BankTransactions;


CREATE TABLE BankTransactions (
  AccountNumber INT,
  AccountHolderName VARCHAR(255),
  TransactionDate DATE,
  TransactionType VARCHAR(255),
  TransactionAmount DECIMAL(10, 2)
);

INSERT INTO BankTransactions (AccountNumber, AccountHolderName, TransactionDate, TransactionType, TransactionAmount)
VALUES
  (1001, 'Ravi Sharma', '2023-07-01', 'Deposit', 5000),
  (1001, 'Ravi Sharma', '2023-07-05', 'Withdrawal', 1000),
  (1001, 'Ravi Sharma', '2023-07-10', 'Deposit', 2000),
  (1002, 'Priya Gupta', '2023-07-02', 'Deposit', 3000),
  (1002, 'Priya Gupta', '2023-07-08', 'Withdrawal', 500),
  (1003, 'Vikram Patel', '2023-07-04', 'Deposit', 10000),
  (1003, 'Vikram Patel', '2023-07-09', 'Withdrawal', 2000);
  
 SELECT * FROM  BankTransactions;
 
 -- Now, here’s how to create a bank account summary using SQL for all the accounts in the database:
  SELECT 
       AccountNumber,
       AccountHolderName,
       SUM(CASE WHEN TransactionType = 'Deposit' THEN TransactionAmount Else -TransactionAmount END) AS TotalBalance
FROM 
    BankTransactions
GROUP BY 
    AccountNumber,AccountHolderName
ORDER BY 
    AccountNumber;
    
-- The SELECT statement to retrieve the necessary information from the “BankTransactions” table. 
-- It calculates the total balance for each account by summing the deposit amounts and subtracting the withdrawal amounts.
--  The CASE statement is used to differentiate between deposit and withdrawal transactions and appropriately adjust the transaction amounts.
--  The results are then grouped by the account number and account holder name using the GROUP BY clause. Finally, 
-- the results are ordered by the account number using the ORDER BY clause.











 
 
 
 
 
 
  
