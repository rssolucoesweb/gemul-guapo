<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 26/09/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Relatório de Diretrizes
-->
<html>
<head>
<title><%=session("Titulo")%> - Grade Curricular</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script></head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	dim intPagina
	
	intCodEmpresa			= session("codEmpresa")
	intCodEmpresaUsuario    = TRIM(Request.Form("cmdEmpresaUsuario"))
	intCodFuncao 			= Trim(Request.Form("cmbFuncao"))
	strSituacao 			= Trim(Request.Form("cmbSituacao"))
	strTipoModulacao 		= Trim(Request.Form("cmbTipoModulacao"))
	strAno	 				= Trim(Request("txtAno"))
	intCodCurso 			= Trim(Request.Form("cmbCurso"))
	if Trim(Request("cmbSemestre")) <> "0" then
		intSemestre 		= Trim(Request("cmbSemestre"))
	else	
		intSemestre 		=  Session("strSemestre")
	end if	
	if intSemestre = "3" then
	   strMsgSemestre = "Anual"
	else
	   strMsgSemestre = intSemestre
	end if   
	   
	if strAno = "" then strAno = session("strAnoLetivo")
	if intSemestre = "" then intSemestre = Session("strSemestre")
    if strTipoModulacao = "I" then
		strTituloRelatorio  	= "DIRETRIZES GERAIS - Interdisciplinar <BR>" & "Período: " & strAno & "/" & strMsgSemestre
	else
		strTituloRelatorio  	= "DIRETRIZES GERAIS - Disciplinar <BR>" & "Período: " & strAno & "/" & strMsgSemestre
	end if
	if intCodEmpresaUsuario = "" then intCodEmpresaUsuario = "0"
	if intCodFuncao = "" then intCodFuncao = "0"
	
	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <% if strSubTitulo <> "" then %>
	  		<tr bgcolor="#CCCCCC">
	    	  <td height="15" colspan="7" class="celula"><div align="center"><strong><%=strSubTitulo%></strong></div></td>
      		</tr>
	  <% end if %>	 
	
	  <tr bgcolor="#CCCCCC">
	    <td width="29%" class="celula"><div align="center"><strong>Escola</strong></div></td>
	    <td width="29%" class="celula"><div align="center">
	      <p><strong>Fun&ccedil;&atilde;o</strong>	    </p>
	    </div></td>
	    <td width="6%" class="celula"><strong>Turno</strong></td>
	    <td width="8%" class="celula"><strong>Modula&ccedil;&atilde;o</strong></td>
		<%if Trim(Request.Form("cmbTipoModulacao")) = "I" then %>
	    	<td width="6%" class="celula"><div align="center"><strong>Vagas </strong></div></td>
        <%else%>    
	    	<td width="6%" class="celula"><div align="center"><strong>Aulas </strong></div></td>
        <%end if%>    
	    <td width="7%" height="15" class="celula"><div align="center"><strong>Ocupa&ccedil;&atilde;o </strong></div></td>
	    <td width="5%" class="celula"><div align="center"><strong>Saldo</strong></div></td>
	    <td width="8%" class="celula"><div align="center"><strong>Situa&ccedil;&atilde;o</strong></div>	      
	    <div align="center"></div></td>
      </tr>
	  
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0
	sql = "SELECT D.Codigo, D.Cod_Empresa, D.CodFuncao, D.Cod_Disciplina, D.VagasOferecidas, D.AulasOferecidas, FC.desc_funcao, E.RAZAOSOCIAL, "
	sql = sql & " D.Cod_turno, TU.Desc_Turno,"
	sql = sql & " case when D.Cod_Disciplina = 0 "
	sql = sql & " 	then ( SELECT COUNT(codigo) FROM SRH_COLABORADOR where CodFuncao = D.CodFuncao and codLotacao = D.Cod_Empresa and CodTurno = D.Cod_turno and situacao = 'A' ) " 
	sql = sql & " else "
	sql = sql & " 	(SELECT Distinct  "
	sql = sql & " 	count(HA.COD_TURMA) " 
	sql = sql & " 	FROM SCA_HORARIO_AULA HA "
	sql = sql & " 	INNER JOIN SCA_TURMA T ON T.COD_TURMA=HA.COD_TURMA  "
	sql = sql & " 	INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR "
	sql = sql & " 	INNER JOIN SCA_PERIODO P ON P.COD_PERIODO=G.COD_PERIODO "
	sql = sql & " 	WHERE HA.COD_EMPRESA = " & intCodEmpresaUsuario 	
	sql = sql & " 	AND HA.ANOLETIVO = " & trim(strAno)
	sql = sql & " 	AND HA.SEMESTRE in ( " & trim(intSemestre) & ")" 
	sql = sql & " 	AND HA.COD_DISCIPLINA = D.Cod_Disciplina "
	sql = sql & " 	AND  P.Cod_Curso = D.cod_curso "
	sql = sql & " 	AND SUBSTRING(t.NomeTurma,6,1) = TU.Turno_Sigla "
	sql = sql & " 	) end  as Ocupacao	"
	sql = sql & " FROM SRH_DIRETRIZES D "
	sql = sql & " inner join SRH_FUNCAOCOLABORADOR FC on FC.cod_funcao = D.CodFuncao "
	sql = sql & " inner join SEG_EMPRESA E on E.CODIGO = D.Cod_Empresa "
	sql = sql & " left join SRH_TURNO TU on TU.cod_Turno = D.Cod_turno "
	sql = sql & " where 1 = 1 "
	sql = sql & "and D.Ano_Letivo = " & strAno
	sql = sql & "and D.Semestre = " & intSemestre
	if intCodEmpresaUsuario <> "0" then
   		sql = sql & "and D.Cod_Empresa in (" & intCodEmpresaUsuario & ")"	
    else
    	sql = sql & "and E.Cod_Grupo in (" & session("CodGrupo") & ")"
   	end if	
	if intCodFuncao <> "0" then
		sql = sql & "and D.CodFuncao = " & intCodFuncao
	end if
	
    if strSituacao = "L" then 
	    sql = sql &  "and D.VagasOferecidas - ( SELECT COUNT(codigo) FROM SRH_COLABORADOR where CodFuncao = D.CodFuncao and codLotacao = D.Cod_Empresa and CodTurno = D.Cod_turno and situacao = 'A' ) = 0 "
	end if
	
    if strSituacao = "D" then 
	    sql = sql & "and D.VagasOferecidas - ( SELECT COUNT(codigo) FROM SRH_COLABORADOR where CodFuncao = D.CodFuncao and codLotacao = D.Cod_Empresa and CodTurno = D.Cod_turno and situacao = 'A' ) > 0 "
	end if
	
    if strSituacao = "E" then 
	    sql = sql & "and D.VagasOferecidas - ( SELECT COUNT(codigo) FROM SRH_COLABORADOR where CodFuncao = D.CodFuncao and codLotacao = D.Cod_Empresa and CodTurno = D.Cod_turno and situacao = 'A' ) < 0 "
	end if

	if strTipoModulacao = "I" then
		sql = sql & "and D.Cod_Disciplina = 0"
	end if
	if strTipoModulacao = "D" then
		sql = sql & "and D.Cod_Disciplina <> 0"
		if intCodCurso <> "0" then
			sql = sql & "and D.cod_curso = " & intCodCurso
		end if
	end if	
	sql = sql & " order by D.Cod_Empresa, FC.desc_funcao " 
	rs.open sql, cnn

	if not rs.eof then 
	    strUnidade = "1"
		While not rs.eof 
			
			strOcupacao = 1
			strSituacao = "A"
			
			if strTipoModulacao = "I" then
				strVagas = rs("VagasOferecidas")
			else
				strVagas = rs("AulasOferecidas")
			end if
	
			strOcupacao = trim(rs("Ocupacao"))
			if isnull(strOcupacao) then  strOcupacao = "0"
			strSaldo = strVagas - strOcupacao
			if  trim(rs("Cod_Disciplina")) = "0" then
				strModulacao = "Interdisciplinar"
			else
				strModulacao = "Disciplinar"
			end if
			
			if  trim(strSaldo) > "0" then
				strSituacao = "Deficit"
			end if
			
			if  trim(strSaldo) = "0" then
				strSituacao = "Lotado"
			end if
			
			if trim(strSaldo) < "0" then
				strSituacao = "Execedente"
			end if
			
			%>
			  <tr height="28">
                <%if strUnidade = "1" then %>
			    	<td align="left" class="celula"><%=rs("RAZAOSOCIAL")%>&nbsp;</td>
                <% else %>
			    	<td align="left" class="celula">&nbsp;</td>
                 <% end if %>
			    <td align="left" class="celula"><%=rs("desc_funcao")%>&nbsp;</td>
                <td align="left" class="celula"><%=rs("Desc_Turno")%>&nbsp;</td>
                <td align="left" class="celula"><%=strModulacao%>&nbsp;</td>
		   		<td align="left" class="celula"><div align="center"><%=strVagas%></div>&nbsp;</td>
			    <td align="left" class="celula"><div align="center"><%=strOcupacao%></div>&nbsp;</td>
			    <td align="left" class="celula"><div align="center"><%=abs(strSaldo)%></div>&nbsp;</td>
			    <td width="2%" align="left" class="celula"><div align="center"><strong><%=strSituacao%>&nbsp;</strong></div></td>
      </tr>
			<%
			'quantidade de registros da página
			if intQtdeRegistroPorPagina = 50 then
				 intPagina = intPagina + 1
				 intQtdeRegistroPorPagina = 1
				 fimTabela
				%>
				<pre></pre>				
				<%			
				mostraCabecalho
			end if	
			cont = cont + 1
			strUnidade = "2"
			strQuebraUnidade1 = rs("cod_empresa")
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			rs.movenext
			strQuebraUnidade2 = ""
			if not rs.eof then 
			   strQuebraUnidade2 = rs("cod_empresa")
			end if 
			if trim(strQuebraUnidade1) <> trim(strQuebraUnidade2) then  
			   strUnidade = "1"
			end if   
		wend
		
		contPeriodo = contPeriodo + 1
	
	else
		%>
		  <tr>
			<td colspan="8" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
%>
</table>
<br>
<br>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
