<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>

<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 27/11/2007
	::	Data de Atualização...: 02/05/2011
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Notas
-->

<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<%
'verifica se o usuario é professor ou admnistrativo
sql = "select codigo "
sql = sql & " from SRH_COLABORADOR"
sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
sql = sql & " and codLotacao= " & Session("CodEmpresa")
sql = sql & " and CodCategoria = 1"'professor
sql = sql & " and Situacao = 'A'"'ativo
rs.open sql, cnn
if rs.eof then
	strTipoAcessoCadastroNotas = "ADM"
else
	strTipoAcessoCadastroNotas = "PROF"
	intCodColaboradorProfessor = rs("codigo")
	strExecutarSubmitDisciplinaDoProfessor = "S"
end if
rs.close
%>
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css"></head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<!--include file="../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file=../../includes/inc_aguarde.asp-->
<script>

	function AlunoFoto(codAluno){
		window.open("AlunoFoto_con.asp?codAluno="+codAluno,"consulta", "top=0,left=0,height=400,width=578,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}
	
	function cadastrarNotas(){
		
		var frm = document.getElementById("frm");
		var form = window.document.forms[0];
		var intContMarcado=0;
		var strAlunos='';
		var strEja='';
		
		if (frm.cmbSemestre.value == 0){
			alert("O Semestre deve ser informado!");
			frm.cmbSemestre.focus();
			return false;
		}
		if (frm.cmbTurma.value == 0){
			alert("A turma deve ser informada!");
			frm.cmbTurma.focus();
			return false;
		}		

		frm.action = "NotasRecalculo_cad.asp";
		frm.submit();
		return true;	
	}
</script>
<%
strPaginaTitulo = "NotasRecalculo_con.asp"
strExecutarSubmitCurso	  = "S"
strExecutarSubmitPeriodo  = "S"
strExecutarSubmitSemestre = "S"
strExecutarSubmitTurno	  = "S"
strExecutarSubmitTurma	  = "S"

strSemestre 			= session("strSemestre")
if trim(request("txtAnoLetivo")) = "" then 
	strAnoLetivo = session("strAnoLetivo")
else
	strAnoLetivo = request.Form("txtAnoLetivo")
end if

intCodCurso	 			= Trim(Request("cmbCurso"))
intCodPeriodo 			= Trim(Request("cmbPeriodo"))
intSemestre 			= Trim(Request("cmbSemestre"))
intCodGrade				= Trim(Request("cmbGrade"))
intCodDisciplinaTurma				= Trim(Request("cmbDisciplinaTurma"))
intCodTurma				= Trim(Request("cmbTurma"))
intCodTurno		 		= Trim(Request("cmbTurno"))
intCodPlanoPagamento	= Trim(Request("cmbPlanoPagamento"))
strSala		 			= Trim(Request("txtSala"))
intAno		 			= Trim(Request("txtAno"))
intAnoLetivo 			= Trim(Request("txtAnoLetivo"))
if intAnoLetivo = "" then intAnoLetivo = strAnoLetivo
intCodTipoLancamento    = trim(request("cmbTipoLancamento"))


strAtivos               = trim(request("cmbativos"))

strFiltroSerie = "0"
strFiltroTurno = "0"

if intCodComp = "" then intCodComp = "0"
if intCodSerie = "" then intCodSerie = "0"
if intCodTurno = "" then intCodTurno = "0"
if intCodTurma = "" then intCodTurma = "0"
if intCodSemestre = "" then intCodSemestre = "0"
if intCodTipoLancamento = "" then intCodTipoLancamento = "0"
if intCodDisciplinaTurma = "" then intCodDisciplinaTurma = "0"

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
'controla os botões
strDesabilitaIncluir = "disabled"
strDesabilitaExcluir = "disabled"
strDesabilitaAlterar = ""
strDesabilitaLimpar = ""
%>
<form method="post" id="frm" action="NotasRecalculo_con.asp">
<input  name="cmbCurso" type="hidden" id="cmbCurso" value="<%=intCodCurso%>">
<input  name="cmbPeriodo" type="hidden" id="cmbPeriodo" value="<%=intCodPeriodo%>">

<table width="100%" border="0" cellpadding="0" bgcolor="#FFFFFF" cellspacing="0">
<tr valign="top">
<td  align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
</tr>
</table>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="2" bgcolor="#FFFFFF">
<tr>
    <td width="12%" class="texto1">Ano Letivo:</td>
    <td width="88%" colspan="2"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
</tr>
<tr>
    <td class="texto1">Semestre:</td>
    <td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
</tr>
<tr> 
    <td class="texto1">Turma: </td>
    <td colspan="2"><!--#include file="../includes/inc_cmdTurma.asp"--></td>
</tr>
<tr>
  <td class="texto1">Disciplina Turma: </td>
  <td colspan="2"><!--#include file="../includes/inc_cmbDisciplinaRecalculo.asp"--></td>
</tr>
<tr>
  <td class="texto1">Situa&ccedil;&otilde;es:</td>
  <td colspan="2"><!--#include file="../includes/inc_cmbAtivos.asp"--></td>
</tr>
<tr> 
  <td colspan="3" class="texto1">&nbsp;</td>
</tr>
<tr align="center"> 
  <td colspan="3" class="texto1"></td>
</tr>
     <tr> 
     <td colspan="3"><hr size="1" color="#CCCCCC"></td>
     </tr>
     <tr> 
     <td colspan="3"><input type="button" name="cmdCadastrar" value="Recalcular Médias" class="botao" onClick="return cadastrarNotas()"> 
     <input type="button" name="cmdLimpar"  value="Limpar"  class="botao" <%=strDesabilitaLimpar%>  onClick="window.location='notasNovo_con.asp'"> 
     <input class="botao" type="button" value="Principal" name="BtnFechar" onClick="window.navigate('default.asp')">      
     <br>
<br>
</td>
     </tr>

   </table>
</form>
<!--#include file="../rodape.asp"-->
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
