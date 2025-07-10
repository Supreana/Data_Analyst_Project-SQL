-- Blank and NULL values

SELECT t1. industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2 
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry ='';

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2 
	ON t1.company = t2.company
SET t1.industry = t2.industry 
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

select *
from layoffs_staging2
WHERE company = 'Airbnb';

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_layoff IS NULL;

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_layoff IS NULL;


DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_layoff IS NULL;

SELECT * 
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num
