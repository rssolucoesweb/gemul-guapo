<!--
	::	DESENVOLVIDO POR "RS SO/LUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 06/08/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: DEBITO PARCELAS
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
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
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif')">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<script>
	function salvar(tipo){
		var form = window.document.forms[0];
		var intContMarcado=0;
		var strAlunos='';

		if (frm.txtMatricula.value == "") {
			//*****verifica se um aluno foi selecionado
			intContMarcado=0;
			for (var i = 0; i < form.elements.length; i++) {
				//verifica todos os checkbox
				if (form.elements[i].type == "checkbox"){
					if (form.elements[i].name == "chkAluno"){
						//verifica se o checkbox está marcado
						if (form.elements[i].checked){
							intContMarcado = intContMarcado + 1;
						}
					}
				}
			}	
			if (intContMarcado==0){
				alert("O aluno deve ser informado ou selecionado!");
				return false;
			}
		}
		

		if (frm.txtValor1.value == "") {
			alert("O Valor da parcela deverá ser informado!");
			frm.txtValor1.focus();
			return false;
		}		
		
		if (frm.txtDataVencimento1.value == "") {
			alert("O Vencimento da parcela deverá ser informado!");
			frm.txtDataVencimento1.focus();
			return false;
		}		
		
		frm.action = "GerarDebitoSemPLano_cod.asp";
		frm.submit();
		
		return true;	
	}

	

</script>
<%
	strPaginaTitulo = "GerarDebitoSemPLano_cad.asp"

    strExecutarSubmitSemestre= "S"
	strExecutarSubmit    	  = "S"
    strExecutarFuncaoAnoInicial = "S"
	strExecutarFuncaoAnoFinal = "S"
	strExecutarFuncaoParcInicial = "S"
	strExecutarFuncaoParcFinal = "S"


	intSemestre 			= session("strSemestre")
	strAnoLetivo 			= session("strAnoLetivo")
	
    strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if trim(intSemestre) = "" or  trim(intSemestre) = "0"  then 	intSemestre  = session("strSemestre")

	
	strCodAluno			   = Trim(Request("txtCodAluno"))
	strMatricula 		   = Trim(Request("txtMatricula"))
	strNomealuno 		   = Trim(Request("txtNomealuno"))
	strSimouNao            = Trim(Request.Form("cmbSimouNao"))
	intCodSituacaoAluno    = Trim(Request.Form("cmbSituacaoAluno"))

	
 	if strMatricula <> "" then
	
		sql = "Select Codigo, NomeAluno, matricula from sca_aluno"
		sql = sql & " where cod_empresa = " & session("CodEmpresa")
		sql = sql & " and matricula = " & strMatricula
		rs.open sql, cnn
		if rs.eof = false then
			strCodAluno			= Trim(rs("codigo"))
			strMatricula 		= Trim(rs("Matricula"))
			strNomealuno 		= Trim(rs("Nomealuno"))
		end if
		rs.close
		
		' Verificando a alocação do aluno
		sql = "SELECT TOP 1 SCA_CURSO.Cod_Curso, SCA_TURMA.COD_SEMESTRE, SCA_TURMA.COD_TURMA, SCA_TURMA.ANOLETIVO, SCA_GRADECURRICULAR.COD_AGRUPAMENTO, SCA_TURMA.Cod_GradeCurricular, SCA_GRADECURRICULAR.AnoReferencia, SCA_GRADECURRICULAR.SemestreReferencia, SCA_TURMA.Nometurma "
		sql = sql & " FROM SCA_ALUNO_TURMA " 
		sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO " 
		sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo "
		sql = sql & " and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa "
		sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa "
		sql = sql & " where SCA_TURMA.cod_empresa = " & Session("CodEmpresa")
		sql = sql & " and 	SCA_ALUNO.CODIGO = " & strCodAluno
		sql = sql & " order by SCA_ALUNO_TURMA.CODIGO DESC "
		rs.open sql, cnn
		if rs.eof then
			%>
			<script>
				alert("ATENÇÃO: O Aluno ainda não foi alocado em uma turma, verifique!");
				window.location='GerarDebitoSemPLano_cad.asp';
			</script>
			<%
			response.end
		end if
		rs.close
	else
		strCodAluno			= ""
		strMatricula 		= ""
		strNomealuno 		= ""
	end if

	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))

	strCodParcelaInicial	= Trim(Request.Form("cmbParcelaInicial"))
	strCodParcelaFinal		= Trim(Request.Form("cmbParcelaFinal"))

	if strCodParcelaInicial = "" then strCodParcelaInicial 	= "1"
	if strCodParcelaFinal 	= "" then strCodParcelaFinal 	= "1"

	strAnoInicial				= Trim(Request.Form("cmbAnoInicial"))
	strAnoFinal					= Trim(Request.Form("cmbAnoFinal"))
	intCodTipoParcela			= Trim(Request.Form("cmbTipoParcela"))
	strConsultar				= Trim(Request("strConsultar"))
	
	strValor1					= Trim(Request.Form("txtValor1"))
	strDataVencimento1			= Trim(Request.Form("txtDataVencimento1"))
	strValorBaixa				= Trim(Request.Form("txtValorBaixa"))
	strDataPagamento			= Trim(Request.Form("txtDataPagamento"))

	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir	
	


