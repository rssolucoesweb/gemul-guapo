<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Sergio Borges - Sergiob76@hotmail.com
	::	Objetivo Pagina...: Cadastro de sala 
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
<script>
	function calculaCapacidadeFisica(objArea,objCapacidade,comprimento, largura){
		var area=0
		var capacidade=0
		
		comprimento = comprimento.replace(",",".")
		largura = largura.replace(",",".")
				
		
		if (comprimento=="")
			comprimento = 0
			
		if (largura=="")
			largura = 0
			
								
		area = FormataNumero(comprimento * largura,2)
		
		//alert (comprimento + " * " + largura + " = " + area + " | " + (area- 2.50)/1.2);
		if (area>0)
			capacidade = parseInt(((area - 2.50)/1.2))
		else
			capacidade = 0
		
		if (capacidade<0)
			capacidade=0
		
		area=area+""
		capacidade=capacidade+""
		
		objArea.value=area.replace(".",",")
		objCapacidade.value = capacidade.replace(".",",")
		
	}
	
function FormataNumero(valor,Qtdcasas){ //->função que delimita qtd de casas após a vírgula. Ex.: 6.86 para 6.8

	var qtde;
	var i;
	var VNota = "";
	var ponto = false;
	valor = "" + valor; //->converte para string
	qtde = valor.length;

	for(i=0;i<qtde;i++){
		VNota = VNota + valor.substring(i,i+1);
		if (valor.substring(i,i+1) =="."){
			ponto = true;
			break;
		}
	}
	
	if (ponto){
		VNota = VNota + valor.substring(i+1,i+Qtdcasas+1)
	}	
	
	return VNota;
}		
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		//Esta função valida os campos do formulário da página sia_SalaAula_cad.js
		if (frm.txtNumNomeSalaDescricao.value == "") {
			alert("O número/nome da sala deve ser informado!");
			frm.txtNumNomeSalaDescricao.focus();
			return false;
		} 
	
		if (frm.txtFuncaoOriginal.value == "") {
			alert("A função original deve ser informada!");
			frm.txtFuncaoOriginal.focus();
			return false;
		} 
	
		if (frm.txtComprimento.value == "") {
			alert("O comprimento deve ser informado!");
			frm.txtComprimento.focus();
			return false;
		}
		
		if (frm.txtLargura.value == "") {
			alert("A largura deve ser informada!");
			frm.txtLargura.focus();
			return false;
		} 
	
		if (frm.txtPeDireito.value == "") {
			alert("O pé-direito deve ser informado!");
			frm.txtPeDireito.focus();
			return false;
		} 
	
		if (frm.txtArea.value == "") {
			alert("A área deve ser informada!");
			frm.txtArea.focus();
			return false;
		} 
	
		if (frm.cmbSituacao.value == "0") {
			alert("A situação da sala de aula deve ser informada!");
			frm.cmbSituacao.focus();
			return false;
		} 
		
		
		frm.action="sia_SalaAula_cod.asp?acao=" + acao;
		frm.submit();
		return true;	 
	}
