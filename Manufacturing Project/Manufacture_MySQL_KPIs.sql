Create database excelr_project_3;

-- 1st KPI (Manufactured Qty)
select concat(round(sum(Today_Manufactured_qty/1000000))," M") as "Manufactured Qty" from manufacturing_report;

-- 2nd KPI (Rejected Qty)
select concat(format(sum(rejected_qty/1000000),2)," M") as "Rejected Qty" from manufacturing_report;

-- 3rd KPI (Processed Qty)
select concat(round(sum(processed_qty/1000000))," M") as "Processed Qty" from manufacturing_report;

-- 4th KPI (Wastage Qty)
select concat(format(sum(rejected_qty/1000000),2)," M") as "Wastage Qty" from manufacturing_report;

-- 5th KPI (Employee wise Rejected Qty)
select emp_name, concat(format(sum(rejected_qty/1000000),2)," M") as "Rejected Qty" from manufacturing_report group by Emp_Name;

-- 6th KPI (Machine wise Rejected Qty)
select Machine_Code, sum(rejected_qty) as "Rejected Qty" from manufacturing_report group by Machine_Code;

-- 7th KPI (Production Comparison Trend)
select max(monthname(doc_date)), concat(format(sum(Today_Manufactured_qty/1000000),2)," M") as "Manufactured Qty" from manufacturing_report group by month(doc_date) order by month(doc_date);

-- 8th KPI (Manufactured vs Rejected)
select concat(round(sum(Today_Manufactured_qty/1000000))," M") as "Manufactured Qty", concat(format(sum(rejected_qty/1000000),2)," M") as "Rejected Qty" from manufacturing_report;

-- 9th KPI (Dept wise Manufactured vs Rejected)
 select Department_Name, concat(round(sum(Today_Manufactured_qty/1000000))," M") as "Manufactured Qty", 
 concat(format(sum(rejected_qty/1000000),2)," M") as "Rejected Qty" from manufacturing_report group by Department_Name;
 
 