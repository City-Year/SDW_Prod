USE [SDW_Prod]
GO
/****** Object:  StoredProcedure [dbo].[sp_Load_Mart_OLD_4_28_16]    Script Date: 12/1/2016 8:51:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[sp_Load_Mart_OLD_4_28_16]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets FROM
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		-- Insert statements for procedure here
	SELECT *
	INTO #Interventions
	FROM SDW_Stage_Prod.dbo.vw_Intervention_final (nolock)   
	
	


	--21,158
	create nonclustered index a on #Interventions(Intervention_Corps_Member)
	create nonclustered index a1 on #Interventions(Intervention_Corps_Member_ID)
	create nonclustered index b on #Interventions(Session_Date)
	create nonclustered index c on #Interventions(Student_School_Year)
	create nonclustered index c1 on #Interventions(MarkingPeriod)
	create nonclustered index d on #Interventions(Section_IA)								--, Session_Skills)
	create nonclustered index e on #Interventions(Student_School_Name)
	create nonclustered index f on #Interventions(CY_Student_ID)
	create nonclustered index f1 on #Interventions(Student_SF_ID)
	--create nonclustered index g on #Interventions(Session_Skills)
	create nonclustered index h on #Interventions(Program_Description)
	create nonclustered index i on #Interventions(Business_Unit)
	create nonclustered index j on #Interventions(Section_Name)
	create nonclustered index k on #Interventions(Program_Description)
	--  1,358
	SELECT *
	INTO #Grades
	FROM SDW_Stage_Prod.dbo.vw_Grades_final (nolock) 
	WHERE ISNULL(standard_name,'') not like '%SB%' 
	

	create nonclustered index l on #Grades(Assignment_Due_Date)
	create nonclustered index n on #Grades(Assignment_Marking_Period)
	create nonclustered index a on #Grades(Assignment_Name)
	create nonclustered index b on #Grades(Assignment_Type)
	create nonclustered index c on #Grades(Assignment_Subject)
	create nonclustered index g on #Grades([Business_Unit])
	create nonclustered index j on #Grades(CY_Student_ID)
	create nonclustered index m on #Grades(Entry_Date)
	create nonclustered index p on #Grades(Grades_IA)
	create nonclustered index r on #Grades(Program_Description)
	create nonclustered index d on #Grades(Section_Name)
	create nonclustered index q on #Grades(Session_Skills)
	create nonclustered index k on #Grades(Student_District_ID)
	create nonclustered index e on #Grades(Student_School_Year)
	create nonclustered index f on #Grades(Student_School_Name)
	create nonclustered index o on #Grades(Student_SF_ID)
	create nonclustered index h on #Grades(TeamName)
	create nonclustered index i on #Grades(TeamDescription )


	SELECT *
	INTO  #Assessments 
	FROM SDW_Stage_Prod.dbo.vw_Assessement_Student_final (nolock)
	
		
	create clustered index e on #Assessments(Assessment_Name)
	create nonclustered index a on #Assessments(CY_Student_ID)
	create nonclustered index b on #Assessments(Date_Administered__c)
	create nonclustered index c on #Assessments(Student_School_Year)
	create nonclustered index d on #Assessments(Student_School_Name)
	create nonclustered index f on #Assessments(CreatedDate)

	
	-- Normalize Team Names & Descriptions	

	select b.Name School_Name, b.Site__c Business_Unit, 
	a.Name Team_Name, a.Team_Description__c Team_Description
	into #School_Team
	FROM [SDW_Stage_Prod].[dbo].[Team__c] a
	inner join [SDW_Stage_Prod].[dbo].[Account] b on a.School_Name__c = b.ID

	select School_Name, count(*) [Count]
	into #Schools_To_Delete
	from #School_Team
	group by School_Name
	having count(*) > 1

	delete from #School_Team where School_Name in (select School_Name from #Schools_To_Delete)

	update #Interventions
	set TeamName = b.Team_Name
	, TeamDescription = b.Team_Description
	from #Interventions (nolock) a
	inner join #School_Team (nolock) b on a.Student_School_Name = b.School_Name

	update #Grades 
	set TeamName = b.Team_Name
	, TeamDescription = b.Team_Description
	from #Grades (nolock) a
	inner join #School_Team (nolock) b on a.Student_School_Name = b.School_Name

	update #Assessments
	set Team = b.Team_Name
	, TeamDescription = b.Team_Description
	from #Assessments (nolock) a
	inner join #School_Team (nolock) b on a.Student_School_Name = b.School_Name


	TRUNCATE TABLE SDW_Prod.dbo.DimAssessment

	INSERT INTO SDW_Prod.dbo.DimAssessment(AssessmentName, AssessmentType)
	VALUES('N/A', 'N/A')

	
	--START NEW ASSESSMENTS



	INSERT INTO SDW_Prod.dbo.DimAssessment(AssessmentName, Local_Benchmark, Quantile_Score, Quantile_Score_for_Summative_Reports, Quantile_Student_Target_Score, Testing_Grade_Level, Create_Date, Created_BY,Score)
	SELECT DISTINCT Assessment_Name, Local_Benchmark__c, Quantile_Score__c, Quantile_Score_for_Summative_Reports__c, Quantile_Student_Target_Score__c, Testing_Grade_Level__c, cast(CreatedDate as date), CreatedBy,Quantile_Score__c
	FROM #Assessments
	WHERE [Assessment_Name] like '%SMI: Scholastic Math Inventory - Math%'


	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],  Explore_Composite_Score, Explore_Composite_Score_for_Sum_Reports, Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score)
	SELECT DISTINCT [Assessment_Name],  Explore_Composite_Score__c, Explore_Composite_Score_for_Sum_Reports__c, Local_Benchmark__c, Testing_Grade_Level__c, cast(CreatedDate as date), CreatedBy,Explore_Composite_Score__c
	FROM #Assessments 
	WHERE [Assessment_Name] like  '%Explore - Reading - ELA%'

	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],  FSA_Algebra_Score,Percentile_PL, FSA_Algebra_Score_for_Summative_Reports, Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score,Score_2)
	SELECT DISTINCT [Assessment_Name],FSA_Algebra_Score__c,Percentile__c,FSA_Algebra_Score_for_Summative_Reports__c, Local_Benchmark__c, Testing_Grade_Level__c, cast(CreatedDate as date), CreatedBy,FSA_Algebra_Score__c,Percentile__c
	FROM #Assessments
	WHERE [Assessment_Name] like '%Florida State Assessment Algebra 1 - Math%'

	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],  Jerry_Johns_BRI_GLE_Score, Jerry_Johns_BRI_GLE_Score_for_Sum_Report, Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],  Jerry_Johns_BRI_GLE_Score__c, Jerry_Johns_BRI_GLE_Score_for_Sum_Report__c, Local_Benchmark__c, Testing_Grade_Level__c, cast(CreatedDate as date), CreatedBy,Jerry_Johns_BRI_GLE_Score__c 
	FROM #Assessments 
	WHERE [Assessment_Name] like '%Jerry Johns BRI - ELA%'
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],  IRLA_GLE_Score_for_Summative_Reports, IRLA_GLE_Student_Target_Score, IRLA_Grade_Level_Equivalent_Score, Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],  IRLA_GLE_Score_for_Summative_Reports__c, IRLA_GLE_Student_Target_Score__c, IRLA_Grade_Level_Equivalent_Score__c, Local_Benchmark__c, Testing_Grade_Level__c , cast(CreatedDate as date), CreatedBy,IRLA_Grade_Level_Equivalent_Score__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%IRLA - ELA%'
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],  Local_Benchmark, Scantron_Scaled_Score, Scantron_Scaled_Score_for_Sum_Reports, Scantron_Student_Target_Score, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],  Local_Benchmark__c, Scantron_Scaled_Score__c, Scantron_Scaled_Score_for_Sum_Reports__c, Scantron_Student_Target_Score__c, Testing_Grade_Level__c , cast(CreatedDate as date), CreatedBy,Scantron_Scaled_Score__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%Scantron Performance Series - Math%'
	
	
	--2 Scores for AIMSweb - Math -----------------------------------------------------

	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],AIMSweb_Math_Scale_score, AIMSweb_Math_Student_Target_Score, AIMSweb_Scale_score_for_Sum_Reports,Local_Benchmark, Percentile_PL, Percentile_for_Summative_Reports, Testing_Grade_Level, Create_Date, Created_BY,Score,Score_2) 
	SELECT DISTINCT [Assessment_Name],AIMSweb_Math_Scale_score__c, AIMSweb_Math_Student_Target_Score__c, AIMSweb_Scale_score_for_Sum_Reports__c,Local_Benchmark__c, Percentile__c, Percentile_for_Summative_Reports__c, Testing_Grade_Level__c, cast(CreatedDate as date), CreatedBy,
	                AIMSweb_Math_Scale_score__c,Percentile__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%AIMSweb - Math%'
	
	
	--2 Scores for AIMSweb - ELA -----------------------------------------------------

	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],AIMSweb_ELA_Scale_score, AIMSweb_ELA_Student_Target_Score, AIMSweb_Scale_score_for_Sum_Reports,Local_Benchmark,MAZE,DRA_Oral_Reading, Percentile_PL, Percentile_for_Summative_Reports, Testing_Grade_Level, Create_Date, Created_BY,score,Score_2,Score_3,Score_4,Score_5) 
	SELECT DISTINCT 
	[Assessment_Name],
	isnull(cast(AIMSweb_ELA_Scale_score__c as varchar(100)), 'N/A'), 
	isnull(cast(AIMSweb_ELA_Student_Target_Score__c as varchar(100)), 'N/A'), 
	isnull(AIMSweb_Scale_score_for_Sum_Reports__c, 'N/A'),
	isnull(Local_Benchmark__c, 'N/A'),
	isnull(cast(MAZE__C as varchar(100)), 'N/A'),
	isnull(cast(DRA_ORAL_READING__c as varchar(100)), 'N/A'), 
	isnull(Percentile__c, 'N/A'), 
	isnull(Percentile_for_Summative_Reports__c, 'N/A'), 
	isnull(Testing_Grade_Level__c, 'N/A'), 
	cast(CreatedDate as date), CreatedBy,
	isnull(cast(AIMSweb_ELA_Scale_score__c as varchar(100)), 'N/A'),
	isnull(cast(AIMSweb_ELA_Student_Target_Score__c as varchar(100)), 'N/A'),
	isnull(cast(MAZE__C as varchar(100)), 'N/A'),
	isnull(cast(DRA_ORAL_READING__c as varchar(100)), 'N/A'),
	isnull(Percentile__c, 'N/A')
	FROM #Assessments 
	WHERE [Assessment_Name] like '%AIMSweb - ELA%'
	
		
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],  Lexile_Score, Lexile_Score_for_Summative_Reports, Lexile_Student_Target_Score, Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],  Lexile_Score__c, Lexile_Score_for_Summative_Reports__c, Lexile_Student_Target_Score__c, Local_Benchmark__c, Testing_Grade_Level__c , cast(CreatedDate as date), CreatedBy,Lexile_Score__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%SRI: Scholastic Reading Inventory - ELA%'
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],  Local_Benchmark, Percentile_PL, Percentile_for_Summative_Reports, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],  Local_Benchmark__c, Percentile__c, Percentile_for_Summative_Reports__c, Testing_Grade_Level__c, cast(CreatedDate as date), CreatedBy,Percentile__c 
	FROM #Assessments 
	WHERE [Assessment_Name] like '%Wonders (McGraw Hill Readers) and Accelerated Reader - ELA%'
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],X0_to_100_Scale_Score, X0_to_100_Scale_Score_for_Sum_Reports, X0_to_100_Scale_Student_Target_Score,   Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],X0_to_100_Scale_Score__c, X0_to_100_Scale_Score_for_Sum_Reports__c, X0_to_100_Scale_Student_Target_Score__c,   Local_Benchmark__c, Testing_Grade_Level__c , cast(CreatedDate as date), CreatedBy,X0_to_100_Scale_Score__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%Amplify - Math%'
	
	-- 3 Scores for 50 Acts of Greatness-----------------------------------------------

	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],  Goals_set, Greatness_Lessons, Weekly_goal_progress,Difficulty_of_Goal,Goal_progress,Date_of_Goal_Completion,Number_of_Acts_of_Greatness_for_week,Date_Administered, Create_Date, Created_BY,Score, Score_2,Score_3) 
	SELECT DISTINCT [Assessment_Name],  Goals_set__c, Greatness_Lesson__c, Weekly_goal_progress__c ,Difficulty_of_Goal__c,Goal_progress__c,Date_of_Goal_Completion__c,Number_of_Acts_of_Greatness_for_week__c,Date_Administered__c, cast(CreatedDate as date), CreatedBy,Goals_set__c,Weekly_goal_progress__c,Greatness_Lesson__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%50 Acts of Greatness - Behavior%'

	--DESSA------------------------------------------------------------------------------
	
	INSERT INTO SDW_Prod.dbo.DimAssessment
	([AssessmentName],Date_Administered,Decision_Making_Description,Decision_Making_Percentile,Decision_Making_Raw_Score,Decision_Making_T_Score,
	Goal_directed_Behavior_Description,Goal_directed_Behavior_Percentile,Goal_directed_Behavior_Raw_Score,Goal_directed_Behavior_T_Score,
	Optimistic_Thinking_Description,Optimistic_Thinking_Percentile,Optimistic_Thinking_Raw_Score,Optimistic_Thinking_T_Score,
	Personal_Responsibility_Description,Personal_Responsibility_Percentile,Personal_Responsibility_Raw_Score,Personal_Responsibility_T_Score,
	Relationship_Skills_Description,Relationship_Skills_Percentile,Relationship_Skills_Raw_Score,Relationship_Skills_T_Score,
	SEL_Composite_Description,SEL_Composite_Percentile,SEL_Composite_Raw_Score,SEL_Composite_T_Score,Self_Awareness_Description,
	Self_Awareness_Percentile,Self_Awareness_Raw_Score,Self_Awareness_T_Score,Self_Management_Description,Self_Management_Percentile,
	Self_Management_Raw_Score,Self_Management_T_Score,Social_Awareness_Description,Social_Awareness_Percentile,Social_Awareness_Raw_Score,
	Social_Awareness_T_Score,Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY) 
	SELECT DISTINCT [Assessment_Name],Date_Administered__c,Decision_Making_Description__c,Decision_Making_Percentile__c,Decision_Making_Raw_Score__c,Decision_Making_T_Score__c,
	Goal_directed_Behavior_Description__c,Goal_directed_Behavior_Percentile__c,Goal_directed_Behavior_Raw_Score__c,Goal_directed_Behavior_T_Score__c,
	Optimistic_Thinking_Description__c,Optimistic_Thinking_Percentile__c,Optimistic_Thinking_Raw_Score__c,Optimistic_Thinking_T_Score__c,
	Personal_Responsibility_Description__c,Personal_Responsibility_Percentile__c,Personal_Responsibility_Raw_Score__c,Personal_Responsibility_T_Score__c,
	Relationship_Skills_Description__c,Relationship_Skills_Percentile__c,Relationship_Skills_Raw_Score__c,Relationship_Skills_T_Score__c,
	SEL_Composite_Description__c,SEL_Composite_Percentile__c,SEL_Composite_Raw_Score__c,SEL_Composite_T_Score__c,Self_Awareness_Description__c,
	Self_Awareness_Percentile__c,Self_Awareness_Raw_Score__c,Self_Awareness_T_Score__c,Self_Management_Description__c,Self_Management_Percentile__c,
	Self_Management_Raw_Score__c,Self_Management_T_Score__c,Social_Awareness_Description__c,Social_Awareness_Percentile__c,Social_Awareness_Raw_Score__c,
	Social_Awareness_T_Score__c,Local_Benchmark__c, Testing_Grade_Level__c, cast(CreatedDate as date), CreatedBy
	FROM #Assessments 
	WHERE [Assessment_Name] = 'Dessa'


	

	-- 3 Scores for DESSA-Mini -----------------------------------------------

	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],SEL_Composite_Description,SEL_Composite_Percentile,SEL_Composite_T_Score, Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score, Score_2) 
	SELECT DISTINCT [Assessment_Name],  SEL_Composite_Description__c, SEL_Composite_Percentile__c, SEL_Composite_T_Score__c ,  Local_Benchmark__c, Testing_Grade_Level__c , cast(CreatedDate as date), CreatedBy,SEL_Composite_T_Score__c, SEL_Composite_Percentile__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%Dessa-mini%'

	
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],X0_to_300_Scaled_Score, X0_to_300_Scaled_Score_for_Sum_Reports, X0_to_300_Student_Target_Score,   Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],X0_to_300_Scaled_Score__c, X0_to_300_Scaled_Score_for_Sum_Reports__c, X0_to_300_Student_Target_Score__c,   Local_Benchmark__c, Testing_Grade_Level__c , cast(CreatedDate as date), CreatedBy,X0_to_300_Scaled_Score__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%EasyCBM - ELA%'
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],FSA_Math_Score,Percentile_PL, FSA_Math_Score_for_Summative_Reports, Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score,Score_2) 
	SELECT DISTINCT [Assessment_Name],  FSA_Math_Score__c,Percentile__c, FSA_Math_Score_for_Summative_Reports__c, Local_Benchmark__c, Testing_Grade_Level__c , cast(CreatedDate as date), CreatedBy,FSA_Math_Score__c,Percentile__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%Florida State Assessment Mathematics - Math%'
	
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],X0_to_300_Scaled_Score, X0_to_300_Scaled_Score_for_Sum_Reports, X0_to_300_Student_Target_Score,   Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],X0_to_300_Scaled_Score__c, X0_to_300_Scaled_Score_for_Sum_Reports__c, X0_to_300_Student_Target_Score__c,   Local_Benchmark__c, Testing_Grade_Level__c , cast(CreatedDate as date), CreatedBy,X0_to_300_Scaled_Score__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%NWEA - Math%'
	
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],X0_to_300_Scaled_Score, X0_to_300_Scaled_Score_for_Sum_Reports, X0_to_300_Student_Target_Score,   Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],X0_to_300_Scaled_Score__c, X0_to_300_Scaled_Score_for_Sum_Reports__c, X0_to_300_Student_Target_Score__c,   Local_Benchmark__c, Testing_Grade_Level__c , cast(CreatedDate as date), CreatedBy,X0_to_300_Scaled_Score__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%NWEA - ELA%'
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],  Lexile_Score, Lexile_Score_for_Summative_Reports, Lexile_Student_Target_Score, Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],  Lexile_Score__c, Lexile_Score_for_Summative_Reports__c, Lexile_Student_Target_Score__c, Local_Benchmark__c, Testing_Grade_Level__c , cast(CreatedDate as date), CreatedBy,Lexile_Score__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%Achieve 3000 - ELA%'

	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],X0_to_100_Scale_Score, X0_to_100_Scale_Score_for_Sum_Reports, X0_to_100_Scale_Student_Target_Score,   Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],X0_to_100_Scale_Score__c, X0_to_100_Scale_Score_for_Sum_Reports__c, X0_to_100_Scale_Student_Target_Score__c,   Local_Benchmark__c, Testing_Grade_Level__c , cast(CreatedDate as date), CreatedBy,X0_to_100_Scale_Score__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%EADMS - Math%'
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],X0_to_100_Scale_Score, X0_to_100_Scale_Score_for_Sum_Reports, X0_to_100_Scale_Student_Target_Score,   Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],X0_to_100_Scale_Score__c, X0_to_100_Scale_Score_for_Sum_Reports__c, X0_to_100_Scale_Student_Target_Score__c,   Local_Benchmark__c, Testing_Grade_Level__c, cast(CreatedDate as date), CreatedBy,X0_to_100_Scale_Score__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%EADMS - ELA%'
		
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],Check_ins,Weekly_goal_progress,Weekly_goals_set,Goals_set,Difficulty_of_Goal,Goal_Progress,Date_Administered,Create_Date, Created_BY,Score,Score_2,Score_3) 
	SELECT DISTINCT [Assessment_Name],Check_ins__c,Weekly_goal_progress__c, Weekly_goals_set__c,Goals_set__c,Difficulty_of_Goal__c,Goal_Progress__c,Date_Administered__c, cast(CreatedDate as date), CreatedBy,Check_ins__c,Weekly_goal_progress__c, Weekly_goals_set__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%SEL Check In Check Out - Behavior%'

		
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],  Goals_set, Leadership_Lesson, Weekly_goal_progress,Difficulty_of_Goal,Goal_progress,Date_of_Goal_Completion,Number_of_Acts_of_Leadership_for_week,Date_Administered, Create_Date, Created_BY,Score,Score_2,Score_3) 
	SELECT DISTINCT                       [Assessment_Name],  Goals_set__c, Leadership_Lesson__c, Weekly_goal_progress__c ,Difficulty_of_Goal__c,Goal_progress__c,Date_of_Goal_Completion__c,Number_of_Acts_of_Leadership_for_week__c,Date_Administered__c, cast(CreatedDate as date), CreatedBy,Goals_set__c, Leadership_Lesson__c, Weekly_goal_progress__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%50 Acts of Leadership - Behavior%'
	
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],  Explore_Composite_Score, Explore_Composite_Score_for_Sum_Reports, Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],  Explore_Composite_Score__c, Explore_Composite_Score_for_Sum_Reports__c, Local_Benchmark__c, Testing_Grade_Level__c, cast(CreatedDate as date), CreatedBy ,Explore_Composite_Score__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%Explore - Math%'
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],  DRA_GLE_Score_for_Summative_Reports, DRA_GLE_Student_Target_Score, DRA_Grade_Level_Equivalent_Score, Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],  DRA_GLE_Score_for_Summative_Reports__c, DRA_GLE_Student_Target_Score__c, DRA_Grade_Level_Equivalent_Score__c, Local_Benchmark__c, Testing_Grade_Level__c, cast(CreatedDate as date), CreatedBy,DRA_Grade_Level_Equivalent_Score__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%DRA - ELA%'
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],  District_Benchmark, District_Benchmark_for_Summative_Reports, Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],  District_Benchmark__c, District_Benchmark_for_Summative_Reports__c, Local_Benchmark__c, Testing_Grade_Level__c , cast(CreatedDate as date), CreatedBy,District_Benchmark__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%District Benchmark Assessments - ELA%'
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],X0_to_1000_Scaled_Score, X0_to_1000_Scaled_Score_for_Sum_Reports, X0_to_1000_Student_Target_Score,   Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],X0_to_1000_Scaled_Score__c, X0_to_1000_Scaled_Score_for_Sum_Reports__c, X0_to_1000_Student_Target_Score__c,   Local_Benchmark__c, Testing_Grade_Level__c, cast(CreatedDate as date), CreatedBy,X0_to_1000_Scaled_Score__c 
	FROM #Assessments 
	WHERE [Assessment_Name] like '%iReady - ELA%'

	
	-- 2 scores for iReady - Math ------------------------------------------------------

	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],Quantile_Score, Quantile_Score_for_Summative_Reports,Quantile_Student_Target_Score, Local_Benchmark, Testing_Grade_Level, Create_Date, 
										Created_BY,X0_to_1000_Scaled_Score,X0_to_1000_Scaled_Score_for_Sum_Reports,X0_to_1000_Student_Target_Score,Score,Score_2) 
	SELECT DISTINCT [Assessment_Name],Quantile_Score__c, Quantile_Score_for_Summative_Reports__c, Quantile_Student_Target_Score__c,Local_Benchmark__c, Testing_Grade_Level__c, cast(CreatedDate as date), CreatedBy,
	                X0_to_1000_Scaled_Score__c,X0_to_1000_Scaled_Score_for_Sum_Reports__c,X0_to_1000_Student_Target_Score__c,Quantile_Score__c,X0_to_1000_Scaled_Score__c
					
	FROM #Assessments 
	WHERE [Assessment_Name] like '%iReady - Math%'


	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],  Lexile_Score, Lexile_Score_for_Summative_Reports, Lexile_Student_Target_Score, Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],  Lexile_Score__c, Lexile_Score_for_Summative_Reports__c, Lexile_Student_Target_Score__c, Local_Benchmark__c, Testing_Grade_Level__c, cast(CreatedDate as date), CreatedBy,Lexile_Score__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%iStation Indicators of Progress - ELA%'
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],  Local_Benchmark, Testing_Grade_Level, TRC_Alpha_Scale_for_Summative_Reports, TRC_Alpha_Scale_Score, TRC_Alpha_Scale_Student_Target_Score, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],  Local_Benchmark__c, Testing_Grade_Level__c, TRC_Alpha_Scale_for_Summative_Reports__c, TRC_Alpha_Scale_Score__c, TRC_Alpha_Scale_Student_Target_Score__c , cast(CreatedDate as date), CreatedBy,TRC_Alpha_Scale_Score__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%TRC - ELA%'
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],  District_Benchmark, District_Benchmark_for_Summative_Reports, Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],  District_Benchmark__c, District_Benchmark_for_Summative_Reports__c, Local_Benchmark__c, Testing_Grade_Level__c, cast(CreatedDate as date), CreatedBy,District_Benchmark__c 
	FROM #Assessments
	WHERE [Assessment_Name] like '%District Benchmark Assessments - Math%'
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],  Local_Benchmark, Percentile_PL, Percentile_for_Summative_Reports, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],  Local_Benchmark__c, Percentile__c, Percentile_for_Summative_Reports__c, Testing_Grade_Level__c, cast(CreatedDate as date), CreatedBy,Percentile__c 
	FROM #Assessments 
	WHERE [Assessment_Name] like '%ANet - Math%'
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],DIBELS_GLE_Score_for_Summative_Reports, DIBELS_GLE_Student_Target_Score, DIBELS_Grade_Level_Equivalent_Score,DAZE, Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score,Score_2) 
	SELECT DISTINCT [Assessment_Name],  DIBELS_GLE_Score_for_Summative_Reports__c, DIBELS_GLE_Student_Target_Score__c, DIBELS_Grade_Level_Equivalent_Score__c,DAZE__c, Local_Benchmark__c, Testing_Grade_Level__c, cast(CreatedDate as date), CreatedBy,
	DIBELS_Grade_Level_Equivalent_Score__c,DAZE__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%DIBELS - ELA%'

		
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],  Local_Benchmark, Scantron_Scaled_Score, Scantron_Scaled_Score_for_Sum_Reports, Scantron_Student_Target_Score, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],  Local_Benchmark__c, Scantron_Scaled_Score__c, Scantron_Scaled_Score_for_Sum_Reports__c, Scantron_Student_Target_Score__c, Testing_Grade_Level__c , cast(CreatedDate as date), CreatedBy,Scantron_Scaled_Score__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%Scantron Performance Series - ELA%'
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],  Local_Benchmark, Percentile_PL, Percentile_for_Summative_Reports, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],  Local_Benchmark__c, Percentile__c, Percentile_for_Summative_Reports__c, Testing_Grade_Level__c , cast(CreatedDate as date), CreatedBy,Percentile__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%ANet - ELA%'
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],Check_ins,Weekly_goal_progress, Weekly_goals_set,Goals_set,Difficulty_of_goal,Goal_Progress,Date_Administered, Create_Date, Created_BY,Score,Score_2,Score_3) 
	SELECT DISTINCT [Assessment_Name],Check_ins__c,Weekly_goal_progress__c, Weekly_goals_set__c,Goals_set__c,Difficulty_of_goal__c,Goal_Progress__c,Date_Administered__c, cast(CreatedDate as date), CreatedBy,Check_ins__c,Weekly_goal_progress__c, Weekly_goals_set__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%Attendance Check In Check Out - Attendance%'

	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],X0_to_300_Scaled_Score, X0_to_300_Scaled_Score_for_Sum_Reports, X0_to_300_Student_Target_Score,   Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],X0_to_300_Scaled_Score__c, X0_to_300_Scaled_Score_for_Sum_Reports__c, X0_to_300_Student_Target_Score__c,   Local_Benchmark__c, Testing_Grade_Level__c, cast(CreatedDate as date), CreatedBy, X0_to_300_Scaled_Score__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%EasyCBM - Math%'
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],  Lexia_Step_Number, Lexia_Step_Number_for_Summative_Reports, Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],  Lexia_Step_Number__c, Lexia_Step_Number_for_Summative_Reports__c, Local_Benchmark__c, Testing_Grade_Level__c, cast(CreatedDate as date), CreatedBy,Lexia_Step_Number__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%Lexia - ELA%'


	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],BPS_Predictive_Scaled_Score, BPS_Predict_Scaled_Score_for_Sum_Reports,   Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],BPS_Predictive_Scaled_Score__c, BPS_Predict_Scaled_Score_for_Sum_Reports__c,   Local_Benchmark__c, Testing_Grade_Level__c , cast(CreatedDate as date), CreatedBy,BPS_Predictive_Scaled_Score__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%BPS Predictive - Math%'
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],BPS_Predictive_Scaled_Score, BPS_Predict_Scaled_Score_for_Sum_Reports,   Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],BPS_Predictive_Scaled_Score__c, BPS_Predict_Scaled_Score_for_Sum_Reports__c,   Local_Benchmark__c, Testing_Grade_Level__c , cast(CreatedDate as date), CreatedBy,BPS_Predictive_Scaled_Score__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%BPS Predictive - ELA%'
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName], FSA_ELA_Score,Percentile_PL, FSA_ELA_Score_for_Summative_Reports, Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score,Score_2) 
	SELECT DISTINCT							   [Assessment_Name],FSA_ELA_Score__c,Percentile__c,FSA_ELA_Score_for_Summative_Reports__c, Local_Benchmark__c, Testing_Grade_Level__c , cast(CreatedDate as date), CreatedBy,FSA_ELA_Score__c,Percentile__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%Florida State Assessment English Language Arts - ELA%'
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],A_to_Z_Alpha_Scale, A_to_Z_Alpha_Scale_for_Summative_Reports,Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],A_to_Z_Alpha_Scale__c, A_to_Z_Alpha_Scale_for_Summative_Reports__c,   Local_Benchmark__c, Testing_Grade_Level__c , cast(CreatedDate as date), CreatedBy,A_to_Z_Alpha_Scale__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%Fountas and Pinnell Benchmark Assessment System - ELA%'

	
	-- 2 Scores for STAR Math -----------------------------------------------------------

	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],STAR_GLE_Score_for_Summative_Reports,STAR_GLE_Student_Target_Score,STAR_Grade_Level_Equivalent_Score,
									  X0_to_1000_Scaled_Score, X0_to_1000_Scaled_Score_for_Sum_Reports, X0_to_1000_Student_Target_Score,Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score,Score_2) 
	SELECT DISTINCT [Assessment_Name],STAR_GLE_Score_for_Summative_Reports__c,STAR_GLE_Student_Target_Score__c,STAR_Grade_Level_Equivalent_Score__c,X0_to_1000_Scaled_Score__c, X0_to_1000_Scaled_Score_for_Sum_Reports__c, X0_to_1000_Student_Target_Score__c,   
					Local_Benchmark__c, Testing_Grade_Level__c , cast(CreatedDate as date), CreatedBy,STAR_Grade_Level_Equivalent_Score__c,X0_to_1000_Scaled_Score__c
					
	FROM #Assessments 
	WHERE [Assessment_Name] like '%STAR Math - Math%'


	-- 2 Scores for STAR Reading --------------------------------------------------

	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],STAR_GLE_Score_for_Summative_Reports,STAR_GLE_Student_Target_Score,STAR_Grade_Level_Equivalent_Score,
									  X0_to_1000_Scaled_Score, X0_to_1000_Scaled_Score_for_Sum_Reports, X0_to_1000_Student_Target_Score,Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score,Score_2) 
	SELECT DISTINCT [Assessment_Name],STAR_GLE_Score_for_Summative_Reports__c,STAR_GLE_Student_Target_Score__c,STAR_Grade_Level_Equivalent_Score__c,X0_to_1000_Scaled_Score__c, X0_to_1000_Scaled_Score_for_Sum_Reports__c, X0_to_1000_Student_Target_Score__c,   
					Local_Benchmark__c, Testing_Grade_Level__c , cast(CreatedDate as date), CreatedBy,STAR_Grade_Level_Equivalent_Score__c,X0_to_1000_Scaled_Score__c
					
	FROM #Assessments 
	WHERE [Assessment_Name] like '%STAR Reading - ELA%'


	-- 5 Scores for Reporting Period Time Based Behavior Tracker - Behavior ------------------------------

	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],[Number_of_Detentions],[Number_of_In_School_Suspensions],[Number_of_Office_Referrals],
									  [Number_of_Out_of_School_Suspensions],[Number_of_Suspensions],Local_Benchmark, Time_Period,Date_Administered, Create_Date, 
									  Created_BY,Score,Score_2,Score_3,Score_4,Score_5) 
	SELECT DISTINCT [Assessment_Name],Number_of_Detentions__c,Number_of_In_School_Suspensions__c,Number_of_Office_Referrals__c,
					Number_of_Out_of_School_Suspensions__c,Number_of_Suspensions__c,Local_Benchmark__c, Time_Period__c , Date_Administered__c,
					cast(CreatedDate as date), CreatedBy,Number_of_Detentions__c,Number_of_In_School_Suspensions__c,Number_of_Office_Referrals__c,
					Number_of_Out_of_School_Suspensions__c,Number_of_Suspensions__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%Time Based Behavior Tracker - Behavior%' 

	-- 5 Scores for Time Based Attendance Tracker ----------------------------

	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],Days_Enrolled,[Number_of_Absences],[Number_of_Excused_Absences],[Number_of_Tardies],[Number_of_Unexcused_Absences],Local_Benchmark, Time_Period, Create_Date, Created_BY,Score,Score_2,Score_3,Score_4,Score_5) 
	SELECT DISTINCT [Assessment_Name],Days_Enrolled__c,Number_of_Absences__c,Number_of_Excused_Absences__c,Number_of_Tardies__c,Number_of_Unexcused_Absences__c,Local_Benchmark__c, Time_Period__c , cast(CreatedDate as date), CreatedBy,Days_Enrolled__c,Number_of_Absences__c,Number_of_Excused_Absences__c,Number_of_Tardies__c,Number_of_Unexcused_Absences__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%Time Based Attendance Tracker - Attendance%'

	

	--NEW ATTENDANCE ASSESSMENTS ADDED 11/13/2015--------------------------------------------

	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],Average_Daily_Attendance__c,Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],Average_Daily_Attendance__c,Local_Benchmark__c, Testing_Grade_Level__c , cast(CreatedDate as date), CreatedBy,Average_Daily_Attendance__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%Cumulative ADA Tracker - Attendance%'

	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],Average_Daily_Attendance__c,Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],Average_Daily_Attendance__c,Local_Benchmark__c, Testing_Grade_Level__c , cast(CreatedDate as date), CreatedBy,Average_Daily_Attendance__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%Reporting Period ADA Tracker - Attendance%'
	
	
	--NEW ASSESSMENTS ADDED 3/28/2016-----------------------------------------------------------------------------------------
	
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],[Number_of_Detentions],[Number_of_In_School_Suspensions],[Number_of_Office_Referrals],
									  [Number_of_Out_of_School_Suspensions],[Number_of_Suspensions],Local_Benchmark, Time_Period,Date_Administered, Create_Date, 
									  Created_BY,Score,Score_2,Score_3,Score_4,Score_5) 
	SELECT DISTINCT [Assessment_Name],Number_of_Detentions__c,Number_of_In_School_Suspensions__c,Number_of_Office_Referrals__c,
					Number_of_Out_of_School_Suspensions__c,Number_of_Suspensions__c,Local_Benchmark__c, Time_Period__c , Date_Administered__c,
					cast(CreatedDate as date), CreatedBy,Number_of_Detentions__c,Number_of_In_School_Suspensions__c,Number_of_Office_Referrals__c,
					Number_of_Out_of_School_Suspensions__c,Number_of_Suspensions__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%Time Based Behavior Tracker - Behavior%' 



	--4 Scores for Florida Assessments For Instruction in Reading - ELA -----------------

	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],Average_Ability_Score, RCT_Ability_Score,VKT_Ability_Score,WRT_Ability_Score,
											Local_Benchmark,Testing_Grade_Level, Create_Date, Created_BY,Score,Score_2,Score_3,Score_4) 

	SELECT DISTINCT Assessment_Name,Average_Ability_Score__c, RCT_Ability_Score__c,VKT_Ability_Score__C,WRT_Ability_Score__c,Local_Benchmark__c, Testing_Grade_Level__c,
					cast(CreatedDate as date), CreatedBy,Average_Ability_Score__c, RCT_Ability_Score__c,VKT_Ability_Score__C,WRT_Ability_Score__c
	FROM #Assessments
	WHERE [Assessment_Name] like '%Florida Assessments For Instruction in Reading - ELA%'


	
	--3 Scores for Compass Learning - ELA ---------------------------------------


	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],PostTest,PreTest,RIT_Score,Local_Benchmark,Testing_Grade_Level, Create_Date, Created_BY,Score,Score_2,Score_3) 
	SELECT DISTINCT Assessment_Name,PostTest__c,PreTest__c,RIT_Score__c,Local_Benchmark__c, Testing_Grade_Level__c,cast(CreatedDate as date), CreatedBy,PostTest__c,PreTest__c,RIT_Score__c
	FROM #Assessments
	WHERE [Assessment_Name] like '%Compass Learning -  Math%'


	--2 Scores for Degrees Of Reading Power - ELA -------------------------------------
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],DRP_Exam_Score,DRP_Proficiency_Level,Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score,Score_2) 
	SELECT DISTINCT [Assessment_Name],DRP_Exam_Score__c,DRP_Proficiency_Level__c,Local_Benchmark__c,Testing_Grade_Level__c,cast(CreatedDate as date),CreatedBy,DRP_Exam_Score__c,DRP_Proficiency_Level__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%Degrees Of Reading Power - ELA%'


	--2 Scores for Degrees Of Reading Power - MATH -------------------------------------
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],DRP_Exam_Score,DRP_Proficiency_Level,Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score,Score_2) 
	SELECT DISTINCT [Assessment_Name],DRP_Exam_Score__c,DRP_Proficiency_Level__c,Local_Benchmark__c,Testing_Grade_Level__c,cast(CreatedDate as date),CreatedBy,DRP_Exam_Score__c,DRP_Proficiency_Level__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%Degrees Of Reading Power - MATH%'

	--2 Scores for Smarter Balanced Assessment Consortium - ELA -------------------------------------
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],SBAC_ELA_Band,SBAC_ELA_Scale_Score,Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score,Score_2) 
	SELECT DISTINCT [Assessment_Name],SBAC_ELA_Band__c,SBAC_ELA_Scale_Score__c,Local_Benchmark__c,Testing_Grade_Level__c,cast(CreatedDate as date),CreatedBy,SBAC_ELA_Band__c,SBAC_ELA_Scale_Score__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%Smarter Balanced Assessment Consortium - ELA%'

	--2 Scores for Smarter Balanced Assessment Consortium - MATH -------------------------------------
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],SBAC_MATH_Band,SBAC_MATH_Scale_Score,Local_Benchmark, Testing_Grade_Level, Create_Date, Created_BY,Score,Score_2) 
	SELECT DISTINCT [Assessment_Name],SBAC_MATH_Band__c,SBAC_MATH_Scale_Score__c,Local_Benchmark__c,Testing_Grade_Level__c,cast(CreatedDate as date),CreatedBy,SBAC_MATH_Band__c,SBAC_MATH_Scale_Score__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%Smarter Balanced Assessment Consortium - MATH%'


	--1 Score for ACT Aspire - ELA ---------------------------------------------------------------
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],  Local_Benchmark, Percent_Correct,Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],Local_Benchmark__c, Percent_Correct__c,Testing_Grade_Level__c , cast(CreatedDate as date), CreatedBy,Percent_Correct__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%ACT Aspire - ELA%'


	--1 Score for ACT Aspire - MATH ---------------------------------------------------------------
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],  Local_Benchmark, Percent_Correct,Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],Local_Benchmark__c, Percent_Correct__c,Testing_Grade_Level__c , cast(CreatedDate as date), CreatedBy,Percent_Correct__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%ACT Aspire - MATH%'


	--1 Score for Agile Minds - MATH ---------------------------------------------------------------
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],  Local_Benchmark, Percent_Correct,Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],Local_Benchmark__c, Percent_Correct__c,Testing_Grade_Level__c , cast(CreatedDate as date), CreatedBy,Percent_Correct__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%Agile Minds - MATH%'


	--1 Score for ANet - ELA ---------------------------------------------------------------
--duplicate code	
--	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],  Local_Benchmark, Percentile_PL, Testing_Grade_Level, Create_Date, Created_BY,Score) 
--	SELECT DISTINCT [Assessment_Name],Local_Benchmark__c, Percentile__c,Testing_Grade_Level__c , cast(CreatedDate as date), CreatedBy,Percentile__c
--	FROM #Assessments 
--	WHERE [Assessment_Name] like '%ANet - ELA%'

	--1 Score for ANet - MATH ---------------------------------------------------------------
--Duplicate code	
--	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],  Local_Benchmark, Percentile_PL, Testing_Grade_Level, Create_Date, Created_BY,Score) 
--	SELECT DISTINCT [Assessment_Name],Local_Benchmark__c, Percentile__c, Testing_Grade_Level__c , cast(CreatedDate as date), CreatedBy,Percentile__c
--	FROM #Assessments 
--	WHERE [Assessment_Name] like '%ANet - MATH%'



	--1 Score for DC District Unit Test - ELA ---------------------------------------------------------------
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],  Local_Benchmark, Percent_Correct, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT 
	[Assessment_Name],
	isnull(Local_Benchmark__c, 'N/A'),
	isnull(cast(Percent_Correct__c as varchar(100)), 'N/A'), 
	isnull(Testing_Grade_Level__c, 'N/A'), 
	cast(CreatedDate as date), 
	CreatedBy,
	isnull(cast(Percent_Correct__c as varchar(100)), 'N/A')
	FROM #Assessments 
	WHERE [Assessment_Name] like '%DC District Unit Test - ELA%'


	--1 Score for DC District Unit Test - MATH ---------------------------------------------------------------
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],  Local_Benchmark, Percent_Correct, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],Local_Benchmark__c, Percent_Correct__c, Testing_Grade_Level__c , cast(CreatedDate as date), CreatedBy,Percent_Correct__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%DC District Unit Test - MATH%'


	--1 Score for Manchester School District Computation Assessment - MATH ---------------------------------------------------------------
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],  Local_Benchmark, MSD_Computation_Score, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT 
	[Assessment_Name],
	isnull(Local_Benchmark__c, 'N/A'), 
	isnull(cast(MSD_Computation_Score__c as varchar(100)), 'N/A'), 
	isnull(Testing_Grade_Level__c, 'N/A'), 
	cast(CreatedDate as date), 
	CreatedBy,
	isnull(cast(MSD_Computation_Score__c as varchar(100)), 'N/A')
	FROM #Assessments 
	WHERE [Assessment_Name] like '%Manchester School District Computation Assessment - MATH%'
	

	--1 Score for Teachers College Reading Assessment - ELA ---------------------------------------------------------------
	
	INSERT INTO SDW_Prod.dbo.DimAssessment([AssessmentName],  Local_Benchmark, Student_Reading_Level, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],Local_Benchmark__c, Student_Reading_Level__c, Testing_Grade_Level__c , cast(CreatedDate as date), CreatedBy,Student_Reading_Level__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%Teachers College Reading Assessment - ELA%'

	
	 	 
	--1 Score for Wonders (McGraw Hill Readers) and Accelerated Reader - ELA ---------------------------------------------------------------
	
	INSERT INTO SDW_Prod.dbo.DimAssessment ([AssessmentName],  Local_Benchmark, Percentile_PL, Testing_Grade_Level, Create_Date, Created_BY,Score) 
	SELECT DISTINCT [Assessment_Name],Local_Benchmark__c, Percentile__c, Testing_Grade_Level__c , cast(CreatedDate as date), CreatedBy,MSD_Computation_Score__c
	FROM #Assessments 
	WHERE [Assessment_Name] like '%Wonders (McGraw Hill Readers) and Accelerated Reader - ELA%'

	


	UPDATE SDW_Prod.dbo.DimAssessment set  A_to_Z_Alpha_Scale							= 'N/A' WHERE  A_to_Z_Alpha_Scale IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  A_to_Z_Alpha_Scale_for_Summative_Reports		= 'N/A' WHERE  A_to_Z_Alpha_Scale_for_Summative_Reports IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  AIMSweb_ELA_Scale_score						= 'N/A' WHERE  AIMSweb_ELA_Scale_score IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  AIMSweb_ELA_Student_Target_Score				= 'N/A' WHERE  AIMSweb_ELA_Student_Target_Score IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  AIMSweb_Math_Scale_score						= 'N/A' WHERE  AIMSweb_Math_Scale_score IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  AIMSweb_Math_Student_Target_Score			= 'N/A' WHERE  AIMSweb_Math_Student_Target_Score IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  AIMSweb_Scale_score_for_Sum_Reports			= 'N/A' WHERE  AIMSweb_Scale_score_for_Sum_Reports IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  BPS_Predict_Scaled_Score_for_Sum_Reports		= 'N/A' WHERE  BPS_Predict_Scaled_Score_for_Sum_Reports IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  BPS_Predictive_Scaled_Score					= 'N/A' WHERE  BPS_Predictive_Scaled_Score IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  Check_ins									= 'N/A' WHERE  Check_ins IS NULL 
  --UPDATE SDW_Prod.dbo.DimAssessment set  Date_Administered							= 'N/A' WHERE  Date_Administered IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  DIBELS_GLE_Score_for_Summative_Reports		= 'N/A' WHERE  DIBELS_GLE_Score_for_Summative_Reports IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  DIBELS_GLE_Student_Target_Score				= 'N/A' WHERE  DIBELS_GLE_Student_Target_Score IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  DIBELS_Grade_Level_Equivalent_Score			= 'N/A' WHERE  DIBELS_Grade_Level_Equivalent_Score IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  DAZE              							= 'N/A' WHERE  DAZE IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  District_Benchmark							= 'N/A' WHERE  District_Benchmark IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  District_Benchmark_for_Summative_Reports		= 'N/A' WHERE  District_Benchmark_for_Summative_Reports IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  DRA_GLE_Score_for_Summative_Reports			= 'N/A' WHERE  DRA_GLE_Score_for_Summative_Reports IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  DRA_GLE_Student_Target_Score					= 'N/A' WHERE  DRA_GLE_Student_Target_Score IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  DRA_Grade_Level_Equivalent_Score				= 'N/A' WHERE  DRA_Grade_Level_Equivalent_Score IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  Explore_Composite_Score						= 'N/A' WHERE  Explore_Composite_Score IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  Explore_Composite_Score_for_Sum_Reports		= 'N/A' WHERE  Explore_Composite_Score_for_Sum_Reports IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  FSA_Algebra_Score							= 'N/A' WHERE  FSA_Algebra_Score IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  FSA_Algebra_Score_for_Summative_Reports		= 'N/A' WHERE  FSA_Algebra_Score_for_Summative_Reports IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  FSA_ELA_Score								= 'N/A' WHERE  FSA_ELA_Score IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  FSA_ELA_Score_for_Summative_Reports			= 'N/A' WHERE  FSA_ELA_Score_for_Summative_Reports IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  FSA_Math_Score								= 'N/A' WHERE  FSA_Math_Score IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  FSA_Math_Score_for_Summative_Reports			= 'N/A' WHERE  FSA_Math_Score_for_Summative_Reports IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  Goals_set									= 'N/A' WHERE  Goals_set IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  Greatness_Lessons							= 'N/A' WHERE  Greatness_Lessons IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  IRLA_GLE_Score_for_Summative_Reports			= 'N/A' WHERE  IRLA_GLE_Score_for_Summative_Reports IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  IRLA_GLE_Student_Target_Score				= 'N/A' WHERE  IRLA_GLE_Student_Target_Score IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  IRLA_Grade_Level_Equivalent_Score			= 'N/A' WHERE  IRLA_Grade_Level_Equivalent_Score IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  Jerry_Johns_BRI_GLE_Score					= 'N/A' WHERE  Jerry_Johns_BRI_GLE_Score IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  Jerry_Johns_BRI_GLE_Score_for_Sum_Report		= 'N/A' WHERE  Jerry_Johns_BRI_GLE_Score_for_Sum_Report IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  Leadership_Lesson							= 'N/A' WHERE  Leadership_Lesson IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  Lexia_Step_Number							= 'N/A' WHERE  Lexia_Step_Number IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  Lexia_Step_Number_for_Summative_Reports		= 'N/A' WHERE  Lexia_Step_Number_for_Summative_Reports IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  Lexile_Score									= 'N/A' WHERE  Lexile_Score IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  Lexile_Score_for_Summative_Reports			= 'N/A' WHERE  Lexile_Score_for_Summative_Reports IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  Lexile_Student_Target_Score					= 'N/A' WHERE  Lexile_Student_Target_Score IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  Local_Benchmark								= 'N/A' WHERE  Local_Benchmark IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  Percentile_for_Summative_Reports				= 'N/A' WHERE  Percentile_for_Summative_Reports IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  Percentile_PL								= 'N/A' WHERE  Percentile_PL IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  Quantile_Score								= 'N/A' WHERE  Quantile_Score IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  Quantile_Score_for_Summative_Reports			= 'N/A' WHERE  Quantile_Score_for_Summative_Reports IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  Quantile_Student_Target_Score				= 'N/A' WHERE  Quantile_Student_Target_Score IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  Scantron_Scaled_Score						= 'N/A' WHERE  Scantron_Scaled_Score IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  Scantron_Scaled_Score_for_Sum_Reports		= 'N/A' WHERE  Scantron_Scaled_Score_for_Sum_Reports IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  Scantron_Student_Target_Score				= 'N/A' WHERE  Scantron_Student_Target_Score IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  Testing_Grade_Level							= 'N/A' WHERE  Testing_Grade_Level IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  TRC_Alpha_Scale_for_Summative_Reports		= 'N/A' WHERE  TRC_Alpha_Scale_for_Summative_Reports IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  TRC_Alpha_Scale_Score						= 'N/A' WHERE  TRC_Alpha_Scale_Score IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  TRC_Alpha_Scale_Student_Target_Score			= 'N/A' WHERE  TRC_Alpha_Scale_Student_Target_Score IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  Weekly_goal_progress							= 'N/A' WHERE  Weekly_goal_progress IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  Weekly_goals_set								= 'N/A' WHERE  Weekly_goals_set IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  X0_to_100_Scale_Score						= 'N/A' WHERE  X0_to_100_Scale_Score IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  X0_to_100_Scale_Score_for_Sum_Reports		= 'N/A' WHERE  X0_to_100_Scale_Score_for_Sum_Reports IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  X0_to_100_Scale_Student_Target_Score			= 'N/A' WHERE  X0_to_100_Scale_Student_Target_Score IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  X0_to_1000_Scaled_Score						= 'N/A' WHERE  X0_to_1000_Scaled_Score IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  X0_to_1000_Scaled_Score_for_Sum_Reports		= 'N/A' WHERE  X0_to_1000_Scaled_Score_for_Sum_Reports IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  X0_to_1000_Student_Target_Score				= 'N/A' WHERE  X0_to_1000_Student_Target_Score IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  X0_to_300_Scaled_Score						= 'N/A' WHERE  X0_to_300_Scaled_Score IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  X0_to_300_Scaled_Score_for_Sum_Reports		= 'N/A' WHERE  X0_to_300_Scaled_Score_for_Sum_Reports IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  X0_to_300_Student_Target_Score				= 'N/A' WHERE  X0_to_300_Student_Target_Score IS NULL 
	UPDATE SDW_Prod.dbo.DimAssessment set  STAR_GLE_Score_for_Summative_Reports			= 'N/A' WHERE  STAR_GLE_Score_for_Summative_Reports IS NULL 	
	UPDATE SDW_Prod.dbo.DimAssessment set  STAR_GLE_Student_Target_Score				= 'N/A' WHERE  STAR_GLE_Student_Target_Score IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  STAR_Grade_Level_Equivalent_Score			= 'N/A' WHERE  STAR_Grade_Level_Equivalent_Score IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  Number_of_Detentions							= 'N/A' WHERE  Number_of_Detentions IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  Number_of_In_School_Suspensions				= 'N/A' WHERE  Number_of_In_School_Suspensions IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  Number_of_Office_Referrals					= 'N/A' WHERE  Number_of_Office_Referrals  IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  Number_of_Out_of_School_Suspensions			= 'N/A' WHERE  Number_of_Out_of_School_Suspensions IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  Number_of_Suspensions						= 'N/A' WHERE  Number_of_Suspensions IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  Number_of_Absences							= 'N/A' WHERE  Number_of_Absences IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  Number_of_Excused_Absences					= 'N/A' WHERE  Number_of_Excused_Absences IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  Number_of_Tardies							= 'N/A' WHERE  Number_of_Tardies IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  Number_of_Unexcused_Absences					= 'N/A' WHERE  Number_of_Unexcused_Absences IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  SEL_Composite_Description					= 'N/A' WHERE  SEL_Composite_Description IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  SEL_Composite_Percentile						= 'N/A' WHERE  SEL_Composite_Percentile IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  SEL_Composite_T_Score						= 'N/A' WHERE  SEL_Composite_T_Score IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  Average_Daily_Attendance__c					= 'N/A' WHERE  Average_Daily_Attendance__c IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  Average_Ability_Score  						= 'N/A' WHERE  Average_Ability_Score IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  RCT_Ability_Score  							= 'N/A' WHERE  RCT_Ability_Score IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  VKT_Ability_Score  							= 'N/A' WHERE  VKT_Ability_Score IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  WRT_Ability_Score  							= 'N/A' WHERE  WRT_Ability_Score IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  PostTest 									= 'N/A' WHERE  PostTest IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  PreTest 										= 'N/A' WHERE  PreTest IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  RIT_Score 									= 'N/A' WHERE  RIT_Score IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  DRP_Exam_Score								= 'N/A' WHERE  DRP_Exam_Score  IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  DRP_Proficiency_Level 						= 'N/A' WHERE  DRP_Proficiency_Level IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  SBAC_ELA_Band 								= 'N/A' WHERE  SBAC_ELA_Band IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  SBAC_ELA_Scale_Score 						= 'N/A' WHERE  SBAC_ELA_Scale_Score IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  SBAC_MATH_Band 								= 'N/A' WHERE  SBAC_MATH_Band IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  SBAC_MATH_Scale_Score 						= 'N/A' WHERE  SBAC_MATH_Scale_Score IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  Percent_Correct 						        = 'N/A' WHERE  Percent_Correct IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  MSD_Computation_Score 						= 'N/A' WHERE  MSD_Computation_Score IS NULL
	UPDATE SDW_Prod.dbo.DimAssessment set  Student_Reading_Level 						= 'N/A' WHERE  Student_Reading_Level IS NULL


	
	
	

	--ASSIGNMENT 
	TRUNCATE TABLE SDW_Prod.dbo.DimAssignment

	INSERT INTO SDW_Prod.dbo.DimAssignment(AssignmentName, AssignmentSubject, AssignmentType, SectionName,Create_by,Entry_Date)
	VALUES('N/A', 'N/A', 'N/A', 'N/A', 'N/A', cast('1/1/1900' as date))

	INSERT INTO SDW_Prod.dbo.DimAssignment(AssignmentName,StandardName,AssignmentSubject, AssignmentType, SectionName,Create_by,Entry_Date)
	SELECT DISTINCT [Assignment_Name], StandardName, Assignment_Subject, ISNULL([Assignment_Type], 'N/A') [Assignment_Type], ISNULL(Section_Name, 'N/A') Section_Name,a.Create_by,a.Entry_Date
	FROM #Grades (nolock) a
	left outer join SDW_Prod.dbo.DimAssignment (nolock) b on a.Assignment_Name = b.AssignmentName
	AND ISNULL(a.Assignment_Type, '') = b.AssignmentType
	AND a.Assignment_Subject = b.AssignmentSubject
	AND ISNULL(a.Section_Name, '') = b.SectionName
	WHERE b.AssignmentName is null AND b.AssignmentSubject is null AND b.AssignmentType is null AND b.SectionName is null

	UPDATE SDW_Prod.dbo.DimAssignment set ProgramDescription = 'N/A' WHERE ProgramDescription is null

	INSERT INTO SDW_Prod.dbo.DimAssignment(AssignmentName,StandardName, AssignmentSubject, AssignmentType, SectionName, ProgramDescription)
	SELECT DISTINCT 'N/A' [Assignment_Name],'N/A' Standard_Name, Assignment_Subject, 'N/A' [Assignment_Type], ISNULL(Section_Name, 'N/A') Section_Name, Program_Description
	FROM #Interventions (nolock) a
	left outer join SDW_Prod.dbo.DimAssignment (nolock) b on ISNULL(a.Section_Name, 'N/A') = b.SectionName
	AND ISNULL(a.Program_Description, 'N/A') = ISNULL(b.ProgramDescription, 'N/A')
	WHERE b.SectionName is null AND b.ProgramDescription is null 

	INSERT INTO SDW_Prod.dbo.DimCorpsMember(CorpsMember_Name, CorpsMember_ID)
	SELECT DISTINCT Intervention_Corps_Member, Intervention_Corps_Member_ID
	FROM #Interventions (nolock) a
	left outer join SDW_Prod.dbo.DimCorpsMember (nolock) b on a.Intervention_Corps_Member = b.CorpsMember_Name and a.Intervention_Corps_Member_ID = b.CorpsMember_ID
	WHERE b.CorpsMember_Name is null
	and   a.Intervention_Corps_Member is not null
	order by Intervention_Corps_Member
	

	INSERT INTO SDW_Prod.dbo.DimGrade(SchoolYear, MarkingPeriod)
	SELECT DISTINCT ISNULL(Student_School_Year, 'N/A'), ISNULL(Assignment_Marking_Period, 'N/A')
	FROM #Grades (nolock) a
	left outer join SDW_Prod.dbo.DimGrade (nolock) b on ISNULL(a.Student_School_Year, 'N/A') = b.SchoolYear AND ISNULL(Assignment_Marking_Period, 'N/A') = b.MarkingPeriod
	WHERE b.SchoolYear is null AND b.MarkingPeriod is null
	order by ISNULL(Student_School_Year, 'N/A')

	INSERT INTO SDW_Prod.dbo.DimGrade(SchoolYear, MarkingPeriod)
	SELECT DISTINCT ISNULL(a.Student_School_Year, 'N/A'), a.MarkingPeriod
	FROM #Interventions (nolock) a
	left outer join SDW_Prod.dbo.DimGrade (nolock) b on ISNULL(a.Student_School_Year, 'N/A') = b.SchoolYear AND a.MarkingPeriod = b.MarkingPeriod
	WHERE b.SchoolYear is null AND b.MarkingPeriod is null
	order by ISNULL(a.Student_School_Year, 'N/A')

/*
	INSERT INTO SDW_Prod.dbo.DimGrade(SchoolYear, MarkingPeriod)
	SELECT DISTINCT ISNULL(a.Student_School_Year, 'N/A'), a.MarkingPeriod
	FROM #Assessments (nolock) a
	left outer join SDW_Prod.dbo.DimGrade (nolock) b on ISNULL(a.Student_School_Year, 'N/A') = b.SchoolYear AND a.MarkingPeriod = b.MarkingPeriod
	WHERE b.SchoolYear is null AND b.MarkingPeriod is null
	order by ISNULL(a.Student_School_Year, 'N/A')
*/

	INSERT INTO SDW_Prod.dbo.DImIndicatorArea(IndicatorArea, SessionSkill, Program_Description)
	SELECT DISTINCT ISNULL(Section_IA, 'N/A'), isnull(Session_Skills, 'N/A'), isnull(a.Program_Description, 'N/A')
	FROM #Interventions (nolock) a 
	left outer join SDW_Prod.dbo.DImIndicatorArea (nolock) b on ISNULL(a.Section_IA, 'N/A') = b.IndicatorArea AND a.Session_Skills = b.SessionSkill and isnull(a.Program_Description, 'N/A') = b.Program_Description
	WHERE b.IndicatorArea is null AND b.SessionSkill is null and b.Program_Description is null
	order by ISNULL(Section_IA, 'N/A'), isnull(Session_Skills, 'N/A'), isnull(a.Program_Description, 'N/A')

	INSERT INTO SDW_Prod.dbo.DImIndicatorArea(IndicatorArea, SessionSkill, Program_Description)
	SELECT DISTINCT ISNULL(Grades_IA, 'N/A'), isnull(Session_Skills, 'N/A'), a.Program_Description
	FROM #Grades (nolock) a 
	left outer join SDW_Prod.dbo.DImIndicatorArea (nolock) b on ISNULL(a.Grades_IA, 'N/A') = b.IndicatorArea AND a.Session_Skills = b.SessionSkill and a.Program_Description = b.Program_Description
	WHERE b.IndicatorArea is null AND b.SessionSkill is null and b.Program_Description is null
	order by ISNULL(Grades_IA, 'N/A'), isnull(Session_Skills, 'N/A'), a.Program_Description

	--TEMP TABLE CONTAINING SCHOOL AND DISTRICT FOR INSERT TO DimSchool TABLE
	SELECT
	b.[Account Name],
	b.[Account ID],
	b.[Account Type],
	b.[Parent Account ID],
	a.[Account Name no Household]
	INTO #School_Names_Districts
	FROM ODW.dbo.dimAccount a INNER JOIN ODW.dbo.dimAccount b ON a.[Account ID]   = b.[Parent Account ID]
														     AND a.[Account Type] = b.[Account Type]
	WHERE a.[Account Type] = 'School/Higher Education'
	ORDER BY b.[Account Name]


	TRUNCATE TABLE SDW_Prod.dbo.DimSchool

		
	INSERT INTO SDW_Prod.dbo.DimSchool(SchoolName, Business_Unit, Region, District, Team, TeamDescription, CYSch_SF_ID, CYCh_SF_ID)
	SELECT DISTINCT 
	ISNULL(a.Student_School_Name, 'N/A'), 
	ISNULL(a.[Business_Unit], 'N/A'), 
	'N/A' Region, 
	ISNULL(c.[Account Name no Household], 'N/A'), 
	ISNULL(a.TeamName, 'N/A'), 
	ISNULL(a.TeamDescription, 'N/A'),
	ISNULL([cysch_Accnt_SF_ID], 'N/A'),
    ISNULL([cych_Accnt_SF_ID], 'N/A')
	FROM #Grades a
	left outer join SDW_Prod.dbo.DimSchool b ON 
		ISNULL(a.Student_School_Name, 'N/A')	= b.SchoolName
	AND ISNULL(a.[Business_Unit], 'N/A')		= b.Business_Unit
	AND ISNULL(a.TeamName, 'N/A')				= b.Team
	AND ISNULL(a.TeamDescription, 'N/A')		= b.TeamDescription 
	LEFT OUTER JOIN #School_Names_Districts c ON b.Schoolname = c.[Account Name]
	WHERE 
	b.SchoolName			is null 
	AND b.Business_Unit		is null 
	AND b.Team				is null 
	AND b.TeamDescription	is null
	AND a.Business_Unit     is not null
	AND a.TeamName          is not null
	ORDER BY	ISNULL(a.Student_School_Name, 'N/A'), 
				ISNULL(a.[Business_Unit], 'N/A'), 
				ISNULL(a.TeamName, 'N/A'),	
				ISNULL(a.TeamDescription, 'N/A')

	UPDATE SDW_Prod.dbo.DimSchool
	SET CYCh_Account_# = b.[Account Number]
	FROM SDW_Prod.dbo.DimSchool (NOLOCK) a INNER JOIN ODW.dbo.DimAccount (NOLOCK) b ON a.CYCh_SF_ID = b.[Account ID]

	INSERT INTO SDW_Prod.dbo.DimSchool(SchoolName, Business_Unit, Region, District, Team, TeamDescription, CYSch_SF_ID, CYCh_SF_ID)
	SELECT DISTINCT 
	ISNULL(a.Student_School_Name, 'N/A'),
	ISNULL(a.Business_Unit, 'N/A'),
	'N/A' Region,
	ISNULL(c.[Account Name no Household], 'N/A'),
	ISNULL(a.TeamName, 'N/A'),
	ISNULL(a.TeamDescription, 'N/A'),
	ISNULL([cysch_Accnt_SF_ID], 'N/A'),
    ISNULL([cych_Accnt_SF_ID], 'N/A')
	FROM #Interventions a
	LEFT OUTER JOIN SDW_Prod.dbo.DimSchool b on 
	    ISNULL(a.Student_School_Name, 'N/A') = b.SchoolName
	AND ISNULL(a.[Business_Unit], 'N/A')	 = b.Business_Unit
	--AND ISNULL(a.TeamName, 'N/A') = b.Team
	--AND ISNULL(a.TeamDescription, 'N/A') = b.TeamDescription 
	LEFT OUTER JOIN #School_Names_Districts c ON b.Schoolname = c.[Account Name] 
	WHERE b.SchoolName IS NULL 
	AND b.Business_Unit IS NULL 
	AND b.Team IS NULL 
	AND b.TeamDescription IS NULL
	
	AND a.Business_Unit is not null
	AND a.TeamName is not null		

	ORDER BY ISNULL(a.Student_School_Name, 'N/A'), ISNULL(a.[Business_Unit], 'N/A'), ISNULL(a.TeamName, 'N/A'), 
	ISNULL(a.TeamDescription, 'N/A')


	UPDATE SDW_Prod.dbo.DimSchool
	SET CYCh_Account_# =  b.[Account Number]
	FROM SDW_Prod.dbo.DimSchool (NOLOCK) a INNER JOIN ODW.dbo.DimAccount (NOLOCK) b ON a.CYCh_SF_ID = b.[Account ID]


	INSERT INTO SDW_Prod.dbo.DimSchool(SchoolName, Business_Unit, Region, District, Team, TeamDescription, CYSch_SF_ID, CYCh_SF_ID)
	SELECT DISTINCT ISNULL(a.Student_School_Name, 'N/A'), a.Business_Unit, a.Region, a.District, a.Team, a.TeamDescription,	ISNULL([cysch_Accnt_SF_ID], 'N/A'),ISNULL([cych_Accnt_SF_ID], 'N/A')
	FROM #Assessments (nolock) a
	left outer join SDW_Prod.dbo.DimSchool b on 
	ISNULL([cysch_Accnt_SF_ID], 'N/A') = b.CYSch_SF_ID
	WHERE b.CYSch_SF_ID is null


	UPDATE SDW_Prod.dbo.DimSchool
	SET CYCh_Account_# =  b.[Account Number]
	FROM SDW_Prod.dbo.DimSchool (NOLOCK) a INNER JOIN ODW.dbo.DimAccount (NOLOCK) b ON a.CYCh_SF_ID = b.[Account ID]


	--  DimSchoolSetup ---------------------------------------------------------------------------------------
	--  DimSchoolSetup contains all the school year and marking period information. Link to DimSchool to 
	--  pick up SchoolID.
	----------------------------------------------------------------------------------------------------------

	TRUNCATE TABLE SDW_Prod.dbo.DimSchoolSetup

	INSERT INTO SDW_Prod.dbo.DimSchoolSetup(CYSch_SF_ID,Year_Start_date,Year_End_Date,Start_Date,End_Date,Quarter)
	
	SELECT DISTINCT a.CYSch_SF_ID,a.Year_Start_date,a.Year_End_Date,a.Start_Date,a.End_Date,a.Quarter--,b.SchoolID
	FROM SDW_Prod.dbo.vw_School_Setup a inner join SDW_Prod.dbo.DimSchool b on a.CYSch_SF_ID = b.CYSch_SF_ID
	                       left outer join SDW_Prod.dbo.DimSchoolSetup c on	  a.CYSch_SF_ID     = c.CYSch_SF_ID
						                                            and   a.Year_Start_Date = c.Year_start_date
																	and   a.Year_End_Date   = c.Year_End_Date
																	and   a.Start_Date      = c.Start_Date
																	and   a.End_Date        = c.End_Date
																	and   a.Quarter         = c.Quarter
																	
    WHERE c.CYSch_SF_ID		IS NULL
	AND   c.Year_start_date IS NULL
	AND   c.Year_End_Date	IS NULL
	AND   c.Start_Date		IS NULL
	AND   c.End_Date		IS NULL
	AND   c.Quarter			IS NULL  

	Order by a.CYSch_SF_ID,Start_Date

	-----------------------------------------------------------------------------------------------------------
	--UPDATE SCHOOLID IN DIMSCHOOLSETUP
	--THE DimSchool table can contain multiple rows for a given school if that school has multiple teams. 
	--In order to keep DimSchoolSetup free of duplicates the grouping for the insert to the DimSchoolSetup
	--has to be without the schoolID.
	--Once loaded with a distinct list of schools the schoolID can be updated. 
	----------------------------------------------------------------------------------------------------------- 
	
	UPDATE SDW_Prod.dbo.DimSchoolSetup SET
	SCHOOLID = b.schoolID 
	FROM SDW_Prod.dbo.DimSchoolSetup a inner join SDW_Prod.dbo.Dimschool b on a.CYSch_SF_ID = b.CYSch_SF_ID

	/*
	SELECT DISTINCT SchoolName, Business_Unit, Region
	INTO #Schools
	FROM SDW_Prod.dbo.DimSchool
	WHERE Business_Unit <> 'N/A' AND Region <> 'N/A'

	UPDATE SDW_Prod.dbo.DimSchool
	set Business_Unit = b.Business_Unit
	,Region = b.Region
	FROM SDW_Prod.dbo.DimSchool (nolock) a
	INNER JOIN #Schools (nolock) b on a.SchoolName = b.SchoolName
	WHERE a.Business_Unit = 'N/A' AND a.Region = 'N/A'
	*/

	TRUNCATE TABLE SDW_Prod.dbo.DIMSTUDENT

	INSERT INTO SDW_Prod.dbo.DimStudent(CY_StudentID, StudentDistrictID, StudentSF_ID, StudentName, StudentFirst_Name, StudentLast_Name, DateOfBirth, Gender, Attendance_IA, Behavior_IA, ELA_IA, Math_IA, Grade, ELL, Ethnicity, TTL_IAs_Assigned)
	SELECT DISTINCT CY_Student_ID, ISNULL(Student_District_ID, 'N/A'), Student_SF_ID, Student_Name, Student_First, Student_Last, Student_DOB, Student_Gender, [Student_IA_Att], [Student_IA_Beh], [Student_IA_ELA], [Student_IA_Math], Student_Grade, ISNULL(Student_ELL, 'N/A'), ISNULL(Student_Ethnicity, 'N/A'), Student_TTL_IAs_Assigned
	FROM #Grades (nolock) a 
	left outer join SDW_Prod.dbo.DimStudent (nolock) b on a.Student_SF_ID = b.StudentSF_ID AND ISNULL(a.Student_District_ID, 'N/A') = b.StudentDistrictID
	WHERE b.StudentSF_ID is null AND b.StudentDistrictID is null

	INSERT INTO SDW_Prod.dbo.DimStudent(CY_StudentID, StudentDistrictID, StudentSF_ID, StudentName, StudentFirst_Name, StudentLast_Name, DateOfBirth, Gender, Attendance_IA, Behavior_IA, ELA_IA, Math_IA, Grade, ELL, Ethnicity, TTL_IAs_Assigned)
	SELECT DISTINCT CY_Student_ID, ISNULL(Student_District_ID, 'N/A'), Student_SF_ID, Student_Name, Student_First, Student_Last, Student_DOB, Student_Gender, [Student_IA_Att], [Student_IA_Beh], [Student_IA_ELA], [Student_IA_Math], Student_Grade, ISNULL(Student_ELL, 'N/A'), ISNULL(Student_Ethnicity, 'N/A'), Student_TTL_IAs_Assigned
	FROM #Interventions (nolock) a 
	left outer join SDW_Prod.dbo.DimStudent (nolock) b on a.Student_SF_ID = b.StudentSF_ID AND ISNULL(a.Student_District_ID, 'N/A') = b.StudentDistrictID
	WHERE b.StudentSF_ID is null AND b.StudentDistrictID is null

	INSERT INTO SDW_Prod.dbo.DimStudent(CY_StudentID, StudentDistrictID, StudentSF_ID, StudentName, StudentFirst_Name, StudentLast_Name, DateOfBirth, Gender, Grade, ELL, Ethnicity, TTL_IAs_Assigned)
	SELECT DISTINCT CY_Student_ID, ISNULL(Student_District_ID, 'N/A'), Student_SF_ID, Student_Name, Student_First, Student_Last, Student_DOB, Student_Gender, Student_Grade, ISNULL(Student_ELL, 'N/A'), ISNULL(Student_Ethnicity, 'N/A'), Student_TTL_IAs_Assigned
	FROM #Assessments (nolock) a 
	left outer join SDW_Prod.dbo.DimStudent (nolock) b on a.Student_SF_ID = b.StudentSF_ID AND ISNULL(a.Student_District_ID, 'N/A') = b.StudentDistrictID
	WHERE b.StudentSF_ID is null AND b.StudentDistrictID is null

	TRUNCATE TABLE SDW_Prod.dbo.FactAll

	INSERT INTO SDW_Prod.dbo.FactALL(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID, IndicatorAreaID, SchoolID, StudentID, 
	FactTypeID, Assignment_Entered_Grade,Grade_Name, Assignment_Grade_Number, Assignment_Weighted_Grade_Value, Session_Dosage, PrimaryCorpsMemberID)
	SELECT b.AssignmentID, 1 AssessmentID, 1 CorpsMemberID, c.DateID DateID, d.GradeID, g.IndicatorAreaID IndicatorAreaID, e.SchoolID, f.StudentID, 1 FactTypeID, 
	a.Assignment_Entered_Grade,a.Grade_Name, a.Assignment_Grade_Number, a.Assignment_Weighted_Grade_Vale Assignment_Weighted_Grade_Value, 0 Session_Dosage, 1
	FROM #Grades (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssignment (nolock) b on 
		a.Assignment_Name = b.AssignmentName and 
		a.Assignment_Subject = ISNULL(b.AssignmentSubject, 'N/A') and
		ISNULL(a.Section_Name, 'N/A') = ISNULL(b.SectionName, 'N/A') and
		CONVERT(VARCHAR(20), a.Entry_Date, 100) = cast(b.Entry_Date as datetime)
	INNER JOIN SDW_Prod.dbo.DimDate (nolock) c on cast(a.Assignment_Due_Date as date) = cast(c.Date as date)
	INNER JOIN SDW_Prod.dbo.DimGrade (nolock) d on a.Student_School_Year = d.SchoolYear AND a.Assignment_Marking_Period = d.MarkingPeriod
	INNER JOIN SDW_Prod.dbo.DimSchool (nolock) e on a.Student_School_Name = e.SchoolName AND a.Business_Unit = e.Business_Unit and a.[cysch_Accnt_SF_ID] = e.CYSch_SF_ID
	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) f on a.CY_Student_ID = f.CY_StudentID AND a.Student_SF_ID = f.StudentSF_ID
	INNER JOIN SDW_Prod.dbo.DimIndicatorArea (nolock) g on a.Grades_IA = g.IndicatorArea AND isnull(a.Session_Skills, 'N/A') = g.SessionSkill and a.Program_Description = g.Program_Description

