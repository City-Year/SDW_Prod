USE [SDW_Prod]
GO
/****** Object:  Table [dbo].[z]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[z](
	[CYSCHOOLHOUSE_STUDENT_ID] [varchar](30) NULL,
	[STUDENT_NAME] [varchar](80) NULL,
	[SITE_NAME] [varchar](250) NULL,
	[SCHOOL_NAME] [varchar](255) NOT NULL,
	[GRADE] [varchar](150) NULL,
	[DIPLOMAS_NOW_SCHOOL] [int] NOT NULL,
	[INTERVAL] [varchar](255) NULL,
	[SKILL_ID] [int] NULL,
	[SKILL_DESCRIPTION] [varchar](250) NULL,
	[DATA_TYPE] [varchar](250) NULL,
	[DATA_TYPE_2] [varchar](250) NULL,
	[DATA_TYPE_3] [varchar](250) NULL,
	[DATA_TYPE_4] [varchar](250) NULL,
	[DATA_TYPE_5] [varchar](250) NULL,
	[SCORE] [varchar](50) NULL,
	[SCORE_2] [varchar](250) NULL,
	[SCORE_3] [varchar](250) NULL,
	[SCORE_4] [varchar](250) NULL,
	[SCORE_5] [varchar](250) NULL,
	[INDICATOR_DESC] [int] NULL,
	[ASSESSMENT_DATE] [datetime] NOT NULL,
	[PERFORMANCE_VALUE] [int] NULL,
	[TARGET_SCORE] [int] NULL,
	[ALPHA_TARGET_SCORE_RANK] [int] NULL,
	[ALPHA_TARGET_SCORE_RANK_NORM] [int] NULL,
	[TESTING_GRADE_LEVEL] [int] NULL,
	[SCORE_RANK] [int] NULL,
	[SCORE_RANK_NORM] [int] NULL,
	[SCALE_LOCAL] [int] NULL,
	[SCALE_NORM] [int] NULL,
	[SCALE_NUM_LOCAL] [int] NULL,
	[SCALE_NUM_NORM] [int] NULL,
	[TAG] [varchar](10) NOT NULL,
	[USED_AS_MID_YEAR_DATA_POINT] [int] NULL,
	[USED_FOR_SUMMATIVE_REPORTING] [int] NULL,
	[FISCAL_YEAR] [varchar](255) NULL,
	[CYSCHOOLHOUSE_SCHOOL_ID] [varchar](250) NULL,
	[SCHOOL_ID] [int] NOT NULL,
	[SITE_ID] [int] NULL,
	[CREATED_BY] [varchar](250) NULL,
	[ENTRY_DATE] [date] NULL,
	[LAST_REFRESH] [datetime] NOT NULL,
	[ASSESSMENTID] [int] NOT NULL
) ON [PRIMARY]

GO
