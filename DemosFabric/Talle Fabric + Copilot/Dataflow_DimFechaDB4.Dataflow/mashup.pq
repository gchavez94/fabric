[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "Consulta1_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "Fecha", DestinationColumnName = "Fecha"], [SourceColumnName = "Año", DestinationColumnName = "Año"], [SourceColumnName = "NombreDelMes", DestinationColumnName = "NombreDelMes"], [SourceColumnName = "Dia", DestinationColumnName = "Dia"], [SourceColumnName = "DiaDeLaSemana", DestinationColumnName = "DiaDeLaSemana"], [SourceColumnName = "Trimestre", DestinationColumnName = "Trimestre"]}], DynamicSchema = false, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared DimFecha = let 
StartDate=#date(2010, 1, 1),
EndDate=DateTime.Date(Date.AddDays(DateTime.LocalNow(), 1)),
DayCount = Duration.Days(Duration.From(EndDate - StartDate)),
Source = List.Dates(StartDate,DayCount,#duration(1,0,0,0)),
  #"Convertido en tabla" = Table.FromList(Source, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
  #"Tipo de columna cambiado" = Table.TransformColumnTypes(#"Convertido en tabla", {{"Column1", type date}}),
  #"Columnas con nombre cambiado" = Table.RenameColumns(#"Tipo de columna cambiado", {{"Column1", "Fecha"}}),
  #"Año insertado" = Table.AddColumn(#"Columnas con nombre cambiado", "Año", each Date.Year([Fecha]), type nullable number),
  #"Nombre del mes insertado" = Table.AddColumn(#"Año insertado", "Nombre del mes", each Date.MonthName([Fecha]), type nullable text),
  #"Día insertado" = Table.AddColumn(#"Nombre del mes insertado", "Día", each Date.Day([Fecha]), type nullable number),
  #"Día de la semana insertado" = Table.AddColumn(#"Día insertado", "Día de la semana", each Date.DayOfWeek([Fecha]), type nullable number),
  #"Trimestre insertado" = Table.AddColumn(#"Día de la semana insertado", "Trimestre", each Date.QuarterOfYear([Fecha]), type nullable number),
  #"Columnas con nombre cambiado 1" = Table.RenameColumns(#"Trimestre insertado", {{"Nombre del mes", "NombreDelMes"}, {"Día", "Dia"}, {"Día de la semana", "DiaDeLaSemana"}})
in #"Columnas con nombre cambiado 1";
shared Consulta1_DataDestination = let
  Pattern = Fabric.Warehouse([HierarchicalNavigation = null, CreateNavigationProperties = false]),
  Navigation_1 = Pattern{[workspaceId = "5bb3a27e-bc84-41d2-bf55-296bb6efc7a4"]}[Data],
  Navigation_2 = Navigation_1{[warehouseId = "5a9b6a60-9dda-49bb-bf7d-119fee6221a6"]}[Data],
  TableNavigation = Navigation_2{[Item = "DimFecha", Schema = "dbo"]}?[Data]?
in
  TableNavigation;