/*
	INNER JOIN SDW_Prod.dbo.DimDate (nolock) c on cast(a.Assignment_Due_Date as date) = cast(c.Date as date)
	INNER JOIN SDW_Prod.dbo.DimGrade (nolock) d on a.Student_School_Year = d.SchoolYear AND a.Assignment_Marking_Period = d.MarkingPeriod
	INNER JOIN SDW_Prod.dbo.DimSchool (nolock) e on a.Student_School_Name = e.SchoolName AND a.Business_Unit = e.Business_Unit and a.[cysch_Accnt_SF_ID] = e.CYSch_SF_ID
	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) f on a.CY_Student_ID = f.CY_StudentID AND a.Student_SF_ID = f.StudentSF_ID
	INNER JOIN SDW_Prod.dbo.DimIndicatorArea (nolock) g on a.Grades_IA = g.IndicatorArea AND a.Session_Skills = g.SessionSkill
*/


	INSERT INTO SDW_Prod.dbo.FactALL(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID, IndicatorAreaID, SchoolID, StudentID, 
	FactTypeID, Assignment_Entered_Grade, Assignment_Grade_Number, Assignment_Weighted_Grade_Value, Session_Dosage, Source_Session_Key, PrimaryCorpsMemberID)
	SELECT h.AssignmentID, 1 AssessmentID, b.CorpsMemberID, c.DateID SessionDateID, d.GradeID, e.IndicatorAreaID, f.SchoolID, g.StudentID, 2 FactTypeID,
	0 Assignment_Entered_Grade, 0 Assignment_Grade_Number, 0 Assignment_Weighted_Grade_Value, ISNULL(a.Session_Dossage, 0), a.Session_ID, 1 --isnull(i.CorpsMemberID, 1)
	FROM #Interventions (nolock) a
	INNER JOIN SDW_Prod.dbo.DimCorpsMember (nolock) b on a.Intervention_Corps_Member = b.CorpsMember_Name and a.Intervention_Corps_Member_ID = b.CorpsMember_ID
	INNER JOIN SDW_Prod.dbo.DimDate (nolock) c on cast(a.Session_Date as date) = cast(c.Date as date)
	INNER JOIN SDW_Prod.dbo.DimGrade (nolock) d on a.Student_School_Year = d.SchoolYear AND a.MarkingPeriod = d.MarkingPeriod
	INNER JOIN SDW_Prod.dbo.DimIndicatorArea (nolock) e on a.Section_IA = e.IndicatorArea AND isnull(a.Session_Skills, 'N/A') = e.SessionSkill and isnull(a.Program_Description, 'N/A') = e.Program_Description
	INNER JOIN SDW_Prod.dbo.DimSchool (nolock) f on ISNULL(a.Student_School_Name, 'N/A') = f.SchoolName AND a.Business_Unit = f.Business_Unit and a.[cysch_Accnt_SF_ID] = f.CYSch_SF_ID
	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) g on a.CY_Student_ID = g.CY_StudentID AND a.Student_SF_ID = g.StudentSF_ID
	INNER JOIN SDW_Prod.dbo.DimAssignment (nolock) h on ISNULL(a.Section_Name, 'N/A') = h.SectionName AND ISNULL(a.Program_Description, 'N/A') = ISNULL(h.ProgramDescription, 'N/A') -- and cast(a.Entry_Date as date) = cast(h.Entry_Date as date)
	-- LEFT OUTER JOIN SDW_Prod.dbo.DimCorpsMember (nolock) i on a.Section_Primary_Staff = i.CorpsMember_Name and a.Section_Primary_Staff_ID = i.CorpsMember_ID
	-- 20177

