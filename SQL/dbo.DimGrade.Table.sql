USE [SDW_Prod]
GO
/****** Object:  Table [dbo].[DimGrade]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimGrade](
	[GradeID] [int] IDENTITY(1,1) NOT NULL,
	[SchoolYear] [varchar](255) NULL,
	[MarkingPeriod] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[GradeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
