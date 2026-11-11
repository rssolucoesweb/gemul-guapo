<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/09/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Cadastro de Aluno 
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
<script type="text/JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../../images/botao_verde_over.gif')">
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file=../../includes/inc_aguarde.asp-->
<script src="../../js/js_funcoes_gerais.js"></script>
<script>
	function AbreFecha(Linha,Figura){
		if (Linha.style.display == "block"){
			Linha.style.display = "none";
			Figura.src="<%=session("strCaminhoRaiz")%>/images/plus.bmp"
		}
		else{
			Linha.style.display = "block";
			Figura.src="<%=session("strCaminhoRaiz")%>/images/minus.bmp"
		}
	}	
	function carregaAluno(){
		if (frm.txtMatricula.value != ""){
			frm.action="Aluno_cad.asp"
			frm.submit();
		}
	}

	function dadosPessoais(){
		if (mostraDadosPessoais.style.display=="none"){
			mostraDadosPessoais.style.display="block"
			frm.imgDadosPessoais.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
		}
		else{
			mostraDadosPessoais.style.display="none"
			frm.imgDadosPessoais.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
		}
	}
	function dadosEndereco(){
		if (mostraDadosEndereco.style.display=="none"){
			mostraDadosEndereco.style.display="block"
			frm.imgDadosEndereco.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
		}
		else{
			mostraDadosEndereco.style.display="none"
			frm.imgDadosEndereco.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
		}
	}
	function dadosFamiliares(){
		if (mostraDadosFamiliares.style.display=="none"){
			mostraDadosFamiliares.style.display="block"
			frm.imgDadosFamiliares.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
		}
		else{
			mostraDadosFamiliares.style.display="none"
			frm.imgDadosFamiliares.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
		}
	}		
	function dadosDocumentos(){
		if (mostraDadosDocumentos.style.display=="none"){
			mostraDadosDocumentos.style.display="block"
			frm.imgDadosDocumentos.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
		}
		else{
			mostraDadosDocumentos.style.display="none"
			frm.imgDadosDocumentos.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
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
	function dadosConclusao(){
		if (mostraDadosConclusao.style.display=="none"){
			mostraDadosConclusao.style.display="block"
			frm.imgDadosConclusao.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
		}
		else{
			mostraDadosConclusao.style.display="none"
			frm.imgDadosConclusao.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
		}
	}	
	function resultadoConsulta(intCodigo){
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function carregaTurma(){
		frm.action="Aluno_cad.asp"
		frm.submit();
	}
	
	function salvar(acao){

		if (frm.txtNomealuno.value==""){
			alert("O nome do aluno deve ser informado.")
			frm.txtNomealuno.focus()
			return false;
		}
		
		var turma = frm.cmbTurma.value;
		var grade = "";
		grade = turma.substring(9,17)

		var turmaAnterior = frm.txtCodTurmaAtual.value;
		var gradeAnterior = "";
		gradeAnterior = turmaAnterior.substring(9,17)
		
		if (frm.cmbTurma.value != "0"){
			if (grade!=gradeAnterior && gradeAnterior !='00000000') {
				var men = 'ATENÇÃO: \nA turma do aluno será alterada, caso a nova turma do aluno for diferente o curso/periodo (Grade Curricular), com esse procedimentos todos as lancamentos para a grade do aluno da turma serão zeradas, inclusive as notas. Deseja continuar com essa alteração?';
				if (confirm(men)) {
					frm.action="Aluno_cod.asp?acao=" + acao;
					frm.submit();
				} else {
					return false;
				}
			}else{
				frm.action="Aluno_cod.asp?acao=" + acao;
				frm.submit();
				return true;
			}
		}else{
			if (frm.cmbTurma.value == "0"){
				alert("A turma do aluno deve ser informada.");
				mostraDadosEscolares.style.display="block"
				frm.imgDadosEscolares.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
				frm.cmbTurma.focus();
				return false;
			}
			frm.action="Aluno_cod.asp?acao=" + acao;
			frm.submit();
			return true;
		}		
 	}

	function foto(codAluno){
		window.open("vincularFotosAluno.asp?codAluno="+codAluno,"consulta", "top=0,left=0,height=300,width=578,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}
</script>
<%
	strPaginaTitulo 		= "Aluno_cad.asp"
	strMostraTodasTurmas 	= Request.Form("strMostraTodasTurmas")
	strExecutarSubmitGradeCurricular = "S"
	'chave da tabela
	strCod_empresa 			= Session("CodEmpresa")
	strSemestre 			= session("strSemestre")
	strAnoLetivo 			= session("strAnoLetivo")

	strNomeBotaoFoto		= "Incluir Foto"

	strCodAluno			= Trim(Request("txtCodAluno"))
	intCodAluno			= Trim(Request("txtCodAluno"))			
	strMatricula 		= Trim(Request("txtMatricula"))
	strNomealuno 		= Trim(Request("txtNomealuno"))

	'dados pessoais
	strDatamatricula 	= formataDataAP(Trim(Request.Form("txtDatamatricula")))
	strNumeroRegistroNascimento	= Trim(Request.Form("txtNumeroRegistroNascimento"))
	strSexo		 		= Trim(Request.Form("cmbSexo"))
	strDatanascimento 	= formataDataAP(Trim(Request.Form("txtDatanascimento")))
	strCidadenascimento = Trim(Request.Form("txtCidadenascimento"))
	strUfnascimento 	= Trim(Request.Form("cmbUfnascimento"))
	strNacionalidade 	= Trim(Request.Form("txtNacionalidade"))
	intCodEstadocivil 	= Trim(Request.Form("cmbEstadoCivil"))
	intCodProfissao 	= Trim(Request.Form("cmbProfissao"))
	intCodReligiao 		= Trim(Request.Form("cmbReligiao"))
	intCodNecessidadeEspecial 	= Trim(Request.Form("cmbNecessidadeEspecial"))
	strAtendimentoespecial 		= Trim(Request.Form("txtAtendimentoespecial"))
	strFoneResidencial 	= Trim(Request.Form("txtFoneResidencial"))
	strFonecomercial 	= Trim(Request.Form("txtFonecomercial"))
	strFoneCelular	 	= Trim(Request.Form("txtFonecelular"))
	strEmail 			= Trim(Request.Form("txtEmail"))
	
	'endereço
	strLogradouro 		= Trim(Request.Form("txtLogradouro"))
	strNumero_endereco 	= Trim(Request.Form("txtNumero_endereco"))
	strComp_endereco 	= Trim(Request.Form("txtComp_endereco"))
	strBairroaluno 		= Trim(Request.Form("txtBairroaluno"))
	strCidaderesidencia	= Trim(Request.Form("txtCidaderesidencia"))
	strUfresidencia 	= Trim(Request.Form("cmbUfresidencia"))
	strCepresidencia 	= Trim(Request.Form("txtCepresidencia"))
	
	'dados familiares
	strPai 				= Trim(Request.Form("txtPai"))
	strPaifalecido 		= Trim(Request.Form("txtPaifalecido"))
	strPaifone 			= Trim(Request.Form("txtPaifone"))
	strPaidatanascimento= formataDataAP(Trim(Request.Form("txtPaidatanascimento")))
	intCodProfissaoPai	= Trim(Request.Form("cmbProfissaoPai"))
	intCodGrauInstrucaoPai= Trim(Request.Form("cmbGrauInstrucaoPai"))

	strMae 				= Trim(Request.Form("txtMae"))
	strMaefalecida 		= Trim(Request.Form("txtMaefalecida"))
	strMaefone 			= Trim(Request.Form("txtMaefone"))
	strMaedatanascimento= formataDataAP(Trim(Request.Form("txtMaedatanascimento")))
	intCodProfissaoMae	= Trim(Request.Form("cmbProfissaoMae"))
	intCodGrauInstrucaoMae= Trim(Request.Form("cmbGrauInstrucaoMae"))

	strResponsavel 				= Trim(Request.Form("txtResponsavel"))
	strResponsavelfone 			= Trim(Request.Form("txtResponsavelfone"))
	strResponsaveldatanascimento= formataDataAP(Trim(Request.Form("txtResponsaveldatanascimento")))
	intCodProfissaoResponsavel	= Trim(Request.Form("cmbProfissaoResponsavel"))
	intCodGrauInstrucaoResponsavel= Trim(Request.Form("cmbGrauInstrucaoResponsavel"))

	intQtdeIrmao 		= Trim(Request.Form("cmdQtdeIrmao"))
	intQtdeIrmaoEscola	= Trim(Request.Form("cmdQtdeIrmaoEscola"))
	
	'documentos
	strIdentidade 		= Trim(Request.Form("txtIdentidade"))
	strIdentidadeOrgao	= Trim(Request.Form("txtIdentidadeOrgao"))
	strIdentidadeUF		= Trim(Request.Form("cmbUFIdentidade"))
	strTituloNumero 	= Trim(Request.Form("txtTituloNumero"))
	strTituloZona 		= Trim(Request.Form("txtTituloZona"))
	strTituloSecao 		= Trim(Request.Form("txtTituloSecao"))
	
	strRegmilitar 		= Trim(Request.Form("txtRegmilitar"))
	strCpfaluno 		= Trim(Request.Form("txtCpfaluno"))
	
	'dados escolares
	intCodGradeCompleta	= Trim(Request.Form("cmbGradeCompleta"))
	if intCodGradeCompleta = "" then intCodGradeCompleta = "0"

	strMesanovestibular = Trim(Request.Form("txtMesanovestibular"))

	intCodFormaIngresso 		= Trim(Request.Form("cmbOrigem"))
	strDataingresso 	= formataDataAP(Trim(Request.Form("txtDataingresso")))
	intCodSituacaoAluno 	= Trim(Request.Form("cmbSituacaoAluno"))

	strDatafastamento 	= formataDataAP(Trim(Request.Form("txtDatafastamento")))
	intCodMotivoAfastamento	= Trim(Request.Form("cmbMotivoAfastamento"))
	strObsafastamento 	= Trim(Request.Form("txtObsafastamento"))

	strDatacolacao 		= formataDataAP(Trim(Request.Form("txtDatacolacao")))
	strAnoconclusao 	= Trim(Request.Form("txtAnoconclusao"))

	strEscola				= Trim(Request.Form("txtEscola"))
	strEscolaOrigem			= Trim(Request.Form("txtEscolaOrigem"))
	strCidade			 	= Trim(Request.Form("txtCidade"))
	strAnoconclusaoEnsinoMedio 	= Trim(Request.Form("txtAnoconclusaoEnsinoMedio"))
	strUfEnsinoMedio	= Trim(Request.Form("cmbUFEnsinoMedio"))


	strSemconclusao 	= Trim(Request.Form("txtSemconclusao"))
	strDatacertificado 	= formataDataAP(Trim(Request.Form("txtDatacertificado")))

	intViaCarterinha 	= Trim(Request.Form("cmbViaCarterinha"))
	strSetransp 		= Trim(Request.Form("txtSetransp"))

	'dados finaceiro
	intCodPlanoPagamento 	= Trim(Request.Form("cmbPlanoPagamento"))
	strBloqueio 		= Trim(Request.Form("txtBloqueio"))
	strOrigbloq 		= Trim(Request.Form("txtOrigbloq"))

	strLogradouro_cobranca 		= Trim(Request.Form("txtLogradouro_cobranca"))
	strNumero_endereco_cobranca	= Trim(Request.Form("txtNumero_endereco_cobranca"))
	strComp_endereco_cobranca 	= Trim(Request.Form("txtComp_endereco_cobranca"))

	if (trim(strCodAluno) <> "" or trim(strMatricula) <> "") and intCodGradeCompleta = "0" then
	
		sql = "SELECT S.Desc_SituacaoAluno, A.* "
		sql = sql & " FROM SCA_ALUNO A"
		sql = sql & " LEFT JOIN SCA_SITUACAOALUNO S ON S.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND S.COD_EMPRESA = A.COD_EMPRESA"
		sql = sql & " Where A.COD_EMPRESA = " & strCod_empresa
		if strCodAluno <> "" then
			sql = sql & " And 	A.codigo = " & strCodAluno
		else
			sql = sql & " And 	A.matricula = " & strMatricula
		end if
		rs.open sql, cnn
		
		if rs.eof = false then
			strSituacaoAluno	= TRIM(rs("Desc_SituacaoAluno"))
			'dados pessoais
			strCodAluno			= TRIM(rs("Codigo"))
			intCodAluno			= TRIM(rs("Codigo"))
			strMatricula 		= TRIM(rs("Matricula"))
			strNomealuno 		= TRIM(rs("Nomealuno"))
			strDatamatricula 	= formataDataAP(TRIM(rs("Datamatricula")))
			strNumeroRegistroNascimento  = TRIM(rs("NUMREGISTRONASC"))
			strSexo		 		= TRIM(rs("SexoAluno"))
			strDatanascimento 	= formataDataAP(TRIM(rs("Datanascimento")))
			strCidadenascimento = TRIM(rs("Cidadenascimento"))
			strUfnascimento 	= TRIM(rs("Ufnascimento"))
			strNacionalidade 	= TRIM(rs("Nacionalidade"))
			intCodEstadocivil 	= TRIM(rs("cod_EstadoCivil"))
			intCodProfissao 	= TRIM(rs("cod_Profissao"))
			intCodReligiao 	= TRIM(rs("cod_Religiao"))
			intCodNecessidadeEspecial 	= TRIM(rs("Cod_necespecial"))
			strAtendimentoespecial 	= TRIM(rs("Atendimentoespecial"))
			strFoneResidencial 	= TRIM(rs("FoneResidencial"))
			strFonecomercial 	= TRIM(rs("Fonecomercial"))
			strFoneCelular	 	= TRIM(rs("Fonecelular"))
			strEmail 			= TRIM(rs("Email"))
			
			'endereço
			strLogradouro 		= TRIM(rs("Logradouro"))
			strNumero_endereco 	= TRIM(rs("Numero_endereco"))
			strComp_endereco 	= TRIM(rs("Comp_endereco"))
			strBairroaluno 		= TRIM(rs("Bairroaluno"))
			strCidaderesidencia	= TRIM(rs("Cidaderesidencia"))
			strUfresidencia 	= TRIM(rs("Ufresidencia"))
			strCepresidencia 	= TRIM(rs("Cepresidencia"))
			
			'dados familiares
			strPai 				= TRIM(rs("Pai"))
			strPaifalecido 		= TRIM(rs("Paifalecido"))
			strPaifone 			= TRIM(rs("Paifone"))
			strPaidatanascimento= formataDataAP(TRIM(rs("Paidatanascimento")))
			intCodProfissaoPai= TRIM(rs("Pai_cod_profissao"))
			intCodGrauInstrucaoPai= TRIM(rs("Pai_cod_grauinstrucao"))

			strMae 				= TRIM(rs("Mae"))
			strMaefalecida 		= TRIM(rs("Maefalecida"))
			strMaefone 			= TRIM(rs("Maefone"))
			strMaedatanascimento= formataDataAP(TRIM(rs("Maedatanascimento")))
			intCodProfissaoMae= TRIM(rs("Mae_cod_profissao"))
			intCodGrauInstrucaoMae= TRIM(rs("Mae_cod_grauinstrucao"))

			strResponsavel 				= TRIM(rs("Responsavel"))
			strResponsavelfone 			= TRIM(rs("Responsavelfone"))
			strResponsaveldatanascimento= formataDataAP(TRIM(rs("Responsaveldatanascimento")))
			intCodProfissaoResponsavel= TRIM(rs("Responsavel_cod_profissao"))
			intCodGrauInstrucaoResponsavel= TRIM(rs("Responsavel_cod_grauinstrucao"))

			intQtdeIrmao 		= TRIM(rs("Qtde_irmao"))
			intQtdeIrmaoEscola	= TRIM(rs("Qtde_irmao_escola"))

			'documentos
			strIdentidade 		= TRIM(rs("Identidade"))
			strIdentidadeOrgao	= TRIM(rs("IdentidadeOrgao"))
			strIdentidadeUF		= TRIM(rs("IdentidadeUF"))
			
			strTituloNumero 	= TRIM(rs("TituloEleitor"))
			strTituloZona	 	= TRIM(rs("TituloZona"))
			strTituloSecao	 	= TRIM(rs("TituloSecao"))
			
			strRegmilitar 		= TRIM(rs("Regmilitar"))
			strCpfaluno 		= TRIM(rs("Cpfaluno"))
			
			'dados escolares
			intCodGradeCompleta	= TRIM(rs("Cod_gradevestibular"))
			strMesanovestibular = TRIM(rs("Mesanovestibular"))
		
			intCodFormaIngresso 		= TRIM(rs("cod_FormaIngresso"))
			strDataingresso 	= formataDataAP(TRIM(rs("Dataingresso")))
			intCodSituacaoAluno	= TRIM(rs("cod_SituacaoAluno"))
		
			strDatafastamento 	= formataDataAP(TRIM(rs("Datafastamento")))
			intCodMotivoAfastamento	= TRIM(rs("Cod_motivoafastamento"))
			strObsafastamento 	= TRIM(rs("Obsafastamento"))
		
			strDatacolacao 		= formataDataAP(TRIM(rs("Datacolacao")))
			strAnoconclusao 	= TRIM(rs("Anoconclusao"))
			strSemconclusao 	= TRIM(rs("Semconclusao"))
			strDatacertificado 	= formataDataAP(TRIM(rs("Datacertificado")))
		
			intViaCarterinha 	= TRIM(rs("Ctrviace"))
			strSetransp 		= TRIM(rs("Setransp"))
		
			'dados finaceiro
			intCodPlanoPagamento 	= TRIM(rs("cod_PlanoTurma"))
			strBloqueio 		= TRIM(rs("Bloqueio"))
			strOrigbloq 		= TRIM(rs("Origbloq"))
		
			strLogradouro_cobranca 		= TRIM(rs("Logradouro_cobranca"))
			strNumero_endereco_cobranca	= TRIM(rs("Numero_endereco_cobranca"))
			strComp_endereco_cobranca 	= TRIM(rs("Comp_endereco_cobranca"))
		
			strEscola				= Trim(RS("Escola_ensinomedio"))
			strEscolaOrigem			= Trim(RS("Escola_origem"))
			strCidade			 	= Trim(RS("Cidade_ensinomedio"))
			strAnoconclusaoEnsinoMedio 	= Trim(RS("ano_ensinomedio"))
			strUfEnsinoMedio	= Trim(RS("uf_ensinomedio"))		
			
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			rs.close

			'VERIFICAÇÃO DE BLOQUEIO
			%>
			<!--#include file="../includes/inc_VerificaBloqueio.asp"-->
			<%

			strCaminhoFoto = session("strCaminhoRaiz") & "/fotoAluno/semFotoAtivo.gif"
			strFoto =  "<img src='" & strCaminhoFoto & "' width='100' height='110'>"
	
			sql = "SELECT arquivo "
			sql = sql & " FROM 	SCA_ALUNO_FOTO"
			sql = sql & " Where COD_EMPRESA = " & strCod_empresa
			sql = sql & " And 	codAluno = " & strCodAluno
			rs.open sql, cnn
			if rs.eof = false then
				strCaminhoFoto = session("strCaminhoRaiz") & "/fotoAluno/" & strCod_empresa & "/" & rs("arquivo")
				strFoto =  "<img src='" & strCaminhoFoto & "' width='100' height='110'>"
				strNomeBotaoFoto	= "Alterar Foto"
			end if
			rs.close
		else
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

			strCaminhoFoto = session("strCaminhoRaiz") & "/fotoAluno/semFoto.gif"
			strFoto =  "<img src='" & strCaminhoFoto & "' width='100' height='110'>"

			rs.close
		end if 
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		strCaminhoFoto = session("strCaminhoRaiz") & "/fotoAluno/semFoto.gif"
		strFoto =  "<img src='" & strCaminhoFoto & "' width='100' height='110'>"
	end if 
%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="751"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post" action="Aluno_cad.asp">
		  <table width="708" border="0" cellpadding="0" cellspacing="0">

            <tr valign="top">
              <td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
		  <%
		  	'parametro para a lista de ocorrencias
			'1 -  intCodAluno
			'2 - intCodEmpresa
			'colocar a função 	function AbreFecha(Linha,Figura)
			intCodAluno	  = strCodAluno
			intCodEmpresa = strCod_empresa
		  %>
		  <!--#include file="../includes/inc_ListaOcorrencias.asp"-->
		  <table width="790" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td colspan="2"><hr size="1" color="#999999"><input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="10" value="<%=strCodAluno%>" maxlength="10"></td>
          </tr>
          <tr>
            <td width="457" height="20" bgcolor="#EEEEEE" class="texto1" style="cursor:hand" onClick="return dadosPessoais()"><img id="imgDadosPessoais" src="<%=session("strCaminhoRaiz")%>/images/down.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Dados Pessoais</strong></td>
            <td width="246" height="20" bgcolor="#EEEEEE" class="texto1"  align="left">
			&nbsp;Situa&ccedil;&atilde;o:
			<%'if Session("strChecarFinanceiro") = "S" then%>
			 	<strong><%=strSituacaoAluno%></strong>&nbsp;&nbsp;
			<%'else%>
				<!--include file="../includes/inc_cmdSituacaoAluno.asp" -->&nbsp;&nbsp;
			<%'end if%>
			</td>
          </tr>
          <tr>
            <td colspan="2" class="texto1" >
				<!-- INICIO CAMPO - DADOS PESSOAIS-->
				<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#F5F5F5" id="mostraDadosPessoais">
				  <tr>
					<td width="18%" class="texto1">&nbsp;Matr&iacute;cula: </td>
					<td width="47%" class="texto1"><input name="txtMatricula" type="text" class="text" id="txtMatricula" size="20" maxlength="9" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 9)" onBlur="carregaAluno()">
					  <a  href="#" onClick="return abreConsulta('Aluno_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a></td>
					<td rowspan="7" align="center" class="texto1">&nbsp;</td>
					<td rowspan="7" align="center" class="texto1">
					<table width="120" height="130" border="0" cellpadding="0" cellspacing="0">
                      <tr>
                        <td bgcolor="#FFFFFF" align="center" class="text"><%=strFoto%></td>
                      </tr>
                    </table>
					</td>
				  </tr>
				  <tr>
					<td class="texto1">&nbsp;Nome Completo: </td>
					<td class="texto1"><input name="txtNomealuno" type="text" class="text" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>"  onKeyPress="return formataCampo(this, 1, 50)"></td>
					</tr>
				  <tr>
					<td class="texto1">&nbsp;Data Nascimento: </td>
					<td class="texto1"><input name="txtDatanascimento" type="text" class="text" id="txtDatanascimento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDatanascimento%>"></td>
					</tr>
				  <tr>
				    <td class="texto1">&nbsp;Data Matr&iacute;cula: </td>
				    <td class="texto1"><input name="txtDatamatricula" type="text" class="text" id="txtDatamatricula" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDatamatricula%>"></td>
				    </tr>
				  <tr>
				    <td class="texto1">&nbsp;N. Reg. Nasc.: </td>
				    <td class="texto1"><input name="txtNumeroRegistroNascimento" type="text" class="text" id="txtNumeroRegistroNascimento" size="20" maxlength="20" value="<%=strNumeroRegistroNascimento%>"  onKeyPress="return formataCampo(this, 2, 20)"></td>
				    </tr>
				  <tr>
				    <td class="texto1">&nbsp;Sexo: </td>
				    <td class="texto1"><!--#include file="../includes/inc_cmdSexo.asp" --></td>
				    </tr>
				  <tr>
					<td class="texto1">&nbsp;Naturalidade: </td>
					<td class="texto1"><input name="txtCidadenascimento" type="text" class="text" id="txtCidadenascimento" size="20" maxlength="40" value="<%=strCidadenascimento%>" onKeyPress="return formataCampo(this, 1, 40)">
					  UF: 
					  <!--#include file="../includes/inc_cmdUFNascimento.asp" --></td>
					</tr>
				  <tr>
				    <td class="texto1">&nbsp;Nacionalidade:</td>
				    <td class="texto1"><input name="txtNacionalidade" type="text" class="text" id="txtNacionalidade" size="20" maxlength="40" value="<%=strNacionalidade%>" onKeyPress="return formataCampo(this, 1, 40)"></td>
				    <td class="texto1" align="center">&nbsp;</td>
				    <td class="texto1" align="center"><input type="button" name="cmdIncluir2" style="cursor:hand"   value="<%=strNomeBotaoFoto%>" class="botao" <%=strDesabilitaAlterar%> onClick="foto('<%=intCodAluno%>')"></td>
				  </tr>
				  <tr>
					<td class="texto1">&nbsp;Profiss&atilde;o: </td>
					<td class="texto1"><!--#include file="../includes/inc_cmdProfissao.asp" --></td>
					<td colspan="2" class="texto1" align="center">&nbsp;</td>
				  </tr>
				  <tr>
				    <td class="texto1">&nbsp;Est. Civil:</td>
				    <td class="texto1"><!--#include file="../includes/inc_cmdEstadoCivil.asp" --></td>
				    <td class="texto1">&nbsp;Religi&atilde;o: </td>
				    <td class="texto1"><!--#include file="../includes/inc_cmdReligiao.asp" --></td>
				  </tr>
				  <tr>
					<td class="texto1">&nbsp;Fone Residencial: </td>
					<td class="texto1"><input name="txtFoneResidencial" type="text" class="text" id="txtFoneResidencial" onKeyPress="mascara(this,telefone)"  size="20" maxlength="14" value="<%=strFoneResidencial%>"></td>
					<td class="texto1">&nbsp;Celular: </td>
					<td class="texto1"><input name="txtFonecelular" type="text" class="text" id="txtFonecelular" onKeyPress="mascara(this,telefone)"  size="20" maxlength="14" value="<%=strFonecelular%>"></td>
				  </tr>
				  <tr>
					<td class="texto1">&nbsp;e-mail: </td>
					<td class="texto1"><input name="txtEmail" type="text" class="text" id="txtEmail" size="50" maxlength="100" value="<%=strEmail%>"></td>
					<td class="texto1">&nbsp;Fone Comercial : </td>
					<td class="texto1"><input name="txtFoneComercial" type="text" class="text" id="txtFoneComercial" onKeyPress="mascara(this,telefone)"  size="20" maxlength="14" value="<%=strFoneComercial%>"></td>
				  </tr>
				  <tr>
                    <td class="texto1">&nbsp;Nec. Especiais: </td>
				    <td class="texto1"><!--#include file="../includes/inc_cmdNecessidadeEspecial.asp" --></td>
				    <td class="texto1">&nbsp;Atend. Especial : </td>
				    <td class="texto1"><span class="TextoForm">
                      <select name="txtAtendimentoespecial" class="Combo" id="txtAtendimentoespecial">
                        <option value="S" <%if strAtendimentoespecial = "S" then response.Write("selected") %>>Sim</option>
                        <option selected value="N" <%if strAtendimentoespecial = "N" then response.Write("selected") %>>N&atilde;o</option>
                      </select>
                    </span></td>
				    </tr>
				</table>
				<!-- FIM CAMPO - DADOS PESSOAIS-->			</td>
          </tr>
          <tr>
            <td colspan="2"><hr size="1" color="#999999"></td>
          </tr>
          <tr>
            <td height="20" colspan="2" bgcolor="#EEEEEE" class="texto1" style="cursor:hand" onClick="return dadosEndereco()"><img id="imgDadosEndereco" src="<%=session("strCaminhoRaiz")%>/images/down.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Endereço</strong></td>
            </tr>
          <tr>
            <td colspan="2" class="texto1" >
				<!-- INICIO CAMPO - DADOS ENDEREÇO-->
				<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#F5F5F5" id="mostraDadosEndereco">
				  <tr>
					<td width="18%" class="texto1">&nbsp;Logradouro: </td>
					<td width="47%" class="texto1"><input name="txtLogradouro" type="text" class="text" id="txtLogradouro" size="40" maxlength="60" value="<%=strLogradouro%>"></td>
					<td width="16%" class="texto1">&nbsp;N&uacute;mero:</td>
					<td width="19%" class="texto1"><input name="txtNumero_endereco" type="text" class="text" id="txtNumero_endereco" size="20" maxlength="5" value="<%=strNumero_endereco%>"></td>
				  </tr>
				  <tr>
					<td class="texto1"> &nbsp;Complemento:</td>
					<td class="texto1"><input name="txtComp_endereco" type="text" class="text" id="txtComp_endereco" size="50" maxlength="50" value="<%=strComp_endereco%>" ></td>
					<td class="texto1">&nbsp;CEP:</td>
					<td class="texto1"><input name="txtCepresidencia" type="text" class="text" id="txtCepresidencia" size="9" maxlength="9" value="<%=strCepresidencia%>" onKeyPress="mascara(this,cep)" ></td>
				  </tr>
				  <tr>
				    <td class="texto1">&nbsp;Bairro:</td>
				    <td class="texto1"><input name="txtBairroaluno" type="text" class="text" id="txtBairroaluno" size="40" maxlength="40" value="<%=strBairroaluno%>" onKeyPress="return formataCampo(this, 1, 40)"></td>
				    <td class="texto1">&nbsp;</td>
				    <td class="texto1">&nbsp;</td>
				    </tr>
				  <tr>
					<td class="texto1">&nbsp;Munic&iacute;pio:</td>
					<td class="texto1"><input name="txtCidaderesidencia" type="text" class="text" id="txtCidaderesidencia" size="40" maxlength="40" value="<%=strCidaderesidencia%>" onKeyPress="return formataCampo(this, 1, 40)"></td>
					<td class="texto1">&nbsp;UF:</td>
					<td class="texto1"><!--#include file="../includes/inc_cmdUFResidencia.asp" --></td>
				  </tr>
				</table>
				<!-- FIM CAMPO - DADOS ENDEREÇO-->			</td>
          </tr>
          <tr>
            <td colspan="2"><hr size="1" color="#999999"></td>
          </tr>
          <tr>
            <td height="20" colspan="2" bgcolor="#EEEEEE" class="texto1" style="cursor:hand" onClick="return dadosFamiliares()"><img id="imgDadosFamiliares" src="<%=session("strCaminhoRaiz")%>/images/down.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Dados Familiares</strong></td>
            </tr>
          <tr>
            <td colspan="2" class="texto1" >
				<!-- INICIO CAMPO - DADOS FAMILIARES-->
				<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#F5F5F5" id="mostraDadosFamiliares">
				  <tr>
					<td width="18%" class="texto1">&nbsp;Pai: </td>
					<td width="46%" class="texto1"><input name="txtPai" type="text" class="text" id="txtPai" size="50" maxlength="50" value="<%=strPai%>" onKeyPress="return formataCampo(this, 1, 50)"></td>
					<td width="17%" class="texto1">&nbsp;Falecido:</td>
					<td width="19%" class="texto1"><span class="TextoForm">
					  <select name="txtPaifalecido" class="Combo" id="txtPaifalecido">
                        <option value="S" <%if strPaifalecido = "M" then response.Write("selected") %>>Sim</option>
                        <option selected value="N" <%if strPaifalecido = "F" then response.Write("selected") %>>N&atilde;o</option>
                      </select>
                    </span></td>
				  </tr>
				  <tr>
				    <td class="texto1">&nbsp;Data Nascimento: </td>
				    <td class="texto1"><input name="txtPaidatanascimento" type="text" class="text" id="txtPaidatanascimento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strPaidatanascimento%>"></td>
				    <td class="texto1">&nbsp;Telefone:</td>
				    <td class="texto1"><input name="txtPaifone" type="text" class="text" id="txtPaifone" onKeyPress="mascara(this,telefone)"  size="20" maxlength="14" value="<%=strPaifone%>"></td>
				    </tr>
				  <tr>
				    <td class="texto1">&nbsp;Profiss&atilde;o: </td>
				    <td class="texto1"><!--#include file="../includes/inc_cmdProfissaoPai.asp" --></td>
				    <td class="texto1">&nbsp;Grau Instru&ccedil;&atilde;o: </td>
				    <td class="texto1"><!--#include file="../includes/inc_cmdGrauInstrucaoPai.asp" --></td>
				    </tr>
				  <tr>
				    <td colspan="4" class="texto1"><hr size="2" color="#FFFFFF" ></td>
				  </tr>
				  <tr>
					<td class="texto1">&nbsp;M&atilde;e: </td>
					<td class="texto1"><input name="txtMae" type="text" class="text" id="txtMae" size="50" maxlength="50" value="<%=strMae%>" onKeyPress="return formataCampo(this, 1, 50)"></td>
					<td class="texto1">&nbsp;Falecida:</td>
					<td class="texto1"><span class="TextoForm">
					  <select name="txtMaefalecida" class="Combo" id="txtMaefalecida">
                        <option value="S" <%if strMaefalecida = "S" then response.Write("selected") %>>Sim</option>
                        <option selected value="N" <%if strMaefalecida = "N" then response.Write("selected") %>>N&atilde;o</option>
                      </select>
                    </span></td>
				  </tr>
				  <tr>
					<td class="texto1">&nbsp;Data Nascimento:</td>
					<td class="texto1"><input name="txtMaedatanascimento" type="text" class="text" id="txtMaedatanascimento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strMaedatanascimento%>"></td>
					<td class="texto1">&nbsp;Telefone:</td>
					<td class="texto1"><input name="txtMaefone" type="text" class="text" id="txtMaefone" onKeyPress="mascara(this,telefone)"  size="20" maxlength="14" value="<%=strMaefone%>"></td>
				  </tr>
				  <tr>
					<td class="texto1">&nbsp;Profiss&atilde;o: </td>
					<td class="texto1"><!--#include file="../includes/inc_cmdProfissaoMae.asp" --></td>
					<td class="texto1">&nbsp;Grau Instru&ccedil;&atilde;o: </td>
					<td class="texto1"><!--#include file="../includes/inc_cmdGrauInstrucaoMae.asp" --></td>
				  </tr>
				  <tr>
				    <td colspan="4" class="texto1"><hr size="2" color="#FFFFFF" ></td>
				  </tr>
				  <tr>
					<td class="texto1">&nbsp;Respons&aacute;vel: </td>
					<td class="texto1"><input name="txtResponsavel" type="text" class="text" id="txtResponsavel" size="50" maxlength="50" value="<%=strResponsavel%>" onKeyPress="return formataCampo(this, 1, 50)"></td>
					<td class="texto1">&nbsp;Telefone:</td>
					<td class="texto1"><input name="txtResponsavelfone" type="text" class="text" id="txtResponsavelfone" onKeyPress="mascara(this,telefone)"  size="20" maxlength="14" value="<%=strResponsavelfone%>"></td>
				  </tr>
				  <tr>
					<td class="texto1">&nbsp;Data Nascimento:</td>
					<td class="texto1"><input name="txtResponsaveldatanascimento" type="text" class="text" id="txtResponsaveldatanascimento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strResponsaveldatanascimento%>"></td>
					<td class="texto1">&nbsp;Grau Instru&ccedil;&atilde;o: </td>
					<td class="texto1"><!--#include file="../includes/inc_cmdGrauInstrucaoResponsavel.asp" --></td>
				  </tr>
				  <tr>
					<td class="texto1">&nbsp;Profiss&atilde;o: </td>
					<td class="texto1"><!--#include file="../includes/inc_cmdProfissaoResponsavel.asp" --></td>
					<td class="texto1">&nbsp;</td>
					<td class="texto1">&nbsp;</td>
				  </tr>
				  <tr>
				    <td colspan="4" class="texto1"><hr size="2" color="#FFFFFF" ></td>
				  </tr>
				  <tr>
					<td class="texto1">&nbsp;Qtde. Irm&atilde;os: </td>
					<td class="texto1"><!--#include file="../includes/inc_cmdQtdeIrmao.asp" --></td>
					<td class="texto1">&nbsp;Na mesma Escola:</td>
					<td class="texto1"><!--#include file="../includes/inc_cmdQtdeIrmaoEscola.asp" --></td>
				  </tr>
				</table>
				<!-- FIM CAMPO - DADOS FAMILIARES-->			</td>
          </tr>
          <tr>
            <td colspan="2"><hr size="1" color="#999999"></td>
          </tr>
          <tr>
            <td height="20" colspan="2" bgcolor="#EEEEEE" class="texto1" style="cursor:hand" onClick="return dadosDocumentos()"><img id="imgDadosDocumentos" src="<%=session("strCaminhoRaiz")%>/images/down.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Documentação</strong></td>
            </tr>
          <tr>
            <td colspan="2" class="texto1" >
				<!-- INICIO CAMPO - DADOS DOCUMENTOS-->
				<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#F5F5F5" id="mostraDadosDocumentos">
				  <tr>
					<td width="18%" class="texto1">&nbsp;Identidade: </td>
					<td width="47%" class="texto1"><input name="txtIdentidade" type="text" class="text" id="txtIdentidade" size="10" maxlength="20" value="<%=strIdentidade%>">
					  &nbsp;&Oacute;rg&atilde;o : 
					  <input name="txtIdentidadeOrgao" type="text" class="text" id="txtIdentidadeOrgao" size="10" maxlength="10" value="<%=strIdentidadeOrgao%>">
					  &nbsp;UF : 
					  <!--#include file="../includes/inc_cmdUFIdentidade.asp" --></td>
					<td width="16%" class="texto1">&nbsp;CPF:</td>
					<td width="19%" class="texto1"><input name="txtCpfaluno" type="text" class="text" id="txtCpfaluno" size="20" maxlength="14" value="<%=strCpfaluno%>" onKeyPress="return formataCampo(this, 5, 14)"></td>
				  </tr>
				  <tr>
				    <td class="texto1">&nbsp;Registro Militar  : </td>
				    <td class="texto1"><input name="txtRegmilitar" type="text" class="text" id="txtRegmilitar" size="40" maxlength="40" value="<%=strRegmilitar%>"></td>
				    <td class="texto1">&nbsp;</td>
				    <td class="texto1">&nbsp;</td>
				    </tr>
				  <tr>
					<td class="texto1">&nbsp;T&iacute;tulo:</td>
					<td colspan="2" class="texto1">Num&eacute;ro :
                      <input name="txtTituloNumero" type="text" class="text" id="txtTituloNumero" onKeyPress="return formataCampo(this,2,23)" size="10" maxlength="23" value="<%=strTituloNumero%>" > 
Zona :
<input name="txtTituloZona" type="text" class="text" id="txtTituloZona" onKeyPress="return formataCampo(this,2,10)" size="10" maxlength="10" value="<%=strTituloZona%>">
Se&ccedil;&atilde;o :
<input name="txtTituloSecao" type="text" class="text" id="txtTituloSecao"  onKeyPress="return formataCampo(this,2,10)" size="5" maxlength="3" value="<%=strTituloSecao%>"></td>
					<td class="texto1">&nbsp;</td>
				  </tr>
				</table>
				<!-- FIM CAMPO - DADOS DOCUMENTOS-->			</td>
          </tr>
          <tr>
            <td colspan="2"><hr size="1" color="#999999"></td>
          </tr>
          <tr>
            <td height="20" colspan="2" bgcolor="#EEEEEE" class="texto1" style="cursor:hand" onClick="return dadosEscolares()"><img id="imgDadosEscolares" src="<%=session("strCaminhoRaiz")%>/images/down.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Dados Escolares</strong></td>
            </tr>
          <tr>
            <td colspan="2" class="texto1" >
<%
				if strCodAluno <> "" then
					intCodTurma = ""
					intCod_GradeCurricular = ""
					'aluno na turma
					sql = "select AT.COD_TURMA, T.Cod_GradeCurricular"
					sql = sql & " from SCA_ALUNO_TURMA AT"
					sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA "
					sql = sql & " AND AT.ANO_LETIVO = T.AnoLetivo AND AT.SEMESTRE = T.Cod_Semestre"
					sql = sql & " where AT.COD_EMPRESA = " &  strCod_empresa
					sql = sql & " and AT.COD_ALUNO = " &  strCodAluno
					sql = sql & " and AT.ANO_LETIVO = " &  session("strAnoLetivo")
					sql = sql & " and AT.SEMESTRE IN (" &  session("strSemestre") & ")"
					sql = sql & " and AT.SITUACAO = 'A'"'ATIVA
					rs.open sql, cnn
					if not rs.eof then
						intCodTurma = rs("cod_Turma")
						intCod_GradeCurricular = rs("Cod_GradeCurricular")
					end if
					rs.close
				end if	
				strSem = session("strSemestre")	
				if session("strSemestre") = "3" then strSem = "Anual"
				if session("strSemestre") = "1,3" then strSem = "1ºSem/Anual"
				if session("strSemestre") = "2,3" then strSem = "2ºSem/Anual"
%>			
				<!-- INICIO CAMPO - DADOS ESCOLARES-->
				<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#F5F5F5" id="mostraDadosEscolares">
				  <tr>
					<td width="18%" class="texto1">&nbsp;Turma <%=session("strAnoLetivo")%>/<%=strSem%>:</td>
					<td colspan="3" class="texto1"><!--#include file="../includes/inc_cmdTurmaGrade.asp" --></td>
					</tr>
				  <tr>
					<td class="texto1">&nbsp;Forma Ingresso: </td>
					<td width="47%" class="texto1"><!--#include file="../includes/inc_cmdFormaIngresso.asp" --></td>
					<td width="16%" class="texto1">&nbsp;Ano/Sem. Ingresso:</td>
					<td width="19%" class="texto1"><input name="txtMesanovestibular" type="text" class="text" id="txtMesanovestibular" size="7" maxlength="6" value="<%=strMesanovestibular%>" ></td>
				  </tr>
				  <tr>
				    <td colspan="4" class="texto1"><hr size="2" color="#FFFFFF" ></td>
				  </tr>
				  <tr>
					<td class="texto1">&nbsp;Data Ingresso: </td>
					<td class="texto1"><input name="txtDataingresso" type="text" class="text" id="txtDataingresso" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataingresso%>"></td>
					<td class="texto1">&nbsp;Dt. Afastamento: </td>
					<td class="texto1"><input name="txtDatafastamento" type="text" class="text" id="txtDatafastamento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDatafastamento%>"></td>
				  </tr>
				  <tr>
					<td class="texto1">&nbsp;Obs:</td>
					<td class="texto1"><textarea class="text" id="txtObsafastamento" name="txtObsafastamento" cols="55" rows="3"><%=strObsafastamento%></textarea></td>
					<td class="texto1">&nbsp;Motivo Afast.:</td>
					<td class="texto1"><!--#include file="../includes/inc_cmdMotivoAfastamento.asp" --></td>
				  </tr>
				  <tr>
				    <td class="texto1">&nbsp;Via Carteirinha:</td>
				    <td class="texto1"><!--#include file="../includes/inc_cmdViaCarterinha.asp" --></td>
				    <td class="texto1">&nbsp;Setransp:</td>
				    <td class="texto1"><input name="txtSetransp" type="text" class="text" id="txtSetransp" size="20" maxlength="15" value="<%=strSetransp%>"></td>
				    </tr>
				  <tr>
				    <td height="20" colspan="4" class="texto1">&nbsp;&nbsp;<strong>Conclus&atilde;o do Ensino M&eacute;dio</strong></td>
				    </tr>
				  <tr>
				    <td class="texto1">&nbsp;Escola: </td>
				    <td class="texto1"><input name="txtEscola" type="text" class="text" id="txtEscola" size="50" maxlength="100" value="<%=strEscola%>"  onKeyPress="return formataCampo(this, 1, 100)"></td>
				    <td class="texto1">Ano Conclus&atilde;o: </td>
				    <td class="texto1"><input name="txtAnoconclusaoEnsinoMedio" type="text" class="text" id="txtAnoconclusaoEnsinoMedio" size="5" maxlength="4" value="<%=strAnoconclusaoEnsinoMedio%>" onKeyPress="return formataCampo(this, 2, 4)"></td>
				    </tr>
				  <tr>
				    <td class="texto1">&nbsp;Cidade:</td>
				    <td class="texto1"><input name="txtCidade" type="text" class="text" id="txtCidade" size="50" maxlength="50" value="<%=strCidade%>" onKeyPress="return formataCampo(this, 1, 50)"></td>
				    <td class="texto1">UF:</td>
				    <td class="texto1"><!--#include file="../includes/inc_cmdUFEnsinoMedio.asp" --></td>
				    </tr>
				  <tr>
				    <td class="texto1"> &nbsp;IES/Escola de Origem: </td>
				    <td class="texto1"><input name="txtEscolaOrigem" type="text" class="text" id="txtEscolaOrigem" size="50" maxlength="100" value="<%=strEscolaOrigem%>"  onKeyPress="return formataCampo(this, 1, 100)"></td>
				    <td class="texto1">&nbsp;</td>
				    <td class="texto1">&nbsp;</td>
				    </tr>
				</table>
				<!-- FIM CAMPO - DADOS ESCOLARES-->			</td>
          </tr>
          <tr>
            <td colspan="2"><hr size="1" color="#999999"></td>
          </tr>
          <tr>
            <td height="20" colspan="2" bgcolor="#EEEEEE" class="texto1" style="cursor:hand" onClick="return dadosConclusao()"><img id="imgDadosConclusao" src="<%=session("strCaminhoRaiz")%>/images/down.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Dados da Conclus&atilde;o</strong></td>
            </tr>
          <tr>
            <td colspan="2" class="texto1" >
				<!-- INICIO CAMPO - DADOS DOCUMENTOS-->
				<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#F5F5F5" id="mostraDadosConclusao">
				  <tr>
					<td width="18%" class="texto1">&nbsp;Data Cola&ccedil;&atilde;o: </td>
					<td width="47%" class="texto1"><input name="txtDatacolacao" type="text" class="text" id="txtDatacolacao" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDatacolacao%>"></td>
					<td width="16%" class="texto1">&nbsp;Ano Conclus&atilde;o: </td>
					<td width="19%" class="texto1"><input name="txtAnoconclusao" type="text" class="text" id="txtAnoconclusao" size="20" maxlength="4" value="<%=strAnoconclusao%>" onKeyPress="return formataCampo(this, 2, 4)"></td>
				  </tr>
				  <tr>
				    <td class="texto1">&nbsp;Data Certificado: </td>
				    <td class="texto1"><input name="txtDatacertificado" type="text" class="text" id="txtDatacertificado" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDatacertificado%>"></td>
				    <td class="texto1">&nbsp;Sem Conclus&atilde;o: </td>
				    <td class="texto1"><input name="txtSemconclusao" type="text" class="text" id="txtSemconclusao" size="20" maxlength="1" value="<%=strSemconclusao%>" onKeyPress="return formataCampo(this, 1, 1)"></td>
				  </tr>
				</table>
				<!-- FIM CAMPO - DADOS DOCUMENTOS-->			</td>
          </tr>
          <tr>
            <td colspan="2"><hr size="1" color="#999999"></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
        </table>
	<%	if trim(strCodAluno) = "" and strMostraTodasTurmas = "" then %>
		<script>
			mostraDadosPessoais.style.display="block";
			dadosEndereco();
			dadosFamiliares();
			dadosDocumentos();
			dadosEscolares();
			dadosConclusao();
		</script>
	<%	else	%>		
		<script>
			mostraDadosPessoais.style.display="block";
			mostraDadosEndereco.style.display="block";
			mostraDadosFamiliares.style.display="block";
			mostraDadosDocumentos.style.display="block";
			mostraDadosEscolares.style.display="block";
			mostraDadosConclusao.style.display="block";
		</script>
	<%	end if	%>		
		<input name="txtCodTurmaAtual" type="hidden" value="<%=ZeroLeft(intCodTurma,8)%>_<%=ZeroLeft(intCod_GradeCurricular,8)%>">
		</form>
		</td>
      </tr>
    </table>
	</td>
  </tr>
</table>
<!--#include file="../rodape.asp"-->
<script>
	aguarde.style.display="none";
</script>
</body>
</html>