--**************************************************************************************************************************************************************
--NEW ASSESSMENTS START
--**************************************************************************************************************************************************************
-- 1 SMI: Scholastic Math Inventory

	select * 
	into #SMI
	from #Assessments
	WHERE [Assessment_Name] like  '%SMI: Scholastic Math Inventory - Math%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT	1 AssignmentID, AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
			d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #SMI (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on a.Assessment_Name = b.AssessmentName
	
	AND ISNULL(a.Local_Benchmark__c, 'N/A')												= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(cast(a.Quantile_Score__c  as varchar(100)), 'N/A')						= ISNULL(b.Quantile_Score, 'N/A')
	AND ISNULL(cast(a.Quantile_Score_for_Summative_Reports__c as varchar(100)), 'N/A')	= ISNULL(b.Quantile_Score_for_Summative_Reports, 'N/A')
	AND ISNULL(cast(a.Quantile_Student_Target_Score__c as varchar(100)), 'N/A')			= ISNULL(b.Quantile_Student_Target_Score, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')											= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)														= cast(b.Create_Date as date)
	AND a.CreatedBy																		= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name] like  '%SMI: Scholastic Math Inventory - Math%'
	

-- 2 Explore - Reading

	select * 
	into #Explore_Reading
	from #Assessments
	WHERE [Assessment_Name] like '%Explore - Reading - ELA%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #Explore_Reading (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.Explore_Composite_Score__c as varchar(100)), 'N/A')					= ISNULL(b.Explore_Composite_Score, 'N/A')
	AND isnull(cast(a.Explore_Composite_Score_for_Sum_Reports__c as varchar(100)), 'N/A')	= ISNULL(b.Explore_Composite_Score_for_Sum_Reports , 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')													= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')												= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)															= cast(b.Create_Date as date)
	AND a.CreatedBy																			= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name] like '%Explore - Reading - ELA%'


