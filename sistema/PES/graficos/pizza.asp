<!--#include file="../../../includes/inc_cnn.asp"-->
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
		
		While not rs.eof
			resultado = resultado & "['" & rs("resposta") & "', " & rs("quantidade") & "],"
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
      google.charts.load("current", {packages:["corechart"]});
      google.charts.setOnLoadCallback(drawChart);
      function drawChart() {
        var data = google.visualization.arrayToDataTable([
          ['Opiniões', 'Quantitativo do Resultado da Pesquisa'],
          <%=resultado%>
        ]);

        var options = {
          title: '<%=pergunta%>',
          is3D: true,
        };

        var chart = new google.visualization.PieChart(document.getElementById('piechart_3d'));
        chart.draw(data, options);
      }
    </script>
  </head>
  <body>
	<div align="center" class="titulo"><h1>Sistema Gemul</h1></div>
	<div align="center" class="titulo"><h2><%=pesquisa%></h2></div>
    <div id="piechart_3d" style="width: 900px; height: 500px;"></div>
  </body>
</html>
