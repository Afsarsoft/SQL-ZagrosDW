CREATE OR ALTER PROCEDURE ZagrosDW.CreateFKs
AS
/***************************************************************************************************
File: CreateFKs.sql
----------------------------------------------------------------------------------------------------
Procedure:      ZagrosDW.CreateFKs
Create Date:    2021-03-01 (yyyy-mm-dd)
Author:         Surush Cyrus
Description:    Creates FKs for all needed ZagrosDW tables  
Call by:        TBD, UI, Add hoc
Steps:          NA
Parameter(s):   None
Usage:          EXEC ZagrosDW.CreateFKs
****************************************************************************************************
SUMMARY OF CHANGES
Date(yyyy-mm-dd)    Author              Comments
------------------- ------------------- ------------------------------------------------------------
****************************************************************************************************/
SET NOCOUNT ON;

DECLARE @ErrorText VARCHAR(MAX),      
        @Message   VARCHAR(255),   
        @StartTime DATETIME,
        @SP        VARCHAR(50)

BEGIN TRY;   
SET @ErrorText = 'Unexpected ERROR in setting the variables!';

SET @SP = OBJECT_NAME(@@PROCID)
SET @StartTime = GETDATE();
   
SET @Message = 'Started SP ' + @SP + ' at ' + FORMAT(@StartTime , 'MM/dd/yyyy HH:mm:ss');   
RAISERROR (@Message, 0,1) WITH NOWAIT;

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed adding FOREIGN KEY for Table ZagrosDW.FactSales.';

IF EXISTS (SELECT *
FROM sys.foreign_keys
WHERE object_id = OBJECT_ID(N'ZagrosDW_FK_FactSales_DimPackage_PackageID')
  AND parent_object_id = OBJECT_ID(N'ZagrosDW.FactSales')
)
BEGIN
  SET @Message = 'FOREIGN KEY for Table ZagrosDW.FactSales already exist, skipping....';
  RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
  ALTER TABLE ZagrosDW.FactSales
   ADD CONSTRAINT ZagrosDW_FK_FactSales_DimPackage_PackageID FOREIGN KEY (PackageID)
      REFERENCES ZagrosDW.DimPackage (PackageID),
    CONSTRAINT ZagrosDW_FK_FactSales_DimLocation_LocationID FOREIGN KEY (LocationID)
      REFERENCES ZagrosDW.DimLocation (LocationID),
    CONSTRAINT ZagrosDW_FK_FactSales_DimOrderStatus_OrderStatusID FOREIGN KEY (OrderStatusID)
      REFERENCES ZagrosDW.DimOrderStatus (OrderStatusID),
    CONSTRAINT ZagrosDW_FK_FactSales_DimCustomer_OrderStatusID FOREIGN KEY (CustomerID)
      REFERENCES ZagrosDW.DimCustomer (CustomerID),
          CONSTRAINT ZagrosDW_FK_FactSales_DimTime_TimeKey FOREIGN KEY (TimeKey)
      REFERENCES ZagrosDW.DimTime (TimeKey);

  SET @Message = 'Completed adding FOREIGN KEY for TABLE ZagrosDW.FactSales.';
  RAISERROR(@Message, 0,1) WITH NOWAIT;
END
-------------------------------------------------------------------------------

SET @Message = 'Completed SP ' + @SP + '. Duration in minutes:  '   
   + CONVERT(VARCHAR(12), CONVERT(DECIMAL(6,2),datediff(mi, @StartTime, getdate())));    
RAISERROR(@Message, 0,1) WITH NOWAIT;

END TRY

BEGIN CATCH;
IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

SET @ErrorText = 'Error: '+CONVERT(VARCHAR,ISNULL(ERROR_NUMBER(),'NULL'))      
                  +', Severity = '+CONVERT(VARCHAR,ISNULL(ERROR_SEVERITY(),'NULL'))      
                  +', State = '+CONVERT(VARCHAR,ISNULL(ERROR_STATE(),'NULL'))      
                  +', Line = '+CONVERT(VARCHAR,ISNULL(ERROR_LINE(),'NULL'))      
                  +', Procedure = '+CONVERT(VARCHAR,ISNULL(ERROR_PROCEDURE(),'NULL'))      
                  +', Server Error Message = '+CONVERT(VARCHAR(100),ISNULL(ERROR_MESSAGE(),'NULL'))      
                  +', SP Defined Error Text = '+@ErrorText;

RAISERROR(@ErrorText,18,127) WITH NOWAIT;
END CATCH;      

