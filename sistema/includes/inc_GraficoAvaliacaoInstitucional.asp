<%

Set oChart = CreateObject("OWC10.ChartSpace")
Set c = oChart.Constants
'oChart.Border.Color = c.chColorNone

Vals = split(conceito," ")
Dim categories(6)
 
'crie um array que represente os valores da série.

'gráfico de pizza com quatro categorias.
'crie um array que represente as categorias.

categories(0) = "(A) Excelente - " & vnotaTA & "%"
categories(1) = "(B) Muito Bom - " & vnotaTB & "%"
categories(2) = "(C) Bom - " & vnotaTC & "%"
categories(3) = "(D) Regular - " & vnotaTD & "%"
categories(4) = "(E) Insuficiente - " & vnotaTE & "%"
categories(5) = "(N) Nulo - " & vnotaTN & "%"
 
With oChart
 
'adicionando um objeto do gráfico.
.Charts.Add
 
'adicionando o tipo do gráfico.
if strOpcaoGrafico = "0" then
   .Charts(0).Type = oChart.Constants.chChartTypePie3d
else 
   .Charts(0).Type = oChart.Constants.chChartTypeColumn3d
end if

'adicionando a série ao gráfico.
.Charts(0).SeriesCollection.Add
 
'ajustando o subtítulo da série (o texto da legenda).
.Charts(0).SeriesCollection(0).Caption = TituloGrafico 
 
'adicionando as categorias e os valores da série.
.Charts(0).SeriesCollection(0).SetData c.chDimCategories, c.chDataLiteral, categories
.Charts(0).SeriesCollection(0).SetData c.chDimValues, c.chDataLiteral, Vals
 
if strOpcaoGrafico = "0" then 
	.Charts(0).HasLegend = True
	.Charts(0).HasTitle = True
else
	.Charts(0).HasLegend = false
	.Charts(0).HasTitle = True
end if
 
End With
 
Response.Expires = 0
Response.Buffer = True
Response.Clear
Response.ContentType = "image/gif"

'ajustando o tamanho do gráfico (figura).
Response.BinaryWrite oChart.GetPicture("gif",850, 550)
  
Set objPieChart = Nothing
%>