--3 Florida State Assessment Algebra 1

	select * 
	into #FSA_Algebra
	from #Assessments
	WHERE [Assessment_Name] like '%Florida State Assessment Algebra 1 - Math%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #FSA_Algebra (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.FSA_Algebra_Score__c as varchar(100)), 'N/A')							= ISNULL(b.FSA_Algebra_Score, 'N/A')
	AND ISNULL(cast(a.FSA_Algebra_Score_for_Summative_Reports__c as varchar(100)),'N/A')	= ISNULL(b.FSA_Algebra_Score_for_Summative_Reports , 'N/A')
	AND ISNULL(cast(a.Percentile__c as varchar(100)),'N/A')									= ISNULL(b.Percentile_PL , 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')													= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')												= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)															= cast(b.Create_Date as date)
	AND a.CreatedBy																			= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name] like '%Florida State Assessment Algebra 1 - Math%'

-- 4 Jerry Johns BRI - ELA

	select * 
	into #JerryJohns_ELA
	from #Assessments
	WHERE [Assessment_Name] like '%Jerry Johns BRI - ELA%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #JerryJohns_ELA (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(a.Jerry_Johns_BRI_GLE_Score__c, 'N/A')					= ISNULL(b.Jerry_Johns_BRI_GLE_Score, 'N/A')
	AND ISNULL(a.Jerry_Johns_BRI_GLE_Score_for_Sum_Report__c, 'N/A')	= ISNULL(b.Jerry_Johns_BRI_GLE_Score_for_Sum_Report, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')								= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')							= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)										= cast(b.Create_Date as date)
	AND a.CreatedBy														= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name] like '%Jerry Johns BRI - ELA%'

-- 5 IRLA - ELA

	select * 
	into #IRLA_ELA
	from #Assessments
	WHERE [Assessment_Name] like '%IRLA - ELA%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #IRLA_ELA (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.IRLA_GLE_Score_for_Summative_Reports__c as varchar(100)), 'N/A')	= ISNULL(b.IRLA_GLE_Score_for_Summative_Reports, 'N/A')
	AND ISNULL(cast(a.IRLA_GLE_Student_Target_Score__c as varchar(100)), 'N/A')			= ISNULL(b.IRLA_GLE_Student_Target_Score, 'N/A')
	AND ISNULL(cast(a.IRLA_Grade_Level_Equivalent_Score__c as varchar(100)), 'N/A')		= ISNULL(b.IRLA_Grade_Level_Equivalent_Score, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')												= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')											= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)														= cast(b.Create_Date as date)
	AND a.CreatedBy																		= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name] like '%IRLA - ELA%'
		
	

-- 6: Scantron Performance Series - Math

	select * 
	into #Scantron_Math
	from #Assessments
	WHERE [Assessment_Name] like '%Scantron Performance Series - Math%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #Scantron_Math (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.Scantron_Scaled_Score__c as varchar(100)), 'N/A')					= ISNULL(b.Scantron_Scaled_Score, 'N/A')
	AND ISNULL(cast(a.Scantron_Scaled_Score_for_Sum_Reports__c as varchar(100)), 'N/A')	= ISNULL(b.Scantron_Scaled_Score_for_Sum_Reports, 'N/A')
	AND ISNULL(cast(a.Scantron_Student_Target_Score__c as varchar(100)), 'N/A')			= ISNULL(b.Scantron_Student_Target_Score, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')											= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')												= ISNULL(b.Local_Benchmark, 'N/A')
	AND cast(CreatedDate as date)														= cast(b.Create_Date as date)
	AND a.CreatedBy																		= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name] like '%Scantron Performance Series - Math%'

