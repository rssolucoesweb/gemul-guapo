<!--#include file="../../includes/inc_cnn.asp"-->
<%
	cod_pergunta = request("cod_pergunta")
	cod_pesquisa = request("cod_pesquisa")
	cod_setor = request("cod_setor")

	sql = "select p.codigo as cod_pergunta, pes.nome as pesquisa, p.nome as pergunta, tr.nome as resposta, re.cod_tipo_resposta, count(*) as quantidade"
	sql = sql & " from pes_resultado r"
	sql = sql & " inner join PES_entrevistado ent on ent.codigo= r.cod_entrevistado"
	sql = sql & " inner join PES_resultado_respostas rr on rr.cod_resultado = r.codigo"
	sql = sql & " inner join PES_pergunta p on p.codigo = rr.cod_pergunta"
	sql = sql & " inner join PES_resposta re on re.codigo = rr.cod_resposta"
	sql = sql & " inner join PES_tipo_resposta tr on tr.codigo = re.cod_tipo_resposta"
	sql = sql & " inner join PES_pesquisa pes on pes.codigo = r.cod_pesquisa"
	sql = sql & " where p.cod_pesquisa = " & cod_pesquisa
	sql = sql & " and rr.cod_pergunta = " & cod_pergunta
	if cod_setor <>"0" then
		sql = sql & " and ent.cod_setor = " & cod_setor
	end if
	sql = sql & " group by p.codigo, pes.nome, p.nome, tr.nome, re.ordem, re.cod_tipo_resposta"
	sql = sql & " order by p.codigo, re.ordem"
	rs.open sql, cnn
	if not rs.eof then 
		pesquisa = rs("pesquisa")
		pergunta = rs("pergunta")
		quant = 1
		While not rs.eof
			quant_respostas = 0
			sql = " select count(*) as quant_respostas from PES_resultado_respostas where cod_pergunta = " & rs("cod_pergunta")
			rsAux.open sql, cnn
			if not rsAux.eof then 
				quant_respostas = rsAux("quant_respostas")
			end if
			rsAux.close
			percentual  = (rs("quantidade")*100)/quant_respostas
			if quant = 1 then cor = "#00008B"
			if quant = 2 then cor = "#DC143C"
			if quant = 3 then cor = "#006400"
			if quant = 4 then cor = "#FF8C00"
			if quant = 5 then cor = "#FFD700"
			if quant = 6 then cor = "#20B2AA"
			if quant = 7 then cor = "#BDB76B"
			if quant = 8 then cor = "#FFFF00"
			if quant = 9 then cor = "#A0522D"
			resultado = resultado & "['" & rs("resposta") & "', " & replace(formatNumber(percentual,1),",",".") & ",'color: " & cor & "'],"
			quant = quant + 1
			rs.movenext
		wend
		resultado = left(resultado,len(resultado)-1)
	end if
	rs.close
	%>

<html>
  <head>
	<style>
		.titulo {
		  font-family: Arial, Helvetica, sans-serif;
		}
	</style>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
	  <script type="text/javascript">
		google.charts.load("current", {packages:['corechart']});
		google.charts.setOnLoadCallback(drawChart);
		function drawChart() {
		  var data = google.visualization.arrayToDataTable([
			["Element", "Percentual", { role: "style" } ],
			<%=resultado%>
			
		  ]);

		  var view = new google.visualization.DataView(data);
		  view.setColumns([0, 1,
						   { calc: "stringify",
							 sourceColumn: 1,
							 type: "string",
							 role: "annotation" },
						   2]);

		  var options = {
			title: "<%=pergunta%>",
			width: 1000,
			height: 500,
			bar: {groupWidth: "95%"},
			legend: { position: "none" },
		  };
		  var chart = new google.visualization.ColumnChart(document.getElementById("columnchart_values"));
		  chart.draw(view, options);
	  }
	  </script>
  </head>
  <body>
	<div align="center" style="width: 1000px;" class="titulo"><h1>Sistema Gemul</h1></div>
	<div align="center" style="width: 1000px;" class="titulo"><h2><%=pesquisa%></h2></div>
    <div id="columnchart_values" style="width: 1000px; height: 300px;"></div>
  </body>
</html>


