USE [SDW_Prod]
GO
/****** Object:  Table [dbo].[DimStudent]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimStudent](
	[StudentID] [int] IDENTITY(1,1) NOT NULL,
	[CY_StudentID] [varchar](30) NULL,
	[StudentDistrictID] [varchar](100) NULL,
	[StudentSF_ID] [varchar](18) NULL,
	[StudentName] [varchar](80) NULL,
	[StudentFirst_Name] [varchar](100) NULL,
	[StudentLast_Name] [varchar](100) NULL,
	[DateOfBirth] [datetime] NULL,
	[Gender] [varchar](255) NULL,
	[StudentName_Display] [varchar](250) NULL,
	[Enrollment_Date] [date] NULL,
	[Enrollment_End_Date] [date] NULL,
	[Attendance_IA] [varchar](250) NULL,
	[Behavior_IA] [varchar](250) NULL,
	[ELA_IA] [varchar](250) NULL,
	[Math_IA] [varchar](250) NULL,
	[Grade] [varchar](150) NULL,
	[ELL] [varchar](250) NULL,
	[Ethnicity] [varchar](250) NULL,
	[TTL_IAs_Assigned] [varchar](250) NULL,
PRIMARY KEY CLUSTERED 
(
	[StudentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
