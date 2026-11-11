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
<!--#include file="../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file=../../includes/inc_aguarde.asp-->
<!--include file="../../js/Calendario/Calendario.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>
<script>
	function validaDigitacaoBolsaFamilia(){
		var frm = document.getElementById("frm");
		if (frm.txtBolsaFamilia.value.length!=11 && frm.txtBolsaFamilia.value != "") {
			alert("Número inválido!");
			frm.txtBolsaFamilia.focus();
			return false;
		}	
		frm.cmbPeriodo.value=0
	}

	function blocTexto(valor, id)
	{
		quant = 500;
		total = valor.length;
		if(total <= quant)
		{
			resto = quant - total;
			document.getElementById('cont').innerHTML = resto;
		}
		else
		{
			document.getElementById('txtResposta_'+id).value = valor.substr(0,quant);
		}
	}


	function AbreFecha(Linha,Figura){
		if (Linha.style.display == "table-row"){
			Linha.style.display = "none";
			Figura.src="<%=session("strCaminhoRaiz")%>/images/plus.bmp"
		}
		else{
			Linha.style.display = "table-row";
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
			mostraDadosPessoais.style.display="table-row"
			frm.imgDadosPessoais.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
		}
		else{
			mostraDadosPessoais.style.display="none"
			frm.imgDadosPessoais.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
		}
	}
	function dadosEndereco(){
		if (mostraDadosEndereco.style.display=="none"){
			mostraDadosEndereco.style.display="table-row"
			frm.imgDadosEndereco.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
		}
		else{
			mostraDadosEndereco.style.display="none"
			frm.imgDadosEndereco.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
		}
	}
	function dadosFamiliares(){
		if (mostraDadosFamiliares.style.display=="none"){
			mostraDadosFamiliares.style.display="table-row"
			frm.imgDadosFamiliares.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
		}
		else{
			mostraDadosFamiliares.style.display="none"
			frm.imgDadosFamiliares.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
		}
	}		
	function dadosDocumentos(){
		if (mostraDadosDocumentos.style.display=="none"){
			mostraDadosDocumentos.style.display="table-row"
			frm.imgDadosDocumentos.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
		}
		else{
			mostraDadosDocumentos.style.display="none"
			frm.imgDadosDocumentos.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
		}
	}		
	function dadosEscolares(){
		if (mostraDadosEscolares.style.display=="none"){
			mostraDadosEscolares.style.display="table-row"
			frm.imgDadosEscolares.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
		}
		else{
			mostraDadosEscolares.style.display="none"
			frm.imgDadosEscolares.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
		}
	}		
	function dadosConclusao(){
		if (mostraDadosConclusao.style.display=="none"){
			mostraDadosConclusao.style.display="table-row"
			frm.imgDadosConclusao.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
		}
		else{
			mostraDadosConclusao.style.display="none"
			frm.imgDadosConclusao.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
		}
	}	
	
	function dadosResponsavel(){
		
		if (mostraDadosResponsavel.style.display=="none"){
			mostraDadosResponsavel.style.display="table-row"
			frm.imgdadosResponsavel.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
		}
		else{
			mostraDadosResponsavel.style.display="none"
			frm.imgdadosResponsavel.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
		}
	}	
	
	
	function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function carregaTurma(){
		
		var frm = document.getElementById("frm");
		
		frm.action="Aluno_cad.asp"
		frm.submit();
	}
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if ((acao=="I") || (acao=="A")) {
			
			if (frm.txtNomealuno.value==""){
				alert("O Nome do Aluno deve ser informado.")
				frm.txtNomealuno.focus()
				return false;
			}

			if (frm.txtDatamatricula.value==""){
				alert("A Data de Matrícula deve ser informada.")
				frm.txtDatamatricula.focus()
				return false;
			}
		
			if (frm.txtDataNascimento.value==""){
				alert("A Data de Nascimento deve ser informada.")
				frm.txtDataNascimento.focus()
				return false;
			}

			if (frm.cmbSexo.value=="0"){
				alert("O Sexo deve ser informado.")
				frm.cmbSexo.focus()
				return false;
			}

			if (frm.txtCidadenascimento.value==""){
				alert("A Naturalidade do Aluno deve ser informada.")
				frm.txtCidadenascimento.focus()
				return false;
			}
			
			if (frm.cmbTipoNacionalidade.value!="3"){
				
				if (frm.cmbUfnascimento.value=="0"){
					alert("O UF da Naturalidade deve ser informada.")
					frm.cmbUfnascimento.focus()
					return false;
				}
				
			}

			if (frm.cmbNacionalidade.value=="0"){
				alert("A Nacionalidade deve ser informada.")
				frm.cmbUfnascimento.focus()
				return false;
			}

			if (frm.cmbTipoNacionalidade.value=="0"){
				alert("A Origem da Nacionalidade deve ser informada.")
				frm.cmbTipoNacionalidade.focus()
				return false;
			}

			if (frm.cmbProfissao.value=="0"){
				alert("A Profissão deve ser informada.")
				frm.cmbProfissao.focus()
				return false;
			}

			if (frm.cmbEtnia.value=="0"){
				alert("A Etnia deve ser informada.")
				frm.cmbEtnia.focus()
				return false;
			}
			
			//bolsa familia
			if (frm.txtBolsaFamiliaAnterior.value!="") {
				if ((frm.txtBolsaFamilia.value=="")){
					alert("O númerio do cartão do bolsa família deve ser preenchido.")
					frm.txtBolsaFamilia.focus()
					return false;
				}
			}
			
            if ((frm.txtFoneResidencial.value=="") && (frm.txtFonecelular.value=="")){
				alert("Pelo menos um telefone de contato deve ser informado.")
				frm.txtFoneResidencial.focus()
				return false;
			}

			if (frm.txtMae.value==""){
				alert("O Nome da Mãe deve ser informado.")
				frm.txtMae.focus()
				return false;
			}
			
			
			
			var turma = frm.cmbTurma.value;
			var gradeNova = "";
			gradeNova = turma.substring(9,17)
	
			var turmaAtual = frm.txtCodTurmaAtual.value;
			var gradeAtual = "";
			gradeAtual = turmaAtual.substring(9,17)
			
			if (frm.cmbTurma.value != "0"){
				if (gradeNova!=gradeAtual && gradeAtual !='00000000') {
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
				   mostraDadosEscolares.style.display="table-row"
				   frm.imgDadosEscolares.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
				   frm.cmbTurma.focus();
				return false;
			}
			
				frm.action="Aluno_cod.asp?acao=" + acao;
				frm.submit();
				return true;
			}	
			
		}
		
		if (acao=="E"){
			
			var men = 'ATENÇÃO: Deseja realmente excluir este Aluno'
			if (confirm(men)) {
				frm.action="Aluno_cod.asp?acao=" + acao;
				frm.submit();
			} else {
				return false;
			}
		
		}	
				
 	}

	function foto(codAluno){
		window.open("Aluno_ViculaFoto.asp?codAluno="+codAluno,"consulta", "top=0,left=0,height=570,width=578,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}
	
	function TirarFoto(codAluno){
		window.open("../../../WebCam/TiraFoto/TiraFoto.asp?codAluno="+codAluno,"consulta", "top=0,left=0,height=570,width=578,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}

	function AlunoDocumentacoes(codAluno){
		if (codAluno == ""){
			alert("O aluno deve ser informado.")
			return false;		
		}else{
		
		frm.action = "Aluno_Documentacoes_cad.asp";
		frm.submit();		
		}
	}

</script>
<%	
	if session("codGrupo") = "7" then
		strUsuarioLiberadoParaMatricularDireto = ""
		sql = "SELECT CODIGO_SEG_USUARIOS_SISTEMA"
		sql = sql & " FROM SEG_USUARIOS_INCLUI_CADASTRO"
		sql = sql & " Where cod_grupo = " & Session("CodGrupo")
		sql = sql & " and upper(CODIGO_SEG_USUARIOS_SISTEMA) = '" & ucase(trim(session("usuarioWeb"))) & "'"
		rs.open sql, cnn
		if rs.eof = false then
			strUsuarioLiberadoParaMatricularDireto = ucase(trim(session("usuarioWeb")))
		end if 
		rs.close
	else
		strUsuarioLiberadoParaMatricularDireto = "SIM"
	end if
	
	strPagina 				= "Aluno_cad.asp"
	strPaginaTitulo 		= "Aluno_cad.asp"
	strMostraTodasTurmas 	= Request.Form("strMostraTodasTurmas")
	strExecutarSubmitGradeCurricular = "S"
	strExecutarSubmitSemestre = "S"
	
	if ucase(trim(session("usuarioWeb"))) <> strUsuarioLiberadoParaMatricularDireto then
		if trim(Session("MatriculaInformatizada")) = "SIM"  then
			strExecutarSubmitTurma = "S"
			%>
			<!--script>
				alert("ATENÇÃO: Não será permitida alteração de Nome durante a efetivação. O nome poderá ser apenas corrigido.");
			</script-->
			<%
		else
			if Session("CodEmpresa") <> "!!" then
				IF session("codGrupo") = "7" THEN
					%>
					<script>
						alert("ATENÇÃO: Inclusão bloqueada temporáriamente durante o processo de matrícula.");
					</script>
					<%
				END IF	
			end if
		end if	
	else
	%>
	<script>
		alert("ATENÇÃO: Seu usuário está com acesso direto a inclusão de aluno, essa inclusão não passará pela matrícula.");
	</script>
	<%
	end if
	
	'chave da tabela    
	strCod_empresa 			= Session("CodEmpresa")
	strSemestre 			= session("strSemestre")
	strAnoLetivo 			= Trim(Request("txtAnoLetivo"))
    intSemestre 	        = Trim(Request("cmbSemestre"))
	
	if strAnoLetivo = "" then
	   strAnoLetivo          = session("strAnoLetivo")
    end if

	if intSemestre = "0" or intSemestre = "" then
	   intSemestre          = session("strSemestre")
    end if

	strMatriculaLocalizar 		= Trim(Request.Form("txtMatriculaLocalizar"))
	intCodEmpresaGrupo		    = Trim(Request.Form("cmbEmpresaGrupo"))
	intCodEmpresaGrupoUsuario	= Trim(Request.Form("cmdEmpresaGrupoUsuario"))

	strNomeBotaoFoto		= "Incluir Foto (10Kb)"

	strCodAluno			= Trim(Request("txtCodAluno"))
	intCodAluno			= Trim(Request("txtCodAluno"))			
	strMatricula 		= Trim(Request("txtMatricula"))
	strNomealuno 		= Trim(Request("txtNomealuno"))

	'dados pessoais
	strDatamatricula 			= formataDataAP(Trim(Request.Form("txtDatamatricula")))
	strNumeroRegistroNascimento	= Trim(Request.Form("txtNumeroRegistroNascimento"))
	
	strFolha			= Trim(Request.Form("txtFolha"))
	strLivro			= Trim(Request.Form("txtLivro"))
	strTermo			= Trim(Request.Form("txtTermo"))
	strNomeCartorio		= Trim(Request.Form("txtNomeCartorio"))
	
	strSexo		 				= Trim(Request.Form("cmbSexo"))
	strDatanascimento 			= formataDataAP(Trim(Request.Form("txtDatanascimento")))
	strDataEmissaoCertidaoNasc 	= formataDataAP(Trim(Request.Form("txtDataEmissaoCertidaoNascimento")))
	 
	strCidadenascimento 	= Trim(Request.Form("txtCidadenascimento"))
	strUfnascimento 		= Trim(Request.Form("cmbUfnascimento"))
	strNacionalidade 		= Trim(Request.Form("cmbNacionalidade"))	
	if strNacionalidade = "" then strNacionalidade 		= "Brasileira"
	strTipoNacionalidade 	= Trim(Request.Form("cmbTipoNacionalidade"))
	if strTipoNacionalidade = "" then strTipoNacionalidade 		= "1"
	intCodEstadocivil 		= Trim(Request.Form("cmbEstadoCivil"))
	intCodProfissao 		= Trim(Request.Form("cmbProfissao"))
	
	intCodReligiao 			= Trim(Request.Form("cmbReligiao"))
	intCodEtnia 			= Trim(Request.Form("cmbEtnia"))
	intCodNecessidadeEspecial 	= Trim(Request.Form("cmbNecessidadeEspecial"))
	strAtendimentoespecial 		= Trim(Request.Form("txtAtendimentoespecial"))
	strFoneResidencial 		= Trim(Request.Form("txtFoneResidencial"))
	strFonecomercial 		= Trim(Request.Form("txtFonecomercial"))
	strFoneCelular	 		= Trim(Request.Form("txtFonecelular"))
	strEmail 				= Trim(Request.Form("txtEmail"))
	
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
	strCPFResponsavel 			= Trim(Request.Form("txtCPFResponsavel"))
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
	strCodigoInep			= Trim(Request.Form("txtCodigoInep"))
	
	strCidade			 				= Trim(Request.Form("txtCidade"))
	strAnoconclusaoEnsinoMedio 			= Trim(Request.Form("txtAnoconclusaoEnsinoMedio"))
	strSemestreconclusaoEnsinoMedio 	= Trim(Request.Form("txtSemestreconclusaoEnsinoMedio"))
	intCodDisciplinaVestibular 			= Trim(Request.Form("cmbDisciplinaVestibular"))
	
	
	strUfEnsinoMedio	= Trim(Request.Form("cmbUFEnsinoMedio"))


	strSemconclusao 	= Trim(Request.Form("txtSemconclusao"))
	strDataConclusao 	= formataDataAP(Trim(Request.Form("txtDataConclusao")))
	strDatacertificado 	= formataDataAP(Trim(Request.Form("txtDatacertificado")))

	intViaCarterinha 	= Trim(Request.Form("cmbViaCarterinha"))
	strSetransp 		= Trim(Request.Form("txtSetransp"))
	strBolsaFamilia 		= Trim(Request.Form("txtBolsaFamilia"))

	'dados finaceiro
	intCodPlanoPagamento 	= Trim(Request.Form("cmbPlanoPagamento"))

	strLogradouro_cobranca 		= Trim(Request.Form("txtLogradouro_cobranca"))
	strNumero_endereco_cobranca	= Trim(Request.Form("txtNumero_endereco_cobranca"))
	strComp_endereco_cobranca 	= Trim(Request.Form("txtComp_endereco_cobranca"))

	sql = "SELECT isnull(Sigla,'EB') as NivelEnsinoSigla"
	sql = sql & " FROM SCA_GRAU"
	sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
	rs.open sql, cnn
	if rs.eof = false then
		strNivelEnsinoSigla		= Trim(rs("NivelEnsinoSigla"))
	end if 
	rs.close

	'Buscar dados de outra unidade
	if trim(session("NivelPermissao")) = "A" then
		if Trim(Request.Form("LocalizarMATRICUA")) = "S" and strNomealuno = "" then
			strimportar = "S"

			if strimportar = "S" then
				sql = " SELECT A.* FROM SCA_ALUNO A "
				sql = sql & " LEFT JOIN SCA_SITUACAOALUNO S ON S.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO"
				sql = sql & " Where A.MATRICULA = '" & trim(strMatriculaLocalizar) & "'"
				sql = sql & " And A.COD_EMPRESA = " & trim(intCodEmpresaGrupo) 
				sql = sql & " And S.Desc_SituacaoAluno <> 'ATIVO' "  
				
				rs.open sql, cnn
				if rs.eof = false then
					''strCodAluno						= TRIM(rs("Codigo"))
					''intCodAluno						= TRIM(rs("Codigo"))
					''strMatricula 					= TRIM(rs("Matricula"))
					strNomealuno 					= TRIM(rs("Nomealuno"))
					strNumeroRegistroNascimento  	= TRIM(rs("NUMREGISTRONASC"))
					strFolha						= TRIM(rs("Folha"))
					strLivro						= TRIM(rs("Livro"))
					strTermo						= TRIM(rs("Termo"))
					strNomeCartorio					= TRIM(rs("NomeCartorio"))
					strSexo		 					= TRIM(rs("SexoAluno"))
					strDatanascimento 				= formataDataAP(TRIM(rs("Datanascimento")))
					strDataEmissaoCertidaoNasc 		= formataDataAP(TRIM(rs("DataEmissaoCertidaoNascimento")))
					'strCidadenascimento 			= TRIM(rs("Cidadenascimento"))
					if Trim(Request.Form("cmbCodigoMunicipio")) = "0" or Trim(Request.Form("cmbCodigoMunicipio")) = "" then 
						strCidadenascimento	= TRIM(rs("Cidadenascimento"))
					end if
					if Trim(Request.Form("cmbUfnascimento")) = "0"  or Trim(Request.Form("cmbUfnascimento")) = ""  then 
						strUfnascimento 	= TRIM(rs("Ufnascimento"))
					end if	
		
					if strUfnascimento = "" or isnull(strUfnascimento) then strUfnascimento = "0"
		
					strUfnascimento 	= TRIM(rs("Ufnascimento"))
					strCidadenascimento	= TRIM(rs("Cidadenascimento"))
		
		
					strNacionalidade 				= TRIM(rs("Nacionalidade"))
					strTipoNacionalidade			= TRIM(rs("cod_TipoNacionalidade"))
					intCodEstadocivil 				= TRIM(rs("cod_EstadoCivil"))
					intCodProfissao 				= TRIM(rs("cod_Profissao"))
					intCodEtnia 					= TRIM(rs("cod_Etnia"))
		
					intCodReligiao 					= TRIM(rs("cod_Religiao"))
					intCodNecessidadeEspecial 		= TRIM(rs("Cod_necespecial"))
					strAtendimentoespecial 			= TRIM(rs("Atendimentoespecial"))
					strFoneResidencial 				= TRIM(rs("FoneResidencial"))
					strFonecomercial 				= TRIM(rs("Fonecomercial"))
					strFoneCelular	 				= TRIM(rs("Fonecelular"))
					strEmail 						= TRIM(rs("Email"))
					
					'endereço
					strLogradouro 					= TRIM(rs("Logradouro"))
					strNumero_endereco 				= TRIM(rs("Numero_endereco"))
					strComp_endereco 				= TRIM(rs("Comp_endereco"))
					strBairroaluno 					= TRIM(rs("Bairroaluno"))
					strCidaderesidencia				= TRIM(rs("Cidaderesidencia"))
					strUfresidencia 				= TRIM(rs("Ufresidencia"))
					strCepresidencia 				= TRIM(rs("Cepresidencia"))
					
					'dados familiares
					strPai 							= TRIM(rs("Pai"))
					strPaifalecido 					= TRIM(rs("Paifalecido"))
					strPaifone 						= TRIM(rs("Paifone"))
					strPaidatanascimento			= formataDataAP(TRIM(rs("Paidatanascimento")))
					intCodProfissaoPai				= TRIM(rs("Pai_cod_profissao"))
					intCodGrauInstrucaoPai			= TRIM(rs("Pai_cod_grauinstrucao"))
		
					strMae 							= TRIM(rs("Mae"))
					strMaefalecida 					= TRIM(rs("Maefalecida"))
					strMaefone 						= TRIM(rs("Maefone"))
					strMaedatanascimento			= formataDataAP(TRIM(rs("Maedatanascimento")))
					intCodProfissaoMae				= TRIM(rs("Mae_cod_profissao"))
					intCodGrauInstrucaoMae			= TRIM(rs("Mae_cod_grauinstrucao"))
		
					strResponsavel 					= TRIM(rs("Responsavel"))
					strCPFResponsavel				= TRIM(rs("CPFResponsavel"))
					strResponsavelfone 				= TRIM(rs("Responsavelfone"))
					strResponsaveldatanascimento	= formataDataAP(TRIM(rs("Responsaveldatanascimento")))
					intCodProfissaoResponsavel		= TRIM(rs("Responsavel_cod_profissao"))
					intCodGrauInstrucaoResponsavel	= TRIM(rs("Responsavel_cod_grauinstrucao"))
		
					intQtdeIrmao 					= TRIM(rs("Qtde_irmao"))
					intQtdeIrmaoEscola				= TRIM(rs("Qtde_irmao_escola"))
		
					'documentos
					strIdentidade 					= TRIM(rs("Identidade"))
					strIdentidadeOrgao				= TRIM(rs("IdentidadeOrgao"))
					strIdentidadeUF					= TRIM(rs("IdentidadeUF"))
					
					strTituloNumero 				= TRIM(rs("TituloEleitor"))
					strTituloZona	 				= TRIM(rs("TituloZona"))
					strTituloSecao	 				= TRIM(rs("TituloSecao"))
					
					strRegmilitar 					= TRIM(rs("Regmilitar"))
					
					if isnull(rs("Cpfaluno")) or trim(rs("Cpfaluno")) = "" then
						strCpfaluno 					= TRIM(rs("Cpfaluno"))
					else
						strCpfaluno 					= Zeroleft(TRIM(rs("Cpfaluno")),11)
					end if
					
					'dados finaceiro
					strEscola						= Trim(RS("Escola_ensinomedio"))
					strBolsaFamilia					= Trim(RS("bolsa_Familia"))
					
				
					if isnull(strBolsaFamilia) then strBolsaFamilia = ""
											
				else
					%>
					<script>
						alert("Não foi Localizado dados para importação. Verifique!")
					</script>
					<%
				end if
				rs.close
			end if
		end if
		'Fim de busca de dados de outra unidade
	end if

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
			strSituacaoAluno				= TRIM(rs("Desc_SituacaoAluno"))
			'dados pessoais
			strCodAluno						= TRIM(rs("Codigo"))
			intCodAluno						= TRIM(rs("Codigo"))
			strMatricula 					= TRIM(rs("Matricula"))
			strNomealuno 					= TRIM(rs("Nomealuno"))
			strDatamatricula 				= formataDataAP(TRIM(rs("Datamatricula")))
			strNumeroRegistroNascimento  	= TRIM(rs("NUMREGISTRONASC"))
			strFolha						= TRIM(rs("Folha"))
			strLivro						= TRIM(rs("Livro"))
			strTermo						= TRIM(rs("Termo"))
			strNomeCartorio					= TRIM(rs("NomeCartorio"))
			strSexo		 					= TRIM(rs("SexoAluno"))
			strDatanascimento 				= formataDataAP(TRIM(rs("Datanascimento")))
			strDataEmissaoCertidaoNasc 		= formataDataAP(TRIM(rs("DataEmissaoCertidaoNascimento")))
			strCidadenascimento 			= TRIM(rs("Cidadenascimento"))
			strUfnascimento 				= TRIM(rs("Ufnascimento"))
			strNacionalidade 				= TRIM(rs("Nacionalidade"))
			if isnull(strNacionalidade) then strNacionalidade 		= "Brasileira"
			
			strTipoNacionalidade			= TRIM(rs("cod_TipoNacionalidade"))
			if isnull(strTipoNacionalidade) then strTipoNacionalidade 		= "1"
			
			intCodEstadocivil 				= TRIM(rs("cod_EstadoCivil"))
			intCodProfissao 				= TRIM(rs("cod_Profissao"))
			intCodEtnia 					= TRIM(rs("cod_Etnia"))

			intCodReligiao 					= TRIM(rs("cod_Religiao"))
			intCodNecessidadeEspecial 		= TRIM(rs("Cod_necespecial"))
			strAtendimentoespecial 			= TRIM(rs("Atendimentoespecial"))
			strFoneResidencial 				= TRIM(rs("FoneResidencial"))
			strFonecomercial 				= TRIM(rs("Fonecomercial"))
			strFoneCelular	 				= TRIM(rs("Fonecelular"))
			strEmail 						= TRIM(rs("Email"))
			
			'endereço
			strLogradouro 					= TRIM(rs("Logradouro"))
			strNumero_endereco 				= TRIM(rs("Numero_endereco"))
			strComp_endereco 				= TRIM(rs("Comp_endereco"))
			strBairroaluno 					= TRIM(rs("Bairroaluno"))
			strCidaderesidencia				= TRIM(rs("Cidaderesidencia"))
			strUfresidencia 				= TRIM(rs("Ufresidencia"))
			strCepresidencia 				= TRIM(rs("Cepresidencia"))
			
			'dados familiares
			strPai 							= TRIM(rs("Pai"))
			strPaifalecido 					= TRIM(rs("Paifalecido"))
			strPaifone 						= TRIM(rs("Paifone"))
			strPaidatanascimento			= formataDataAP(TRIM(rs("Paidatanascimento")))
			intCodProfissaoPai				= TRIM(rs("Pai_cod_profissao"))
			intCodGrauInstrucaoPai			= TRIM(rs("Pai_cod_grauinstrucao"))

			strMae 							= TRIM(rs("Mae"))
			strMaefalecida 					= TRIM(rs("Maefalecida"))
			strMaefone 						= TRIM(rs("Maefone"))
			strMaedatanascimento			= formataDataAP(TRIM(rs("Maedatanascimento")))
			intCodProfissaoMae				= TRIM(rs("Mae_cod_profissao"))
			intCodGrauInstrucaoMae			= TRIM(rs("Mae_cod_grauinstrucao"))

			strResponsavel 					= TRIM(rs("Responsavel"))
			if isnull(rs("Responsavel")) then strResponsavel = strMae
			strCPFResponsavel				= TRIM(rs("CPFResponsavel"))
			strResponsavelfone 				= TRIM(rs("Responsavelfone"))
			strResponsaveldatanascimento	= formataDataAP(TRIM(rs("Responsaveldatanascimento")))
			intCodProfissaoResponsavel		= TRIM(rs("Responsavel_cod_profissao"))
			intCodGrauInstrucaoResponsavel	= TRIM(rs("Responsavel_cod_grauinstrucao"))

			intQtdeIrmao 					= TRIM(rs("Qtde_irmao"))
			intQtdeIrmaoEscola				= TRIM(rs("Qtde_irmao_escola"))

			'documentos
			strIdentidade 					= TRIM(rs("Identidade"))
			strIdentidadeOrgao				= TRIM(rs("IdentidadeOrgao"))
			strIdentidadeUF					= TRIM(rs("IdentidadeUF"))
			
			strTituloNumero 				= TRIM(rs("TituloEleitor"))
			strTituloZona	 				= TRIM(rs("TituloZona"))
			strTituloSecao	 				= TRIM(rs("TituloSecao"))
			
			strRegmilitar 					= TRIM(rs("Regmilitar"))
			strCpfaluno 					= TRIM(rs("Cpfaluno"))
			
			'dados escolares
			intCodGradeCompleta				= TRIM(rs("Cod_gradevestibular"))
			strMesanovestibular 			= TRIM(rs("Mesanovestibular"))
		
			intCodFormaIngresso 			= TRIM(rs("cod_FormaIngresso"))
			strDataingresso 				= formataDataAP(TRIM(rs("Dataingresso")))
			intCodSituacaoAluno				= TRIM(rs("cod_SituacaoAluno"))
		
			strDatafastamento 				= formataDataAP(TRIM(rs("Datafastamento")))
			intCodMotivoAfastamento			= TRIM(rs("Cod_motivoafastamento"))
			strObsafastamento 				= TRIM(rs("Obsafastamento"))
		
			strDatacolacao 					= formataDataAP(TRIM(rs("Datacolacao")))
			strAnoconclusao 				= TRIM(rs("Anoconclusao"))
			strSemconclusao 				= TRIM(rs("Semconclusao"))
			strDataConclusao 				= TRIM(rs("DataConclusao"))

			strDatacertificado 				= formataDataAP(TRIM(rs("Datacertificado")))
			intCodDisciplinaVestibular		= TRIM(rs("Disciplina_Processo_Seletivo"))

		
			intViaCarterinha 				= TRIM(rs("Ctrviace"))
			strSetransp 					= TRIM(rs("Setransp"))
		
			'dados finaceiro
			intCodPlanoPagamento 			= TRIM(rs("cod_PlanoTurma"))
		
			strLogradouro_cobranca 			= TRIM(rs("Logradouro_cobranca"))
			strNumero_endereco_cobranca		= TRIM(rs("Numero_endereco_cobranca"))
			strComp_endereco_cobranca 		= TRIM(rs("Comp_endereco_cobranca"))
		
			strEscola						= Trim(RS("Escola_ensinomedio"))
			strEscolaOrigem					= Trim(RS("Escola_origem"))
			strCodigoInep					= Trim(RS("CodigoInep"))
			strCidade			 			= Trim(RS("Cidade_ensinomedio"))
			strAnoconclusaoEnsinoMedio 		= Trim(RS("ano_ensinomedio"))
			strSemestreconclusaoEnsinoMedio	= Trim(RS("semestre_ensinomedio"))
			strUfEnsinoMedio				= Trim(RS("uf_ensinomedio"))		
			strBolsaFamilia					= Trim(RS("bolsa_Familia"))
			if isnull(strBolsaFamilia) then strBolsaFamilia = ""

			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			
			'if session("codGrupo") = "7" then strDesabilitaAlterar	= "disabled"
			
			rs.close

			'VERIFICAÇÃO DE BLOQUEIO
			%>
			<!--#include file="../includes/inc_VerificaBloqueio.asp"-->
			<%

			strCaminhoFoto = session("strCaminhoRaiz") & "/gemul2015/fotoAluno/semFoto.gif"
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
		if ucase(trim(session("usuarioWeb"))) <> strUsuarioLiberadoParaMatricularDireto then
			if trim(Session("MatriculaInformatizada")) = "SIM" then
				strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			else	
				strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
				if session("codGrupo") <> "7" then strDesabilitaIncluir	= ""
				if Session("CodEmpresa") = "999" and strimportar = "S" then strDesabilitaIncluir	= ""
			end if
		end if
		
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		strCaminhoFoto = session("strCaminhoRaiz") & "/fotoAluno/semFoto.gif"
		strFoto =  "<img src='" & strCaminhoFoto & "' width='100' height='110'>"
	end if 
	
	if  trim(strCodAluno) <> "" then
		
		'aluno na turma
		sql = "select top 1 T.NomeTurma"
		sql = sql & " from SCA_ALUNO_TURMA AT"
		sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA "
		sql = sql & " AND AT.ANO_LETIVO = T.AnoLetivo "
		'sql = sql & " AND AT.SEMESTRE = T.Cod_Semestre "
		sql = sql & " Where AT.COD_EMPRESA = " &  strCod_empresa
		sql = sql & " and AT.COD_ALUNO = " &  strCodAluno
		sql = sql & " order by AT.CODIGO desc"
		rs.open sql, cnn
		if not rs.eof then
			strNomeTurma 	= rs("NomeTurma")
		end if
		rs.close
		
		if session("codGrupo") = "7" then
			strBloqAltrExcl = ""
			' bloqueia o alterar e excluir para alunos não efetivados
			sql = " select Efetivacao from MAT_inscricao " 
			sql = sql & " where cod_aluno = " &  strCodAluno
			rs.open sql, cnn
			if rs.eof = false then
				if rs("Efetivacao") = "S" then
					strBloqAltrExcl = ""
				else
					strBloqAltrExcl = "S"
				end if
			end if 
			rs.close
		end if
	end if
	strCssCampo="text"
	BloqueiaCampo = ""
	if session("codGrupo") = "7" then
		if strDesabilitaAlterar = "" then
			if session("NivelPermissao") = "A" then
				BloqueiaCampo = ""
			else
				if ucase(trim(session("usuarioWeb"))) <> strUsuarioLiberadoParaMatricularDireto then
					if trim(Session("MatriculaInformatizada")) = "SIM" then
						if strDatamatricula = "" then strDatamatricula = formatadataAP(date)
					end if
					strCssCampo="textDisabled"
					BloqueiaCampo = " readonly "
				end if
				
				if trim(Session("MatriculaInformatizada")) = "SIM"  then 
					strDesabilitaExcluir = " Disabled "
				end if
				if strBloqAltrExcl="S" and trim(Session("MatriculaInformatizada"))="" then 
					strDesabilitaExcluir = " Disabled "
					strDesabilitaAlterar = " Disabled "
				end if
			end if
			'if isnull(strUfnascimento) or strUfnascimento = "0" or strUfnascimento = "" then strUfnascimento = "9"
		end if
	end if
%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="98%"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post" action="Aluno_cad.asp">
		  <table width="708" border="0" cellpadding="0" cellspacing="0">

            <tr valign="top">
              <td height="30" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
             <%
			 if ucase(trim(session("usuarioWeb"))) <> strUsuarioLiberadoParaMatricularDireto then
				if trim(Session("MatriculaInformatizada")) = "SIM" then %>
				<tr valign="top">
					<td height="30" align="center" class="tituloSistema"><font color="#FF0000"><strong>Aluno vindo do Processo de Matricula Informatizada</strong></font></td>
				</tr>
				<%
				end if
			end if
			%>
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
                    <%if trim(Session("MatriculaInformatizada")) = "SIM"  then strDesabilitaExcluir = " Disabled "%>

		  <!--#include file="../includes/inc_ListaOcorrencias.asp"-->
          
		  <table width="98%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><hr size="1" color="#999999"><input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="10" value="<%=strCodAluno%>" maxlength="10"></td>
          </tr>
          <tr>
            <td class="texto1"><div align="center">
              <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                <font color="#FF0000">Informe corretamente os campos obrigat&oacute;rios ( * )</font></div></td>
          </tr>
          <% if Session("NivelPermissao") = "A" then %>
              <tr>
                <td height="44" class="texto1" style="cursor:hand" onClick="return dadosPessoais()"><div align="center">Importar Cadastro de Outras unidades - Matr&iacute;cula: 
                    <input name="txtMatriculaLocalizar" type="text" class="text" id="txtMatriculaLocalizar" size="20" maxlength="14" value="<%=strMatriculaLocalizar%>"> 
                    <a  href="#" onClick="return abreConsulta('AlunoLocalizar_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para Localizar Alunos de outras Unidades" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" > </a>
                    - Unidade: 
                    <!--#include file="../includes/inc_cmbEmpresaOutrasUnidades.asp"-->
                    <span class="TextoForm"><strong>*</strong>
                    <input type="checkbox" name="LocalizarMATRICUA" value="S" onClick='submit()'> 
                Importar?</span></div></td>
                </tr>
			<%end if%>

           <tr>
             <td   width="100%"  height="20" bgcolor="#EEEEEE" class="texto1">
                     <table  width="100%" >
                       <tr>
                        <td width="340" height="20" bgcolor="#EEEEEE" class="texto1" ><img id="imgDadosPessoais" src="<%=session("strCaminhoRaiz")%>/images/down.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Dados Pessoais</strong></td>
                        <td width="52" bgcolor="#EEEEEE" class="texto1" onClick="return dadosPessoais()"><span class="texto1" style="cursor:hand">&nbsp;Turma:</span></td>
                        <td width="97" bgcolor="#EEEEEE" class="texto1" onClick="return dadosPessoais()"><span class="texto1" style="cursor:hand"><strong><%=strNomeTurma%></strong></span></td>
                        <td width="161" bgcolor="#EEEEEE" class="texto1" onClick="return dadosPessoais()"><font color="#FF0000"><strong>C&oacute;digo de Seguran&ccedil;a:</strong></font></td>
                        <td width="116" bgcolor="#EEEEEE" class="texto1" onClick="return dadosPessoais()"><span class="texto1" style="cursor:hand"><font color="#FF0000"><strong><%=strCodAluno%></strong></font></span></td>
                        <td width="419" height="20" bgcolor="#EEEEEE" class="texto1"  align="left">
                        &nbsp;Situa&ccedil;&atilde;o: <strong><%=strSituacaoAluno%></strong>
                        </td>
                      </tr>
                      </table>
            </td>
           </tr>
           
          <tr>
            <td class="texto1" >
				<!-- INICIO CAMPO - DADOS PESSOAIS-->
				<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#F5F5F5" id="mostraDadosPessoais">
				  <tr>
					<td width="18%" class="texto1">&nbsp;Matr&iacute;cula: </td>
					<td width="47%" class="texto1"><input <%=BloqueiaCampo%>  name="txtMatricula" type="text" class="text" id="txtMatricula" size="20" maxlength="10" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 10)" onBlur="carregaAluno()">
					  <a  href="#" onClick="return abreConsulta('Aluno_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" > * </a></td>
					<td colspan="2" rowspan="11" align="center" class="texto1">
					  <table width="120" height="130" border="0" cellpadding="0" cellspacing="0">
					    <tr>
					      <td bgcolor="#FFFFFF" align="center" class="text"><%=strFoto%></td>
					      </tr>
					    </table>					</td>
					</tr>
				  <tr>
					<td class="texto1">&nbsp;Nome Completo: </td>
					<td class="texto1"><input <%=BloqueiaCampo%> name="txtNomealuno" type="text" class="<%=strCssCampo%>" id="txtNomealuno" size="50" maxlength="70" value="<%=strNomealuno%>"  onKeyPress="return formataCampo(this, 1, 70)"> 
                    <input name="txtNomeAnt" type="hidden" class="<%=strCssCampo%>" id="txtNomeAnt" value="<%=strNomealuno%>" > 
					* </td>
					</tr>
				  
				  <tr>
				    <td class="texto1">&nbsp;Data Matr&iacute;cula: </td>
				    <td class="texto1"><input name="txtDatamatricula" type="text" class="text" id="txtDatamatricula" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDatamatricula%>"> 
				    * </td>
				    </tr>
				  <tr>
				    <td class="texto1">&nbsp;Data Nascimento: </td>
				    <td class="texto1"><input <%=BloqueiaCampo%> name="txtDataNascimento" type="text" class="<%=strCssCampo%>" id="txtDataNascimento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDatanascimento%>"> 
				      *</td>
				    </tr>
				  <tr>
				    <td class="texto1">&nbsp;N. Reg. Nasc.: </td>
				    <td class="texto1"><input name="txtNumeroRegistroNascimento" type="text" class="text" id="txtNumeroRegistroNascimento" size="40" maxlength="40" value="<%=strNumeroRegistroNascimento%>"  onKeyPress="return formataCampo(this, 2, 40)"></td>
				    </tr>
				  <tr>
				    <td class="texto1">&nbsp;Emiss&atilde;o:</td>
				    <td class="texto1"><input name="txtDataEmissaoCertidaoNascimento" type="text" class="text" id="txtDataEmissaoCertidaoNascimento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataEmissaoCertidaoNasc%>"></td>
				    </tr>
				  <tr>
				    <td class="texto1">&nbsp;Folha:</td>
				    <td class="texto1"><input name="txtFolha" type="text" class="text" id="txtFolha" size="20" maxlength="20" value="<%=strFolha%>"></td>
				    </tr>
				  <tr>
				    <td class="texto1">&nbsp;Livro:</td>
				    <td class="texto1"><input name="txtLivro" type="text" class="text" id="txtLivro" size="20" maxlength="20" value="<%=strLivro%>"></td>
				    </tr>
                 			  
				  <tr> 
				 	
				    <td class="texto1">&nbsp;Nome Cart&oacute;rio:</td>
				    <td class="texto1"><input name="txtNomeCartorio" type="text" class="text" id="txtNomeCartorio" size="50" maxlength="50" value="<%=strNomeCartorio%>"></td>
				    </tr>
				  <tr>
				    <td class="texto1">&nbsp;Sexo: </td>
				    <td class="texto1"><!--#include file="../includes/inc_cmdSexo.asp" --> 
				    *</td>
				    </tr>
				  <tr>
					<td class="texto1">&nbsp;Naturalidade: </td>
					<td class="texto1"><input name="txtCidadenascimento" type="text" class="text" id="txtCidadenascimento" size="40" maxlength="40" value="<%=strCidadenascimento%>" onKeyPress="return formataCampo(this, 1, 40)">
					*					  </td>
					</tr>
				  <tr>
				    <td class="texto1">&nbsp;Nacionalidade:</td>
				    <td class="texto1"><!--#include file="../includes/inc_cmdNacionalidade.asp"-->
				    *</td>
				    <td colspan="2" align="center" class="texto1"><input type="button" name="cmdIncluir2" style="cursor:hand"   value="<%=strNomeBotaoFoto%>" class="botao" <%=strDesabilitaAlterar%> onClick="foto('<%=intCodAluno%>')">
				      <input type="button" name="cmdTirarFoto" style="cursor:hand"   value="Tirar Foto" class="botao" <%=strDesabilitaAlterar%> onClick="TirarFoto('<%=intCodAluno%>')"></td>
				    </tr>
				  <tr>
				    <td class="texto1">&nbsp;Tipo de Nacionalidade:</td>
				    <td class="texto1"><!--#include file="../includes/inc_cmdTipoNacionalidade.asp" -->
				    *</td>
				    <td colspan="2" class="texto1" align="center">&nbsp;</td>
				    </tr>
				  <tr>
				    <td class="texto1">&nbsp;UF:</td>
				    <td class="texto1"><!--#include file="../includes/inc_cmdUFNascimento.asp" -->
*</td>
				    <td colspan="2" class="texto1" align="center">&nbsp;</td>
				    </tr>
				  <tr>
					<td class="texto1">&nbsp;Profiss&atilde;o: </td>
					<td class="texto1"><%if intCodProfissao = "0" or intCodProfissao = "" or isnull(intCodProfissao) then intCodProfissao = "157"%><!--#include file="../includes/inc_cmdProfissao.asp" -->
					*</td>
					<td colspan="2" class="texto1" align="center">&nbsp;</td>
				  </tr>
				  <tr>
				    <td class="texto1">&nbsp;Etnia:</td>
				    <td class="texto1"><!--#include file="../includes/inc_cmdEtnia.asp" -->
				    *</td>
				    <td class="texto1">&nbsp;Bolsa Fam&iacute;lia:</td>
				    <td class="texto1"><input name="txtBolsaFamilia" type="text" class="text" id="txtBolsaFamilia" size="15" maxlength="11" onKeyPress="return formataCampo(this, 2, 11)" value="<%=strBolsaFamilia%>" onBlur="validaDigitacaoBolsaFamilia()" />
                      <input name="txtBolsaFamiliaAnterior" type="hidden" class="text" id="txtBolsaFamiliaAnterior" value="<%=strBolsaFamilia%>"/></td>
				    </tr>
				  <tr>
				    <td class="texto1">&nbsp;Estado Civil:</td>
				    <td class="texto1"><!--#include file="../includes/inc_cmdEstadoCivil.asp" --></td>
				    <td class="texto1">&nbsp;Religi&atilde;o: </td>
				    <td class="texto1"><!--#include file="../includes/inc_cmdReligiao.asp" --></td>
				  </tr>
				  <tr>
					<td class="texto1">&nbsp;Fone Residencial: </td>
					<td class="texto1"><input name="txtFoneResidencial" type="text" class="text" id="txtFoneResidencial" onKeyPress="mascaraTelefone(this,telefone)"  size="20" maxlength="15" value="<%=strFoneResidencial%>"></td>
					<td class="texto1">&nbsp;Celular: </td>
					<td class="texto1"><input name="txtFonecelular" type="text" class="text" id="txtFonecelular" onKeyPress="mascaraTelefone(this,telefone)"  size="20" maxlength="15" value="<%=strFonecelular%>"></td>
				  </tr>
				  <tr>
					<td class="texto1">&nbsp;e-mail: </td>
					<td class="texto1"><input name="txtEmail" type="text" class="text" id="txtEmail" size="50" maxlength="100" value="<%=strEmail%>"></td>
					<td class="texto1">&nbsp;Fone Comercial : </td>
					<td class="texto1"><input name="txtFoneComercial" type="text" class="text" id="txtFoneComercial" onKeyPress="mascaraTelefone(this,telefone)"  size="20" maxlength="15" value="<%=strFoneComercial%>"></td>
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
            <td><hr size="1" color="#999999"></td>
          </tr>
          
                    <tr>
            <td height="20" bgcolor="#EEEEEE" class="texto1" style="cursor:hand" onClick="return dadosEscolares()"><img id="imgDadosEscolares" src="<%=session("strCaminhoRaiz")%>/images/down.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Dados Escolares</strong></td>
            </tr>
          <tr>
            <td class="texto1" >
<%
				strSem = session("strSemestre")	
				if session("strSemestre") = "3" then strSem = "Anual"
				if session("strSemestre") = "1,3" then strSem = "1ºSem/Anual"
				if session("strSemestre") = "2,3" then strSem = "2ºSem/Anual"

				if strCodAluno <> "" then
					intCodTurma = ""
					intCod_GradeCurricular = ""

					'aluno na turma
					sql = "select top 1 AT.COD_TURMA, T.Cod_GradeCurricular"
					sql = sql & " from SCA_ALUNO_TURMA AT"
					sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA "
					sql = sql & " AND AT.ANO_LETIVO = T.AnoLetivo "
					'sql = sql & " AND AT.SEMESTRE = T.Cod_Semestre"
					sql = sql & " where AT.COD_EMPRESA = " &  strCod_empresa
					sql = sql & " and AT.COD_ALUNO = " &  strCodAluno
					'sql = sql & " and AT.ANO_LETIVO = " &  strAnoLetivo
					'sql = sql & " and AT.SEMESTRE in (" &  intSemestre & ")"
					sql = sql & " and AT.SITUACAO = 'A'"'ATIVA
					sql = sql & " order by AT.CODIGO desc"
					rs.open sql, cnn
					if not rs.eof then
						intCodTurma = rs("cod_Turma")
						intCod_GradeCurricular = rs("Cod_GradeCurricular")
					end if
					rs.close
				
					if trim(intCodTurma) = "" then
						'aluno na turma
						sql = "select top 1 AT.COD_TURMA, T.Cod_GradeCurricular, AT.ANO_LETIVO, AT.SEMESTRE"
						sql = sql & " from SCA_ALUNO_TURMA AT"
						sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA "
						sql = sql & " AND AT.ANO_LETIVO = T.AnoLetivo AND AT.SEMESTRE = T.Cod_Semestre"
						sql = sql & " where AT.COD_EMPRESA = " &  strCod_empresa
						sql = sql & " and AT.COD_ALUNO = " &  strCodAluno
						sql = sql & " order by AT.CODIGO desc"
						rs.open sql, cnn
						if not rs.eof then
							intCodTurma = rs("cod_Turma")
							intCod_GradeCurricular = rs("Cod_GradeCurricular")
							if strAnoLetivo = "" then
							   strAnoLetivo 	= rs("ANO_LETIVO")
							end if
							if intSemestre = "" or intSemestre = "0" then    
							   intSemestre 	= rs("SEMESTRE")
							end if   
							if intSemestre = "3" then strSem = "Anual"
							if intSemestre = "1" then strSem = "1ºSem"
							if intSemestre = "2" then strSem = "2ºSem"
						end if
						rs.close
					end if					
				end if	
				
				if Session("MatriculaInformatizada")="SIM" then
					strAnoLetivo = Session("MatriculaInformatizadaAnoEfetivacao")  
				end if
				%>
               
				<!-- INICIO CAMPO - DADOS ESCOLARES-->
				<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#F5F5F5" id="mostraDadosEscolares">
				  <tr>
				    <td class="texto1">&nbsp;Ano Letivo:</td>
				    <td class="texto1"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo"  onChange="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"> </td>
				    <td class="texto1">&nbsp;Semestre:</td>
				    <td class="texto1"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
				    </tr>
                    <%
					if ucase(trim(session("usuarioWeb"))) <> strUsuarioLiberadoParaMatricularDireto then
						if Session("MatriculaInformatizada")="SIM" then
							intCodTurmaTroca = intCodTurma
							''---------------------------------------------------''
							'' NOVA REGRA - para o process de matricula o sistema 
							'' efetivará o aluno na turna em ordem de preenchimento sequencial
							''---------------------------------------------------''
							'' BUSCA TURMA DISPONIVEL PARA A ESCOLA SELECIONADA
							''---------------------------------------------------''
							sql = "select tu.cod_turno, tu.cod_periodo"
							sql = sql & " from SCA_TURMA TU"
							sql = sql & " where TU.Cod_Empresa  = " & session("codEmpresa")
							sql = sql & " and TU.cod_turma = " & intCodTurma
							rs.open sql, cnn,3,3
							if not RS.EOF then
								intCodTurno = rs("cod_turno")
								intCodPeriodo = rs("cod_periodo")
							end if
							rs.close
							
							intCodTurma = "0"

							sql = "select  top 1 tu.cod_turma, tu.NomeTurma, tu.sala"
							sql = sql & " from SCA_TURMA TU "
							sql = sql & " where TU.Cod_Empresa = " & session("codEmpresa") 
							sql = sql & " and TU.Situacao = 'A' "
							sql = sql & " and tu.AnoLetivo = " & Session("MatriculaInformatizadaAnoEfetivacao")   
							sql = sql & " and tu.Cod_Semestre = " & strSemestre 
							sql = sql & " and tu.Cod_Periodo = " & intCodPeriodo 
							sql = sql & " and TU.Cod_Turno = " & intCodTurno 
							sql = sql & " and "
							sql = sql & " 	case "
							sql = sql & " 		when isnull(tu.capacidade,0) <  isnull(tu.vagasReservadas,0) then "
							sql = sql & " 			isnull(tu.capacidade,0) - "
							sql = sql & " 			( "
							sql = sql & " 			select COUNT(AT1.CODIGO) "
							sql = sql & " 			from SCA_ALUNO_TURMA AT1 "
							sql = sql & " 			INNER JOIN SCA_ALUNO A1 ON AT1.COD_ALUNO = A1.CODIGO "
							sql = sql & " 			inner join SCA_SITUACAOALUNO sa1 on sa1.Cod_SituacaoAluno = a1.Cod_SituacaoAluno "
							sql = sql & " 			where AT1.Situacao = 'A' "
							sql = sql & " 			and AT1.Ano_Letivo = " & Session("MatriculaInformatizadaAnoEfetivacao")  
							sql = sql & " 			and AT1.Semestre = " & strSemestre 
							sql = sql & " 			and AT1.cod_turma = tu.cod_turma "
							sql = sql & " 			and desc_situacaoaluno = 'ATIVO' "
							sql = sql & " 			)"
							sql = sql & " 		else "
							sql = sql & " 			isnull(tu.capacidade,0) -  isnull(tu.vagasReservadas,0) -"
							sql = sql & " 			( "
							sql = sql & " 			select COUNT(AT1.CODIGO) "
							sql = sql & " 			from SCA_ALUNO_TURMA AT1 "
							sql = sql & " 			INNER JOIN SCA_ALUNO A1 ON AT1.COD_ALUNO = A1.CODIGO "
							sql = sql & " 			inner join SCA_SITUACAOALUNO sa1 on sa1.Cod_SituacaoAluno = a1.Cod_SituacaoAluno "
							sql = sql & " 			where AT1.Situacao = 'A' "
							sql = sql & " 			and AT1.Ano_Letivo = " & Session("MatriculaInformatizadaAnoEfetivacao")  
							sql = sql & " 			and AT1.Semestre = " & strSemestre 
							sql = sql & " 			and AT1.cod_turma = tu.cod_turma "
							sql = sql & " 			and desc_situacaoaluno = 'ATIVO' "
							sql = sql & " 			)"
							sql = sql & " 	end"
							sql = sql & " 	> 0"
							sql = sql & " order by tu.sala"
							
							'if session("usuarioWeb") = "sergio" or session("usuarioWeb") = "SERGIO" then
							'	response.write sql
							'	response.End()
							'end if

							rs.open sql, cnn,3,3
							if not RS.EOF then
								if not isnull(rs("cod_turma")) then
									intCodTurma = rs("cod_turma")
									strNomeTurma = rs("NomeTurma")
								end if
							end if
							rs.close
							if intCodTurma = "0" then
								%>
								<script>
									alert("Não foi localiza a turma do aluno, tente fazer novamente a efetivação!")
									window.location = '../mat/EfetivacaoAluno_con.asp';
								</script>
								<%
								response.end
							end if
						%>
						  <tr>
						<td width="18%" class="texto1">&nbsp;Turma <%=Session("MatriculaInformatizadaAnoEfetivacao")%>/<%=strSem%>:</td>
						<td colspan="3" class="texto1">
								<input readonly name="txtTurmaNome" 	type="text" class="textDisabled" size="20" id="txtTurmaNome" 		value="<%=strNomeTurma%>">
								<input readonly name="cmbTurma" 		type="hidden" class="textDisabled" size="20" id="cmbTurma" 			value="<%=intCodTurma%>">
								<input readonly name="cmbTurmaTroca" 	type="hidden" class="textDisabled" size="20" id="cmbTurmaTroca" 	value="<%=intCodTurmaTroca%>">
						  *</td>
						</tr>
						
						<%else%>
					  <tr>
						<td width="18%" class="texto1">&nbsp;Turma <%=strAnoLetivo%>/<%=strSem%>:</td>
						<td colspan="3" class="texto1"><!--#include file="../includes/inc_cmdTurmaAluno.asp" -->
						  *</td>
						</tr>
						<%end if%>
                    <%else%>
					<tr>
						<td width="18%" class="texto1">&nbsp;Turma <%=strAnoLetivo%>/<%=strSem%>:</td>
						<td colspan="3" class="texto1"><!--#include file="../includes/inc_cmdTurmaAluno.asp" -->
						  *</td>
						</tr>
					<%end if%>
				  <tr>
					<td class="texto1">&nbsp;Forma Ingresso: </td>
					<td width="47%" class="texto1"><!--#include file="../includes/inc_cmdFormaIngresso.asp" --></td>
					<td width="16%" class="texto1">&nbsp;Ano/Sem. Ingresso:</td>
					<td width="19%" class="texto1"><input name="txtMesanovestibular" type="text" class="text" id="txtMesanovestibular" size="7" maxlength="6" value="<%=strMesanovestibular%>" ></td>
				  </tr>
				  <tr>
				    <td class="texto1">&nbsp;Disciplinas do Processo Seletivo: </td>
				    <td class="texto1"><!--#include file="../includes/inc_cmdDisciplinaVestibular.asp" --></td>
				    <td class="texto1">&nbsp;</td>
				    <td class="texto1">&nbsp;</td>
				    </tr>
				  <tr>
				    <td colspan="4" class="texto1"><hr size="2" color="#FFFFFF" ></td>
				  </tr>
				  <tr>
					<td class="texto1">&nbsp;Data Ingresso: </td>
					<td class="texto1"><input name="txtDataingresso" type="text" class="text" id="txtDataingresso" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataingresso%>"></td>
					<td class="texto1">&nbsp;Data Afastamento: </td>
					<td class="texto1"><input name="txtDatafastamento" type="text" class="text" id="txtDatafastamento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDatafastamento%>"></td>
				  </tr>
				  <tr>
					<td rowspan="2" class="texto1">&nbsp;Obs:</td>
					<td rowspan="2" class="texto1"><textarea  onkeyup="blocTexto(this.value,'<%=cont%>')"  name="txtObsafastamento" cols="55" rows="3" class="text" id="txtObsafastamento"><%=strObsafastamento%></textarea>
				<font color="#FF0000">(caracteres restantes: <span id="cont">500</span>)</font>			   </td>
					<td class="texto1">&nbsp;Motivo Afastamento:</td>
					<td class="texto1"><!--#include file="../includes/inc_cmdMotivoAfastamento.asp" --></td>
				  </tr>
				  <tr>
				    <td class="texto1">&nbsp;Setransp:</td>
				    <td class="texto1"><input name="txtSetransp" type="text" class="text" id="txtSetransp" size="20" maxlength="15" value="<%=strSetransp%>"></td>
				    </tr>
				  <tr>
				    <td class="texto1">&nbsp;Via Carteirinha:</td>
				    <td class="texto1"><!--#include file="../includes/inc_cmdViaCarterinha.asp" --></td>
				    <td class="texto1">&nbsp;C&oacute;digo INEP:</td>
				    <td class="texto1"><input name="txtCodigoInep" type="text" class="text" id="txtCodigoInep" size="20" maxlength="15" value="<%=strCodigoInep%>"></td>
				    </tr>
				  <tr style="display:none">
				    <td height="20" colspan="4" class="texto1">&nbsp;&nbsp;<strong>Conclus&atilde;o do Ensino M&eacute;dio</strong></td>
				    </tr>
				  <tr style="display:none">
				    <td class="texto1">&nbsp;Escola: </td>
				    <td class="texto1"><input disabled name="txtEscola" type="text" class="text" id="txtEscola" size="50" maxlength="100" value="<%=strEscola%>"></td>
				    <td class="texto1">&nbsp;Ano e Semestre de Conclus&atilde;o:: </td>
				    <td class="texto1"><input disabled name="txtAnoconclusaoEnsinoMedio" type="text" class="text" id="txtAnoconclusaoEnsinoMedio" size="5" maxlength="4" value="<%=strAnoconclusaoEnsinoMedio%>" onKeyPress="return formataCampo(this, 2, 4)">
				    /
				      <input disabled name="txtSemestreconclusaoEnsinoMedio" type="text" class="text" id="txtSemestreconclusaoEnsinoMedio" size="2" maxlength="1" value="<%=strSemestreconclusaoEnsinoMedio%>" onKeyPress="return formataCampo(this, 2, 4)"></td>
				    </tr>
				  <tr style="display:none">
				    <td class="texto1">&nbsp;Cidade:</td>
				    <td class="texto1"><input disabled name="txtCidade" type="text" class="text" id="txtCidade" size="50" maxlength="50" value="<%=strCidade%>"></td>
				    <td class="texto1">&nbsp;UF:</td>
				    <td class="texto1"><!--#include file="../includes/inc_cmdUFEnsinoMedio.asp" --></td>
				    </tr>
				  <tr style="display:none">
				    <td class="texto1"> &nbsp;IES/Escola de Origem: </td>
				    <td class="texto1"><input  disabled name="txtEscolaOrigem" type="text" class="text" id="txtEscolaOrigem" size="50" maxlength="100" value="<%=strEscolaOrigem%>"></td>
				    <td class="texto1">&nbsp;</td>
				    <td class="texto1">&nbsp;</td>
				    </tr>
				</table>
				<!-- FIM CAMPO - DADOS ESCOLARES-->			</td>
          </tr>
  			
               <tr>
            <td><hr size="1" color="#999999"></td>
          </tr>
          
          <tr>
            <td height="20" bgcolor="#EEEEEE" class="texto1" style="cursor:hand" onClick="return dadosEndereco()"><img id="imgDadosEndereco" src="<%=session("strCaminhoRaiz")%>/images/down.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Endereço</strong></td>
            </tr>
          <tr>
            <td class="texto1" >
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
				    <td class="texto1"><input name="txtBairroaluno" type="text" class="text" id="txtBairroaluno" size="40" maxlength="40" value="<%=strBairroaluno%>"></td>
				    <td class="texto1">&nbsp;</td>
				    <td class="texto1">&nbsp;</td>
				    </tr>
				  <tr>
					<td class="texto1">&nbsp;Munic&iacute;pio:</td>
					<td class="texto1"><input name="txtCidaderesidencia" type="text" class="text" id="txtCidaderesidencia" size="40" maxlength="40" value="<%=strCidaderesidencia%>"></td>
					<td class="texto1">&nbsp;UF:</td>
					<td class="texto1"><!--#include file="../includes/inc_cmdUFResidencia.asp" --></td>
				  </tr>
				</table>
				<!-- FIM CAMPO - DADOS ENDEREÇO-->			</td>
          </tr>
          <tr>
            <td><hr size="1" color="#999999"></td>
          </tr>
          <tr>
            <td height="20" bgcolor="#EEEEEE" class="texto1" style="cursor:hand" onClick="return dadosFamiliares()"><img id="imgDadosFamiliares" src="<%=session("strCaminhoRaiz")%>/images/down.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Dados Familiares</strong></td>
            </tr>
          <tr>
            <td class="texto1" >
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
				    <td class="texto1"><input name="txtPaidatanascimento" type="text" class="text" id="txtPaidatanascimento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strPaidatanascimento%>" title="Click aqui para visualizar o calend&aacute;rio"></td>
				    <td class="texto1">&nbsp;Telefone:</td>
				    <td class="texto1"><input name="txtPaifone" type="text" class="text" id="txtPaifone" onKeyPress="mascaraTelefone(this,telefone)"  size="20" maxlength="15" value="<%=strPaifone%>"></td>
				    </tr>
				  <tr>
				    <td class="texto1">&nbsp;Profiss&atilde;o: </td>
				    <td class="texto1"><!--#include file="../includes/inc_cmdProfissaoPai.asp" --></td>
				    <td class="texto1">&nbsp;Grau Instru&ccedil;&atilde;o: </td>
				    <td class="texto1"><!--#include file="../includes/inc_cmdGrauInstrucaoPai.asp" --></td>
				    </tr>
				  <tr>
					<td class="texto1">&nbsp;M&atilde;e: </td>
					<td class="texto1"><input <%=BloqueiaCampo%> name="txtMae" type="text" class="<%=strCssCampo%>" id="txtMae" size="50" maxlength="50" value="<%=strMae%>" onKeyPress="return formataCampo(this, 1, 50)">
					*</td>
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
					<td class="texto1"><input name="txtMaedatanascimento" type="text" class="text" id="txtMaedatanascimento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strMaedatanascimento%>" title="Click aqui para visualizar o calend&aacute;rio"></td>
					<td class="texto1">&nbsp;Telefone:</td>
					<td class="texto1"><input name="txtMaefone" type="text" class="text" id="txtMaefone" onKeyPress="mascaraTelefone(this,telefone)"  size="20" maxlength="15" value="<%=strMaefone%>"></td>
				  </tr>
				  <tr>
					<td class="texto1">&nbsp;Profiss&atilde;o: </td>
					<td class="texto1"><!--#include file="../includes/inc_cmdProfissaoMae.asp" --></td>
					<td class="texto1">&nbsp;Grau Instru&ccedil;&atilde;o: </td>
					<td class="texto1"><!--#include file="../includes/inc_cmdGrauInstrucaoMae.asp" --></td>
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
            <td><hr size="1" color="#999999"></td>
          </tr>
           <tr>
            <td height="20" bgcolor="#EEEEEE" class="texto1" style="cursor:hand" onClick="return dadosResponsavel()"><img id="imgdadosResponsavel" src="<%=session("strCaminhoRaiz")%>/images/down.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Dados Responsável</strong></td>
            </tr>
          <tr>
            <td class="texto1" >
				<!-- INICIO CAMPO - DADOS DOCUMENTOS-->
				<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#F5F5F5" id="mostraDadosResponsavel">
				  <tr>
					<td width="18%" class="texto1">&nbsp;Respons&aacute;vel: </td>
					<td width="47%" class="texto1"><input name="txtResponsavel" type="text" class="text" id="txtResponsavel" size="50" maxlength="50" value="<%=strResponsavel%>" onKeyPress="return formataCampo(this, 1, 50)"></td>
					<td width="16%" class="texto1">&nbsp;CPF Respons&aacute;vel:</td>
					<td width="19%" class="texto1"><input name="txtCPFResponsavel" type="text" class="text" id="txtCPFResponsavel" size="20" maxlength="14" value="<%=strCPFResponsavel%>" onKeyPress="return formataCampo(this, 5, 14)" onBlur="return validaCPF(this)" > </td>
				  </tr>
				  <tr>
				    <td class="texto1">&nbsp;Data Nascimento:</td>
				    <td class="texto1"><input name="txtResponsaveldatanascimento" type="text" class="text" id="txtResponsaveldatanascimento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strResponsaveldatanascimento%>" title="Click aqui para visualizar o calend&aacute;rio"></td>
				    <td class="texto1">&nbsp;Grau Instru&ccedil;&atilde;o: </td>
				    <td class="texto1"><!--#include file="../includes/inc_cmdGrauInstrucaoResponsavel.asp" --></td>
				    </tr>
				  <tr>
				    <td class="texto1">&nbsp;Profiss&atilde;o: </td>
				    <td class="texto1"><!--#include file="../includes/inc_cmdProfissaoResponsavel.asp" --></td>
				    <td class="texto1">&nbsp;Telefone:</td>
				    <td class="texto1"><input name="txtResponsavelfone" type="text" class="text" id="txtResponsavelfone" onKeyPress="mascara(this,telefone)"  size="20" maxlength="15" value="<%=strResponsavelfone%>"></td>
				    </tr>
				  <tr>
				    <td class="texto1">&nbsp;</td>
				    <td class="texto1">&nbsp;</td>
				    <td class="texto1">&nbsp;</td>
				    <td class="texto1">&nbsp;</td>
				  </tr>
				</table>
				<!-- FIM CAMPO - DADOS DOCUMENTOS-->			</td>
          </tr>
          <tr>
            <td><hr size="1" color="#999999"></td>
          </tr>
          <tr>
            <td height="20" bgcolor="#EEEEEE" class="texto1" style="cursor:hand" onClick="return dadosDocumentos()"><img id="imgDadosDocumentos" src="<%=session("strCaminhoRaiz")%>/images/down.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Documentação</strong></td>
            </tr>
          	<tr>
            <td class="texto1" >
				<!-- INICIO CAMPO - DADOS DOCUMENTOS-->
				<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#F5F5F5" id="mostraDadosDocumentos">
      <% if strNivelEnsinoSigla <> "EB" then%>
				  <tr>
					<td width="18%" class="texto1">&nbsp;Identidade: </td>
					<td width="47%" class="texto1"><input name="txtIdentidade" type="text" class="text" id="txtIdentidade" size="10" maxlength="20" value="<%=strIdentidade%>">
					  &nbsp;&Oacute;rg&atilde;o : 
					  <input name="txtIdentidadeOrgao" type="text" class="text" id="txtIdentidadeOrgao" size="10" maxlength="10" value="<%=strIdentidadeOrgao%>">
					  &nbsp;UF : 
					  <!--#include file="../includes/inc_cmdUFIdentidade.asp" --></td>
					<td width="16%" class="texto1">&nbsp;CPF:</td>
					<td width="19%" class="texto1"><input name="txtCpfaluno" type="text" class="text" id="txtCpfaluno" size="20" maxlength="14" value="<%=strCpfaluno%>" onKeyPress="return formataCampo(this, 5, 14)" onBlur="return validaCPF(this)"></td>
				  </tr>
                  
				  <tr>
				    <td class="texto1">&nbsp;Registro Militar  : </td>
				    <td class="texto1"><input name="txtRegmilitar" type="text" class="text" id="txtRegmilitar" size="40" maxlength="30" value="<%=strRegmilitar%>"></td>
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
<input name="txtTituloSecao" type="text" class="text" id="txtTituloSecao"  onKeyPress="return formataCampo(this,2,10)" size="5" maxlength="5" value="<%=strTituloSecao%>"></td>
					<td class="texto1">&nbsp;</td>
				  </tr>
       <% end if %>
				</table>
				<!-- FIM CAMPO - DADOS DOCUMENTOS-->			</td>
          </tr>
          <tr>
            <td><hr size="1" color="#999999"></td>
          </tr>
        <tr>
            <td><hr size="1" color="#999999"></td>
          </tr>
          <tr>
            <td height="20" bgcolor="#EEEEEE" class="texto1" style="cursor:hand" onClick="return dadosConclusao()"><img id="imgDadosConclusao" src="<%=session("strCaminhoRaiz")%>/images/down.jpg" width="12" height="12">&nbsp;&nbsp;<strong>Dados da Conclus&atilde;o</strong></td>
            </tr>
          <tr>
            <td class="texto1" >
				<!-- INICIO CAMPO - DADOS DOCUMENTOS-->
 				<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#F5F5F5" id="mostraDadosConclusao">
     <% if strNivelEnsinoSigla <> "EB" then%>
				  <tr>
					<td width="18%" class="texto1">&nbsp;Data Cola&ccedil;&atilde;o: </td>
					<td width="31%" class="texto1"><input name="txtDatacolacao" type="text" class="text" id="txtDatacolacao" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDatacolacao%>" title="Click aqui para visualizar o calend&aacute;rio"></td>
					<td width="10%" class="texto1">&nbsp;Ano Conclus&atilde;o: </td>
					<td colspan="3" class="texto1"><input name="txtAnoconclusao" type="text" class="text" id="txtAnoconclusao" size="4" maxlength="4" value="<%=strAnoconclusao%>" onKeyPress="return formataCampo(this, 2, 4)"></td>
				  </tr>
				  <tr>
				    <td class="texto1">&nbsp;Data Certificado: </td>
				    <td class="texto1"><input name="txtDatacertificado" type="text" class="text" id="txtDatacertificado" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDatacertificado%>" title="Click aqui para visualizar o calend&aacute;rio"></td>
				    <td class="texto1">&nbsp;Sem Conclus&atilde;o: </td>
				    <td width="14%" class="texto1"><input name="txtSemconclusao" type="text" class="text" id="txtSemconclusao" size="20" maxlength="1" value="<%=strSemconclusao%>" onKeyPress="return formataCampo(this, 2, 1)"></td>
				    <td width="11%" class="texto1">Data de Conclus&atilde;o:</td>
				    <td width="16%" class="texto1"><input name="txtDataConclusao" type="text" class="text" id="txtDataConclusao" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataConclusao%>" title="Click aqui para visualizar o calend&aacute;rio"></td>
				  </tr>
        <% end if %>
				</table>
				<!-- FIM CAMPO - DADOS DOCUMENTOS-->			</td>
        	 </tr>
           <tr>
            <td><hr size="1" color="#999999"></td>
          </tr>
          <tr>
            <td class="texto1">Observa&ccedil;&otilde;es:  </td>
          </tr>
          <tr>
            <td class="texto1">* Caso n&atilde;o seja informado o n&uacute;mero no campo &quot;Matr&iacute;cula&quot; o sistema se encarregar&aacute; gerar, informando ser&aacute; mantido o n&uacute;mero informado. </td>
          </tr>
          <tr>
            <td><span class="texto1">* Para realizar mudan&ccedil;a  de turma/turno/s&eacute;rie, basta entrar na aba dados escolares e selecionar a turma desejada. Se caso  o aluno tiver sua s&eacute;rie trocada durante a mudan&ccedil;a, ser&aacute; criado pelo sistema  uma nova grade de disciplinas zerando a anterior. </span></td>
          </tr>
          <tr>
            <td>                
			<% 
			
			response.write strCodAluno
			if strCodAluno <> "" and strCodAluno <> "0" then %>
                  <input type="button" name="cmdAtualizaDocumentos" style="cursor:hand"   value="Atualizar Documentações" class="botao" onClick="return AlunoDocumentacoes('<%=strCodAluno%>')">
           <% end if %>                      
			</td>
          </tr>
          <tr>
            <td><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
        </table>
	<%	if trim(strCodAluno) = "" and strMostraTodasTurmas = "" then %>
		<script>
			dadosEndereco();
			dadosFamiliares();
			dadosDocumentos();
			dadosEscolares();
			dadosConclusao();
			dadosResponsavel();
		</script>
	<%	else	%>		
		<script>
			mostraDadosEndereco.style.display="none";
			mostraDadosFamiliares.style.display="none";
			mostraDadosDocumentos.style.display="none";
			mostraDadosEscolares.style.display="none";
			mostraDadosConclusao.style.display="none";
			mostraDadosResponsavel.style.display="none";
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