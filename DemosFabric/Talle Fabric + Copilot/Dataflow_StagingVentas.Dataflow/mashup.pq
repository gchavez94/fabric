[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "StagingVentas_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "Source.Name", DestinationColumnName = "Source.Name"], [SourceColumnName = "VENTA_ID", DestinationColumnName = "VENTA_ID"], [SourceColumnName = "FECHA", DestinationColumnName = "FECHA"], [SourceColumnName = "SUCURSAL_CLIENTE", DestinationColumnName = "SUCURSAL_CLIENTE"], [SourceColumnName = "ARTICULO", DestinationColumnName = "ARTICULO"], [SourceColumnName = "CANTIDAD", DestinationColumnName = "CANTIDAD"], [SourceColumnName = "SUBTOTAL", DestinationColumnName = "SUBTOTAL"], [SourceColumnName = "IVA", DestinationColumnName = "IVA"], [SourceColumnName = "VENDEDOR", DestinationColumnName = "VENDEDOR"]}], DynamicSchema = false, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared StagingVentasMayoreo = let
  Origen = SharePoint.Files("https://gcgcia.sharepoint.com/sites/EquipoVentas", [ApiVersion = 15]),
  #"Filas filtradas" = Table.SelectRows(Origen, each ([Name] = "Ventas_y_Catalogos.xlsx")),
  #"Archivos ocultos filtrados" = Table.SelectRows(#"Filas filtradas", each [Attributes]?[Hidden]? <> true),
  #"Invocar función personalizada" = Table.AddColumn(#"Archivos ocultos filtrados", "Transformar archivo", each #"Transformar archivo"([Content])),
  #"Columnas con nombre cambiado" = Table.RenameColumns(#"Invocar función personalizada", {{"Name", "Source.Name"}}),
  #"Se han quitado otras columnas." = Table.SelectColumns(#"Columnas con nombre cambiado", {"Source.Name", "Transformar archivo"}),
  #"Columna de tabla expandida" = Table.ExpandTableColumn(#"Se han quitado otras columnas.", "Transformar archivo", Table.ColumnNames(#"Transformar archivo"(#"Archivo de ejemplo"))),
  #"Tipo de columna cambiado" = Table.TransformColumnTypes(#"Columna de tabla expandida", {{"VENTA_ID", Int64.Type}, {"FECHA", type date}, {"SUCURSAL_CLIENTE", Int64.Type}, {"ARTICULO", Int64.Type}, {"CANTIDAD", Int64.Type}, {"SUBTOTAL", Int64.Type}, {"IVA", type number}, {"VENDEDOR", Int64.Type}})
in
  #"Tipo de columna cambiado";
shared #"Archivo de ejemplo" = let
  Origen = SharePoint.Files("https://gcgcia.sharepoint.com/sites/EquipoVentas", [ApiVersion = 15]),
  #"Filas filtradas" = Table.SelectRows(Origen, each [Name] = "Ventas_y_Catalogos.xlsx"),
  #"Archivos ocultos filtrados" = Table.SelectRows(#"Filas filtradas", each [Attributes]?[Hidden]? <> true),
  Navegación = #"Archivos ocultos filtrados"{0}[Content]
in
  Navegación;
shared Parámetro = let
  Parámetro = #"Archivo de ejemplo" meta [IsParameterQuery = true, IsParameterQueryRequired = false, Type = type binary, BinaryIdentifier = #"Archivo de ejemplo"]
in
  Parámetro;
shared #"Transformar Archivo de ejemplo" = let
  Origen = Excel.Workbook(Parámetro, null, true),
  Navigation = Origen{[Item = "Ventas_Mayoreo", Kind = "Sheet"]}[Data],
  #"Encabezados promovidos" = Table.PromoteHeaders(Navigation, [PromoteAllScalars = true])
in
  #"Encabezados promovidos";
[FunctionQueryBinding = "{""exemplarFormulaName"":""Transformar Archivo de ejemplo""}"]
shared #"Transformar archivo" = (Parámetro as binary) => let
  Origen = Excel.Workbook(Parámetro, null, true),
  Navigation = Origen{[Item = "Ventas_Mayoreo", Kind = "Sheet"]}[Data],
  #"Encabezados promovidos" = Table.PromoteHeaders(Navigation, [PromoteAllScalars = true])
in
  #"Encabezados promovidos";
shared StagingVentas_DataDestination = let
  Pattern = Fabric.Warehouse([HierarchicalNavigation = null, CreateNavigationProperties = false]),
  Navigation_1 = Pattern{[workspaceId = "5bb3a27e-bc84-41d2-bf55-296bb6efc7a4"]}[Data],
  Navigation_2 = Navigation_1{[warehouseId = "99814535-6e61-45dc-9ea7-69d1651f5c8a"]}[Data],
  TableNavigation = Navigation_2{[Item = "StagingVentas", Schema = "dbo"]}?[Data]?
in
  TableNavigation;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "StagingVentasMenudeo_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "Source.Name", DestinationColumnName = "Source.Name"], [SourceColumnName = "VENTA_ID", DestinationColumnName = "VENTA_ID"], [SourceColumnName = "FECHA", DestinationColumnName = "FECHA"], [SourceColumnName = "SUCURSAL_CLIENTE", DestinationColumnName = "SUCURSAL_CLIENTE"], [SourceColumnName = "ARTICULO", DestinationColumnName = "ARTICULO"], [SourceColumnName = "CANTIDAD", DestinationColumnName = "CANTIDAD"], [SourceColumnName = "SUBTOTAL", DestinationColumnName = "SUBTOTAL"], [SourceColumnName = "IVA", DestinationColumnName = "IVA"], [SourceColumnName = "VENDEDOR", DestinationColumnName = "VENDEDOR"]}], DynamicSchema = false, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared StagingVentasMenudeo = let
  Origen = SharePoint.Files("https://gcgcia.sharepoint.com/sites/EquipoVentas", [ApiVersion = 15]),
  #"Filas filtradas" = Table.SelectRows(Origen, each ([Name] = "Ventas_Menudeo.csv")),
  #"Archivos ocultos filtrados" = Table.SelectRows(#"Filas filtradas", each [Attributes]?[Hidden]? <> true),
  #"Invocar función personalizada" = Table.AddColumn(#"Archivos ocultos filtrados", "Transformar archivo (2)", each #"Transformar archivo (2)"([Content])),
  #"Columnas con nombre cambiado" = Table.RenameColumns(#"Invocar función personalizada", {{"Name", "Source.Name"}}),
  #"Se han quitado otras columnas." = Table.SelectColumns(#"Columnas con nombre cambiado", {"Source.Name", "Transformar archivo (2)"}),
  #"Columna de tabla expandida" = Table.ExpandTableColumn(#"Se han quitado otras columnas.", "Transformar archivo (2)", Table.ColumnNames(#"Transformar archivo (2)"(#"Archivo de ejemplo (2)"))),
  #"Tipo de columna cambiado" = Table.TransformColumnTypes(#"Columna de tabla expandida", {{"VENTA_ID", Int64.Type}, {"FECHA", type date}, {"SUCURSAL_CLIENTE", Int64.Type}, {"ARTICULO", Int64.Type}, {"CANTIDAD", Int64.Type}, {"SUBTOTAL", Int64.Type}, {"IVA", Int64.Type}, {"VENDEDOR", Int64.Type}})
in
  #"Tipo de columna cambiado";
shared #"Archivo de ejemplo (2)" = let
  Origen = SharePoint.Files("https://gcgcia.sharepoint.com/sites/EquipoVentas", [ApiVersion = 15]),
  #"Filas filtradas" = Table.SelectRows(Origen, each [Name] = "Ventas_Menudeo.csv"),
  #"Archivos ocultos filtrados" = Table.SelectRows(#"Filas filtradas", each [Attributes]?[Hidden]? <> true),
  Navegación = #"Archivos ocultos filtrados"{0}[Content]
in
  Navegación;
shared #"Parámetro (2)" = let
  #"Parámetro (2)" = #"Archivo de ejemplo (2)" meta [IsParameterQuery = true, IsParameterQueryRequired = false, Type = type binary, BinaryIdentifier = #"Archivo de ejemplo (2)"]
in
  #"Parámetro (2)";
shared #"Transformar Archivo de ejemplo (2)" = let
  Origen = Csv.Document(#"Parámetro (2)", [Delimiter = ",", Columns = 8, QuoteStyle = QuoteStyle.None]),
  #"Encabezados promovidos" = Table.PromoteHeaders(Origen, [PromoteAllScalars = true])
in
  #"Encabezados promovidos";
[FunctionQueryBinding = "{""exemplarFormulaName"":""Transformar Archivo de ejemplo (2)""}"]
shared #"Transformar archivo (2)" = (#"Parámetro (2)" as binary) => let
  Origen = Csv.Document(#"Parámetro (2)", [Delimiter = ",", Columns = 8, QuoteStyle = QuoteStyle.None]),
  #"Encabezados promovidos" = Table.PromoteHeaders(Origen, [PromoteAllScalars = true])
in
  #"Encabezados promovidos";
shared StagingVentasMenudeo_DataDestination = let
  Pattern = Fabric.Warehouse([HierarchicalNavigation = null, CreateNavigationProperties = false]),
  Navigation_1 = Pattern{[workspaceId = "5bb3a27e-bc84-41d2-bf55-296bb6efc7a4"]}[Data],
  Navigation_2 = Navigation_1{[warehouseId = "99814535-6e61-45dc-9ea7-69d1651f5c8a"]}[Data],
  TableNavigation = Navigation_2{[Item = "StagingVentasMenudeo", Schema = "dbo"]}?[Data]?
in
  TableNavigation;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "StagingArticulos_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "Source.Name", DestinationColumnName = "Source.Name"], [SourceColumnName = "CodigoArticulo", DestinationColumnName = "CodigoArticulo"], [SourceColumnName = "DescArticulo", DestinationColumnName = "DescArticulo"], [SourceColumnName = "Categoria", DestinationColumnName = "Categoria"], [SourceColumnName = "Formato", DestinationColumnName = "Formato"]}], DynamicSchema = false, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared StagingArticulos = let
  Origen = SharePoint.Files("https://gcgcia.sharepoint.com/sites/EquipoVentas", [ApiVersion = 15]),
  #"Filas filtradas" = Table.SelectRows(Origen, each ([Name] = "Ventas_y_Catalogos.xlsx")),
  #"Archivos ocultos filtrados" = Table.SelectRows(#"Filas filtradas", each [Attributes]?[Hidden]? <> true),
  #"Invocar función personalizada" = Table.AddColumn(#"Archivos ocultos filtrados", "Transformar archivo (3)", each #"Transformar archivo (3)"([Content])),
  #"Columnas con nombre cambiado" = Table.RenameColumns(#"Invocar función personalizada", {{"Name", "Source.Name"}}),
  #"Se han quitado otras columnas." = Table.SelectColumns(#"Columnas con nombre cambiado", {"Source.Name", "Transformar archivo (3)"}),
  #"Columna de tabla expandida" = Table.ExpandTableColumn(#"Se han quitado otras columnas.", "Transformar archivo (3)", Table.ColumnNames(#"Transformar archivo (3)"(#"Archivo de ejemplo (3)"))),
  #"Tipo de columna cambiado" = Table.TransformColumnTypes(#"Columna de tabla expandida", {{"CodigoArticulo", Int64.Type}, {"DescArticulo", type text}, {"Categoria", type text}, {"Formato", type text}})
in
  #"Tipo de columna cambiado";
shared #"Archivo de ejemplo (3)" = let
  Origen = SharePoint.Files("https://gcgcia.sharepoint.com/sites/EquipoVentas", [ApiVersion = 15]),
  #"Filas filtradas" = Table.SelectRows(Origen, each [Name] = "Ventas_y_Catalogos.xlsx"),
  #"Archivos ocultos filtrados" = Table.SelectRows(#"Filas filtradas", each [Attributes]?[Hidden]? <> true),
  Navegación = #"Archivos ocultos filtrados"{0}[Content]
in
  Navegación;
shared #"Parámetro (3)" = let
  #"Parámetro (3)" = #"Archivo de ejemplo (3)" meta [IsParameterQuery = true, IsParameterQueryRequired = false, Type = type binary, BinaryIdentifier = #"Archivo de ejemplo (3)"]
in
  #"Parámetro (3)";
shared #"Transformar Archivo de ejemplo (3)" = let
  Origen = Excel.Workbook(#"Parámetro (3)", null, true),
  Navigation = Origen{[Item = "ARTICULOS", Kind = "Sheet"]}[Data],
  #"Encabezados promovidos" = Table.PromoteHeaders(Navigation, [PromoteAllScalars = true])
in
  #"Encabezados promovidos";
[FunctionQueryBinding = "{""exemplarFormulaName"":""Transformar Archivo de ejemplo (3)""}"]
shared #"Transformar archivo (3)" = (#"Parámetro (3)" as binary) => let
  Origen = Excel.Workbook(#"Parámetro (3)", null, true),
  Navigation = Origen{[Item = "ARTICULOS", Kind = "Sheet"]}[Data],
  #"Encabezados promovidos" = Table.PromoteHeaders(Navigation, [PromoteAllScalars = true])
in
  #"Encabezados promovidos";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "StagingClientes_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "CodigoGrupoCliente", DestinationColumnName = "CodigoGrupoCliente"], [SourceColumnName = "Nombre Grupo Sucursal", DestinationColumnName = "Nombre Grupo Sucursal"], [SourceColumnName = "CodigoSucursal", DestinationColumnName = "CodigoSucursal"], [SourceColumnName = "CP", DestinationColumnName = "CP"], [SourceColumnName = "Pais", DestinationColumnName = "Pais"], [SourceColumnName = "Colonia", DestinationColumnName = "Colonia"], [SourceColumnName = "Desc_Estado", DestinationColumnName = "Desc_Estado"], [SourceColumnName = "Codigo_Estado", DestinationColumnName = "Codigo_Estado"], [SourceColumnName = "Desc_Municipio", DestinationColumnName = "Desc_Municipio"], [SourceColumnName = "Codigo_Municipio", DestinationColumnName = "Codigo_Municipio"], [SourceColumnName = "LAT", DestinationColumnName = "LAT"], [SourceColumnName = "LONG", DestinationColumnName = "LONG"]}], DynamicSchema = false, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared StagingClientes = let
  Origen = SharePoint.Files("https://gcgcia.sharepoint.com/sites/EquipoVentas", [ApiVersion = 15]),
  #"Filas filtradas" = Table.SelectRows(Origen, each ([Name] = "Ventas_y_Catalogos.xlsx")),
  #"Archivos ocultos filtrados" = Table.SelectRows(#"Filas filtradas", each [Attributes]?[Hidden]? <> true),
  #"Invocar función personalizada" = Table.AddColumn(#"Archivos ocultos filtrados", "Transformar archivo (3)", each #"Transformar archivo (3)"([Content])),
  #"Columnas con nombre cambiado" = Table.RenameColumns(#"Invocar función personalizada", {{"Name", "Source.Name"}}),
  #"Archivos ocultos filtrados 1" = Table.SelectRows(#"Columnas con nombre cambiado", each [Attributes]?[Hidden]? <> true),
  #"Invocar función personalizada 1" = Table.AddColumn(#"Archivos ocultos filtrados 1", "Transformar archivo (4)", each #"Transformar archivo (4)"([Content])),
  #"Se han quitado otras columnas." = Table.SelectColumns(#"Invocar función personalizada 1", {"Transformar archivo (4)"}),
  #"Columna de tabla expandida" = Table.ExpandTableColumn(#"Se han quitado otras columnas.", "Transformar archivo (4)", Table.ColumnNames(#"Transformar archivo (4)"(#"Archivo de ejemplo (4)"))),
  #"Tipo de columna cambiado" = Table.TransformColumnTypes(#"Columna de tabla expandida", {{"CodigoGrupoCliente", Int64.Type}, {"Nombre Grupo Sucursal", type text}, {"CodigoSucursal", Int64.Type}, {"CP", Int64.Type}, {"Pais", type text}, {"Colonia", type text}, {"Desc_Estado", type text}, {"Codigo_Estado", type text}, {"Desc_Municipio", type text}, {"Codigo_Municipio", Int64.Type}, {"LAT", Int64.Type}, {"LONG", Int64.Type}})
in
  #"Tipo de columna cambiado";
shared #"Archivo de ejemplo (4)" = let
  Origen = SharePoint.Files("https://gcgcia.sharepoint.com/sites/EquipoVentas", [ApiVersion = 15]),
  #"Filas filtradas" = Table.SelectRows(Origen, each [Name] = "Ventas_y_Catalogos.xlsx"),
  #"Archivos ocultos filtrados" = Table.SelectRows(#"Filas filtradas", each [Attributes]?[Hidden]? <> true),
  #"Invocar función personalizada" = Table.AddColumn(#"Archivos ocultos filtrados", "Transformar archivo (3)", each #"Transformar archivo (3)"([Content])),
  #"Columnas con nombre cambiado" = Table.RenameColumns(#"Invocar función personalizada", {{"Name", "Source.Name"}}),
  #"Archivos ocultos filtrados 1" = Table.SelectRows(#"Columnas con nombre cambiado", each [Attributes]?[Hidden]? <> true),
  Navegación = #"Archivos ocultos filtrados 1"{0}[Content]
in
  Navegación;
shared #"Parámetro (4)" = let
  #"Parámetro (4)" = #"Archivo de ejemplo (4)" meta [IsParameterQuery = true, IsParameterQueryRequired = false, Type = type binary, BinaryIdentifier = #"Archivo de ejemplo (4)"]
in
  #"Parámetro (4)";
shared #"Transformar Archivo de ejemplo (4)" = let
  Origen = Excel.Workbook(#"Parámetro (4)", null, true),
  Navigation = Origen{[Item = "CLIENTES", Kind = "Sheet"]}[Data],
  #"Encabezados promovidos" = Table.PromoteHeaders(Navigation, [PromoteAllScalars = true])
in
  #"Encabezados promovidos";
[FunctionQueryBinding = "{""exemplarFormulaName"":""Transformar Archivo de ejemplo (4)""}"]
shared #"Transformar archivo (4)" = (#"Parámetro (4)" as binary) => let
  Origen = Excel.Workbook(#"Parámetro (4)", null, true),
  Navigation = Origen{[Item = "CLIENTES", Kind = "Sheet"]}[Data],
  #"Encabezados promovidos" = Table.PromoteHeaders(Navigation, [PromoteAllScalars = true])
in
  #"Encabezados promovidos";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "StagingGrupoCliente_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "CodigoGrupoCliente", DestinationColumnName = "CodigoGrupoCliente"], [SourceColumnName = "NombreGrupoCliente", DestinationColumnName = "NombreGrupoCliente"], [SourceColumnName = "URL Web", DestinationColumnName = "URL Web"]}], DynamicSchema = false, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared StagingGrupoCliente = let
  Origen = SharePoint.Files("https://gcgcia.sharepoint.com/sites/EquipoVentas", [ApiVersion = 15]),
  #"Filas filtradas" = Table.SelectRows(Origen, each ([Name] = "Ventas_y_Catalogos.xlsx")),
  #"Archivos ocultos filtrados" = Table.SelectRows(#"Filas filtradas", each [Attributes]?[Hidden]? <> true),
  #"Invocar función personalizada" = Table.AddColumn(#"Archivos ocultos filtrados", "Transformar archivo (3)", each #"Transformar archivo (3)"([Content])),
  #"Columnas con nombre cambiado" = Table.RenameColumns(#"Invocar función personalizada", {{"Name", "Source.Name"}}),
  #"Archivos ocultos filtrados 1" = Table.SelectRows(#"Columnas con nombre cambiado", each [Attributes]?[Hidden]? <> true),
  #"Archivos ocultos filtrados 2" = Table.SelectRows(#"Archivos ocultos filtrados 1", each [Attributes]?[Hidden]? <> true),
  #"Invocar función personalizada 1" = Table.AddColumn(#"Archivos ocultos filtrados 2", "Transformar archivo (5)", each #"Transformar archivo (5)"([Content])),
  #"Se han quitado otras columnas." = Table.SelectColumns(#"Invocar función personalizada 1", {"Transformar archivo (5)"}),
  #"Columna de tabla expandida" = Table.ExpandTableColumn(#"Se han quitado otras columnas.", "Transformar archivo (5)", Table.ColumnNames(#"Transformar archivo (5)"(#"Archivo de ejemplo (5)"))),
  #"Tipo de columna cambiado" = Table.TransformColumnTypes(#"Columna de tabla expandida", {{"CodigoGrupoCliente", Int64.Type}, {"NombreGrupoCliente", type text}, {"URL Web", type text}})
in
  #"Tipo de columna cambiado";
shared #"Archivo de ejemplo (5)" = let
  Origen = SharePoint.Files("https://gcgcia.sharepoint.com/sites/EquipoVentas", [ApiVersion = 15]),
  #"Filas filtradas" = Table.SelectRows(Origen, each [Name] = "Ventas_y_Catalogos.xlsx"),
  #"Archivos ocultos filtrados" = Table.SelectRows(#"Filas filtradas", each [Attributes]?[Hidden]? <> true),
  #"Invocar función personalizada" = Table.AddColumn(#"Archivos ocultos filtrados", "Transformar archivo (3)", each #"Transformar archivo (3)"([Content])),
  #"Columnas con nombre cambiado" = Table.RenameColumns(#"Invocar función personalizada", {{"Name", "Source.Name"}}),
  #"Archivos ocultos filtrados 1" = Table.SelectRows(#"Columnas con nombre cambiado", each [Attributes]?[Hidden]? <> true),
  #"Archivos ocultos filtrados 2" = Table.SelectRows(#"Archivos ocultos filtrados 1", each [Attributes]?[Hidden]? <> true),
  Navegación = #"Archivos ocultos filtrados 2"{0}[Content]
in
  Navegación;
shared #"Parámetro (5)" = let
  #"Parámetro (5)" = #"Archivo de ejemplo (5)" meta [IsParameterQuery = true, IsParameterQueryRequired = false, Type = type binary, BinaryIdentifier = #"Archivo de ejemplo (5)"]
in
  #"Parámetro (5)";
shared #"Transformar Archivo de ejemplo (5)" = let
  Origen = Excel.Workbook(#"Parámetro (5)", null, true),
  Navigation = Origen{[Item = "GrupoCliente", Kind = "Sheet"]}[Data],
  #"Encabezados promovidos" = Table.PromoteHeaders(Navigation, [PromoteAllScalars = true])
in
  #"Encabezados promovidos";
[FunctionQueryBinding = "{""exemplarFormulaName"":""Transformar Archivo de ejemplo (5)""}"]
shared #"Transformar archivo (5)" = (#"Parámetro (5)" as binary) => let
  Origen = Excel.Workbook(#"Parámetro (5)", null, true),
  Navigation = Origen{[Item = "GrupoCliente", Kind = "Sheet"]}[Data],
  #"Encabezados promovidos" = Table.PromoteHeaders(Navigation, [PromoteAllScalars = true])
in
  #"Encabezados promovidos";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "StagingVendedor_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "Vendedor", DestinationColumnName = "Vendedor"], [SourceColumnName = "NombreVendedor", DestinationColumnName = "NombreVendedor"]}], DynamicSchema = false, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared StagingVendedor = let
  Origen = SharePoint.Files("https://gcgcia.sharepoint.com/sites/EquipoVentas", [ApiVersion = 15]),
  #"Filas filtradas" = Table.SelectRows(Origen, each ([Name] = "Ventas_y_Catalogos.xlsx")),
  #"Archivos ocultos filtrados" = Table.SelectRows(#"Filas filtradas", each [Attributes]?[Hidden]? <> true),
  #"Invocar función personalizada" = Table.AddColumn(#"Archivos ocultos filtrados", "Transformar archivo (3)", each #"Transformar archivo (3)"([Content])),
  #"Columnas con nombre cambiado" = Table.RenameColumns(#"Invocar función personalizada", {{"Name", "Source.Name"}}),
  #"Archivos ocultos filtrados 1" = Table.SelectRows(#"Columnas con nombre cambiado", each [Attributes]?[Hidden]? <> true),
  #"Archivos ocultos filtrados 2" = Table.SelectRows(#"Archivos ocultos filtrados 1", each [Attributes]?[Hidden]? <> true),
  #"Invocar función personalizada 1" = Table.AddColumn(#"Archivos ocultos filtrados 2", "Transformar archivo (6)", each #"Transformar archivo (6)"([Content])),
  #"Se han quitado otras columnas." = Table.SelectColumns(#"Invocar función personalizada 1", {"Transformar archivo (6)"}),
  #"Columna de tabla expandida" = Table.ExpandTableColumn(#"Se han quitado otras columnas.", "Transformar archivo (6)", Table.ColumnNames(#"Transformar archivo (6)"(#"Archivo de ejemplo (6)"))),
  #"Tipo de columna cambiado" = Table.TransformColumnTypes(#"Columna de tabla expandida", {{"Vendedor", Int64.Type}, {"NombreVendedor", type text}})
in
  #"Tipo de columna cambiado";
shared #"Archivo de ejemplo (6)" = let
  Origen = SharePoint.Files("https://gcgcia.sharepoint.com/sites/EquipoVentas", [ApiVersion = 15]),
  #"Filas filtradas" = Table.SelectRows(Origen, each [Name] = "Ventas_y_Catalogos.xlsx"),
  #"Archivos ocultos filtrados" = Table.SelectRows(#"Filas filtradas", each [Attributes]?[Hidden]? <> true),
  #"Invocar función personalizada" = Table.AddColumn(#"Archivos ocultos filtrados", "Transformar archivo (3)", each #"Transformar archivo (3)"([Content])),
  #"Columnas con nombre cambiado" = Table.RenameColumns(#"Invocar función personalizada", {{"Name", "Source.Name"}}),
  #"Archivos ocultos filtrados 1" = Table.SelectRows(#"Columnas con nombre cambiado", each [Attributes]?[Hidden]? <> true),
  #"Archivos ocultos filtrados 2" = Table.SelectRows(#"Archivos ocultos filtrados 1", each [Attributes]?[Hidden]? <> true),
  Navegación = #"Archivos ocultos filtrados 2"{0}[Content]
in
  Navegación;
shared #"Parámetro (6)" = let
  #"Parámetro (6)" = #"Archivo de ejemplo (6)" meta [IsParameterQuery = true, IsParameterQueryRequired = false, Type = type binary, BinaryIdentifier = #"Archivo de ejemplo (6)"]
in
  #"Parámetro (6)";
shared #"Transformar Archivo de ejemplo (6)" = let
  Origen = Excel.Workbook(#"Parámetro (6)", null, true),
  Navigation = Origen{[Item = "Vendedores", Kind = "Sheet"]}[Data],
  #"Encabezados promovidos" = Table.PromoteHeaders(Navigation, [PromoteAllScalars = true])
in
  #"Encabezados promovidos";
[FunctionQueryBinding = "{""exemplarFormulaName"":""Transformar Archivo de ejemplo (6)""}"]
shared #"Transformar archivo (6)" = (#"Parámetro (6)" as binary) => let
  Origen = Excel.Workbook(#"Parámetro (6)", null, true),
  Navigation = Origen{[Item = "Vendedores", Kind = "Sheet"]}[Data],
  #"Encabezados promovidos" = Table.PromoteHeaders(Navigation, [PromoteAllScalars = true])
in
  #"Encabezados promovidos";
shared StagingArticulos_DataDestination = let
  Pattern = Fabric.Warehouse([HierarchicalNavigation = null, CreateNavigationProperties = false]),
  Navigation_1 = Pattern{[workspaceId = "5bb3a27e-bc84-41d2-bf55-296bb6efc7a4"]}[Data],
  Navigation_2 = Navigation_1{[warehouseId = "99814535-6e61-45dc-9ea7-69d1651f5c8a"]}[Data],
  TableNavigation = Navigation_2{[Item = "StagingArticulos", Schema = "dbo"]}?[Data]?
in
  TableNavigation;
shared StagingClientes_DataDestination = let
  Pattern = Fabric.Warehouse([HierarchicalNavigation = null, CreateNavigationProperties = false]),
  Navigation_1 = Pattern{[workspaceId = "5bb3a27e-bc84-41d2-bf55-296bb6efc7a4"]}[Data],
  Navigation_2 = Navigation_1{[warehouseId = "99814535-6e61-45dc-9ea7-69d1651f5c8a"]}[Data],
  TableNavigation = Navigation_2{[Item = "StagingClientes", Schema = "dbo"]}?[Data]?
in
  TableNavigation;
shared StagingGrupoCliente_DataDestination = let
  Pattern = Fabric.Warehouse([HierarchicalNavigation = null, CreateNavigationProperties = false]),
  Navigation_1 = Pattern{[workspaceId = "5bb3a27e-bc84-41d2-bf55-296bb6efc7a4"]}[Data],
  Navigation_2 = Navigation_1{[warehouseId = "99814535-6e61-45dc-9ea7-69d1651f5c8a"]}[Data],
  TableNavigation = Navigation_2{[Item = "StagingGrupoCliente", Schema = "dbo"]}?[Data]?
in
  TableNavigation;
shared StagingVendedor_DataDestination = let
  Pattern = Fabric.Warehouse([HierarchicalNavigation = null, CreateNavigationProperties = false]),
  Navigation_1 = Pattern{[workspaceId = "5bb3a27e-bc84-41d2-bf55-296bb6efc7a4"]}[Data],
  Navigation_2 = Navigation_1{[warehouseId = "99814535-6e61-45dc-9ea7-69d1651f5c8a"]}[Data],
  TableNavigation = Navigation_2{[Item = "StagingVendedor", Schema = "dbo"]}?[Data]?
in
  TableNavigation;
