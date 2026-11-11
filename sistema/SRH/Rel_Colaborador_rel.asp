<%
if request("exportar") = "" then
	Response.Buffer = false
end if
Server.ScriptTimeOut = 9999
paginaatual = request.ServerVariables("SCRIPT_NAME")
nomeDocSalvo = "relatorioColaborador"

dim intPagina
dim strInfoTurma

strFiltro01	 			= Trim(Request("filtro01"))
strFiltro02	 			= Trim(Request("filtro02"))
strFiltro03	 			= Trim(Request("filtro03"))
strFiltro04	 			= Trim(Request("filtro04"))
strFiltro05	 			= Trim(Request("filtro05"))
strFiltro06	 			= Trim(Request("filtro06"))
strFiltro07	 			= Trim(Request("filtro07"))
strFiltro08	 			= Trim(Request("filtro08"))
strFiltro09	 			= Trim(Request("filtro09"))
strFiltro10	 			= Trim(Request("filtro10"))
strFiltro11	 			= Trim(Request("filtro11"))
strFiltro12	 			= Trim(Request("filtro12"))
strFiltro13	 			= Trim(Request("filtro13"))
strFiltro14	 			= Trim(Request("filtro14"))
strFiltro15	 			= Trim(Request("filtro15"))
strFiltro16	 			= Trim(Request("filtro16"))
strFiltro17	 			= Trim(Request("filtro17"))
strFiltro18	 			= Trim(Request("filtro18"))
strFiltro19	 			= Trim(Request("filtro19"))
strFiltro20	 			= Trim(Request("filtro20"))
strFiltro21	 			= Trim(Request("filtro21"))
strFiltro22	 			= Trim(Request("filtro22"))
strFiltro23	 			= Trim(Request("filtro23"))
strFiltro24	 			= Trim(Request("filtro24"))
strFiltro25	 			= Trim(Request("filtro25"))
strFiltro26	 			= Trim(Request("filtro26"))
strFiltro27	 			= Trim(Request("filtro27"))
strFiltro28	 			= Trim(Request("filtro28"))
strFiltro29	 			= Trim(Request("filtro29"))
strFiltro30	 			= Trim(Request("filtro30"))
strFiltro31	 			= Trim(Request("filtro31"))
strFiltro32	 			= Trim(Request("filtro32"))
strFiltro33	 			= Trim(Request("filtro33"))
strFiltro34	 			= Trim(Request("filtro34"))
strFiltro35	 			= Trim(Request("filtro35"))
strFiltro36	 			= Trim(Request("filtro36"))
strFiltro37 			= Trim(Request("filtro37"))
strFiltro38 			= Trim(Request("filtro38"))
strFiltro39 			= Trim(Request("filtro39"))
strFiltro40 			= Trim(Request("filtro40"))
strFiltro41 			= Trim(Request("filtro41"))

strSituacao					= Trim(Request("cmbSituacao"))	
intCodCategoria				= Trim(Request("cmbCategoria"))	
intCodCargoCategoria			= Trim(Request("cmbCargoCategoria"))	
intCodDepartamento			= Trim(Request("cmbDepartamento"))
intCodCargo 	    		= TRIM(Request("cmbCargo"))
intCodFuncao 	    		= TRIM(Request("cmbFuncao"))
intCodTurno 	    		= TRIM(Request("cmbTurno"))
intCodGrauInstrucao			= Trim(Request("cmbGrauInstrucao"))	
intcodLotacao 	    		= TRIM(Request("cmbLotacao"))
intCodFormaNomeacao 		= TRIM(Request("cmbFormaNomeacao"))
intCodEmpresaUsuario 	    = TRIM(Request("cmdEmpresaUsuario"))
strMes		 	        	= Trim(Request("cmbMes"))
strClassificacao			= request("cmbClassificacao")

strDataInicialAdmissao		= TRIM(Request("txtDataInicialAdmissao"))
strDataFinalAdmissao		= TRIM(Request("txtDataFinalAdmissao"))

strDataInicialLotacao		= TRIM(Request("txtDataInicialLotacao"))
strDataFinalLotacao			= TRIM(Request("txtDataFinalLotacao"))

strDataInicialAfastamento	= TRIM(Request("txtDataInicialAfastamento"))
strDataFinalAfastamento		= TRIM(Request("txtDataFinalAfastamento"))
readaptacao		= TRIM(Request("readaptacao"))

if strMes = "" then strMes ="0"

strTituloRelatorio  	= "Relação de Colaboradores"

strExportarWord 	= paginaatual & "?exportar=w&cmbSituacao=" & strSituacao & "&cmbCategoria=" & intCodCategoria & "&cmbDepartamento=" & intCodDepartamento & "&cmbCargo=" & intCodCargo & "&cmbFuncao=" & intCodFuncao & "&cmbTurno=" & intCodTurno	& "&cmbGrauInstrucao=" & intCodGrauInstrucao & "&cmbLotacao=" & intcodLotacao & "&cmbFormaNomeacao=" & intCodFormaNomeacao & "&cmdEmpresaUsuario=" & intCodEmpresaUsuario & "&cmbMes=" & strMes & "&cmbClassificacao=" & strClassificacao & "&filtro01=" & strFiltro01 & "&filtro02=" & strFiltro02 & "&filtro03=" & strFiltro03 & "&filtro04=" & strFiltro04 & "&filtro05=" & strFiltro05 & "&filtro06=" & strFiltro06 & "&filtro07=" & strFiltro07 & "&filtro08=" & strFiltro08 & "&filtro09=" & strFiltro09 & "&filtro10=" & strFiltro10 & "&filtro11="& strFiltro11 & "&filtro12=" & strFiltro12 & "&filtro13=" & strFiltro13 & "&filtro14=" & strFiltro14 & "&filtro15=" & strFiltro15 & "&filtro16=" & strFiltro16 & "&filtro17=" & strFiltro17 & "&filtro18=" & strFiltro18 & "&filtro19=" & strFiltro19 & "&filtro20=" & strFiltro20 & "&filtro21=" & strFiltro21 & "&filtro22=" & strFiltro22 & "&filtro23=" & strFiltro23 & "&filtro24=" & strFiltro24 & "&filtro25=" & strFiltro25 & "&filtro26=" & strFiltro26 & "&filtro27=" & strFiltro27 & "&filtro28=" & strFiltro28 & "&filtro29=" & strFiltro29 & "&filtro30=" & strFiltro30 & "&filtro31=" & strFiltro31 & "&filtro32=" & strFiltro32 & "&filtro33=" & strFiltro33 & "&filtro34=" & strFiltro34 & "&filtro35=" & strFiltro35 & "&filtro36=" & strFiltro36 & "&filtro37=" & strFiltro37 & "&filtro38=" & strFiltro38 & "&filtro39=" & strFiltro39 & "&filtro40=" & strFiltro40 & "&filtro41=" & strFiltro41 & "&txtDataInicialAdmissao=" & formatadataBD(strDataInicialAdmissao) & "&txtDataFinalAdmissao=" & formatadataBD(strDataFinalAdmissao) & "&txtDataInicialLotacao=" & formatadataBD(strDataInicialLotacao) & "&txtDataFinalLotacao=" & formatadataBD(strDataFinalLotacao) & "&txtDataInicialAfastamento=" & formatadataBD(strDataInicialAfastamento) & "&txtDataFinalAfastamento=" & formatadataBD(strDataFinalAfastamento)
												 								 
