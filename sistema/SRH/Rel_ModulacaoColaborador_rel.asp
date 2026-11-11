<%
if request("exportar") = "" then
	Response.Buffer = false
end if
Server.ScriptTimeOut = 9999

paginaatual = request.ServerVariables("SCRIPT_NAME")
nomeDocSalvo = "relatorioModulacaoColaborador"

dim intPagina
	
strAnoLetivo 					= Trim(Request("txtAnoLetivo"))
strTituloRelatorio  			= "Relatório Modulação Colaborador"

pagina							= "Rel_ModulacaoColaborador_con.asp"
intCodColaborador				= Trim(Request("txtCodFuncionario"))
intCodFuncional  				= Trim(Request("txtCodigoFuncional"))
strnome 						= Trim(Request("txtNomeFuncionario"))

strSemestre 					= session("strSemestre")
intCodEmpresa 					= Session("CodEmpresa")
intCodGrupo 					= Session("CodGrupo")
intCodEmpresaGrupo				= Trim(Request("cmbEmpresaGrupo"))

intCodFuncao					= Trim(Request("cmbFuncao"))
intCodPeriodo					= Trim(Request("cmbPeriodo"))
intCodCursoCombo				= Trim(Request("cmbCursoCombo"))
intCodColaboradorModulacao		= Trim(Request("cmbColaboradorModulacao"))	

intCodTurno						= Trim(Request("cmbTurno"))
intCodDisciplina 				= Trim(Request("cmbDisciplina"))
intTotalAulas 					= Trim(Request("txtTotalAulas"))
strSituacao						= Trim(Request("cmbSituacao"))	
strTipoLancamento				= Trim(Request("optTipoLancamento"))	
strTipoModulacao				= Trim(Request("optTipoModulacao"))	
strPorPeriodo					= Trim(Request("optPorPeriodo"))
strClassificacao  				= Trim(Request("cmbClassificacao"))

intCodTurnoColaborador = intCodTurno
	
if intCodColaboradorModulacao = "" then intCodColaboradorModulacao = "0"
if intCodTurnoColaborador = "" then intCodTurnoColaborador = "0"
if intCodTurno = "" then intCodTurno = "0"

if intCodFuncao = "" then intCodFuncao = "0"
if intCodPeriodo = "" then intCodPeriodo = "0"
if intCodDisciplina = "" then intCodDisciplina = "0"
if intCodColaborador = "" then intCodColaborador = "0"
if intCodCursoCombo = "" then intCodCursoCombo = "0"
if strSituacao = "" then strSituacao = "A"

strExportarWord 	= paginaatual & "?exportar=w&txtAnoLetivo=" & strAnoLetivo & "&txtCodFuncionario=" & intCodColaborador & "&txtCodigoFuncional=" & intCodFuncional & "&txtNomeFuncionario=" & strnome & "&cmbEmpresaGrupo=" & intCodEmpresaGrupo & "&cmbFuncao=" & intCodFuncao	& "&cmbPeriodo=" & intCodPeriodo & "&cmbCursoCombo=" & intCodCursoCombo & "&cmbColaboradorModulacao=" & intCodColaboradorModulacao & "&cmdEmpresaUsuario=" & intCodEmpresaUsuario & "&cmbMes=" & strMes & "&txtDataInicialAdmissao=" & strDataInicialAdmissao & "&cmbTurno=" & intCodTurno & "&cmbDisciplina=" & intCodDisciplina	 & "&txtTotalAulas=" & intTotalAulas & "&cmbSituacao=" & strSituacao & "&optTipoLancamento=" & strTipoLancamento & "&optTipoModulacao=" & strTipoModulacao & "&optPorPeriodo=" & strPorPeriodo & "&cmbClassificacao=" & strClassificacao
strExportarExcel 	= paginaatual & "?exportar=e&txtAnoLetivo=" & strAnoLetivo & "&txtCodFuncionario=" & intCodColaborador & "&txtCodigoFuncional=" & intCodFuncional & "&txtNomeFuncionario=" & strnome & "&cmbEmpresaGrupo=" & intCodEmpresaGrupo & "&cmbFuncao=" & intCodFuncao	& "&cmbPeriodo=" & intCodPeriodo & "&cmbCursoCombo=" & intCodCursoCombo & "&cmbColaboradorModulacao=" & intCodColaboradorModulacao & "&cmdEmpresaUsuario=" & intCodEmpresaUsuario & "&cmbMes=" & strMes & "&txtDataInicialAdmissao=" & strDataInicialAdmissao & "&cmbTurno=" & intCodTurno & "&cmbDisciplina=" & intCodDisciplina	 & "&txtTotalAulas=" & intTotalAulas & "&cmbSituacao=" & strSituacao & "&optTipoLancamento=" & strTipoLancamento & "&optTipoModulacao=" & strTipoModulacao & "&optPorPeriodo=" & strPorPeriodo & "&cmbClassificacao=" & strClassificacao
%>
<html>
<head>
<title><%=session("Titulo")%></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%	if request("exportar") = "" then %>
    <link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
	<script src="../../js/js_funcoes_gerais.js"></script>
	<script src="../../js/js_barra_movel.js"></script>