%>
<form method="post" id="frm" action="GerarDebitoSemPLano_cad.asp">
<input name="strConsultar" type="hidden" value="S">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td width="100%" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
		<tr valign="top">
		  <td align="center">
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
          <tr>
            <td height="12">&nbsp;</td>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td height="12"><span class="texto1">Ano Letivo: </span></td>
            <td colspan="2"><span class="texto1">
              <input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
            </span></td>
          </tr>
          <tr> 
            <td width="19%" height="12"><span class="texto1">Semestre:</span></td>
              <td class="texto1"><!--#include file="../includes/inc_cmdSemestre.asp" --> </td>
          </tr>
          <tr>
            <td class="texto1">Matr&iacute;cula: </td>
            <td class="texto1"><input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="10" value="<%=strCodAluno%>" maxlength="10">
              <input name="txtMatricula" type="text" class="text" id="txtMatricula" size="20" maxlength="10" value="<%=strMatricula%>" onKeyPress="return formataCampo(this, 2, 10)" onBlur="submit()">
              <a  href="#" onClick="return abreConsulta('../SCA/Aluno_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a>
              <input readonly name="txtNomealuno" type="text" class="textDesabilita" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>" ></td>
          </tr>
          <tr> 
            <td class="texto1">Parcela e Ano Inicial:</td>
            <td class="texto1"> 
              <!--#include file="../includes/inc_cmbParcelaInicial.asp" -->
              / 
              <!--#include file="../includes/inc_cmbAnoInicial.asp" -->
			  <%
			   if ZeroLeft(strCodParcelaFinal,2) < ZeroLeft(strCodParcelaInicial,2) then
			      strCodParcelaFinal = strCodParcelaInicial
			   end if	  
			  %>		    </td>
          </tr>
          <tr> 
            <td class="texto1">Parcela e Ano Final:</td>
            <td class="texto1"> 
              <!--#include file="../includes/inc_cmbParcelaFinal.asp" -->
              / 
              <!--#include file="../includes/inc_cmbAnoFinal.asp" -->            </td>
        </tr>
          <tr> 
            <td colspan="2" class="texto1"><hr size="1" color="#CCCCCC"></td>
          </tr>
          
          <tr> 
            <td class="texto1">Tipo Parcela:</td>
            <td class="texto1"> 
              <!--#include file="../includes/inc_cmdTipoParcela.asp" -->            </td>
          </tr>
          <tr>
            <td class="texto1">Valor:</td>
            <td class="texto1"><input name="txtValor1" type="text" class="text" id="txtValor1"  onKeyPress="return currencyFormat(this,event)" size="11" maxlength="10" value="<%=strValor1%>"></td>
           
          </tr>
          <tr>
            <td class="texto1">Vencimento:</td>
            <td class="texto1"><input name="txtDataVencimento1" type="text" class="text" id="txtDataVencimento1" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataVencimento1%>"></td>
            
          </tr>
          <tr> 
            <td colspan="2" class="texto1"><hr size="1" color="#CCCCCC"></td>
          </tr>
          <tr>
            <td colspan="2" class="texto1">Informar somente quando necessitar de BAIXAR o documento gerado:</td>
            
          </tr>
          <tr>
            <td class="texto1">Valor Baixa:</td>
            <td class="texto1"><input name="txtValorBaixa" type="text" class="text" id="txtValorBaixa"  onKeyPress="return currencyFormat(this,event)" size="11" maxlength="10" value="<%=strValorBaixa%>"></td>
           
          </tr>
          <tr>
            <td class="texto1">:Data do Pagamento:</td>
            <td class="texto1"><input name="txtDataPagamento" type="text" class="text" id="txtDataPagamento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataPagamento%>"></td>
            
          </tr>
          <tr> 
            <td colspan="3" class="texto1">&nbsp;</td>
          </tr>
          <tr> 
            <td colspan="3"><hr size="1" color="#CCCCCC"></td>
          </tr>
          <tr> 
            <td colspan="3"> 
              <!--#include file="../../includes/inc_botoes_cad_con.asp"-->            </td>
          </tr>
        </table>
  		  </td>
		</tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>