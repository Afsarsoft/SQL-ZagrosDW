EXEC ZagrosDW.DropFKs;

TRUNCATE TABLE ZagrosDW.FactSales;
GO
TRUNCATE TABLE ZagrosDW.DimLocation;
GO
TRUNCATE TABLE ZagrosDW.DimPackage;
GO
TRUNCATE TABLE ZagrosDW.DimOrderStatus;
GO
TRUNCATE TABLE ZagrosDW.DimCustomer;
GO
