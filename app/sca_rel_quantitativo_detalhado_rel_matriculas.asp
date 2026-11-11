<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<html>
<head>
<title><%=session("Titulo")%> - Alunos Por Turma</title>
<link type="text/css" rel="stylesheet" href="../Estilo/Estilo_Impressao.css">
<body>
<!--#include file="../includes/inc_verificaSession.asp"-->
<!--#include file="../includes/inc_cnn.asp"-->
<%
	dim intPagina
	
	if Trim(Request.Form("txtAnoLetivo")) <> "" then
	   strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	else
	   strAnoLetivo = session("strAnoLetivo")   
	end if   

	idade		= Trim(Request("idade"))
	cod_empresa	= Trim(Request("cod_empresa"))
	turno		= Trim(Request("turno"))
	sexo		= Trim(Request("sexo"))
	situacaoaluno = Trim(Request("situacaoaluno"))
	curso 		= Trim(Request("curso"))
	

	
	VACINA_COVID			= Trim(Request("covid"))
	VACINA_COVID_DOSE		= Trim(Request("covid_dose"))
	
	
sql = "select distinct a.matricula, a.nomealuno, a.datanascimento "
	sql = sql &"  from sca_aluno a"
	sql = sql &"  inner join sca_aluno_turma at on at.cod_aluno = a.codigo"
	sql = sql &"  inner join sca_turma t on t.cod_turma = at.cod_turma"
	sql = sql &"  inner join sca_turno tu on tu.cod_turno = t.cod_turno"
	sql = sql &"  inner join sca_situacaoaluno s on s.cod_situacaoaluno = a.cod_situacaoaluno"
	sql = sql &"  inner join SCA_GRADECURRICULAR g on g.Cod_GradeCurricular = t.Cod_GradeCurricular"
	sql = sql &"  inner join SCA_PERIODO p on p.cod_periodo = g.cod_periodo"
	sql = sql &"  inner join SCA_CURSO c on c.cod_curso = p.cod_curso"
	sql = sql &"  where at.cod_empresa = " & cod_empresa
	sql = sql &"  and a.sexoaluno = '" & sexo & "'"
	sql = sql &"  and tu.desc_turno = '" & turno & "'"
	sql = sql &"  and at.situacao = 'A'"
	sql = sql &"  and at.ano_letivo = " & strAnoLetivo
	sql = sql &"  and s.Desc_SituacaoAluno = '" & situacaoaluno & "'"
	sql = sql &"  and c.descricao = '" & curso & "'"
	if idade = "999" then
		sql = sql &"  and YEAR(getdate())-YEAR(a.DATANASCIMENTO)-IIF(MONTH(getdate())*32+DAY(getdate())<MONTH(a.DATANASCIMENTO)*32+DAY(a.DATANASCIMENTO),1,0) < 0"
	else
		sql = sql &"  and YEAR(getdate())-YEAR(a.DATANASCIMENTO)-IIF(MONTH(getdate())*32+DAY(getdate())<MONTH(a.DATANASCIMENTO)*32+DAY(a.DATANASCIMENTO),1,0) = " & idade
	end if
	sql = sql &"  order by a.nomealuno"
	
	'response.write sql
	'response.end
	rs.open sql, cnn
	if not rs.eof then
		%>
		<table width="100%" border="1" cellspacing="0" cellpadding="0" class="tabela">
		  <tr>
			<td class="celula"><strong>Matrícula</strong></td>
			<td class="celula"><strong>Nome</strong></td>
			<td class="celula"><strong>Data Nascimento</strong></td>
		  </tr>
        <%
		cont = 0
		while not rs.eof
			%>
		  <tr>
			<td class="celula"><%=rs("matricula")%></td>
			<td class="celula"><%=rs("nomealuno")%></td>
			<td class="celula"><%=rs("datanascimento")%></td>
		  </tr>
		  	<%
			cont = cont + 1

		 	rs.movenext 
		wend
		%>
       	<tr>
			<td colspan="3" class="celula">Quantidade de alunos: <strong><%=cont%></strong></td>
		  </tr>
		</table>
		<%
		rs.close			
	else
		rs.close	
		%>
		<script>
			alert("Não foi encontrado registros!");
			window.close();
		</script>
		<%
		response.end
	end if
	
%>
</body>
</html>
