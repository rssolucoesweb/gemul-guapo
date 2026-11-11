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

		if (window.confirm("Confirma a replicação de todas as grades e turmas do ano de " + frm.txtAnoLetivo.value + " para o ano de " + frm.txtAnoLetivoReplicacao.value + "?")) {
			frm.action="promoverTurmaGrade_cod.asp?acao="+acao;
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
	
	strAnoLetivo = session("strAnoLetivo")
	if request.form("txtAnoLetivo")<>"" then strAnoLetivo = request.form("txtAnoLetivo")
	intSemestre = "3"
	strAnoLetivoReplicacao = strAnoLetivo + 1
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
        <input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" value="<%=strAnoLetivo%>" size="5" maxlength="5" onblur="submit()" onKeyPress="return formataCampo(this,2,10)">
      </span></td>
    </tr>
    <tr>
      <td class="texto1">Semestre Atual:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
    </tr>
	<tr>
      <td width="17%" class="texto1">Ano Letivo Replicação:</td>
      <td width="83%" colspan="2"><span class="texto1">
        <input  name="txtAnoLetivoReplicacao" type="text" class="text" id="txtAnoLetivoReplicacao" value="<%=strAnoLetivoReplicacao%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
      </span></td>
    </tr>
    <tr>
      <td class="texto1">Unidade:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmbEmpresaGrupo.asp" --></td>
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
			cont =0
			sql = "SELECT h.id_aut_grade_turma_historico, h.ano_atual, h.ano_promocao, e.razaosocial as unidade, h.usuario_incl, h.data_hora_incl, h.situacao"
			sql = sql & " FROM MAT_aut_grade_turma_historico h "
			sql = sql & " left join seg_empresa e on e.codigo = h.cod_empresa "
			sql = sql & " where h.ano_atual = " & strAnoLetivo
			sql = sql & " Order by h.data_hora_incl desc"
			rs.open sql, cnn

			if rs.eof = false then
			%>
                <table width = "80%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td height="25" colspan="7" align="center" class="celula"><strong>Lista de Replicações - <%=strAnoLetivo%></strong></td>
                  </tr>
				  <tr bgcolor="#E5E5E5">
                    <td width="10%" align="center" class="celula"><strong>Ano Atual</strong></td>
                    <td width="10%" align="center" class="celula"><strong>Ano Replicação</strong></td>
					 <td width="20%" align="center" class="celula"><strong>Unidade</strong></td>
                    <td width="20%" align="center" class="celula"><strong>Usuário</strong></td>
                    <td width="15%" align="center" class="celula"><strong>Data</strong></td>
					<td width="10%" align="center" class="celula"><strong>Situação</strong></td>
					<td width="3%" align="center" class="celula"><strong>Cancelar</strong></td>
                  </tr>
                  <%
				while not rs.eof
					cont = cont + 1	
					situacao = ""
					if rs("situacao") = "A" then situacao = "Processada"
					if rs("situacao") = "C" then situacao = "<font color='red'>Cancelada</font>"
					if rs("situacao") = "N" then situacao = "<font color='red'>Não processado</font>"
					unidade = rs("unidade")
					if rs("unidade") = "0" or rs("unidade") = "" or isnull(rs("unidade")) then unidade = "<STRONG>TODAS UNIDADES</STRONG>"
					%>
                  <tr>
                    <td height="20" class="celula"><%=trim(rs("ano_atual"))%></td>
					<td height="20" class="celula"><%=trim(rs("ano_promocao"))%></td>
					<td height="20" class="celula"><%=trim(unidade)%></td>
					<td height="20" class="celula"><%=trim(rs("usuario_incl"))%></td>
					<td height="20" class="celula"><%=trim(rs("data_hora_incl"))%></td>
					<td height="20" class="celula"><strong><%=trim(situacao)%></strong></td>
                    <td style="cursor: pointer" height="26" align="center" class="celula" <%if rs("situacao")="A" then%> onClick="return cancelarReplicacao('<%=rs("id_aut_grade_turma_historico")%>','<%=rs("ano_atual")%>','<%=rs("ano_promocao")%>')" <%end if%>><%if rs("situacao")="A" then%><img src="../../../images/botao_vermelho_normal.gif" width="26" height="26"><%else%>&nbsp;<%end if%></td>
                  </tr>
                  <%				
					rs.movenext
					wend
				  %>
                  </table>
              <%
			  end if
			  rs.close%>
		  
		  </td>
		</tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>