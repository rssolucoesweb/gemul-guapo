<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 26/09/2011
	::	Objetivo Pagina...: Relatório de Diretrizes
-->
<html>
<head>
<title><%=session("Titulo")%> - Grade Curricular</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
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
	strMarcouOpcaoDeficit    = TRIM(Request.Form("strMarcouOpcaoDeficit"))
	if strMarcouOpcaoDeficit = "" then strMarcouOpcaoDeficit = "N"
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
	    	<td width="6%" class="celula"><div align="center"><strong>Vagas Existente </strong></div></td>
        <%else%>    
	    	<td width="6%" class="celula"><div align="center"><strong>Vagas Existente </strong></div></td>
        <%end if%>    
	    <td width="7%" height="15" class="celula"><div align="center"><strong>Modulada </strong></div></td>
	    <td width="5%" class="celula"><div align="center"><strong>Disponível</strong></div></td>
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

	sql="SELECT D.Codigo, D.Cod_Empresa, D.CodFuncao, D.Cod_Disciplina, D.VagasOferecidas, D.AulasOferecidas, FC.desc_funcao,  FC.Modular, "
	
	if ucase(Session("UsuarioWeb")) = "USUARIO.TESTE" then
		sql = sql & "		'"&session("EmpresaWeb")&"' as RAZAOSOCIAL, "
	else
		sql=sql & " E.RAZAOSOCIAL, "
	end if
	
	sql=sql & " D.Cod_turno, TU.Desc_Turno, "
	
	sql=sql & " CASE "
       
    sql=sql & "         WHEN FC.Modular = 'N' THEN "
	sql=sql & " 				( SELECT SUM(D1.VagasOferecidas)"
	sql=sql & " 					FROM   SRH_DIRETRIZES D1"
	sql=sql & " 							INNER JOIN SRH_FUNCAOCOLABORADOR F ON  F.cod_Funcao = D1.CodFuncao"
	sql=sql & " 					 WHERE  F.tipo_funcao = 'FUNCIONARIO'"
	sql=sql & " 							AND D1.Cod_Empresa = D.Cod_Empresa "
	sql=sql & " 							AND D1.CodFuncao = D.CodFuncao"
	sql=sql & " 							AND D1.Ano_Letivo = d.Ano_Letivo"
	sql=sql & " 							AND D1.Semestre = d.Semestre "
	sql=sql & " 							AND D1.Cod_Turno = d.Cod_Turno"
	sql=sql & " 					  )   "
	sql=sql & " 					  -"
	sql=sql & " 				("
    sql=sql & "                  SELECT COUNT(codigo)"
    sql=sql & "                 FROM   SRH_COLABORADOR col"
    sql=sql & "                        INNER JOIN SRH_FUNCAOCOLABORADOR func ON  func.cod_Funcao = col.codFuncao"
    sql=sql & "                 WHERE  func.tipo_funcao = 'FUNCIONARIO'"
    sql=sql & "                        AND func.Cod_Funcao = D.CodFuncao"
    sql=sql & "                        AND col.codLotacao = D.Cod_Empresa"
    sql=sql & "                        AND col.CodTurno = D.Cod_turno"
    sql=sql & "                        AND col.situacao = 'A'"
	sql=sql & "				)"
   	sql=sql & "         ELSE ("
   	sql=sql & "         	SELECT SUM(D1.VagasOferecidas)"
	sql=sql & "					FROM   SRH_DIRETRIZES D1"
	sql=sql & "							INNER JOIN SRH_FUNCAOCOLABORADOR F ON  F.cod_Funcao = D1.CodFuncao"
	sql=sql & "					 WHERE  F.tipo_funcao = 'FUNCIONARIO'"
	sql=sql & "							AND D1.Cod_Empresa = D.Cod_Empresa "
	sql=sql & "							AND D1.CodFuncao = D.CodFuncao"
	sql=sql & "							AND D1.Ano_Letivo = d.Ano_Letivo"
	sql=sql & "							AND D1.Semestre = d.Semestre "
	sql=sql & "							AND D1.Cod_Turno = d.Cod_Turno"
	sql=sql & "					  ) "  
    sql=sql & "        	 -"
    sql=sql & "        	("
    sql=sql & "                 SELECT ISNULL(SUM(Total_Aulas), 0) AS TotalCargo"
    sql=sql & "                 FROM   SRH_MODULACAO_DISCIPLINAR_DOCENTE"
    sql=sql & "                 WHERE  cod_empresa = D.Cod_Empresa"
    sql=sql & "                        AND ano_letivo = D.Ano_Letivo"
	sql=sql & "                        AND Semestre = D.Semestre "
    sql=sql & "                        AND cod_Funcao = FC.cod_funcao"
    sql=sql & "                        AND cod_Turno = D.Cod_turno"
    sql=sql & "                        AND tipo_contratacao IS NOT NULL"
    sql=sql & "             )"
    sql=sql & "   END AS Disponivel, "
	
	  sql=sql & "        	("
    sql=sql & "                 SELECT ISNULL(SUM(Total_Aulas), 0) AS TotalCargo"
    sql=sql & "                 FROM   SRH_MODULACAO_DISCIPLINAR_DOCENTE"
    sql=sql & "                 WHERE  cod_empresa = D.Cod_Empresa"
    sql=sql & "                        AND ano_letivo = D.Ano_Letivo"
	sql=sql & "                        AND Semestre = D.Semestre "
    sql=sql & "                        AND cod_Funcao = FC.cod_funcao"
    sql=sql & "                        AND cod_Turno = D.Cod_turno"
    sql=sql & "                        AND tipo_contratacao IS NOT NULL"
    sql=sql & "             ) as TotalModulado "


	sql=sql & " FROM SRH_DIRETRIZES D "
	sql=sql & " inner join SRH_FUNCAOCOLABORADOR FC on FC.cod_funcao = D.CodFuncao "
	sql=sql & " inner join SEG_EMPRESA E on E.CODIGO = D.Cod_Empresa "
	sql=sql & " left join SRH_TURNO TU on TU.cod_Turno = D.Cod_turno "
	sql=sql & " where 1 = 1 "
	sql=sql & " and D.Ano_Letivo = " & trim(strAno)
	sql=sql & " and D.Semestre in ( " & trim(intSemestre) & ")" 
	
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
	elseif strTipoModulacao = "D" then
		sql = sql & "and D.Cod_Disciplina <> 0"
		if intCodCurso <> "0" then
			sql = sql & "and D.cod_curso = " & intCodCurso
		end if
	else
		if intCodCurso <> "0" then
			sql = sql & "and D.cod_curso = " & intCodCurso
		end if
	end if	
	
	sql = sql & " order by D.Cod_Empresa, FC.desc_funcao, FC.Modular" 
	
	rs.open sql, cnn

	if not rs.eof then 
	    strUnidade = "1"
		While not rs.eof 
			
			strSituacao = "A"
			
			if  trim(rs("Cod_Disciplina")) = "0" then
				strModulacao = "Interdisciplinar"
				strVagas = rs("VagasOferecidas")
			else
				strModulacao = "Disciplinar"
				strVagas = rs("AulasOferecidas")
			end if
			
			strDisponivel = trim(rs("Disponivel"))
			strModulado = rs("TotalModulado")		
			
			if  trim(strModulado) > "0" then
				strSituacao = "Deficit"
			end if
			
			if  trim(strModulado) = "0" then
				strSituacao = "Lotado"
			end if
			
			if trim(strModulado) < "0" then
				strSituacao = "Execedente"
			end if
			
			strMostraLinha = "N"
			
			if trim(rs("Modular"))= "N" then
				strCorLinha = ""
			else
				strCorLinha = "#FFFFCC"
			end if
			
			if 	strSituacao = "Deficit" and strMarcouOpcaoDeficit = "S" then
				strMostraLinha = "S"
			elseif strMarcouOpcaoDeficit = "N" then
				strMostraLinha = "S"
			end if
			
			if strMostraLinha = "S" then %>
			  <tr height="28">
                <%if strUnidade = "1" then %>
			    	<td align="left" class="celula"><%=rs("RAZAOSOCIAL")%>&nbsp;</td>
                <% else %>
			    	<td align="left" class="celula">&nbsp;</td>
                 <% end if %>
			    <td bgcolor="<%=strCorLinha%>" align="left" class="celula"><%=rs("desc_funcao")%></td>
                <td bgcolor="<%=strCorLinha%>" align="left" class="celula"><%=rs("Desc_Turno")%>&nbsp;</td>
                <td bgcolor="<%=strCorLinha%>" align="left" class="celula"><%=strModulacao%>&nbsp;</td>
		   		<td bgcolor="<%=strCorLinha%>" align="left" class="celula"><div align="center"><%=strVagas%></div>&nbsp;</td>
			    <td bgcolor="<%=strCorLinha%>" align="left" class="celula"><div align="center"><%=abs(strModulado)%></div>&nbsp;</td>
			    <td bgcolor="<%=strCorLinha%>" align="left" class="celula"><div align="center"><%=strDisponivel%></div>&nbsp;</td>
			    <td bgcolor="<%=strCorLinha%>" width="2%" align="left" class="celula"><div align="center"><strong><%=strSituacao%>&nbsp;</strong></div></td>
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
			end if

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
