USE [SDW_Prod]
GO
/****** Object:  Table [dbo].[DimSchool]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimSchool](
	[SchoolID] [int] IDENTITY(1,1) NOT NULL,
	[SchoolName] [varchar](255) NOT NULL,
	[Business_Unit] [varchar](250) NULL,
	[Region] [varchar](250) NULL,
	[District] [varchar](250) NULL,
	[Team] [varchar](250) NULL,
	[TeamDescription] [varchar](250) NULL,
	[Number_Of_Teams] [varchar](250) NULL,
	[CYSch_SF_ID] [varchar](250) NULL,
	[CYCh_SF_ID] [varchar](250) NULL,
	[CYCh_Account_#] [varchar](250) NULL,
	[Diplomas_Now] [varchar](250) NULL,
PRIMARY KEY CLUSTERED 
(
	[SchoolID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
