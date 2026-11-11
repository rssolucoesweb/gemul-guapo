<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Vestibular
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
	function resultadoConsulta(intCodigo){
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function salvar(acao){
		
		if (frm.cmbTipoProcesso.value == "0") {
			alert("O Tipo do Processo deve ser informado !");
			frm.cmbTipoProcesso.focus();
			return false;
		}
		
		if (frm.txtAnoLetivo.value == "") {
			alert("Ano letivo deve ser informado !");
			frm.txtAnoLetivo.focus();
			return false;
		}
		
		if (frm.cmbSemestre.value == "0") {
			alert("O Semestre deve ser informado !");
			frm.cmbSemestre.focus();
			return false;
		}
	
		if (frm.cmbVestibularDisciplina.value == "0") {
			alert("A Disciplina do Processo Seletivo deve ser informada!");
			frm.cmbVestibularDisciplina.focus();
			return false;
		}
		
		if (frm.txtDescricao.value == "") {
			alert("A Descrição deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
	
		if (frm.txtHorario.value == "") {
			alert("O Horario deve ser informado !");
			frm.txtHorario.focus();
			return false;
		}
		
		if (frm.txtCampus.value == "") {
			alert("O Campus deve ser informado !");
			frm.txtCampus.focus();
			return false;
		}
		
		if (frm.txtNumeroVaga.value == "") {
			alert("O Numero de vaga deve ser informado !");
			frm.txtNumeroVaga.focus();
			return false;
		}		

		if ((frm.optSituacao[0].checked == false) && (frm.optSituacao[1].checked == false)) {
			alert("Situação deve ser informada!");
			frm.optSituacao[0].focus();
			return false;
		} 
				
		if (frm.txtCampus.value == "") {
			alert("O Campus deve ser informado !");
			frm.txtCampus.focus();
			return false;
		}
			
		if (frm.txtDataVencimento.value == "") {
			alert("O Vencimento deve ser informado !");
			frm.txtDataVencimento.focus();
			return false;
		}	
		
		frm.action="Vestibular_cod.asp?acao=" + acao;
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
	strPaginaTitulo				 = "vestibular_cad.asp"
    strExecutarSubmitSemestre    = "S"
    strSimouNao_submit           = "N"
	
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")
	
	intCodigo					= Trim(Request("txtCodigo"))
	intTipoProcesso				= Trim(Request("cmbTipoProcesso"))
	strDescricao				= Trim(Request("txtDescricao"))
	strData						= Trim(Request("txtData"))
	strHorario					= Trim(Request("txtHorario"))
	strCampus					= Trim(Request("txtCampus"))
	strSituacao					= Trim(Request("optSituacao"))
	intCodVestibularDisciplina	= Trim(Request("cmbVestibularDisciplina"))
	strValorVestibular          = Trim(Request("txtValorVestibular"))
	strDataVencimento			= Trim(Request("txtDataVencimento"))
	strSimouNao         		= Trim(Request.Form("cmbSimouNao"))
	intNumeroVaga				= Trim(Request.Form("txtNumeroVaga"))	
	         
	if strSituacao = "" then strSituacao = "A"
	

	if trim(intCodigo) <> "" then
	
		sql = "SELECT Cod_empresa, Ano_letivo, Semestre, CodVestibularDisciplina, Codigo, TipoProcesso, Descricao, "
		sql = sql & " Data, Horario, Campus, situacao, Valor_Vestibular, DataVencimento, PublicarWeb, NumeroVaga"
		sql = sql & " FROM SCA_VESTIBULAR"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " and cod_empresa = " & Session("CodEmpresa")	
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo 							= rs("Codigo")
			intTipoProcesso						= rs("TipoProcesso")
			strDescricao 						= rs("Descricao")
			strData		 						= FORMATADATAAP(rs("Data"))
			strDataVencimento					= FORMATADATAAP(rs("DataVencimento"))
			strHorario	 						= rs("Horario")
			strCampus 							= rs("Campus")
			strSituacao							= rs("situacao")
		    strSimouNao                         = rs("PublicarWeb")
			strAnoLetivo 						= Trim(rs("Ano_Letivo"))
			intSemestre 						= Trim(rs("Semestre"))
			intCodVestibularDisciplina 			= Trim(rs("CodVestibularDisciplina"))
			strValorVestibular                  = Trim(rs("Valor_Vestibular"))
			intNumeroVaga						= Trim(rs("NumeroVaga"))
			
			strValorVestibular = formatNumber(strValorVestibular,2)
	
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir

		end if 
		rs.close
	
	else
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 

%>

  <table width="100%" align="center" class="CorFundo" >
    <tr>
      <td height="85" align="center">
      <form method="post" id="frm" action="#">
      <table width="95%" border="0" align="center" cellspacing="0" cellpadding="0">
        <tr valign="top">
          <td colspan="2" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
        </tr>
        <tr>
          <td width="185">&nbsp;</td>
          <td width="737"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
        </tr>
        <tr>
          <td height="15" class="texto1">Tipo:</td>
          <td colspan="2"><select name="cmbTipoProcesso" id="cmbTipoProcesso" style="width:100pt" class="combo">
              <option value="0">Selecione...</option>
              <option value="1" <%if intTipoProcesso = "1" then response.Write("selected") %>>Processo Seletivo</option>
              <option value="2" <%if intTipoProcesso = "2" then response.Write("selected") %>>Atividade</option>
          </select></td>
        </tr>
        <tr>
          <td class="texto1">Ano Letivo:</td>
          <td colspan="2"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
        </tr>
        <tr>
          <td class="texto1">Semestre:</td>
          <td colspan="2"><!--#include file="../includes/inc_cmdSemestreTodos.asp" --></td>
        </tr>
        <tr>
          <td height="28"><span class="texto1">Disciplina do Evento:</span></td>
          <td><!--#include file="../includes/inc_VestibularDisciplina.asp" --></td>
        </tr>
        <tr>
          <td height="28"><span class="texto1">Descri&ccedil;&atilde;o: </span></td>
          <td><input name="txtDescricao" type="text" class="text" id="txtDescricao" size="50" maxlength="70" value="<%=strDescricao%>" /></td>
        </tr>
        <tr>
          <td height="20"><span class="texto1">Data de in&iacute;cio: </span></td>
          <td><span class="texto1">
            <input name="txtData" type="text" class="text" id="txtData" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strData%>">
          </span></td>
        </tr>
        <tr>
          <td height="20"><span class="texto1">Horario:</span></td>
          <td><span class="texto1">
            <input name="txtHorario" type="text" class="text" id="txtHorario" size="11" maxlength="20" value="<%=strHorario%>">
          </span></td>
        </tr>
        <tr>
          <td height="20"><span class="texto1">Local - Campus: </span></td>
          <td><input name="txtCampus" type="text" class="text" id="txtCampus" size="50" maxlength="70" value="<%=strCampus%>" /></td>
        </tr>
        <tr>
          <td height="20"><span class="texto1">Valor: </span></td>
          <td class="TextoForm"><input name="txtValorVestibular" type="text" class="text" id="txtValorVestibular"  onKeyPress="return currencyFormat(this,event)" size="11" maxlength="10" value="<%=strValorVestibular%>">
        <tr>
                <td height="20"><span class="texto1">Vencimento Boleto: </span></td>
                <td><span class="texto1">
                  <input name="txtDataVencimento" type="text" class="text" id="txtDataVencimento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataVencimento%>">
                </span></td>
        </tr>
              <tr>
                <td><span class="texto1">N&uacute;mero Vaga: </span></td>
                <td class="TextoForm"><input  name="txtNumeroVaga" type="text" class="text" id="txtNumeroVaga" onBlur="submit()"  value="<%=intNumeroVaga%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
              </tr>
              <tr>
                <td><span class="texto1">Publicar Evento na Web? </span></td>
                <td class="TextoForm"><!--#include file="../includes/inc_cmbSimouNao.asp"--></td>
              </tr>
              <tr>
                <td><span class="texto1">Situa&ccedil;&atilde;o: </span></td>
                <td class="TextoForm"><input name="optSituacao" type="radio" value="A" <%if strSituacao ="A" then response.Write("checked")%>>
                  Ativo 
                  &nbsp;&nbsp;
                    <input type="radio" name="optSituacao" value="I"  <%if strSituacao ="I" then response.Write("checked")%>>
                  Inativo</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
              </tr>
              <tr>
                <td colspan="2">&nbsp;</td>
              </tr>
              <tr>
                <td colspan="2"><%
			cont =0
			
			sql = "SELECT cod_empresa, Codigo, TipoProcesso, Descricao, Data, Horario, Campus"
			sql = sql & " FROM SCA_VESTIBULAR"
			sql = sql & " Where cod_empresa = " & Session("CodEmpresa")	
			sql = sql & " And ano_letivo = " & strAnoLetivo
			sql = sql & " Order by Codigo desc"
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
                    <table width = "99%" border="1" align="left" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                      <tr bgcolor="#E5E5E5">
                        <td width="17%" class="celula"><strong>C&oacute;digo</strong></td>
                        <td width="22%" class="celula"><strong>Tipo</strong></td>
                        <td width="47%" class="celula"><strong>Descri&ccedil;&atilde;o</strong></td>
                        <td width="14%" height="21" class="celula"><strong>Data<span class="TextoForm"></span></strong></td>
                      </tr>
                      <%
				while not rs.eof
					cont = cont + 1	
					
					if trim(rs("TipoProcesso")) = 1 then
						strTipoProcesso = "Processo Seletivo"
					else
						strTipoProcesso = "Atividade"
					end if
					
					%>
                      <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
                        <td class="celula"><%=trim(rs("Codigo"))%></td>
                        <td class="celula"><%=strTipoProcesso%></td>
                        <td class="celula"><%=trim(rs("Descricao"))%></td>
                        <td height="20" class="celula"><%=trim(FORMATADATAAP(rs("Data")))%></td>
                      </tr>
                      <%				
					rs.movenext
					wend
				  %>
                      <tr>
                        <td height="21" colspan="4" class="celula">Total Registros : <%=cont%></td>
                  </table>
                  <%
			end if
			rs.close%></td>
              </tr>
      </table>
      </form>
      
      <br></td>
    </tr>
  </table>

<!--#include file="../rodape.asp"-->
</body>
</html>
