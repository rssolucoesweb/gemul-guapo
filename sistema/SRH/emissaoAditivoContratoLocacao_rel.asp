<html>
<head>
<title><%=session("Titulo")%></title>
<link href="css/Estilo_Impressao.css" rel="stylesheet" type="text/css">
<style type="text/css">

	@media print {
    #imprimir {
        display: none;
    }

</style>
<!--#include file="includes/inc_Botoes_relatorio.asp"-->
<script src="js/barraMovel.js"></script>
<script src="js/js_funcoes_gerais.js"></script></head>
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_extenso.asp"-->
<!--#include file="includes/inc_formataData.asp"--><body>
<%
	intNumContrato	= Trim(Request("txtNumContrato"))
	intCodAditivoContrato	= Trim(Request("txtCodAditivoContrato"))

	if trim(intNumContrato) <> "" then
		sql = " SELECT C.NumPasta, C.codigo, C.NumContrato, C.codLocatarioImovel, C.dataInicio, C.dataFim, C.taxaDoBoleto, "
		sql = sql & " C.meses, C.dataAssinatura, C.DataAluguel, C.DataRepasse, IL.codImovel, LI.tipoFiador "
		sql = sql & " FROM IMOB_ImovelLocador IL INNER JOIN (IMOB_LocatarioImovel LI INNER JOIN IMOB_contrato C "
		sql = sql & " ON LI.codigo = C.codLocatarioImovel) ON IL.codigo = LI.codImovelLocador "
		sql = sql & " WHERE C.NumContrato=" & intNumContrato
		sql = sql & " and C.CodEmpresa = " & session("codEmpresa")
		
		rs.open sql, cnn
		if rs.eof = false then
			intCodContrato			= rs("codigo")
			intCodImovel			= rs("codImovel")
			intPasta				= rs("NumPasta")
			intCodLocatarioImovel	= rs("codLocatarioImovel")
			strDataFinal			= DateAdd("d", 1, formatadataAP(rs("dataFim")))
			strDiaVencimento		= day(rs("DataAluguel"))
			strDataVencimento		= formatadataAP(rs("DataAluguel"))
			strTaxaDoBoleto			= formatNumber(rs("taxaDoBoleto"),2)
			rs.close
			
			strQtdeMeses = 0
			
			sql = "SELECT C.DataVencimentoReajuste,  C.meses, C.dataInicio, C.dataFim, C.valorAluguelReajuste"
			sql = sql & " FROM IMOB_ContratoReajuste C"
			sql = sql & " WHERE C.CODContrato="& intCodContrato
            sql = sql & " and C.codigo = " & intCodAditivoContrato
			sql = sql & " and C.CodEmpresa = " & session("codEmpresa")
			sql = sql & " order by C.codigo desc"

			rs.open sql, cnn
			if rs.eof = false then
				while not rs.eof
					if strDataInicioReajuste = "" then
						if trim(strQtdeMesesReajuste) = "" then
							strQtdeMesesReajuste	= rs("meses")
						end if
						strQtdeMeses			= strQtdeMeses + rs("meses")
	
						strDataInicioReajuste		= formataDataAP(rs("dataInicio"))
						strDataFinalReajuste		= formataDataAP(rs("dataFim"))
						
						strDataVencimentoReajuste		= formataDataAP(rs("DataVencimentoReajuste"))
						
						if trim(strValorAluguelReajuste) = "" then
							strValorAluguelReajuste	= formatNumber(Trim(Rs("valorAluguelReajuste")),2)
						end if
					end if
					rs.movenext
				wend
			end if
			rs.close
			'regra para os reajuste antigo
			'os novos reajuste no precisaram ser calculadas automaticamente				
			if trim(strDataInicioReajuste) = "" and trim(strDataFinalReajuste) = "" then
				strDataInicio	=  DateAdd("m", strQtdeMeses-12, strDataFinal)
				strDataInicio	=  formatadataAP(strDataInicio)
				strDataFinal 	=  DateAdd("m", strQtdeMeses, strDataFinal)-1
				strDataFinal	=  formatadataAP(strDataFinal)

				strDataInicioReajuste		= strDataInicio
				strDataFinalReajuste		= strDataFinal

				strDataInicioVenc	=  DateAdd("m", 1, strDataInicio)
				strDataInicioVenc	=  formatadataAP(strDataInicioVenc)
				strDataVencimentoReajuste = formatadataAP(strDataInicioVenc)
			end if
			
		else
			rs.close
			%>
			<script>
				alert("Dados do Aluquel/Imovel/Locatário Inexistente , verifique!");
				window.close();
			</script>
			<%
			response.End()
		end if
	end if

