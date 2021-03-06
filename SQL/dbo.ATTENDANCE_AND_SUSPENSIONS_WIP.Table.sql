USE [SDW_Prod]
GO
/****** Object:  Table [dbo].[ATTENDANCE_AND_SUSPENSIONS_WIP]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ATTENDANCE_AND_SUSPENSIONS_WIP](
	[student_sf_id] [varchar](250) NULL,
	[cych_Accnt_SF_ID] [varchar](250) NULL,
	[Student] [varchar](250) NULL,
	[Intervention_Corps_Member] [varchar](250) NULL,
	[Intervention_Corps_Member_ID] [varchar](250) NULL,
	[Assessment_Name] [varchar](250) NULL,
	[Average_Daily_Attendance] [varchar](250) NULL,
	[Number_of_Suspensions] [varchar](250) NULL,
	[Number_of_Detentions] [varchar](250) NULL,
	[Number_of_Office_Referrals] [varchar](250) NULL,
	[Quarter] [varchar](250) NULL,
	[Date_Administered] [varchar](250) NULL,
	[cysch_accnt_sf_id] [varchar](250) NULL,
	[Suspension_Ind] [int] NULL,
	[DETENTION_IND] [int] NULL,
	[OFFICEREFERRAL_IND] [int] NULL
) ON [PRIMARY]

GO
