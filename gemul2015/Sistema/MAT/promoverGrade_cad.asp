<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<script>
	function salvar(acao){
				
		var frm = document.getElementById("frm");
		if (frm.txtAnoLetivo.value == "") {
			alert("Informe o ano letivo atual!");
			frm.txtAnoLetivo.focus();
			return false;
		}
		
		if (frm.txtAnoLetivoReplicacao.value == "") {
			alert("Informe o ano letivo para a replicação!");
			frm.txtAnoLetivoReplicacao.focus();
			return false;
		}

		if (window.confirm("Confirma a replicação de todas as matriz do ano de " + frm.txtAnoLetivo.value + " para o ano de " + frm.txtAnoLetivoReplicacao.value + "?")) {
			frm.action="promoverGrade_cod.asp?acao="+acao;
			frm.submit();
			return true;
		}
		
 	}
	function cancelarReplicacao(id, ano, ano_replicacao){
		var frm = document.getElementById("frm");

		if (window.confirm("ATENÇÃO: Esse procedimento só poderá ser executado se não houver nenhuma movimentação no registro de grade e turma.\nConfirma o CANCELAMENTO de toda a replicação de todas as grades e turmas do ano de " + ano + " para o ano de " + ano_replicacao + "?")) {
			frm.action="promoverTurmaGrade_cod.asp?acao=E&id="+id;
			frm.submit();
			return true;
		}
		
 	}
</script>
<%
	strPaginaTitulo = "promoverTurmaGrade_cad.asp"

	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	strAnoLetivo = request.form("txtAnoLetivo")
	if strAnoLetivo = "" then strAnoLetivo = session("strAnoLetivo")
	intSemestre = "3"

	strAnoLetivoReplicacao = request.form("txtAnoLetivoReplicacao")
	if strAnoLetivoReplicacao = "" then strAnoLetivoReplicacao = strAnoLetivo + 1

%>
<form method="post" id="frm" action="#">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
		<tr valign="top">
		  <td align="center">
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
    <tr>
      <td width="17%" class="texto1">Ano Letivo Atual:</td>
      <td width="83%" colspan="2"><span class="texto1">
        <input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)" onblur="submit()">
      </span></td>
    </tr>
    <tr>
      <td class="texto1">Semestre Atual:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
    </tr>
	<tr>
      <td width="17%" class="texto1">Ano Letivo Replicação:</td>
      <td width="83%" colspan="2"><span class="texto1">
        <input  name="txtAnoLetivoReplicacao" type="text" class="text" id="txtAnoLetivoReplicacao" value="<%=strAnoLetivoReplicacao%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)" onblur="submit()">
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
  </table>
  <br>
  		  
		  <%
		  if strAnoLetivoReplicacao <> "" then
			cont =0
			sql = "select top 1 Cod_GradeCurricular from SCA_GRADECURRICULAR where AnoReferencia = " & strAnoLetivoReplicacao
			rs.open sql, cnn

			if rs.eof = false then
			%>
                <table width = "80%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td height="60" align="center" class="celula"><strong>Matriz <%=strAnoLetivoReplicacao%> criada</strong></td>
                  </tr>
                </table>
			<%
			end if
			rs.close
			  
		 end if%>
		  
		  </td>
		</tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>