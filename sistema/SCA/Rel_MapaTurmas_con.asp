<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Extrato de NOtas
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css"></head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<script>
	function gerar(){
	
		var frm = document.getElementById("frm");
		
		if (frm.optOpcao[0].checked==false && frm.optOpcao[1].checked==false && frm.optOpcao[2].checked==false){
			alert("Selecione o filtro para relatório.");
			return false
		}
		var filtro;
		if (frm.optOpcao[0].checked==true) filtro = "T"
		if (frm.optOpcao[1].checked==true) filtro = "A"
		if (frm.optOpcao[2].checked==true) filtro = "C"
		
		frm.action = "Rel_MapaTurmas_rel.asp?f="+filtro;
		frm.submit();
		return true;	
	}	
</script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--include file="../includes/inc_sqlAlunoTurma.asp"-->
<!--#include file="../../js/Calendario/Calendario.asp"-->
<%
	strPaginaTitulo = "Rel_MapaTurmas_con.asp"

	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodGrade				= Trim(Request.Form("cmbGrade"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	strDataI 				= trim(request.Form("txtDataI"))
	strDataF 				= trim(request.Form("txtDataF"))
	strDataInicio 			= trim(request.Form("txtDataInicio"))
	strDataFim 				= trim(request.Form("txtDataFim"))
	strlpp 					= Trim(Request.Form("cmblpp"))
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))

	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")

	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodSemestre = "" then intCodSemestre = "0"

	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""

%>
<form method="post" id="frm" action="#">
<input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
		<tr valign="top">
		  <td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
		</tr>
		<tr valign="top">
		  <td align="center">
<br>
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
      <% if Session("CodEmpresa") <> "119" then  %>
           <tr>
            <td class="texto1">Ano Letivo:</td>
            <td colspan="2"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
            </tr>
          <tr>
            <td class="texto1">Semestre:</td>
            <td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
          </tr>
      <% end if %>

    <tr>
      <td width="16%" class="texto1">Curso:</td>
      <td width="84%"><span class="texto1">
        <!--#include file="../includes/inc_cmdCurso.asp"--></span></td>
    </tr>
      <% if Session("CodEmpresa") <> "119" then  %>
            <tr>
              <td class="texto1">Período:</td>
              <td colspan="2"><!--#include file="../includes/inc_cmdPeriodo.asp"--></td>
            </tr>
      <% end if %>
    <tr>
      <td class="texto1">Filtro:</td>
      <%
			 	if request.Form("txtHiddenStatus") <> "" then
				   strDesabilitaSerie = "disabled"
				end if
			 %>
      <td colspan="2" class="texto1"><p><strong>
        <input <% if strOpcaoRelatorio = "T" then response.Write("checked")%> name="optOpcao" type="radio" value="T">
        Total por Disciplinas - Todas Turmas &nbsp;&nbsp; <br>
  <input <% if strOpcaoRelatorio = "A" then response.Write("checked")%> name="optOpcao" type="radio" value="A"> 
        Total por Disciplinas - Somente Turmas Ativas, com alunos vinculados</strong><br>
<strong><input <% if strOpcaoRelatorio = "C" then response.Write("checked")%> name="optOpcao" type="radio" value="C"> 
Total </strong><strong>por Aluno</strong></td>
    </tr>
    
    <tr>
      <td class="texto1">Ingressantes:</td>
      <td colspan="2"><input type="checkbox" name="chkIngressantes" value="S"></td>
    </tr>
    <tr>
      <td class="texto1">Processo Seletivo:</td>
      <td colspan="2" class="texto1"><input type="checkbox" name="chkProcessoSeletivo" value="S">
        - Somente alunos que passaram pelo processo de valida&ccedil;&atilde;o do evento.</td>
    </tr>
    <tr>
      <td class="texto1">Situa&ccedil;&atilde;o:</td>
      <td colspan="2" class="texto1"><!--#include file="../includes/inc_cmdSituacaoAluno.asp"--> 
      - 
        <input type="checkbox" name="chkAgruparAtivosPrematriculas" value="S"> 
        Classificar somentar  ATIVOS e PR&Eacute;-MATRICULAS.</td>
    </tr>
     <tr>
      <td class="texto1">Turno:</td>
      <td colspan="3"><!--#include file="../includes/inc_cmdTurno.asp" --></td>
    </tr>
     <tr>
       <td class="texto1">Data de Aloca&ccedil;&atilde;o/Matr&iacute;cula:</td>
       <td colspan="3" class="texto1"><input name="txtDataI" type="text" class="text" id="txtDataI" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataI%>" style="cursor:hand" title="Click aqui para visualizar o calend&aacute;rio"> 
         a 
         <input name="txtDataF" type="text" class="text" id="txtDataF" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataF%>" style="cursor:hand" title="Click aqui para visualizar o calend&aacute;rio">       </td>
     </tr>
     <tr>
       <td class="texto1">Data de Ingresso:</td>
       <td colspan="3" class="texto1"><input name="txtDataInicio" type="text" class="text" id="txtDataInicio" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataInicio%>" style="cursor:hand" title="Click aqui para visualizar o calend&aacute;rio"> 
          a 
         <input name="txtDataFim" type="text" class="text" id="txtDataFim" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataFim%>" style="cursor:hand" title="Click aqui para visualizar o calend&aacute;rio">           </td>
     </tr>
     <% if intCodCurso = "0" or intCodCurso = "" then %>
         <tr>
           <td class="texto1">Ordenar por Curso e Per&iacute;odo:</td>
           <td colspan="3"><input type="checkbox" name="chkOrdenaCursoPeriodo" value="S"></td>
         </tr>
     <% end if %>
     <tr>
      <td class="texto1">Linhas por P&aacute;gina: </td>
      <td colspan="3"><!--#include file="../includes/inc_cmbLinhaPorPagina.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Tamanho da Fonte:</td>
      <td colspan="3"><!--#include file="../includes/inc_cmbTamanhoFonteArial.asp"--></td>
    </tr>
    <tr>
      <td colspan="3"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr>
      <td colspan="3"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->&nbsp;</td>
    </tr>
  </table>
<br>
<br>		  </td>
		</tr>
  </table>

</form>
<!--#include file="../rodape.asp"-->
</body>
</html>
