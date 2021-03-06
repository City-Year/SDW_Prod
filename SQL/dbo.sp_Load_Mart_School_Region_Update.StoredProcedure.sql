USE [SDW_Prod]
GO
/****** Object:  StoredProcedure [dbo].[sp_Load_Mart_School_Region_Update]    Script Date: 12/1/2016 8:51:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Load_Mart_School_Region_Update]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Careforce' WHERE Business_Unit = 'Careforce'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Headquarters' WHERE Business_Unit = 'Headquarters'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Headquarters' WHERE Business_Unit = 'Baltimore'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Central' WHERE Business_Unit = 'Dallas'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Midwest' WHERE Business_Unit = 'Kansas City'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Headquarters' WHERE Business_Unit = 'Las Vegas'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'South' WHERE Business_Unit = 'Jacksonville'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'South' WHERE Business_Unit = 'Miami'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'South' WHERE Business_Unit = 'Orlando'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Midwest' WHERE Business_Unit = 'Chicago'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Midwest' WHERE Business_Unit = 'Cleveland'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Midwest' WHERE Business_Unit = 'Columbus'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Midwest' WHERE Business_Unit = 'Detroit'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Midwest' WHERE Business_Unit = 'Milwaukee'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'East' WHERE Business_Unit = 'Boston'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'East' WHERE Business_Unit = 'New Hampshire'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'East' WHERE Business_Unit = 'New York'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'East' WHERE Business_Unit = 'Philadelphia'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'East' WHERE Business_Unit = 'Providence'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'East' WHERE Business_Unit = 'Rhode Island'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'East' WHERE Business_Unit = 'Washington, DC'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Central' WHERE Business_Unit = 'Baton Rouge'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'South' WHERE Business_Unit = 'Columbia'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'South' WHERE Business_Unit = 'Little Rock'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Central' WHERE Business_Unit = 'New Orleans'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Central' WHERE Business_Unit = 'San Antonio'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Central' WHERE Business_Unit = 'Tulsa'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Central' WHERE Business_Unit = 'Denver'

	UPDATE SDW_Prod.dbo.DimSchool set Region = 'West' WHERE Business_Unit = 'Los Angeles'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'West' WHERE Business_Unit = 'Sacramento'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'West' WHERE Business_Unit = 'San Jose'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'West' WHERE Business_Unit = 'Seattle'

/* OLD 
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Careforce' WHERE Business_Unit = 'Careforce'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Headquarters' WHERE Business_Unit = 'Headquarters'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Headquarters' WHERE Business_Unit = 'Baltimore'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Headquarters' WHERE Business_Unit = 'Dallas'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Headquarters' WHERE Business_Unit = 'Kansas City'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Headquarters' WHERE Business_Unit = 'Las Vegas'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Florida' WHERE Business_Unit = 'Jacksonville'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Florida' WHERE Business_Unit = 'Miami'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Florida' WHERE Business_Unit = 'Orlando'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Midwest' WHERE Business_Unit = 'Chicago'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Midwest' WHERE Business_Unit = 'Cleveland'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Midwest' WHERE Business_Unit = 'Columbus'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Midwest' WHERE Business_Unit = 'Detroit'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Midwest' WHERE Business_Unit = 'Milwaukee'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Northeast' WHERE Business_Unit = 'Boston'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Northeast' WHERE Business_Unit = 'Manchester'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Northeast' WHERE Business_Unit = 'New York'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Northeast' WHERE Business_Unit = 'Philadelphia'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Northeast' WHERE Business_Unit = 'Providence'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'Northeast' WHERE Business_Unit = 'Washington, DC'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'South' WHERE Business_Unit = 'Baton Rouge'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'South' WHERE Business_Unit = 'Columbia'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'South' WHERE Business_Unit = 'Little Rock'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'South' WHERE Business_Unit = 'New Orleans'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'South' WHERE Business_Unit = 'San Antonio'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'South' WHERE Business_Unit = 'Tulsa'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'West' WHERE Business_Unit = 'Denver'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'West' WHERE Business_Unit = 'Los Angeles'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'West' WHERE Business_Unit = 'Sacramento'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'West' WHERE Business_Unit = 'San Jose'
	UPDATE SDW_Prod.dbo.DimSchool set Region = 'West' WHERE Business_Unit = 'Seattle'

	*/
END




GO
