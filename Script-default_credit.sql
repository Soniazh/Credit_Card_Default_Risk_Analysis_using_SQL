--check missing value and outlier
select sum(case when limit_bal is null then 1 else 0 end ) as missing_LIMIT_BAL,
       sum(case when sex is null then 1 else 0 end) as missing_SEX,
       sum(case when education is null then 1 else 0 end) as missing_EDUCATION,
       sum(case when marriage is null then 1 else 0 end) as missing_MARRIAGE,
       sum(case when age is null then 1 else 0 end) as missing_AGE
from credit;
select distinct education from credit order by 1;
select distinct marriage from credit order by 1;
select distinct sex from credit order by 1;
select distinct education_cleaned from credit order by 1;
select distinct marriage_cleaned from credit order by 1;
--deal with outlier
alter table credit add column education_cleaned integer;
update credit
set education_cleaned=case when education in (1,2,3,4) then education else 4 end;
alter table credit add column marriage_cleaned integer;
update credit
set marriage_cleaned=case when marriage in (1,2,3) then marriage else 3 end;
--Exploratory Data Analysis(total deafult rate, default relate with gender,education level,marriage state)
select count(*) as total_count, 
       sum("default payment next month") as default_count,
       round(100*sum("default payment next month")/count(*),2)|| '%' as default_rate
from credit;
select sex,
       count(*) as total_count, 
       sum("default payment next month") as default_count,
       round(100*sum("default payment next month")/count(*),2)|| '%' as default_rate
from credit
group by sex;
select education_cleaned as education_level,
       count(*) as total_count, 
       sum("default payment next month") as default_count,
       round(100*sum("default payment next month")/count(*),2)|| '%' as default_rate
from credit
group by education_level
order by 1;
select marriage_cleaned as marriage_state,
       count(*) as total_count, 
       sum("default payment next month") as default_count,
       round(100*sum("default payment next month")/count(*),2)|| '%' as default_rate
from credit
group by marriage_state
order by 1;
--Exploratory Data Analysis(default relate with credit limit, pay_0, multivariate cross-analysis(credit+gender)
select case when age<30 then 1
            when age between 30 and 39 then 2
            when age between 40 and 49 then 3
            when age>=50 then 4 end as age_rank,
       case when age<30 then 'under 30'
            when age between 30 and 39 then '30-39'
            when age between 40 and 49 then '40-49'
            when age>=50 then '50+'end as age_group,
       count(*) as total_count, 
       sum("default payment next month") as default_count,
       round(100*sum("default payment next month")/count(*),2)|| '%' as default_rate
from credit
group by age_rank, age_group
order by 1,2;
select case when limit_bal <50000 then 1
            when limit_bal between 50000 and 99999 then 2
            when limit_bal between 100000 and 149999 then 3
            when limit_bal between 150000 and 199999 then 4
            else 5 end as credit_limit_rank,
       case when limit_bal <50000 then '<50k'
            when limit_bal between 50000 and 99999 then '50k-100k'
            when limit_bal between 100000 and 149999 then '100k-150k'
            when limit_bal between 150000 and 199999 then '150k-200k'
            else '200k+' end as credit_limit_group,
       count(*) as total_count, 
       sum("default payment next month") as default_count,
       round(100*sum("default payment next month")/count(*),2)|| '%' as default_rate
from credit
group by 1,2
order by 1;
select pay_0,
       count(*) as total_count, 
       sum("default payment next month") as default_count,
       round(100*sum("default payment next month")/count(*),2)|| '%' as default_rate
from credit
group by 1
order by 1;
select case when limit_bal <50000 then 1
            when limit_bal between 50000 and 99999 then 2
            when limit_bal between 100000 and 149999 then 3
            when limit_bal between 150000 and 199999 then 4
            else 5 end as credit_limit_rank,
       case when limit_bal <50000 then '<50k'
            when limit_bal between 50000 and 99999 then '50k-100k'
            when limit_bal between 100000 and 149999 then '100k-150k'
            when limit_bal between 150000 and 199999 then '150k-200k'
            else '200k+' end as credit_limit_group,
       sex,
       count(*) as total_count, 
       sum("default payment next month") as default_count,
       round(100*sum("default payment next month")/count(*),2)|| '%' as default_rate
from credit
group by 1,2,3
order by 1,2
       