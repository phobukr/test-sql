CREATE PROCEDURE GetDisplayOptions
    @order_id INT,
    @XmlData XML
AS
BEGIN
    SET NOCOUNT ON;
    SET IMPLICIT_TRANSACTIONS OFF;
    DECLARE @hDoc INT;
    EXEC sp_xml_preparedocument @hDoc OUTPUT, @XmlData;

    CREATE TABLE #TempItems (
        OrderId INT NULL,
        ItemId INT,
        Quantity INT,
        Price DECIMAL(18,2),
        CustomerSegment NVARCHAR(255) NULL,
        RegionName NVARCHAR(255) NULL,
        ProductCategory NVARCHAR(255) NULL,
        SalesAmount DECIMAL(18,2) NULL,
        TaxRate DECIMAL(5,2) NULL,
        StockLevel INT NULL,
        ShippingCost DECIMAL(18,2) NULL,
        WarehouseCapacity INT NULL,
        EmployeePerformance INT NULL,
        LogisticsEfficiency DECIMAL(5,2) NULL,
        SupplierRating DECIMAL(5,2) NULL,
        ITSecurityRating DECIMAL(5,2) NULL,
        RefundAmount DECIMAL(18,2) NULL,
        QualityAssuranceScore DECIMAL(5,2) NULL,
        PromotionDiscount DECIMAL(5,2) NULL,
        FinancialStabilityIndex DECIMAL(5,2) NULL,
        RiskCategory NVARCHAR(50) NULL,
        EcoSustainabilityIndex DECIMAL(5,2) NULL
    );


    -- Insert data from XML
    INSERT INTO #TempItems (OrderId, CustomerSegment, RegionName, ProductCategory, SalesAmount, TaxRate, StockLevel,
                            ShippingCost, WarehouseCapacity, EmployeePerformance, LogisticsEfficiency, SupplierRating,
                            ITSecurityRating, RefundAmount, QualityAssuranceScore, PromotionDiscount,
                            FinancialStabilityIndex, RiskCategory, EcoSustainabilityIndex)
    SELECT
        @order_id,
        x.CustomerSegment,
        x.RegionName,
        x.ProductCategory,
        x.SalesAmount,
        x.TaxRate,
        x.StockLevel,
        x.ShippingCost,
        x.WarehouseCapacity,
        x.EmployeePerformance,
        x.LogisticsEfficiency,
        x.SupplierRating,
        x.ITSecurityRating,
        x.RefundAmount,
        x.QualityAssuranceScore,
        x.PromotionDiscount,
        x.FinancialStabilityIndex,
        x.RiskCategory,
        x.EcoSustainabilityIndex
    FROM OPENXML(@hDoc, '/Filters/Filter', 2)
    WITH (
        CustomerSegment NVARCHAR(255),
        RegionName NVARCHAR(255),
        ProductCategory NVARCHAR(255),
        SalesAmount DECIMAL(18,2),
        TaxRate DECIMAL(5,2),
        StockLevel INT,
        ShippingCost DECIMAL(18,2),
        WarehouseCapacity INT,
        EmployeePerformance INT,
        LogisticsEfficiency DECIMAL(5,2),
        SupplierRating DECIMAL(5,2),
        ITSecurityRating DECIMAL(5,2),
        RefundAmount DECIMAL(18,2),
        QualityAssuranceScore DECIMAL(5,2),
        PromotionDiscount DECIMAL(5,2),
        FinancialStabilityIndex DECIMAL(5,2),
        RiskCategory NVARCHAR(50),
        EcoSustainabilityIndex DECIMAL(5,2)
    ) AS x;

    EXEC sp_xml_removedocument @hDoc;

    BEGIN TRY
        SELECT di.*
        FROM #TempItems ti
        JOIN CustomConfig cc ON ti.OrderId = cc.order_id
        JOIN DisplayOptions di ON cc.config_id = di.config_id
        WHERE cc.module = 'SALES'
        UNION
        SELECT di.*
        FROM #TempItems ti
        JOIN LegacyConfig cc ON ti.OrderId = cc.order_id
        JOIN DisplayOptions di ON cc.config_id = di.config_id
        WHERE cc.module = 'MARKETING_DATA';

        DROP TABlE #TempItems;

    END TRY
    BEGIN CATCH
        -- Rollback in case of error
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        -- Return error message
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT @ErrorMessage = ERROR_MESSAGE(),
               @ErrorSeverity = ERROR_SEVERITY(),
               @ErrorState = ERROR_STATE();

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
