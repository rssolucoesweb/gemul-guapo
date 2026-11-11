<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 27/11/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Criterio de Avaliação
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
//-->
</script></head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif')">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurmaTodasSituacoes.asp"-->
<!--#include file="../../js/Calendario/Calendario.asp"-->
<script>

	function marcaTodos(valor){
		
		var frm = document.getElementById("frm");
		var form = window.document.forms[0];
		var i;
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "checkbox"){
				//verifica se o checkbox está marcado
				if (form.elements[i].disabled == false){
				form.elements[i].checked=valor;
				}

			}
		}
	}
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbSituacaoAluno.value=="0"){
			alert("Selecione a situação do aluno")		
			frm.cmbSituacaoAluno.focus();
			return false
		}
		
		frm.action="ControleSituacaoAluno_cod.asp";
		frm.submit();
		return true;
 	}

</script>
<%
	strPaginaTitulo = "ControleSituacaoAluno_cad.asp"

	strExecutarSubmitSemestre 		= "S"
	strExecutarSubmitCurso	  		= "S"
	strExecutarSubmitPeriodo  		= "S"
	strExecutarSubmitTurno	 		= "S"
	strExecutarSubmitTurma	 		= "S"	

	intSemestre 			= Trim(Request("cmbSemestre"))
	strSemestre 			= Trim(Request("cmbSemestre"))
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if

	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula 		= Trim(Request("txtMatricula"))
	strNomealuno 		= Trim(Request("txtNomealuno"))

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
	else
			strCodAluno			= ""
			strMatricula 		= ""
			strNomealuno 		= ""
	end if


	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	
	strFiltroSerie 			= "0"
	strFiltroTurno 			= "0"

	if intCodCurso 		= "" then intCodCurso 		= "0"
	if intCodSerie 		= "" then intCodSerie 		= "0"
	if intCodTurno 		= "" then intCodTurno 		= "0"
	if intCodTurma 		= "" then intCodTurma 		= "0"

	strMostraAlunos = ""
	if 	intCodCurso <> "0" then strMostraAlunos = "S"
	if 	intCodSerie <> "0" then strMostraAlunos = "S"
	if 	intCodTurno <> "0" then strMostraAlunos = "S"
	if 	intCodTurma <> "0" then strMostraAlunos = "S"

	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	strbotaoAtualizar		= "S"

%>
<form method="post" id="frm" action="ControleSituacaoAluno_cad.asp">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td  align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
		<tr valign="top">
		  <td align="center">
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
    <tr>
      <td class="texto1">&nbsp;</td>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td class="texto1">Ano:</td>
      <td colspan="2"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
    </tr>
    <tr>
      <td class="texto1">Semestre:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
    </tr>
    <tr> 
      <td width="14%" class="texto1">Turma:</td>
      <td width="86%" colspan="2"><!--#include file="../includes/inc_cmdTurma.asp"--></td>
    </tr>
    
    <tr>
      <td class="texto1">Trocar Situa&ccedil;&atilde;o para: </td>
      <td colspan="2"><!--#include file="../includes/inc_cmdSituacaoAluno.asp"--></td>
    </tr>
   <tr>
      <td height="18" class="texto1">Dt. Matr&iacute;cula:</td>
      <td><span class="texto1">
        <input name="txtDatamatricula" type="text" class="text" id="txtDatamatricula" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDatamatricula%>" title="Click aqui para visualizar o calend&aacute;rio">
      </span></td>
    </tr>
    <tr>
      <td height="18" class="texto1">Dt. Afastamento:</td>
      <td><span class="texto1">
        <input name="txtDatafastamento" type="text" class="text" id="txtDatafastamento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDatafastamento%>" title="Click aqui para visualizar o calend&aacute;rio">
      </span></td>
    </tr>
    <tr> 
      <td class="texto1">&nbsp;</td>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="3"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr> 
      <td colspan="3"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
    </tr>
    <tr> 
      <td colspan="3" class="texto1"> <br> 
	  <%
			if strMostraAlunos = "S" OR strMatricula <> "" then%> 
			
			<table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
          <tr class="CabecalhoConsulta"> 
            <td width="32" align="center" class="celula"><input type="checkbox" name="chkTodos" onClick="return marcaTodos(this.checked)"></td>
            <td width="40" class="celula"><strong>Ord.</strong></td>
            <td width="187" class="celula"><strong>Matr&iacute;cula</strong></td>
            <td width="391" class="celula"><strong>Nome</strong></td>
            <td width="125" class="celula"><strong>Turma</strong></td>
            <td width="131" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
          </tr>
          <%	
		  	cont = 0				
			'seleciona os alunos da turma'					
			sql = sqlAlunoTurma(intCodTurma, "")
			rs.open sql, cnn
			if rs.eof = false then
				selecionado = "checked"
				while not rs.eof

					cont = cont +1
					strCodigoAluno        = rs("codigo")
					strMatricula		  = rs("MATRICULA")
					
					strBloqAltrExcl 	  = ""
					corLinha 			  = " "
					sql = "select efetivacao, codigo as codInscricao from mat_inscricao where cod_aluno = " & strCodigoAluno
					rsAux.open sql, cnn
					if not rsAux.eof then
						strEfetivacao		  = rsAux("EFETIVACAO")
						if not isnull(rsAux("codInscricao")) then
							if strEfetivacao = "S" then
								strBloqAltrExcl = ""
								corLinha = " "
							else
								strBloqAltrExcl = "disabled"
								strMensagemEfetivacao = "<br><table class='tabela' width='50%' border='0' cellspacing='0' cellpadding='0'><tr  bgcolor='#9BCDFF'><td class='celula'><strong>* Aluno não está efetivado!</strong></td></tr></table><br><br>"
								corLinha = " bgcolor='#9BCDFF' "
							end if
						end if			
					end if
					rsAux.close
					%>
          <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" <%=corLinha%>> 
            <td class="celula" align="center"><input type="checkbox" id="chkAluno"  <%=strBloqAltrExcl%>  name="chkAluno" value="<%=rs("codigo")%>"></td>
            <td class="celula"><div align="center"><%=cont%></div></td>
            <td class="celula">&nbsp;<%=strMatricula%></td>
            <td class="celula"><%=rs("NOMEALUNO")%>&nbsp;</td>
            <td class="celula"><%=rs("NOMETURMA")%>&nbsp;</td>
            <td class="celula"><%=rs("Desc_SituacaoAluno")%>&nbsp;</td>
          </tr>
          <%			selecionado = ""
						rs.movenext
					wend
				else
					%>
					  <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
						<td colspan="6" align="center" class="celula"><%=session("strMensagemRelatorioNaoEncontrado")%></td>
					  </tr>
					  <%
					end if
					rs.close
			end if
					%>
        </table>
			<br><strong><%=strMensagemEfetivacao%></strong></td>
    </tr>
  </table>
  		  </td>
		</tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>