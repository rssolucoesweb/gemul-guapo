<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Extrato de NOtas
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<script>
	function marcaTodos(valor){
		
		var frm = document.getElementById("frm");
		var form = window.document.forms[0];
		var i;
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "checkbox"){
				//verifica se o checkbox está marcado
				form.elements[i].checked=valor;
			}
		}
	}
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbTurma.value == "0") {
			alert("A Turma deve ser informada !");
			frm.cmbTurma.focus();
			return false;
		}
		
		frm.action="numeroDiarioFrequencia_cod.asp?acao=A";
		frm.submit();
		return true;
 	}

</script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<%
	strPaginaTitulo = "numeroDiarioFrequencia_cad.asp"

	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodGrade				= Trim(Request.Form("cmbGrade"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))

	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"


	'controla os botões
	strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

%>
<form method="post" id="frm" action="#">
<input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
		<tr valign="top">
		  <td align="center">
<br>
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
     <tr>
      <td width="12%" class="texto1">Curso</td>
      <td width="88%"><span class="texto1"><!--#include file="../includes/inc_cmdCurso.asp"--></span></td>
    </tr>
    <tr>
      <td class="texto1">Per&iacute;odo</td>
      <%
			 	if request.Form("txtHiddenStatus") <> "" then
				   strDesabilitaSerie = "disabled"
				end if
			 %>
      <td colspan="2"><!--#include file="../includes/inc_cmdPeriodo.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Semestre</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Turno</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdTurno.asp"--></td>
    </tr>
    
    <tr>
      <td class="texto1">Turma</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdTurma.asp"--></td>
    </tr>
    
    <tr>
      <td colspan="3"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr>
      <td colspan="3"><!--#include file="../../includes/inc_botoes_cadastro.asp"-->&nbsp;</td>
    </tr>
    <tr>
      <td colspan="3">
			<br>
			<%
			if intCodTurma    = "" then intCodTurma="0"
			if intCodPeriodo = "" then intCodPeriodo="0"

			if intCodTurma<>"0" and intCodPeriodo<>"0" then%>
				<table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
          <tr class="CabecalhoConsulta">
            <td width="151" class="celula"><strong>Matrícula</strong></td>
            <td width="619" class="celula"><strong>Nome do aluno em ordem alfabética</strong></td>
            <td width="187" class="celula"><div align="center"><strong>N&uacute;mero do Di&aacute;rio </strong></div></td>
          </tr>
          <%					
					'seleciona os alunos da turma'					
					sql = sqlAlunoTurma(intCodTurma, "")
					rs.open sql, cnn
					
					'Armazena o código de todos os alunos da turma'
					strAlunosTurma=""
					if rs.eof = false then
						while not rs.eof
							strCodigoAlunoTurma   = rs("CODALUNOTURMA")
							strMatricula		  = rs("MATRICULA")

							'Função que verifica a siuação do aluno
							strSituacaoPromocao = "" 'Não é necessário mostrar a situação promoção nesta tela

							%>
						  <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
							<td class="celula"><%=strMatricula%></td>
							<td class="celula"><%=rs("NOMEALUNO") & " " & strSituacaoAluno%>&nbsp;</td>
							<td class="celula"><div align="center">
							  <input name="txtChamada<%=strCodigoAlunoTurma%>"  value="<%=rs("sequencia")%>" type="text"  class="text" size="4" onKeyPress="return formataCampo(this,2,5)">
							</div></td>
						  </tr>
						  <%
							rs.movenext
						wend
					else
					%>
          <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
            <td colspan="3" align="center" class="celula"><%=session("strMensagemNaoEncontrado")%></td>
          </tr>
					<%
					end if
					rs.close
			end if
					%>
        </table>
		<br>
			
		</td>
    </tr>
  </table>
		  </td>
		</tr>
  </table><input type="hidden" name="txtHiddenAlunosTurma" value="<%=strAlunosTurma%>">
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>
