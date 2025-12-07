
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
 
<<<<<<< HEAD
 SELECT SUBSTRING(`date` , 1 , 7) AS `MONTH` , SUM(total_laid_off)
 FROM layoffs_staging4
 GROUP BY `MONTH`
 ORDER BY 1 ASC ;
 
  
=======
 WITH Rolling_Total AS   
 (
 SELECT SUBSTRING(`date` , 1 , 7) AS `MONTH` , SUM(total_laid_off) AS total_off
 FROM layoffs_staging4
 WHERE SUBSTRING(`date` , 1 , 7) IS NOT NULL
 GROUP BY `MONTH`
 ORDER BY 1 ASC )
 
SELECT `MONTH` , total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total   # this is the rolling total 
FROM Rolling_Total;

 # Normal total Sum in the `MONTH` 
 
 SELECT SUBSTRING(`date` , 1 , 7) AS `MONTH` , SUM(total_laid_off) AS total_off  # using substring to select only the months and years named it `MONTHS'
                                                                                  # total_off as the amount for that particular month 
 FROM layoffs_staging4 
 WHERE SUBSTRING(`date` , 1 , 7) IS NOT NULL   # removing all NULLS 
 GROUP BY `MONTH`  # grouping by the months 
 ORDER BY 1 ASC;   # order the grouping in ascending order according to the `MONTH` 
 
 
     SELECT company, SUM(total_laid_off)
 FROM layoffs_staging4
 GROUP BY company 
 ORDER BY 2 DESC; 
 

      SELECT company, YEAR(`date`), SUM(total_laid_off)
 FROM layoffs_staging4
 GROUP BY company , YEAR(`date`)
 ORDER BY 3 DESC; 
 
 -- using CTE to rank the 
 
 WITH Company_Year (company , years , total_laid_off) AS  # the ones in the brackets are used to change the names of the columns 
 
	# Using CTE  
 (
      SELECT company, YEAR(`date`), SUM(total_laid_off)
 FROM layoffs_staging4
 GROUP BY company , YEAR(`date`)
 ), 
     
     # Another CTE for ranking 
 Company_Year_Rank AS
 
 (SELECT * , DENSE_RANK() OVER( PARTITION BY years ORDER BY total_laid_off DESC) AS rank_laid
 FROM Company_Year
 WHERE years IS NOT NULL  # removing nulls
 )
   SELECT *
   FROM Company_Year_Rank   
   WHERE rank_laid <= 5;  # ranking them year by year top 5 
   
   
 
>>>>>>> c8c86b13f5f8dbafbcc4820b18b23a4898f1e56c
