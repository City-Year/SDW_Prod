USE [SDW_Prod]
GO
/****** Object:  Table [dbo].[FactAll]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactAll](
	[FactID] [int] IDENTITY(1,1) NOT NULL,
	[AssignmentID] [int] NOT NULL,
	[AssessmentID] [int] NOT NULL,
	[CorpsMemberID] [int] NOT NULL,
	[DateID] [int] NOT NULL,
	[GradeID] [int] NOT NULL,
	[IndicatorAreaID] [int] NOT NULL,
	[SchoolID] [int] NOT NULL,
	[StudentID] [int] NOT NULL,
	[FactTypeID] [int] NOT NULL,
	[ProgramID] [int] NULL,
	[Assignment_Entered_Grade] [varchar](10) NULL,
	[Assignment_Grade_Number] [decimal](15, 2) NULL,
	[Grade_Name] [varchar](50) NULL,
	[Assignment_Weighted_Grade_Value] [decimal](15, 2) NULL,
	[Session_Dosage] [int] NOT NULL,
	[Source_Session_Key] [varchar](255) NULL,
	[PrimaryCorpsMemberID] [int] NULL
) ON [PRIMARY]

GO