-- 7  AIMSweb - Math

	select * 
	into #AIMSWEb_Math
	from #Assessments
	WHERE [Assessment_Name] like '%AIMSweb - Math%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #AIMSWEb_Math (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.AIMSweb_Math_Scale_score__c as varchar(100)), 'N/A')				= ISNULL(b.AIMSweb_Math_Scale_score, 'N/A')
	AND ISNULL(cast(a.AIMSweb_Math_Student_Target_Score__c as varchar(100)), 'N/A')		= ISNULL(b.AIMSweb_Math_Student_Target_Score, 'N/A')
	AND ISNULL(cast(a.AIMSweb_Scale_score_for_Sum_Reports__c as varchar(110)), 'N/A')	= ISNULL(b.AIMSweb_Scale_score_for_Sum_Reports, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')												= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Percentile__c, 'N/A')													= ISNULL(b.Percentile_PL, 'N/A')
	AND ISNULL(cast(a.Percentile_for_Summative_Reports__c as varchar(100)), 'N/A')		= ISNULL(b.Percentile_for_Summative_Reports, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')											= ISNULL(b.Testing_Grade_Level, 'N/A') 
	AND cast(CreatedDate as date)														= cast(b.Create_Date as date)
	AND a.CreatedBy																		= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name] like '%AIMSweb - Math%'

--8 NWEA - Math

	select * 
	into #NWEA_Math
	from #Assessments
	WHERE [Assessment_Name] like '%NWEA - Math%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #NWEA_Math (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.X0_to_300_Scaled_Score__c as varchar(100)), 'N/A')					= ISNULL(b.X0_to_300_Scaled_Score, 'N/A')
	AND ISNULL(cast(a.X0_to_300_Scaled_Score_for_Sum_Reports__c as varchar(100)), 'N/A')	= ISNULL(b.X0_to_300_Scaled_Score_for_Sum_Reports, 'N/A')
	AND ISNULL(cast(a.X0_to_300_Student_Target_Score__c as varchar(100)), 'N/A')			= ISNULL(b.X0_to_300_Student_Target_Score, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')													= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')												= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)															= cast(b.Create_Date as date)
	AND a.CreatedBy																			= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name] like '%NWEA - Math%'

	
--9 SRI: Scholastic Reading Inventory

	select * 
	into #SRI_ELA
	from #Assessments
	WHERE [Assessment_Name] like '%SRI: Scholastic Reading Inventory - ELA%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #SRI_ELA (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.Lexile_Score__c as varchar(100)), 'N/A')							= ISNULL(b.Lexile_Score, 'N/A')
	AND ISNULL(cast(a.Lexile_Score_for_Summative_Reports__c as varchar(100)), 'N/A')	= ISNULL(b.Lexile_Score_for_Summative_Reports, 'N/A')
	AND ISNULL(cast(a.Lexile_Student_Target_Score__c as varchar(100)), 'N/A')			= ISNULL(b.Lexile_Student_Target_Score, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')												= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')											= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)														= cast(b.Create_Date as date)
	AND a.CreatedBy																		= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name] like '%SRI: Scholastic Reading Inventory - ELA%'


--10 Wonders (McGraw Hill Readers) and Accelerated Reader - ELA

	select * 
	into #WAR_ELA
	from #Assessments
	WHERE [Assessment_Name] like '%Wonders (McGraw Hill Readers) and Accelerated Reader - ELA%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #WAR_ELA (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(a.Percentile__c, 'N/A')											    = ISNULL(b.Percentile_PL, 'N/A')
	AND ISNULL(cast(a.Percentile_for_Summative_Reports__c as varchar(100)), 'N/A')	= ISNULL(b.Percentile_for_Summative_Reports, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')										= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')											= ISNULL(b.Local_Benchmark, 'N/A')
	AND cast(CreatedDate as date)													= cast(b.Create_Date as date)
	AND a.CreatedBy																	= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name] like '%Wonders (McGraw Hill Readers) and Accelerated Reader - ELA%'

-- 11 Amplify - Math

	select * 
	into #Amp_Math
	from #Assessments
	WHERE [Assessment_Name] like '%Amplify - Math%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID,  b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #Amp_Math (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.X0_to_100_Scale_Score__c as varchar(100)), 'N/A')					= ISNULL(b.X0_to_100_Scale_Score, 'N/A')
	AND ISNULL(cast(a.X0_to_100_Scale_Score_for_Sum_Reports__c as varchar(100)), 'N/A') = ISNULL(b.X0_to_100_Scale_Score_for_Sum_Reports , 'N/A')
	AND ISNULL(cast(a.X0_to_100_Scale_Student_Target_Score__c as varchar(100)), 'N/A')	= ISNULL(b.X0_to_100_Scale_Student_Target_Score, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')												= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')											= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)														= cast(b.Create_Date as date)
	AND a.CreatedBy																		= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name] like '%Amplify - Math%'


--12  50 Acts of Greatness
  
	select * 
	into #50_Behavior
	from #Assessments
	WHERE [Assessment_Name]  like '%50 Acts of Greatness - Behavior%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	select 1 AssignmentID, AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	from #50_Behavior (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.Goals_set__c as varchar(100)), 'N/A')										= ISNULL(b.Goals_set, 'N/A')
	AND ISNULL(cast(a.Greatness_Lesson__c as varchar(100)), 'N/A')								= ISNULL(b.Greatness_Lessons, 'N/A')
	AND ISNULL(cast(a.Weekly_goal_progress__c as varchar(100)), 'N/A')							= ISNULL(b.Weekly_goal_progress, 'N/A')
	AND ISNULL(cast(a.Difficulty_of_Goal__c as varchar(100)), 'N/A')							= ISNULL(b.Difficulty_of_Goal, 'N/A')
	AND ISNULL(cast(a.Goal_progress__c as varchar(100)), 'N/A')									= ISNULL(b.Goal_progress, 'N/A')
	AND ISNULL(cast(a.Date_of_Goal_Completion__c as varchar(100)), 'N/A')						= ISNULL(b.Date_of_Goal_Completion, 'N/A')
	AND ISNULL(cast(a.Number_of_Acts_of_Greatness_for_week__c as varchar(100)), 'N/A')			= ISNULL(b.Number_of_Acts_of_Greatness_for_week, 'N/A')
	AND cast(Date_Administered as date)															= cast(b.Date_Administered as date)
	AND ISNULL(a.Local_Benchmark__c, 'N/A')								= b.Local_Benchmark
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')							= b.Testing_Grade_Level
	AND cast(CreatedDate as date)										= cast(b.Create_Date as date)
	AND a.CreatedBy														= b.Created_By
	
	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%50 Acts of Greatness - Behavior%'

	
--13 EasyCBM - ELA

	select * 
	into #EasyCBM_ELA
	from #Assessments
	WHERE [Assessment_Name]  like '%EasyCBM - ELA%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #EasyCBM_ELA (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.X0_to_300_Scaled_Score__c as varchar(100)), 'N/A') = ISNULL(b.X0_to_300_Scaled_Score, 'N/A')
	AND ISNULL(cast(a.X0_to_300_Scaled_Score_for_Sum_Reports__c as varchar(100)), 'N/A') = ISNULL(b.X0_to_300_Scaled_Score_for_Sum_Reports, 'N/A')
	AND ISNULL(cast(a.X0_to_300_Student_Target_Score__c as varchar(100)), 'N/A') = ISNULL(b.X0_to_300_Student_Target_Score, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A') = ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A') = ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date) = cast(b.Create_Date as date)
	AND a.CreatedBy = b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%EasyCBM - ELA%'


--14 Florida State Assessment Mathematics

	select * 
	into #FSA_Math
	from #Assessments
	WHERE [Assessment_Name]  like '%Florida State Assessment Mathematics - Math%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #FSA_Math (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.FSA_Math_Score__c as varchar(100)), 'N/A') = ISNULL(b.FSA_Math_Score, 'N/A')
	AND ISNULL(cast(a.FSA_Math_Score_for_Summative_Reports__c as varchar(100)), 'N/A') = ISNULL(b.FSA_Math_Score_for_Summative_Reports, 'N/A')
	AND ISNULL(cast(a.Percentile__c as varchar(100)), 'N/A') = ISNULL(b.Percentile_PL, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A') = ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A') = ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date) = cast(b.Create_Date as date)
	AND a.CreatedBy = b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%Florida State Assessment Mathematics - Math%'

--15 AIMSweb - ELA

	select * 
	into #AIMSweb_ELA
	from #Assessments
	WHERE [Assessment_Name]  like '%AIMSweb - ELA%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #AIMSweb_ELA (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.AIMSweb_ELA_Scale_score__c as varchar(100)), 'N/A')					= isnull(b.AIMSweb_ELA_Scale_score, 'N/A')
	AND ISNULL(cast(a.AIMSweb_ELA_Student_Target_Score__c as varchar(100)), 'N/A')			= isnull(b.AIMSweb_ELA_Student_Target_Score, 'N/A')
	AND ISNULL(cast(a.AIMSweb_Scale_score_for_Sum_Reports__c as varchar(100)), 'N/A')		= isnull(b.AIMSweb_Scale_score_for_Sum_Reports, 'N/A')
	AND ISNULL(cast(a.MAZE__c as varchar(100)), 'N/A')										= isnull(b.MAZE, 'N/A')
	AND ISNULL(cast(a.DRA_Oral_Reading__c as varchar(100)), 'N/A')							= isnull(b.DRA_Oral_Reading, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')													= isnull(b.Local_Benchmark, 'N/A')
	AND ISNULL(cast(a.Percentile__c as varchar(100)), 'N/A')								= isnull(b.Percentile_PL, 'N/A')
	AND ISNULL(cast(a.Testing_Grade_Level__c as varchar(100)), 'N/A')						= isnull(b.Testing_Grade_Level, 'N/A')
	AND ISNULL(a.Percentile_for_Summative_Reports__c, 'N/A')								= isnull(b.Percentile_for_Summative_Reports, 'N/A')
	AND cast(CreatedDate as date) = cast(b.Create_Date as date)
	AND a.CreatedBy = b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%AIMSweb - ELA%'

--16 

	select * 
	into #EADMS_Math
	from #Assessments
	WHERE [Assessment_Name]  like '%EADMS - Math%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #EADMS_Math (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.X0_to_100_Scale_Score__c as varchar(100)), 'N/A') = ISNULL(b.X0_to_100_Scale_Score, 'N/A')
	AND ISNULL(cast(a.X0_to_100_Scale_Score_for_Sum_Reports__c as varchar(100)), 'N/A') = ISNULL(b.X0_to_100_Scale_Score_for_Sum_Reports, 'N/A')
	AND ISNULL(cast(a.X0_to_100_Scale_Student_Target_Score__c as varchar(100)), 'N/A') = ISNULL(b.X0_to_100_Scale_Student_Target_Score, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A') = ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A') =  ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date) = cast(b.Create_Date as date)
	AND a.CreatedBy = b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%EADMS - Math%'

	--17

	select * 
	into #NWEA_ELA
	from #Assessments
	WHERE [Assessment_Name]  like '%NWEA - ELA%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #NWEA_ELA (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.X0_to_300_Scaled_Score__c as varchar(100)), 'N/A')					= ISNULL(b.X0_to_300_Scaled_Score, 'N/A')
	AND ISNULL(cast(a.X0_to_300_Scaled_Score_for_Sum_Reports__c as varchar(100)), 'N/A')	= ISNULL(b.X0_to_300_Scaled_Score_for_Sum_Reports, 'N/A')
	AND ISNULL(cast(a.X0_to_300_Student_Target_Score__c as varchar(100)), 'N/A')			= ISNULL(b.X0_to_300_Student_Target_Score, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')													= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')												= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)															= cast(b.Create_Date as date)
	AND a.CreatedBy																			= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%NWEA - ELA%'

--18

	select * 
	into #A3000_ELA
	from #Assessments
	WHERE [Assessment_Name]  like '%Achieve 3000 - ELA%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #A3000_ELA (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.Lexile_Score__c as varchar(100)), 'N/A')							= ISNULL(b.Lexile_Score, 'N/A')
	AND ISNULL(cast(a.Lexile_Score_for_Summative_Reports__c as varchar(100)), 'N/A')	= ISNULL(b.Lexile_Score_for_Summative_Reports, 'N/A')
	AND ISNULL(cast(a.Lexile_Student_Target_Score__c as varchar(100)), 'N/A')			= ISNULL(b.Lexile_Student_Target_Score, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')												= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')											= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)														= cast(b.Create_Date as date)
	AND a.CreatedBy																		= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%Achieve 3000 - ELA%'

--19 EADMS - ELA

	select * 
	into #EADMS_ELA
	from #Assessments
	WHERE [Assessment_Name]  like '%EADMS - ELA%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #EADMS_ELA (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.X0_to_100_Scale_Score__c as varchar(100)), 'N/A')					= ISNULL(b.X0_to_100_Scale_Score, 'N/A')
	AND ISNULL(cast(a.X0_to_100_Scale_Score_for_Sum_Reports__c as varchar(100)), 'N/A')	= ISNULL(b.X0_to_100_Scale_Score_for_Sum_Reports , 'N/A')
	AND ISNULL(cast(a.X0_to_100_Scale_Student_Target_Score__c as varchar(100)), 'N/A')	= ISNULL(b.X0_to_100_Scale_Student_Target_Score, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')												= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')											= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)														= cast(b.Create_Date as date)
	AND a.CreatedBy																		= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%EADMS - ELA%'

	


--20 BPS Predictive - Math

	select * 
	into #BPS_Math
	from #Assessments
	WHERE [Assessment_Name]  like '%BPS Predictive - Math%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #BPS_Math (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.BPS_Predictive_Scaled_Score__c as varchar(100)), 'N/A')				= ISNULL(b.BPS_Predictive_Scaled_Score, 'N/A')
	AND ISNULL(cast(a.BPS_Predict_Scaled_Score_for_Sum_Reports__c as varchar(100)), 'N/A')	= ISNULL(b.BPS_Predict_Scaled_Score_for_Sum_Reports , 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')													= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')												= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)															= cast(b.Create_Date as date)
	AND a.CreatedBy																			= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%BPS Predictive - Math%'

--21 SEL Check In, Check Out

	select * 
	into #SEL_In_Out
	from #Assessments
	WHERE [Assessment_Name]  like '%SEL Check In Check Out - Behavior%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #SEL_In_Out (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 
	AND ISNULL(cast(a.Check_ins__c as varchar(100)), 'N/A')					= ISNULL(b.Check_ins,'N/A')
	AND ISNULL(cast(a.Weekly_goal_progress__c as varchar(100)), 'N/A')		= ISNULL(b.Weekly_goal_progress,'N/A')
	AND ISNULL(cast(a.Weekly_goals_set__c as varchar(100)), 'N/A')			= ISNULL(b.Weekly_goals_set,'N/A')
	AND ISNULL(cast(a.Goals_set__c as varchar(100)), 'N/A')					= ISNULL(b.Goals_Set,'N/A')
	AND ISNULL(cast(a.Difficulty_of_goal__c as varchar(100)), 'N/A')		= ISNULL(b.Difficulty_of_goal,'N/A')
	AND ISNULL(cast(a.goal_Progress__c as varchar(100)), 'N/A')				= ISNULL(b.Goal_progress,'N/A')
	AND ISNULL(cast(Date_Administered__c as date),'1900-01-01')				= ISNULL(cast(b.Date_Administered as date),'1900-01-01')
	AND cast(CreatedDate as date)											= cast(b.Create_Date as date)
	AND a.CreatedBy															= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%SEL Check In Check Out - Behavior%'

	
--22  

	select * 
	into #50_Acts_Behavior
	from #Assessments
	WHERE [Assessment_Name]  like '%50 Acts of Leadership - Behavior%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT distinct 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage 
	FROM #50_Acts_Behavior (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 
	
	AND ISNULL(cast(a.Goals_set__c as varchar(100)), 'N/A')				= ISNULL(b.Goals_set, 'N/A')
	AND ISNULL(cast(a.Leadership_Lesson__c as varchar(100)), 'N/A')		= ISNULL(b.Leadership_Lesson, 'N/A')
	AND ISNULL(cast(a.Weekly_goal_progress__c as varchar(100)), 'N/A')	= ISNULL(b.Weekly_goal_progress, 'N/A')
	AND cast(CreatedDate as date)										= cast(b.Create_Date as date)
	AND a.CreatedBy														= b.Created_By
	
	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock)    e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%50 Acts of Leadership - Behavior%'

--23  

	select * 
	into #Explore_Math
	from #Assessments
	WHERE [Assessment_Name]  like '%Explore - Math%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #Explore_Math (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.Explore_Composite_Score__c as varchar(100)), 'N/A')					= ISNULL(b.Explore_Composite_Score, 'N/A')
	AND ISNULL(cast(a.Explore_Composite_Score_for_Sum_Reports__c as varchar(100)), 'N/A')	= ISNULL(b.Explore_Composite_Score_for_Sum_Reports , 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')													= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')												= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)															= cast(b.Create_Date as date)
	AND a.CreatedBy = b.Created_By
	
	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%Explore - Math%'



--24  DRA - ELA

	select * 
	into #DRA_ELA
	from #Assessments
	WHERE [Assessment_Name]  like '%DRA - ELA%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #DRA_ELA (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.DRA_GLE_Score_for_Summative_Reports__c as varchar(100)), 'N/A')	= ISNULL(b.DRA_GLE_Score_for_Summative_Reports, 'N/A')
	AND ISNULL(cast(a.DRA_GLE_Student_Target_Score__c as varchar(100)), 'N/A')			= ISNULL(b.DRA_GLE_Student_Target_Score, 'N/A')
	AND ISNULL(cast(a.DRA_Grade_Level_Equivalent_Score__c as varchar(100)), 'N/A')		= ISNULL(b.DRA_Grade_Level_Equivalent_Score, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')												= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')											= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)														= cast(b.Create_Date as date)
	AND a.CreatedBy																		= b.Created_By


	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%DRA - ELA%'

	
--25

	select * 
	into #DBA_ELA
	from #Assessments
	WHERE [Assessment_Name]  like '%District Benchmark Assessments - ELA%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #DBA_ELA (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.District_Benchmark__c as varchar(100)), 'N/A')								= ISNULL(b.District_Benchmark, 'N/A')
	AND ISNULL(cast(a.District_Benchmark_for_Summative_Reports__c as varchar(100)), 'N/A')			= ISNULL(b.District_Benchmark_for_Summative_Reports, 'N/A')
	AND ISNULL(cast(a.DRA_Grade_Level_Equivalent_Score__c as varchar(100)), 'N/A')					= ISNULL(b.DRA_Grade_Level_Equivalent_Score, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')															= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')														= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)																	= cast(b.Create_Date as date)
	AND a.CreatedBy																					= b.Created_By


	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%District Benchmark Assessments - ELA%'


--26 iReady - ELA

	select * 
	into #iReady_ELA
	from #Assessments
	WHERE [Assessment_Name]  like '%iReady - ELA%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #iReady_ELA (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.X0_to_1000_Scaled_Score__c as varchar(100)), 'N/A')					= ISNULL(b.X0_to_1000_Scaled_Score, 'N/A')
	AND ISNULL(cast(a.X0_to_1000_Scaled_Score_for_Sum_Reports__c as varchar(100)), 'N/A')	= ISNULL(b.X0_to_1000_Scaled_Score_for_Sum_Reports , 'N/A')
	AND ISNULL(cast(a.X0_to_1000_Student_Target_Score__c as varchar(100)), 'N/A')			= ISNULL(b.X0_to_1000_Student_Target_Score, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')													= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')												= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)															= cast(b.Create_Date as date)
	AND a.CreatedBy																			= b.Created_By


	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%iReady - ELA%'

	

--27 iStation Indicators of Progress - ELA

	select * 
	into #iStation_ELA
	from #Assessments
	WHERE [Assessment_Name]  like '%iStation Indicators of Progress - ELA%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #iStation_ELA (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 
	AND ISNULL(cast(a.Lexile_Score__c as varchar(100)), 'N/A')							= ISNULL(b.Lexile_Score, 'N/A')
	AND ISNULL(cast(a.Lexile_Score_for_Summative_Reports__c as varchar(100)), 'N/A')	= ISNULL(b.Lexile_Score_for_Summative_Reports, 'N/A')
	AND ISNULL(cast(a.Lexile_Student_Target_Score__c as varchar(100)), 'N/A')			= ISNULL(b.Lexile_Student_Target_Score, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')												= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')											= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)														= cast(b.Create_Date as date)
	AND a.CreatedBy																		= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%iStation Indicators of Progress - ELA%'


--28 TRC - ELA

	select * 
	into #TRC_ELA
	from #Assessments
	WHERE [Assessment_Name]  like '%TRC - ELA%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #TRC_ELA (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.TRC_Alpha_Scale_for_Summative_Reports__c as varchar(100)), 'N/A')		= ISNULL(b.TRC_Alpha_Scale_for_Summative_Reports, 'N/A')
	AND ISNULL(cast(a.TRC_Alpha_Scale_Score__c as varchar(100)), 'N/A')						= ISNULL(b.TRC_Alpha_Scale_Score, 'N/A')
	AND ISNULL(cast(a.TRC_Alpha_Scale_Student_Target_Score__c as varchar(100)), 'N/A')		= ISNULL(b.TRC_Alpha_Scale_Student_Target_Score, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')													= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')												= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)															= cast(b.Create_Date as date)
	AND a.CreatedBy																			= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%TRC - ELA%'

