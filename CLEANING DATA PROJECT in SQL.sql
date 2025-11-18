   
   -- DATA CLEANING 
   
SELECT *
FROM layoffs;


-- Step1 : Remove duplicates 
-- Step2 : Standardize the Data (Spellings) 
-- Step3 : Null Values or Blank values 
-- Step4 : Remove unnecesary columns or rows 

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
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company ,location, 
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
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
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
FROM layoffs_staging;

SET SQL_SAFE_UPDATES = 0;  # Allows delete function to work

DELETE    # deletes the duplicate 
FROM layoffs_staging4
WHERE row_num > 1;

SELECT*    # to check if the duplicates are deleted 
FROM layoffs_staging4
WHERE row_num > 1;

 
 # STANDARDIZING DATA 
 
 SET SQL_SAFE_UPDATES = 0;
 
 -- Trimming company column
 
SELECT company , (TRIM(company))     # DISTINCT list all without repeating anyone in that specific column
FROM layoffs_staging4;
 
UPDATE layoffs_staging4
SET company =  TRIM(company);


 -- changing name of things in industry column  
 
 SELECT DISTINCT industry 
FROM layoffs_staging4
 ;

UPDATE layoffs_staging4
SET industry = 'Crypto' 
WHERE industry LIKE 'Crypto%';  # This renamed everything that looked like 'crypto%' int just 'crypto'



SELECT DISTINCT country
FROM layoffs_staging4
ORDER BY 1; 



SELECT *
FROM layoffs_staging4
WHERE country LIKE 'United States%'
ORDER BY 1; 

UPDATE layoffs_staging4
SET country = 'United States' 
WHERE country LIKE 'United states%';  # did the same for united states 

-- changing date to time/date instead of text 

SELECT `date` 
FROM  layoffs_staging4;

SELECT `date` ,
STR_TO_DATE(`date`, '%m/%d/%Y')  # this corrects the date dtype '%m/%d/%Y'
FROM  layoffs_staging4;

UPDATE layoffs_staging4
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging4
MODIFY COLUMN `date` DATE;

SELECT * 
FROM layoffs_staging4;

-- REMOVING BLANKS & NULLS alter

SELECT * 
FROM layoffs_staging4
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- changing blanks to nulls

UPDATE layoffs_staging4
SET industry = NULL
WHERE industry = '';



SELECT *
FROM layoffs_staging4
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
  
  
  SELECT * 
FROM layoffs_staging4
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE 
FROM layoffs_staging4
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;  # This is for removing specific null values 

SELECT * 
FROM layoffs_staging4;

-- to remove columns 

ALTER TABLE layoffs_staging4
DROP COLUMN row_num;
