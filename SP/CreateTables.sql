CREATE OR ALTER PROCEDURE ZagrosDW.CreateTables
AS
/***************************************************************************************************
File: CreateTables.sql
----------------------------------------------------------------------------------------------------
Procedure:      ZagrosDW.CreateTables
Create Date:    2021-03-01 (yyyy-mm-dd)
Author:         Surush Cyrus
Description:    Creates all needed ZagrosDW tables  
Call by:        TBD, UI, Add hoc
Steps:          NA
Parameter(s):   None
Usage:          EXEC ZagrosDW.CreateTables
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
SET @ErrorText = 'Failed CREATE Table ZagrosDW.DimTime.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'ZagrosDW.DimTime') AND type in (N'U'))
BEGIN
    SET @Message = 'Table ZagrosDW.DimTime already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
    CREATE TABLE ZagrosDW.DimTime
    (
        TimeKey int IDENTITY (1, 1) NOT NULL ,
        -- ActualDate datetime NOT NULL ,
        ActualDate DATE NOT NULL ,
        Year int NOT NULL ,
        Quarter int NOT NULL ,
        Month int NOT NULL ,
        Week int NOT NULL ,
        DayofYear int NOT NULL ,
        DayofMonth int NOT NULL ,
        DayofWeek int NOT NULL ,
        IsWeekend bit NOT NULL ,
        Comments varchar(20) NULL ,
        CalendarWeek int NOT NULL ,
        BusinessYearWeek int NOT NULL ,
        LeapYear tinyint NOT NULL,
        CONSTRAINT PK_DimTime_TimeKey PRIMARY KEY CLUSTERED (TimeKey)
    );
    SET @Message = 'Completed CREATE TABLE ZagrosDW.DimTime.';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table ZagrosDW.DimLocation.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'ZagrosDW.DimLocation') AND type in (N'U'))
BEGIN
    SET @Message = 'Table ZagrosDW.DimLocation already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
    CREATE TABLE ZagrosDW.DimLocation
    (
        LocationID TINYINT NOT NULL,
        Name NVARCHAR(50) NOT NULL,
        CONSTRAINT PK_DimLocation_LocationID PRIMARY KEY CLUSTERED (LocationID),
        CONSTRAINT UK_DimLocation_Name UNIQUE (Name)
    );

    SET @Message = 'Completed CREATE TABLE ZagrosDW.DimLocation.';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table ZagrosDW.DimPackage.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'ZagrosDW.DimPackage') AND type in (N'U'))
BEGIN
    SET @Message = 'Table ZagrosDW.DimPackage already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
    CREATE TABLE ZagrosDW.DimPackage
    (
        PackageID TINYINT NOT NULL,
        Name NVARCHAR(50) NOT NULL,
        CONSTRAINT PK_DimPackage_PackageID PRIMARY KEY CLUSTERED (PackageID),
        CONSTRAINT UK_DimPackage_Name UNIQUE (Name)
    );

    SET @Message = 'Completed CREATE TABLE ZagrosDW.DimPackage.';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table ZagrosDW.DimOrderStatus.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'ZagrosDW.DimOrderStatus') AND type in (N'U'))
BEGIN
    SET @Message = 'Table ZagrosDW.DimOrderStatus already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
    CREATE TABLE ZagrosDW.DimOrderStatus
    (
        OrderStatusID TINYINT NOT NULL,
        Name NVARCHAR(50) NOT NULL,
        CONSTRAINT PK_DimOrderStatus_OrderStatusID PRIMARY KEY CLUSTERED (OrderStatusID),
        CONSTRAINT UK_DimOrderStatus_Name UNIQUE (Name)
    );

    SET @Message = 'Completed CREATE TABLE ZagrosDW.DimOrderStatus.';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table ZagrosDW.DimCustomer.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'ZagrosDW.DimCustomer') AND type in (N'U'))
BEGIN
    SET @Message = 'Table ZagrosDW.DimCustomer already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
    CREATE TABLE ZagrosDW.DimCustomer
    (
        CustomerID TINYINT NOT NULL,
        Email NVARCHAR(50) NOT NULL,
        FirstName NVARCHAR(50) NOT NULL,
        LastName NVARCHAR(50) NOT NULL,
        Country NVARCHAR(50) NOT NULL,
        CONSTRAINT PK_DimCustomer_CustomerID PRIMARY KEY CLUSTERED (CustomerID),
        CONSTRAINT UK_Customer_Email UNIQUE (Email)
    );

    SET @Message = 'Completed CREATE TABLE ZagrosDW.DimCustomer.';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
SET @ErrorText = 'Failed CREATE Table ZagrosDW.FactSales.';

IF EXISTS (SELECT *
FROM sys.objects
WHERE object_id = OBJECT_ID(N'ZagrosDW.FactSales') AND type in (N'U'))
BEGIN
    SET @Message = 'Table ZagrosDW.FactSales already exist, skipping....';
    RAISERROR(@Message, 0,1) WITH NOWAIT;
END
ELSE
BEGIN
    CREATE TABLE ZagrosDW.FactSales
    (
        OrderID INT NOT NULL,
        LocationID TINYINT NOT NULL,
        PackageID TINYINT NOT NULL,
        CustomerID INT NOT NULL,
        OrderStatusID TINYINT NOT NULL,
        TimeKey INT NOT NULL,
        OrderDate DATETIME NOT NULL,
        FinalDate DATETIME NULL,
        UnitPrice MONEY NOT NULL,
        Quantity TINYINT NOT NULL,
        CONSTRAINT PK_FactSales_OrderID_LocationID_PackageID PRIMARY KEY CLUSTERED (OrderID, LocationID, PackageID)
    );

    SET @Message = 'Completed CREATE TABLE ZagrosDW.FactSales.';
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

