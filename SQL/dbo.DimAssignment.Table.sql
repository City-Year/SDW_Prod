USE [SDW_Prod]
GO
/****** Object:  Table [dbo].[DimAssignment]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimAssignment](
	[AssignmentID] [int] IDENTITY(1,1) NOT NULL,
	[AssignmentName] [varchar](80) NULL,
	[StandardName] [varchar](250) NULL,
	[AssignmentSubject] [varchar](80) NULL,
	[AssignmentType] [varchar](80) NOT NULL,
	[SectionName] [varchar](250) NOT NULL,
	[ProgramDescription] [varchar](250) NULL,
	[Frequency] [varchar](250) NULL,
	[Create_By] [varchar](250) NULL,
	[Entry_Date] [varchar](250) NULL,
PRIMARY KEY CLUSTERED 
(
	[AssignmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
