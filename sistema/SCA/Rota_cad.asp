<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Aluno 
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
<!--#include file="../../includes/inc_validaPermissaoPagina.asp"-->
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
		
		if (frm.txtNome.value == ""){
			alert("A rota deve ser informada.");
			frm.txtNome.focus();
			return false;
		}	
		
		if (frm.txtDistanciaPercorrida.value == ""){
			alert("A distancia percorrida deve ser informada.");
			frm.txtDistanciaPercorrida.focus();
			return false;
		}			
		
		if (frm.cmbColaborador.value == "0"){
			alert("O Colobaorador deve ser informado.");
			frm.cmbColaborador.focus();
			return false;
		}
		
		if (frm.txtValor.value == ""){
			alert("O Valor deve ser informado.");
			frm.txtValor.focus();
			return false;
		}
		
		if (frm.txtVeiculo.value == ""){
			alert("O Veiculo deve ser informado.");
			frm.txtVeiculo.focus();
			return false;
		}
		
		if (frm.txtPlaca.value == ""){
			alert("A Placa deve ser informada.");
			frm.txtPlaca.focus();
			return false;
		}
		
		if (frm.txtCor.value == ""){
			alert("A Cor deve ser informada.");
			frm.txtCor.focus();
			return false;
		}			
		
		if (frm.txtData.value == ""){
			alert("A Data deve ser informada.");
			frm.txtData.focus();
			return false;
		}	
		
		frm.action= "Rota_cod.asp?acao=" + acao;
		frm.submit();
		return true;	 
 	}
</script>
<%
	strPaginaTitulo 		= "Rota_cad.asp"
	intCodigo		    	= Trim(Request.Form("txtCodigo")) 
	strNomeRota	 			= Trim(Request.Form("txtNome"))
	intDistanciaPercorrida 	= Trim(Request.Form("txtDistanciaPercorrida"))
	intCodColaborador	 	= Trim(Request.Form("cmbColaborador"))
	strValor	 			= Trim(Request.Form("txtValor"))
	strVeiculo	 			= Trim(Request.Form("txtVeiculo"))
	strPlaca	 			= Trim(Request.Form("txtPlaca"))
	strCor	 				= Trim(Request.Form("txtCor"))
	strData	 				= Trim(Request.Form("txtData"))
	strObservacao			= Trim(Request.Form("txtObservacao"))
	
	if intCodigo <> "" then
	
		sql = "SELECT Cod_Rota, Cod_Empresa,Cod_Grupo, Descricao, Distancia_percorrida, CodColaborador, Valor, Veiculo, Placa, Cor, Data, Observacao"
		sql = sql & " FROM SCA_ROTA"
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
		sql = sql & " and Cod_Rota=" & intCodigo
		
		rs.open sql, cnn
		if rs.eof = false then
			
			intCodRota	 			= rs("Cod_Rota")
			intCodEmpresa 			= rs("Cod_Empresa")
			strNomeRota            	= rs("Descricao")
			intDistanciaPercorrida 	= rs("Distancia_percorrida")
			intCodColaborador	 	= rs("CodColaborador")
			strValor	 			= formatNumber(rs("Valor"),2) 
			strVeiculo	 			= rs("Veiculo")
			strPlaca	 			= rs("Placa")
			strCor	 				= rs("Cor")
			strData	 				= formatadataAP(rs("Data"))
			strObservacao          	= rs("Observacao")
			
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
	
	if strData = "" then strData = formatadataAP(date)
