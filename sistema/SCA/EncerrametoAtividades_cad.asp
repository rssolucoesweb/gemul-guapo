<!--
	::	DESENVOLVIDO POR..: RS SOLUÇÕES WEB - www.rssolucoesweb.com.br
	::	Data de Criação...: 09/12/2008
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Configurações gerais
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../js/Calendario/Calendario.asp"-->
<script>
	function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtAno.value == "") {
			alert("O Ano letivo deve ser informado!");
			frm.txtAno.focus();
			return false;
		}
		
		if (frm.cmbSemestre.value == "0") {
			alert("O Semestre deve ser informado!");
			frm.cmbSemestre.focus();
			return false;
		}
		
		if (frm.txtDataEncerramento.value == "") {
			alert("A Data de Encerramento deve ser informada!");
			frm.txtDataEncerramento.focus();
			return false;
		}
		
		frm.action="EncerrametoAtividades_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%
	strPaginaTitulo 					= "EncerrametoAtividades_cad.asp"
	intCodigo	 						= Trim(Request.Form("txtCodigo"))
    strReplicar   						= Trim(Request.Form("cmbReplicar"))
	intAno								= Trim(Request.Form("txtAno"))
	intSemestre							= Trim(Request.Form("cmbSemestre"))
	strDataEncerramento					= Trim(Request.Form("txtDataEncerramento"))
	strSimouNaoDocente					= Trim(Request.Form("cmbSimouNaoDocente"))
	intCodAvaliacaoAgrupamento			= Trim(Request.Form("cmbTipoAvaliacaoAgrupamento"))
    strSimouNaoSecretaria    			= Trim(Request.Form("cmbSimouNaoSecretaria"))
    strSimouNaoCampoAcumuladaFalta 		= Trim(Request.Form("cmbSimouNaoCampoAcumuladaFalta"))
    strSimouNaoDocumentacaoColaboradores= Trim(Request.Form("cmbSimouNaoDocumentacaoColaboradores"))
    strSimouNaoHabilitaPlanoEnsino      = Trim(Request.Form("cmbSimouNaoHabilitaPlanoEnsino"))
    strSimouNaoPreMatricula      		= Trim(Request.Form("cmbSimouNaoPreMatricula"))
    strSimouNaoDocumentos 				= Trim(Request.Form("cmbSimouNaoDocumentos"))
    strSimouNaoBiblioteca 				= Trim(Request.Form("cmbSimouNaoBiblioteca"))
    strCriarGradeChecandoHistorico 		= Trim(Request.Form("cmbCriarGradeChecandoHistorico"))
	strNotificacao1						= Trim(Request.Form("txtNotificacao1"))
	strNotificacao2						= Trim(Request.Form("txtNotificacao2"))
	strMes								= Trim(Request("cmbMes"))

    strGestorMaster = ""
    strGestorSuporte  = ""
    strGestorManutencao = ""
	sql = "select ISNULL(USUARIO_MASTER,'N') as USUARIO_MASTER, "
	sql = sql & " ISNULL(GESTOR_SUPORTE,'N') as GESTOR_SUPORTE, "
	sql = sql & " ISNULL(GESTOR_MANUTENCAO,'N') as GESTOR_MANUTENCAO "
	sql = sql & " From SEG_USUARIOS_SISTEMA"
	sql = sql & " where Usua_Codg = '"& Trim(session("UsuarioWeb")) & "'"
	rs.open sql, cnn
	if rs.eof = false then
	   strGestorMaster = trim(rs("USUARIO_MASTER"))
	   strGestorSuporte = trim(rs("GESTOR_SUPORTE"))
	   strGestorManutencao = trim(rs("GESTOR_MANUTENCAO"))
	end if
	rs.close


	if strMes = "0" then strMes = month(date) 
		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, cod_empresa, ano_letivo, semestre, data_encerramento, Bloqueia_NotasDocente, Permitir_AlteracaoNotaDocente, "
		sql = sql & " Bloqueia_NotasSecretaria, Bloqueia_CampoAcumuladaFalta, Bloqueia_ConteudoProgramatico, Habilitar_PlanoEnsino, Habilitar_PreMatricula, "
		sql = sql & " NC_Matricula_Documentacoes, NC_Matricula_Biblioteca, DocumentacaoColaboradores, notificacao1, notificacao2, CriarGrade_ChecandoHistorico"
		sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES"
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
		sql = sql & " and codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo							= rs("Codigo")
			intAno								= rs("ano_letivo")
			intSemestre							= rs("semestre")
			strDataEncerramento					= formataDataAP(rs("data_encerramento"))
			strSimouNaoDocente					= rs("Bloqueia_NotasDocente")
			intCodAvaliacaoAgrupamento			= rs("Permitir_AlteracaoNotaDocente")
			
			strSimouNaoSecretaria				= rs("Bloqueia_NotasSecretaria")
			strSimouNaoCampoAcumuladaFalta		= rs("Bloqueia_CampoAcumuladaFalta")
			strSimouNaoHabilitaPlanoEnsino      = rs("Habilitar_PlanoEnsino")
			
			if Trim(Request.Form("cmbSimouNaoPreMatricula")) = "0" then
				strSimouNaoPreMatricula     		= rs("Habilitar_PreMatricula")
			end if
			
			strSimouNaoDocumentos	     		= rs("NC_Matricula_Documentacoes")
			strSimouNaoBiblioteca     			= rs("NC_Matricula_Biblioteca")
			strSimouNaoDocumentacaoColaboradores= rs("DocumentacaoColaboradores")
			strNotificacao1						= rs("Notificacao1")
			strNotificacao2						= rs("Notificacao2")
			strMes								= rs("Bloqueia_ConteudoProgramatico")
			strCriarGradeChecandoHistorico		= rs("CriarGrade_ChecandoHistorico")
			
			if isnull(strMes) then strMes = "0"
			
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

		end if 
		rs.close
		
	else
	    if session("nivelpermissao")= "A" then
		   strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		else   
		   strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
		end if   
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="1259"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td width="1259" colspan="2" align="center">
		<form id="frm" method="post">
		  <table width="708" border="0" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
		  <table width="1255" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="texto1">&nbsp;</td>
            <td><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
          </tr>
          <tr bgcolor="#E5E5E5">
            <td height="19" colspan="2" class="texto1"><strong>Fechamento do semestre ou ano letivo</strong></td>
            </tr>
           <% if strGestorMaster = "S" or strGestorSuporte = "S" or strGestorManutencao = "S" then %>

              <tr>
                <td height="22" class="texto1">Replicar configura&ccedil;&otilde;es em todas unidades do grupo:</td>
                <td><select name="cmbReplicar" class="combo" id="cmbReplicar"  style="width:70pt" onchange='' >
                  <option value="N" <%if strReplicar = "N" then response.Write("selected") %>>NAO</option>
                  <option value="S" <%if strReplicar = "S" then response.Write("selected") %>>SIM</option>
                </select></td>
              </tr>
          <% end if %>    
          
          <tr>
            <td height="22" class="texto1"><span class="TextoForm">Ano: </span></td>
            <td><input name="txtAno" type="text" class="text" id="txtAno"  value="<%=intAno%>" size="5" maxlength="4" onKeyPress="return formataCampo(this,2,4)"> 
              - </td>
          </tr>
          <tr>
            <td height="19" class="texto1"><span class="TextoForm">Semestre:</span> </td>
            <td><!--#include file="../includes/inc_cmdSemestreTodos.asp" --></td>
          </tr>
          <tr>
            <td class="texto1"><span class="TextoForm">Data de Encerramento: </span></td>
            <td><span class="texto1">
              <input name="txtDataEncerramento" type="text" class="text" id="txtDataEncerramento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataEncerramento%>" style="cursor:hand" title="Click aqui para visualizar o calend&aacute;rio">
            </span></td>
          </tr>
          <tr>
            <td colspan="2" class="texto1">&nbsp;</td>
          </tr>
          <tr bgcolor="#E5E5E5">
            <td colspan="2" class="texto1"><strong>Controlando Atividades</strong></td>
            </tr>
          <tr>
            <td class="texto1"><span class="TextoForm">Bloquear Lancto Notas Docentes? </span></td>
            <td><select name="cmbSimouNaoDocente" class="combo" id="cmbSimouNaoDocente"  style="width:70pt" onchange='' >
              <option value="0">Selecione...</option>
              <option value="S" <%if strSimouNaoDocente = "S" then response.Write("selected") %>>SIM</option>
              <option value="N" <%if strSimouNaoDocente = "N" then response.Write("selected") %>>NAO</option>
            </select></td>
          </tr>
          <tr>
            <td class="texto1">Permitir altera&ccedil;&atilde;o Notas ao Docentes?</td>
            <td><!--#include file="../includes/inc_cmdTipoAvaliacaoAgrupamentoDigitacao.asp" --></td>
          </tr>
          <tr>
            <td width="420" class="texto1"><span class="TextoForm">Bloquear Lancto Notas Secretaria? </span></td>
            <td width="835"><select name="cmbSimouNaoSecretaria" class="combo" id="cmbSimouNaoSecretaria"  style="width:70pt" onchange='' >
              <option value="0">Selecione...</option>
              <option value="S" <%if strSimouNaoSecretaria = "S" then response.Write("selected") %>>SIM</option>
              <option value="N" <%if strSimouNaoSecretaria = "N" then response.Write("selected") %>>NAO</option>
            </select></td>
          </tr>
          <tr>
            <td><span class="TextoForm">Bloquear Campo Acumulada de Faltas? </span></td>
            <td><select name="cmbSimouNaoCampoAcumuladaFalta" class="combo" id="cmbSimouNaoCampoAcumuladaFalta"  style="width:70pt" onChange='' >
              <option value="0">Selecione...</option>
              <option value="S" <%if strSimouNaoCampoAcumuladaFalta = "S" then response.Write("selected") %>>SIM</option>
              <option value="N" <%if strSimouNaoCampoAcumuladaFalta = "N" then response.Write("selected") %>>NAO</option>
            </select></td>
          </tr>
          <tr>
            <td class="texto1"><span class="TextoForm">Bloquear Conte&uacute;do Program&aacute;tico at&eacute; o m&ecirc;s: </span> </td>
            <td><!--#include file="../includes/inc_cmbMesConteudo.asp"--></td>
          </tr>
          <tr>
            <td class="TextoForm">Habilitar Plano de Ensino?</td>
            <td><select name="cmbSimouNaoHabilitaPlanoEnsino" class="combo" id="cmbSimouNaoHabilitaPlanoEnsino"  style="width:70pt" onChange='' >
              <option value="0">Selecione...</option>
              <option value="S" <%if strSimouNaoHabilitaPlanoEnsino = "S" then response.Write("selected") %>>SIM</option>
              <option value="N" <%if strSimouNaoHabilitaPlanoEnsino = "N" then response.Write("selected") %>>NAO</option>
            </select></td>
          </tr>
          <tr>
            <td class="texto1"><span class="TextoForm">Habilitar Pr&eacute;-Matr&iacute;cula no Portal do Aluno? </span></td>
            <td><select name="cmbSimouNaoPreMatricula" class="combo" id="cmbSimouNaoPreMatricula"  style="width:70pt" onChange='submit()' >
              <option value="0">Selecione...</option>
              <option value="S" <%if strSimouNaoPreMatricula = "S" then response.Write("selected") %>>SIM</option>
              <option value="N" <%if strSimouNaoPreMatricula = "N" then response.Write("selected") %>>NAO</option>
            </select></td>
          </tr>
          <% if strSimouNaoPreMatricula = "S" then %>
              <tr>
                <td class="texto1">Checar Documenta&ccedil;&otilde;es Pessoais na Pr&eacute;-Matr&iacute;cula?</td>
                <td><select name="cmbSimouNaoDocumentos" class="combo" id="cmbSimouNaoDocumentos"  style="width:70pt" onChange='' >
                  <option value="0">Selecione...</option>
                  <option value="S" <%if strSimouNaoDocumentos = "S" then response.Write("selected") %>>SIM</option>
                  <option value="N" <%if cmbSimouNaoDocumentos = "N" then response.Write("selected") %>>NAO</option>
                </select></td>
              </tr>
              <tr>
                <td class="texto1">Checar Empr&eacute;stimo da Biblioteca na Pr&eacute;-Matr&iacute;cula?</td>
                <td><select name="cmbSimouNaoBiblioteca" class="combo" id="cmbSimouNaoBiblioteca"  style="width:70pt" onChange='' >
                  <option value="0">Selecione...</option>
                  <option value="S" <%if strSimouNaoBiblioteca = "S" then response.Write("selected") %>>SIM</option>
                  <option value="N" <%if strSimouNaoBiblioteca = "N" then response.Write("selected") %>>NAO</option>
                </select></td>
              </tr>
          <% end if %>    
          <tr>
            <td class="texto1">Criar ou Atualizar Matriz Curricular checando o Hist&oacute;rico?</td>
            <td><select name="cmbCriarGradeChecandoHistorico" class="combo" id="cmbCriarGradeChecandoHistorico"  style="width:70pt" onChange='' >
              <option value="0">Selecione...</option>
              <option value="S" <%if strCriarGradeChecandoHistorico = "S" then response.Write("selected") %>>SIM</option>
              <option value="N" <%if strCriarGradeChecandoHistorico = "N" then response.Write("selected") %>>NAO</option>
            </select></td>
          </tr>
          <tr>
            <td class="texto1"><span class="TextoForm">Controlar Documenta&ccedil;&atilde;o de Colaboradores pelo Grau de Instru&ccedil;&atilde;o?</span> </td>
            <td><select name="cmbSimouNaoDocumentacaoColaboradores" class="combo" id="cmbSimouNaoDocumentacaoColaboradores"  style="width:70pt" onChange='' >
              <option value="0">Selecione...</option>
              <option value="S" <%if strSimouNaoDocumentacaoColaboradores = "S" then response.Write("selected") %>>SIM</option>
              <option value="N" <%if strSimouNaoDocumentacaoColaboradores = "N" then response.Write("selected") %>>NAO</option>
            </select></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr bgcolor="#E5E5E5">
            <td colspan="2"><div align="center"><span class="TextoForm">Quadro de Avisos  ( at&eacute; 800 caracteres por linha ) </span></div></td>
          </tr>
          <tr>
            <td colspan="2"><div align="center">
                <span class="TextoForm">
                    01.
                    <textarea name="txtNotificacao1" cols="120" rows="5" class="text" id="txtNotificacao1"><%=strNotificacao1%></textarea>
                  </span></div></td>
          </tr>
          <tr>
            <td colspan="2"><div align="center"><span class="TextoForm">
              02.
                    <textarea name="txtNotificacao2" cols="120" rows="6" class="text" id="txtNotificacao2"><%=strNotificacao2%></textarea>
            </span></div></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"> <!--#include file="../../includes/inc_botoes_cadastro.asp"--> </td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><%
			cont =0
			
			sql = "SELECT Codigo, cod_empresa, ano_letivo, semestre, data_encerramento"
			sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES"
			sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
			sql = sql & " Order by codigo"
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
                <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="12%" align="center" class="celula"><strong><span class="TextoForm">Ano</span></strong></td>
                    <td width="9%" align="center" class="celula"><strong><span class="TextoForm">Semestre</span></strong></td>
                    <td width="79%" height="21" class="celula"><strong><span class="TextoForm">Data de Encerramento</span></strong></td>
                  </tr>
                  <%
				while not rs.eof
					cont = cont + 1	
					%>
                  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
                    <td align="center" class="celula"><%=rs("ano_letivo")%></td>
                    <td align="center" class="celula"><%=rs("semestre")%></td>
                    <td height="20" class="celula"><%=formataDataAP(trim(rs("data_encerramento")))%></td>
                  </tr>
                  <%				
					rs.movenext
					wend
				  %>
                  <tr>
                    <td height="21" colspan="3" class="celula">Total Registros : <%=cont%></td>
                  </table>
              <%
			  end if
			  rs.close%></td>
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