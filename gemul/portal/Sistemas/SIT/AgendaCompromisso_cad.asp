<%strNomeDaPaginaPortal = "Agendamento de Compromisso"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>

<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>
	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		
		frm.txtCodigo.value=intCodigo
		frm.submit();
	}
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtDescricao.value == "") {
			alert("A Descrição do Evento deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		if (frm.cmbTipoEvento.value == "0") {
			alert("O Tipo do Evento deve ser informado !");
			frm.cmbTipoEvento.focus();
			return false;
		}
		
		if (frm.txtLocal.value == "") {
			alert("O Local deve ser informado !");
			frm.txtLocal.focus();
			return false;
		}
		
		if (frm.txtData.value == "") {
			alert("A Data do Evento deve ser informada !");
			frm.txtData.focus();
			return false;
		}
		if (frm.txtHora.value == "") {
			alert("A Hora do Evento deve ser informada !");
			frm.txtHora.focus();
			return false;
		}
		
		frm.action="AgendaCompromisso_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%  
	
	intCodEmpresa		= session("codEmpresa")
	intCodigo	 		= Trim(Request("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strLocal	 		= Trim(Request.Form("txtLocal"))
	intcodTipoEvento	= Trim(Request.Form("cmbTipoEvento"))
	strData		 		= Trim(Request.Form("txtData"))
	
	if strData = "" then strData = formatadataAP(date)
	strHora		 		= Trim(Request.Form("txtHora"))

	strDataFim		 	= Trim(Request.Form("txtDataFim"))
	if strDataFim = "" then strDataFim = formatadataAP(date)
	strHoraFim		 	= Trim(Request.Form("txtHoraFim"))

	strObs 				= Trim(Request.Form("txtObs"))
	strSituacao 		= Trim(Request.Form("cmbSituacao"))
	 		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT  * "
		sql = sql & " FROM SIT_AgendaCompromisso"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And CodEmpresa = " & intCodEmpresa
		rs.open sql, cnn
		
		if rs.eof = false then
			
			strDescricao		= rs("Descricao")
			intCodigo	 		= Trim(Rs("Codigo"))
			strDescricao 		= Trim(Rs("Descricao"))
			strLocal 			= Trim(Rs("LocalCompromisso"))
			intcodTipoEvento	= Trim(Rs("codTipoEvento"))
			strData		 		= formataDataAP(Trim(Rs("dataInicio")))
			strHora 			= hour(rs("dataInicio"))
			strMinuto 			= minute(rs("dataInicio"))
			
			if len(strHora)<2 then strHora="0" & strHora
			if len(strMinuto)<2 then strMinuto="0" & strMinuto
			strHora 			= strHora & ":" & strMinuto
			
			if not isnull(Rs("DataFim")) then
			
				strDataFim		= formataDataAP(Trim(Rs("DataFim")))
				strHoraFim 		= hour(rs("dataFim"))
				strMinutoFim 	= minute(rs("dataFim"))
				
				if len(strHoraFim)<2 then strHoraFim="0" & strHoraFim
				if len(strMinutoFim)<2 then strMinutoFim="0" & strMinutoFim
								
				strHoraFim 		= strHoraFim & ":" & strMinutoFim
				
			end if
			
			strObs 				= Trim(Rs("Obs"))
			strSituacao 		= Trim(Rs("Situacao"))
		
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			BotaoFoto				= ""

		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		BotaoFoto  				= "disabled"
	end if 
%>
<!-- fim do codigo asp da pagina -->
<table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td height="365" bgcolor="#FFFFFF" valign="top" align="center">

        <hr size="1" color="#FFFFFF">
        <table width="97%" cellpadding="0" cellspacing="0" class="TabelaDoCadastro" bgcolor="#F5F5F5">
            <tr>
                <td width="97%" class="CelulaDoCadastro" align="center" valign="top">

    <form id="frm" name="frm" action="#" method="post">
   	<!-- inicio do formulario da pagina-->
	    <table width="100%" border="0">
        <tr>
          <td width="16%" class="TextoForm">Titulo: <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
          <td colspan="3"><input name="txtDescricao" type="text" class="text" id="txtDescricao" size="40" maxlength="40" value="<%=strDescricao%>"></td>
        </tr>
        <tr>
          <td class="TextoForm">Tipo: </td>
          <td colspan="3"><!--#include file="../../../includes/inc_cmbTipoEvento.asp"--></tr>
        <tr>
          <td class="TextoForm">Local:</td>
          <td colspan="3"><input name="txtLocal" type="text" class="text" id="txtLocal" size="80" maxlength="100" value="<%=strLocal%>" /></td>
          </tr>
        <tr>
          <td class="TextoForm">Data In&iacute;cio:</td>
          <td width="26%"><input name="txtData" type="text" class="text" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strData%>" size="14" maxlength="11"></td>
          <td width="10%" class="TextoForm">Hora In&iacute;cio: </td>
          <td width="48%"><input name="txtHora" type="text" class="text" id="txtHora" value="<%=strHora%>" size="6" maxlength="5" onKeyPress="return formataCampo(this,10,5)"   ></td>
        </tr>
        <tr>
          <td class="TextoForm">Data Fim : </td>
          <td><input name="txtDataFim" type="text" class="text" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strDataFim%>" size="14" maxlength="11" /></td>
          <td><span class="TextoForm">Hora Fim: </span></td>
          <td><input name="txtHoraFim" type="text" class="text" id="txtHoraFim" value="<%=strHoraFim%>" size="6" maxlength="5" onKeyPress="return formataCampo(this,10,5)"></td>
        </tr>
        <tr>
          <td class="TextoForm">Observa&ccedil;&atilde;o:</td>
          <td colspan="3"><textarea name="txtObs" cols="51" rows="5" id="txtObs" class="text"><%=strObs%></textarea></td>
        </tr>								
        <tr>
          <td class="TextoForm">Situa&ccedil;&atilde;o:</td>
          <td colspan="3"><select name="cmbSituacao" id="cmbSituacao" class="combo">
            <option value="A" <%if trim(strSituacao)="A" then response.write "selected"%>>Ativo</option>
            <option value="E" <%if trim(strSituacao)="E" then response.write "selected"%>>Encerrado</option>
            <option value="C" <%if trim(strSituacao)="C" then response.write "selected"%>>Cancelado</option>
          </select></td>
        </tr>
        <tr>
          <td class="TextoForm">&nbsp;</td>
          <td colspan="3">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="4">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="4"><!--#include file="../../../includes/inc_botoes_cadastro.asp"--></td>
        </tr>
        <tr>
          <td colspan="4">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="4"><%
				cont =0
						
					sql = " SELECT  SIT_AgendaCompromisso.localCompromisso, SIT_AgendaCompromisso.codigo, "
					sql = sql & " SIT_TipoEvento.Descricao AS TipoEvento, "
					sql = sql & " SIT_AgendaCompromisso.Descricao, SIT_AgendaCompromisso.DataInicio, "
					sql = sql & " SIT_AgendaCompromisso.DataFim, SIT_AgendaCompromisso.situacao "
					sql = sql & " FROM SIT_TipoEvento "
					sql = sql & " INNER JOIN SIT_AgendaCompromisso ON SIT_TipoEvento.Codigo = SIT_AgendaCompromisso.codTipoEvento "
					sql = sql & " Where SIT_AgendaCompromisso.CodEmpresa = " & intCodEmpresa
					sql = sql & " Order by SIT_AgendaCompromisso.DataInicio desc"
					rs.open sql, cnn
									
					if rs.eof = false then
					%>
              <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                <tr bgcolor="#E5E5E5">
                  <td height="21" colspan="6" class="celula" align="center"><strong>Compromissos de <%=ucase(monthname(month(date)))%>/<%=year(date)%></strong></td>
                </tr>
                <tr bgcolor="#E5E5E5">
                  <td width="10%" height="21" class="celula"><strong>Tipo<span class="TextoForm"></span></strong></td>
                  <td width="19%" class="celula"><strong>Local</strong></td>
                  <td width="41%" height="21" class="celula"><strong>Evento<span class="TextoForm"></span></strong></td>
                  <td width="10%" class="celula"><strong><span class="TextoForm">In&iacute;cio </span></strong></td>
                  <td width="8%" height="21" class="celula"><strong><span class="TextoForm">Fim </span></strong></td>
                  <td width="12%" height="21" class="celula"><strong>Situação<span class="TextoForm"></span></strong></td>
                </tr>
                <%
				while not rs.eof
					cont = cont + 1	
					situacao = "Agendado"
					if rs("situacao") = "C" then situacao = "Cancelado"
					if rs("situacao") = "A" then situacao = "Ativo"
					if rs("situacao") = "E" then situacao = "Encerrado"
					%>
                <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')">
                  <td height="20" class="celula"><%=trim(rs("TipoEvento"))%>&nbsp;</td>
                  <td class="celula"><%=trim(rs("localCompromisso"))%>&nbsp;</td>
                  <td height="20" class="celula"><%=trim(rs("Descricao"))%>&nbsp;</td>
                  <td class="celula"><%=trim(formatadataap(rs("DataInicio")))%></td>
                  <td height="20" class="celula"><%=trim(formatadataap(rs("DataFim")))%></td>
                  <td height="20" class="celula"><%=trim(situacao)%>&nbsp;</td>
                </tr>
                <%				
					rs.movenext
					wend
				%>
                <tr>
                  <td height="21" colspan="6" class="celula">Total 
                    Registros : <%=cont%></td>
              </table>
            <%
			  end if
			  rs.close%>			  </td>
        </tr>
        <tr>
          <td colspan="4">&nbsp;</td>
        </tr>
      </table>

   	<!-- fim do formulario da pagina-->
    </form>
                   </td>
            </tr>
        </table>
        <hr size="1" color="#FFFFFF">
 
    
    </td>
  </tr>
</table>
<!--#include file="rodape.asp"-->
</body>
</html>
<script>aguarde.style.display="none";</script>