--29 District Benchmark Assessments - Math

	select * 
	into #DBA_Math
	from #Assessments
	WHERE [Assessment_Name]  like '%District Benchmark Assessments - Math%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #DBA_Math (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.District_Benchmark__c as varchar(100)), 'N/A')							= ISNULL(b.District_Benchmark, 'N/A')
	AND ISNULL(cast(a.District_Benchmark_for_Summative_Reports__c as varchar(100)), 'N/A')		= ISNULL(b.District_Benchmark_for_Summative_Reports , 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')														= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')													= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)																= cast(b.Create_Date as date)
	AND a.CreatedBy																				= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%District Benchmark Assessments - Math%'




--30  ANet - Math

	select * 
	into #ANet_Math
	from #Assessments
	WHERE [Assessment_Name]  like '%ANet - Math%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #ANet_Math (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.Percentile__c as varchar(100)), 'N/A')							= ISNULL(b.Percentile_PL, 'N/A')
	AND ISNULL(cast(a.Percentile_for_Summative_Reports__c as varchar(100)), 'N/A')		= ISNULL(b.Percentile_for_Summative_Reports , 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')												= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')											= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)														= cast(b.Create_Date as date)
	AND a.CreatedBy																		= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%ANet - Math%'

	
--31 DIBELS - ELA

	select * 
	into #DIBELS_ELA
	from #Assessments
	WHERE [Assessment_Name]  like '%DIBELS - ELA%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #DIBELS_ELA (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.DIBELS_GLE_Score_for_Summative_Reports__c as varchar(100)), 'N/A')	= ISNULL(b.DIBELS_GLE_Score_for_Summative_Reports, 'N/A')
	AND ISNULL(cast(a.DIBELS_GLE_Student_Target_Score__c as varchar(100)), 'N/A')			= ISNULL(b.DIBELS_GLE_Student_Target_Score, 'N/A')
	AND ISNULL(cast(a.DIBELS_Grade_Level_Equivalent_Score__c as varchar(100)), 'N/A')		= ISNULL(b.DIBELS_Grade_Level_Equivalent_Score, 'N/A')
	AND ISNULL(cast(a.DAZE__c as varchar(100)), 'N/A')										= ISNULL(b.DAZE, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')													= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')												= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)															= cast(b.Create_Date as date)
	AND a.CreatedBy																			= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%DIBELS - ELA%'

	


--32 Scantron Performance Series - ELA

	select * 
	into #Scantron_ELA
	from #Assessments
	WHERE [Assessment_Name]  like '%Scantron Performance Series - ELA%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #Scantron_ELA (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.Scantron_Scaled_Score__c as varchar(100)), 'N/A')						= ISNULL(b.Scantron_Scaled_Score, 'N/A')
	AND ISNULL(cast(a.Scantron_Scaled_Score_for_Sum_Reports__c as varchar(100)), 'N/A')		= ISNULL(b.Scantron_Scaled_Score_for_Sum_Reports, 'N/A')
	AND ISNULL(cast(a.Scantron_Student_Target_Score__c as varchar(100)), 'N/A')				= ISNULL(b.Scantron_Student_Target_Score, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')													= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')												= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)															= cast(b.Create_Date as date)
	AND a.CreatedBy																			= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%Scantron Performance Series - ELA%'
	
--33  ANet - ELA

	select * 
	into #ANet_ELA
	from #Assessments
	WHERE [Assessment_Name]  like '%ANet - ELA%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #ANet_ELA (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 


	AND ISNULL(cast(a.Percentile__c as varchar(100)), 'N/A')							= ISNULL(b.Percentile_PL, 'N/A')
	AND ISNULL(cast(a.Percentile_for_Summative_Reports__c as varchar(100)), 'N/A')		= ISNULL(b.Percentile_for_Summative_Reports, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')												= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')											= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)														= cast(b.Create_Date as date)
	AND a.CreatedBy																		= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%ANet - ELA%'


	
--34 Attendance Check In, Check Out

	select * 
	into #Att_Check_In_Out
	from #Assessments
	WHERE [Assessment_Name] like '%Attendance Check In Check Out - Attendance%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage

	FROM #Att_Check_In_Out (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.Check_ins__c as varchar(100)), 'N/A')						= ISNULL(b.Check_ins,'N/A')
	AND ISNULL(cast(a.Weekly_goal_progress__c as varchar(100)), 'N/A')			= ISNULL(b.Weekly_goal_progress ,'N/A')
	AND ISNULL(cast(a.Weekly_goals_set__c as varchar(100)), 'N/A')				= ISNULL(b.Weekly_goals_set,'N/A')
	AND ISNULL(cast(a.Goals_set__c as varchar(100)), 'N/A')						= ISNULL(b.Goals_Set,'N/A')
	AND ISNULL(cast(a.Difficulty_of_goal__c as varchar(100)), 'N/A')			= ISNULL(b.Difficulty_of_goal,'N/A')
	AND ISNULL(cast(a.goal_Progress__c as varchar(100)), 'N/A')					= ISNULL(b.Goal_progress,'N/A')
	AND ISNULL(cast(Date_Administered__c as date),'1900-01-01')					= ISNULL(cast(b.Date_Administered as date),'1900-01-01')
	AND ISNULL(a.Local_Benchmark__c,'N/A')										= ISNULL(b.Local_Benchmark,'000')	
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')									= ISNULL(b.Testing_Grade_Level,'N/A')
	AND cast(CreatedDate as date)												= cast(b.Create_Date as date)
	AND a.CreatedBy																= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name] like '%Attendance Check In Check Out - Attendance%'


	
--35

	select * 
	into #EasyCBM_Math
	from #Assessments
	WHERE [Assessment_Name]  like '%EasyCBM - Math%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #EasyCBM_Math (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.X0_to_300_Scaled_Score__c as varchar(100)), 'N/A')					= ISNULL(b.X0_to_300_Scaled_Score,'N/A')
	AND ISNULL(cast(a.X0_to_300_Scaled_Score_for_Sum_Reports__c as varchar(100)), 'N/A')	= ISNULL(b.X0_to_300_Scaled_Score_for_Sum_Reports,'N/A')
	AND ISNULL(cast(a.X0_to_300_Student_Target_Score__c as varchar(100)), 'N/A')			= ISNULL(b.X0_to_300_Student_Target_Score,'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')													= ISNULL(b.Local_Benchmark,'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')												= ISNULL(b.Testing_Grade_Level,'N/A')
	AND cast(CreatedDate as date)															= cast(b.Create_Date as date)
	AND a.CreatedBy																			= b.Created_By
		
	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%EasyCBM - Math%'



--36 Lexia - ELA

	select * 
	into #Lexia_ELA
	from #Assessments
	WHERE [Assessment_Name]  like '%Lexia - ELA%'		

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #Lexia_ELA (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.Lexia_Step_Number__c as varchar(100)), 'N/A')							= ISNULL(b.Lexia_Step_Number, 'N/A')	
	AND ISNULL(cast(a.Lexia_Step_Number_for_Summative_Reports__c as varchar(100)), 'N/A')	= ISNULL(b.Lexia_Step_Number_for_Summative_Reports, 'N/A')	
	AND ISNULL(a.Local_Benchmark__c, 'N/A')													= ISNULL(b.Local_Benchmark, 'N/A')	
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')												= ISNULL(b.Testing_Grade_Level, 'N/A')	
	AND cast(CreatedDate as date)															= cast(b.Create_Date as date)
	AND a.CreatedBy																			= b.Created_By
	
	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%Lexia - ELA%'		

	

--37 BPS Predictive - ELA

	select * 
	into #BPS_ELA
	from #Assessments
	WHERE [Assessment_Name]  like '%BPS Predictive - ELA%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #BPS_ELA (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.BPS_Predictive_Scaled_Score__c as varchar(100)), 'N/A')				= ISNULL(b.BPS_Predictive_Scaled_Score, 'N/A')	
	AND ISNULL(cast(a.BPS_Predict_Scaled_Score_for_Sum_Reports__c as varchar(100)), 'N/A')	= ISNULL(b.BPS_Predict_Scaled_Score_for_Sum_Reports, 'N/A')	
	AND ISNULL(a.Local_Benchmark__c, 'N/A')													= ISNULL(b.Local_Benchmark, 'N/A')	
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')												= ISNULL(b.Testing_Grade_Level, 'N/A')	
	AND cast(CreatedDate as date)															= cast(b.Create_Date as date)
	AND a.CreatedBy																			= b.Created_By
	
	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%BPS Predictive - ELA%'


--38 Florida State Assessment English Language Arts

	select * 
	into #FSA_ELA
	from #Assessments
	WHERE [Assessment_Name]  like '%Florida State Assessment English Language Arts - ELA%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #FSA_ELA (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.FSA_ELA_Score__c as varchar(100)), 'N/A')							= ISNULL(b.FSA_ELA_Score, 'N/A')
	AND ISNULL(cast(a.FSA_ELA_Score_for_Summative_Reports__c as varchar(100)), 'N/A')	= ISNULL(b.FSA_ELA_Score_for_Summative_Reports, 'N/A')
	AND ISNULL(cast(a.Percentile__c as varchar(100)), 'N/A')							= ISNULL(b.Percentile_PL, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')												= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')											= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)														= cast(b.Create_Date as date)
	AND a.CreatedBy																		= b.Created_By	
	
	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%Florida State Assessment English Language Arts - ELA%'

				

--39 Fountas and Pinnell Benchmark Assessment System - ELA

	select * 
	into #FPBAS_ELA
	from #Assessments
	WHERE [Assessment_Name]  like '%Fountas and Pinnell Benchmark Assessment System - ELA%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #FPBAS_ELA (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.A_to_Z_Alpha_Scale__c as varchar(100)), 'N/A')						= ISNULL(b.A_to_Z_Alpha_Scale, 'N/A')
	AND ISNULL(cast(a.A_to_Z_Alpha_Scale_for_Summative_Reports__c as varchar(100)), 'N/A')	= ISNULL(b.A_to_Z_Alpha_Scale_for_Summative_Reports, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')													= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')												= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)															= cast(b.Create_Date as date)
	AND a.CreatedBy																			= b.Created_By
	
	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%Fountas and Pinnell Benchmark Assessment System - ELA%'

--40	iReady - Math

	select * 
	into #iReady_Math
	from #Assessments
	WHERE [Assessment_Name]  like '%iReady - Math%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #iReady_Math (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.Quantile_score__c as varchar(100)), 'N/A')					        = ISNULL(b.Quantile_score,'N/A')
	AND ISNULL(cast(a.Quantile_score_for_summative_reports__c as varchar(100)), 'N/A')		= ISNULL(b.Quantile_score_for_summative_reports,'N/A')
	AND ISNULL(cast(a.Quantile_student_target_score__c as varchar(100)), 'N/A')				= ISNULL(b.Quantile_student_target_score,'N/A')
	AND ISNULL(cast(a.X0_to_1000_Scaled_Score__c as varchar(100)), 'N/A')					= ISNULL(b.X0_to_1000_Scaled_Score,'N/A')
	AND ISNULL(cast(a.X0_to_1000_Scaled_Score_for_Sum_Reports__c as varchar(100)), 'N/A')	= ISNULL(b.X0_to_1000_Scaled_Score_for_Sum_Reports,'N/A') 
	AND ISNULL(cast(a.X0_to_1000_Student_Target_Score__c as varchar(100)), 'N/A')			= ISNULL(b.X0_to_1000_Student_Target_Score,'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')													= ISNULL(b.Local_Benchmark,'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')												= ISNULL(b.Testing_Grade_Level,'N/A')
	AND cast(CreatedDate as date)															= cast(b.Create_Date as date)
	AND a.CreatedBy																			= b.Created_By


	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%iReady - Math%'

	
-- 41 STAR Math

	select * 
	into #Star_Math
	from #Assessments
	WHERE [Assessment_Name]  like '%Star Math - Math%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #Star_Math (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.STAR_Grade_level_equivalent_score__c as varchar(100)), 'N/A')			= ISNULL(b.STAR_Grade_level_equivalent_score, 'N/A')
	AND ISNULL(cast(a.STAR_GLE_score_for_summative_reports__c as varchar(100)), 'N/A')		= ISNULL(b.STAR_GLE_score_for_summative_reports, 'N/A')
	AND ISNULL(cast(a.STAR_GLE_student_target_score__c as varchar(100)), 'N/A')				= ISNULL(b.STAR_GLE_student_target_score, 'N/A')
	AND ISNULL(cast(a.X0_to_1000_Scaled_Score__c as varchar(100)), 'N/A')					= ISNULL(b.X0_to_1000_Scaled_Score, 'N/A')
	AND ISNULL(cast(a.X0_to_1000_Scaled_Score_for_Sum_Reports__c as varchar(100)), 'N/A')	= ISNULL(b.X0_to_1000_Scaled_Score_for_Sum_Reports, 'N/A') 
	AND ISNULL(cast(a.X0_to_1000_Student_Target_Score__c as varchar(100)), 'N/A')			= ISNULL( b.X0_to_1000_Student_Target_Score, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')													= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')												= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)															= cast(b.Create_Date as date)
	AND a.CreatedBy																			= b.Created_By


	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%Star Math - Math%'

-- 42 STAR Reading

	select * 
	into #Star_ELA
	from #Assessments
	WHERE [Assessment_Name]  like '%Star Reading - ELA%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #Star_ELA (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.STAR_Grade_level_equivalent_score__c as varchar(100)), 'N/A')			= ISNULL(b.STAR_Grade_level_equivalent_score, 'N/A')
	AND ISNULL(cast(a.STAR_GLE_score_for_summative_reports__c as varchar(100)), 'N/A')		= ISNULL(b.STAR_GLE_score_for_summative_reports, 'N/A')
	AND ISNULL(cast(a.STAR_GLE_student_target_score__c as varchar(100)), 'N/A')				= ISNULL(b.STAR_GLE_student_target_score, 'N/A')
	AND ISNULL(cast(a.X0_to_1000_Scaled_Score__c as varchar(100)), 'N/A')					= ISNULL(b.X0_to_1000_Scaled_Score, 'N/A')
	AND ISNULL(cast(a.X0_to_1000_Scaled_Score_for_Sum_Reports__c as varchar(100)), 'N/A')	= ISNULL(b.X0_to_1000_Scaled_Score_for_Sum_Reports, 'N/A') 
	AND ISNULL(cast(a.X0_to_1000_Student_Target_Score__c as varchar(100)), 'N/A')			= ISNULL( b.X0_to_1000_Student_Target_Score, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')													= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')												= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)															= cast(b.Create_Date as date)
	AND a.CreatedBy																			= b.Created_By


	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%Star Reading - ELA%'
  
	
-- 43 Time Based Behavior Tracker 

	select * 
	into #TBBT_Beh
	from #Assessments
	WHERE [Assessment_Name] like '%Time Based Behavior Tracker - Behavior%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #TBBT_Beh (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.Number_of_Detentions__c as varchar(100)), 'N/A')					= ISNULL(b.Number_of_Detentions, 'N/A')
	AND ISNULL(cast(a.Number_of_In_School_Suspensions__c as varchar(100)), 'N/A')		= ISNULL(b.Number_of_In_School_Suspensions, 'N/A')
	AND ISNULL(cast(a.Number_of_Office_Referrals__c as varchar(100)), 'N/A')			= ISNULL(b.Number_of_Office_Referrals, 'N/A')
	AND ISNULL(cast(a.Number_of_Out_of_School_Suspensions__c as varchar(100)), 'N/A')	= ISNULL(b.Number_of_Out_of_School_Suspensions, 'N/A')
	AND ISNULL(cast(a.Number_of_Suspensions__c as varchar(100)), 'N/A')					= ISNULL(b.Number_of_Suspensions, 'N/A')
	AND ISNULL(cast(a.Time_Period__c as varchar(100)), 'N/A')							= ISNULL(b.Time_Period, 'N/A') 
	AND ISNULL(a.Local_Benchmark__c, 'N/A')												= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')											= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND ISNULL(cast(Date_Administered__c as date),'1900-01-01')				= ISNULL(cast(b.Date_Administered as date),'1900-01-01')
	AND cast(CreatedDate as date)														= cast(b.Create_Date as date)
	AND a.CreatedBy																		= b.Created_By


	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name] like '%Time Based Behavior Tracker - Behavior%'
  

