<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
response.Expires=0
Server.ScriptTimeOut = 5000
response.Buffer = false
%>
<html>
<head>
<title>GEMUL - Quantitativos</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<%
	dim intPagina
	
	if Trim(Request.Form("txtAnoLetivo")) <> "" then
	   strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	else
	   strAnoLetivo = session("strAnoLetivo")   
	end if   

	periodo		= Trim(Request("periodo"))
	cod_empresa	= Trim(Request("cod_empresa"))
	turno		= Trim(Request("turno"))
	sexo		= Trim(Request("sexo"))
	situacaoaluno = Trim(Request("situacaoaluno"))
	curso 		= Trim(Request("curso"))

	sql = "select distinct a.matricula, a.nomealuno, a.datanascimento "
	sql = sql &"  from sca_aluno a"
	sql = sql &"  inner join sca_aluno_turma at on at.cod_aluno = a.codigo"
	sql = sql &"  inner join sca_turma t on t.cod_turma = at.cod_turma"
	sql = sql &"  inner join sca_turno tu on tu.cod_turno = t.cod_turno"
	'sql = sql &"  inner join sca_situacaoaluno s on s.cod_situacaoaluno = a.cod_situacaoaluno"
	sql = sql &"  inner join SCA_GRADECURRICULAR g on g.Cod_GradeCurricular = t.Cod_GradeCurricular"
	sql = sql &"  inner join SCA_PERIODO p on p.cod_periodo = g.cod_periodo"
	sql = sql &"  inner join SCA_CURSO c on c.cod_curso = p.cod_curso"
		'--------------------------------------------------------
        '-- Recupera apenas a última situação do aluno
        '--------------------------------------------------------
    sql = sql &"      OUTER APPLY"
    sql = sql &"      ("
    sql = sql &"          SELECT TOP 1"
    sql = sql &"              SS.Desc_SituacaoAluno"
    sql = sql &"          FROM SCA_CONTROLE_SITUACAO_ALUNO CS"
    sql = sql &"          INNER JOIN SCA_SITUACAOALUNO SS"
    sql = sql &"              ON SS.Cod_SituacaoAluno = CS.COD_SITUACAOALUNO"
    sql = sql &"          WHERE CS.COD_EMPRESA = AT.COD_EMPRESA"
    sql = sql &"            AND CS.COD_ALUNO   = AT.COD_ALUNO"
    sql = sql &"            AND CS.ANO_LETIVO  = AT.ANO_LETIVO"
    sql = sql &"          ORDER BY CS.CODIGO DESC"
    sql = sql &"      ) SIT"
	sql = sql &"  where at.cod_empresa = " & cod_empresa
	sql = sql &"  and isnull(a.sexoaluno,'M') = '" & sexo & "'"
	sql = sql &"  and tu.desc_turno = '" & turno & "'"
	'sql = sql &"  and at.situacao = 'A'"
	sql = sql &"  and t.situacao = 'A'"
	sql = sql &"  and AT.SITUACAO = 'A'"
	sql = sql &"  and at.ano_letivo = " & strAnoLetivo
	'sql = sql &"  and s.Desc_SituacaoAluno = '" & situacaoaluno & "'"
	sql = sql &"  AND ISNULL("
    sql = sql &"                  SIT.Desc_SituacaoAluno,"
	sql = sql &"  				'ATIVO') = 'ATIVO'"
	
	sql = sql &"  and p.descricao = '" & periodo & "'"
	sql = sql &"  and c.descricao = '" & curso & "'"
	sql = sql &"  order by a.nomealuno"
	
	'response.write sql
	
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