</script>
<%
	intCodigo							= Trim(Request.form("txtHiddenCodigo"))
	intCodEmpresa 					= Session("CodEmpresa")
	intCodAmbiente						= "27"' Codigo da Sala de Aula
	'intCodFuncionalidade			=  "1" ' Codigo Pedagogico
	strNumNomeSalaDescricao		= Trim(Request.form("txtNumNomeSalaDescricao"))
	strFuncaoOriginal					= Trim(Request.form("txtFuncaoOriginal"))
	strComprimento						= Trim(Request.form("txtComprimento"))
	strLargura								= Trim(Request.form("txtLargura"))
	strPeDireito							= Trim(Request.form("txtPeDireito"))
	strArea    								= Trim(Request.form("txtArea"))
	strCapacidade							= Trim(Request.form("txtCapacidade"))
	intCodigoImovel						= Trim(Request.Form("txtCodigoImovel"))
	intCodImovel							= Trim(Request.Form("cmbImovel"))
	srtExtensao 							= Trim(Request.Form("chkExtensao"))
	strLarguraAtual						= Trim(Request.form("txtLargura"))
	strSituacaoSala						= Trim(Request.Form("cmbSituacao"))
	
	if srtExtensao = "S" then
		strDesabilita = ""
	else
		strDesabilita = "disabled"
	end if 
	
	strReadOnly ="readOnly"
	strEnabled 	="disabled"
		
	if intCodImovel = "" then intCodImovel ="0"
	if intCodigo <> "" and intCodEmpresa <> "" then
	
			strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar = "" 'Habilita o botão Alterar
			strDesabilitaExcluir = "" 'Habilita o botão Excluir
			strDesabilitaLimpar  = "" 'Habilita o Botão Limpar
			
			sql = "SELECT codigo, codigo_sia_conj_ambiente, codigo_sia_func_ambiente," 
			sql = sql & " descricao, funcao_original, comprimento, largura, area, capacidade, pe_direito, codigo_status"
			sql = sql & " FROM SIA_ambiente_ue"
			sql = sql & " WHERE codigo = " & intCodigo
			sql = sql & " AND codigo_sia_unid_ensino = " & intCodEmpresa
			'response.write sql
			rs.open sql, cnn
			
			if not rs.eof then
			
				if rs("descricao") <> "" then
					strNumNomeSalaDescricao= cstr(rs("descricao"))
				end if 
	
				if rs("funcao_original") <> "" then
					strFuncaoOriginal= cstr(rs("funcao_original"))
				end if 
		
				if rs("comprimento") <> "" then
					strComprimento= cstr(rs("comprimento"))
				end if 
			
				if rs("largura") <> "" then
					strLargura= cstr(rs("largura"))
				End if 
				
				if rs("area") <> "" then
					strArea= cstr(rs("area"))
				end if
			
				if rs("capacidade") <> "" then
					strCapacidade= cstr(rs("capacidade"))
				end if
				
				if rs("codigo_status") <> "" then
					
					intCodSituacao= cstr(rs("codigo_status"))
					
					if intCodSituacao = "1" then 
						strSituacaoSala = "Ativo"
					elseif intCodSituacao = "2" then 
						strSituacaoSala = "Inativo"
					end if 
				
				end if
				
				if rs("capacidade") <> "" then
					strCapacidade= cstr(rs("capacidade"))
				end if 
				
				if rs("pe_direito") <> "" then
					strPeDireito= cstr(rs("pe_direito"))
				end if 
			
			end if 
			rs.close

			
			' Consulta dados Imovel
			sql = "SELECT imovel.codigo, codigo_sia_outro_imovel, situacao"
			sql = sql & " FROM SIA_sala_outro_imovel as imovel inner join SIA_outro_imovel"
			sql = sql & " on imovel.codigo_sia_unid_ensino = sia_outro_imovel.codigo_sia_unid_ensino and imovel.codigo_sia_outro_imovel = SIA_outro_imovel.codigo" 
			sql = sql & " where imovel.codigo_sia_ambiente_ue= " & intCodigo
			sql = sql & " AND imovel.codigo_sia_unid_ensino = " & intCodEmpresa
			'response.write sql
			rs.open sql, cnn
			
			if not rs.eof then
				
				if rs("codigo") <> "" then
					intCodigoImovel = cstr(rs("codigo"))
				end if 
			
				if rs("codigo_sia_outro_imovel") <> "" then
					intCodImovel= cstr(rs("codigo_sia_outro_imovel"))
					strDesabilita = ""
					srtExtensao = "S"
				end if
				
				if rs("situacao") = "Inativo" then 
					strDesabilita 	= "disabled"
					strSituacao 		= rs("situacao")
				else
					strDesabilita =""
				end if 
				
			end if 
			rs.close

	else
		strDesabilitaIncluir = "" 'Habilita o botão Incluir
		strDesabilitaAlterar = "disabled" 'Desabilita o botão Alterar
		strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
		strDesabilitaLimpar  = "" 'Habilita o Botão Limpar
	end if
	
	' Caso na seje alteração ele pega o valor da consulta
	if strLarguraAtual <> "" then 
		if strLargura="" then strLargura = strLarguraAtual
		if strArea="" then strArea = strAreaAnt
	end if
