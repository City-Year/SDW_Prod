USE [SDW_Prod]
GO
/****** Object:  Table [dbo].[SJ_SPM]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SJ_SPM](
	[ACM_Name] [varchar](250) NULL,
	[Student_ID] [varchar](250) NULL,
	[Student_Name] [varchar](250) NULL,
	[Student_Grade] [varchar](50) NULL,
	[In_Target_Population] [varchar](50) NULL,
	[ELA_Math] [varchar](50) NULL,
	[Score] [varchar](50) NULL,
	[ELA_Math_On_Track] [varchar](50) NULL,
	[Att_SEL] [varchar](50) NULL,
	[Att_SEL_On_Track] [varchar](50) NULL,
	[Dosage_YTD] [varchar](50) NULL,
	[Dosage_Current_Cycle] [varchar](50) NULL,
	[Absence_Rate] [varchar](50) NULL,
	[Number_Of_Suspensions] [varchar](50) NULL
) ON [PRIMARY]

GO