--44 Time Based Attendance Tracker

	select * 
	into #TBAT
	from #Assessments
	WHERE [Assessment_Name]  like '%Time Based Attendance Tracker - Attendance%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #TBAT (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.Number_of_Absences__c as varchar(100)), 'N/A')			= ISNULL(b.Number_of_Absences, 'N/A')
	AND ISNULL(cast(a.Number_of_Excused_Absences__c as varchar(100)), 'N/A')	= ISNULL(b.Number_of_Excused_Absences, 'N/A')
	AND ISNULL(cast(a.Number_of_Tardies__c as varchar(100)), 'N/A')				= ISNULL(b.Number_of_Tardies, 'N/A')
	AND ISNULL(cast(a.Number_of_Unexcused_Absences__c as varchar(100)), 'N/A')	= ISNULL(b.Number_of_Unexcused_Absences, 'N/A')
	AND ISNULL(cast(a.Days_Enrolled__c as varchar(100)), 'N/A')					= ISNULL(b.Days_Enrolled, 'N/A')
	AND ISNULL(cast(a.Time_Period__c as varchar(100)), 'N/A')					= ISNULL(b.Time_Period, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')										= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')					 				= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)												= cast(b.Create_Date as date)
	AND a.CreatedBy																= b.Created_By


	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%Time Based Attendance Tracker - Attendance%'
	order by assignmentID,assessmentID,studentID


	--45 Dessa-Mini

	select * 
	into #Dessa_Mini
	from #Assessments
	WHERE [Assessment_Name]  like '%Dessa-mini%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #Dessa_Mini (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.SEL_Composite_Description__c as varchar(100)), 'N/A')		= ISNULL(b.SEL_Composite_Description, 'N/A')
	AND ISNULL(cast(a.SEL_Composite_Percentile__c as varchar(100)), 'N/A')		= ISNULL(b.SEL_Composite_Percentile, 'N/A')
	AND ISNULL(cast(a.SEL_Composite_T_Score__c as varchar(100)), 'N/A')			= ISNULL(b.SEL_Composite_T_Score, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')										= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')					 				= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)												= cast(b.Create_Date as date)
	AND a.CreatedBy																= b.Created_By


	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%Dessa-mini%'
	order by assignmentID,assessmentID,studentID

	--45.5 DESSA

	select * 
	into #Dessa
	from #Assessments
	WHERE [Assessment_Name]  like 'DESSA'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #Dessa (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 
	AND ISNULL(cast(a.Decision_Making_Description__c as varchar(100)), 'N/A')				= ISNULL(b.Decision_Making_Description, 'N/A')
	AND ISNULL(cast(a.Decision_Making_Percentile__c as varchar(100)), 'N/A')				= ISNULL(b.Decision_Making_Percentile, 'N/A')
	AND ISNULL(cast(a.Decision_Making_Raw_Score__c as varchar(100)), 'N/A')					= ISNULL(b.Decision_Making_Raw_Score, 'N/A')
	AND ISNULL(cast(a.Decision_Making_T_Score__c as varchar(100)), 'N/A')					= ISNULL(b.Decision_Making_T_Score, 'N/A')
	AND ISNULL(cast(a.Goal_directed_Behavior_Description__c as varchar(100)), 'N/A')		= ISNULL(b.Goal_directed_Behavior_Description, 'N/A')
	AND ISNULL(cast(a.Goal_directed_Behavior_Percentile__c as varchar(100)), 'N/A')			= ISNULL(b.Goal_directed_Behavior_Percentile, 'N/A')
	AND ISNULL(cast(a.Goal_directed_Behavior_Raw_Score__c as varchar(100)), 'N/A')			= ISNULL(b.Goal_directed_Behavior_Raw_Score, 'N/A')
	AND ISNULL(cast(a.Goal_directed_Behavior_T_Score__c as varchar(100)), 'N/A')			= ISNULL(b.Goal_directed_Behavior_T_Score, 'N/A')
	AND ISNULL(cast(a.Optimistic_Thinking_Description__c as varchar(100)), 'N/A')			= ISNULL(b.Optimistic_Thinking_Description, 'N/A')
	AND ISNULL(cast(a.Optimistic_Thinking_Percentile__c as varchar(100)), 'N/A')			= ISNULL(b.Optimistic_Thinking_Percentile, 'N/A')
	AND ISNULL(cast(a.Optimistic_Thinking_Raw_Score__c as varchar(100)), 'N/A')				= ISNULL(b.Optimistic_Thinking_Raw_Score, 'N/A')
	AND ISNULL(cast(a.Optimistic_Thinking_T_Score__c as varchar(100)), 'N/A')				= ISNULL(b.Optimistic_Thinking_T_Score, 'N/A')
	AND ISNULL(cast(a.Personal_Responsibility_Description__c as varchar(100)), 'N/A')		= ISNULL(b.Personal_Responsibility_Description, 'N/A')
	AND ISNULL(cast(a.Personal_Responsibility_Percentile__c as varchar(100)), 'N/A')		= ISNULL(b.Personal_Responsibility_Percentile, 'N/A')
	AND ISNULL(cast(a.Personal_Responsibility_Raw_Score__c as varchar(100)), 'N/A')			= ISNULL(b.Personal_Responsibility_Raw_Score, 'N/A')
	AND ISNULL(cast(a.Personal_Responsibility_T_Score__c as varchar(100)), 'N/A')			= ISNULL(b.Personal_Responsibility_T_Score, 'N/A')
	AND ISNULL(cast(a.Relationship_Skills_Description__c as varchar(100)), 'N/A')			= ISNULL(b.Relationship_Skills_Description, 'N/A')
	AND ISNULL(cast(a.Relationship_Skills_Percentile__c as varchar(100)), 'N/A')			= ISNULL(b.Relationship_Skills_Percentile, 'N/A')
	AND ISNULL(cast(a.Relationship_Skills_Raw_Score__c as varchar(100)), 'N/A')				= ISNULL(b.Relationship_Skills_Raw_Score, 'N/A')
	AND ISNULL(cast(a.Relationship_Skills_T_Score__c as varchar(100)), 'N/A')				= ISNULL(b.Relationship_Skills_T_Score, 'N/A')
	AND ISNULL(cast(a.SEL_Composite_Description__c as varchar(100)), 'N/A')					= ISNULL(b.SEL_Composite_Description, 'N/A')
	AND ISNULL(cast(a.SEL_Composite_Percentile__c as varchar(100)), 'N/A')					= ISNULL(b.SEL_Composite_Percentile, 'N/A')
	AND ISNULL(cast(a.SEL_Composite_Raw_Score__c as varchar(100)), 'N/A')					= ISNULL(b.SEL_Composite_Raw_Score, 'N/A')
	AND ISNULL(cast(a.SEL_Composite_T_Score__c as varchar(100)), 'N/A')						= ISNULL(b.SEL_Composite_T_Score, 'N/A')
	AND ISNULL(cast(a.Self_Awareness_Description__c as varchar(100)), 'N/A')				= ISNULL(b.Self_Awareness_Description, 'N/A')
	AND ISNULL(cast(a.Self_Awareness_Percentile__c as varchar(100)), 'N/A')					= ISNULL(b.Self_Awareness_Percentile, 'N/A')
	AND ISNULL(cast(a.Self_Awareness_Raw_Score__c as varchar(100)), 'N/A')					= ISNULL(b.Self_Awareness_Raw_Score, 'N/A')
	AND ISNULL(cast(a.Self_Awareness_T_Score__c as varchar(100)), 'N/A')					= ISNULL(b.Self_Awareness_T_Score, 'N/A')
	AND ISNULL(cast(a.Self_Management_Description__c as varchar(100)), 'N/A')				= ISNULL(b.Self_Management_Description, 'N/A')
	AND ISNULL(cast(a.Self_Management_Percentile__c as varchar(100)), 'N/A')				= ISNULL(b.Self_Management_Percentile, 'N/A')
	AND ISNULL(cast(a.Self_Management_Raw_Score__c as varchar(100)), 'N/A')					= ISNULL(b.Self_Management_Raw_Score, 'N/A')
	AND ISNULL(cast(a.Self_Management_T_Score__c as varchar(100)), 'N/A')					= ISNULL(b.Self_Management_T_Score, 'N/A')
	AND ISNULL(cast(a.Social_Awareness_Description__c as varchar(100)), 'N/A')				= ISNULL(b.SEL_Composite_Description, 'N/A')
	AND ISNULL(cast(a.Social_Awareness_Percentile__c as varchar(100)), 'N/A')				= ISNULL(b.Social_Awareness_Percentile, 'N/A')
	AND ISNULL(cast(a.Social_Awareness_Raw_Score__c as varchar(100)), 'N/A')				= ISNULL(b.Social_Awareness_Raw_Score, 'N/A')
	AND ISNULL(cast(a.Social_Awareness_T_Score__c as varchar(100)), 'N/A')					= ISNULL(b.Social_Awareness_T_Score, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')													= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')					 							= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)															= cast(b.Create_Date as date)
	AND a.CreatedBy																			= b.Created_By


	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like 'DESSA'
	order by assignmentID,assessmentID,studentID


	--46 Cumulative ADA Tracker - Attendance
	select * 
	into #CAT_Att
	from #Assessments
	WHERE [Assessment_Name]  like '%Cumulative ADA Tracker - Attendance%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #CAT_Att (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.Average_Daily_Attendance__c as varchar(100)), 'N/A')		= ISNULL(b.Average_Daily_Attendance__c, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')										= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')					 				= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)												= cast(b.Create_Date as date)
	AND a.CreatedBy																= b.Created_By


	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%Cumulative ADA Tracker - Attendance%'
	order by assignmentID,assessmentID,studentID

	--47 Reporting Period ADA Tracker - Attendance
	select * 
	into #RPAT_Att
	from #Assessments
	WHERE [Assessment_Name]  like '%Reporting Period ADA Tracker - Attendance%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #RPAT_Att (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.Average_Daily_Attendance__c as varchar(100)), 'N/A')		= ISNULL(b.Average_Daily_Attendance__c, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')										= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')					 				= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)												= cast(b.Create_Date as date)
	AND a.CreatedBy																= b.Created_By


	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%Reporting Period ADA Tracker - Attendance%'
	order by assignmentID,assessmentID,studentID



	--48
	select * 
	into #FAIR_ELA
	from #Assessments
	WHERE [Assessment_Name]  like '%Florida Assessments For Instruction in Reading - ELA%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #FAIR_ELA (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.Average_Ability_Score__c as varchar(100)), 'N/A')			= ISNULL(b.Average_Ability_Score, 'N/A')
	AND ISNULL(cast(a.RCT_Ability_Score__c as varchar(100)), 'N/A')				= ISNULL(b.RCT_Ability_Score, 'N/A')
	AND ISNULL(cast(a.VKT_Ability_Score__c as varchar(100)), 'N/A')				= ISNULL(b.VKT_Ability_Score, 'N/A')
	AND ISNULL(cast(a.WRT_Ability_Score__c as varchar(100)), 'N/A')				= ISNULL(b.WRT_Ability_Score, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')										= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')					 				= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)												= cast(b.Create_Date as date)
	AND a.CreatedBy																= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%Florida Assessments For Instruction in Reading - ELA%'
	order by assignmentID,assessmentID,studentID


	--49
	select * 
	into #Compass_Math
	from #Assessments
	WHERE [Assessment_Name]  like '%Compass Learning - Math%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #Compass_Math (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.PostTest__c as varchar(100)), 'N/A')			= ISNULL(b.PostTest, 'N/A')
	AND ISNULL(cast(a.PreTest__c as varchar(100)), 'N/A')			= ISNULL(b.PreTest, 'N/A')
	AND ISNULL(cast(a.RIT_Score__c as varchar(100)), 'N/A')			= ISNULL(b.RIT_Score, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')							= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')					 	= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)									= cast(b.Create_Date as date)
	AND a.CreatedBy													= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%Compass Learning - Math%'
	order by assignmentID,assessmentID,studentID

		
	--50
	select * 
	into #DRP_ELA
	from #Assessments
	WHERE [Assessment_Name]  like '%Degrees Of Reading Power - ELA%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #DRP_ELA (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.DRP_Exam_Score__c as varchar(100)), 'N/A')			= ISNULL(b.DRP_Exam_Score, 'N/A')
	AND ISNULL(cast(a.DRP_Proficiency_Level__c as varchar(100)), 'N/A')		= ISNULL(b.DRP_Proficiency_Level, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')									= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')					 			= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)											= cast(b.Create_Date as date)
	AND a.CreatedBy															= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%Degrees Of Reading Power - ELA%'
	order by assignmentID,assessmentID,studentID

	
	--51
	select * 
	into #SBAC_ELA
	from #Assessments
	WHERE [Assessment_Name]  like '%Smarter Balanced Assessment Consortium - ELA%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #SBAC_ELA (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.SBAC_ELA_Band__c as varchar(100)), 'N/A')				= ISNULL(b.SBAC_ELA_Band, 'N/A')
	AND ISNULL(cast(a.SBAC_ELA_Scale_Score__c as varchar(100)), 'N/A')		= ISNULL(b.SBAC_ELA_Scale_Score, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')									= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')					 			= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)											= cast(b.Create_Date as date)
	AND a.CreatedBy															= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%Smarter Balanced Assessment Consortium - ELA%'
	order by assignmentID,assessmentID,studentID





	--52
	select * 
	into #SBAC_Math
	from #Assessments
	WHERE [Assessment_Name]  like '%Smarter Balanced Assessment Consortium - MATH%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #SBAC_Math (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.SBAC_MATH_Band__c as varchar(100)), 'N/A')			= ISNULL(b.SBAC_MATH_Band, 'N/A')
	AND ISNULL(cast(a.SBAC_MATH_Scale_Score__c as varchar(100)), 'N/A')		= ISNULL(b.SBAC_MATH_Scale_Score, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')									= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')					 			= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)											= cast(b.Create_Date as date)
	AND a.CreatedBy															= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%Smarter Balanced Assessment Consortium - MATH%'
	order by assignmentID,assessmentID,studentID



	--53
	select * 
	into #ACT_Aspire_ELA
	from #Assessments
	WHERE [Assessment_Name]  like '%ACT Aspire - ELA%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #ACT_Aspire_ELA (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.Percent_Correct__c as varchar(100)), 'N/A')			= ISNULL(b.Percent_Correct, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')									= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')					 			= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)											= cast(b.Create_Date as date)
	AND a.CreatedBy															= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%ACT Aspire - ELA%'
	order by assignmentID,assessmentID,studentID


	--54
	select * 
	into #ACT_Aspire_Math
	from #Assessments
	WHERE [Assessment_Name]  like '%ACT Aspire - MATH%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #ACT_Aspire_Math (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.Percent_Correct__c as varchar(100)), 'N/A')			= ISNULL(b.Percent_Correct, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')									= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')					 			= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)											= cast(b.Create_Date as date)
	AND a.CreatedBy															= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%ACT Aspire - MATH%'
	order by assignmentID,assessmentID,studentID



	--55
	select * 
	into #Agile_Minds_Math
	from #Assessments
	WHERE [Assessment_Name]  like '%Agile Minds - MATH%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #Agile_Minds_Math (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.Percent_Correct__c as varchar(100)), 'N/A')			= ISNULL(b.Percent_Correct, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')									= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')					 			= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)											= cast(b.Create_Date as date)
	AND a.CreatedBy															= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%Agile Minds - MATH%'
	order by assignmentID,assessmentID,studentID



	--56
	select * 
	into #Anet_ELA2
	from #Assessments
	WHERE [Assessment_Name]  like '%ANet - ELA%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #Anet_ELA2 (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.Percentile__c as varchar(100)), 'N/A')					= ISNULL(b.Percentile_PL, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')									= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')					 			= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)											= cast(b.Create_Date as date)
	AND a.CreatedBy															= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%ANet - ELA%'
	order by assignmentID,assessmentID,studentID


	--57
	select * 
	into #Anet_Math2
	from #Assessments
	WHERE [Assessment_Name]  like '%ANet - MATH%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #Anet_Math2 (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.Percentile__c as varchar(100)), 'N/A')					= ISNULL(b.Percentile_PL, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')									= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')					 			= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)											= cast(b.Create_Date as date)
	AND a.CreatedBy															= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%ANet - MATH%'
	order by assignmentID,assessmentID,studentID
	
	
	--58
	select * 
	into #DDUT_ELA
	from #Assessments
	WHERE [Assessment_Name]  like '%DC District Unit Test - ELA%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #DDUT_ELA (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.Percent_Correct__c as varchar(100)), 'N/A')			= ISNULL(b.Percent_Correct, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')									= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')					 			= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)											= cast(b.Create_Date as date)
	AND a.CreatedBy															= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%DC District Unit Test - ELA%'
	order by assignmentID,assessmentID,studentID


	--59
	select * 
	into #DDUT_Math
	from #Assessments
	WHERE [Assessment_Name]  like '%DC District Unit Test - MATH%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #DDUT_Math (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.Percent_Correct__c as varchar(100)), 'N/A')			= ISNULL(b.Percent_Correct, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')									= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')					 			= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)											= cast(b.Create_Date as date)
	AND a.CreatedBy															= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%DC District Unit Test - MATH%'
	order by assignmentID,assessmentID,studentID


	--59
	select * 
	into #MSDCA_Math
	from #Assessments
	WHERE [Assessment_Name]  like '%Manchester School District Computation Assessment - MATH%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #MSDCA_Math (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.MSD_Computation_Score__c as varchar(100)), 'N/A')		= ISNULL(b.MSD_Computation_Score, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')									= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')					 			= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)											= cast(b.Create_Date as date)
	AND a.CreatedBy															= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%Manchester School District Computation Assessment - MATH%'
	order by assignmentID,assessmentID,studentID


	--60
	select * 
	into #TCRA_ELA
	from #Assessments
	WHERE [Assessment_Name]  like '%Teachers College Reading Assessment - ELA%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #TCRA_ELA (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.Student_Reading_Level__c as varchar(100)), 'N/A')		= ISNULL(b.Student_Reading_Level, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')									= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')					 			= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)											= cast(b.Create_Date as date)
	AND a.CreatedBy															= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%Teachers College Reading Assessment - ELA%'
	order by assignmentID,assessmentID,studentID


	--60
	select * 
	into #WaCR_ELA
	from #Assessments
	WHERE [Assessment_Name]  like '%Wonders (McGraw Hill Readers) and Accelerated Reader - ELA%'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, ISNULL(e.DateID,''), 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #WaCR_ELA (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(cast(a.Percentile__c as varchar(100)), 'N/A')	= ISNULL(b.Percentile_PL, 'N/A')
	AND ISNULL(a.Local_Benchmark__c, 'N/A')						= ISNULL(b.Local_Benchmark, 'N/A')
	AND ISNULL(a.Testing_Grade_Level__c, 'N/A')					= ISNULL(b.Testing_Grade_Level, 'N/A')
	AND cast(CreatedDate as date)								= cast(b.Create_Date as date)
	AND a.CreatedBy												= b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN (select max(SchoolID) SchoolID, SchoolName, Business_Unit, CYSch_SF_ID from SDW_Prod.dbo.DimSchool group by SchoolName, Business_Unit, CYSch_SF_ID) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	LEFT OUTER JOIN SDW_Prod.dbo.DimDate  (nolock) e on cast(a.Date_Administered__c as date) = e.Date
--	WHERE [Assessment_Name]  like '%Wonders (McGraw Hill Readers) and Accelerated Reader - ELA%'
	order by assignmentID,assessmentID,studentID



	
	--************************************************************************************************************************************************
	-- NEW ASSESSMENTS END
    --************************************************************************************************************************************************
