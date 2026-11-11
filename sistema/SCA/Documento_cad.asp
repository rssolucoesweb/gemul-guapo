<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 20/05/2008
	::	Desenvolvedores...: Sérgio Borges - sergiob76@gmail.com
	::	Objetivo Pagina...: Cadastro de Documentos
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
.style1 {
	color: #009900;
	font-weight: bold;
}
-->
</style>
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--include file="../fckeditor/fckeditor.asp" -->
<script src="../ckeditor/ckeditor.js"></script>
<script src="../ckeditor/config.js"></script>
<script>
	function dadosAluno(){
		if (mostraDadosAluno.style.display=="none"){
			mostraDadosAluno.style.display="block"
			frm.imgDadosAluno.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
		}
		else{
			mostraDadosAluno.style.display="none"
			frm.imgDadosAluno.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
		}
	}
	function dadosEscolares(){
		if (mostraDadosEscolares.style.display=="none"){
			mostraDadosEscolares.style.display="block"
			frm.imgDadosEscolares.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
		}
		else{
			mostraDadosEscolares.style.display="none"
			frm.imgDadosEscolares.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
		}
	}
	function dadosDataAtual(){
		if (mostraDadosDataAtual.style.display=="none"){
			mostraDadosDataAtual.style.display="block"
			frm.imgDadosDataAtual.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
		}
		else{
			mostraDadosDataAtual.style.display="none"
			frm.imgDadosDataAtual.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
		}
	}
	function dadosRepresentantes(){
		if (mostraDadosRepresentantes.style.display=="none"){
			mostraDadosRepresentantes.style.display="block"
			frm.imgDadosRepresentantes.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
		}
		else{
			mostraDadosRepresentantes.style.display="none"
			frm.imgDadosRepresentantes.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
		}
	}		
	function dadosAutorizacao(){
		if (mostraDadosAutorizacao.style.display=="none"){
			mostraDadosAutorizacao.style.display="block"
			frm.imgDadosAutorizacao.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
		}
		else{
			mostraDadosAutorizacao.style.display="none"
			frm.imgDadosAutorizacao.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
		}
	}
	function dadosValidacao(){
		if (mostraDadosValidacao.style.display=="none"){
			mostraDadosValidacao.style.display="block"
			frm.imgDadosValidacao.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
		}
		else{
			mostraDadosValidacao.style.display="none"
			frm.imgDadosValidacao.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
		}
	}
	function mostraCampoInserir(linhacampo,marcou){
		if (marcou) {
			document.all[linhacampo].style.display="block";
		} else {
			document.all[linhacampo].style.display="none";
		}
	}

	function resultadoConsulta(intCodigo){
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		if (frm.txtTitulo.value == "") {
			alert("Titulo deve ser informado!");
			frm.txtTitulo.focus();
			return false;
		}
		
		if (frm.cmbDepartamento.value == "0") {
			alert("O departamento deve ser informado!");
			frm.cmbDepartamento.focus();
			return false;
		}
		
		frm.action="Documento_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel_documento.js"></script>
<%
	strPaginaTitulo 	= "Documento_cad.asp"

	strPagina			= "Documento_cad.asp"
	intCodDocumento		= Trim(Request("txtCodigo"))
	strTitulo	 		= Trim(Request.Form("txtTitulo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	if TRIM(Session("NivelPermissao")) = "A" then
	   strMostraSomenteDeptoAtual = "" 'mostra todos os deptos
    else   
	   strMostraSomenteDeptoAtual = "S" 'mostra somente o depto atual
	end if	
	if trim(intCodDocumento) <> "" then
	
		sql = "SELECT codigo, titulo, Documento, campos, cod_departamento, posicaofinanceira, situacaoaluno"
		sql = sql & " FROM SCA_DOCUMENTO"
		sql = sql & " Where codigo = " & intCodDocumento
		sql = sql & " And cod_empresa = " & Session("CodEmpresa")			
		rs.open sql, cnn
		
		if rs.eof = false then
			
			strTitulo 				= rs("Titulo")
			strDescricao			= rs("Documento")
			strDescricao 			= REPLACE(REPLACE(rs("documento"),"&lt;","["),"&gt;","]")
			strCampos				= rs("campos")
			intCodDepartamento		= rs("cod_departamento")
			strMarcaPosicaoFinanceira= ""
			if trim(rs("posicaofinanceira")) = "S" then
				strMarcaPosicaoFinanceira= "checked"
			end if
			
			strsituacaoaluno		= rs("situacaoaluno")
			
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir

		end if 
		rs.close
		
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
	
	strMarcaNomeAluno 		= ""
	strMarcaMatricula 		= ""
	strMarcaDataNascimento 	= ""
	strMarcaCidadeNascimento= ""
	strMarcaUfNascimento 	= ""
	strMarcaCidadeResidencia= ""
	strMarcaUfResidencia 	= ""
	strMarcaFone		 	= ""
	strMarcaEmail		 	= ""

	strMarcaIdentidade	 	= ""
	strMarcaCPF 			= ""
	strMarcaTitulo		 	= ""
	
	strMarcaAnoLetivo 		= ""
	strMarcaPai 			= ""
	strMarcaMae 			= ""
	strMarcaCursoAtual 		= ""
	strMarcaPeriodoAtual 	= ""
	strMarcaTurnoAtual 		= ""

	strMarcaTurmaAluno 		= ""
	strMarcaSituacaoAluno	= ""
	strMarcaFormaIngresso	= ""

	strMarcaCidade	 		= ""
	strMarcaDia 			= ""
	strMarcaMes 			= ""
	strMarcaAno 			= ""
	strMarcaSecretario 		= ""
	strMarcaDiretor 		= ""

	strMarcaAnoConclusao 	= ""
	strMarcaSemestre	 	= ""
	strAutorizacao			= ""
	strDataAutorizacao		= ""
	strDataReconhecimento	= ""
	strReconhecimento		= ""
	strCH_Exigida			= ""
	strDataColacao			= ""
	strDataCertificado		= ""
	strDataMatricula		= ""
	strNacionalidade		= ""
	strEstadoCivil			= ""
	
	

	estiloInicialNomeAluno = "style='display:none'"
	estiloInicialMatricula = "style='display:none'"
	estiloInicialDataNascimento = "style='display:none'"
	estiloInicialCidadeNascimento = "style='display:none'"
	estiloInicialUfNascimento = "style='display:none'"
	estiloInicialCidadeResidencia = "style='display:none'"
	estiloInicialUfResidencia = "style='display:none'"
	estiloInicialFone = "style='display:none'"
	estiloInicialEmail = "style='display:none'"

	estiloInicialIdentidade = "style='display:none'"
	estiloInicialCPF 		= "style='display:none'"
	estiloInicialTitulo 	= "style='display:none'"

	estiloInicialAnoLetivo = "style='display:none'"
	estiloInicialPai = "style='display:none'"
	estiloInicialMae = "style='display:none'"
	estiloInicialCursoAtual = "style='display:none'"
	estiloInicialPeriodoAtual = "style='display:none'"
	estiloInicialTurnoAtual = "style='display:none'"
	
	estiloInicialTurmaAluno = "style='display:none'"	
	estiloInicialSituacaoAluno = "style='display:none'"
	estiloInicialFormaIngresso = "style='display:none'"

	estiloInicialCidade = "style='display:none'"
	estiloInicialDia = "style='display:none'"
	estiloInicialMes = "style='display:none'"
	estiloInicialAno = "style='display:none'"
	estiloInicialSecretario = "style='display:none'"
	estiloInicialDiretor = "style='display:none'"

	estiloInicialAnoConclusao = "style='display:none'"
	estiloInicialSemestre = "style='display:none'"
	estiloInicialAutorizacao = "style='display:none'"
	estiloInicialDataAutorizacao = "style='display:none'"
	estiloInicialDataReconhecimento = "style='display:none'"
	estiloInicialCH_Exigida = "style='display:none'"
	
	estiloInicialReconhecimento = "style='display:none'"
	estiloInicialDataColacao = "style='display:none'"
	estiloInicialDataCertificado = "style='display:none'"
	estiloInicialDataMatricula = "style='display:none'"
	estiloInicialNacionalidade = "style='display:none'"
	estiloInicialEstadoCivil = "style='display:none'"
    
	'
	estiloInicialLogradouro = "style='display:none'"
	estiloInicialNumero_Endereco = "style='display:none'"
	estiloInicialComp_Endereco = "style='display:none'"
	estiloInicialBairroAluno = "style='display:none'"
	'

	if strCampos <> "" then

		vetCampos = split(strCampos,",")
		for i=0 to ubound(vetCampos)
			if trim(vetCampos(i)) = "NOMEALUNO" then 
				strMarcaNomeAluno = "checked"
				estiloInicialNomeAluno = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "MATRICULA" then 
				strMarcaMatricula = "checked"
				estiloInicialMatricula = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "DATANASCIMENTO" then 
				strMarcaDataNascimento = "checked"
				estiloInicialDataNascimento = "style='display:block'"
			end if

			if trim(vetCampos(i)) = "CIDADENASCIMENTO" then 
				strMarcaCidadeNascimento = "checked"
				estiloInicialCidadeNascimento = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "UFNASCIMENTO" then 
				strMarcaUfNascimento = "checked"
				estiloInicialUfNascimento = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "CIDADERESIDENCIA" then 
				strMarcaCidadeResidencia = "checked"
				estiloInicialCidadeResidencia = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "UFRESIDENCIA" then 
				strMarcaUfResidencia = "checked"
				estiloInicialUfResidencia = "style='display:block'"
			end if

			if trim(vetCampos(i)) = "FONE" then 
				strMarcaFone = "checked"
				estiloInicialFone = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "EMAIL" then 
				strMarcaEmail = "checked"
				estiloInicialEmail = "style='display:block'"
			end if
			
			if trim(vetCampos(i)) = "IDENTIDADE" then 
				strMarcaIdentidade = "checked"
				estiloInicialIdentidade = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "CPF" then 
				strMarcaCPF = "checked"
				estiloInicialCPF = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "TITULO" then 
				strMarcaTitulo = "checked"
				estiloInicialTitulo = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "ANOLETIVO" then 
				strMarcaAnoLetivo = "checked"
				estiloInicialAnoLetivo = "style='display:block'"
			end if

			if trim(vetCampos(i)) = "PAI" then 
				strMarcaPai = "checked"
				estiloInicialPai = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "MAE" then 
				strMarcaMae = "checked"
				estiloInicialMae = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "CURSOATUAL" then 
				strMarcaCursoAtual = "checked"
				estiloInicialCursoAtual = "style='display:block'"
			end if

			if trim(vetCampos(i)) = "PERIODOATUAL" then 
				strMarcaPeriodoAtual = "checked"
				estiloInicialPeriodoAtual = "style='display:block'"
			end if

			if trim(vetCampos(i)) = "TURNOATUAL" then 
				strMarcaTurnoAtual = "checked"
				estiloInicialTurnoAtual = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "SITUACAOALUNO" then 
				strMarcaSituacaoAluno = "checked"
				estiloInicialSituacaoAluno = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "FORMAINGRESSO" then 
				strMarcaFormaIngresso = "checked"
				estiloInicialFormaIngresso = "style='display:block'"
			end if

			if trim(vetCampos(i)) = "TURMAALUNO" then 
				strMarcaTurmaAluno = "checked"
				estiloInicialTurmaAluno = "style='display:block'"
			end if

			if trim(vetCampos(i)) = "CIDADE" then 
				strMarcaCidade = "checked"
				estiloInicialCidade = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "DIA" then 
				strMarcaDia = "checked"
				estiloInicialDia = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "MES" then 
				strMarcaMes = "checked"
				estiloInicialMes = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "ANO" then 
				strMarcaAno = "checked"
				estiloInicialAno = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "SECRETARIO" then 
				strMarcaSecretario = "checked"
				estiloInicialSecretario = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "DIRETOR" then 
				strMarcaDiretor = "checked"
				estiloInicialDiretor = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "ANOCONCLUSAO" then 
				strMarcaAnoConclusao = "checked"
				estiloInicialAnoConclusao = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "SEMESTRE" then 
				strMarcaSemestre = "checked"
				estiloInicialSemestre = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "AUTORIZACAO" then 
				strMarcaAutorizacao = "checked"
				estiloInicialAutorizacao = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "DATAAUTORIZACAO" then 
				strMarcaDataAutorizacao = "checked"
				estiloInicialDataAutorizacao = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "DATARECONHECIMENTO" then 
				strMarcaDataReconhecimento = "checked"
				estiloInicialDataReconhecimento = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "RECONHECIMENTO" then 
				strMarcaReconhecimento = "checked"
				estiloInicialReconhecimento = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "CH_EXIGIDA" then 
				strMarcaCH_Exigida = "checked"
				estiloInicialCH_Exigida = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "DATACOLACAO" then 
				strMarcaDataColacao = "checked"
				estiloInicialDataColacao = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "DATACERTIFICADO" then 
				strMarcaDataCertificado = "checked"
				estiloInicialDataCertificado = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "DATAMATRICULA" then 
				strMarcaDataMatricula = "checked"
				estiloInicialDataMatricula = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "NACIONALIDADE" then 
				strMarcaNacionalidade = "checked"
				estiloInicialNacionalidade = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "ESTADOCIVIL" then 
				strMarcaEstadoCivil = "checked"
				estiloInicialEstadoCivil = "style='display:block'"
			end if

			if trim(vetCampos(i)) = "LOGRADOURO" then 
				strLogradouro = "checked"
				estiloInicialLogradouro = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "NUMERO_ENDERECO" then 
				strNumeroEndereco = "checked"
				estiloInicialNumero_Endereco = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "COMP_ENDERECO" then 
				strCompEndereco = "checked"
				estiloInicialComp_Endereco = "style='display:block'"
			end if
			if trim(vetCampos(i)) = "BAIRROALUNO" then 
				strBairroAluno = "checked"
				estiloInicialBairroAluno = "style='display:block'"
			end if
			
		next
	end if
	
%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="751"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post">
		  <table width="708" border="0" cellpadding="0" cellspacing="0">

            <tr valign="top">
              <td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
		<table width="950" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="706" height="80" class="texto1"><table width="703" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td height="23" class="texto1"><strong>T&iacute;tulo : </strong></td>
					<td colspan="3"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodDocumento%>" maxlength="10">
					  <input name="txtTitulo" type="text" class="text" id="txtTitulo" size="50" maxlength="50" value="<%=strTitulo%>"></td>
				  </tr>
				  <tr>
				    <td height="23" class="texto1"><strong>Departamento : </strong></td>
				    <td colspan="3"><!--#include file="../includes/inc_cmdDepartamento.asp" --></td>
				    </tr>
				  <tr bgcolor="#EEEEEE">
					<td height="20" colspan="4" bgcolor="#EEEEEE" class="texto1" style="cursor:hand" onClick="return dadosAluno()"><img id="imgDadosAluno" src="<%=session("strCaminhoRaiz")%>/images/up.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Informa&ccedil;&otilde;es Pessoais do Aluno</strong></td>
				  </tr>
				  <tr>
					<td colspan="4" class="texto1" >
					<!-- INICIO CAMPO - DADOS ALUNO-->
						<table style="display:none" width="100%" border="0" cellpadding="0" cellspacing="0" id="mostraDadosAluno">					
						  <tr>
							<td width="158" class="texto1"><strong><input onClick="mostraCampoInserir('NOMEALUNO',this.checked)" type="checkbox" name="campos" value="NOMEALUNO" <%=strMarcaNomeAluno%>>Nome do Aluno</strong></td>
							<td width="181" class="texto1"><strong><input  onClick="mostraCampoInserir('MATRICULA',this.checked)" type="checkbox" name="campos" value="MATRICULA" <%=strMarcaMatricula%>>Matrícula do Aluno</strong></td>
							<td width="164" class="texto1"><strong><input onClick="mostraCampoInserir('DATANASCIMENTO',this.checked)"  type="checkbox" name="campos" value="DATANASCIMENTO" <%=strMarcaDataNascimento%>>Data Nasc. do Aluno</strong></td>
							<td width="200" class="texto1"><strong><input onClick="mostraCampoInserir('CIDADENASCIMENTO',this.checked)"  type="checkbox" name="campos" value="CIDADENASCIMENTO" <%=strMarcaCidadeNascimento%>>Cidade de Nascimento</strong></td>
						  </tr>
						  <tr>
							<td width="158" class="texto1"><strong><input onClick="mostraCampoInserir('UFNASCIMENTO',this.checked)"  type="checkbox" name="campos" value="UFNASCIMENTO" <%=strMarcaUfNascimento%>>Estado de Nasc.</strong></td>
							<td class="texto1"><strong><input onClick="mostraCampoInserir('IDENTIDADE',this.checked)"  type="checkbox" name="campos" value="IDENTIDADE" <%=strMarcaIdentidade%>>Identidade</strong></td>
							<td class="texto1"><strong><input onClick="mostraCampoInserir('CPF',this.checked)"  type="checkbox" name="campos" value="CPF" <%=strMarcaCPF%>>CPF</strong></td>
							<td class="texto1"><strong><input onClick="mostraCampoInserir('TITULO',this.checked)"  type="checkbox" name="campos" value="TITULO" <%=strMarcaTitulo%>>T&iacute;tulo de Eleitor</strong></td>
						  </tr>
						  <tr>
							<td width="158" class="texto1"><strong><input onClick="mostraCampoInserir('ESTADOCIVIL',this.checked)"  type="checkbox" name="campos" value="ESTADOCIVIL" <%=strMarcaEstadoCivil%>>Estado Civil </strong></td>
							<td class="texto1"><strong><input onClick="mostraCampoInserir('PAI',this.checked)"  type="checkbox" name="campos" value="PAI" <%=strMarcaPai%>>Pai do Aluno</strong></td>
							<td class="texto1"><strong><input onClick="mostraCampoInserir('MAE',this.checked)"  type="checkbox" name="campos" value="MAE" <%=strMarcaMae%>>Mãe do Aluno</strong></td>
							<td class="texto1"><strong><input onClick="mostraCampoInserir('NACIONALIDADE',this.checked)"  type="checkbox" name="campos" value="NACIONALIDADE" <%=strMarcaNacionalidade%>>Nacionalidade</strong></td>
						  </tr>
						  <tr>
							<td width="158" class="texto1"><strong><input onClick="mostraCampoInserir('LOGRADOURO',this.checked)"  type="checkbox" name="campos" value="LOGRADOURO" <%=strLogradouro%>>Logradouro</strong></td>
							<td class="texto1"><strong><input onClick="mostraCampoInserir('NUMERO_ENDERECO',this.checked)"  type="checkbox" name="campos" value="NUMERO_ENDERECO" <%=strNumeroEndereco%>>Numero</strong></td>
							<td class="texto1"><strong><input onClick="mostraCampoInserir('COMP_ENDERECO',this.checked)"  type="checkbox" name="campos" value="COMP_ENDERECO" <%=strCompEndereco%>>Complemento</strong></td>
							<td class="texto1"><strong><input onClick="mostraCampoInserir('BAIRROALUNO',this.checked)"  type="checkbox" name="campos" value="BAIRROALUNO" <%=strBairroAluno%>>Bairro</strong></td>
						  </tr>
                          <tr>
							<td width="200" class="texto1"><strong><input onClick="mostraCampoInserir('CIDADERESIDENCIA',this.checked)"  type="checkbox" name="campos" value="CIDADERESIDENCIA" <%=strMarcaCidadeResidencia%>>Cidade de Residência</strong></td>
							<td width="158" class="texto1"><strong><input onClick="mostraCampoInserir('UFRESIDENCIA',this.checked)"  type="checkbox" name="campos" value="UFRESIDENCIA" <%=strMarcaUfResidencia%>>Estado de Residência</strong></td>
							<td width="158" class="texto1"><strong><input onClick="mostraCampoInserir('EMAIL',this.checked)"  type="checkbox" name="campos" value="EMAIL" <%=strMarcaEmail%>>Email</strong></td>
							<td width="158" class="texto1"><strong><input onClick="mostraCampoInserir('FONE',this.checked)"  type="checkbox" name="campos" value="FONE" <%=strMarcaFone%>>Telefone(s)</strong></td>
						  </tr>
						</table>
					</td>
				  </tr>
				  <tr bgcolor="#EEEEEE">
					<td height="20" colspan="4" bgcolor="#EEEEEE" class="texto1" style="cursor:hand" onClick="return dadosEscolares()"><img id="imgDadosEscolares" src="<%=session("strCaminhoRaiz")%>/images/up.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Informa&ccedil;&otilde;es Dados Escolares</strong></td>
				  </tr>
				  <tr>
					<td colspan="4" class="texto1" >
					<!-- INICIO CAMPO - DADOS ESCOLARES-->
						<table style="display:none" width="100%" border="0" cellpadding="0" cellspacing="0" id="mostraDadosEscolares">					
						  <tr>
							<td class="texto1"><strong><input onClick="mostraCampoInserir('ANOLETIVO',this.checked)"  type="checkbox" name="campos" value="ANOLETIVO" <%=strMarcaAnoLetivo%>>Ano Letivo</strong></td>
							<td class="texto1"><strong><input onClick="mostraCampoInserir('CURSOATUAL',this.checked)"  type="checkbox" name="campos" value="CURSOATUAL" <%=strMarcaCursoAtual%>>Curso Atual</strong></td>
							<td class="texto1"><strong><input onClick="mostraCampoInserir('PERIODOATUAL',this.checked)"  type="checkbox" name="campos" value="PERIODOATUAL" <%=strMarcaPeriodoAtual%>>Período Atual</strong></td>
							<td class="texto1"><strong><input onClick="mostraCampoInserir('TURNOATUAL',this.checked)"  type="checkbox" name="campos" value="TURNOATUAL" <%=strMarcaTurnoAtual%>>Turno Atual</strong></td>
							</tr>
						  <tr>
							<td class="texto1"><strong><input onClick="mostraCampoInserir('TURMAALUNO',this.checked)"  type="checkbox" name="campos" value="TURMAALUNO" <%=strMarcaTurmaAluno%>>Turma do Aluno</strong></td>
							<td class="texto1"><strong><input onClick="mostraCampoInserir('SITUACAOALUNO',this.checked)"  type="checkbox" name="campos" value="SITUACAOALUNO" <%=strMarcaSituacaoAluno%>>Situação do Aluno</strong></td>
							<td class="texto1"><strong><input onClick="mostraCampoInserir('FORMAINGRESSO',this.checked)"  type="checkbox" name="campos" value="FORMAINGRESSO" <%=strMarcaFormaIngresso%>>Forma Ingresso </strong></td>
							<td class="texto1"><strong><input onClick="mostraCampoInserir('DATAMATRICULA',this.checked)"  type="checkbox" name="campos" value="DATAMATRICULA" <%=strMarcaDataMatricula%>>Data da Matr&iacute;cula </strong></td>
							</tr>
						  <tr>
							<td class="texto1"><strong><input onClick="mostraCampoInserir('DATACOLACAO',this.checked)"  type="checkbox" name="campos" value="DATACOLACAO" <%=strMarcaDataColacao%>>Data Cola&ccedil;&atilde;o </strong></td>
							<td class="texto1"><strong><input onClick="mostraCampoInserir('DATACERTIFICADO',this.checked)"  type="checkbox" name="campos" value="DATACERTIFICADO" <%=strMarcaDataCertificado%>>Data Certificado </strong></td>
							<td class="texto1"><strong><input onClick="mostraCampoInserir('ANOCONCLUSAO',this.checked)"  type="checkbox" name="campos" value="ANOCONCLUSAO" <%=strMarcaAnoConclusao%>>Ano Conclus&atilde;o </strong></td>
							<td class="texto1"><strong><input onClick="mostraCampoInserir('SEMESTRE',this.checked)"  type="checkbox" name="campos" value="SEMESTRE" <%=strMarcaSemestre%>>Semestre</strong></td>
						  </tr>
					   </table>
					</td>
				  </tr>
				  <tr bgcolor="#EEEEEE">
					<td height="20" colspan="4" bgcolor="#EEEEEE" class="texto1" style="cursor:hand" onClick="return dadosDataAtual()"><img id="imgDadosDataAtual" src="<%=session("strCaminhoRaiz")%>/images/up.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Informa&ccedil;&otilde;es data atual</strong></td>
				  </tr>
				  <tr>
					<td colspan="4" class="texto1" >
					<!-- INICIO CAMPO - DADOS DATA ATUAL-->
						<table style="display:none" width="100%" border="0" cellpadding="0" cellspacing="0" id="mostraDadosDataAtual">					
						  <tr>
							<td class="texto1"><strong><input onClick="mostraCampoInserir('CIDADE',this.checked)"  type="checkbox" name="campos" value="CIDADE" <%=strMarcaCidade%>>Cidade</strong></td>
							<td class="texto1"><strong><input onClick="mostraCampoInserir('DIA',this.checked)"  type="checkbox" name="campos" value="DIA" <%=strMarcaDia%>>Dia</strong></td>
							<td class="texto1"><strong><input onClick="mostraCampoInserir('MES',this.checked)"  type="checkbox" name="campos" value="MES" <%=strMarcaMes%>>M&ecirc;s</strong></td>
							<td class="texto1"><strong><input onClick="mostraCampoInserir('ANO',this.checked)"  type="checkbox" name="campos" value="ANO" <%=strMarcaAno%>>Ano</strong></td>
						  </tr>
					   </table>
					</td>
				  </tr>
				  <tr bgcolor="#EEEEEE">
					<td height="20" colspan="4" bgcolor="#EEEEEE" class="texto1" style="cursor:hand" onClick="return dadosRepresentantes()"><img id="imgDadosRepresentantes" src="<%=session("strCaminhoRaiz")%>/images/up.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Informa&ccedil;&otilde;es dos Representantes Legais</strong></td>
				  </tr>
				  <tr>
					<td colspan="4" class="texto1" >
					<!-- INICIO CAMPO - DADOS REPRESENTANTES-->
					<table style="display:none" width="100%" border="0" cellpadding="0" cellspacing="0" id="mostraDadosRepresentantes">					
					  <tr>
						<td class="texto1"><strong><input onClick="mostraCampoInserir('SECRETARIO',this.checked)"  type="checkbox" name="campos" value="SECRETARIO" <%=strMarcaSecretario%>>Secretario(a)</strong></td>
						<td class="texto1"><strong><input onClick="mostraCampoInserir('DIRETOR',this.checked)"  type="checkbox" name="campos" value="DIRETOR" <%=strMarcaDiretor%>>Diretor(a)</strong></td>
						<td class="texto1">&nbsp;</td>
						<td class="texto1">&nbsp;</td>
					  </tr>
					</table>
					</td>
				  </tr>
				  <tr bgcolor="#EEEEEE">
					<td height="20" colspan="4" bgcolor="#EEEEEE" class="texto1" style="cursor:hand" onClick="return dadosAutorizacao()"><img id="imgDadosAutorizacao" src="<%=session("strCaminhoRaiz")%>/images/up.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Informa&ccedil;&atilde;o de  Autoriza&ccedil;&atilde;o</strong></td>
				  </tr>
				  <tr>
					<td colspan="4" class="texto1" >
					<!-- INICIO CAMPO - DADOS AUTORIZAÇÃO-->
					<table style="display:none" width="100%" border="0" cellpadding="0" cellspacing="0" id="mostraDadosAutorizacao">					
						  <tr>
							<td class="texto1"><strong><input onClick="mostraCampoInserir('AUTORIZACAO',this.checked)"  type="checkbox" name="campos" value="AUTORIZACAO" <%=strMarcaAutorizacao%>>Autoriza&ccedil;&atilde;o</strong></td>
							<td class="texto1"><strong><input onClick="mostraCampoInserir('DATAAUTORIZACAO',this.checked)"  type="checkbox" name="campos" value="DATAAUTORIZACAO" <%=strMarcaDataAutorizacao%>>
							Data Autoriza&ccedil;&atilde;o </strong></td>
							<td class="texto1"><strong><input onClick="mostraCampoInserir('RECONHECIMENTO',this.checked)"  type="checkbox" name="campos" value="RECONHECIMENTO" <%=strMarcaReconhecimento%>>Reconhecimento</strong></td>
							<td class="texto1"><strong>
							  <input onClick="mostraCampoInserir('DATARECONHECIMENTO',this.checked)"  type="checkbox" name="campos" value="DATARECONHECIMENTO" <%=strMarcaDataReconhecimento%>>
							  Data Reconhecimento</strong></td>
						  </tr>
						  <tr>
							<td class="texto1"><strong>
							  <input onClick="mostraCampoInserir('CH_EXIGIDA',this.checked)"  type="checkbox" name="campos" value="CH_EXIGIDA" <%=strMarcaCH_Exigida%>>CH Exigida </strong></td>
							<td colspan="3" class="texto1">&nbsp;</td>
							</tr>
					</table>
					</td>
				  </tr>
				  <tr bgcolor="#EEEEEE">
					<td height="20" colspan="4" bgcolor="#EEEEEE" class="texto1" style="cursor:hand" onClick="return dadosValidacao()"><img id="imgDadosValidacao" src="<%=session("strCaminhoRaiz")%>/images/up.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Validações</strong></td>
				  </tr>
				  <tr>
					<td colspan="4" class="texto1" >
					<!-- INICIO CAMPO - DADOS AUTORIZAÇÃO-->
					<table style="display:none" width="100%" border="0" cellpadding="0" cellspacing="0" id="mostraDadosValidacao">					
						  <tr>
							<td width="34%" class="texto1"><strong><input type="checkbox" name="posicaofinanceira" value="S" <%=strMarcaPosicaoFinanceira%>>
							Checar posi&ccedil;&atilde;o financeira 
							</strong></td>
							<td width="40%" class="texto1">&nbsp;</td>
							<td width="13%" class="texto1">&nbsp;</td>
							<td width="13%" class="texto1">&nbsp;</td>
						  </tr>
						  <tr>
							<td class="texto1"><strong>
							  Situa&ccedil;&atilde;o cadastral: </strong></td>
							<td colspan="3" class="texto1">
							<strong>
							<%
							if strsituacaoaluno <> "" then
								vetor = split(strsituacaoaluno,",")
							end if
							sql = "select * from sca_situacaoaluno"
							sql = sql & " where cod_empresa = " & Session("CodEmpresa")
							rs.open sql, cnn
							if rs.eof = false then
								cont = 0
								while not rs.eof
								
									selecionado = ""
									if strsituacaoaluno <> "" then
										for i=0 to ubound(vetor)
											if trim(vetor(i)) = trim(rs("cod_situacaoAluno")) then
												selecionado = "checked"
											end if
										next
									end if
									%>
									  <input <%=selecionado%> type="checkbox" name="situacaoaluno" value="<%=rs("cod_situacaoAluno")%>">
									  <%=rs("desc_situacaoAluno")%>
									<%
									cont = cont + 1
									if cont = 4 then response.Write("<br>")
									rs.movenext
								wend
							end if
							rs.close
							%>							  
							  
							</strong></td>
							</tr>
					</table>
					</td>
				  </tr>
				  <tr>
					<td colspan="4" class="texto1"><span class="style1">Obs: <br>
					* 
					  Todos os campos selecionados dever&atilde;o ser utilizados no texto do documento.</span></td>
					</tr>
				  <tr>
				    <td height="19" colspan="4" align="center">&nbsp;</td>
				    </tr>
				  <tr>
					<td colspan="4"><!--#include file="../../includes/inc_botoes_cadastro.asp"--><br></td>
				  </tr>
				  <tr>
					<td height="19" colspan="4" align="center" bgcolor="#EFEFDE"><span class="texto1"><strong>Texto do Documento </strong></span></td>
				  </tr>
				  <tr>
					<td colspan="4"><span class="TextoForm">
					  <%
								''Dim oFCKeditor
								''Set oFCKeditor = New FCKeditor
								''oFCKeditor.BasePath	="../../Sistema/fckeditor/"
								''oFCKeditor.Config("DefaultLanguage") = "pt-br"
								''oFCKeditor.Value = strDescricao
								'oFCKeditor.Width = 540
								''oFCKeditor.Height = 500
								''oFCKeditor.Create "txtDescricao"
								%>
								<Textarea class="ckeditor" cols="80" rows="20" id="txtDescricao" name="txtDescricao"><%=strDescricao%></textarea> 
					</span></td>
				  </tr>
				  <tr>
					<td colspan="4">&nbsp;</td>
				  </tr>
				  <tr>
					<td colspan="4"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
				  </tr>
				  <tr>
					<td colspan="4">&nbsp;</td>
				  </tr>
				  <tr>
					<td colspan="4">
		<%
					cont =0
					
					sql = "SELECT CODIGO, TITULO"
					sql = sql & " FROM SCA_DOCUMENTO"
					sql = sql & " where cod_empresa = " & Session("CodEmpresa")	
					if strMostraSomenteDeptoAtual = "S" then
					   SQL = SQL & " AND (cod_departamento=" & Session("CodDeptoUsuario") & " or cod_departamento is null)"
					end if   
					sql = sql & " Order by TITULO"
					rs.open sql, cnn
									
					if rs.eof = false then
					%>
						<table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
						  <tr bgcolor="#E5E5E5">
						    <td height="21" colspan="2" bgcolor="#E5E5E5" class="celula" align="center"><strong>Documentos Cadastrados </strong></td>
						    </tr>
						  <tr bgcolor="#E5E5E5">
							<td width="10%" height="21" class="celula"><strong>C&oacute;digo</strong></td>
							<td width="90%" class="celula"><strong>T&iacute;tulo<span class="TextoForm"></span></strong></td>
							</tr>
						  <%
						while not rs.eof
							cont = cont + 1	
							%>
						  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
							<td height="20" class="celula"><%=rs("codigo")%></td>
							<td class="celula"><%=trim(rs("titulo"))%></td>
							</tr>
						  <%				
							rs.movenext
							wend
						  %>
						  <tr>
							<td height="21" colspan="2" class="celula">Total Registros : <%=cont%></td>
						  </table>
					  <%
					  end if
					  rs.close%>			</td>
				  </tr>
				  <tr>
					<td colspan="4">&nbsp;</td>
				  </tr>
				</table></td>
            <td width="288" class="texto1" valign="top">
			<div id="documento" style="position:absolute;">
			<table width="288" border="0" cellspacing="2" cellpadding="2">
              <tr>
                <td class="texto1" align="center" bgcolor="#F0F0F0"><strong>Campos a serem inseridos </strong></td>
              </tr>
              <tr id="NOMEALUNO" <%=estiloInicialNomeAluno%>>
                <td class="texto1">[a id=NOMEALUNO][/a]</td>
              </tr>
              <tr id="MATRICULA" <%=estiloInicialMatricula%>>
                <td class="texto1" bgcolor="#F0F0F0">[a id=MATRICULA][/a]</td>
              </tr>
              <tr id="DATANASCIMENTO" <%=estiloInicialDataNascimento%>>
                <td class="texto1">[a id=DATANASCIMENTO][/a]</td>
              </tr>
              <tr id="CIDADENASCIMENTO" <%=estiloInicialCidadeNascimento%>>
                <td class="texto1" bgcolor="#F0F0F0">[a id=CIDADENASCIMENTO][/a]</td>
              </tr>
              <tr id="UFNASCIMENTO" <%=estiloInicialUfNascimento%>>
                <td class="texto1">[a id=UFNASCIMENTO][/a]</td>
              </tr>
              <tr id="CIDADERESIDENCIA" <%=estiloInicialCidadeResidencia%>>
                <td class="texto1" bgcolor="#F0F0F0">[a id=CIDADERESIDENCIA][/a]</td>
              </tr>
              <tr id="UFRESIDENCIA" <%=estiloInicialUfResidencia%>>
                <td class="texto1">[a id=UFRESIDENCIA][/a]</td>
              </tr>
              <tr id="FONE" <%=estiloInicialFone%>>
                <td class="texto1">[a id=FONE][/a]</td>
              </tr>
              <tr id="EMAIL" <%=estiloInicialEmail%>>
                <td class="texto1">[a id=EMAIL][/a]</td>
              </tr>
              <tr id="IDENTIDADE" <%=estiloInicialIdentidade%>>
                <td class="texto1">[a id=IDENTIDADE][/a]</td>
              </tr>
              <tr id="CPF" <%=estiloInicialCPF%>>
                <td class="texto1">[a id=CPF][/a]</td>
              </tr>
              <tr id="TITULO" <%=estiloInicialTitulo%>>
                <td class="texto1">[a id=TITULO][/a]</td>
              </tr>
              <tr id="ANOLETIVO" <%=estiloInicialAnoLetivo%>>
                <td class="texto1" bgcolor="#F0F0F0">[a id=ANOLETIVO][/a]</td>
              </tr>
              <tr id="PAI" <%=estiloInicialPai%>>
                <td class="texto1">[a id=PAI][/a]</td>
              </tr>
              <tr id="MAE" <%=estiloInicialMae%>>
                <td class="texto1" bgcolor="#F0F0F0">[a id=MAE][/a]</td>
              </tr>
              <tr id="CURSOATUAL" <%=estiloInicialCursoAtual%>>
                <td class="texto1">[a id=CURSOATUAL][/a]</td>
              </tr>
              <tr id="PERIODOATUAL" <%=estiloInicialPeriodoAtual%>>
                <td class="texto1" bgcolor="#F0F0F0">[a id=PERIODOATUAL][/a]</td>
              </tr>
              <tr id="TURNOATUAL" <%=estiloInicialTurnoAtual%>>
                <td class="texto1" >[a id=TURNOATUAL][/a]</td>
              </tr>
              <tr id="TURMAALUNO" <%=estiloInicialTurmaAluno%>>
                <td class="texto1"  bgcolor="#F0F0F0">[a id=TURMAALUNO][/a]</td>
              </tr>
              <tr id="SITUACAOALUNO" <%=estiloInicialSituacaoAluno%>>
                <td class="texto1" >[a id=SITUACAOALUNO][/a]</td>
              </tr>
              <tr id="FORMAINGRESSO" <%=estiloInicialFormaIngresso%>>
                <td class="texto1" >[a id=FORMAINGRESSO][/a]</td>
              </tr>
              <tr id="CIDADE" <%=estiloInicialCidade%>>
                <td class="texto1"  bgcolor="#F0F0F0">[a id=CIDADE][/a]</td>
              </tr>
              <tr id="DIA" <%=estiloInicialDia%>>
                <td class="texto1" >[a id=DIA][/a]</td>
              </tr>
              <tr id="MES" <%=estiloInicialMes%>>
                <td class="texto1" bgcolor="#F0F0F0" >[a id=MES][/a]</td>
              </tr>
              <tr id="ANO" <%=estiloInicialAno%>>
                <td class="texto1" >[a id=ANO][/a]</td>
              </tr>
              <tr id="SECRETARIO" <%=estiloInicialSecretario%>>
                <td class="texto1"  bgcolor="#F0F0F0">[a id=SECRETARIO][/a]</td>
              </tr>
              <tr id="DIRETOR" <%=estiloInicialDiretor%>>
                <td class="texto1" >[a id=DIRETOR][/a]</td>
              </tr>
              <tr id="DATAMATRICULA" <%=estiloInicialDataMatricula%>>
                <td class="texto1"   bgcolor="#F0F0F0">[a id=DATAMATRICULA][/a]</td>
              </tr>
              <tr id="NACIONALIDADE" <%=estiloInicialNacionalidade%>>
                <td class="texto1" >[a id=NACIONALIDADE][/a]</td>
              </tr>
              
              <tr id="LOGRADOURO" <%=estiloInicialLogradouro%>>
                <td class="texto1" >[a id=LOGRADOURO][/a]</td>
              </tr>
              <tr id="NUMERO_ENDERECO" <%=estiloInicialNumero_Endereco%>>
                <td class="texto1" >[a id=NUMERO_ENDERECO][/a]</td>
              </tr>
              <tr id="COMP_ENDERECO" <%=estiloInicialComp_Endereco%>>
                <td class="texto1" >[a id=COMP_ENDERECO][/a]</td>
              </tr>
               <tr id="BAIRROALUNO" <%=estiloInicialBairroAluno%>>
                <td class="texto1" >[a id=BAIRROALUNO][/a]</td>
              </tr>
              
              <tr id="ESTADOCIVIL" <%=estiloInicialEstadoCivil%>>
                <td class="texto1"   bgcolor="#F0F0F0">[a id=ESTADOCIVIL][/a]</td>
              </tr>
              <tr id="DATACERTIFICADO" <%=estiloInicialDataCertificado%>>
                <td class="texto1" >[a id=DATACERTIFICADO][/a]</td>
              </tr>
              <tr id="DATACOLACAO" <%=estiloInicialDataColacao%>>
                <td class="texto1"   bgcolor="#F0F0F0">[a id=DATACOLACAO][/a]</td>
              </tr>
              <tr id="RECONHECIMENTO" <%=estiloInicialReconhecimento%>>
                <td class="texto1" >[a id=RECONHECIMENTO][/a]</td>
              </tr>
              <tr id="DATARECONHECIMENTO" <%=estiloInicialDataReconhecimento%>>
                <td class="texto1"   bgcolor="#F0F0F0">[a id=DATARECONHECIMENTO][/a]</td>
              </tr>
              <tr id="AUTORIZACAO" <%=estiloInicialAutorizacao%>>
                <td class="texto1" >[a id=AUTORIZACAO][/a]</td>
              </tr>
              <tr id="DATAAUTORIZACAO" <%=estiloInicialDataAutorizacao%>>
                <td class="texto1" >[a id=DATAAUTORIZACAO][/a]</td>
              </tr>
              <tr id="CH_EXIGIDA" <%=estiloInicialCH_Exigida%>>
                <td class="texto1" >[a id=CH_EXIGIDA][/a]</td>
              </tr>
              <tr id="ANOCONCLUSAO" <%=estiloInicialAnoConclusao%>>
                <td class="texto1"   bgcolor="#F0F0F0">[a id=ANOCONCLUSAO][/a]</td>
              </tr>
              <tr id="SEMESTRE" <%=estiloInicialSemestre%>>
                <td class="texto1"   bgcolor="#F0F0F0">[a id=SEMESTRE][/a]</td>
              </tr>
            </table>
			</div>
			</td>
          </tr>
    </table>
		</form>
		</td>
      </tr>
    </table>
	</td>
  </tr>
</table>
<!--#include file="../rodape.asp"-->
</body>
</html>