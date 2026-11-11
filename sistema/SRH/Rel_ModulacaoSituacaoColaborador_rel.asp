<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<%
Response.AddHeader "Content-Type", "text/html; charset=utf-8"
Response.AddHeader "Pragma", "no-cache"
response.Charset="utf-8"
%>
<html>
<head>
<title><%=session("Titulo")%></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
<style type="text/css">
body,td,th {
	font-family: Tahoma;
}
</style>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	dim intPagina
	
	strAnoLetivo 					= session("strAnoLetivo")
    strTituloRelatorio  			= "Relatório Modulação Disponibilidade"

	strAnoLetivo 					= session("strAnoLetivo")
	strSemestre 					= session("strSemestre")
	intCodEmpresa 					= Session("CodEmpresa")
	intCodEmpresaGrupo				= Trim(Request.Form("cmbEmpresaGrupo"))
	intCodColaboradorModulacao		= Trim(Request.Form("cmbColaboradorModulacao"))	
	
	strTipoModulacao				= Trim(Request.Form("optTipoModulacao"))
	intCodTurno					 	= Trim(Request.Form("cmbTurno"))
	intCodFuncao					= Trim(Request.Form("cmbFuncao"))
	intSaldoPositivo				= Trim(Request.Form("chkSaldoPositivo"))
	
	if intCodEmpresaGrupo="" then intCodEmpresaGrupo = "0"
	if intCodEmp = "" then intCodEmp = session("codEmpresa")
	if trim(request("cmbSemestre")) = "0" or trim(request("cmbSemestre")) = ""  then 
		intSemestre = session("strSemestre")
	else
		intSemestre = request.Form("cmbSemestre")
	end if

	if intCodColaboradorModulacao = "" then intCodColaboradorModulacao = "0"
	if strSituacao = "0" then strSituacao = "A"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodFuncao = "" then intCodFuncao = "0"

	
	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
	    <td height="21" colspan="15" align="center" class="celula"><strong>Modula&ccedil;&atilde;o Situa&ccedil;&atilde;o Colaborador</strong></td>
      </tr>
	  <tr bgcolor="#CCCCCC">
	    <td width="21%" class="celula"><strong>Unidade</strong></td>
		<td width="21%" height="19" class="celula"><strong>Professor</strong></td>
		<td width="7%" class="celula"><strong>Categoria</strong></td>
		<td width="19%" class="celula"><strong>Fun&ccedil;&atilde;o</strong></td>
		<td width="14%" class="celula"><strong>Nivel</strong></td>
		<td width="6%" class="celula"><strong>Turno</strong></td>
		<td width="7%" align="center" class="celula"><strong>Contratado</strong></td>
		<td width="7%" align="center" class="celula"><strong>Modulado</strong></td>
		<td width="6%" align="center" class="celula"><strong>Saldo</strong></td>
		<td width="6%" align="center" class="celula"><strong>M&aacute;ximo</strong></td>
		<td width="7%" align="center" class="celula"><strong>Saldo</strong></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
	intPagina = 1
	cont = 0
	
	sql = " select c.codigo, c.nome, f.Tipo_Funcao, c.codFuncional, c.cod_nivel, c.situacao, c.cpf, tu.Desc_Turno as turno, "
	sql = sql & " c.codFuncao, isnull(n.Descricao,'NAO_INFORMADO') as nivel, f.Desc_Funcao as funcao, ca.desc_categoria as categoria, "
	sql = sql & " isnull(n.total_aulas,0) as total_aulas_nivel, c.total_aulas, isnull(c.carga_horario_contratada,0) as carga_horario_contratada, c.cod_empresa, e.razaosocial"
	sql = sql & " from srh_colaborador c"
	sql = sql & " inner join seg_empresa e on e.codigo = c.codLotacao"
	if request("cmbNivel")<>"0" and request("cmbNivel")<>"" then
		sql = sql & " left join srh_nivel n on n.codigo = " & request("cmbNivel")
	else
		sql = sql & " left join srh_nivel n on n.codigo = c.cod_nivel"
	end if
	
	sql = sql & " left join SRH_MODULACAO_DISCIPLINAR_DOCENTE DD ON  dd.Cod_Colaborador = C.codigo "
	sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = c.codfuncao "
	sql = sql & " left join SRH_CATEGORIA ca on ca.Cod_Categoria = c.CodCategoria "
	sql = sql & " left join SRH_TURNO tu on tu.Cod_Turno = c.CodTurno "
	sql = sql & " Where 1=1"
	
	IF intCodEmpresaGrupo<>"0" THEN
		sql = sql & " and c.codLotacao = " & intCodEmpresaGrupo 
	END IF
	
	sql = sql & " And dd.ano_letivo = " & strAnoLetivo
	
	if intCodColaboradorModulacao <> "0" then
		sql = sql & " And c.codigo = " & intCodColaboradorModulacao 
	end if
	
	if strTipoModulacao <> "" then
		sql = sql & " And f.Tipo_Funcao = '" & strTipoModulacao & "'"
	end if
	
	if intCodTurno <> "0" then
		sql = sql & " And tu.cod_turno = " & intCodTurno
	end if
	
	if intCodFuncao <> "0" then
		sql = sql & " And f.cod_funcao = " & intCodFuncao 
	end if
	
	sql = sql & " and c.Situacao = 'A'"
	sql = sql & " and F.Modular = 'S'"
	sql = sql & " order by funcao"
    rs.open sql, cnn
	if not rs.eof then 
	   
	   mostraCabecalho
	   
	   intCodCodFuncionalAnt = 0
	   
	   While not rs.eof
	   	
		
		intCodColaborador	= rs("Codigo")
		intCodEmp           = rs("Cod_Empresa")
		strnome 			= Trim(Rs("nome"))
		intCodFuncional		= Trim(Rs("CodFuncional"))
		strNivel			= Trim(Rs("nivel"))
		if request("cmbNivel")<>"0" and request("cmbNivel")<>"" then	
			intCodNivel = request("cmbNivel")
		else
		intCodNivel			= Trim(Rs("cod_nivel"))
		end if
		strFuncao			= Trim(Rs("funcao"))
		strTurnoContratado	= rs("turno")
		strCategoria		= Trim(Rs("categoria"))
		intContratado	 	= rs("total_aulas")
		intContratadoNivel	= rs("total_aulas_nivel")
		strTipo_Funcao		= rs("Tipo_Funcao")
		
		strDesabilitaProfessor = ""
		if strTipo_Funcao = "PROFESSOR" and Trim(Request.Form("optTipoModulacao"))="" then
		strTipoModulacao = "PROFESSOR"
		end if
		if strTipo_Funcao = "FUNCIONARIO" and Trim(Request.Form("optTipoModulacao"))="" then
		strTipoModulacao = "FUNCIONARIO"
		strDesabilitaProfessor = " disabled "
		end if
		if strTipo_Funcao <> "FUNCIONARIO" OR intContratadoNivel > 0 THEN
			strDesabilitaProfessor = ""
		end if	
		strCPF  			= Trim(Rs("CPF"))
		strSituacaoColaborador = rs("situacao")
		intCodFuncaoColaborador		= rs("codFuncao")
	   
		intModulado = "0"
		if trim(rs("codigo")) <> "" then
		
			sql = "select isnull(sum(Total_Aulas),0) as modulado, situacao_disciplinar "
			sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE"
			sql = sql & " where Cod_Colaborador = " & trim(rs("codigo"))
			sql = sql & " and status = 'A'"
			sql = sql & " and cod_turno is not null"
			sql = sql & " and ano_letivo = " & strAnoLetivo
			sql = sql & " and tipo_contratacao is not null group by situacao_disciplinar"
			rsAux.open sql, cnn
			if rsAux.eof = false then
				intModulado = rsAux("modulado")
				if isnull(intModulado) then intModulado = "0"
				if trim(rsAux("situacao_disciplinar")) = "I" then
					intModulado = rsAux("modulado") * 21 ' intContratadoNivel
				end if
			end if
			rsAux.close
			
		end if
		if intCodFuncao = "" then intCodFuncao = "0"
	
		strSomenteProfessor = ""
		if intContratadoNivel = "" then intContratadoNivel = 0
		if cInt(intContratadoNivel) = 14 then
			intContratadoMaximo = 20
		elseif cInt(intContratadoNivel) = 21 then
			intContratadoMaximo = 27
		elseif cInt(intContratadoNivel) = 28 then
			intContratadoMaximo = 42
		elseif cInt(intContratadoNivel) >= 42 then
			intContratadoMaximo = 42
		end if
	
		intSaldoContratado = 0
		if intContratado<>"" and intModulado<>"" then
			intSaldoContratado = intContratado - intModulado
		end if	
		
		if intSaldoPositivo = "S" then
		
			if intSaldoContratado > 0 and intContratadoNivel > 0 then 
			
				strCor = "" 
				
				if cint(intModulado ) < cint(intContratadoNivel) then
					
					if trim(rs("CodFuncional")) <> intCodCodFuncionalAnt then
					
					intCodCodFuncionalAnt = trim(rs("CodFuncional"))
					
					cont = cont + 1
									
			  %>
                  <tr bgcolor="<%=strCor%>">
                    <td class="celula" align="left"><%=Trim(Rs("razaosocial"))%></td>
                  <td class="celula" align="left"><span class="celula9"><%=trim(rs("CodFuncional"))%> - <%=trim(rs("nome"))%></span></td>
                  <td class="celula" align="left"><%=Trim(Rs("categoria"))%></td>
                  <td align="left" class="celula"><span class="celula9"><%=strFuncao%></span></td>
                  <td align="left" class="celula"><span class="celula9"><%=strNivel%></span></td>
                  <td class="celula" align="left"><span class="celula9"><%=strTurnoContratado%></span></td>
                  <td class="celula" align="center"><span class="celula9"><%=intContratadoNivel%></span></td>
                  <td align="center" class="celula"><span class="celula9">&nbsp;<%=intModulado%></span></td>
                  <td align="center" class="celula"><span class="celula9"><%=intSaldoContratado%></span></td>
                  <td align="center" class="celula"><span class="celula9"><%=intContratadoMaximo%></span></td>
                  <td align="center" class="celula"><%=intContratadoMaximo-intModulado%>&nbsp;</td>
                </tr>
            <%
				end if
				
				else
					strCor = ""
				end if
			end if
		  else  
		  		if trim(rs("CodFuncional")) <> intCodCodFuncionalAnt then
					
					intCodCodFuncionalAnt = trim(rs("CodFuncional"))
					cont = cont + 1
			  %>
			  <tr>
			    <td class="celula" align="left"><%=Trim(Rs("razaosocial"))%></td>
			  <td class="celula" align="left"><span class="celula9"><%=trim(rs("CodFuncional"))%> - <%=trim(rs("nome"))%></span></td>
			  <td class="celula" align="left"><%=Trim(Rs("categoria"))%></td>
			  <td align="left" class="celula"><span class="celula9"><%=strFuncao%></span></td>
			  <td align="left" class="celula"><span class="celula9"><%=strNivel%></span></td>
			  <td class="celula" align="left"><span class="celula9"><%=strTurnoContratado%></span></td>
			  <td class="celula" align="center"><span class="celula9"><%=intContratadoNivel%></span></td>
			  <td align="center" class="celula"><span class="celula9">&nbsp;<%=intModulado%></span></td>
			  <td align="center" class="celula"><span class="celula9"><%=intSaldoContratado%></span></td>
			  <td align="center" class="celula"><span class="celula9"><%=intContratadoMaximo%></span></td>
			  <td align="center" class="celula"><%=intContratadoMaximo-intModulado%>&nbsp;</td>
	  </tr>
	   <%
			  	 end if
		  end if
		  
	 	  'quantidade de registros da página
		  if int(intQtdeRegistroPorPagina) = int(strlpp) - 1 then
			 intPagina = intPagina + 1
			 intQtdeRegistroPorPagina = 1
			 fimTabela
			 %>
			 <pre></pre>				
		 	 <%			
			 mostraCabecalho
	 	  end if	
		  
		  intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
		  rs.movenext
	   wend
	   %>
	   <tr>
	   <td colspan="15" bgcolor="#CCCCCC" class="celula">Total Registros :<%=cont%></td>
      </tr>
   <%
	else
		%>
		  <tr>
			<td height="12" colspan="15" align="center" class="celula"><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
	  </tr>
		<%
	end if
	rs.close
%>
</table>
<br>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