%>
<table width="100%" height="355" border="0" cellpadding="0" cellspacing="0" align="center" bgcolor="#FFFFFF">
  <tr>
    <td>
      <form id="frm" method="post">
	    <table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
          <tr>
            <td width="12%" class="texto1">&nbsp;</td>
            <td width="88%"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Nome da Rota: </td>
            <td><input name="txtNome" value="<%=strNomeRota%>" type="text" class="text" id="txtNome" size="50" maxlength="50"></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Dist&acirc;ncia percorrida: </td>
            <td><input name="txtDistanciaPercorrida" value="<%=intDistanciaPercorrida%>" type="text" class="text" id="txtDistanciaPercorrida" size="4" maxlength="4">
              <font color="#666666" class="texto1">(km)</font></td>
          </tr>
          <tr>
            <td height="24" class="texto1">Motorista:</td>
            <td><!--#include file="../includes/inc_cmdColaborador.asp" --></td>
          </tr>
          <tr>
            <td height="24" class="texto1">Valor:</td>
            <td><span class="TextoForm">
              <input name="txtValor" type="text" class="text" id="txtValor" onKeyPress="return currencyFormat(this,event)" size="11" maxlength="5" value="<%=strValor%>">
            </span></td>
          </tr>
          <tr>
            <td height="24" class="texto1">Veiculo:</td>
            <td><input name="txtVeiculo" value="<%=strVeiculo%>" type="text" class="text" id="txtVeiculo" size="18" maxlength="20"></td>
          </tr>
          <tr>
            <td height="24" class="texto1">Placa:</td>
            <td><input name="txtPlaca" type="text" class="text" id="txtPlaca" size="10" maxlength="7" value="<%=strPlaca%>" /></td>
          </tr>
          <tr>
            <td height="26" class="texto1">Cor:</td>
            <td><input name="txtCor" value="<%=strCor%>" type="text" class="text" id="txtCor" size="18" maxlength="20"></td>
          </tr>
          <tr>
            <td height="27" class="texto1">Data:</td>
            <td><span class="TextoForm">
              <input name="txtData" type="text" class="text" id="txtData" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" value="<%=strData%>" style="cursor:hand" title="Click aqui para visualizar o calend&aacute;rio">
            </span></td>
          </tr>
          <tr>
            <td class="texto1">Observa&ccedil;&atilde;o:</td>
            <td><textarea name="txtObservacao" cols="50" class="text" id="txtObservacao"><%=strObservacao%></textarea></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><%IF  Session("CodEmpresa")	<>"0" THEN%>
              <table width = "98%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                <tr bgcolor="#E5E5E5">
                  <td width="5%" align="center" class="celula">#</td>
                  <td width="7%" class="celula"><strong>Empresa</strong></td>
                  <td width="38%" class="celula"><strong>Grupo</strong></td>
                  <td class="celula"><strong>Unidade/Empresa</strong></td>
                </tr>
                <%

			sql = "SELECT SEG_EMPRESA.RAZAOSOCIAL, SEG_GRUPO.DESCRICAO as GRUPO, SEG_EMPRESA.COD_GRUPO, SEG_EMPRESA.CODIGO AS COD_EMPRESA"
			sql = sql & " FROM SEG_EMPRESA"
			sql = sql & " INNER JOIN SEG_GRUPO ON SEG_GRUPO.CODIGO = SEG_EMPRESA.COD_GRUPO"
			sql = sql & " WHERE SEG_EMPRESA.COD_GRUPO = " & Session("CodGrupo") 
			sql = sql & " Order by SEG_GRUPO.DESCRICAO, SEG_EMPRESA.RAZAOSOCIAL"
			rs.open sql, cnn
			if rs.eof = false then
				while not rs.eof
					cont = cont + 1	
					strMarca 	= ""
					
					if trim(rs("COD_EMPRESA")) = trim(intCodEmpresa) then
						strMarca = "checked"
						strCor = "#FFFFCC"
					else
						strMarca = ""
						strCor = ""
					end if
					
					strCor = ""
					
					if strNomeRota <> "" then 
					
					sql = "SELECT Cod_Rota, Cod_Empresa, Cod_Grupo, Descricao, Distancia_percorrida, CodColaborador, Valor, Veiculo, Placa, Cor, Data, Observacao"
					sql = sql & " FROM SCA_ROTA"
					sql = sql & " where Descricao = '" & trim(strNomeRota) & "'"
					sql = sql & " And Cod_Empresa = '" & trim(rs("COD_EMPRESA"))  & "'"
					RsAux.open sql, cnn
					if RsAux.eof = false then
						strCor = "#CECEFF"
					else
						strCor = ""
					end if
					RsAux.close
					
					end if
					
					
					
					%>
                <tr bgcolor="<%=strCor%>" >
                  <td class="celula" align="center"><input name="chkEmpresa"  type="checkbox" value="<%=rs("cod_empresa")%>" <%=strMarca%>></td>
                  <td class="celula"><%=trim(rs("cod_empresa"))%></td>
                  <td class="celula"><%=trim(rs("grupo"))%></td>
                  <td class="celula"><%=trim(rs("RAZAOSOCIAL"))%></td>
                </tr>
                <%	
						rs.movenext
					wend
				  else
				  %>
                <center>
                  <strong><%=strMensagemNaoEncontrado%></strong>
                </center>
                <%		
					end if
					rs.close
				  %>
                <tr>
                  <td align="center" bgcolor="#E5E5E5" class="celula"><strong>Total</strong></td>
                  <td colspan="3" bgcolor="#E5E5E5" class="celula"><%=cont%></td>
                </tr>
              </table>
              <%END IF%></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><%
			cont =0
			
			sql = "SELECT Cod_Rota, Cod_Empresa, Descricao"
			sql = sql & " FROM SCA_ROTA"
			sql = sql & " where Cod_Empresa =  " & Session("CodEmpresa")				
			sql = sql & " Order by Cod_Rota"
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
              <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                <tr bgcolor="#E5E5E5">
                  <td width="17%" class="celula"><strong>C&oacute;digo</strong></td>
                  <td width="83%" class="celula"><strong>Rota</strong></td>
                  <td width="83%" height="21" class="celula"><strong>Cod. Empresa<span class="TextoForm"></span></strong></td>
                  </tr>
                <%
				while not rs.eof
					cont = cont + 1	
					%>
                <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Cod_Rota")%>')">
                  <td class="celula"><%=rs("Cod_Rota")%></td>
                  <td class="celula"><%=trim(rs("Descricao"))%></td>
                  <td height="20" class="celula"><%=trim(rs("Cod_Empresa"))%></td>
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
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
        </table>
	  </form>
    </td>
  </tr>
</table>
<!--#include file="../rodape.asp"-->
</body>
</html>