strExportarExcel 	= paginaatual & "?exportar=e&cmbSituacao=" & strSituacao & "&cmbCategoria=" & intCodCategoria & "&cmbDepartamento=" & intCodDepartamento 
strExportarExcel 	= strExportarExcel & "&cmbCargoCategoria=" & intCodCargoCategoria
strExportarExcel 	= strExportarExcel & "&cmbCargo=" & intCodCargo & "&cmbFuncao=" & intCodFuncao & "&cmbTurno=" & intCodTurno	& "&cmbGrauInstrucao=" & intCodGrauInstrucao 
strExportarExcel	= strExportarExcel & "&cmbLotacao=" & intcodLotacao & "&cmbFormaNomeacao=" & intCodFormaNomeacao & "&cmdEmpresaUsuario=" & intCodEmpresaUsuario 
strExportarExcel	= strExportarExcel & "&cmbMes=" & strMes & "&cmbClassificacao=" & strClassificacao 
strExportarExcel	= strExportarExcel & "&filtro01=" & strFiltro01 & "&filtro02=" & strFiltro02 & "&filtro03=" & strFiltro03 & "&filtro04=" & strFiltro04 & "&filtro05=" & strFiltro05 
strExportarExcel	= strExportarExcel & "&filtro06=" & strFiltro06 & "&filtro07=" & strFiltro07 & "&filtro08=" & strFiltro08 & "&filtro09=" & strFiltro09 & "&filtro10=" & strFiltro10 
strExportarExcel	= strExportarExcel & "&filtro11=" & strFiltro11 & "&filtro12=" & strFiltro12 & "&filtro13=" & strFiltro13 & "&filtro14=" & strFiltro14 & "&filtro15=" & strFiltro15 
strExportarExcel	= strExportarExcel & "&filtro16=" & strFiltro16 & "&filtro17=" & strFiltro17 & "&filtro18=" & strFiltro18 & "&filtro19=" & strFiltro19 & "&filtro20=" & strFiltro20 
strExportarExcel	= strExportarExcel & "&filtro21=" & strFiltro21 & "&filtro22=" & strFiltro22 & "&filtro23=" & strFiltro23 & "&filtro24=" & strFiltro24 & "&filtro25=" & strFiltro25 
strExportarExcel	= strExportarExcel & "&filtro26=" & strFiltro26 & "&filtro27=" & strFiltro27 & "&filtro28=" & strFiltro28 & "&filtro29=" & strFiltro29 & "&filtro30=" & strFiltro30 
strExportarExcel	= strExportarExcel & "&filtro31=" & strFiltro31 & "&filtro32=" & strFiltro32 & "&filtro33=" & strFiltro33 & "&filtro34=" & strFiltro34 & "&filtro35=" & strFiltro35 
strExportarExcel	= strExportarExcel & "&filtro36=" & strFiltro36 & "&filtro37=" & strFiltro37 & "&filtro38=" & strFiltro38 & "&filtro39=" & strFiltro39 & "&filtro40=" & strFiltro40 
strExportarExcel	= strExportarExcel & "&filtro41=" & strFiltro41 

strExportarExcel	= strExportarExcel & "&txtDataInicialAdmissao=" & formatadataBD(strDataInicialAdmissao) & "&txtDataFinalAdmissao=" & formatadataBD(strDataFinalAdmissao) & "&txtDataInicialLotacao=" & formatadataBD(strDataInicialLotacao) & "&txtDataFinalLotacao=" & formatadataBD(strDataFinalLotacao) & "&txtDataInicialAfastamento=" & formatadataBD(strDataInicialAfastamento) & "&txtDataFinalAfastamento=" & formatadataBD(strDataFinalAfastamento)

%>
<html>
<head>
<title><%=session("Titulo")%> - Grade Curricular</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%	if request("exportar") = "" then %>
    <link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
	<script src="../../js/js_funcoes_gerais.js"></script>
<%	end if %>

<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlCodigoEmpresaUsuario.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
<%
if request("exportar") = "" then 
    %><!--#include file="../../includes/inc_Botoes_relatorio_word_excel.asp"--><%
end if
%>
<%	if request("exportar") = "" then %>
<!--#include file="../../includes/inc_aguarde.asp"-->
<%	end if %>

<br>

