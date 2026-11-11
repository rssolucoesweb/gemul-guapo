<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Vestibular 
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
<script type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
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
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=session("strCaminhoRaiz")%>/images/Consulta_over.gif','../../images/Consulta_over.gif','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif')">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../js/Calendario/Calendario.asp"-->
<script>
    
	function abreConsultaVest(){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbVestibular.value == "0"){
			alert("O vestibular deve ser informado!");
			frm.cmbVestibular.focus();
			return false;
		}
		var caminho = 'VestibularDados_con.asp?cmbVestibular=' + frm.cmbVestibular.value;
	 	 window.open(caminho,"consulta","top=0,left=0,height=500,width=620,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}
	
    function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}


	function gerarImpressao(){
		
		var frm = document.getElementById("frm");
		
		frm.action = "vestibular_rel.asp";
		frm.submit();
		return true;	
	}
	
	function gerarImpressaoBoleto(){
		
		var frm = document.getElementById("frm");
		frm.action = "vestibularBoleto_rel.asp?codInsc=" + frm.txtCodigo.value;
		frm.submit();
		return true;	
	}
	function salvar(acao){
	
		var frm = document.getElementById("frm");
		
	    if (frm.cmbVestibular.value == "0") {
			alert("A Atividade deve ser informada !");
			frm.cmbVestibular.focus();
			return false;
		}

	    if (frm.txtDataInscricao.value == "") {
			alert("A Data de Inscricao deve ser informada !");
			frm.txtDataInscricao.focus();
			return false;
		}
		
		if (frm.txtCpf.value == "") {
			alert("O CPF do Aluno deve ser informado !");
			frm.txtCpf.focus();
			return false;
		}
			
	   if (frm.txtNomealuno.value == "") {
			alert("O Nome do Aluno deve ser informado !");
			frm.txtNomealuno.focus();
			return false;
		}
		
		
		if (frm.txtIdentidade.value == "") {
			alert("O Número da Identidade deve ser informado !");
			frm.txtIdentidade.focus();
			return false;
		}
		
		if (frm.txtOrgaoExpedidor.value == "") {
			alert("O Orgão Expedidor deve ser informado !");
			frm.txtOrgaoExpedidor.focus();
			return false;
		}
		
		if (frm.txtUFExpedidor.value == "") {
			alert("O Estado Expedidor deve ser informado !");
			frm.txtUFExpedidor.focus();
			return false;
		}
		
		if (frm.txtDataNascimento.value == "") {
			alert("A Data de Nascimento deve ser informada !");
			frm.txtDataNascimento.focus();
			return false;
		}
		
		if (frm.txtCidadeNascimento.value == "") {
			alert("A Cdade de Nascimento deve ser informada !");
			frm.txtCidadeNascimento.focus();
			return false;
		}
		
		if (frm.txtUFNascimento.value == "") {
			alert("O Estado de Nascimento deve ser informado !");
			frm.txtUFNascimento.focus();
			return false;
		}
		
		if (frm.txtNacionalidade.value == "") {
			alert("A Nacionalidade deve ser informada !");
			frm.txtNacionalidade.focus();
			return false;
		}
		
		if (frm.cmbSexo.value == "0") {
			alert("O Sexo deve ser informado !");
			frm.cmbSexo.focus();
			return false;
		}
		
		if (frm.txtFone.value == "") {
			alert("O Fone deve ser informado !");
			frm.txtFone.focus();
			return false;
		}
	
		if (frm.txtLogradouro.value == "") {
			alert("O Logradouro deve ser informado !");
			frm.txtLogradouro.focus();
			return false;
		}
		

		if (frm.txtBairro.value == "") {
			alert("O Bairro deve ser informado !");
			frm.txtBairro.focus();
			return false;
		}
		
		if (frm.txtCep.value == "") {
			alert("O CEP deve ser informado !");
			frm.txtCep.focus();
			return false;
		}
	
		if (frm.txtCidade.value == "") {
			alert("A Cidade deve ser informada !");
			frm.txtCidade.focus();
			return false;
		}

		if (frm.cmbUFResidencia.value == "0") {
			alert("O Estado deve ser informado !");
			frm.cmbUFResidencia.focus();
			return false;
		}    
		if (frm.txtVencimento.value == "") {
			alert("O Vencimento deve ser Informado !");
			frm.txtVencimento.focus();
			return false;
		}    
		
		frm.action="VestibularDados_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%
	strPaginaTitulo 			= "vestibularDados_cad.asp"
	strPagina					= "vestibularDados_cad.asp"
	
	strMatriculaAluno		= Trim(Request.Form("txtMatricula"))
    strCodAluno			    = Trim(Request("txtCodAluno"))
	strNomealuno 		    = Trim(Request("txtNomealuno"))

	strMostraBotaoImprimir		= "S"
	strMostraBotaoImprimirBoleto= ""
	strExecutarSubmitVestibular = "S"
	strExecutarSubmitCursoPrimeiraOpcao = "S"
	strExecutarSubmitCursoSegundaOpcao = "S"
	
	intCodigo					= Trim(Request("txtCodigo"))
	intCodVestibular			= Trim(Request("cmbVestibular"))	

	intCodCursoPrimeiraOpcao	= Trim(Request("cmbCursoPrimeiraOpcao"))
	intCodCursoSegundaOpcao		= Trim(Request("cmbCursoSegundaOpcao"))
	intCodTurnoPrimeiraOpcao	= Trim(Request("cmbTurnoPrimeiraOpcao"))
	intCodTurnoSegundaOpcao		= Trim(Request("cmbTurnoSegundaOpcao"))
	
	strOpcao	 				= Trim(Request("cmbOpcao"))
	strCpf						= Trim(Request.Form("txtCpf"))
	strNomealuno		 		= Trim(Request("txtNomealuno"))
	strIdentidade				= Trim(Request("txtIdentidade"))
	strOrgaoExpedidor			= Trim(Request("txtOrgaoExpedidor"))
	strUFExpedidor		 		= Trim(Request("txtUFExpedidor"))
	strDataNascimento 			= Trim(Request("txtDataNascimento"))
	strCidadeNascimento 		= Trim(Request("txtCidadeNascimento"))
	strUFNascimento 			= Trim(Request("txtUFNascimento"))
	strNacionalidade 			= Trim(Request("txtNacionalidade"))
	strSexo						= Trim(Request("cmbSexo"))
	txtFone 					= Trim(Request("txtFone"))
	
	'endereço
	strLogradouro 				= Trim(Request.Form("txtLogradouro"))
	strNumero_endereco 			= Trim(Request.Form("txtNumero_endereco"))
	strComp_endereco 			= Trim(Request.Form("txtComp_endereco"))
	strBairro 					= Trim(Request.Form("txtBairro"))
	strCidade					= Trim(Request.Form("txtCidade"))
	strUfResidencia				= Trim(Request.Form("cmbUFResidencia"))
	strCep		 				= Trim(Request.Form("txtCep"))
	strDataInscricao            = formatadataAP(date)
	strValor		    	    = "0,00"
	strDataPagamento            = " "
	strDataVencimento           = " "
	strValorPagamento		   	= "0,00"
    strStatusPagamento          = "  ***  "
	
	if trim(strMatriculaAluno) <> "" then
		sql = "Select *, uf.sigla From sca_aluno a "
		sql = sql & " inner join scf_uf uf on uf.codigo = a.ufnascimento "
		sql = sql & " where cod_empresa= " & session("CodEmpresa")
		sql = sql & " and matricula = " & strMatriculaAluno
		rs.open sql, cnn
		if rs.eof = false then
		   strNomealuno		 		    = Trim(rs("Nomealuno"))
		   strIdentidade				= Trim(rs("Identidade"))
		   strOrgaoExpedidor			= Trim(rs("IdentidadeOrgao"))
		   strUFExpedidor		 		= Trim(rs("IdentidadeUf"))
		   strDataNascimento 			= Trim(rs("Datanascimento"))
		   strCidadeNascimento 		    = Trim(rs("CidadeNascimento"))
		   strUFNascimento 			    = Trim(rs("sigla"))
		   strNacionalidade 			= Trim(rs("Nacionalidade"))
		   strSexo						= Trim(rs("SexoAluno"))
		   txtFone 					    = Trim(rs("FoneResidencial"))
		   strLogradouro 				= Trim(rs("Logradouro"))
		   strNumero_endereco 			= Trim(rs("Numero_Endereco"))
		   strComp_endereco 			= Trim(rs("Comp_Endereco"))
		   strBairro 					= Trim(rs("BairroAluno"))
		   strCidade					= Trim(rs("CidadeResidencia"))
		   strUfResidencia				= Trim(rs("UfResidencia"))
		   strCep		 				= Trim(rs("CepResidencia"))
		   strDataInscricao            = formatadataAP(date)
		else
		   %>
		   <script>
		   	alert("Aluno não foi encontrado.");
		   </script>
		   <%
		end if
		rs.close
	else
		strCodAluno			    = ""
		strMatriculaAluno 		= ""
	end if
                                  
	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, Cod_Vestibular, Cod_CursoPrimeiraOpcao, Cod_CursoSegundaOpcao, Cod_TurnoPrimeiraOpcao, Cod_TurnoSegundaOpcao, OptanteEnem, valor, DataPagamento, DataVencimento, ValorPagamento, Cod_TipoPagamento, Ativado,"
		sql = sql & " CPF, NomeAluno, Identidade, OrgaoExpedidor, UFExpedidor, DataNascimento, CidadeNascimento, "
		sql = sql & " UFNascimento, Nacionalidade, Sexo, Fone, "
		sql = sql & " LOGRADOURO, NUMERO_ENDERECO, COMP_ENDERECO, "
 		sql = sql & " BAIRRO, CIDADE, UF, CEP, DataInscricao "
		sql = sql & " FROM SCA_VESTIBULAR_DADOS"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " and cod_empresa = " & Session("CodEmpresa")	
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodVestibular				= rs("Cod_Vestibular")
            if Trim(Request("cmbCursoPrimeiraOpcao")) = "0" then
			    intCodCursoPrimeiraOpcao		= rs("Cod_CursoPrimeiraOpcao")
			end if	
			if Trim(Request("cmbCursoSegundaOpcao")) = "0" then
				intCodCursoSegundaOpcao			= rs("Cod_CursoSegundaOpcao")
         	end if
			intCodTurnoPrimeiraOpcao		= rs("Cod_TurnoPrimeiraOpcao")
			intCodTurnoSegundaOpcao			= rs("Cod_TurnoSegundaOpcao")
			strOpcao	 					= rs("OptanteEnem")
			strCpf							= rs("CPF")
			strNomealuno		 			= rs("NomeAluno")
			strIdentidade					= rs("Identidade")
			strOrgaoExpedidor				= rs("OrgaoExpedidor")
			strUFExpedidor		 			= rs("UFExpedidor")
			strDataNascimento 				= rs("DataNascimento")
			strCidadeNascimento 			= rs("CidadeNascimento")
			strUFNascimento 				= rs("UFNascimento")
			strNacionalidade 				= rs("Nacionalidade")
			strSexo							= rs("Sexo")
			strFone 						= rs("Fone")
			strLogradouro 					= rs("LOGRADOURO")
			strNumero_endereco 				= rs("NUMERO_ENDERECO")
			strComp_endereco 				= rs("COMP_ENDERECO")
			strBairro	 					= rs("BAIRRO")
			strCidade						= rs("CIDADE")
			strUfResidencia					= rs("UF")
			strCep			 				= rs("CEP")
			strDataInscricao	        	= formatadataAP(rs("DataInscricao"))
            if rs("Valor") <> "" then
          		strValor		    	    	= trim(formatNumber(rs("Valor"),2))
			end if	
	        strDataPagamento            	= formatadataAP(rs("DataPagamento"))
			if rs("ValorPagamento") <> "" then
			   strValorPagamento		    	= trim(formatNumber(rs("ValorPagamento"),2))
			end if   
	        strVencimento            		= formatadataAP(rs("DataVencimento"))
		    strCod_TipoPagamento            = rs("Cod_TipoPagamento")
			strAtivado                      = Trim(rs("Ativado"))
			if strCod_TipoPagamento <>  1 then
			   strStatusPagamento = "BAIXADO"
			   strMostraBotaoImprimirBoleto    =  "" 'Desabilita o botão  Boleto
			   strDesabilitaVencimento = "readonly"
			else 
			   strStatusPagamento = " DEVE  "
			   strDesabilitaVencimento = ""
			end if
		
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Alterar
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			strDesabilitaImprimir	= ""

		end if 
		rs.close
		
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Alterar
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaImprimir	= "disabled"	
	end if 
	if trim(strAtivado) = "S" then 
		strDesabilitaIncluir        	= "disabled" 'Desabilita o botão Incluir
		strDesabilitaAlterar    	    = "disabled" 'Desabilita o botão Alterar
		strDesabilitaExcluir    	    = "disabled" 'Desabilita o botão Excluir
		strMostraBotaoImprimirBoleto    = "" 'Desabilita o botão Imprimir Boleto
		%>
		<script>
			alert("Esse aluno já foi validado. Verifique!")
		</script>
		<%
	end if
%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="100%"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form method="post" id="frm" action="#">
		  <table width="708" border="0" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
		      <table width="98%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td colspan="7" bgcolor="#CCCCCC" class="texto1"><strong>Dados do Evento ou Atividade Extra Curricular </strong></td>
                </tr>
                <tr>
                  <td  class="texto1">&nbsp;</td>
                  <td><span class="texto1">
                    <input name="txtMatricula" type="text" class="text" id="txtMatricula" size="20" maxlength="20" value="<%=strMatriculaAluno%>"  onKeyPress="return formataCampo(this, 2, 10)" onBlur="submit()">
                  </span></td>
                  <td  class="texto1">&nbsp;</td>
                  <td colspan="2" class="texto1">&nbsp;</td>
                </tr>
                <tr>
                  <td  class="texto1">Importar Dados Pessoais: </td>
                  <td colspan="4"><input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="10" value="<%=strCodAluno%>" maxlength="10">
                    <span class="texto1"><a  href="#" onClick="return abreConsulta('Aluno_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a></span>&nbsp;</td>
                </tr>
                <tr> 
                  <td  class="texto1">&nbsp;</td>
                  <td colspan="4">&nbsp;</td>
                </tr>
                <tr> 
                  <td  class="texto1">Evento ou Atividade:</td>
                  <td  class="texto1"> 
                    <!--#include file="../includes/inc_cmdVestibular.asp" --></td>
                  <td  class="texto1"><a href="#" onClick="return abreConsultaVest()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image1312','','../../images/Consulta_over.gif',1)"><img alt="Consultar Candidato"  src="../../images/Consulta_normal.gif" name="Image1312" width="26" height="26" border="0"  align="absmiddle" id="Image1312" /></a></td>
                  <td colspan="2"  class="texto1"><input type="hidden" name="txtValorVestibular" id="txtValorVestibular" value="<%=intValorVestibular%>"> 
                    <input type="hidden" name="txtDataVencimento" id="txtDataVencimento" value="<%=strDataVencimento%>"></td>
                </tr>
                <tr> 
                  <td class="texto1">Data da Inscri&ccedil;&atilde;o: </td>
                  <td class="texto1"><span class="TextoForm"> 
                    <input name="txtDataInscricao" type="text" class="text" id="txtDataInscricao" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" value="<%=strDataInscricao%>">
                    </span></td>
                  <td class="texto1">&nbsp;</td>
                  <td colspan="2" class="texto1">&nbsp;</td>
                  <td class="texto1">&nbsp;</td>
                  <td class="texto1">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="7" class="texto1">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="7" bgcolor="#CCCCCC" class="texto1">Dados do Curso                  </td>
                </tr>
                <tr> 
                  <td width="318" class="texto1">&nbsp;</td>
                  <td colspan="6">&nbsp;</td>
                </tr>
                <tr> 
                  <td class="texto1">Curso e Turno na 1 Op&ccedil;&atilde;o : </td>
                  <td colspan="4"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"> 
                    <!--#include file="../includes/inc_cmdCursoPrimeraOpcao.asp" --> 
                    -   <!--#include file="../includes/inc_cmbTurnoPrimeiraOpcao.asp" -->              </td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td height="28" class="texto1">Curso e Turno na 2 Op&ccedil;&atilde;o :                  </td>
                  <td colspan="4"> 
                    <!--#include file="../includes/inc_cmdCursoSegundaOpcao.asp" --> 
                    -   <!--#include file="../includes/inc_cmbTurnoSegundaOpcao.asp" -->              </td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td height="29" class="texto1">Optante ENEM : </td>
                  <td colspan="4"> 
                    <!--#include file="../includes/inc_cmdOpcao.asp" -->                  </td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="texto1">&nbsp;</td>
                  <td colspan="6">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="7" bgcolor="#CCCCCC" class="texto1"><strong>Dados do Aluno                  </strong></td>
                </tr>
                <tr> 
                  <td class="texto1">&nbsp;</td>
                  <td colspan="6">&nbsp;</td>
                </tr>
                <tr>
                  <td height="23" class="texto1">CPF : </td>
                  <td colspan="6"><span class="texto1">
                    <input name="txtCpf" type="text" class="text" id="txtCpf" size="15" maxlength="14" value="<%=strCpf%>" onKeyPress="return formataCampo(this, 5, 14)">
                  </span></td>
                </tr>
                <tr> 
                  <td class="texto1">Nome Aluno : </td>
                  <td colspan="6"><span class="texto1"> 
                    <input name="txtNomealuno" type="text" class="text" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>"  onKeyPress="return formataCampo(this, 1, 50)">
                    </span></td>
                </tr>
                <tr> 
                  <td height="27" class="texto1">N da Identidade :</td>
                  <td width="120"><span class="texto1"> 
                    <input name="txtIdentidade" type="text" class="text" id="txtIdentidade" size="20" maxlength="20" value="<%=strIdentidade%>">
                    </span></td>
                  <td width="96"><span class="texto1">&Oacute;rg&atilde;o Exp. 
                    :</span></td>
                  <td colspan="2"><span class="texto1"> 
                    <input name="txtOrgaoExpedidor" type="text" class="text" id="txtOrgaoExpedidor" size="20" maxlength="20" value="<%=strOrgaoExpedidor%>">
                    </span></td>
                  <td width="95"><span class="texto1">Estado : </span></td>
                  <td width="213"><span class="texto1"> 
                    <input name="txtUFExpedidor" type="text" class="text" id="txtUFExpedidor" size="5" maxlength="2" value="<%=strUFExpedidor%>">
                    </span></td>
                </tr>
                <tr> 
                  <td height="27" class="texto1">Data Nascimento :</td>
                  <td><span class="texto1"> 
                    <input name="txtDataNascimento" type="text" class="text" id="txtDataNascimento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDatanascimento%>" style="cursor:hand" title="Click aqui para visualizar o calend&aacute;rio">
                    </span></td>
                  <td><span class="texto1">Cidade :</span></td>
                  <td colspan="2"><span class="texto1"> 
                    <input name="txtCidadeNascimento" type="text" class="text" id="txtCidadeNascimento" size="40" maxlength="40" value="<%=strCidadeNascimento%>">
                    </span></td>
                  <td><span class="texto1">Estado : </span></td>
                  <td><span class="texto1"> 
                    <input name="txtUFNascimento" type="text" class="text" id="txtUFNascimento" size="5" maxlength="2" value="<%=strUFNascimento%>">
                    </span></td>
                </tr>
                <tr> 
                  <td height="27" class="texto1">Nacionalidade : </td>
                  <td><span class="texto1"> 
                    <input name="txtNacionalidade" type="text" class="text" id="txtNacionalidade" size="20" maxlength="20" value="<%=strNacionalidade%>">
                    </span></td>
                  <td><span class="texto1">Sexo : </span></td>
                  <td colspan="2"><span class="texto1"> 
                    <!--#include file="../includes/inc_cmdSexo.asp" -->
                    </span></td>
                  <td><span class="texto1">Fone : </span></td>
                  <td><span class="texto1"> 
                    <input name="txtFone" type="text" class="text" onKeyPress="mascara(this,telefone)" id="txtFone" size="14" maxlength="14" value="<%=strFone%>">
                    </span></td>
                </tr>
                <tr> 
                  <td class="texto1">&nbsp;</td>
                  <td colspan="6">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="7" bgcolor="#CCCCCC" class="texto1"><strong>Endere&ccedil;o</strong></td>
                </tr>
                <tr> 
                  <td colspan="7" class="texto1"><table width="100%" border="0" cellpadding="0" cellspacing="0" id="mostraDadosEndereco">
                      <tr> 
                        <td width="13%" height="28" class="texto1">&nbsp;Logradouro:                        </td>
                        <td colspan="4" class="texto1"><input name="txtLogradouro" type="text" class="text" id="txtLogradouro" size="40" maxlength="40" value="<%=strLogradouro%>"></td>
                        <td width="6%" class="texto1">&nbsp;N&uacute;mero:</td>
                        <td width="37%" class="texto1"><input name="txtNumero_endereco" type="text" class="text" id="txtNumero_endereco" size="20" maxlength="5" value="<%=strNumero_endereco%>"  onKeyPress="return formataCampo(this, 2, 5)"></td>
                      </tr>
                      <tr> 
                        <td height="21" class="texto1">&nbsp;Complemento:</td>
                        <td colspan="4" class="texto1"><input name="txtComp_endereco" type="text" class="text" id="txtComp_endereco" size="40" maxlength="40" value="<%=strComp_endereco%>" ></td>
                        <td class="texto1">&nbsp;CEP:</td>
                        <td class="texto1"><input name="txtCep" type="text" class="text"  id="txtCep" size="9" maxlength="9" value="<%=strCep%>" onKeyPress="mascara(this,cep)" ></td>
                      </tr>
                      <tr> 
                        <td height="23" class="texto1">&nbsp;Bairro:</td>
                        <td colspan="4" class="texto1"><input name="txtBairro" type="text" class="text" id="txtBairro" size="40" maxlength="40" value="<%=strBairro%>" onKeyPress="return formataCampo(this, 1, 40)"></td>
                        <td class="texto1">&nbsp;</td>
                        <td class="texto1">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td class="texto1">&nbsp;Munic&iacute;pio:</td>
                        <td colspan="4" class="texto1"><input name="txtCidade" type="text" class="text" id="txtCidade" size="40" maxlength="40" value="<%=strCidade%>" onKeyPress="return formataCampo(this, 1, 40)"></td>
                        <td class="texto1">&nbsp;UF:</td>
                        <td class="texto1"> 
                          <!--#include file="../includes/inc_cmdUFResidencia.asp" -->                        </td>
                      </tr>
                      <tr> 
                        <td class="texto1">&nbsp;</td>
                        <td colspan="4" class="texto1">&nbsp;</td>
                        <td class="texto1">&nbsp;</td>
                        <td class="texto1">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td height="21" bgcolor="#CCCCCC" class="texto1"><strong>Posi&ccedil;&atilde;o 
                          Financeira</strong>: </td>
                        <td bgcolor="#CCCCCC" width="6%" class="texto1">Valor 
                          da Inscri&ccedil;&atilde;o</td>
                        <td bgcolor="#CCCCCC" width="7%" class="texto1">Data Vencimento</td>
                        <td bgcolor="#CCCCCC" width="12%" class="texto1">Data 
                          do Pagamento</td>
                        <td bgcolor="#CCCCCC" width="19%" class="texto1">Valor 
                          Pago </td>
                        <td bgcolor="#CCCCCC" class="texto1">Situa&ccedil;&atilde;o</td>
                        <td class="texto1">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td class="texto1">&nbsp;</td>
                        <td class="texto1"><strong><%=strValor%></strong></td>
                        <td class="texto1"><div align="center">
                          <input <%=strDesabilitaVencimento%> name="txtVencimento" type="text" class="text" id="txtVencimento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strVencimento%>">
                        </div></td>
                        <td class="texto1"><strong><%=strDataPagamento%></strong></td>
                        <td class="texto1"><strong><%=strValorPagamento%></strong></td>
						<td bgcolor="#CCCCCC" class="texto1"><div align="center"><strong><%=strStatusPagamento%></strong></div></td>
                        <td class="texto1">&nbsp;</td>
                      </tr>
                  </table></td>
                </tr>
                <tr> 
                  <td colspan=5 >&nbsp;</td>
                </tr>
                <tr>
                  <td colspan=5 >
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->                  </td>
                </tr>
                <tr> 
                  <td colspan=5 >&nbsp; </td>
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