   
   -- DATA CLEANING 
   
SELECT *
FROM layoffs;


-- Step1 : Remove duplicates 
-- Step2 : Standardize the Data (Spellings) 
-- Step3 : Null Values or Blank values 
-- Step4 : Remove unnecesary columns or rows 

<<<<<<< HEAD
 # You're creating a blank table with the same structure as layoffs, then filling it with all the data from layoffs (duplicate)
 
CREATE TABLE layoffs_staging 
LIKE layoffs;    # It copies the structure/schema of the table layoffs ..basically a rough copy 
			     # But no data is copied yet, just the structure.


INSERT layoffs_staging  # This line copies the actual data/records..... contents and all 
SELECT *
FROM layoffs;   # So now, layoffs_staging becomes a full duplicate of layoffs



SELECT *,
ROW_NUMBER() OVER(      # Creates a new column called row_num

PARTITION BY company ,location, stage, 
country, funds_raised_millions, industry ,
 total_laid_off , percentage_laid_off , `date`) AS row_num
# PARTITION BY company, location,....Groups rows that have the same values in all these columns:
# Used to detect duplicates ...they must all show as 1(just 1 like that particular row)  if there is a 2 then they are duplicates
FROM layoffs_staging;
 
  -- CHECKING FOR DUPLICATES IN ALL COLUMNS 
  
WITH duplicate_cte AS # This creates a CTE named duplicate_cte for the duplicates 
=======
 # Creating a table we can work with instead of the main table 
 
CREATE TABLE layoffs_staging 
LIKE layoffs;




INSERT layoffs_staging
SELECT *
FROM layoffs;


SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company ,location, stage, country, funds_raised_millions, industry , total_laid_off , percentage_laid_off , `date`) AS row_num
FROM layoffs_staging;
 
 # CHECKING FOR DUPLICATES IN ALL COLUMNS 
WITH duplicate_cte AS 
>>>>>>> c8c86b13f5f8dbafbcc4820b18b23a4898f1e56c
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company ,location, 
<<<<<<< HEAD
stage, country, funds_raised_millions,                        # Copied code that brought out the row numbers earlier 
industry , total_laid_off , percentage_laid_off , `date`) AS row_num
FROM layoffs_staging
) 
     -- Brings out the duplicates 
SELECT *
FROM duplicate_cte   # Selected the CTE named duplicate_cte ....
WHERE row_num > 1;   # And used the WHERE query to pull out the duplicates since their row number > 1

SELECT * 
FROM layoffs_staging
WHERE company = 'Casper'; # checking Casper company name to be sure it is just 2 duplicates ....
# there are 3 Caspers but one has a different date so that make just 2 duplicates 





-- Creating a new layoffs table to delete the duplicates 

#Why you did this:
#You needed a place to store your data along with the row_num column.
#The original table (layoffs_staging) did not have a row_num column.
#row_num is necessary to identify duplicates (row_num > 1).
#So you created layoffs_staging4 as a new table where you could insert data that includes row_num.

    
CREATE TABLE `layoffs_staging4` (    # change the name because its a diferent table 
=======
stage, country, funds_raised_millions, 
industry , total_laid_off , percentage_laid_off , `date`) AS row_num
FROM layoffs_staging
) 

SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT * 
FROM layoffs_staging
WHERE company = 'Casper';


# Creating a new layoffs table to delete the duplicates
CREATE TABLE `layoffs_staging4` (    # change the name 
>>>>>>> c8c86b13f5f8dbafbcc4820b18b23a4898f1e56c
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
<<<<<<< HEAD
  `row_num` INT                                   # add this for the row number column 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
 
-- How to get this 
    # go to schema section > find the table you want > right click > click copy to clipboard > copy CREATE statement 

 # Make sure to refresh after doing this 




SELECT * 
FROM layoffs_staging4   
WHERE row_num > 1;     # This would only show the column without the contents because you have not inserted the contents in the new table

INSERT INTO layoffs_staging4  # inserts the contents of the columns using INSERT INTO 
SELECT *,        # This is what we are inserting in the columns
ROW_NUMBER() OVER(  
PARTITION BY company ,location, 
stage, country, funds_raised_millions, 
industry , total_laid_off , percentage_laid_off , `date`) AS row_num   # the contents of row number
=======
  `row_num` INT  # add this 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT * 
FROM layoffs_staging4   # inserts just the columns 
WHERE row_num > 1;

INSERT INTO layoffs_staging4  # inserts the contents of the columns 
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company ,location, 
stage, country, funds_raised_millions, 
industry , total_laid_off , percentage_laid_off , `date`) AS row_num
>>>>>>> c8c86b13f5f8dbafbcc4820b18b23a4898f1e56c
FROM layoffs_staging;