<%


	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
	    <%if trim(strFiltro31) = "S" then %> 
			<td class="celula" align="center"><strong>Matr&iacute;cula</strong></td>
		<%end if%>  
	    <td class="celula"><div align="center"><strong>Colaborador</strong></div></td>
	  	<%if Session("NivelPermissao") = "A" then%> 
	        <%if trim(strFiltro40) = "S" then %> 
		    <td class="celula" align="center"><strong>Unidade</strong></td>
            <%end if%> 
		<%end if%> 
		<%if trim(strFiltro01) = "S" then %> 
		  	<td class="celula"><div align="center"><strong>Admiss&atilde;o</strong></div></td>
		<%end if%>  
	    <%if trim(strFiltro02) = "S" then %> 
			<td class="celula"><div align="center"><strong>Endere&ccedil;o </strong></div></td>
		<%end if%>  
	    <%if trim(strFiltro03) = "S" then %> 
			<td class="celula"><div align="center"><strong>Bairro</strong></div></td>
		<%end if%>  
	    <%if trim(strFiltro04) = "S" then %> 
			<td class="celula"><div align="center"><strong>Cidade/U.F</strong></div></td>
		<%end if%>  
	    <%if trim(strFiltro05) = "S" then %> 
			<td class="celula"><div align="center"><strong>C.E.P</strong></div></td>
		<%end if%>  
	    <%if trim(strFiltro06) = "S" then %> 
			<td class="celula"><strong>Fone Res/Com </strong></td>
		<%end if%>  
	    <%if trim(strFiltro07) = "S" then %> 
			<td class="celula"><strong>Celular</strong></td>
		<%end if%>  
	    <%if trim(strFiltro08) = "S" then %> 
			<td class="celula"><strong>Email</strong></td>
		<%end if%>  
	    <%if trim(strFiltro09) = "S" then %> 
			<td class="celula"><strong>Nome do Pai</strong></td>
		<%end if%>  
	    <%if trim(strFiltro10) = "S" then %> 
			<td class="celula"><strong>Nome da Mae </strong></td>
		<%end if%>  
	    <%if trim(strFiltro11) = "S" then %> 
			<td class="celula"><strong>D. Nascimento </strong></td>
		<%end if%>  
	    <%if trim(strFiltro12) = "S" then %> 
			<td class="celula"><strong>Naturalidade</strong></td>
		<%end if%>  
	    <%if trim(strFiltro13) = "S" then %> 
			<td class="celula"><div align="center"><strong>Nacionalidade</strong></div></td>
		<%end if%>  
        <%if trim(strFiltro14) = "S" then %> 
			<td class="celula"><strong>Estado Civil </strong></td>
		<%end if%>  
	    <%if trim(strFiltro15) = "S" then %> 
			<td class="celula"><strong>Conjugue</strong></td>
		<%end if%>  
	    <%if trim(strFiltro16) = "S" then %> 
			<td class="celula"><strong>N&ordm; Filhos </strong></td>
		<%end if%>  
	    <%if trim(strFiltro17) = "S" then %> 
			<td class="celula"><strong>C.P.F</strong></td>
		<%end if%>  
	    <%if trim(strFiltro18) = "S" then %> 
			<td class="celula" align="center"><strong>Titulo Eleitor </strong></td>
		<%end if%>  
	    <%if trim(strFiltro19) = "S" then %> 
			<td class="celula" align="center"><strong>C.T.P.S</strong></td>
		<%end if%>  
	    <%if trim(strFiltro20) = "S" then %> 
			<td class="celula" align="center"><strong>R.G</strong></td>
		<%end if%>  
	    <%if trim(strFiltro21) = "S" then %> 
			<td class="celula" align="center"><strong>Reservista</strong></td>
		<%end if%>  
	    <%if trim(strFiltro22) = "S" then %> 
			<td class="celula" align="center"><strong>Sexo</strong></td>
		<%end if%>  
	    <%if trim(strFiltro23) = "S" then %> 
			<td class="celula" align="center"><strong>P.I.S</strong></td>
		<%end if%>  
	    <%if trim(strFiltro24) = "S" then %> 
			<td class="celula" align="center"><strong>D. Afastamento </strong></td>
		<%end if%>  
	    <%if trim(strFiltro25) = "S" then %> 
			<td class="celula" align="center"><strong>Situa&ccedil;&atilde;o</strong></td>
		<%end if%>  
	    <%if trim(strFiltro26) = "S" then %> 
			<td class="celula" align="center"><strong>Categoria</strong></td>
		<%end if%>  
	    <%if trim(strFiltro27) = "S" then %> 
			<td class="celula" align="center"><strong>Instru&ccedil;&atilde;o</strong></td>
		<%end if%>  
	    <%if trim(strFiltro28) = "S" then %> 
			<td class="celula" align="center"><strong>Cargo</strong></td>
		    <%end if%>  
	    <%if trim(strFiltro29) = "S" then %> 
			<td class="celula" align="center"><strong>Função</strong></td>
		<%end if%>  
	    <%if trim(strFiltro30) = "S" then %> 
			<td class="celula" align="center"><strong>Departamento</strong></td>
		<%end if%>  
	    <%if trim(strFiltro32) = "S" then %> 
			<td class="celula" align="center"><strong>Observa&ccedil;&otilde;es</strong></td>
		<%end if%>  
	    <%if trim(strFiltro33) = "S" then %> 
			<td class="celula" align="center"><strong>Login Sistema </strong></td>
		<%end if%>  
	    <%if trim(strFiltro34) = "S" then %> 
			<td class="celula" align="center"><strong>Assinatura</strong></td>
		<%end if%> 
	    <%if trim(strFiltro35) = "S" then %> 
			<td class="celula" align="center"><strong>Nomeação</strong></td>
		<%end if%> 
	    <%if trim(strFiltro36) = "S" then %> 
			<td class="celula" align="center"><strong>Remoção</strong></td>
		<%end if%> 
        <%if trim(strFiltro37) = "S" then %> 
			<td class="celula" align="center"><strong>Turno</strong></td>
		<%end if%> 
        <%if trim(strFiltro38) = "S" then %> 
			<td align="center" class="celula" ><strong>Nivel</strong></td>
            <td align="center" class="celula" ><strong>Horas Semanais</strong></td>
            <td align="center" class="celula" ><strong>Aulas Semanais</strong></td>
            <td align="center" class="celula" ><strong>Tipo Vinculo</strong></td>
        <%end if%> 
        <%if trim(strFiltro39) = "S" then %> 
			<td class="celula" align="center"><strong>Data Lotação</strong></td>
		<%end if%> 
		<%if trim(strFiltro41) = "S" then %> 
		<td class="celula" align="center"><strong>Readaptação</strong></td>
		<%end if%>
	  </tr>
	<%
	end Sub
	
	sub mostraCabecalhoReduzido()
	%>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
	    <%if trim(strFiltro31) = "S" then %> 
			<td class="celula" align="center"><strong>Matr&iacute;cula</strong></td>
		<%end if%>  
	    <td class="celula"><div align="center"><strong>Colaborador</strong></div></td>
	  	<%if Session("NivelPermissao") = "A" then%> 
			<%if trim(strFiltro40) = "S" then %> 
			    <td class="celula"><strong>Unidade</strong></td>
			<%end if %> 
		<%end if%> 
		<%if trim(strFiltro01) = "S" then %> 
		  	<td class="celula"><div align="center"><strong>Admiss&atilde;o</strong></div></td>
		<%end if%>  
	    <%if trim(strFiltro02) = "S" then %> 
			<td class="celula"><div align="center"><strong>Endere&ccedil;o </strong></div></td>
		<%end if%>  
	    <%if trim(strFiltro03) = "S" then %> 
			<td class="celula"><div align="center"><strong>Bairro</strong></div></td>
		<%end if%>  
	    <%if trim(strFiltro04) = "S" then %> 
			<td class="celula"><div align="center"><strong>Cidade/U.F</strong></div></td>
		<%end if%>  
	    <%if trim(strFiltro05) = "S" then %> 
			<td class="celula"><div align="center"><strong>C.E.P</strong></div></td>
		<%end if%>  
	    <%if trim(strFiltro06) = "S" then %> 
			<td class="celula"><strong>Fone Res/Com </strong></td>
		<%end if%>  
	    <%if trim(strFiltro07) = "S" then %> 
			<td class="celula"><strong>Celular</strong></td>
		<%end if%>  
	    <%if trim(strFiltro08) = "S" then %> 
			<td class="celula"><strong>Email</strong></td>
		<%end if%>  
	    <%if trim(strFiltro09) = "S" then %> 
			<td class="celula"><strong>Nome do Pai</strong></td>
		<%end if%>  
	    <%if trim(strFiltro10) = "S" then %> 
			<td class="celula"><strong>Nome da Mae </strong></td>
		<%end if%>  
	    <%if trim(strFiltro11) = "S" then %> 
			<td class="celula"><strong>D. Nascimento </strong></td>
		<%end if%>  
	    <%if trim(strFiltro12) = "S" then %> 
			<td class="celula"><strong>Naturalidade</strong></td>
		<%end if%>  
	    <%if trim(strFiltro13) = "S" then %> 
			<td class="celula"><div align="center"><strong>Nacionalidade</strong></div></td>
		<%end if%>  
        <%if trim(strFiltro14) = "S" then %> 
			<td class="celula"><strong>Estado Civil </strong></td>
		<%end if%>  
	    <%if trim(strFiltro15) = "S" then %> 
			<td class="celula"><strong>Conjugue</strong></td>
		<%end if%>  
	    <%if trim(strFiltro16) = "S" then %> 
			<td class="celula"><strong>N&ordm; Filhos </strong></td>
		<%end if%>  
	    <%if trim(strFiltro17) = "S" then %> 
			<td class="celula"><strong>C.P.F</strong></td>
		<%end if%>  
	    <%if trim(strFiltro18) = "S" then %> 
			<td class="celula"><strong>Titulo Eleitor </strong></td>
		<%end if%>  
	    <%if trim(strFiltro19) = "S" then %> 
			<td class="celula"><strong>C.T.P.S</strong></td>
		<%end if%>  
	    <%if trim(strFiltro20) = "S" then %> 
			<td class="celula"><strong>R.G</strong></td>
		<%end if%>  
	    <%if trim(strFiltro21) = "S" then %> 
			<td class="celula"><strong>Reservista</strong></td>
		<%end if%>  
	    <%if trim(strFiltro22) = "S" then %> 
			<td class="celula"><strong>Sexo</strong></td>
		<%end if%>  
	    <%if trim(strFiltro23) = "S" then %> 
			<td class="celula"><strong>P.I.S</strong></td>
		<%end if%>  
	    <%if trim(strFiltro24) = "S" then %> 
			<td class="celula"><strong>D. Afastamento </strong></td>
		<%end if%>  
	    <%if trim(strFiltro25) = "S" then %> 
			<td class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
		<%end if%>  
	    <%if trim(strFiltro26) = "S" then %> 
			<td class="celula"><strong>Categoria</strong></td>
		<%end if%>  
	    <%if trim(strFiltro27) = "S" then %> 
			<td class="celula"><strong>Instru&ccedil;&atilde;o</strong></td>
		<%end if%>  
	    <%if trim(strFiltro28) = "S" then %> 
			<td class="celula"><strong>Cargo</strong></td>
		    <%end if%>  
	    <%if trim(strFiltro29) = "S" then %> 
			<td class="celula"><strong>Função</strong></td>
		<%end if%>  
	    <%if trim(strFiltro30) = "S" then %> 
			<td class="celula"><strong>Departamento</strong></td>
		<%end if%>  
	    <%if trim(strFiltro32) = "S" then %> 
			<td class="celula"><strong>Observa&ccedil;&otilde;es</strong></td>
		<%end if%>  
	    <%if trim(strFiltro33) = "S" then %> 
			<td class="celula"><strong>Login Sistema </strong></td>
		<%end if%>  
	    <%if trim(strFiltro34) = "S" then %> 
			<td class="celula"><strong>Assinatura</strong></td>
		<%end if%> 
	    <%if trim(strFiltro35) = "S" then %> 
			<td class="celula"><strong>Nomeação</strong></td>
		<%end if%> 
	    <%if trim(strFiltro36) = "S" then %> 
			<td class="celula"><strong>Remoção</strong></td>
		<%end if%> 
        <%if trim(strFiltro37) = "S" then %> 
			<td class="celula"><strong>Turno</strong></td>
		<%end if%> 
        <%if trim(strFiltro38) = "S" then %> 
			<td align="center" class="celula"><strong>Nivel</strong></td>
            <td align="center" class="celula"><strong>Horas Semanais</strong></td>
            <td align="center" class="celula"><strong>Aulas Semanais</strong></td>
            <td align="center" class="celula"><strong>Tipo Vinculo</strong></td>
        <%end if%> 
        <%if trim(strFiltro39) = "S" then %> 
			<td class="celula"><strong>Data Lotação</strong></td>
		<%end if%> 
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	if request("exportar") = "" then 
		mostraCabecalho
	else
		mostraCabecalhoReduzido
	end if
	cont = 0
	contColaboradorEmpresa = 0
	intQtdeRegistroPorPagina = 0
	
	sql = "SELECT C.data_admissao," '0
	sql = sql & " C.Data_nascimento, "'1
	sql = sql & " C.Datafastamento, "'2
	sql = sql & " C.DataLotacao, "'3
	sql = sql & " C.Situacao, "'4
	sql = sql & " C.Estado_civil, "'5
	sql = sql & " '' AS DOCUMENTACOES,"'6
	sql = sql & " '' AS CONTEUDO,"'7
	sql = sql & " C.CodFuncional,"'8
	sql = sql & " C.NOME AS NOME_COLABORADOR,"'9
	sql = sql & " C.Logradouro,"'10
	sql = sql & " C.Numero_Logradouro, "'11
	sql = sql & " C.Comp_Endereco,"'12
	sql = sql & " C.Bairro,"'13
	sql = sql & " C.Cidade,"'14
	sql = sql & " C.uf,"'15
	sql = sql & " C.CEP,"'16
	sql = sql & " C.FoneResidencial,"'17
	sql = sql & " C.FoneComercial,"'18
	sql = sql & " C.FoneCelular,"'19
	sql = sql & " C.email,"'20
	sql = sql & " C.Pai,"'21
	sql = sql & " C.Mae,"'22
	sql = sql & " C.Naturalidade,"'23
	sql = sql & " C.Conjuge,"'24
	sql = sql & " C.Numero_filhos,"'25
	sql = sql & " C.Cpf,"'26
	sql = sql & " C.Titulo_Eleitor,"'27
	sql = sql & " C.Carteira_Trabalho,"'28
	sql = sql & " C.Rg,"'29
	sql = sql & " C.Orgaoexp,"'30
	sql = sql & " C.Carteira_Reservista,"'31
	sql = sql & " C.Sexo,"'32
	sql = sql & " C.Pis,"'33
	sql = sql & " CA.DESC_CATEGORIA,"'34
	sql = sql & " GI.DESCRICAO AS GrauInstrucao,"'35
	sql = sql & " CC.Desc_Cargo as Cargo,"'36
	sql = sql & " CASE "
	sql = sql & " 	when FC_R.Desc_Funcao is null then FC.Desc_Funcao"
	sql = sql & " 	else FC_R.Desc_Funcao + ' (readaptação)'"
	sql = sql & " 	end as Funcao,"'37
	sql = sql & " DP.DESCRICAO AS DPTO, " '38
	sql = sql & " UF.SIGLA AS UF,"'39
	sql = sql & " C.CodFuncional,"'40
	sql = sql & " C.Obs,"'41
	sql = sql & " C.Codigo_seg_usuarios_sistema,"'42
	sql = sql & " FN.DESC_FORMANOMEACAO AS NOMEACAO,"'43
	sql = sql & " TU.DESC_TURNO,"'44
	sql = sql & " N.Descricao as Nivel,"'45
	sql = sql & " C.carga_horario_contratada,"'46
	sql = sql & " C.total_aulas,"'47
	sql = sql & " N.Tipo_Vinculo,"'48
	sql = sql & " N.PermiteSubstituicao,"'49
	sql = sql & " N.PermiteDobras, "'50
	sql = sql & " (select max(DataLotacao) 	from SRH_LOTACAOHISTORICO where cod_Colaborador=c.codigo) AS REMOCAO, "'51
	sql = sql & " TU.DESC_TURNO, "'52
	sql = sql & " N.Descricao as Nivel, "'53
	sql = sql & " N.carga_horario_contratada, "'54
	sql = sql & " N.total_aulas, "'55
	sql = sql & " N.Tipo_Vinculo, "'56
	sql = sql & " N.PermiteSubstituicao, "'57
	sql = sql & " N.PermiteDobras, "'58
	sql = sql & " '' AS DOCUMENTACOES, "'59
	sql = sql & " '' AS CONTEUDO,  "'60
	sql = sql & " e.razaosocial, "'61
	sql = sql & " c.nacionalidade, "'62
	sql = sql & " c.CodLotacao, "'63
	sql = sql & " c.cod_empresa, "'64
	sql = sql & " case when c.codFuncao_readaptacao is null then '' else 'Sim' end codFuncao_readaptacao"'65
	sql = sql & " FROM SRH_COLABORADOR C "
	sql = sql & " LEFT JOIN SCF_UF UF ON UF.CODIGO = C.UF "
	sql = sql & " LEFT JOIN SRH_CATEGORIA CA ON CA.COD_CATEGORIA = C.CODCATEGORIA "
	sql = sql & " LEFT JOIN SCA_GRAUINSTRUCAO GI ON GI.CODIGO = C.CodGrauInstrucao "
	sql = sql & " LEFT JOIN SEG_DEPARTAMENTO DP ON DP.CODIGO = C.CodDepartamento "
	sql = sql & " LEFT JOIN SRH_TURNO TU ON TU.COD_TURNO = C.CodTurno "
    sql = sql & " inner join SEG_EMPRESA E ON E.CODIGO = C.CodLotacao "
    sql = sql & " LEFT JOIN SRH_CARGOCOLABORADOR CC ON CC.COD_CARGO = C.CODCARGO "
    sql = sql & " LEFT JOIN SRH_FUNCAOCOLABORADOR FC ON FC.COD_FUNCAO = C.CODFUNCAO "
    sql = sql & " LEFT JOIN SRH_FORMANOMEACAOCOLABORADOR FN ON FN.COD_FORMANOMEACAO = C.CODFORMANOMEACAO "
    sql = sql & " LEFT JOIN SRH_FORMANOMEACAOCOLABORADOR RM ON RM.COD_FORMANOMEACAO = C.CODREMOCAO "
	sql = sql & " LEFT JOIN SRH_NIVEL N ON N.Codigo = C.Cod_nivel "
	sql = sql & " LEFT JOIN SRH_FUNCAOCOLABORADOR FC_R ON FC_R.COD_FUNCAO = C.CODFUNCAO_READAPTACAO "
    if Session("NivelPermissao") <> "A" then
		
	   		sql = sql & " WHERE C.CodLotacao	= " & session("CodEmpresa")
		
	else   
		if intCodEmpresaUsuario <> "0" and intCodEmpresaUsuario <> "" then
			
		   		sql = sql & " where C.CodLotacao in (" & intCodEmpresaUsuario & ")"
			
		else
			
				sql = sql & " where C.CodLotacao in (" & intEmpresasDoGrupo & ")"
			
		end if   
    end if
	if readaptacao="S" then
		sql = sql & " AND C.CODFUNCAO_READAPTACAO is not null"
	end if
	if strDataInicialAdmissao <> "" and strDataFinalAdmissao <> "" then
       sql = sql & " AND C.data_admissao  >'" & formatadataBD(strDataInicialAdmissao) & "'"
	   sql = sql & " AND C.data_admissao <'" & formatadataBD(strDataFinalAdmissao) & "'"
	end if 
	
	if strDataInicialLotacao <> "" and strDataFinalLotacao <> "" then
       sql = sql & " AND C.DataLotacao  >'" & formatadataBD(strDataInicialLotacao) & "'"
	   sql = sql & " AND C.DataLotacao <'" & formatadataBD(strDataFinalLotacao) & "'"
	end if 
	
	if strDataInicialAfastamento <> "" and strDataFinalAfastamento <> "" then
       sql = sql & " AND C.Datafastamento  >'" & formatadataBD(strDataInicialAfastamento) & "'"
	   sql = sql & " AND C.Datafastamento <'" & formatadataBD(strDataFinalAfastamento) & "'"
	end if 
	
	if strSituacao <> "" and strSituacao <> "0" then
       sql = sql & " AND C.SITUACAO	= '" & strSituacao & "'"
	end if 
	if intCodCargoCategoria <> "" and intCodCargoCategoria <> "0" then
       sql = sql & " AND CC.CodCargoCategoria	= " & intCodCargoCategoria
	end if
	if intCodCategoria <> "" and intCodCategoria <> "0" then
       sql = sql & " AND C.CODCATEGORIA	= " & intCodCategoria
	end if 
	if intCodDepartamento <> "" and intCodDepartamento <> "0" then
       sql = sql & " AND C.CODDEPARTAMENTO	= " & intCodDepartamento
	end if
	if intCodCargo <> "" and intCodCargo <> "0" then
       sql = sql & " AND C.CODCARGO	= " & intCodCargo
	end if
	if intCodFuncao <> "" and intCodFuncao <> "0" then
		
		sql = sql & " AND " & intCodFuncao & " = "
		sql = sql & " (CASE "
		sql = sql & " 	when c.codFuncao_readaptacao is null then c.codFuncao"
		sql = sql & " 	else c.codFuncao_readaptacao"
		sql = sql & " 	end ) "
	   
	end if
	if intCodTurno <> "" and intCodTurno <> "0" then
       sql = sql & " AND C.CODturno= " & intCodTurno
	end if
	if intCodGrauInstrucao <> "" and intCodGrauInstrucao <> "0" then
       sql = sql & " AND C.CODGRAUINSTRUCAO= " & intCodGrauInstrucao
	end if
	if intcodLotacao <> "" and intcodLotacao <> "0" then
       sql = sql & " AND C.CODLOTACAO= " & intcodLotacao
	end if
	if intCodFormaNomeacao <> "" and intCodFormaNomeacao <> "0" then
       sql = sql & " AND C.CODFORMANOMEACAO= " & intCodFormaNomeacao
	end if
	
    if strClassificacao = "NOM" then
	   if strCompartilharDados = "S" then 
      		sql = sql & " ORDER BY NOME_COLABORADOR "
		else  
      		sql = sql & " ORDER BY NOME_COLABORADOR "
		end if  
	end if
    if strClassificacao = "DAD" then
	   if strCompartilharDados = "S" then 
      		sql = sql & " ORDER BY C.CODLOTACAO, C.data_admissao "
		else  
      		sql = sql & " ORDER BY C.COD_EMPRESA, C.data_admissao "
		end if  
	end if
	if strClassificacao = "BAI" then
	   if strCompartilharDados = "S" then 
      		sql = sql & " ORDER BY C.CODLOTACAO, C.Bairro "
		else  
      		sql = sql & " ORDER BY C.COD_EMPRESA, C.Bairro "
		end if  
	end if
    if strClassificacao = "CID" then
	   if strCompartilharDados = "S" then 
      		sql = sql & " ORDER BY C.CODLOTACAO, C.Cidade "
		else  
      		sql = sql & " ORDER BY C.COD_EMPRESA, C.Cidade "
		end if  
	end if
    if strClassificacao = "DNA" then
	   if strCompartilharDados = "S" then 
      		sql = sql & " ORDER BY C.CODLOTACAO, C.Data_nascimento "
		else  
      		sql = sql & " ORDER BY C.COD_EMPRESA, C.Data_nascimento "
		end if  
	end if
    if strClassificacao = "FUN" then
	   if strCompartilharDados = "S" then 
      		sql = sql & " ORDER BY C.CODLOTACAO, FC.DESC_FUNCAO "
		else  
      		sql = sql & " ORDER BY C.COD_EMPRESA, FC.DESC_FUNCAO "
		end if  
	end if
    if strClassificacao = "DEP" then
	   if strCompartilharDados = "S" then 
       		sql = sql & " ORDER BY C.CODLOTACAO, DPTO "
		else  
      		sql = sql & " ORDER BY C.COD_EMPRESA, DPTO "
		end if  
	end if
    if strClassificacao = "GER" then
   		sql = sql & " ORDER BY NOME_COLABORADOR "
	end if
	
	if strFiltro27 = "S" then
   		'sql = sql & " ORDER BY GrauInstrucao "
	end if
