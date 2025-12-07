
 -- EDA PROJECT (Exploratory Data Analysis)
 
 SELECT * 
 FROM layoffs_staging4;
 
 
 SELECT MAX(total_laid_off) , MAX(percentage_laid_off)     # Maximun laid off and the percentage laid off 
 FROM layoffs_staging4;
 
 
 
  SELECT company , SUM(total_laid_off)
 FROM layoffs_staging4
 GROUP BY company 
 ORDER BY 2 DESC;   # company is 1 SUM...is 2
 
 SELECT MIN(`date`) , MAX(`date`)
  FROM layoffs_staging4;
 
 
   SELECT industry , SUM(total_laid_off)
 FROM layoffs_staging4
 GROUP BY industry    # industry with the highest total_laid_off
 ORDER BY 2 DESC;
    
    SELECT country , SUM(total_laid_off)
 FROM layoffs_staging4
 GROUP BY country
 ORDER BY 2 DESC;
 
  SELECT * 
 FROM layoffs_staging4;
 
   SELECT YEAR(`date`) , SUM(total_laid_off)
 FROM layoffs_staging4
 GROUP BY YEAR(`date`)
 ORDER BY 1 DESC;
 
    SELECT stage, SUM(total_laid_off)
 FROM layoffs_staging4
 GROUP BY stage
 ORDER BY 2 DESC;
 
 
 # rolling total lay offs 
 
 -- based off the month 
 
 SELECT SUBSTRING(`date` , 1 , 7) AS `MONTH` , SUM(total_laid_off)
 FROM layoffs_staging4
 GROUP BY `MONTH`
 ORDER BY 1 ASC ;
 
  