SET SQL_SAFE_UPDATES = 0;  # Allows delete function to work

DELETE    # deletes the duplicate 
FROM layoffs_staging4
WHERE row_num > 1;

SELECT*    # to check if the duplicates are deleted 
FROM layoffs_staging4
WHERE row_num > 1;

<<<<<<< HEAD
# And conclusion nothing would show ....duplicates have been removed 
 
 
 
 
 
 
 
 
 
 -- STANDARDIZING DATA 
=======
 
 # STANDARDIZING DATA 
>>>>>>> c8c86b13f5f8dbafbcc4820b18b23a4898f1e56c
 
 SET SQL_SAFE_UPDATES = 0;
 
 -- Trimming company column
 
<<<<<<< HEAD
SELECT company , (TRIM(company))   # Showing the initial look and the TRIM version of company column   
FROM layoffs_staging4;
 
UPDATE layoffs_staging4
SET company =  TRIM(company);    # UPDATE is to update and SET the company column to a TRIM version 
=======
SELECT company , (TRIM(company))     # DISTINCT list all without repeating anyone in that specific column
FROM layoffs_staging4;
 
UPDATE layoffs_staging4
SET company =  TRIM(company);
>>>>>>> c8c86b13f5f8dbafbcc4820b18b23a4898f1e56c


 -- changing name of things in industry column  
 
<<<<<<< HEAD
 SELECT DISTINCT industry    # DISTINCT -- list all without repeating anyone in that specific column
FROM layoffs_staging4;      # we are using this to check if any industry was misspelt or the same name was repeated twice but with a suffix or an unecessary letter  


UPDATE layoffs_staging4     
SET industry = 'Crypto'       # % means anything after or anything before or anthing in between 
WHERE industry LIKE 'Crypto%';  # This renamed everything that looked like 'crypto%' int just 'crypto'


# so now only one Crypto industry would exist instead of Cryptoss


SELECT DISTINCT country
FROM layoffs_staging4
ORDER BY 1;   # sort in alphabetical order based on the 1st column after the SELECT query 
=======
 SELECT DISTINCT industry 
FROM layoffs_staging4
 ;

UPDATE layoffs_staging4
SET industry = 'Crypto' 
WHERE industry LIKE 'Crypto%';  # This renamed everything that looked like 'crypto%' int just 'crypto'



SELECT DISTINCT country
FROM layoffs_staging4
ORDER BY 1; 
>>>>>>> c8c86b13f5f8dbafbcc4820b18b23a4898f1e56c



SELECT *
<<<<<<< HEAD
FROM layoffs_staging4    
WHERE country LIKE 'United States%'     # After showing all the United States% it was shown that there was an issue similar to Crypto industry 
=======
FROM layoffs_staging4
WHERE country LIKE 'United States%'
>>>>>>> c8c86b13f5f8dbafbcc4820b18b23a4898f1e56c
ORDER BY 1; 

UPDATE layoffs_staging4
SET country = 'United States' 
<<<<<<< HEAD
WHERE country LIKE 'United states%';  # did the same for united states ....  Renamed all to United States
=======
WHERE country LIKE 'United states%';  # did the same for united states 
>>>>>>> c8c86b13f5f8dbafbcc4820b18b23a4898f1e56c

-- changing date to time/date instead of text 

SELECT `date` 
FROM  layoffs_staging4;

SELECT `date` ,
STR_TO_DATE(`date`, '%m/%d/%Y')  # this corrects the date dtype '%m/%d/%Y'
FROM  layoffs_staging4;

UPDATE layoffs_staging4
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

<<<<<<< HEAD
ALTER TABLE layoffs_staging4  # ALTER used to change the structure of the table....Alters the table
MODIFY COLUMN `date` DATE;    # changes the column datatype to a proper DATE type instead of text.

    # date column dtype has been changed to date

SELECT * 
FROM layoffs_staging4;   # Checking for errors to fix ....remains nulls 







-- REMOVING BLANKS & NULLS 

SELECT * 
FROM layoffs_staging4
WHERE total_laid_off IS NULL      # WHERE applies a condition to filter the rows with the ones with nulls ...
AND percentage_laid_off IS NULL;  # ....on both the total_laid_off and percentage_laid_off
=======
ALTER TABLE layoffs_staging4
MODIFY COLUMN `date` DATE;

SELECT * 
FROM layoffs_staging4;

-- REMOVING BLANKS & NULLS alter

SELECT * 
FROM layoffs_staging4
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
>>>>>>> c8c86b13f5f8dbafbcc4820b18b23a4898f1e56c

-- changing blanks to nulls