%>  <tr valign="top">
    <td>
	<table width="751"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post">
		<table width="708" border="0" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td width="700" align="center" class="tituloSistema">Cadastro de Salas</td>
            </tr>
          </table>		
			  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
		
		<tr> 
		  <td>&nbsp;</td>
		  <td colspan="4"><input name="txtHiddenCodigo" type="hidden" class="caixaTexto" id="txtHiddenCodigo" value="<%=intCodigo%>" size="10" maxlength="10">		  </td>
		  <td colspan="5"></td>
		</tr>
		<tr> 
		  <td>Ambiente</td>
		  <td colspan="4"> <a href="#" onClick="return abreConsulta('sia_SalaAula_con.asp')"></a> 
			<input name="textfield" type="text" class="caixaTexto" value="Sala de Aula" <%=strEnabled%>  size="15" maxlength="15"> 
			<a href="#" onClick="return abreConsulta('sia_SalaAula_con.asp')"><img src="../../imagens/Consulta_normal.gif" name="Consulta" width="25" height="26" border="0" align="absmiddle"></a> 
		  <td width="380" colspan="5"></td>
		</tr>
		<tr> 
		  <td width="154">Funcionalidade </td>
		  <td colspan="5"><input name="txtFuncionalidade" type="text" class="caixaTexto" id="txtFuncionalidade"  value="Pedagógica" <%=strEnabled%> size="15" maxlength="15">		  </td>
		</tr>
		<tr> 
		  <td>N&ordm; / Nome da sala</td>
		  <td colspan="5"><input name="txtNumNomeSalaDescricao" class="caixaTexto" type="text" id="txtNumNomeSalaDescricao" value="<%=strNumNomeSalaDescricao%>" size="50" maxlength="50">		  </td>
		</tr>
		<tr> 
		  <td>Fun&ccedil;&atilde;o original</td>
		  <td><input name="txtFuncaoOriginal" type="text" class="caixaTexto" id="txtFuncaoOriginal" value="<%=strFuncaoOriginal%>" size="30" maxlength="50">		  </td>
		  <td colspan="2"><input name="chkExtensao" type="checkbox" id="chkExtensao" <%if srtExtensao ="S" then response.Write("checked")%> onClick="return reload()" value="S">
			Extens&atilde;o</td>
		  <td width="72">Im&oacute;vel 
			<input name="txtCodigoImovel" type="hidden" class="caixaTexto" id="txtCodigoImovel" value="<%=intCodigoImovel%>" size="10" maxlength="10"></td>
		  <%
					
					SQL = "SELECT codigo, nome_imovel"
					SQL = SQL & " FROM SIA_outro_imovel"
					SQL = SQL & " Where codigo_sia_unid_ensino =" & intCodUnidEnsino
					
					if strSituacao <> "Inativo" then 
						SQL = SQL & " and situacao = 'Ativo'"
					end if
									
					SQL = SQL & " ORDER BY nome_imovel"
					
					RS.OPEN SQL, CNN
				%>
		  <td width="380"><select name="cmbImovel" id="cmbImovel" <%=strDesabilita%> class="combo">
			  <option value="0">Selecione...</option>
			  <%
					While not RS.EOF
						if cstr(intCodImovel) = cstr(rs("codigo")) then
							strSelecionado = "selected"
						else
							strSelecionado = ""
						end if
						response.write "<option value=" & rs("codigo") & " " & strSelecionado & ">" & rs("nome_imovel") & "</otpion>" & vbcrlf
						rs.movenext
					wend
					rs.close
					%>
			</select></td>
		</tr>
		<tr> 
		  <td height="23">Comprimento</td>
		  <td><input name="txtComprimento" type="text" class="caixaTexto" id="txtComprimento" onKeyPress="return formataCampo(this, 6, 5)" onBlur="calculaCapacidadeFisica(frm.txtArea,frm.txtCapacidade,this.value,frm.txtLargura.value)" value="<%=strComprimento%>" size="5" maxlength="5">(m)</td>
		  <td><div align="left">Largura </div></td>
		  <td><input name="txtLargura" type="text" class="caixaTexto" id="txtLargura" value="<%=strLargura%>" onKeyPress="return formataCampo(this, 6, 5)" onBlur="calculaCapacidadeFisica(frm.txtArea,frm.txtCapacidade,frm.txtComprimento.value,this.value)" size="5" maxlength="5">(m)</td>
		  <td>P&eacute;-direito</td>
		  <td><input name="txtPeDireito" type="text" class="caixaTexto" id="txtPeDireito" onKeyPress="return formataCampo(this, 6, 5)" value="<%=strPeDireito%>" size="5" maxlength="5">(m)</td>
		</tr>
		<tr>
		  <td>&Aacute;rea</td>
		  <td><input name="txtArea" type="text" class="caixaTexto" id="txtArea" onKeyPress="return formataCampo(this, 2, 8)" value="<%=strArea%>" <%=strReadOnly%> size="10" maxlength="10">(m&sup2;)</td>
		  <td>Capacidade f&iacute;sica</td>
		  <td><input name="txtCapacidade" type="text" class="caixaTexto" id="txtCapacidade" value="<%=strCapacidade%>" <%=strReadOnly%> size="10" maxlength="10">
			(alunos) </td>
		  <td colspan="4">&nbsp;</td>
		</tr>
		<tr> 
		  <td width="154">Situa&ccedil;&atilde;o</td>
		  <td width="173"><select name="cmbSituacao" class="combo" id="select5">
			  <option value="0">Selecione...</option>
			  <%
				For cont= 5 to 6
					
					if cont= 5 then 
						strSituacaoSala = "Ativo"
					elseif  cont= 6 then 
						strSituacaoSala = "Inativo"
					end if 
				
					if cstr(intCodSituacao) = cstr(cont) then
						strSelecionado = "selected"
					else
						strSelecionado = ""
					end if
					response.write "<option value=" & cont & " " & strSelecionado & ">" & strSituacaoSala & "</option>" & vbcrlf
				next
				
			%>
			</select></td>
		  <td width="85"><div align="left"></div></td>
		  <td width="109">&nbsp;</td>
		  <td colspan="4">&nbsp;</td>
		</tr>
		<tr> 
		  <td colspan="8"><hr size="1" color="#CCCCCC"></td>
		</tr>
		<tr> 
		  <td colspan="8"><!--#include file="../../includes/inc_botoes_cadastro.asp"--> </td>
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