'response.write sql
	primeiraVez = 0
	vetColabora = null
	rs.open sql, cnn
	if not rs.eof then
		vetColabora = rs.getRows
	end if
	rs.close
		
	if isArray(vetColabora) then
		controle = 0
		for i=0 to ubound(vetColabora,2)

	   		remocao = vetColabora(51,i) 
	   		if remocao = "01/01/1900" then remocao = "" 
			
	        if not isnull(vetColabora(0,i)) then
			   strDataAdmissao = formatadataAP(vetColabora(0,i))
			end if 
			
	        if not isnull(vetColabora(1,i)) then
			   strDataNascimento = formatadataAP(vetColabora(1,i))
			end if  
			
	        if not isnull(vetColabora(2,i)) then
			   strDatafastamento = formatadataAP(vetColabora(2,i))
			else
				strDatafastamento = ""   
			end if  
			
			if not isnull(vetColabora(3,i)) then
			   strDataLotacao = formatadataAP(vetColabora(3,i))
			else
				strDataLotacao = ""   
			end if  
			
  		    if trim(vetColabora(4,i)) = "A" then 
			   strSituacao = "ATIVO"
		    elseif trim(vetColabora(4,i)) = "I" then  
			   strSituacao = "INATIVO"	  
			end if   
			 
			if trim(vetColabora(5,i)) = "S" then 
			   strestado_civil = "SOLTEIRO"
			elseif trim(vetColabora(5,i)) = "C" then  
			    strestado_civil = "CASADO"
			elseif trim(vetColabora(5,i)) = "V" then  
			    strestado_civil = "VIÚVO"
			elseif trim(vetColabora(5,i)) = "D" then  
			    strestado_civil = "DESQUITADO"
			elseif trim(vetColabora(5,i)) = "O" then  
			    strestado_civil = "OUTROS"
			end if	