UPDATE layoffs_staging4
<<<<<<< HEAD
SET industry = NULL  # Changing all blanks to nulls to easily be able to edit them since they are the same thing 
WHERE industry = '';   
=======
SET industry = NULL
WHERE industry = '';
>>>>>>> c8c86b13f5f8dbafbcc4820b18b23a4898f1e56c



SELECT *
FROM layoffs_staging4
<<<<<<< HEAD
WHERE industry IS NULL    # calling out all the nulls and blanks ( there shouldn't be any blanks because we have changed them to nulls)
OR industry = '' ; 

 -- updating Airbnb industry column so they can all have the same 'Travel'
 
SELECT * 
FROM layoffs_staging4
WHERE company = 'Airbnb' ;  # This simply displays all records where the company is Airbnb

SELECT T1.industry , T2.industry    # Selecting the in industries in the two diferent alike tables 
FROM layoffs_staging4 T1       # calling the first table T1 
JOIN layoffs_staging4 T2       # calling the second table T2  and using JOIN query to compare them 
  ON T1.company = T2.company    # Comparing the company of T1 and T2 
  AND T1.location = T2.location  # Comparing the industry of T1 and T2 
  WHERE (T1.industry IS NULL OR T1.industry = '')  # Show us rows that have industry T1 as null or industry T1 as blank 
AND T2.industry IS NOT NULL;  # AND also show us rows that have no nulls in industry T2


     # The idea of this is to fix values of things in the countries or industries columns that are blank that should supposedly have contents that were not fixed initially instead of blanks and nulls 
     # so we made T1 a table from the initial table that has industry as NUll or BlANKS .....
     # Then we made T2 NOT NULL meaning it must have contents in them 
     # Then we compared them and want the NULLS and BLANKS to have the same as the ones with contents 
     
     
UPDATE layoffs_staging4 T1
JOIN layoffs_staging4 T2
  ON T1.company = T2.company         # the companies must be the same 
  SET T1.industry = T2.industry       # Where the conditions are met, replace T1's industry (which is empty/missing) with T2's industry (which is filled)
    WHERE (T1.industry IS NULL )  
AND T2.industry IS NOT NULL;        # Summary of this we made T1 industry ( the ones with BLANKS and NULLS) = T2 industry ( the ones with contents ) ....so that the ones without contents would now have contents in them
									# now it is updated 


SELECT * 
FROM layoffs_staging4         
WHERE company LIKE 'Bally%' ;  # just checking if there were any issues 
=======
WHERE industry IS NULL 
OR industry = '' ; 

 -- updating Airbnb industry column so they can all have the same 'Travel'
SELECT * 
FROM layoffs_staging4
WHERE company = 'Airbnb' ;

SELECT T1.industry , T2.industry
FROM layoffs_staging4 T1
JOIN layoffs_staging4 T2
  ON T1.company = T2.company 
  AND T1.location = T2.location
  WHERE (T1.industry IS NULL OR T1.industry = '')  # Show us rows that have industry t1 as null or industry t1 as blank 
AND T2.industry IS NOT NULL;  # Show us rows that have no nulls in industry t2


UPDATE layoffs_staging4 T1
JOIN layoffs_staging4 T2
  ON T1.company = T2.company 
  SET T1.industry = T2.industry
    WHERE (T1.industry IS NULL )  
AND T2.industry IS NOT NULL; 


SELECT * 
FROM layoffs_staging4
WHERE company LIKE 'Bally%' ;
>>>>>>> c8c86b13f5f8dbafbcc4820b18b23a4898f1e56c
  
  
  SELECT * 
FROM layoffs_staging4
WHERE total_laid_off IS NULL
<<<<<<< HEAD
AND percentage_laid_off IS NULL;    # Selecting the NULLS in percentage_laid_off AND total_laid_off at the same time ...
=======
AND percentage_laid_off IS NULL;
>>>>>>> c8c86b13f5f8dbafbcc4820b18b23a4898f1e56c

DELETE 
FROM layoffs_staging4
WHERE total_laid_off IS NULL
<<<<<<< HEAD
AND percentage_laid_off IS NULL;  # This is for removing those NULL values because they are useless since those are the key columns in the whole data 
=======
AND percentage_laid_off IS NULL;  # This is for removing specific null values 
>>>>>>> c8c86b13f5f8dbafbcc4820b18b23a4898f1e56c

SELECT * 
FROM layoffs_staging4;

-- to remove columns 

ALTER TABLE layoffs_staging4
<<<<<<< HEAD
DROP COLUMN row_num;       # We are done with row number column so we are dropping it 
=======
DROP COLUMN row_num;
>>>>>>> c8c86b13f5f8dbafbcc4820b18b23a4898f1e56c
