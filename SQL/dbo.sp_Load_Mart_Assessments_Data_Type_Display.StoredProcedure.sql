USE [SDW_Prod]
GO
/****** Object:  StoredProcedure [dbo].[sp_Load_Mart_Assessments_Data_Type_Display]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO












-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE    PROCEDURE [dbo].[sp_Load_Mart_Assessments_Data_Type_Display]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Lexile_Score__c'
	where AssessmentName = 'Achieve 3000 - ELA'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'X0_to_100_Scale_Score__c'
	where AssessmentName = 'Amplify - Math'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Percentile_PL__c'
	where AssessmentName = 'ANet - ELA'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Percentile_PL__c'
	where AssessmentName = 'ANet - Math'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'BPS_Predictive_Scaled_Score__c'
	where AssessmentName = 'BPS Predictive - ELA'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'BPS_Predictive_Scaled_Score__c'
	where AssessmentName = 'BPS Predictive - Math'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'SEL Composite T-Score (SEL_Composite_T_Score__c)'
	where AssessmentName = 'DESSA'

	/*

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'SEL Composite T-Score (SEL_Composite_T_Score__c)'
	where AssessmentName = 'DESSA-mini'

	*/

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'DIBELS_Grade_Level_Equivalent_Score__c'
	where AssessmentName = 'DIBELS - ELA'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_2 = 'DAZE__c'
	where AssessmentName = 'DIBELS - ELA'




	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'District_Benchmark__c'
	where AssessmentName = 'District Benchmark Assessments - ELA'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'District_Benchmark__c'
	where AssessmentName = 'District Benchmark Assessments - Math'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'DRA_Grade_Level_Equivalent_Score__c'
	where AssessmentName = 'DRA - ELA'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'X0_to_100_Scale_Score__c'
	where AssessmentName = 'EADMS - ELA'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'X0_to_100_Scale_Score__c'
	where AssessmentName = 'EADMS - Math'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'X0_to_300_Scaled_Score__c'
	where AssessmentName = 'EasyCBM - ELA'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'X0_to_300_Scaled_Score__c'
	where AssessmentName = 'EasyCBM - Math'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Explore_Composite_Score__c'
	where AssessmentName = 'Explore - Math'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Explore_Composite_Score__c'
	where AssessmentName = 'Explore - Reading - ELA'



	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'FSA_Algebra_Score__c'
	where AssessmentName = 'Florida State Assessment Algebra 1 - Math'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_2 = 'Percentile__c'
	where AssessmentName = 'Florida State Assessment Algebra 1 - Math'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'FSA_Math_Score__c'
	where AssessmentName = 'Florida State Assessment Mathematics - Math'

		update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_2 = 'Percentile__c'
	where AssessmentName = 'Florida State Assessment Mathematics - Math'






	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'FSA_ELA_Score__c'
	where AssessmentName = 'Florida State Assessment English Language Arts - ELA'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_2 = 'Percentile__c'
	where AssessmentName = 'Florida State Assessment English Language Arts - ELA'



	


	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'A_to_Z_Alpha_Scale__c'
	where AssessmentName = 'Fountas and Pinnell Benchmark Assessment System - ELA'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'X0_to_1000_Scaled_Score__c'
	where AssessmentName = 'iReady - ELA'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'IRLA_Grade_Level_Equivalent_Score__c'
	where AssessmentName = 'IRLA - ELA'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Lexile_Score__c'
	where AssessmentName = 'iStation Indicators of Progress - ELA'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Jerry_Johns_BRI_GLE_Score__c'
	where AssessmentName = 'Jerry Johns BRI - ELA'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Lexia_Step_Number__c'
	where AssessmentName = 'Lexia - ELA'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'X0_to_300_Scaled_Score__c'
	where AssessmentName = 'NWEA - ELA'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'X0_to_300_Scaled_Score__c'
	where AssessmentName = 'NWEA - Math'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Scantron_Scaled_Score__c'
	where AssessmentName = 'Scantron - ELA'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Scantron_Scaled_Score__c'
	where AssessmentName = 'Scantron - Math'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Quantile_Score__c'
	where AssessmentName = 'SMI: Scholastic Math Inventory - Math'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Lexile_Score__c'
	where AssessmentName = 'SRI: Scholastic Reading Inventory - ELA'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'TRC_Alpha_Scale_Score__c'
	where AssessmentName = 'TRC - ELA'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Percentile_PL__c'
	where AssessmentName = 'Wonders (McGraw Hill Readers) and Accelerated Reader - ELA'

	--THESE HAVE MULTIPLE SCORES PER ASSESSMENT(there are 7) ------------------------------------------------------------------

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'AIMSweb_ELA_Scale_score'
	where AssessmentName = 'AIMSweb - ELA'
		
	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_2 = 'Maze__c'
	where AssessmentName = 'AIMSweb - ELA'
	
	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_3 = 'DRA_Oral_Reading__c'
	where AssessmentName = 'AIMSweb - ELA'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_4 = 'Percentile__c'
	where AssessmentName = 'AIMSweb - ELA'

	
	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'AIMSweb_Math_Scale_score__c'
	where AssessmentName = 'AIMSweb - Math'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_2 = 'Percentile__c'
	where AssessmentName = 'AIMSweb - Math'


	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Quantile_Score__c'
	where AssessmentName = 'iReady - Math'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_2 = 'X0_to_1000_Scaled_Score__c'
	where AssessmentName = 'iReady - Math'


	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'STAR_Grade_Level_Equivalent_Score__c'
	where AssessmentName = 'STAR Math - Math'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_2 = 'X0_to_1000_Scaled_Score__c'
	where AssessmentName = 'STAR Math - Math'


	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'STAR_Grade_Level_Equivalent_Score__c'
	where AssessmentName = 'STAR Reading - ELA'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_2 = 'X0_to_1000_Scaled_Score__c'
	where AssessmentName = 'STAR Reading - ELA'

	--Florida Assessments For Instruction in Reading - ELA

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Average_Ability_Score__c'
	where AssessmentName = 'Florida Assessments For Instruction in Reading - ELA'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_2 = 'RCT_Ability_Score__c'
	where AssessmentName = 'Florida Assessments For Instruction in Reading - ELA'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_3 = 'VKT_Ability_Score__C'
	where AssessmentName = 'Florida Assessments For Instruction in Reading - ELA'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_4 = 'WRT_Ability_Score__c'
	where AssessmentName = 'Florida Assessments For Instruction in Reading - ELA'



	--Reporting Period Time Based Attendance Tracker - Attendance

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Days_Enrolled__c'
	where AssessmentName = 'Reporting Period Time Based Attendance Tracker - Attendance'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_2 = 'Number_of_Absences__c'
	where AssessmentName = 'Reporting Period Time Based Attendance Tracker - Attendance'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_3 = 'Number_of_Excused_Absences__c'
	where AssessmentName = 'Reporting Period Time Based Attendance Tracker - Attendance'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_4 = 'Number_of_Tardies__c'
	where AssessmentName = 'Reporting Period Time Based Attendance Tracker - Attendance'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_5 = 'Number_of_Unexcused_Absences__c'
	where AssessmentName = 'Reporting Period Time Based Attendance Tracker - Attendance'


	--'Cumulative Time Based Attendance Tracker - Attendance'
	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Days_Enrolled__c'
	where AssessmentName = 'Cumulative Time Based Attendance Tracker - Attendance'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_2 = 'Number_of_Absences__c'
	where AssessmentName = 'Cumulative Time Based Attendance Tracker - Attendance'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_3 = 'Number_of_Excused_Absences__c'
	where AssessmentName = 'Cumulative Time Based Attendance Tracker - Attendance'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_4 = 'Number_of_Tardies__c'
	where AssessmentName = 'Cumulative Time Based Attendance Tracker - Attendance'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_5 = 'Number_of_Unexcused_Absences__c'
	where AssessmentName = 'Cumulative Time Based Attendance Tracker - Attendance'
	

	--Cumulative Time Based Behavior Tracker - Behavior


	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Number_of_Detentions__c'
	where AssessmentName = 'Cumulative Time Based Behavior Tracker - BEHAVIOR'   --'Time Based Behavior Tracker - Behavior'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_2 = 'Number_of_In_School_Suspensions__c'
	where AssessmentName = 'Cumulative Time Based Behavior Tracker - BEHAVIOR'   --'Time Based Behavior Tracker - Behavior'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_3 = 'Number_of_Office_Referrals__c'
	where AssessmentName = 'Cumulative Time Based Behavior Tracker - BEHAVIOR'    --'Time Based Behavior Tracker - Behavior'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_4 = 'Number_of_Out_of_School_Suspensions__c'
	where AssessmentName = 'Cumulative Time Based Behavior Tracker - BEHAVIOR'    --'Time Based Behavior Tracker - Behavior'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_5 = 'Number_of_Suspensions__c'
	where AssessmentName = 'Cumulative Time Based Behavior Tracker - BEHAVIOR'    --'Time Based Behavior Tracker - Behavior'



	--Reporting Period Time Based Behavior Tracker - Behavior

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Number_of_Detentions__c'
	where AssessmentName = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR'   --'Time Based Behavior Tracker - Behavior'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_2 = 'Number_of_In_School_Suspensions__c'
	where AssessmentName = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR'   --'Time Based Behavior Tracker - Behavior'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_3 = 'Number_of_Office_Referrals__c'
	where AssessmentName = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR'    --'Time Based Behavior Tracker - Behavior'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_4 = 'Number_of_Out_of_School_Suspensions__c'
	where AssessmentName = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR'    --'Time Based Behavior Tracker - Behavior'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_5 = 'Number_of_Suspensions__c'
	where AssessmentName = 'Reporting Period Time Based Behavior Tracker - BEHAVIOR'    --'Time Based Behavior Tracker - Behavior'



	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Goals_set__c'
	where AssessmentName = '50 Acts of Greatness - Behavior'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_2 = 'Weekly_goal_progress__c'
	where AssessmentName = '50 Acts of Greatness - Behavior'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_3 = 'Greatness_Lesson__c'
	where AssessmentName = '50 Acts of Greatness - Behavior'


	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Goals_set__c'
	where AssessmentName = '50 Acts of Leadership - Behavior'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_2 = 'Leadership_lesson__c'
	where AssessmentName = '50 Acts of Leadership - Behavior'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_3 = 'Weekly_goal_progress__c'
	where AssessmentName = '50 Acts of Leadership - Behavior'



	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Check_ins__c'
	where AssessmentName = 'Attendance Check In Check Out - Attendance'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_2 = 'Weekly_goal_progress__c'
	where AssessmentName = 'Attendance Check In Check Out - Attendance'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_3 = 'Weekly_goals_set__c'
	where AssessmentName = 'Attendance Check In Check Out - Attendance'


	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Check_ins__c'
	where AssessmentName = 'SEL Check In Check Out - Behavior'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_2 = 'Weekly_goal_progress__c'
	where AssessmentName = 'SEL Check In Check Out - Behavior'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_3 = 'Weekly_goals_set__c'
	where AssessmentName = 'SEL Check In Check Out - Behavior'

	/*
	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'SEL_Composite_Description__c'
	where AssessmentName = 'Dessa-mini'
	*/

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'SEL_Composite_T_Score__c'
	where AssessmentName = 'Dessa-mini'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_2 = 'SEL_Composite_Percentile__c'
	where AssessmentName = 'Dessa-mini'


	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Average_Daily_Attendance__c'
	where AssessmentName = 'Cumulative ADA Tracker - Attendance'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Average_Daily_Attendance__c'
	where AssessmentName = 'Reporting Period ADA Tracker - Attendance'


	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'PostTest__c'
	where AssessmentName = 'Compass Learning -  Math'

	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_2 = 'PreTest__c'
	where AssessmentName = 'Compass Learning -  Math'


	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_3 = 'RIT_Score__c'
	where AssessmentName = 'Compass Learning -  Math'


	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'DRP_Exam_Score__c'
	where AssessmentName = 'Degrees Of Reading Power - ELA'
	
	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_2 = 'DRP_Proficiency_Level__c'
	where AssessmentName = 'Degrees Of Reading Power - ELA'



	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'SBAC_ELA_Band__c'
	where AssessmentName = 'Smarter Balanced Assessment Consortium - ELA'


	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_2 = 'SBAC_ELA_Scale_Score__c'
	where AssessmentName = 'Smarter Balanced Assessment Consortium - ELA'


	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'SBAC_MATH_Band__c'
	where AssessmentName = 'Smarter Balanced Assessment Consortium - MATH'


	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display_2 = 'SBAC_MATH_Scale_Score__c'
	where AssessmentName = 'Smarter Balanced Assessment Consortium - MATH'



	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Percent_Correct__c'
	where AssessmentName = 'ACT Aspire - ELA'

		
	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Percent_Correct__c'
	where AssessmentName = 'ACT Aspire - MATH'

	
	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Percent_Correct__c'
	where AssessmentName = 'Agile Minds - MATH'


	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Percentile__c'
	where AssessmentName = 'ANet - ELA'


	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Percentile__c'
	where AssessmentName = 'ANet - MATH'

		
	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Percent_Correct__c'
	where AssessmentName = 'DC District Unit Test - ELA'


	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Percent_Correct__c'
	where AssessmentName = 'DC District Unit Test - MATH'
	
	
	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'MSD_Computation_Score__c'
	where AssessmentName = 'Manchester School District Computation Assessment - MATH'


	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Student_Reading_Level__c'
	where AssessmentName = 'Teachers College Reading Assessment - ELA'


	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'Student_Reading_Level__c'
	where AssessmentName = 'Wonders (McGraw Hill Readers) and Accelerated Reader - ELA'


	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'X0_to_100_Scale_Score__c'
	where AssessmentName = 'Orlando Common Numeric Assessment - ELA'

	
	update SDW_Prod.dbo.DimAssessment
	set Data_Type_Display = 'X0_to_100_Scale_Score__c'
	where AssessmentName = 'Orlando Common Numeric Assessment - MATH'



END















GO