/*
	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID,IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, b.AssessmentID, 1 CorpsMemberID, e.DateID, 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, c.StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #Assessments (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName 

	AND ISNULL(a.Lexile_Score__c, as varchar(100)), 'N/A') = b.Lexile_Score
	AND ISNULL(a.Local_Benchmark__c, 'N/A') = b.Local_Benchmark 
	AND ISNULL(a.National_Benchmark__c, 'N/A') = b.National_Benchmark
	AND ISNULL(cast(a.Oral_Reading_Fluency_ORF__c as varchar(100)), 'N/A') = b.Oral_Reading_Fluency_ORF
	AND ISNULL(a.Reading_Level__c, 'N/A') = b.Reading_Level
	AND cast(CreatedDate as date) = cast(b.Create_Date as date)
	AND a.CreatedBy = b.Created_By

	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN SDW_Prod.dbo.DimSchool (nolock) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	INNER JOIN SDW_Prod.dbo.DimDate (nolock) e on cast(a.Date_Administered__c as date) = e.Date
	WHERE [Assessment_Name] = ''


	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID, 
	IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, AssessmentID, 1 CorpsMemberID, e.DateID, 1 GradeID, 1 IndicatorAreaID, 
	d.SchoolID, StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #Assessments (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName
	AND ISNULL(cast(a.Composite_Score_CS__c as varchar(100)), 'N/A') = b.Composite_Score_CS
	AND ISNULL(cast(a.DAZE_adjusted__c as varchar(100)), 'N/A') = b.DAZE_adjusted
	AND ISNULL(cast(a.Oral_Reading_Fluency_Accuracy__c as varchar(100)), 'N/A') = b.Oral_Reading_Fluency_Accuracy
	AND ISNULL(a.Local_Benchmark__c, 'N/A') = b.Local_Benchmark 
	AND ISNULL(a.National_Benchmark__c, 'N/A') = b.National_Benchmark
	AND ISNULL(cast(a.Oral_Reading_Fluency_ORF__c as varchar(100)), 'N/A') = b.Oral_Reading_Fluency_ORF
	AND ISNULL(cast(a.Retell_Quality_of_Response__c as varchar(100)), 'N/A') = b.Retell_Quality_Of_Response
	AND ISNULL(cast(a.Retell_Score__c as varchar(100)), 'N/A') = b.Retell_Score
	AND cast(a.CreatedDate as date) = cast(b.Create_Date as date)
	AND a.CreatedBy = b.Created_By	
	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN SDW_Prod.dbo.DimSchool (nolock) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	INNER JOIN SDW_Prod.dbo.DimDate (nolock) e on cast(a.Date_Administered__c as date) = e.Date
	WHERE [Assessment_Name] = 'DIBELS (Dynamic Indicators of Basic Early Literacy Skills)'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID, 
	IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, AssessmentID, 1 CorpsMemberID, e.DateID, 1 GradeID, 1 IndicatorAreaID, 
	SchoolID, StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #Assessments (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName
	AND ISNULL(cast(a.District_Average_RIT__c as varchar(100)), 'N/A') = b.District_Average_RIT
	AND ISNULL(cast(a.Percentile_Score__c as varchar(100)), 'N/A') = b.Percentile_Score
	AND ISNULL(cast(a.RIT_Score__c as varchar(100)), 'N/A') = b.RIT_Score
	AND ISNULL(cast(a.Zone_of_Proximal_Development_ZPD__c as varchar(100)), 'N/A') = b.Zone_of_Proximal_Development_ZPD
	AND ISNULL(cast(a.Test_Type__c as varchar(100)), 'N/A') = b.Test_Type
	AND ISNULL(a.Local_Benchmark__c, 'N/A') = b.Local_Benchmark 
	AND ISNULL(a.National_Benchmark__c, 'N/A') = b.National_Benchmark
	AND cast(a.CreatedDate as date) = cast(b.Create_Date as date)
	AND a.CreatedBy = b.Created_By
	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN SDW_Prod.dbo.DimSchool (nolock) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	INNER JOIN SDW_Prod.dbo.DimDate (nolock) e on cast(ISNULL(a.Date_Administered__c, '1/1/2014') as date) = e.Date
	WHERE [Assessment_Name] = 'MAP (Measures of Academic Progress)'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID, 
	IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, AssessmentID, 1 CorpsMemberID, e.DateID, 1 GradeID, 1 IndicatorAreaID, 
	SchoolID, StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #Assessments (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName
	AND ISNULL(cast(a.Lexile_Score__c as varchar(100)), 'N/A') = b.Lexile_Score
	AND ISNULL(cast(a.Normal_Curve_Equivalent_NCE__c as varchar(100)), 'N/A') = b.Normal_Curve_Equivalent_NCE
	AND ISNULL(cast(a.Percentile_Score__c as varchar(100)), 'N/A') = b.Percentile_Score
	AND ISNULL(cast(a.Stanine__c as varchar(100)), 'N/A') = b.Stanine
	AND ISNULL(a.Local_Benchmark__c, 'N/A') = b.Local_Benchmark 
	AND ISNULL(a.National_Benchmark__c, 'N/A') = b.National_Benchmark
	AND cast(a.CreatedDate as date) = cast(b.Create_Date as date)
	AND a.CreatedBy = b.Created_By
	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN SDW_Prod.dbo.DimSchool (nolock) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	INNER JOIN SDW_Prod.dbo.DimDate (nolock) e on cast(ISNULL(a.Date_Administered__c, '1/1/2014') as date) = e.Date
	WHERE [Assessment_Name] = 'SRI (Scholastic Reading Inventory)' 

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID, 
	IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, AssessmentID, 1 CorpsMemberID, e.DateID, 1 GradeID, 1 IndicatorAreaID, 
	SchoolID, StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #Assessments (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName
	AND ISNULL(cast(a.Number_of_Absences__c as varchar(100)), 'N/A')			= b.Number_of_Absences
	AND ISNULL(cast(a.Days_Enrolled__c as varchar(100)), 'N/A')					= b.Days_Enrolled
	AND ISNULL(cast(a.Number_of_Excused_Absences__c as varchar(100)), 'N/A')	= b.Number_of_Excused_Absences
	AND ISNULL(cast(a.SchoolForce__Scale_Score__c as varchar(100)), 'N/A')		= b.Scaled_Score_SS
	AND ISNULL(cast(a.Number_of_Tardies__c as varchar(100)), 'N/A')				= b.Number_of_Tardies
	AND ISNULL(cast(a.Number_of_Unexcused_Absences__c as varchar(100)), 'N/A')	= b.Number_of_Unexcused_Absences
	AND ISNULL(a.Local_Benchmark__c, 'N/A') = b.Local_Benchmark 
	AND ISNULL(a.National_Benchmark__c, 'N/A') = b.National_Benchmark
	AND ISNULL(a.Time_Period__c, 'N/A') = b.Time_Period
	AND cast(a.CreatedDate as date) = cast(b.Create_Date as date)
	AND a.CreatedBy = b.Created_By
	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN SDW_Prod.dbo.DimSchool (nolock) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	INNER JOIN SDW_Prod.dbo.DimDate (nolock) e on cast(ISNULL(a.Date_Administered__c, '1/1/2014') as date) = e.Date
	WHERE [Assessment_Name] = 'Time Based Attendance Tracker'

	INSERT INTO SDW_Prod.dbo.FactAll(AssignmentID, AssessmentID, CorpsMemberID, DateID, GradeID, 
	IndicatorAreaID, SchoolID, StudentID, FactTypeID, Session_Dosage)
	SELECT 1 AssignmentID, AssessmentID, 1 CorpsMemberID, e.DateID, 1 GradeID, 1 IndicatorAreaID, 
	1 SchoolID, 1 StudentID, 3 FactTypeID, 0 Session_Dosage
	FROM #Assessments (nolock) a
	INNER JOIN SDW_Prod.dbo.DimAssessment (nolock) b on 
	a.Assessment_Name = b.AssessmentName
	AND ISNULL(a.Local_Benchmark__c, 'N/A') = b.Local_Benchmark 
	AND ISNULL(a.National_Benchmark__c, 'N/A') = b.National_Benchmark
	AND ISNULL(cast(a.Number_of_Detentions__c as varchar(100)), 'N/A') = b.Number_of_Detentions
	AND ISNULL(cast(a.Number_of_Suspensions__c as varchar(100)), 'N/A') = b.Number_of_Suspensions
	AND ISNULL(cast(a.Number_of_In_School_Suspensions__c as varchar(100)), 'N/A') = b.Number_of_In_School_Suspensions
	AND ISNULL(cast(a.Number_of_Out_of_School_Suspensions__c as varchar(100)), 'N/A') = b.Number_of_Out_of_School_Suspensions
	AND ISNULL(cast(a.Number_of_Office_Referrals__c as varchar(100)), 'N/A') = b.Number_of_Office_Referrals
	AND ISNULL(a.Time_Period__c, 'N/A') = b.Time_Period
	AND cast(a.CreatedDate as date) = cast(b.Create_Date as date)
	AND a.CreatedBy = b.Created_By
	INNER JOIN SDW_Prod.dbo.DimStudent (nolock) c on a.Student_SF_ID = c.StudentSF_ID
	INNER JOIN SDW_Prod.dbo.DimSchool (nolock) d on a.Student_School_Name = d.SchoolName AND a.Business_Unit = d.Business_Unit and a.[cysch_Accnt_SF_ID] = d.CYSch_SF_ID
	INNER JOIN SDW_Prod.dbo.DimDate (nolock) e on cast(ISNULL(a.Date_Administered__c, '1/1/2014') as date) = e.Date
	WHERE [Assessment_Name] = 'Time Based Behavior Tracker' 
*/

	--END ASSESSMENTS-------------------------------------------------------------------------------------------------------------

	UPDATE SDW_Prod.dbo.DimSchool set Number_Of_Teams =6 WHERE Business_Unit = 'Baton Rouge'
	UPDATE SDW_Prod.dbo.DimSchool set Number_Of_Teams =21 WHERE Business_Unit = 'Boston'
	UPDATE SDW_Prod.dbo.DimSchool set Number_Of_Teams =21 WHERE Business_Unit = 'Chicago'
	UPDATE SDW_Prod.dbo.DimSchool set Number_Of_Teams =6 WHERE Business_Unit = 'Cleveland'
	UPDATE SDW_Prod.dbo.DimSchool set Number_Of_Teams =3 WHERE Business_Unit = 'Columbia'
	UPDATE SDW_Prod.dbo.DimSchool set Number_Of_Teams =4 WHERE Business_Unit = 'Columbus'
	UPDATE SDW_Prod.dbo.DimSchool set Number_Of_Teams =2 WHERE Business_Unit = 'Dallas'
	UPDATE SDW_Prod.dbo.DimSchool set Number_Of_Teams =8 WHERE Business_Unit = 'Denver'
	UPDATE SDW_Prod.dbo.DimSchool set Number_Of_Teams =13 WHERE Business_Unit = 'Detroit'
	UPDATE SDW_Prod.dbo.DimSchool set Number_Of_Teams =8 WHERE Business_Unit = 'Jacksonville'
	UPDATE SDW_Prod.dbo.DimSchool set Number_Of_Teams =6 WHERE Business_Unit = 'Little Rock'
	UPDATE SDW_Prod.dbo.DimSchool set Number_Of_Teams =25 WHERE Business_Unit = 'Los Angeles'
	UPDATE SDW_Prod.dbo.DimSchool set Number_Of_Teams =6 WHERE Business_Unit = 'Manchester'
	UPDATE SDW_Prod.dbo.DimSchool set Number_Of_Teams =18 WHERE Business_Unit = 'Miami'
	UPDATE SDW_Prod.dbo.DimSchool set Number_Of_Teams =9 WHERE Business_Unit = 'Milwaukee'
	UPDATE SDW_Prod.dbo.DimSchool set Number_Of_Teams =5 WHERE Business_Unit = 'New Orleans'
	UPDATE SDW_Prod.dbo.DimSchool set Number_Of_Teams =24 WHERE Business_Unit = 'New York City'
	UPDATE SDW_Prod.dbo.DimSchool set Number_Of_Teams =7 WHERE Business_Unit = 'Orlando'
	UPDATE SDW_Prod.dbo.DimSchool set Number_Of_Teams =18 WHERE Business_Unit = 'Philadelphia'
	UPDATE SDW_Prod.dbo.DimSchool set Number_Of_Teams =5 WHERE Business_Unit = 'Rhode Island'
	UPDATE SDW_Prod.dbo.DimSchool set Number_Of_Teams =6 WHERE Business_Unit = 'Sacramento'
	UPDATE SDW_Prod.dbo.DimSchool set Number_Of_Teams =9 WHERE Business_Unit = 'San Antonio'
	UPDATE SDW_Prod.dbo.DimSchool set Number_Of_Teams =9 WHERE Business_Unit = 'San Jose'
	UPDATE SDW_Prod.dbo.DimSchool set Number_Of_Teams =8 WHERE Business_Unit = 'Seattle'
	UPDATE SDW_Prod.dbo.DimSchool set Number_Of_Teams =6 WHERE Business_Unit = 'Tulsa'
	UPDATE SDW_Prod.dbo.DimSchool set Number_Of_Teams =13 WHERE Business_Unit = 'Washington, DC'

	UPDATE SDW_Prod.dbo.DimAssignment set AssignmentSubject = 'ELA/Literacy' WHERE SectionName like '%ELA%'
	UPDATE SDW_Prod.dbo.DimAssignment set AssignmentSubject = 'Attendance' WHERE AssignmentName like '%ADA%'
	UPDATE SDW_Prod.dbo.DimAssignment set AssignmentSubject = 'Math' WHERE SectionName like '%Math%'
	
	UPDATE SDW_Prod.dbo.FactAll 
	set ProgramID = 1
	FROM SDW_Prod.dbo.FactAll (nolock) a
	INNER JOIN DimFactType (nolock) b on a.FactTypeID = b.FactTypeID
	INNER JOIN DimIndicatorArea (nolock) c on a.IndicatorAreaID = c.IndicatorAreaID
	WHERE c.IndicatorArea = 'Attendance' AND b.FactType = 'Intervention'

	UPDATE SDW_Prod.dbo.FactAll 
	set ProgramID = 2
	FROM SDW_Prod.dbo.FactAll (nolock) a
	INNER JOIN DimFactType (nolock) b on a.FactTypeID = b.FactTypeID
	INNER JOIN DimIndicatorArea (nolock) c on a.IndicatorAreaID = c.IndicatorAreaID
	WHERE c.IndicatorArea = 'ELA/Literacy' AND b.FactType = 'Intervention'

	UPDATE SDW_Prod.dbo.FactAll 
	set ProgramID = 3
	FROM SDW_Prod.dbo.FactAll (nolock) a
	INNER JOIN DimFactType (nolock) b on a.FactTypeID = b.FactTypeID
	INNER JOIN DimIndicatorArea (nolock) c on a.IndicatorAreaID = c.IndicatorAreaID
	WHERE c.IndicatorArea = 'Math' AND b.FactType = 'Intervention'

	UPDATE SDW_Prod.dbo.FactAll 
	set ProgramID = 1
	FROM SDW_Prod.dbo.FactAll (nolock) a
	INNER JOIN DimFactType (nolock) b on a.FactTypeID = b.FactTypeID
	INNER JOIN DimAssignment (nolock) d on a.AssignmentID = d.AssignmentID
	WHERE d.AssignmentSubject = 'Attendance' AND b.FactType = 'Assignment'

	UPDATE SDW_Prod.dbo.FactAll 
	set ProgramID = 2
	FROM SDW_Prod.dbo.FactAll (nolock) a
	INNER JOIN DimFactType (nolock) b on a.FactTypeID = b.FactTypeID
	INNER JOIN DimAssignment (nolock) d on a.AssignmentID = d.AssignmentID
	WHERE d.AssignmentSubject = 'ELA/Literacy' AND b.FactType = 'Assignment'

	UPDATE SDW_Prod.dbo.FactAll 
	set ProgramID = 3
	FROM SDW_Prod.dbo.FactAll (nolock) a
	INNER JOIN DimFactType (nolock) b on a.FactTypeID = b.FactTypeID
	INNER JOIN DimAssignment (nolock) d on a.AssignmentID = d.AssignmentID
	WHERE d.AssignmentSubject = 'Math' AND b.FactType = 'Assignment'

	UPDATE SDW_Prod.dbo.FactAll set ProgramID = 4 WHERE ProgramID is null

	UPDATE SDW_Prod.dbo.DimStudent set StudentName_Display = rtrim(StudentLast_Name) + ', ' + rtrim(StudentFirst_Name) WHERE StudentName_Display is null

	UPDATE SDW_Prod.dbo.FactAll
	set Assignment_Grade_Number = Assignment_Grade_Number * 100.0
	FROM SDW_Prod.dbo.FactAll a
	INNER JOIN SDW_Prod.dbo.DimProgram b on a.ProgramID = b.ProgramID
	INNER JOIN SDW_Prod.dbo.DimAssignment c on a.AssignmentID = c.AssignmentID
	WHERE AssignmentType = 'Reporting Period ADA' AND Assignment_Grade_Number <= 1



	/* REMOVED 1-27-2016 BECAUSE SYSTEM OF RECORD COULD NOT BE DETERMINED---------------------------------

	SELECT DISTINCT AccountId, Diplomas_Now_School_Partnership__c
	INTO #DN
	FROM ODW_Stage.dbo.Opportunity_Full (nolock)
	WHERE Diplomas_Now_School_Partnership__c = 1 AND Probability = 100

	*/

	UPDATE SDW_Prod.dbo.DimSchool set Diplomas_Now = 'No'

	UPDATE SDW_Prod.dbo.DimSchool set Diplomas_Now = 'Yes'
	WHERE SchoolName IN (
							'Broadmoor Middle'
							,'Capitol Middle'
							,'English'
							,'McCormack Middle School'
							,'John Hope College Prepatory High School'
							,'Gage Park High School'
							,'Linden McKinley STEM Academy' 
							,'Mifflin High School'
							,'South High School'
							,'Noble Elementary-Middle School'
							,'Detroit Collegiate Preparatory High School @ Northwestern'
							,'Jefferson HS'
							,'Manual Arts High School'
							,'Booker T. Washington HS'
							,'Miami Carol City HS'
							,'Homestead HS'
							,'Georgia Jones-Ayers Middle School'
							,'Newtown High School'
							,'M.S. 126K John Ericsson Middle School'
							,'Dimner Beeber Middle School'
							,'Grover Washington Middle School'
							,'Woodrow Wilson Middle School'
							,'Burbank High School'
							,'Rhodes Middle School (Philadelphia)'
							,'Rhodes Middle School (San Antonio)'
							,'Aki Kurose Middle School'
							,'Denny Middle School'
							,'Clinton Middle School'
							,'Webster High School'
							,'Cardozo Education Campus'
							)


/*
	UPDATE SDW_Prod.dbo.DimSchool set Diplomas_Now = 'Yes'
	FROM SDW_Prod.dbo.DimSchool (nolock) a 
	INNER JOIN #DN (nolock) b on a.CYCh_SF_ID = b.AccountId

*/

	alter index all on SDW_Prod.dbo.DimAssessment REBUILD
	alter index all on SDW_Prod.dbo.DimAssignment REBUILD
	alter index all on SDW_Prod.dbo.DimCorpsMember REBUILD
	alter index all on SDW_Prod.dbo.DimGrade REBUILD
	alter index all on SDW_Prod.dbo.DimIndicatorArea REBUILD
	alter index all on SDW_Prod.dbo.DimProgram REBUILD
	alter index all on SDW_Prod.dbo.DimSchool REBUILD
	alter index all on SDW_Prod.dbo.DimStudent REBUILD

	UPDATE SDW_Prod.dbo.DimAssessment
	set AssessmentType = 'Attendance'
	WHERE AssessmentName like '%Attendance%'

	UPDATE SDW_Prod.dbo.DimAssessment
	set AssessmentType = 'Behavior'
	WHERE AssessmentName like '%Behavior%'

	UPDATE SDW_Prod.dbo.DimAssessment set AssessmentType = 'Other' WHERE AssessmentType is null



/*
	UPDATE SDW_Prod.dbo.DimAssessment
	set ADA = cast(Days_Enrolled as decimal(18,2))- (cast(Number_of_Excused_Absences as decimal(18,2))+ cast(Number_of_Unexcused_Absences as decimal(18,2))) / case cast(Days_Enrolled as decimal(18,2)) when 0 then 1 else cast(Days_Enrolled as decimal(18,2)) end
	WHERE AssessmentType = 'Attendance' AND (Days_Enrolled <> 'N/A' AND Number_of_Excused_Absences <> 'N/A' AND Number_of_Unexcused_Absences <> 'N/A')

	UPDATE SDW_Prod.dbo.DimAssessment set ADA = Lexile_Score WHERE AssessmentName = 'Achieve 3000'
	UPDATE SDW_Prod.dbo.DimAssessment set ADA = Composite_Score_CS WHERE AssessmentName = 'DIBELS (Composite)'
	UPDATE SDW_Prod.dbo.DimAssessment set ADA = RIT_Score WHERE AssessmentName = 'MAP (Measures of Academic Progress)'
	UPDATE SDW_Prod.dbo.DimAssessment set ADA = Lexile_Score WHERE AssessmentName = 'SRI (Scholastic Reading Inventory)'
	UPDATE SDW_Prod.dbo.DimAssessment set ADA = case Grade_Equivalent_GE when 'N/A' then Scaled_Score_SS else Grade_Equivalent_GE end WHERE AssessmentName = 'STAR Reading'
*/
	UPDATE SDW_Prod.dbo.DimAssessment set ADA = 'N/A' WHERE ADA is null

	UPDATE SDW_Prod.dbo.DimAssessment set Frequency = 'Monthly' WHERE Time_Period in ('Apr','Aug','Dec','Feb','Jan','Jul','Jun','Mar','May','Nov','Oct','Sep')
	UPDATE SDW_Prod.dbo.DimAssessment set Frequency = 'Quarterly' WHERE Time_Period in ('Q1','Q2','Q3','Q4')
	UPDATE SDW_Prod.dbo.DimAssessment set Frequency = 'Semester' WHERE Time_Period in ('S1','S2','S3','S4')
	UPDATE SDW_Prod.dbo.DimAssessment set Frequency = 'Trimester' WHERE Time_Period in ('T1','T2','T3','T4')
	UPDATE SDW_Prod.dbo.DimAssessment set Frequency = 'N/A' WHERE Frequency is null
	
	update SDW_Prod.dbo.DimAssessment
	set Classification = 1
	where AssessmentName in ('Achieve 3000 - ELA','Amplify - Math','ANet - ELA', 'ANet - Math', 'BPS Predictive - ELA',
	'BPS Predictive - Math','DESSA','DESSA-mini','DIBELS - ELA','District Benchmark Assessments - ELA','District Benchmark Assessments - Math','DRA - ELA',
	'EADMS - ELA','EADMS - Math','EasyCBM - ELA','EasyCBM - Math','Explore - Math','Explore - Reading','Florida State Assessment Algebra 1 - Math',
	'Florida State Assessment English Language Arts - ELA','Florida State Assessment Mathematics - Math','Fountas and Pinnell Benchmark Assessment System - ELA','iReady - ELA',
	'IRLA - ELA','iStation Indicators of Progress - ELA','Jerry Johns BRI - ELA','Lexia - ELA','NWEA - ELA',
	'NWEA - Math','Scantron - ELA','Scantron - Math','SMI: Scholastic Math Inventory - Math','SRI: Scholastic Reading Inventory - ELA',
	'TRC - ELA','Wonders (McGraw Hill Readers) and Accelerated Reader - ELA','Reporting Period ADA Tracker - Attendance','Cumulative ADA Tracker - Attendance')

	update SDW_Prod.dbo.DimAssessment
	set Classification = 2
	where AssessmentName in ('AIMSweb - ELA','AIMSweb - Math','iReady - Math','STAR Math - Math','STAR Reading - ELA')

	update SDW_Prod.dbo.DimAssessment
	set Classification = 3
	where AssessmentName in ('50 Acts of Greatness - Behavior','50 Acts of Leadership - Behavior','Attendance Check In Check Out - Attendance','SEL Check In Check Out - Behavior')

	update SDW_Prod.dbo.DimAssessment
	set Classification = 5
	where AssessmentName in ('Reporting Period Time Based Attendance Tracker - Attendance',
							 'Reporting Period Time Based Behavior Tracker - Behavior',
							 
							 'Cumulative Time Based Behavior Tracker - Behavior',
							 'Cumulative Time Based Attendance Tracker - Attendance'
							 
							)

	select Student_SF_ID, ISNULL(Student_District_ID, 'N/A') Student_District_ID, max(Student_TTL_IAs_Assigned) Student_TTL_IAs_Assigned
	into #Source_Student
	from SDW_Stage_Prod.dbo.vw_Student_Information (nolock)
	group by Student_SF_ID, ISNULL(Student_District_ID, 'N/A')

	update SDW_Prod.dbo.DimStudent 
	set TTL_IAs_Assigned = b.Student_TTL_IAs_Assigned
	from SDW_Prod.dbo.DimStudent (nolock) a 
	inner join #Source_Student (nolock) b on b.Student_SF_ID = a.StudentSF_ID AND ISNULL(b.Student_District_ID, 'N/A') = a.StudentDistrictID
						 
	truncate table SDW_Prod.dbo.Section_Indicator_Area_Matrix

	insert into SDW_Prod.dbo.Section_Indicator_Area_Matrix(StudentSF_ID, Attendance_IA, Behavior_IA, ELA_IA, Math_IA, Section_IA, CorpsMember_Name, CorpsMember_ID)
	select distinct g.StudentSF_ID, g.Attendance_IA, g.Behavior_IA, g.ELA_IA, g.Math_IA, 
	e.IndicatorArea Section_IA, c.CorpsMember_Name, c.CorpsMember_ID
	from  dbo.FactAll AS a WITH (nolock) 
	INNER JOIN dbo.DimCorpsMember AS c WITH (nolock) ON a.CorpsMemberID = c.CorpsMemberID 
	INNER JOIN dbo.DimIndicatorArea AS e WITH (nolock) ON a.IndicatorAreaID = e.IndicatorAreaID 
	INNER JOIN dbo.DimStudent AS g WITH (nolock) ON a.StudentID = g.StudentID 
	INNER JOIN dbo.DimAssignment AS h WITH (nolock) ON a.AssignmentID = h.AssignmentID 

/*
--	Normalize the Corp Members that tutor in more than one school
	select CorpsMember_Name, max(CorpsMember_ID) CorpsMember_ID
	into #NormalizeCorpMember
	from SDW_Prod.dbo.DimCorpsMember
	group by CorpsMember_Name
	having count(*) > 1

	update SDW_Prod.dbo.DimCorpsMember
	set CorpsMember_ID = b.CorpsMember_ID
	from SDW_Prod.dbo.DimCorpsMember (nolock) a
	inner join #NormalizeCorpMember (nolock) b on a.CorpsMember_Name = b.CorpsMember_Name
*/

	exec SDW_Prod.dbo.sp_Load_Mart_School_Region_Update
	exec SDW_Prod.dbo.sp_Load_Mart_Assessment_Indicator_Area
	exec SDW_Prod.dbo.sp_Load_Mart_Assessments_Data_Type_Display
	exec SDW_Prod.dbo.sp_Load_Mart_Assignment_Frequency

END






























GO