'			strMgsNadaConsta = ""
'			if isnull(vetColabora(6,i)) then
'			   strMgsNadaConsta = strMgsNadaConsta + ""
'			else 
'				strMgsNadaConsta = strMgsNadaConsta + "Documentações "
'			end if	
'			
'			if strMes <> "0" then	
'				if isnull(vetColabora(7,i)) then
'					strMgsNadaConsta = strMgsNadaConsta + "Conteúdo Programático Mês: " & zeroleft(strmes,2)
'				else 
'					strMgsNadaConsta = strMgsNadaConsta + ""
'				end if	
'			end if	
			
  		    %> 
			<tr>
			<%if trim(strFiltro31) = "S" then %> 
				<td  class="celula"><%=vetColabora(40,i)%>&nbsp;</td>
		    <%end if%>  
			<td class="celula"><%=vetColabora(9,i)%>&nbsp;</td>
		    <%if Session("NivelPermissao") = "A" then%> 
    	        <%if trim(strFiltro40) = "S" then %> 
				<td  class="celula"><%=vetColabora(61,i)%>&nbsp;</td>			
				<%end if%> 	
            <%end if%> 
			<%if trim(strFiltro01) = "S" then %> 
				<td class="celula" align="center"><%=strDataAdmissao%>&nbsp;</td>
		    <%end if%>  
			<%if trim(strFiltro02) = "S" then %> 
				<td  class="celula"><%=vetColabora(10,i)%>, <%=vetColabora(11,i)%>, <%=vetColabora(12,i)%>&nbsp;</td>
		    <%end if%>  
			<%if trim(strFiltro03) = "S" then %> 
				<td  class="celula"><%=vetColabora(13,i)%>&nbsp;</td>
		    <%end if%>  
			<%if trim(strFiltro04) = "S" then %> 
				<td  class="celula"><%=vetColabora(14,i)%>-<%=vetColabora(15,i)%>&nbsp;</td>
		    <%end if%>  
			
			<%if trim(strFiltro05) = "S" then %> 
				<td  class="celula"><%=vetColabora(16,i)%></td>
		    <%end if%>  
			<%if trim(strFiltro06) = "S" then %> 
				<td  class="celula"><%=vetColabora(17,i)%> / <%=vetColabora(18,i)%></td>
		    <%end if%>  
			<%if trim(strFiltro07) = "S" then %> 
				<td  class="celula"><%=vetColabora(19,i)%>&nbsp;</td>
		    <%end if%>  
			<%if trim(strFiltro08) = "S" then %> 
				<td  class="celula"><%=vetColabora(20,i)%>&nbsp;</td>
		    <%end if%>  

			<%if trim(strFiltro09) = "S" then %> 
				<td  class="celula"><%=vetColabora(21,i)%>&nbsp;</td>
		    <%end if%>  
			<%if trim(strFiltro10) = "S" then %> 
				<td  class="celula"><%=vetColabora(22,i)%>&nbsp;</td>
		    <%end if%>  
			<%if trim(strFiltro11) = "S" then %> 
				<td class="celula" align="center"><%=strDataNascimento%></td>
		    <%end if%>  
			<%if trim(strFiltro12) = "S" then %> 
				<td  class="celula"><%=vetColabora(23,i)%></td>
		    <%end if%>
			  
			<%if trim(strFiltro13) = "S" then %> 
				<td  class="celula" align="center"><%=vetColabora(62,i)%>&nbsp;</td>
		    <%end if%>  
			<%if trim(strFiltro14) = "S" then %> 
				<td  class="celula" align="center"><%=strestado_civil%>&nbsp;</td>
		    <%end if%>  
			<%if trim(strFiltro15) = "S" then %> 
				<td  class="celula"><%=vetColabora(24,i)%>&nbsp;</td>
		    <%end if%>  
			<%if trim(strFiltro16) = "S" then %> 
				<td  class="celula" align="center"><%=vetColabora(25,i)%>&nbsp;</td>
		    <%end if%>
			  
			<%if trim(strFiltro17) = "S" then %> 
				<td  class="celula"><%=vetColabora(26,i)%>&nbsp;</td>
		    <%end if%>  
			<%if trim(strFiltro18) = "S" then %> 
				<td  class="celula"><%=vetColabora(27,i)%>&nbsp;</td>
		    <%end if%>  
			<%if trim(strFiltro19) = "S" then %> 
				<td  class="celula"><%=vetColabora(28,i)%>&nbsp;</td>
		    <%end if%>  
			<%if trim(strFiltro20) = "S" then %> 
				<td  class="celula"><%=vetColabora(29,i)%>/<%=vetColabora(30,i)%>&nbsp;</td>
		    <%end if%>  

			<%if trim(strFiltro21) = "S" then %> 
				<td  class="celula"><%=vetColabora(31,i)%>&nbsp;</td>
		    <%end if%>  
			<%if trim(strFiltro22) = "S" then %> 
				<td  class="celula" align="center"><%=vetColabora(32,i)%>&nbsp;</td>
		    <%end if%>  
			<%if trim(strFiltro23) = "S" then %> 
				<td class="celula"><%=vetColabora(33,i)%>&nbsp;</td>
		    <%end if%>  
			<%if trim(strFiltro24) = "S" then %> 
				<td class="celula" align="center"><%=strDatafastamento%>&nbsp;</td>
		    <%end if%>  
           
          	<%if trim(strFiltro25) = "S" then %> 
				<td  class="celula" align="center"><%=strSituacao%>&nbsp;</td>
		    <%end if%>  
			<%if trim(strFiltro26) = "S" then %> 
				<td  class="celula"><%=vetColabora(34,i)%>&nbsp;</td>
		    <%end if%>  
			<%if trim(strFiltro27) = "S" then %> 
				<td  class="celula"><%=vetColabora(35,i)%>&nbsp;</td>
		    <%end if%>  
			<%if trim(strFiltro28) = "S" then %> 
				<td  class="celula"><%=vetColabora(36,i)%>&nbsp;</td>
		    <%end if%>  
			<%if trim(strFiltro29) = "S" then %> 
				<td  class="celula"><%=vetColabora(37,i)%>&nbsp;</td>
		    <%end if%>  
			<%if trim(strFiltro30) = "S" then %> 
				<td class="celula"><%=vetColabora(38,i)%>&nbsp;</td>
		    <%end if%>  
			<%if trim(strFiltro32) = "S" then %> 
				<td  class="celula"><%=vetColabora(41,i)%>&nbsp;</td>
		    <%end if%>  
			<%if trim(strFiltro33) = "S" then %> 
				<td  class="celula"><%=vetColabora(42,i)%>&nbsp;</td>
		    <%end if%>  
			<%if trim(strFiltro34) = "S" then %> 
				<td  class="celula" align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		    <%end if%> 
			<%if trim(strFiltro35) = "S" then %> 
				<td  class="celula"><%=vetColabora(43,i)%>&nbsp;</td>
		    <%end if%>  
			<%if trim(strFiltro36) = "S" then %> 
				<td  class="celula"><%=remocao%>&nbsp;</td>
		    <%end if%>  
            <%if trim(strFiltro37) = "S" then %> 
				<td  class="celula"><%=vetColabora(44,i)%>&nbsp;</td>
		    <%end if%>  
            <%if trim(strFiltro38) = "S" then %> 
				<td align="center" class="celula"><%=vetColabora(45,i)%>&nbsp;</td>
               <td  align="center" class="celula"><%=vetColabora(46,i)%>&nbsp;</td>
               <td  align="center" class="celula"><%=vetColabora(47,i)%>&nbsp;</td>
               <td  align="center" class="celula"><%=vetColabora(48,i)%>&nbsp;</td>
            <%end if%> 
            <%if trim(strFiltro39) = "S" then %> 
				<td class="celula" align="center"><%=strDataLotacao%>&nbsp;</td>
		    <%end if%>  
    		<%if trim(strFiltro41) = "S" then %> 
				<td class="celula" align="center"><%=vetColabora(65,i)%>&nbsp;</td>
		    <%end if%> 
			
            
			</tr> 
		    <%	
			'quantidade de registros da página
			if intQtdeRegistroPorPagina = 50 and request("exportar") = "" then
				 intPagina = intPagina + 1
				 intQtdeRegistroPorPagina = 1
				 fimTabela
				%>
				<pre></pre>				
				<%			
				mostraCabecalho
			end if	
			
			cont = cont + 1
			contColaboradorEmpresa = contColaboradorEmpresa + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			
			if strCompartilharDados = "S" then 
            	checaEmpresa = vetColabora(63,i)
			else
            	checaEmpresa = vetColabora(64,i)
			end if	
			

		next
		contPeriodo = contPeriodo + 1
	else
		%>
		  <tr>
			<td colspan="36" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
%>
<%	if request("exportar") = "" then %>
<tr>
<td colspan="36" class="celula" align="center"><div align="left">Total de Registros: <%=cont%> </div></td>
</tr>
<%	end if %>

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