%>	<div align="center" style="width:700px"> 
		<div class="textoRelatorioContrato" align="center">
		<!--#include file="includes/inc_cabecalhoRelatorioContrato.asp"-->
		</div>
	</div>
<table width="100%" class="textoRelatorio">
  <tr> 
    <td colspan="3" align="center" class="textoRelatorio"><strong>TERMO ADITIVO DE CONTRATO DE LOCA&Ccedil;&Atilde;O </strong></td>
  </tr>
  <tr> 
    <td colspan="3" align="center">Q U A D R O&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; R 
      E S U M O</td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><div align="center"><strong>CONTRATO: <%=intNumContrato%>&nbsp;&nbsp;&nbsp;&nbsp;PASTA:&nbsp;<%=intPasta%> </strong></div></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><hr size="1" color="#CCCCCC"></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><p><strong>1 - L O C A D O R (A)</strong></p></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><hr size="1" color="#CCCCCC"></td>
  </tr>
  <%
	'busca imovel/proprietario
	sql = "SELECT IL.codigo AS CodImovelLocador, I.ValorAluguel, I.ValorRepasse, I.codigo AS codImovel, TS.Descricao AS TipoServico, TI.Descricao AS TipoImovel, TC.Descricao AS categoria, I.tipo, I.situacao, I.endereco, I.bairro, I.municipio, I.codTipoServico, I.codTipoImovel, I.uf, C.NomeCompleto_RazaoSocial AS Proprietario, C.Profissao, EC.Descricao AS estadocivil, C.Cpf_Cnpj AS cic, C.RG, C.OrgaoExp AS OrgaoExp, C.Endereco AS enderecoLocador, C.Bairro AS bairroLocador, C.CEP AS cepLocador, C.Cidade AS municipioLocador, C.UF AS ufLocador "
	sql = sql & " FROM IMOB_TipoServico TS RIGHT JOIN ((IMOB_TipoCategoria TC RIGHT JOIN IMOB_TipoImovel TI ON TC.Codigo = TI.CodCategoria) RIGHT JOIN ((IMOB_Imovel I LEFT JOIN IMOB_ImovelLocador IL ON I.codigo = IL.codImovel) LEFT JOIN (IMOB_EstadoCivil EC RIGHT JOIN ((IMOB_Cliente C RIGHT JOIN IMOB_ClienteTipoVinculo CTV ON C.codigo = CTV.CodCliente) RIGHT JOIN IMOB_ImovelLocadorProprietario ILP ON CTV.Codigo = ILP.codClienteTipoVinculo) ON EC.Codigo = C.CodEstadoCivil) ON IL.codigo = ILP.codImovelLocador) ON TI.Codigo = I.codTipoImovel) ON TS.Codigo = I.codTipoServico "
	sql = sql & " Where I.Codigo = " & intCodImovel 
	sql = sql & " AND 	IL.situacao = 'A'" 'ativo
	sql = sql & " and C.CodEmpresa = " & session("codEmpresa")
	rs.open sql, cnn
	if rs.eof = false then
		intCodImovel		= Trim(Rs("codImovel"))
		strDescricaoImovel = " "
		strBairroImovel = " "
		strMunicipioImovel = " "
		if not isnull(rs("endereco")) then
			strObjeto = trim(rs("tipoImovel"))
			strDestinoLocacao = trim(rs("categoria"))
			strEnderecoImovel = rs("endereco")
			strBairroImovel = rs("bairro")
			strMunicipioImovel = rs("municipio") & "-GO"
		end if
		strValorAluguel			= formatNumber(Trim(Rs("ValorAluguel")),2)
		strValorRepasse			= formatNumber(Trim(Rs("ValorRepasse")),2)
		strProprietario = ""
		while not rs.eof
			strProfissaoLocador 	= ucase(rs("profissao"))
			strEstadoCivilLocador 	= ucase(rs("estadocivil"))
			strCPFLocador 			= rs("cic")
			strRGLocador 			= rs("rg")
			strOrgaoExpedidorLocador= rs("orgaoExp")
			strEnderecoLocador		= rs("enderecoLocador")
			strBairroLocador 		= rs("bairrolocador")
			strCepLocador 			= rs("ceplocador")
			strEnderecoCompletoLocador = strEnderecoLocador
			if not isnull(rs("bairrolocador")) then strEnderecoCompletoLocador = strEnderecoCompletoLocador & ", " & rs("bairrolocador")
			if not isnull(rs("municipiolocador")) and rs("municipiolocador") <> "" then strEnderecoCompletoLocador = strEnderecoCompletoLocador & ", " & rs("municipiolocador") 
			if not isnull(rs("uflocador")) and rs("uflocador") <> "" then strEnderecoCompletoLocador = strEnderecoCompletoLocador & ", " & rs("uflocador") 
			if not isnull(rs("ceplocador")) and rs("ceplocador") <> "" then strEnderecoCompletoLocador = strEnderecoCompletoLocador & ", " & rs("ceplocador") 
							
			strProprietario	= rs("Proprietario")
			%>
			  <tr> 
				<td width="23%" class="textoRelatorio"><strong>NOME</strong></td>
				<td width="77%" colspan="2" class="textoRelatorio"><strong>:&nbsp;<%=strProprietario%></strong></td>
			  </tr>
			  <tr> 
				<td width="23%" class="textoRelatorio"><strong>NACIONALIDADE</strong></td>
				<td colspan="2" class="textoRelatorio"><strong>:&nbsp;BRASILEIRO(a)</strong></td>
			  </tr>
			  <tr> 
				<td width="23%" class="textoRelatorio"><strong>ESTADO CIVIL(a)</strong></td>
				<td colspan="2" class="textoRelatorio"><strong>:</strong>&nbsp;<%=strEstadoCivilLocador%></td>
			  </tr>
			  <tr> 
				<td width="23%" class="textoRelatorio"><strong>PROFISS&Atilde;O</strong></td>
				<td colspan="2" class="textoRelatorio"><strong>:</strong> <%=strProfissaoLocador%></td>
			  </tr>
			  <tr> 
				<td width="23%" class="textoRelatorio"><strong>C&Eacute;D.IDENTIDADE</strong></td>
				<td colspan="2" class="textoRelatorio"><strong>: <%=strRGLocador%>, <%=strOrgaoExpedidorLocador%></strong></td>
			  </tr>
			  <tr> 
				<td width="23%" class="textoRelatorio"><strong>CPF</strong></td>
				<td colspan="2" class="textoRelatorio"><strong>: <%=strCPFLocador%></strong></td>
			  </tr>
			  <tr> 
				<td colspan="3" class="textoRelatorio"><hr size="1" color="#CCCCCC"></td>
			  </tr>
			  <%				
			rs.movenext
		wend
	end if
	rs.close
	%>
  <% if session("strAssinatura") <> "" then%>
  <tr> 
    <td colspan="3" class="textoRelatorio"><div align="justify">      <br>
      NESTE ATO REPRESENTADO 
        PELA <strong><%=session("strRazaoSocial")%></strong>, pessoa f&iacute;sica ora denominada <strong><%=session("strAssinatura")%></strong>, devidamente inscrita no CRECI/GO <%=session("strCreci")%>, localizada na <%=session("strEndereco") & ", " & session("strBairro")  & ", " & session("strCidade") & "/" & session("strUF") %>, doravante denominado simplesmente ADMINISTRADORA.<br>
        <br>
    </div></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><hr size="1" color="#CCCCCC"></td>
  </tr>
  <% end if%>
  <tr> 
    <td colspan="3" class="textoRelatorio"><strong>2 - L O C A T &Aacute; R I O (A)</strong></td>
  </tr>
  <%

	'busca locatario
	strLocatario = ""
	strLocatario = ""
	sql = "SELECT LI.codigo, IL.codImovel, C.tipo_pessoa, LI.tipoFiador, LI.valorFianca, C.NomeCompleto_RazaoSocial AS locatario, C.Cpf_Cnpj AS cic, C.RG, C.OrgaoExp AS OrgaoExp, C.Endereco, C.Bairro, C.CEP, C.Cidade AS municipio, C.UF, C.Profissao, EC.Descricao AS EstadoCivil, C.NomeCompletoConjuge, c.NacionalidadeConjuge, C.CPFConjuge, C.RGConjuge, C.OrgaoExpConjuge, c.profissaoconjuge  "
	sql = sql & " FROM (IMOB_ImovelLocador IL INNER JOIN IMOB_LocatarioImovel LI ON IL.codigo = LI.codImovelLocador) INNER JOIN (IMOB_EstadoCivil EC RIGHT JOIN ((IMOB_Cliente C INNER JOIN IMOB_ClienteTipoVinculo CTV ON C.codigo = CTV.CodCliente) INNER JOIN IMOB_LocatarioImovelCliente LIC ON CTV.Codigo = LIC.codClienteTipoVinculo) ON EC.Codigo = C.CodEstadoCivil) ON LI.codigo = LIC.codLocatarioImovel "
	sql = sql & " WHERE LI.codigo="& intCodLocatarioImovel
	sql = sql & " and C.CodEmpresa = " & session("codEmpresa")
	rs.open sql, cnn, 3, 1
	if rs.eof = false then
		contLoc = 0
		dim vetLocatario()
		numeroLocatario = cint(rs.recordcount)
		redim vetLocatario(numeroLocatario-1)
		
		dim vetLocatarioConjuge()
		redim vetLocatarioConjuge(numeroLocatario-1)
		
		while not rs.eof
		
			strTipoFiador 				= trim(rs("tipoFiador"))
			strValorFianca 				= trim(rs("valorFianca"))
			strLocatario				= rs("locatario")
			vetLocatario(contLoc)		= rs("locatario")
			strTipoPessoa				= rs("tipo_pessoa")
			strProfissaoLocatario 		= UCASE(rs("profissao"))
			strEstadoCivilLocatario 	= UCASE(rs("estadocivil"))
			strCPFLocatario 			= rs("cic")
			strRGLocatario	 			= rs("rg")
			strOrgaoExpedidorLocatario	= rs("orgaoExp")
			strEnderecoLocatario		= rs("endereco")
			strBairroLocatario 			= rs("bairro")
			strCepLocatario 			= rs("cep")
			vetLocatarioConjuge(contLoc)= ucase(rs("NomeCompletoConjuge"))

			if strTipoPessoa = "F" then
			%>
				  <tr> 
					<td colspan="3" class="textoRelatorio"><hr size="1" color="#CCCCCC"></td>
				  </tr>
				  <tr> 
					<td width="23%" class="textoRelatorio"><strong>NOME</strong></td>
					<td colspan="2" class="textoRelatorio"><strong>: <%=strLocatario%></strong></td>
				  </tr>
				  <tr> 
					<td width="23%" class="textoRelatorio"><strong>NACIONALIDADE</strong></td>
					<td colspan="2" class="textoRelatorio"><strong>: BRASILEIRO(a)</strong></td>
				  </tr>
				  <tr> 
					<td width="23%" class="textoRelatorio"><strong>ESTADO CIVIL</strong></td>
					<td colspan="2" class="textoRelatorio"><strong>:</strong> <%=strEstadoCivilLocatario%></td>
				  </tr>
				  <tr> 
					<td width="23%" class="textoRelatorio"><strong>PROFISS&Atilde;O</strong></td>
					<td colspan="2" class="textoRelatorio"><strong>:</strong> <%=strProfissaoLocatario%></td>
				  </tr>
				  <tr> 
					<td width="23%" class="textoRelatorio"><strong>C.I. (RG)</strong></td>
					<td colspan="2" class="textoRelatorio"><strong>:&nbsp;<%=strRGLocatario%>, <%=strOrgaoExpedidorLocatario%></strong></td>
				  </tr>
				  <tr> 
					<td width="23%" class="textoRelatorio"><strong>CPF</strong></td>
					<td colspan="2" class="textoRelatorio"><strong>: <%=strCPFLocatario%></strong></td>
				  </tr>
				 
			<%if left(strEstadoCivilLocatario,6) = "CASADO" then%>
			
					<%
					strConjuge				= ucase(rs("NomeCompletoConjuge"))
					strProfissaoConjuge 	= UCASE(rs("profissaoconjuge"))
					strCPFConjuge 			= rs("cpfConjuge")
					strRGConjuge	 		= rs("RgConjuge")
					strNacionalidadeConjuge	= UCASE(rs("NacionalidadeConjuge"))
					strOrgaoExpedidorConjuge= UCASE(rs("OrgaoExpConjuge"))
					%>
				  
				  <tr> 
					<td colspan="3" class="textoRelatorio"><hr size="1" color="#CCCCCC"></td>
				  </tr>
				  <tr> 
					<td width="23%" class="textoRelatorio"><strong>NOME DO CONUGE</strong></td>
					<td colspan="2" class="textoRelatorio"><strong>: <%=strConjuge%></strong></td>
				  </tr>
				  <tr> 
					<td width="23%" class="textoRelatorio"><strong>NACIONALIDADE</strong></td>
					<td colspan="2" class="textoRelatorio"><strong>: <%=strNacionalidadeConjuge%></strong></td>
				  </tr>
				  <tr> 
					<td width="23%" class="textoRelatorio"><strong>PROFISS&Atilde;O</strong></td>
					<td colspan="2" class="textoRelatorio"><strong>:</strong> <%=strProfissaoConjuge%></td>
				  </tr>
				  <tr> 
					<td width="23%" class="textoRelatorio"><strong>C.I. (RG)</strong></td>
					<td colspan="2" class="textoRelatorio"><strong>:&nbsp;<%=strRGConjuge%>, <%=strOrgaoExpedidorConjuge%></strong></td>
				  </tr>
				  <tr> 
					<td width="23%" class="textoRelatorio"><strong>CPF</strong></td>
					<td colspan="2" class="textoRelatorio"><strong>: <%=strCPFConjuge%></strong></td>
				  </tr>
	
			<%end if%>
	
