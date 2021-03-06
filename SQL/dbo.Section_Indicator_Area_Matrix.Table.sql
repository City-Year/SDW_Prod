USE [SDW_Prod]
GO
/****** Object:  Table [dbo].[Section_Indicator_Area_Matrix]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Section_Indicator_Area_Matrix](
	[StudentSF_ID] [varchar](18) NULL,
	[Attendance_IA] [varchar](250) NULL,
	[Behavior_IA] [varchar](250) NULL,
	[ELA_IA] [varchar](250) NULL,
	[Math_IA] [varchar](250) NULL,
	[Section_IA] [varchar](255) NULL,
	[CorpsMember_Name] [varchar](255) NOT NULL,
	[CorpsMember_ID] [varchar](255) NULL
) ON [PRIMARY]

GO
