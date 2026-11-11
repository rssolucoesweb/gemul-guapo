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
	function gerar(){
		var caminho;
		if (frm.optOpcao[0].checked==false && frm.optOpcao[1].checked==false && frm.optOpcao[2].checked==false && frm.optOpcao[3].checked==false && frm.optOpcao[4].checked==false && frm.optOpcao[5].checked==false && frm.optOpcao[6].checked==false && frm.optOpcao[7].checked==false && frm.optOpcao[8].checked==false && frm.optOpcao[9].checked==false && frm.optOpcao[10].checked==false && frm.optOpcao[11].checked==false) {
			alert("Opção de relatório deve ser informada !");
			frm.optOpcao[0].focus();
			return false;
		}	
		if (frm.optOpcao[0].checked) {
			caminho = "Rel_AlunoPorTurma_rel.asp"
		}	
		if (frm.optOpcao[1].checked) {
			caminho = "Rel_AlunoPorTurmaAssinatura_rel.asp"
		}	
		if (frm.optOpcao[2].checked) {
			caminho = "Rel_AlunoPorTurmaLisa_rel.asp"
		}	
		if (frm.optOpcao[3].checked) {
			caminho = "Rel_AlunoPorTurmaEndereco_rel.asp"
		}	
		if (frm.optOpcao[4].checked) {
			caminho = "Rel_AlunoPorTurmaPai_rel.asp"
		}	
		if (frm.optOpcao[5].checked) {
			caminho = "Rel_AlunoPorTurmaMae_rel.asp"
		}	
		if (frm.optOpcao[6].checked) {
			caminho = "Rel_AlunoPorTurmaIdade_rel.asp"
		}	
		if (frm.optOpcao[7].checked) {
			if (frm.cmbMes.value=="0") {
				alert("O Mês deve ser informado!");
				frm.optOpcao[0].focus();
				return false;
			}
		
			caminho = "Rel_AlunoPorTurmaAniversario_rel.asp"
		}	
		if (frm.optOpcao[8].checked) {
			caminho = "Rel_AlunoPorTurmaEntregaRecebimento_rel.asp"
		}	
		if (frm.optOpcao[9].checked) {
			caminho = "Rel_AlunoPorTurmaPreMatricula_rel.asp"
		}	
		if (frm.optOpcao[10].checked) {
			caminho = "Rel_AlunoPorTurmaFoto_rel.asp"
		}	
		if (frm.optOpcao[11].checked) {
			caminho = "Rel_AlunoPorTurmaDataNascimnetoBairro_rel.asp"
		}	

		frm.action = caminho;
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
	strPaginaTitulo = "Rel_AlunoPorTurma_con.asp"
	
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	strExecutarSubmit         = "S"
	
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodDisciplinaTurma   = trim(request("cmbDisciplinaTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodGrade				= Trim(Request.Form("cmbGrade"))
	strSexo					= Trim(Request.Form("cmbSexo"))
	strMes					= Trim(Request.Form("cmbMes"))
	intCodFormaIngresso 	= Trim(Request.Form("cmbFormaIngresso"))
	intCodSituacaoAluno     = Trim(Request.Form("cmbSituacaoAluno"))
	intCodEstagio     		= Trim(Request.Form("cmbEstagio"))

	if strMes = "" or strMes = "0" then strMes = month(date)

	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	intCodPlanoPagamento	= Trim(Request.Form("cmbPlanoPagamento"))
	strSala		 			= Trim(Request.Form("txtSala"))
	strSubTitulo 			= Trim(Request.Form("txtSubTitulo"))
	strlpp 					= Trim(Request.Form("cmblpp"))
	IF strlpp = "" THEN strlpp = "0"
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))

	if Trim(Request.Form("txtAnoLetivo")) <> "" then
	   strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	else
	   strAnoLetivo = session("strAnoLetivo")   
	end if   


	if trim(intCodTurma) <> "" then
		sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma"
		sql = sql & " FROM SCA_TURMA "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
		SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
		sql = sql & " AND SCA_TURMA.Cod_Turma= " & intCodTurma
		RS.OPEN SQL, CNN
		IF not RS.EOF THEN
			intCodCurso 	= rs("cod_curso")
			intCodPeriodo = rs("cod_periodo")
			intCodTurno = rs("cod_turno")
			intSemestre = rs("cod_Semestre")
		END IF
		rs.close
	end if

	strOpcaoRelatorio		= Trim(Request.Form("optOpcao"))
	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if strSexo = "" then strSexo = "0"
	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	if intCodTipoLancamento = "" then intCodTipoLancamento = "0"
	if intCodDisciplinaTurma = "" then intCodDisciplinaTurma = "0"
	if intCodNota = "" then intCodNota="0"

	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""

%>
<form method="post" id="frm" action="#">
<input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
<table width="100%" border="0" cellpadding="0" bgcolor="#FFFFFF" cellspacing="0">
            <tr valign="top">
              <td align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
  </table>
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" bgcolor="#FFFFFF">
     <tr>
       <td height="146" class="texto1"><strong>Op&ccedil;&atilde;o de Relat&oacute;rio: </strong></td>
       <td width="39%" class="texto1"><p><strong>
         <input <% if strOpcaoRelatorio = "0" then response.Write("checked")%> name="optOpcao" type="radio" value="0" onClick="submit()">
         Datas&nbsp;&nbsp;&nbsp;&nbsp; <br>
         <input <% if strOpcaoRelatorio = "1" then response.Write("checked")%> name="optOpcao" type="radio" value="1" onClick="submit()">
         Assinatura<br>
         <input <% if strOpcaoRelatorio = "2" then response.Write("checked")%> name="optOpcao" type="radio" value="2" onClick="submit()">
         Simplificada ( Matr&iacute;cula e nome do aluno )
         &nbsp;- Envia Email&nbsp;&nbsp; <br>
         <input <% if strOpcaoRelatorio = "3" then response.Write("checked")%> name="optOpcao" type="radio" value="3" onClick="submit()">
         Endere&ccedil;o, Telefone e Email <br>
         <input <% if strOpcaoRelatorio = "4" then response.Write("checked")%> name="optOpcao" type="radio" value="4" onClick="submit()">
         Cpf, Pai eTelefone</strong>
         <strong> <br>
           <input <% if strOpcaoRelatorio = "5" then response.Write("checked")%> name="optOpcao" type="radio" value="5" onClick="submit()">
M&atilde;e, Telefone, Data Nascimento, C&oacute;d.  Seguran&ccedil;a, Endere&ccedil;o, Data Matricula e Situa&ccedil;&atilde;o<br>
       </strong></p></td>
       <td width="45%" class="texto1" valign="top"><p><strong>
         <br>
         <br>
         <input <% if strOpcaoRelatorio = "6" then response.Write("checked")%> name="optOpcao" type="radio" value="6" onClick="submit()">
         Data de Nascimento, Naturalidade e Idade<br>
         <input <% if strOpcaoRelatorio = "7" then response.Write("checked")%> name="optOpcao" type="radio" value="7" onClick="submit()">
         Aniversariantes do M&ecirc;s:&nbsp;
         <!--#include file="../includes/inc_cmbMes.asp"-->
         com Idade:&nbsp;
         <!--#include file="../includes/inc_cmbIdade.asp"-->
       </strong>
       <strong> &nbsp;- Envia Email&nbsp;&nbsp; <BR>
       <input <% if strOpcaoRelatorio = "8" then response.Write("checked")%> name="optOpcao" type="radio" value="8" onClick="submit()">
       Controle de Entrega e Recebimento</strong><BR>
       <strong>
         <input <% if strOpcaoRelatorio = "9" then response.Write("checked")%> name="optOpcao" type="radio" value="10" onClick="submit()">
           Controle  de Requerimento - Pr&eacute;-Matr&iacute;cula       </strong>
       <BR><strong>
       <input <% if strOpcaoRelatorio = "10" then response.Write("checked")%> name="optOpcao" type="radio" value="10" onClick="submit()">
       Fotos
       </strong><br>
       <strong>
       <input <% if strOpcaoRelatorio = "11" then response.Write("checked")%> name="optOpcao" type="radio" value="11" onClick="submit()">
Data Nascimento e bairro onde mora</strong></td>
    </tr>
     <tr>
       <td class="texto1">Ano Letivo:</td>
       <td colspan="2"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
     </tr>
     <tr>
       <td class="texto1">Semestre:</td>
       <td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp"--></td>
     </tr>
     <tr>
      <td width="16%" class="texto1">Curso:</td>
      <td colspan="2"><span class="texto1"><!--#include file="../includes/inc_cmdCurso.asp"--></span></td>
    </tr>
    <tr>
      <td class="texto1">Per&iacute;odo:</td>
      <%
			 	if request.Form("txtHiddenStatus") <> "" then
				   strDesabilitaSerie = "disabled"
				end if
			 %>
      <td colspan="3"><!--#include file="../includes/inc_cmdPeriodo.asp"--></td>
    </tr>
    
    <tr>
      <td class="texto1">Turno:</td>
      <td colspan="3"><!--#include file="../includes/inc_cmdTurno.asp"--></td>
    </tr>
    
    <tr>
      <td class="texto1">Turma:</td>
      <td colspan="3"><!--#include file="../includes/inc_cmdTurma.asp"--></td>
    </tr>
	<tr style="display:none">
      <td class="texto1">Disciplina:</td>
       <td colspan="2"><!--#include file="../includes/inc_cmbDisciplinaTurma.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Sexo:</td>
      <td colspan="3"><span class="texto1">
        <!--#include file="../includes/inc_cmdSexo.asp" -->
      </span></td>
    </tr>
    <tr>
      <td class="texto1">Situa&ccedil;&atilde;o do Aluno:</td>
      <td colspan="3" class="texto1"><!--#include file="../includes/inc_cmdSituacaoAluno.asp"-->
      <input type="checkbox" name="AlunoSemSituacao" value="S">&nbsp; - Somente alunos sem situação Acadêmica</td>
    </tr>
  
    <tr style="display:none">
      <td class="texto1">Forma de Ingresso: </td>
      <td colspan="3"><!--#include file="../includes/inc_cmdFormaIngresso.asp" --></td>
    </tr>
    
    <tr style="display:none">
      <td class="texto1">Estagio: </td>
      <td colspan="3"><!--#include file="../includes/inc_cmdEstagio.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Sub-T&iacute;tulo (Opcional): </td>
      <td colspan="3"><input name="txtSubTitulo" type="text" class="text" id="txtSubTitulo" size="100" maxlength="100" value="<%=strSubTitulo%>">&nbsp;</td>
    </tr>
    <tr>
      <td class="texto1">Ordem:</td>
      <td colspan="3">
	  <select name="cmbOrdem" class="Combo" id="cmbOrdem"  style="width:100pt" >
	  <option value="alfabetica" >Alfabetica</option>
	  <option value="matricula" >Matrícula</option>
	  <option value="datamatricula" >Data da Matricula</option>
	  <option value="dataafastamento" >Data de Afastamento</option>
	  <option value="idade" >Idade</option>
	  <option value="bairro" >Bairro</option>
	</select>	  </td>
    </tr>
    <tr>
      <td class="texto1">Quebra p&aacute;gina:</td>
      <td colspan="3"><select name="cmbQuebraPagina" class="Combo" id="cmbQuebraPagina"  style="width:100pt" >
        <option value="NORMAL" >Normal</option>
        <option value="TURMA" >Por Turma</option>
      </select></td>
    </tr>
    <tr>
      <td class="texto1">Linhas por P&aacute;gina: </td>
      <td colspan="3"><!--#include file="../includes/inc_cmbLinhaPorPagina.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Tamanho da Fonte:</td>
      <td colspan="3"><!--#include file="../includes/inc_cmbTamanhoFonteArial.asp"--></td>
    </tr>
 
    <% if (strOpcaoRelatorio = "2" or strOpcaoRelatorio = "7" ) and session("NivelPermissao")="A" then %>
        <tr>
          <td class="texto1">Enviar notifica&ccedil;&atilde;o via email?</td>
          <td colspan="2"><span class="texto1">
            <input type="checkbox" name="txtEnviarNotificacao" value="S" >
          - Marcando essa op&ccedil;&atilde;o, cada aluno classificado receber&aacute; em seu email a mensagem abaixo selecionada.</span></td>
        </tr>
        <tr>
          <td class="texto1">Mensagens:</td>
          <td class="texto1"><!--#include file="../includes/inc_cmbMensagensModelo.asp"--></td>
        </tr>
    <% end if %>   

    <tr>
      <td class="texto1">&nbsp;</td>
      <td colspan="3">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="4"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr>
      <td colspan="4"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->&nbsp;</td>
    </tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>
