<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
SESSION.Timeout = 1200
Server.ScriptTimeout = 1200
%>
<html>
<head>
<title><%=session("Titulo")%> - Justificativa de Faltas</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<script src="js/js_funcoes_gerais.js"></script>
<script src="js_app/js_barra_movel.js"></script>
<script>
	function abrePaginaJustificativa(cod){
		
		var caminho = "sca_justificativa_faltas_img.asp?codigo="+cod;
		window.open(caminho,"abreConsulta","top=50,left=50,height=600,width=800,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}
</script>
</head>
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->
<!--#include file="includes/inc_aguarde.asp"-->
<br>
<%

	dim intPagina
	redim vetTipoAvaliacao(0,2)

	strTituloRelatorio  	= "Justificativa de Faltas<br>"

	sub mostraCabecalho()
		%>
		<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
		<br>
		<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub	

	strMostraResultadoFinal	= Trim(Request.Form("resultadoFinal"))
	strMostraCH			= Trim(Request.Form("CH"))
	strMostraPercFaltas = Trim(Request.Form("PercFaltas"))
	strTipoResultadoFinal = Trim(Request.Form("txtTipoResultadoFinal"))
	intQtdeQuebraExtrato  	    = Trim(Request.Form("cmbTotalExtrato"))
	
	intCodCurso	 		= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 		= Trim(Request.Form("cmbPeriodo"))
	intSemestre 		= Trim(Request.Form("cmbSemestre"))
	intCodTurma 		= Trim(Request.Form("cmbTurma"))
	intCodBimestre 		= Trim(Request.Form("cmbBimestre"))
	intCodTipoJustificativa 		= Trim(Request.Form("cmbTipoJustificativa"))
	strCod_empresa 		= Session("CodEmpresa")
	intAnoLetivo 		= Trim(Request.Form("txtAnoLetivo"))
	
	strCodAluno			= Trim(Request("chkAluno"))
	if strCodAluno <> "" then
		vetAluno	=	split(Trim(Request.form("chkAluno")),",")
	end if
	

	if strCodAluno <> "" then 
		contQuebra = 0		
		for j=0 to ubound(vetAluno)
			
			intCodAluno 	 = vetAluno(j)

			sql = " select j.codigo, j.ano_letivo, j.DataInicial, j.DataFinal, j.justificativa, a.NOMEALUNO as aluno, a.MATRICULA, b.Descricao as bimestre, t.Descricao as tipo, tu.NomeTurma, tu.TurmaAluno, c.Descricao as curso, p.Descricao as periodo, tur.Desc_Turno as turno"
			sql = sql & " from SCA_ALUNO_JUSTIFICATIVA_FALTAS j"
			sql = sql & " inner join SCA_ALUNO a on a.codigo = j.cod_aluno"
			sql = sql & " inner join SCA_BIMESTRE b on b.Codigo = j.Cod_bimestre"
			sql = sql & " inner join SCA_TIPO_JUSTIFICATIVA_FALTAS t on t.Codigo = j.cod_Tipo_Justificativa_Faltas"
			sql = sql & " inner join SCA_TURMA tu on tu.Cod_Turma = j.Cod_turma"
			sql = sql & " inner join SCA_PERIODO p on p.Cod_Periodo = tu.Cod_periodo"
			sql = sql & " inner join SCA_curso c on c.Cod_curso = p.Cod_curso"
			sql = sql & " inner join SCA_turno tur on tur.Cod_Turno = tu.Cod_Turno"
			sql = sql & " where j.ano_letivo =" & intAnoLetivo
			sql = sql & " and tu.cod_empresa = " & strCod_empresa
			if intCodTipoJustificativa <>"0" then
				sql = sql & " and j.cod_Tipo_Justificativa_Faltas = " & intCodTipoJustificativa
			end if
			if intCodBimestre <> "0" then
				sql = sql & " and j.Cod_bimestre = " & intCodBimestre
			end if
			sql = sql & " and j.Cod_turma = " & intCodTurma
			sql = sql & " and j.Cod_aluno = " & intCodAluno
			sql = sql & " order by j.ano_letivo, a.NOMEALUNO, j.DataInicial"
			quebraPagina = ""
			
			IF ucase(SESSION("USUARIOWEB")) = "SERGIO" THEN
				'response.write sql
			END IF
			rs.open sql, cnn
			if rs.eof = false then
				mostraCabecalho
				strNomeAluno 	 = rs("aluno")
				strMatricula 	 = rs("MATRICULA")
				strNomeTurma 	 = rs("NOMETURMA") & " - " & rs("TurmaAluno")
				strDescricaoCurso= rs("curso")
				strDescricaoPeriodo= rs("periodo")
				strDescricaoTurno= rs("TURNO")
				
				quebraPagina = "S"
				%>
					<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
					  <tr>
						<td width="8%">Aluno(a):</td>
						<td width="63%">&nbsp;<strong><%=strNomeAluno%></strong></td>
						<td width="14%">Matr&iacute;cula:</td>
						<td width="15%">&nbsp;<strong><%=strMatricula%></strong></td>
					  </tr>
					  <tr>
						<td>Curso:</td>
						<td>&nbsp;<strong><%=strDescricaoCurso%></strong></td>
						<td>Turma:</td>
						<td>&nbsp;<strong><%=strNomeTurma%></strong></td>
					  </tr>
					  <tr>
					    <td>Per&iacute;odo:</td>
					    <td>&nbsp;<strong><%=strDescricaoPeriodo%></strong></td>
					    <td>Turno:</td>
					    <td>&nbsp;<strong><%=strDescricaoTurno%></strong></td>
				      </tr>
					</table>
					<br>
					<table width="98%" border="1" cellspacing="0" cellpadding="0" class="tabela" align="center">
				  <tr>
					<td width="20%" align="center" class="celula">Bimestre</td>
					<td width="20%" align="center" class="celula">Tipo</td>
					<td width="30%" align="center" class="celula">Justificativa</td>
					<td width="10%" align="center" class="celula">Data Inicial</td>
					<td width="10%" align="center" class="celula">Data Final</td>
					<td width="10%" align="center" class="celula">Dias</td>
				  </tr>
				<%
				while not rs.eof	
				
					dataInicial = CDate(rs("DataInicial"))
					dataFinal = CDate(rs("DataFinal"))

					' Calculando a diferença em dias
					dias = DateDiff("d", dataInicial, dataFinal)
						%>

					 <tr style="cursor:pointer" onClick="return abrePaginaJustificativa('<%=rs("codigo")%>')" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
						<td align="left" class="celula">&nbsp;<%=rs("bimestre")%></td>
						<td align="left" class="celula">&nbsp;<%=rs("tipo")%></td>
						<td align="left" class="celula">&nbsp;<%=rs("justificativa")%></td>
						<td align="center" class="celula">&nbsp;<%=formatadataAP(rs("DataInicial"))%></td>
						<td align="center" class="celula">&nbsp;<%=formatadataAP(rs("DataFinal"))%></td>
						<td align="center" class="celula">&nbsp;<%=dias+1%></td>
					 </tr>
						<%
					rs.movenext
				wend 
				%>
				</table>
			<%		
			end if
			rs.close

			if j <> ubound(vetAluno) and quebraPagina = "S" then
				%>
				<pre></pre>				
				<%	
			end if			
		next
		'next aluno		
	else
		rs.close
		cnn.close
		%>
		<script>
			alert("Aluno não foi encontrato, verifique.");
			window.history.back();
		</script>
		<%
		response.end
	end if 
	
	%>
</body>
<script>
	aguarde.style.display="none";
</script>
</html>