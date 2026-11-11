<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
SESSION.Timeout = 1200
Server.ScriptTimeout = 1200
%>
<html>
<head>
<title>GEMUL - Conteúdo Ministrado</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<script src="js/js_funcoes_gerais.js"></script>
<script src="js_app/js_barra_movel.js"></script>
<style type="text/css">
	.font14 {
		font-size: 14px;
	}
	.font16 {
		font-size: 14px;
	}
</style>
</head>
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->
<!--#include file="includes/inc_aguarde.asp"-->
<%
	dim intPagina
	strAssinatura				= trim(request("cmbAssinatura")) 		
	dataInicio				= trim(request("txtDataInicial")) 		
	dataFim				    = trim(request("txtDataFinal")) 		
	intCodColaborador		= Trim(Request("cmbProfessor"))
    intCodTurma             = Trim(Request("cmbTurmaProfessor"))
	intCodTurno             = Trim(Request("cmbTurnoDoProfessor"))
    intCodDisciplina        = Trim(Request("cmbDisciplinaDoProfessor"))
	if intCodDisciplina = "" then intCodDisciplina = "0"
	strAnoLetivo		 	= Trim(Request.Form("txtAnoLetivo"))
	'strSemestre			 	= Trim(Request.Form("cmbSemestre"))
	


	'sql="select Cod_Turno from SCA_TURMA where Cod_Turma =" & intCodTurma
	sql="select Cod_Turno, desc_turno from sca_TURNO "
	sql=sql & " where Cod_Turno =" & intCodTurno
	rs.open sql, cnn
	if rs.eof = false then
		intCodTurno = rs("Cod_Turno")
		strTurno = rs("desc_turno")
	end if
	rs.close

	if intCodDisciplina <> "0" then
		sql="select desc_disciplina from sca_disciplina"
		sql=sql & " where cod_disciplina =" & intCodDisciplina
		rs.open sql, cnn
		if rs.eof = false then
			strDisciplina = rs("desc_disciplina")
		end if
		rs.close	
	else
		strDisciplina = "Todos"
	end if

	sql="select tu.NomeTurma, tu.TurmaAluno, pe.Descricao as periodo, cu.Descricao as curso, t.Desc_Turno as turno "
	sql=sql & " from sca_turma tu"
	sql=sql & " inner join SCA_PERIODO pe on pe.Cod_Periodo = tu.Cod_periodo"
	sql=sql & " inner join SCA_curso cu on cu.Cod_curso=pe.Cod_Curso"
	sql=sql & " inner join SCA_turno t on t.Cod_Turno = tu.Cod_Turno"
	sql=sql & " where tu.Cod_Turma=" & intCodTurma
	rs.open sql, cnn
	if rs.eof = false then
		strCurso = rs("curso")
		strPeriodo = rs("periodo")
		strTurma = rs("NomeTurma") & " " & rs("TurmaAluno") & " (" & rs("turno") & ")"
	end if
	rs.close
	
	strTituloRelatorio  	= "Conteúdo Ministrado"
	
	sub mostraCabecalho()
	%>
	<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	<br>
    <table width="100%" cellspacing="0" cellpadding="0" class="tabela">
	  <tr>
		<td width="100px" align="left" class="celula"><strong>Curso:</strong> <%=strCurso%></td>
		<td width="100px" align="left" class="celula"><strong>Período:</strong> <%=strPeriodo%></td>
		<%if strTurno<>"" then%>
		<td width="100px" align="left" class="celula"><strong>Turno:</strong> <%=strTurno%></td>
		<%end if%>
		<td width="100px" align="left" class="celula"><strong>Componente curricular:</strong> <%=strDisciplina%></td>
		<td width="100px" align="left" class="celula"><strong>Turma:</strong> <%=strTurma%></td>
	  </tr>
	</table>
	<br>
	<table width="100%" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td width="70px" align="center" class="celula"><strong>Data</strong></td>
		<td width="100px" align="center" class="celula"><strong>Professor(a)</strong></td>
		<td width="20px" class="celula"><strong>Aula</strong></td>
		<td class="celula"><strong>Conteúdo Ministrado</strong></td>
		<td width="150px" class="celula"><strong>ConteúdoComplementar</strong></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
	intQtdeRegistroPorPagina = 0
	intPagina = 1
	mostraCabecalho
	contExtra = 0
	contAula = 0
	contGeral = 0
	disciplina = ""
	textSabadoAnterior = ""
    sql="SP_rel_conteudo_ministrado " & intCodColaborador & "," & intCodTurma & "," & intCodTurno & "," & intCodDisciplina & ",'" & formatadataBD(dataInicio) & "', '" & formatadataBD(dataFim) & "'"
		if session("usuarioWeb") = "SERGIO" THEN
			'RESPONSE.WRITE SQL & "<hr>"
		end if
	rs.open sql, cnn
	if not rs.eof then 
		%>
		  <tr>
			<td colspan="6" class="celula font14">Componente curricular: <strong><%=rs("disciplina")%></strong></td>
		  </tr>
		<%
		While not rs.eof
			
			
			if not isnull(rs("desc_conteudo_ministrado")) then
	  			strDescContMin = rs("desc_conteudo_ministrado")
				if isnull(rs("numero_aula")) then
					ArrayExtra = split(strDescContMin,"|")
					
					for i=0 to UBound(ArrayExtra)-1
						campoSabadoAtual = left(ArrayExtra(i),16)
						
						if trim(campoSabadoAtual) <> trim(textSabadoAnterior) then
							contGeral = contGeral + 1
							contExtra = contExtra + 1
						end if
						textSabadoAnterior = left(ArrayExtra(i),16)
					next
					
					fundoLinha = " bgcolor='#fcfedb' "
				else
					contAula = contAula + 1
					contGeral = contGeral + 1
					fundoLinha = " bgcolor='#FFFFFF' "
				end if
			else
				strDescContMin = ""
			end if
			
			%>
			  <tr <%=fundoLinha%> >
				<td class="celula"><%=rs("data_aula")%></td>
				<td class="celula"><%=rs("professor")%> </td>
				<td class="celula"><%=rs("numero_aula")%></td>
				<td class="celula"><%=replace(strDescContMin,"|","<br>")%></td>
				<td class="celula"><%=rs("desc_conteudo_complementar")%></td>
			  </tr>
			<%

			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			textSabadoAnterior = ""
			rs.movenext
		wend
		
		%>
		  <tr>
			<td colspan="5" class="celula">Quantidade de aula: <%=contAula%> | Quantidade de aula sábado letivo: <%=contExtra%> | Total: <%=contAula+contExtra%></td>
		  </tr>
		  
		  <%if strAssinatura="S" then%>
		  <tr height="28">
				<td colspan="5">
					<br>
					<br>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td width="50%" align="center">______________________________________</td>
						<td width="50%" align="center">______________________________________</td>
					  </tr>
					  <tr>
						<td align="center" valign="top">Coordenador(a)</td>
						<td align="center" valign="top">Professor(a)</td>
					  </tr>
					</table>					
					<br>
				</td>
			</tr>
			<%end if%>
		 <%
		else
		%>
		  <tr>
			<td height="13" colspan="5" align="center" class="celula"><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
	  </tr>
		<%
	end if
	rs.close
%>
</table>
</body>
<script>
	aguarde.style.display="none";
</script>
</html>