<%else%>
  <tr> 
    <td colspan="3" class="textoRelatorio"><hr size="1" color="#CCCCCC"></td>
  </tr>
  <tr> 
    <td width="23%" class="textoRelatorio"><strong>RAZÃO SOCIAL</strong></td>
    <td colspan="2" class="textoRelatorio"><strong>: <%=strLocatario%></strong></td>
  </tr>
  <tr> 
    <td width="23%" class="textoRelatorio"><strong>CNPJ</strong></td>
    <td colspan="2" class="textoRelatorio"><strong>: <%=strCPFLocatario%></strong></td>
  </tr>
<%end if%>
  <tr> 
    <td class="textoRelatorio">&nbsp;</td>
    <td colspan="2" class="textoRelatorio">&nbsp;</td>
  </tr>
  <%
			contLoc = contLoc + 1
			rs.movenext
		wend
	end if
	rs.close
%>
  <tr> 
    <td colspan="3" class="textoRelatorio"><hr size="1" color="#CCCCCC"></td>
  </tr>
  <tr> 
    <td height="25" colspan="3" class="textoRelatorio"><p><strong>3 - D E S C R I &Ccedil; &Atilde; O &nbsp;&nbsp;D O&nbsp;&nbsp; I M &Oacute; V E L</strong></p></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><hr size="1" color="#CCCCCC"></td>
  </tr>
  <tr> 
    <td width="23%" class="textoRelatorio"><strong>ENDERE&Ccedil;O</strong></td>
    <td colspan="2" class="textoRelatorio"><strong>:</strong> <%=strEnderecoImovel%></td>
  </tr>
  <tr> 
    <td width="23%" class="textoRelatorio"><strong>SETOR/BAIRO</strong></td>
    <td colspan="2" class="textoRelatorio"><strong>:</strong> <%=strBairroImovel%></td>
  </tr>
  <tr> 
    <td width="23%" class="textoRelatorio"><strong>CIDADE</strong></td>
    <td colspan="2" class="textoRelatorio"><strong>:</strong> <%=strMunicipioImovel%></td>
  </tr>
  <tr> 
    <td width="23%" class="textoRelatorio"><strong>ESPECIE</strong></td>
    <td colspan="2" class="textoRelatorio"><strong>:</strong> <%=strDestinoLocacao%></td>
  </tr>
  <tr> 
    <td width="23%" class="textoRelatorio"><strong>DESCRI&Ccedil;&Atilde;O</strong></td>
    <td colspan="2" class="textoRelatorio"><strong>:</strong> <%=strObjeto%></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><hr size="1" color="#CCCCCC"></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><strong>4 - V A L O R&nbsp;&nbsp; D O&nbsp;&nbsp; A L U G U E L&nbsp;&nbsp; M E N S A L&nbsp;&nbsp;&nbsp;&nbsp; 
      E&nbsp;&nbsp;&nbsp; D A T A &nbsp;D E&nbsp; V E N C I M E N T O </strong></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><hr size="1" color="#CCCCCC"></td>
  </tr>
  <tr> 
    <td class="textoRelatorio"><strong>VALOR ALUGUEL</strong></td>
    <td colspan="2" class="textoRelatorio"><strong>:</strong>&nbsp;<strong><%=strValorAluguelReajuste%>&nbsp;(<%=Extenso(strValorAluguelReajuste)%>)</strong></td>  </tr>
  <tr> 
    <td class="textoRelatorio"><strong>DATA VENCIMENTO</strong></td>
    <td colspan="2" class="textoRelatorio"><strong>:</strong>&nbsp;<strong><%=strDataVencimentoReajuste%></strong></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><hr size="1" color="#CCCCCC"></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><p><strong>5 - P R A Z O</strong></p></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><hr size="1" color="#CCCCCC"></td>
  </tr>
  <tr> 
    <td class="textoRelatorio"><strong>N. DE MESES</strong></td>
    <td colspan="2" class="textoRelatorio"><strong>:</strong> <%=strQtdeMesesReajuste%>&nbsp;(<%=trim(replace(replace(Extenso(strQtdeMesesReajuste),"reais",""),"real",""))%>)</td>
  </tr>
  <tr> 
    <td class="textoRelatorio"><strong>IN&Iacute;CIO</strong></td>
    <td colspan="2" class="textoRelatorio"><strong>:</strong> <%=strDataInicioReajuste%></td>
  </tr>
  <tr> 
    <td class="textoRelatorio"><p><strong>T&Eacute;RMINO</strong></p></td>
    <td colspan="2" class="textoRelatorio"><strong>:</strong> <%=strDataFinalReajuste%></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><hr size="1" color="#CCCCCC"></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><p><strong>6 - R E A J U S T E&nbsp;&nbsp; 
        D O&nbsp;&nbsp; A L U G U E L</strong></p></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><hr size="1" color="#CCCCCC"></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><strong>CONFORME CONTRATO DE LOCA&Ccedil;&Atilde;O INICIAL</strong></td>
  </tr>
  
  <tr> 
    <td colspan="3" class="textoRelatorio"><p><strong> </strong></p></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><hr size="1" color="#CCCCCC"></td>
  </tr>
  <%
  if strTipoFiador = "F" then strDescFiadorCaucao = "8 - F I A D O R E S"
  if strTipoFiador = "V" then strDescFiadorCaucao = "8 - C A U Ç Ã O "
  %>
  <tr> 
    <td colspan="3" class="textoRelatorio"><strong><%=strDescFiadorCaucao%></strong></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><hr size="1" color="#CCCCCC"></td>
  </tr>
  <%
	  if strTipoFiador = "V" then
	  %>
  <tr> 
    <td width="23%" class="textoRelatorio"><strong>VALOR CAUÇÃO</strong></td>
    <td colspan="2" class="textoRelatorio"><strong>: <%=FORMATNUMBER(strValorFianca,2)%>&nbsp; (<%=Extenso(FORMATNUMBER(strValorFianca,2))%>)</strong></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><hr size="1" color="#CCCCCC"></td>
  </tr>
  <%
	  else
		sql = " SELECT C.codigo AS codCliente, C.NomeCompleto_RazaoSocial AS fiador, C.NomeCompletoConjuge AS NomeConjuge, C.Profissao, EC.Descricao AS EstadoCivil, C.Cpf_Cnpj AS cic, C.RG, C.OrgaoExp AS OrgaoExp, C.Endereco, C.Bairro, C.CEP, C.Cidade AS municipio, C.UF, C.CPFConjuge, C.RGConjuge, C.OrgaoExpConjuge AS OrgaoExpedidorConjuge "
		sql = sql & " FROM IMOB_EstadoCivil EC RIGHT JOIN ((IMOB_Cliente C INNER JOIN IMOB_ClienteTipoVinculo CTV ON C.codigo = CTV.CodCliente) INNER JOIN IMOB_ClienteFiador CF ON CTV.Codigo = CF.codClienteTipoVinculo) ON EC.Codigo = C.CodEstadoCivil "
		sql = sql & " WHERE CF.codLocatarioImovel="& intCodLocatarioImovel
		sql = sql & " and C.CodEmpresa = " & session("codEmpresa")
		rs.open sql, cnn
		if rs.eof = false then
			while not rs.eof 
				strFiador	= rs("fiador")
				strFiadorConjuque	= rs("NomeConjuge")
				
				strProfissaoFiador 	= rs("profissao")
				strEstadoCivilFiador 	= rs("estadocivil")
				strCPFFiador 			= rs("cic")
				strCPFConjuque 			= rs("cpfConjuge")
				strRGFiador 			= rs("rg")
				strRGConjuque 			= rs("rgConjuge")
				strOrgaoExpedidorFiador= rs("orgaoExp")
				strOrgaoExpedidorConjuque= rs("OrgaoExpedidorConjuge")
				strEnderecoFiador		= rs("endereco")
				strBairroFiador 		= rs("bairro")
				strMunicipioFiador 		= rs("municipio")
				strCepFiador 			= rs("cep")
				%>
  <tr> 
    <td class="textoRelatorio"><strong>NOME</strong></td>
    <td colspan="2" class="textoRelatorio"><strong>:</strong> <%=strFiador%></td>
  </tr>
  <tr> 
    <td class="textoRelatorio"><strong>NACIONALIDADE</strong></td>
    <td colspan="2" class="textoRelatorio"><strong>:</strong> Brasileiro(a)</td>
  </tr>
  <tr> 
    <td class="textoRelatorio"><strong>ESTADO CIVIL</strong></td>
    <td colspan="2" class="textoRelatorio"><strong>:</strong> <%=strEstadoCivilFiador%></td>
  </tr>
  <tr> 
    <td class="textoRelatorio"><strong>PROFISS&Atilde;O</strong></td>
    <td colspan="2" class="textoRelatorio"><strong>:</strong> <%=strProfissaoFiador%></td>
  </tr>
  <tr> 
    <td class="textoRelatorio"><p><strong>C&Eacute;D.IDENTIDADE</strong></p></td>
    <td colspan="2" class="textoRelatorio"><strong>:</strong> <%=strRGFiador%></td>
  </tr>
  <tr> 
    <td class="textoRelatorio"><strong>CPF/CNPJ/MF</strong></td>
    <td colspan="2" class="textoRelatorio"><strong>:</strong> <%=strCPFFiador%></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><hr size="1" color="#CCCCCC"></td>
  </tr>
  <%	'if strFiadorConjuque <> "" and not isnull(strFiadorConjuque) then	%>
  <%	'end if																%>
  <%
				rs.movenext
			wend
		end if
		rs.close
	  end if
	  %>
  <tr> 
    <td colspan="3" class="textoRelatorio"><div align="justify"> 
        <p><br>
        As partes supra qualificadas s&atilde;o signat&aacute;rias do contrato de loca&ccedil;&atilde;o do im&oacute;vel acima mencionado e por via do presente, resolvem de comum acordo renovar o prazo de loca&ccedil;&atilde;o por mais <%=Cint(strQtdeMesesReajuste)%>&nbsp;(<%=trim(replace(replace(Extenso(strQtdeMesesReajuste),"reais",""),"real",""))%>) meses com reajuste anual corrigido pelo IGPM.</p>
      </div></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><div align="justify">&nbsp;</div></td>
  </tr>
  
  <tr> 
    <td colspan="3" class="textoRelatorio"></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><div align="justify">1 - 0 aluguel ajustado ser&aacute; no valor de R$
        <%=strValorAluguel%> mensais.</div></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><div align="justify"></div></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><div align="justify"> 
        <p>2 - Face ao exposto no artigo 1208 do C&oacute;digo Civil Brasileiro, o LOCAT&Aacute;RIO autoriza desde j&aacute; que o SEGURO DE INC&Ecirc;NDIO lhe seja cobrado juntamente com o primeiro aluguel da renova&ccedil;&atilde;o, bem como a cada 12 meses de loca&ccedil;&atilde;o, e at&eacute; a efetiva devolu&ccedil;&atilde;o do im&oacute;vel.</p>
      </div></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><div align="justify"></div></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><div align="justify">3 - A presente locação é regida pela Lei Federal nr. 8.245/81;</div></td>
  </tr>
   <tr> 
    <td colspan="3" class="textoRelatorio"><div align="justify"></div></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><div align="justify">4 - Depois de lido e por estarem assim justos e contratados, assinam o presente em 02 (duas) vias de igual teor e forma, na presença de duas testemunhas, tudo de acordo com a lei. As partes contratantes elegem o Foro da Comarca de Goiânia(GO) para dirimir todas as questões contratuais;</div></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><div align="justify"></div></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><div align="justify"> 
        <p>5 - A multa pactuada para a rescis&atilde;o desse contrato, &eacute; de; 10% da soma do aluguel dos meses faltantes para o t&eacute;rmino do contrato.</p>
    </div></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><div align="justify">&nbsp;</div></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><div align="justify"><strong>PAR&Aacute;GRAFO PRIMEIRO</strong> - Sendo o contrato firmado por prazo igual ou superior a 30 meses,  as partes contratantes ficar&atilde;o isentas do pagamento da multa de rescis&atilde;o contratual,  desde que a parte interessada NOTIFIQUE a outra, por escrito, no prazo de 30 (trinta) dias antes do vencimento da 12&ordf; (d&eacute;cima segunda) parcela de aluguel, ou seja, nestes casos a rescis&atilde;o sem multa somente poder&aacute; ocorrer no 12&deg; (d&eacute;cimo segundo) m&ecirc;s de loca&ccedil;&atilde;o. </div></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><div align="justify"></div></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><div align="justify"> 
        <p>5 - Neste ato, as partes ratificam todas as cl&aacute;usulas do CONTRATO DE  LOCA&Ccedil;&Atilde;O  que  n&atilde;o  conflitarem  com  o  presente  TERMO  ADITIVO, permanecendo, as mesmas em pleno vigor. </p>
      </div></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><div align="justify"></div></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><div align="justify">E assim por estarem justos e acordados, assinam o presente termo, na presen&ccedil;a de duas testemunhas presenciais ao ato e que tamb&eacute;m o assinam.</div></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><div align="justify"></div></td>
  </tr>
  
  
  <tr> 
    <td colspan="3" class="textoRelatorio">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio"><strong>Goi&acirc;nia, <%=day(strDataInicioReajuste)%> de <%=monthname(month(strDataInicioReajuste))%> de <%=year(strDataInicioReajuste)%>. </strong></td>
  </tr>
  <tr> 
    <td colspan="3" class="textoRelatorio">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="3" align="center" class="textoRelatorio">_______________________________________</td>
  </tr>
  <tr> 
    <td colspan="3" align="center" class="textoRelatorio"><strong><%=session("strRazaoSocial")%></strong></td>
  </tr>
  <tr> 
    <td colspan="3" align="center" class="textoRelatorio">LOCADOR</td>
  </tr>
  <%for i=0 to ubound(vetLocatario)%>
  
  <tr> 
    <td colspan="3" class="textoRelatorio">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="3" align="center" class="textoRelatorio">_______________________________________</td>
  </tr>
  <tr> 
    <td colspan="3" align="center" class="textoRelatorio"><strong><%=vetLocatario(i)%></strong></td>
  </tr>
  <tr> 
    <td colspan="3" align="center" class="textoRelatorio">LOCAT&Aacute;RIO(A)</td>
  </tr>
  
	<%if vetLocatarioConjuge(i) <> "" then%>
	  <tr> 
		<td colspan="3" class="textoRelatorio">&nbsp;</td>
	  </tr>
	  <tr> 
		<td colspan="3" align="center" class="textoRelatorio">_______________________________________</td>
	  </tr>
	  <tr> 
		<td colspan="3" align="center" class="textoRelatorio"><strong><%=vetLocatarioConjuge(i)%></strong></td>
	  </tr>
	  <tr> 
		<td colspan="3" align="center" class="textoRelatorio">LOCAT&Aacute;RIO(A)</td>
	  </tr>
	<%end if%>
	
  <%next%>
  <%
	sql = "SELECT C.codigo AS codCliente, C.NomeCompleto_RazaoSocial as fiador, C.NomeCompletoConjuge as NomeConjuge "
	sql = sql & " FROM IMOB_EstadoCivil EC RIGHT JOIN ((IMOB_Cliente C INNER JOIN IMOB_ClienteTipoVinculo CTV ON C.codigo = CTV.CodCliente) INNER JOIN IMOB_ClienteFiador CF ON CTV.Codigo = CF.codClienteTipoVinculo) ON EC.Codigo = C.CodEstadoCivil "
	sql = sql & " WHERE CF.codLocatarioImovel="& intCodLocatarioImovel
	sql = sql & " and C.CodEmpresa = " & session("codEmpresa")
		rs.open sql, cnn
		if rs.eof = false then
			while not rs.eof 
				strFiador	= rs("fiador")
				strFiadorConjuque	= rs("NomeConjuge")
				%>
  <tr> 
    <td colspan="3" class="textoRelatorio">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="3" align="center" class="textoRelatorio">_______________________________________</td>
  </tr>
  <tr> 
    <td colspan="3" align="center" class="textoRelatorio"><strong><%=strFiador%></strong></td>
  </tr>
  <tr> 
    <td colspan="3" align="center" class="textoRelatorio">FIADOR(A)</td>
  </tr>
  <%	if strFiadorConjuque <> "" and not isnull(strFiadorConjuque) then	%>
  <tr> 
    <td colspan="3" align="center" class="textoRelatorio">&nbsp;</td>
  </tr>
  <%	end if
			  	%>
  <%
				rs.movenext
			wend
		end if
		rs.close
		%>
  <tr> 
    <td colspan="3" align="center" class="textoRelatorio">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="3" align="center" class="textoRelatorio">TESTEMUNHAS:</td>
  </tr>
  <tr> 
    <td colspan="3" align="center" class="textoRelatorio">01)___________________________    </td>
  </tr>
  <tr> 
    <td height="37" colspan="3" align="center" class="textoRelatorio">02)___________________________</td>
  </tr>
</table>
</body>
</html>