<%	end if %>

</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
if request("exportar") = "" then 
    %><!--#include file="../../includes/inc_Botoes_relatorio_word_excel.asp"--><%
end if
%>
<%	if request("exportar") = "" then %>
	<!--#include file="../../includes/inc_aguarde.asp"-->
<%	end if 
	
	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
	    <td height="21" colspan="16" align="center" class="celula"><strong>Modula&ccedil;&atilde;o Colaborador</strong></td>
      </tr>
	  <tr bgcolor="#CCCCCC">
	    <td width="3%" class="celula">Matrícula</td>
	    <td width="18%" class="celula">Professor</td>
		<td width="18%" height="19" class="celula">Unidade</td>
		<td width="18%" class="celula">Fun&ccedil;&atilde;o</td>
		<td width="10%" class="celula">Datas</td>
		<td width="1%" class="celula">Ano</td>
		<td width="4%" class="celula">Per&iacute;odo</td>
		<td width="5%" class="celula">Turno</td>
		<td width="7%" class="celula">Sit. Disciplinar</td>
		<td width="7%" class="celula">Disciplina</td>
		<td width="2%" align="center" class="celula">Aulas/Entrada</td>
		<td width="10%" class="celula">Origem</td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
	intPagina = 1
	
	sql = "select dd.Codigo, dd.Situacao_disciplinar, p.Descricao as periodo, t.desc_turno as turno, dd.Total_Aulas, c.codFuncional,"
	sql = sql & " dd.tipo_contratacao, dd.periodo_inicial, dd.periodo_final, dd.DataInicial, dd.DataFinal, "
	sql = sql & " dd.Ano_letivo, dd.Semestre, e.RAZAOSOCIAL, "
	sql = sql & " f.Desc_Funcao as funcao, isnull(dd.Cod_Substituicao,'0') as Cod_Substituicao,"
	sql = sql & " c.nome, "
	sql = sql & " d.Desc_Disciplina as disciplina, dd.status, "
	sql = sql & " TOPC.Desc_Turno AS TurnoOpcional "
	sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE dd "
	sql = sql & " inner join SEG_EMPRESA e on e.CODIGO = dd.Cod_empresa "
	sql = sql & " left join SRH_COLABORADOR C ON C .codigo = dd.Cod_Colaborador"
	sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = dd.cod_funcao"
	sql = sql & " left join SCA_disciplina d on d.cod_disciplina = dd.cod_disciplina"
	sql = sql & " left join SCA_periodo p on p.cod_periodo = dd.cod_periodo"
	sql = sql & " left join SCA_Curso CU on CU.Cod_curso = p.Cod_Curso"
	sql = sql & " left join SRH_TURNO t on t.cod_turno = dd.cod_turno"
	sql = sql & " left join SRH_TURNO TOPC on TOPC.cod_turno = dd.Cod_turno_opcional"
	sql = sql & " Where dd.ano_letivo = " & strAnoLetivo
	sql = sql & " AND E.COD_GRUPO = " & intCodGrupo
	
	if strPorPeriodo <> "T" then
		sql = sql & " And dd.tipo_contratacao = '"  & strPorPeriodo & "'"
	end if
			
	if intCodEmpresaGrupo <> "0" then 
		sql = sql & " And e.codigo = " & intCodEmpresaGrupo
	end if
	
	if intCodColaborador <> "0" then
		sql = sql & " And dd.Cod_Colaborador = " & intCodColaborador	
	end if
	
	if strTipoLancamento <> "" then 
		sql = sql & " And dd.Situacao_disciplinar = '" & strTipoLancamento & "'"
	end if
	
	if intCodTurno <> "0" then
		sql = sql & " And dd.cod_turno = " & intCodTurno
	end if
	
	if intCodFuncao <> "0" then
		sql = sql & " And dd.cod_funcao = " & intCodFuncao 
	end if

	if intCodPeriodo <> "0" then
		sql = sql & " And dd.cod_periodo = " & intCodPeriodo 
	end if

	if intCodCursoCombo <> "0" then
		sql = sql & " And CU.Cod_curso = " & intCodCursoCombo 
	end if
	
	if intCodDisciplina <> "0" then
		sql = sql & " And dd.cod_disciplina = " & intCodDisciplina 
	end if
			
	if strSituacao <> "" AND strSituacao <> "0" then
		sql = sql & " And dd.status = '" & strSituacao & "'"
	end if
	
	if strTipoModulacao <> "" then
		sql = sql & " And dd.tipoModulacao = '" & strTipoModulacao & "'"
	end if
	
	if strClassificacao = "1" or strClassificacao = "" then 
		sql = sql & " order by c.nome"
	end if
	
	if strClassificacao = "2" then 
		sql = sql & " order by RAZAOSOCIAL"
	end if
	
	if strClassificacao = "3" then 
		sql = sql & " order by Desc_Funcao"
	end if
	
	if strClassificacao = "4" then 
		sql = sql & " order by periodo"
	end if
	
	if strClassificacao = "5" then 
		sql = sql & " order by desc_turno"
	end if
	
	if strClassificacao = "6" then 
		sql = sql & " order by disciplina"
	end if
	'response.write sql
    rs.open sql, cnn
	if not rs.eof then 
	   
	   mostraCabecalho
	   
	   TotalAulas = "0"
	   cont = 0
				
	   While not rs.eof
	   	 cont = cont + 1	
		
		strSituacaoDisciplinar = rs("Situacao_disciplinar")
		if strSituacaoDisciplinar = "D" then strSituacaoDisciplinar = "Disciplinar"
		if strSituacaoDisciplinar = "I" then strSituacaoDisciplinar = "Interdisciplinar"
		
		if rs("Cod_Substituicao") = "0" then 
			strorigem = "CONTRATUAL"	
		else				
			strorigem = "SUBSTITUICAO"	
		end if
				   
		periodo = ""
		tipo = "Contratual"
		cor = "#FFFFFF"
		if rs("tipo_contratacao") = "A" then 
			periodo = "&nbsp;" & formatadataAP(rs("periodo_inicial")) & " a " & formatadataAP(rs("periodo_final"))
			tipo = "Adicional"
			cor = "#C6E2FF"
			strorigem = "PER&Iacute;ODO"
		else
			periodo = "&nbsp;" & formatadataAP(rs("DataInicial")) & " a " & formatadataAP(rs("DataFinal"))
		end if
		link = "onClick='return resultadoConsulta(" & rs("codigo") & ")'"
		if trim(rs("status")) <> "A" then 
		cor = "#C0C0C0"
		link = ""
		end if
		
		if rs("Cod_Substituicao") <> "0" then 
			cor = "#C0C0C0"
			link = ""
		end if
		
		if strNomeAnt = "" then
			strNomeAnt = rs("nome")
		end if
		
		if strCodFuncionalAnt = "" then
			strCodFuncionalAnt = rs("codFuncional")
		end if
		
		if rs("Situacao_disciplinar") = "I" then
			intTAulas = rs("Total_Aulas")*21
		else
			intTAulas = rs("Total_Aulas")
		end if
		
		if trim(rs("TurnoOpcional")) <> "" then 
			strTurno = trim(rs("TurnoOpcional"))
		else
			strTurno = trim(rs("turno"))
		end if
		
		'Regra para Funcionario
		if strTipoModulacao = "FUNCIONARIO" and  strTurno = "INTEGRAL" then
			intTAulas = rs("Total_Aulas")*42
		end if 
					
		
		if strNomeAnt = trim(rs("nome")) then
			'TotalAulas = TotalAulas + cint(rs("Total_Aulas"))
			TotalAulas = TotalAulas + intTAulas
		end if
		
		if strNomeAnt <> trim(rs("nome")) then
			
			strNome = trim(rs("nome"))
			strMatricula = trim(rs("codFuncional"))
			
			strNomeAnt = trim(rs("nome"))
			strCodFuncionalAnt = trim(rs("codFuncional"))
							
			if TotalAulas <> "0" then
				%>
				<tr><td height="26" colspan="10" align="right" bgcolor="#FFFFCC" class="celula"><span class="texto">Total :&nbsp;</span></td>
					<td align="center" bgcolor="#FFFFCC" class="celula"><%=trim(TotalAulas)%></td>
					<td height="26" bgcolor="#FFFFCC" class="celula">&nbsp;</td>
				</tr>
				<%
				TotalAulas = 0
			end if
			TotalAulas = TotalAulas + intTAulas
		else
			
			if cont = 1 then
				strNome = rs("nome")
				strMatricula = trim(rs("codFuncional"))
			else
				
				if trim(rs("nome")) <> strNomeAnt then
					strNome = rs("nome")
					strMatricula = trim(rs("codFuncional"))
				else
					strNome = ""
					strMatricula = ""
				end if
			end if
							
		end if	
						
	      %>
		  <tr  bgcolor="<%=cor%>" >
		    <td class="celula" align="left">&nbsp;<%=trim(strMatricula)%></td>
            <td class="celula" align="left">&nbsp;<%=trim(strNome)%></td>
              <td class="celula" align="left">&nbsp;<%=trim(rs("RAZAOSOCIAL"))%></td>
              <td class="celula" align="left">&nbsp;<%=trim(rs("funcao"))%></td>
              <td align="left" class="celula">&nbsp;<%=periodo%></td>
              <td align="left" class="celula"><div align="center">&nbsp;<%=trim(rs("Ano_letivo"))%></div></td>
              <td align="left" class="celula">&nbsp;<%=trim(rs("periodo"))%></td>
              <td align="left" class="celula">&nbsp;<%=trim(strTurno)%></td>
              <td class="celula" align="left">&nbsp;<%=strSituacaoDisciplinar%></td>
              <td class="celula" align="left">&nbsp;<%=trim(rs("disciplina"))%></td>
              <td align="center" class="celula">&nbsp;<%=intTAulas%></td>
            <td align="left" class="celula"><span class="celula9">&nbsp;<%=trim(strorigem)%></span></td>
	  	  </tr>
		  <%
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
		 ' cont = cont + 1
		  intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
		  Total_Aulas = Total_Aulas + intTAulas
		  rs.movenext
	   wend
	   %>
        <tr><td height="26" colspan="10" align="right" bgcolor="#FFFFCC" class="celula"><span class="texto">Total :&nbsp;</span></td>
                                <td align="center" bgcolor="#FFFFCC" class="celula"><%=TotalAulas%></td>
          <td height="26" bgcolor="#FFFFCC" class="celula">&nbsp;</td>
                            </tr>
	   <tr>
	   <td colspan="16" bgcolor="#CCCCCC" class="celula">Total Registros :<%=cont%></td>
      </tr>
	   <%
	else
		%>
		  <tr>
			<td height="12" colspan="16" align="center" class="celula"><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
	  </tr>
		<%
		
	end if
	rs.close
%>
</table>
<%
	if request("exportar") = "w" then 
		Response.ContentType = "application/vnd.ms-word"
        Response.AddHeader "content-disposition","attachment;filename="&nomeDocSalvo&".doc"
	elseif request("exportar") = "e" then 
		Response.ContentType = "application/vnd.ms-excel"
        Response.AddHeader "content-disposition","attachment;filename="&nomeDocSalvo&".xls"
	end if


%>

<script>
	aguarde.style.display="none";
</script>
</body>
</html>
