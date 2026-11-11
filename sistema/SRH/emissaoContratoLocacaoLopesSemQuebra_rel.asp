<%
if request("w") = "" then
	Response.Buffer = false
end if
Server.ScriptTimeOut = 9999
intNumContrato	= Trim(Request("txtNumContrato"))

nomeDocSalvo = "contrato" & intNumContrato
%>
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="css/Estilo_Impressao.css" rel="stylesheet" type="text/css">
<script src="js/js_funcoes_gerais.js"></script>
<script src="js/barraMovel.js"></script>
<style type="text/css">
<!--
.textoRelatorioContrato {font-family:"Times New Roman"; font-size:16px}
.style1 {color: #FF0000}
.style2 {font-size: 9px}
.style3 {font-size: 10px}
-->
</style>
</head>
<%

	intNumPagina 	= 1
	strPaginaWord = "emissaoContratoLocacaoLopesSemQuebra_rel.asp?W=S&txtNumContrato=" & intNumContrato
	
%>
<!--#include file="includes/inc_Botoes_relatorio_word.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_extenso.asp"-->
<!--#include file="includes/inc_formataData.asp"-->
<body>
<%
	if trim(intNumContrato) <> "" then
		sql = " SELECT C.NumPasta, C.NumContrato, C.codLocatarioImovel, C.dataInicio, C.dataFim, C.obs_valor_aluguel, "
		sql = sql & " C.meses, C.dataAssinatura, C.DataAluguel, C.DataRepasse, IL.codImovel, LI.tipoFiador "
		sql = sql & " FROM IMOB_ImovelLocador IL INNER JOIN (IMOB_LocatarioImovel LI INNER JOIN IMOB_contrato C "
		sql = sql & " ON LI.codigo = C.codLocatarioImovel) ON IL.codigo = LI.codImovelLocador "
		sql = sql & " WHERE C.NumContrato=" & intNumContrato
		sql = sql & " and C.CodEmpresa = " & session("codEmpresa")
		'response.write sql
		rs.open sql, cnn
		if rs.eof = false then
			obs_valor_aluguel		= rs("obs_valor_aluguel")
			intCodImovel			= rs("codImovel")
			intCodLocatarioImovel	= rs("codLocatarioImovel")
			strQtdeMeses			= rs("meses")
			intNumPasta				= rs("NumPasta")
			strDataAssinatura		= formatadataAP(rs("dataAssinatura"))
			strDataInicio			= formatadataAP(rs("dataInicio"))
			strDataFinal			= formatadataAP(rs("dataFim"))
			strDiaVencimento		= day(rs("DataAluguel"))
			strDataVencimento		= formatadataAP(rs("DataAluguel"))
			rs.close
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

	strNumTotalPaginas = "/8"
	strLinhaVertical = "N"
  %>
<br>
<div align="center" style="width:780px"> 
<div align="center" style="width:700px"> 
<div class="textoRelatorioContrato" align="center">
<!--#include file="includes/inc_cabecalhoRelatorioContrato.asp"-->
</div>
<br> 
<div class="textoRelatorioContrato" align="center"><strong>CONTRATO DE LOCAÇÃO &nbsp;- &nbsp;&nbsp;CONTRATO N&ordm;. <%=intNumContrato%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;PASTA N&ordm;. <%=intNumPasta%></strong>&nbsp;
<%
	'busca imovel/proprietario
	sql = "SELECT IL.codigo AS CodImovelLocador, I.ValorAluguel, I.ValorRepasse, I.codigo AS codImovel, TS.Descricao AS TipoServico, TI.Descricao AS TipoImovel, TC.Descricao AS categoria, I.tipo, I.situacao, I.endereco, I.bairro, I.municipio, I.codTipoServico, I.codTipoImovel, I.uf, C.NomeCompleto_RazaoSocial AS Proprietario, C.Profissao, EC.Descricao AS estadocivil, C.Cpf_Cnpj AS cic, C.RG, C.OrgaoExp AS OrgaoExp, C.Endereco AS enderecoLocador, C.Bairro AS bairroLocador, C.CEP AS cepLocador, C.Cidade AS municipioLocador, C.UF AS ufLocador "
	sql = sql & " FROM IMOB_TipoServico TS RIGHT JOIN ((IMOB_TipoCategoria TC RIGHT JOIN IMOB_TipoImovel TI ON TC.Codigo = TI.CodCategoria) RIGHT JOIN ((IMOB_Imovel I LEFT JOIN IMOB_ImovelLocador IL ON I.codigo = IL.codImovel) LEFT JOIN (IMOB_EstadoCivil EC RIGHT JOIN ((IMOB_Cliente C RIGHT JOIN IMOB_ClienteTipoVinculo CTV ON C.codigo = CTV.CodCliente) RIGHT JOIN IMOB_ImovelLocadorProprietario ILP ON CTV.Codigo = ILP.codClienteTipoVinculo) ON EC.Codigo = C.CodEstadoCivil) ON IL.codigo = ILP.codImovelLocador) ON TI.Codigo = I.codTipoImovel) ON TS.Codigo = I.codTipoServico "
	sql = sql & " Where I.Codigo = " & intCodImovel 
	sql = sql & " AND 	IL.situacao = 'A'" 'ativo
	sql = sql & " and C.CodEmpresa = " & session("codEmpresa")
	rs.open sql, cnn,3 ,1
	if rs.eof = false then
		intCodImovel		= Trim(Rs("codImovel"))
		strDescricaoImovel = " "
		if not isnull(rs("endereco")) then
			strObjeto = trim(rs("tipoImovel"))
			strDestinoLocacao = trim(rs("categoria"))
			strEnderecoImovel = rs("endereco")
			if not isnull(rs("bairro")) then strEnderecoImovel = strEnderecoImovel & ", " & rs("bairro")
			if not isnull(rs("municipio")) then strEnderecoImovel = strEnderecoImovel & ", " & rs("municipio") & "-GO"
		end if
		strValorAluguel			= formatNumber(Trim(Rs("ValorAluguel")),2)
		strValorRepasse			= formatNumber(Trim(Rs("ValorRepasse")),2)
		strProprietario = ""
		contLoc = 0
		dim vetLocador()
		numeroLocador = cint(rs.recordcount)
		redim vetLocador(numeroLocador-1)		
		while not rs.eof
			strProfissaoLocador 	= rs("profissao")
			strEstadoCivilLocador 	= rs("estadocivil")
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
			vetLocador(contLoc)	=	rs("Proprietario")
%>
		  <p align="justify"  class="textoRelatorioContrato"><strong>1. LOCADOR(A):&nbsp;<%=strProprietario%>&nbsp;, </strong>brasileiro(a), <%=strEstadoCivilLocador%>(a), <%=strProfissaoLocador%>, portador da carteira de identidade n. <%=strRGLocador%>, <%=strOrgaoExpedidorLocador%>, CPF n. <%=strCPFLocador%>, residente e domiciliado (a) nesta capital.<br>
		  
<%				
			contLoc = contLoc + 1
			rs.movenext
		wend
	end if
	rs.close
	%>
	  <div align="justify"  class="textoRelatorioContrato">Representando por sua bastante procurador, <strong><%=ucase(session("strRazaoSocialCompleto"))%></strong>, pessoa juridica, devidamente inscrita no CNPJ: <%=session("strCnpj")%> e no Creci-Juridico: <%=session("strCreci")%>, denominada simplesmente&nbsp;<strong><%=ucase(session("strRazaoSocial"))%></strong>, com sede na cidade de Goi&acirc;nia, estado de Goi&aacute;s</div>	
	  
	<%
	'busca locatario
	strLocatario = ""
	sql = "SELECT LI.codigo, IL.codImovel, LI.tipoFiador, LI.valorFianca, LI.GARANTIALOCATICIA, c.NacionalidadeConjuge, C.NomeCompleto_RazaoSocial AS locatario, C.Cpf_Cnpj AS cic, C.RG, C.OrgaoExp AS OrgaoExp, C.CPFConjuge, C.RGConjuge, C.OrgaoExpConjuge, c.profissaoconjuge, C.Endereco, C.Bairro, C.CEP, C.Cidade AS municipio, C.UF, C.Profissao, EC.Descricao AS EstadoCivil, C.NomeCompletoConjuge  "
	sql = sql & " FROM (IMOB_ImovelLocador IL INNER JOIN IMOB_LocatarioImovel LI ON IL.codigo = LI.codImovelLocador) INNER JOIN (IMOB_EstadoCivil EC RIGHT JOIN ((IMOB_Cliente C INNER JOIN IMOB_ClienteTipoVinculo CTV ON C.codigo = CTV.CodCliente) INNER JOIN IMOB_LocatarioImovelCliente LIC ON CTV.Codigo = LIC.codClienteTipoVinculo) ON EC.Codigo = C.CodEstadoCivil) ON LI.codigo = LIC.codLocatarioImovel "
	sql = sql & " WHERE LI.codigo="& intCodLocatarioImovel
	sql = sql & " and C.CodEmpresa = " & session("codEmpresa")
	rs.open sql, cnn, 3, 1
	if rs.eof = false then
		contLoc = 0
		dim vetLocatario()
		dim vetLocatarioConjuge()
		numeroLocatario = cint(rs.recordcount)
		redim vetLocatario(numeroLocatario-1)
		redim vetLocatarioConjuge(numeroLocatario-1)
		while not rs.eof
			strTipoFiador 			= trim(rs("tipoFiador"))
			strValorFianca 			= trim(rs("valorFianca"))
			strLocatario			= rs("locatario")
			strCPFLocatario			= rs("cic")
			vetLocatario(contLoc)	=	rs("locatario")
			vetLocatarioConjuge(contLoc)	=	ucase(rs("NomeCompletoConjuge"))
			strConjuge				= ucase(rs("NomeCompletoConjuge"))
			strGarantialocaticia 	= rs("GARANTIALOCATICIA")
			strProfissaoLocatario 	= rs("profissao")
			strProfissaoConjuge 	= rs("profissaoconjuge")
			strEstadoCivilLocatario = rs("estadocivil")
			strCPFLocatario 		= rs("cic")
			strRGLocatario	 		= rs("rg")
			strCPFConjuge 			= rs("cpfConjuge")
			strRGConjuge	 		= rs("RgConjuge")
			strNacionalidadeConjuge	= rs("NacionalidadeConjuge")
			strOrgaoExpedidorLocatario= rs("orgaoExp")
			strOrgaoExpedidorConjuge= rs("OrgaoExpConjuge")
			strEnderecoLocatario	= rs("endereco")
			strBairroLocatario 		= rs("bairro")
			strCepLocatario 		= rs("cep")
			strEnderecoCompletoLocatario = strEnderecoLocatario
			if not isnull(rs("bairro")) then strEnderecoCompletoLocatario = strEnderecoCompletoLocatario & ", " & rs("bairro")
			if not isnull(rs("municipio")) and rs("municipio") <> "" then strEnderecoCompletoLocador = strEnderecoCompletoLocador & ", " & rs("municipio") 
			if not isnull(rs("uf")) and rs("uf") <> "" then strEnderecoCompletoLocador = strEnderecoCompletoLocador & ", " & rs("uf") 
			if not isnull(rs("cep")) and rs("cep") <> "" then strEnderecoCompletoLocatario = strEnderecoCompletoLocatario & ", " & rs("cep") 
			%>
	   
			<%if len(strCPFLocatario)=18 then%>
                <div align="justify"  class="textoRelatorioContrato"><strong><br>2. LOCAT&Aacute;RIO(A): <%=strLocatario%>, </strong>inscritos no CNPJ nº.: <%=strCPFLocatario%>.</div>
            <%else%>
                <%if strEstadoCivilLocatario="Solteiro(a)" then%>
                	<div align="justify"  class="textoRelatorioContrato"><strong><br>2. LOCAT&Aacute;RIO(A): <%=strLocatario%>, </strong>brasileiro(a), <%=strEstadoCivilLocatario%>, <%=strProfissaoLocatario%>, portador da carteira de identidade n. <%=strRGLocatario%>, <%=strOrgaoExpedidorLocatario%>, CPF n. <%=strCPFLocatario%>, residente e domiciliado (a) nesta capital.</div>
                <%else%>
                	<div align="justify"  class="textoRelatorioContrato"><strong><br>2. LOCAT&Aacute;RIO(A): <br><%=strLocatario%>, </strong>brasileiro(a), <%=strEstadoCivilLocatario%>, <%=strProfissaoLocatario%>, portador da carteira de identidade n. <%=strRGLocatario%>, <%=strOrgaoExpedidorLocatario%>, CPF n. <%=strCPFLocatario%>, residente e domiciliado (a) nesta capital.</div>
                	<div align="justify"  class="textoRelatorioContrato"><strong><%=strConjuge%>, </strong><%=strNacionalidadeConjuge%>, <%if strEstadoCivilLocatario<>"Divorciado(a)" then%><%=strEstadoCivilLocatario%>, <%end if%><%=strProfissaoConjuge%>, <%=strRGConjuge%>, <%=strOrgaoExpedidorConjuge%>, <%if strCPFConjuge<>"" then%><%=strCPFConjuge%>, <%end if%>residente e domiciliado (a) nesta capital.</div>
                <%end if%>
            <%end if%>
	  		
			<%				
			contLoc = contLoc + 1
			rs.movenext
		wend
	end if
	rs.close
%>
<div align="justify"  class="textoRelatorioContrato">
<br>
	  <strong>3. IM&Oacute;VEL: </strong><%=strObjeto%>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;<strong>ENDERE&Ccedil;O DO IM&Oacute;VEL:</strong> <%=strEnderecoImovel%>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;<strong>UTILIZA&Ccedil;&Atilde;O</strong>: <%=ucase(strDestinoLocacao)%>
<br>
<br>
	  <strong>4. VALOR DO ALUGUEL:</strong> <%=strValorAluguel%>&nbsp;(<%=Extenso(strValorAluguel)%>)<%=trim(obs_valor_aluguel)%>
<br>
<br>
	  <strong>5. PRAZO:</strong> <%=strQtdeMeses%>&nbsp;(<%=trim(ExtensoDia(strQtdeMeses))%>) Meses
<br>
&nbsp;&nbsp;&nbsp;&nbsp;IN&Iacute;CIO: <%=strDataInicio%>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;T&Eacute;RMINO: <%=strDataFinal%>
<br>
<br>
<strong>6. REAJUSTE:</strong> CONFORME CLAUSULA TERCEIRA
<br>
  <%
  if strTipoFiador = "F" then strDescFiadorCaucao = "<br><strong>7. FIADOR(ES)</strong>&nbsp;"
  if strTipoFiador = "V" then strDescFiadorCaucao = "<br><strong>7. CAUÇÃO</strong>&nbsp;"
  %>
  <%=strDescFiadorCaucao%>
  
  <%
	  if strTipoFiador = "V" then
	  %>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;<strong>VALOR CAUÇÃO: <%=FORMATNUMBER(strValorFianca,2)%>&nbsp; (<%=Extenso(FORMATNUMBER(strValorFianca,2))%>)</strong>
<br>
<%=strGarantialocaticia%>
  <%
	  elseif strTipoFiador = "I" then
	  %>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;<%=strGarantialocaticia%>
   <%
	  else
		sql = " SELECT C.codigo AS codCliente, C.NomeCompleto_RazaoSocial AS fiador, C.NomeCompletoConjuge AS NomeConjuge, C.Profissao, EC.Descricao AS EstadoCivil, C.Cpf_Cnpj AS cic, C.RG, C.OrgaoExp AS OrgaoExp, C.Endereco, C.Bairro, C.CEP, C.Cidade AS municipio, C.UF, C.CPFConjuge, C.RGConjuge, C.OrgaoExpConjuge AS OrgaoExpedidorConjuge "
		sql = sql & " FROM IMOB_EstadoCivil EC RIGHT JOIN ((IMOB_Cliente C INNER JOIN IMOB_ClienteTipoVinculo CTV ON C.codigo = CTV.CodCliente) INNER JOIN IMOB_ClienteFiador CF ON CTV.Codigo = CF.codClienteTipoVinculo) ON EC.Codigo = C.CodEstadoCivil "
		sql = sql & " WHERE CF.codLocatarioImovel="& intCodLocatarioImovel
		sql = sql & " and C.CodEmpresa = " & session("codEmpresa")
		intContadorFiador = 0
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
				strRGConjuqe 			= rs("rgConjuge")
				strOrgaoExpedidorFiador= rs("orgaoExp")
				strOrgaoExpedidorConjuque= rs("OrgaoExpedidorConjuge")
				strEnderecoFiador		= rs("endereco")
				strBairroFiador 		= rs("bairro")
				strMunicipioFiador 		= rs("municipio")
				strCepFiador 			= rs("cep")
				%><br>&nbsp;&nbsp;&nbsp;&nbsp;- <%=strFiador%><%
				intContadorFiador = intContadorFiador + 1
				rs.movenext
			wend
		end if
		rs.close
	  end if
	  %>
</div>   
<br>
  <strong>DAS PARTES</strong>
  <div align="justify"  class="textoRelatorioContrato"> 
        <p>Os signat&aacute;rios ao final assinados, qualificados como  LOCADOR (ES) E LOCAT&Aacute;RIO, no QUADRO RESUMO (campos l e 2), tem entre si, certo  e ajustado na melhor forma de direito, a  loca&ccedil;&atilde;o do im&oacute;vel descrito no QUADRO RESUMO (campo 3), mediante as cl&aacute;usulas e  condi&ccedil;&otilde;es mutuamente aceitas e  outorgadas, a saber:</p>
      </div>


<%if strTipoFiador = "F" and trim(strGarantialocaticia)<>"" then%>
	 <div align="justify"  class="textoRelatorioContrato"> 
        <p><%=strGarantialocaticia%></p>
      </div>
	
<%end if%>

  <div align="justify"  class="textoRelatorioContrato"><strong>CL&Aacute;USULA  PRIMEIRA:</strong> O prazo de loca&ccedil;&atilde;o do presente contrato, ser&aacute; o que encontra-se especificado no  QUADRO RESUMO, (campo 5) devendo o LOCAT&Aacute;RIO no t&eacute;rmino, restituir o im&oacute;vel ora  locado completamente desocupado e em  perfeito estado de conserva&ccedil;&atilde;o,inclusive com pintura nova, obedecendo a  mesma qualidade e tonalidade de cor. (conforme laudo de vistoria inicial).</div>
  <div align="justify"  class="textoRelatorioContrato"> 
        <p><strong>CL&Aacute;USULA  SEGUNDA:&nbsp;</strong>O  valor do aluguel especificado no QUADRO RESUMO (campo 4), mais a tarifa  banc&aacute;ria que nesta data fixada em R$ 2,00, dever&atilde;o ser pagos at&eacute; a data do vencimento do aluguel,  em qualquer ag&ecirc;ncia banc&aacute;ria, atrav&eacute;s de &quot;boleto banc&aacute;rio&quot; emitido  pelo BANCO CONTRATADO PELA ADMINISTRADORA.</p>
      </div>
  <div align="justify"  class="textoRelatorioContrato"><strong>PAR&Aacute;GRAFO  PRIMEIRO</strong> - Caso o LOCAT&Aacute;RIO n&atilde;o receba o BOLETO para  pagamento do aluguel, com anteced&ecirc;ncia m&iacute;nima de 05 (CINCO) dias antes do  vencimento, o mesmo se obriga e se compromete a procurar a ADMINISTRADORA, sito  a Avenida Mil&atilde;o, Qd. CP-13 Lt. 01, n&ordm;.  1693, Sala 1, Celina Park, Goi&acirc;nia &ndash; GO, no hor&aacute;rio banc&aacute;rio,  solicitando SEGUNDA VIA para pagamento no banco, sem quaisquer &ocirc;nus adicional,  desde que n&atilde;o ultrapasse a data do vencimento.</div>
  <div align="justify"  class="textoRelatorioContrato"> 
        <p><strong>PAR&Aacute;GRAFO  SEGUNDO - </strong>&Eacute;  terminantemente vedado de pleno direito, considerado nulo ou inexistente, o  pagamento de alugu&eacute;is e encargos realizados pelo LOCAT&Aacute;RIO atrav&eacute;s de ordens de  cr&eacute;dito ou de pagamento, remessa de cheques ou valores, depositados diretamente  em conta do LOCADOR OU ADMINISTRADORA, bem como por quaisquer outros meios que  n&atilde;o sejam, exatamente, aqueles pactuados neste contrato (cl&aacute;usula segunda).</p>
      </div>
  
  <div align="justify"  class="textoRelatorioContrato"> 
        <p><strong>PAR&Aacute;GRAFO TERCEIRO</strong> - Todos os  pagamentos, sejam eles de qualquer natureza, ser&atilde;o recebidos pelos BANCOS e/ou  pela IMOBILI&Aacute;RIA.</p>
      </div>
  <div align="justify"  class="textoRelatorioContrato">
      <p><strong>PAR&Aacute;GRAFO QUARTO</strong> - Durante a vig&ecirc;ncia  deste contrato, inclusive na sua prorroga&ccedil;&atilde;o, o locat&aacute;rio autoriza o locador,  atrav&eacute;s de sua administradora, a alterar ou incluir seus dados pessoais na  unidade consumidora pertencente &agrave; Ampla Eenergia e Serviços S.A. &ndash; ENEL  e &agrave;  Saneamento de Goi&aacute;s S/A &ndash; SANEAGO, relativamente ao im&oacute;vel objeto deste  contrato.</p>
    </div>
  <div align="justify"  class="textoRelatorioContrato">
      <p><strong>CL&Aacute;USULA TERCEIRA:</strong> As partes  estabelecem que o valor do aluguel ora contratado, ser&aacute; reajustado a cada 12  (DOZE) meses, independentemente de notifica&ccedil;&atilde;o ou aviso, tomando-se como &iacute;ndice  para tal reajuste, o IGPM-FGV (&Iacute;NDICE GERAL DE PRE&Ccedil;OS DO MERCADO), medido pela  Funda&ccedil;&atilde;o Get&uacute;lio Vargas, a partir do primeiro dia subsequente ao do m&ecirc;s  vencido, sem que isto importe em prorroga&ccedil;&atilde;o Contratual, e, na falta deste  &iacute;ndice, poder&aacute; ser utilizado qualquer outro que refuta a real infla&ccedil;&atilde;o do pa&iacute;s,  tamb&eacute;m medido pela FUNDA&Ccedil;&Atilde;O GET&Uacute;LIO VARGAS.</p>
    </div>
  <div align="justify"  class="textoRelatorioContrato">
      <p><strong>PAR&Aacute;GRAFO PRIMEIRO</strong> - Se em  virtude de lei subseq&uuml;ente, vier a ser admitida a corre&ccedil;&atilde;o do valor do aluguel  em periodicidade inferior &agrave; prevista na legisla&ccedil;&atilde;o vigente, &agrave; &eacute;poca de sua  celebra&ccedil;&atilde;o, concordam as partes, desde j&aacute;, e em car&aacute;ter irrevog&aacute;vel, que o  reajuste do aluguel e o seu indexador passar&atilde;o automaticamente a ser feita no  menor prazo que for permitido pela lei posterior.</p>
    </div>
  <div align="justify"  class="textoRelatorioContrato">
      <p><strong>PAR&Aacute;GRAFO SEGUNDO </strong>- Considerando  a exist&ecirc;ncia da defasagem de tempo entre a coleta dos pre&ccedil;os formadores do  &iacute;ndice pactuado e a data de sua publica&ccedil;&atilde;o, convencionam as partes, para efeito  de reajustamento do aluguel, adotar o IGP-M correspondente ao m&ecirc;s anterior ao  da assinatura deste instrumento e aqueles que correspondem aos meses anteriores  ao de compet&ecirc;ncia de cada aluguel.</p>
    </div>
  <div align="justify"  class="textoRelatorioContrato">
      <p><strong>PAR&Aacute;GRAFO TERCEIRO</strong> - Fica certo  e livremente compromissado entre as partes, que sempre que expirado o prazo  locat&iacute;cio ajustado, dever&aacute; o LOCAT&Aacute;RIO promover expressa renova&ccedil;&atilde;o do contrato,  por meio de aditivo ou novo contrato, bem como dever&aacute; promover a atualiza&ccedil;&atilde;o do  seu cadastro e do cadastro dos FIADORES, sob pena de configurar expressa  infra&ccedil;&atilde;o contratual, podendo inclusive ensejar na rescis&atilde;o contratual e  conseq&uuml;entemente no despejo do im&oacute;vel.</p>
    </div>
  <div align="justify"  class="textoRelatorioContrato"> 
        <p><strong>CL&Aacute;USULA QUARTA:</strong> O vencimento do aluguel  ora contratado ser&aacute; sempre no dia <%=strDiaVencimento%> (<%=ExtensoDia(strDiaVencimento)%>) de cada m&ecirc;s, sem qualquer  car&ecirc;ncia. </p>
      </div>
<div align="justify"  class="textoRelatorioContrato">
        <p><strong>CL&Aacute;USULA QUINTA:</strong> Acontecendo  o vencimento do aluguel em dias n&atilde;o &uacute;teis, o  mesmo poder&aacute; ser quitado no primeiro dia &uacute;til posterior sem qualquer multa ou juros.</p>
    </div>
  <div align="justify"  class="textoRelatorioContrato">
      <p><strong>CL&Aacute;USULA SEXTA:</strong> O pagamento do aluguel al&eacute;m do prazo estipulado na CL&Aacute;USULA QUARTA, bem como  quaisquer outros pagamentos efetuados pelo LOCADOR atrav&eacute;s da ADMINISTRADORA,  sujeitar&aacute; o LOCAT&Aacute;RIO a juros de mora de 1% (um por cento) ao m&ecirc;s, multa de 10%  (dez por cento), al&eacute;m de atualiza&ccedil;&atilde;o monet&aacute;ria no primeiro dia ap&oacute;s o  vencimento.</p>
    </div>
  <div align="justify"  class="textoRelatorioContrato"> 
        <p><strong>PAR&Aacute;GRAFO PRIMEIRO</strong> - O atraso no pagamento do  aluguel e encargos da loca&ccedil;&atilde;o superior a 10 (dez)  dias, sujeitar&aacute; o LOCAT&Aacute;RIO ao pagamento dos d&eacute;bitos conforme esta cl&aacute;usula, e,  ainda, ao pagamento dos honor&aacute;rios advocat&iacute;cios fixados em 10% (dez por cento)  sobre o total do d&eacute;bito apurado. Os honor&aacute;rios ser&atilde;o de 20% (vinte por cento)  sobre o total do d&eacute;bito apurado, se para o recebimento, for necess&aacute;rio  ajuizamento da a&ccedil;&atilde;o judicial, caso em que o d&eacute;bito ser&aacute; tamb&eacute;m acrescido das  custas judiciais.</p>
      </div>
  <div align="justify"  class="textoRelatorioContrato"> 
        <p><strong>CL&Aacute;USULA S&Eacute;TIMA:</strong> O LOCAT&Aacute;RIO  fica obrigado a devolver o im&oacute;vel ora locado, devidamente pintado na mesma  tonalidade e nas mesmas condi&ccedil;&otilde;es determinadas no RELAT&Oacute;RIO DE VISTORIA, que  fica fazendo parte integrante deste contrato, bem como ao pagamento dos  alugu&eacute;is e encargos da loca&ccedil;&atilde;o, at&eacute; a efetiva assinatura do distrato e entrega  de chaves a ADMINISTRADORA, ficando certo que a simples entrega das chaves &agrave;  ADMINISTRADORA, n&atilde;o configura efetiva devolu&ccedil;&atilde;o do im&oacute;vel. PAR&Aacute;GRAFO &Uacute;NICO - Fica  expressamente e definitivamente proibido ao LOCAT&Aacute;RIO, sob pena de rescis&atilde;o  contratual e conseq&uuml;entemente despejo, manter no im&oacute;vel locado, qualquer tipo  de animal, mesmo dom&eacute;stico, sem a devida autoriza&ccedil;&atilde;o por escrito do s&iacute;ndico em  caso de loca&ccedil;&atilde;o em condom&iacute;nios.</p>
      </div>
  <div align="justify"  class="textoRelatorioContrato"> 
        <p><strong>CLAUSULA OITAVA:</strong> Durante o período de locação, até a efetiva devolução do imóvel, o LOCATÁRIO arcará, sob pena de rescisão contratual, com: a. todos os encargos tributários incidentes sobre o imóvel, (exceto as despesas extraordinárias de condomínio, conforme previsto na LEI DO INQUILINATO); b. todas as despesas de conservação do prédio, de seguro, de consumo de água, luz, telefone, de taxas condominiais e outras ligadas ao uso do imóvel; c. todas as multas pecuniárias provenientes do atraso no pagamento de quantias sob sua responsabilidade.</p>
      </div>
	  
  <div align="justify"  class="textoRelatorioContrato"><strong>PARÁGRAFO PRIMEIRO: </strong>O  IPTU,  as  taxas  de  água,  energia  elétrica,  condomínio,  serão  pagas  pelo LOCATÁRIO  diretamente  aos  órgãos  arrecadadores  respectivos,  ficando  este  obrigado  a  apresentar  a ADMINISTRADORA os comprovantes, sempre que esta solicitar, sob pena de ser recusado o recebimento do aluguel, dando assim, motivo à rescisão contratual por parte do LOCATÁRIO.</div>  
  <br>
  <div align="justify"  class="textoRelatorioContrato"><strong>PARÁGRAFO SEGUNDO: </strong>A LOCADORA fica obrigada a adimplir, negociar, assumir, etc, todos os débitos e impostos que recaírem sobre o imóvel objeto do presente contrato até a  data da assinatura do presente instrumento, ficando tais responsabilidades a encargo do LOCATÁRIO a partir da data de inicio do presente instrumento.</div>  
  <br>
  <div align="justify"  class="textoRelatorioContrato"><strong>PARÁGRAFO TERCEIRO: </strong>O  LOCATÁRIO  fica  OBRIGADO  a  transferir  perante  a  ENEL  e  a  SANEAGO  as titularidades  das  respectivas  contas  de  energia  e  água  para  seu  nome  no  prazo  máximo  de  10  (dez)  dias contados da assinatura do presente contrato, devendo assim prevalecer durante toda a vigência contratual.</div>  
  <br>
  <div align="justify"  class="textoRelatorioContrato"><strong>PARÁGRAFO QUARTO: </strong>Caso o LOCATÁRIO não cumpra com o estabelecido no parágrafo anterior, além da multa  contratual,  estará  sujeito  e  obrigado  ao  pagamento  de  todas  as  despesas  e  tributos  que  recaírem sobre o imóvel objeto do presente contrato independente da troca de titularidade.</div>  

  <div align="justify"  class="textoRelatorioContrato"> 
        <p><strong>CLAUSULA NONA:</strong> Para prevenir  responsabilidades, o LOCAT&Aacute;RIO, autoriza expressamente a ADMINISTRADORA a  cobrar-lhe no ato da assinatura do contrato de loca&ccedil;&atilde;o, o PREMIO DE SEGURO  CONTRA INC&Ecirc;NDIO do im&oacute;vel objeto deste contrato em seguradora indicada pela  ADMINISTRADORA e pelo valor real do im&oacute;vel.</p>
      </div>
  <div align="justify"  class="textoRelatorioContrato"> 
        <p><strong>PAR&Aacute;GRAFO &Uacute;NICO</strong>: Em caso de  renova&ccedil;&atilde;o autom&aacute;tica, fica desde j&aacute; autorizada tamb&eacute;m &agrave; renova&ccedil;&atilde;o do SEGURO DE  INC&Ecirc;NDIO, e sua cobran&ccedil;a ser&aacute; feita juntamente com o PRIMEIRO aluguel da  referida renova&ccedil;&atilde;o.</p>
      </div>
  <div align="justify"  class="textoRelatorioContrato"> 
        <p><strong>CL&Aacute;USULA D&Eacute;CIMA:</strong> Em caso de  inc&ecirc;ndio ou outros danos quaisquer de for&ccedil;a maior, que impe&ccedil;a o uso do im&oacute;vel  locado, total ou parcialmente, que importe em obra por prazo superior a 30  (trinta) dias, ou ainda desapropria&ccedil;&atilde;o, o presente contrato ficar&aacute; tamb&eacute;m  rescindido de pleno direito independente de interpela&ccedil;&atilde;o judicial e sem direito  ao LOCAT&Aacute;RIO, de qualquer indeniza&ccedil;&atilde;o por parte do(s) LOCADOR (ES) OU  ADMINISTRADORA.</p>
      </div>
  <div align="justify"  class="textoRelatorioContrato">
      <p><strong>CL&Aacute;USULA D&Eacute;CIMA PRIMEIRA:</strong> Em  caso de loca&ccedil;&atilde;o de unidades residenciais ou comerciais, regidas por condom&iacute;nio,  desde j&aacute; o LOCAT&Aacute;RIO se obriga e se compromete a cumprir a conven&ccedil;&atilde;o de  condom&iacute;nio, bem como regulamento interno, cujos termos declaram conhecer e que  passar&aacute; a fazer parte integrante deste contrato. Em caso de descumprimento  estar&aacute; o LOCAT&Aacute;RIO sujeito as penalidades legais e rescis&atilde;o contratual.</p>
    </div><div align="justify"  class="textoRelatorioContrato"> 
        <p><strong>CL&Aacute;USULA D&Eacute;CIMA SEGUNDA:</strong> O  LOCAT&Aacute;RIO encaminhar&aacute; a ADMINISTRADORA todas &agrave;s correspond&ecirc;ncias, intima&ccedil;&otilde;es,  notifica&ccedil;&otilde;es que lhe forem entregues em nome do PROPRIET&Aacute;RIO ou qualquer outro.  Omitindo-se desta obriga&ccedil;&atilde;o, responder&aacute; pelas indeniza&ccedil;&otilde;es e perdas e danos.</p>
      </div>
  
  <div align="justify"  class="textoRelatorioContrato">
      <p><strong>CL&Aacute;USULA D&Eacute;CIMA TERCEIRA:</strong> O (A) LOCAT&Aacute;RIO (A) declara estar recebendo, como de fato recebe no ato da  assinatura deste contrato, o im&oacute;vel com todas as depend&ecirc;ncias em condi&ccedil;&otilde;es de  serem ocupadas, conforme LAUDO DE VISTORIA EM ANEXO, que passa a integrar o  presente instrumento, comprometendo-se a restitu&iacute;-lo nas mesmas condi&ccedil;&otilde;es em  que o recebe, procedendo aos consertos e reparos dos danos que ocorrerem  durante a loca&ccedil;&atilde;o, sendo-lhe facultado pintar o im&oacute;vel quando bem lhe aprouver,  observada a mesma cor e qualidade do material empregado, por sua conta e sem  direito a qualquer indeniza&ccedil;&atilde;o.</p>
    </div>
  
  <div align="justify"  class="textoRelatorioContrato">
      <p><strong>PAR&Aacute;GRAFO  PRIMEIRO</strong> - Entretanto, caso o LOCAT&Aacute;RIO n&atilde;o promova no t&eacute;rmino da  loca&ccedil;&atilde;o a pintura e os reparos necess&aacute;rios, poder&aacute; a ADMINISTRADORA, com amplos  e ilimitados poderes, promover tais servi&ccedil;os, apresentando o total das despesas  ao LOCAT&Aacute;RIO e ao (s) FIADOR (ES), ou a seus representantes legais, para o  pagamento imediato, sob pena de execu&ccedil;&atilde;o judicial, incluindo-se nestas, taxas  de servi&ccedil;os, dilig&ecirc;ncias judiciais, custas processuais, honor&aacute;rios advocat&iacute;cios  e demais encargos da loca&ccedil;&atilde;o.</p>
    </div>
  
  <div align="justify"  class="textoRelatorioContrato">
      <p><strong>PAR&Aacute;GRAFO  SEGUNDO</strong> - Visando manter o padr&atilde;o de qualidade do im&oacute;vel ora  locado, fica desde j&aacute; acertado entre as partes, que todos os servi&ccedil;os de  reparos necess&aacute;rios ao im&oacute;vel, somente poder&atilde;o ser realizados por <strong>profissionais  autorizados </strong>por escrito pela ADMINISTRADORA.</p>
    </div>
  
  <div align="justify"  class="textoRelatorioContrato">
      <p><strong>PAR&Aacute;GRAFO  TERCEIRO</strong> - Caso o LOCAT&Aacute;RIO tome posse do im&oacute;vel ora locado antes  da assinatura do LAUDO DE VISTORIA, este assumir&aacute; toda a responsabilidade pelas  diverg&ecirc;ncias, n&atilde;o podendo no futuro reclamar ou exigir nova vistoria e dever&aacute;  no t&eacute;rmino da loca&ccedil;&atilde;o, devolve-lo totalmente reformado e com pintura nova,  usando material de primeira linha e respeitando a mesma tonalidade de  cor.</p>
    </div>
  
  <div align="justify"  class="textoRelatorioContrato">
      <p><strong>CL&Aacute;USULA D&Eacute;CIMA QUARTA:</strong> As obras  que importarem na seguran&ccedil;a do im&oacute;vel ser&aacute; de responsabilidade do(s) LOCADOR (ES).  Todas as demais, bem como as referentes &agrave;: conserva&ccedil;&atilde;o de aparelhos sanit&aacute;rios;  de ilumina&ccedil;&atilde;o; fog&atilde;o, trincos, fechaduras, torneiras, vidra&ccedil;as, limpeza em  geral, reparos de desentupimento de &aacute;gua, esgoto, caixa de gordura, conserto de  telhado com reposi&ccedil;&atilde;o de telhas se for o caso, conserva&ccedil;&atilde;o de jardins e  arvores, e, enfim, toda a manuten&ccedil;&atilde;o do im&oacute;vel ser&aacute; de inteira responsabilidade  do LOCAT&Aacute;RIO, que fica obrigado a restituir o im&oacute;vel em perfeito estado de  conserva&ccedil;&atilde;o. No caso de po&ccedil;o e bomba para &aacute;gua com motor, os respectivos  encargos de limpeza, manuten&ccedil;&atilde;o e reparos ficar&atilde;o tamb&eacute;m a cargo do LOCAT&Aacute;RIO.  Toda e qualquer modifica&ccedil;&atilde;o a ser introduzida no im&oacute;vel locado ou em suas  instala&ccedil;&otilde;es &eacute; expressamente necess&aacute;ria pr&eacute;via anu&ecirc;ncia por escrito do (s)  LOCADOR (ES), e, as que com autoriza&ccedil;&atilde;o, forem feitas, passar&atilde;o a pertencer ao patrim&ocirc;nio  do (s) LOCADOR (ES). Poder&aacute;, entretanto, o (s) LOCADOR (ES), finda a loca&ccedil;&atilde;o,  exigir que as benfeitorias ou modifica&ccedil;&otilde;es introduzidas sem o seu consentimento  por escrito, sejam retiradas com recursos do LOCAT&Aacute;RIO, o qual fica obrigado a  pagar os ALUGUEIS devidos at&eacute; que o im&oacute;vel seja restitu&iacute;do sem as mesmas benfeitorias,  tal como lhe foi entregue.</p>
    </div>
  
  <div align="justify"  class="textoRelatorioContrato"> 
        <p><strong>CL&Aacute;USULA D&Eacute;CIMA QUINTA:</strong> Se findo  o prazo da loca&ccedil;&atilde;o, permanecer o LOCAT&Aacute;RIO no im&oacute;vel ora locado, subsistir&atilde;o  para o mesmo e seus FIADORES, todas as obriga&ccedil;&otilde;es contratadas neste  instrumento, e, em caso de n&atilde;o haver renova&ccedil;&atilde;o contratual, o LOCAT&Aacute;RIO se  obriga e se compromete a pagar o valor do aluguel devidamente reajustado a  pre&ccedil;o de mercado, ou caso n&atilde;o exista acordo, o aluguel ser&aacute; corrigido de acordo  com o IGPM, e na sua falta, outro que refuta a infla&ccedil;&atilde;o real do Pais.</p>
  </div>
	
    <div align="justify"  class="textoRelatorioContrato"> 
        <p><strong>CL&Aacute;USULA D&Eacute;CIMA SEXTA:</strong>&nbsp; Com o objetivo de defender o im&oacute;vel&nbsp; de quaisquer  eventualidades, por aus&ecirc;ncia do LOCAT&Aacute;RIO, e, no intuito de acautelar-se&nbsp; &agrave;&nbsp; sua&nbsp;  integridade&nbsp; contra&nbsp; poss&iacute;veis&nbsp;  esbulhos&nbsp; ou depreda&ccedil;&atilde;o, fica o (s) LOCADOR(ES) autorizado a tomar posse do im&oacute;vel, independente de qualquer procedimento judicial,&nbsp; desde que fique comprovado o abandono do im&oacute;vel pelo LOCAT&Aacute;RIO. Caracterizando tamb&eacute;m como abandono, a aus&ecirc;ncia habitual e prolongada do LOCAT&Aacute;RIO depois de  vencido o SEGUNDO m&ecirc;s sem pagamento dos alugueis e tributos. PAR&Aacute;GRAFO &Uacute;NICO - N&atilde;o ser&aacute; permitida a  transferencia deste contrato, nem a subloca&ccedil;&atilde;o, cess&atilde;o  ou empr&eacute;stimo total ou parcial do im&oacute;vel locado, sem a  autoriza&ccedil;&atilde;o expressa e por escrito da ADMINISTRADORA.</p>
    </div>
  
  <div align="justify"  class="textoRelatorioContrato"> 
        <p><strong>CL&Aacute;USULA D&Eacute;CIMA S&Eacute;TIMA:</strong> A  toler&acirc;ncia da ADMINISTRADORA para qualquer ato ou obriga&ccedil;&atilde;o que, em virtude  deste contrato, deva ser praticado ou satisfeito pelo LOCAT&Aacute;RIO, n&atilde;o dar&aacute; a  este qualquer direito nem poder&aacute; ser tido como altera&ccedil;&atilde;o ou nova&ccedil;&atilde;o do  estabelecido neste instrumento.</p>
      </div>
  <div align="justify"  class="textoRelatorioContrato">
  <p><strong>CL&Aacute;USULA D&Eacute;CIMA OITAVA:</strong> O  LOCAT&Aacute;RIO obriga-se a fazer &agrave;s suas custas, todas as repara&ccedil;&otilde;es ou obras  oriundas de notifica&ccedil;&atilde;o ou intima&ccedil;&atilde;o de qualquer autoridade judicial, estadual  e municipal, pelas quais seja respons&aacute;vel, assim como pagar imediatamente quaisquer  multas que lhe sejam impostas por infra&ccedil;&atilde;o as leis e regulamentos, das quais se  obriga a dar ci&ecirc;ncia por escrito a ADMINISTRADORA.</p>
  </div>
  <div align="justify"  class="textoRelatorioContrato">
      <p><strong>CL&Aacute;USULA D&Eacute;CIMA NONA:</strong> A multa pactuada para a rescis&atilde;o deste contrato &eacute; de 10% do valor do aluguel  vigente na &eacute;poca e ser&aacute; cobrada proporcionalmente sobre os meses restantes para  o t&eacute;rmino do contrato de loca&ccedil;&atilde;o.</p>
    </div>
  <div align="justify"  class="textoRelatorioContrato">
      <p><strong>PAR&Aacute;GRAFO PRIMEIRO</strong> - Sendo o  contrato firmado por prazo igual ou superior a 30 meses, as partes contratantes  ficar&atilde;o isentas do pagamento da multa de rescis&atilde;o contratual, desde que a parte  interessada NOTIFIQUE a outra, por escrito, no prazo de 30 (trinta) dias antes  do vencimento da 12a (d&eacute;cima segunda) parcela de aluguel, ou seja, nestes casos  a rescis&atilde;o sem multa somente poder&aacute; ocorrer no 12&deg; (d&eacute;cimo segundo) m&ecirc;s de  loca&ccedil;&atilde;o.</p>
    </div>  
 	<%
if strTipoFiador = "F" then%>
    
    <p align="justify"  class="textoRelatorioContrato"><strong>CL&Aacute;USULA VIG&Eacute;SIMA:</strong> Os abaixo qualificados assinam tamb&eacute;m o presente  contrato, na qualidade de FIADORES e PRINCIPAIS pagadores, solidariamente respons&aacute;veis com o LOCAT&Aacute;RIO nas obriga&ccedil;&otilde;es contra&iacute;das atrav&eacute;s do presente contrato,  cujas responsabilidades se estendem a todos os reajustes  dos alugu&eacute;is e demais encargos da loca&ccedil;&atilde;o e pelos  danos e estragos que se verificarem no im&oacute;vel, at&eacute; a sua  efetiva devolu&ccedil;&atilde;o e distrato deste instrumento,  ainda que a loca&ccedil;&atilde;o se prorrogue por prazo indeterminado. Ficam tamb&eacute;m os fiadores solidariamente  respons&aacute;veis pelas custas e honor&aacute;rios advocat&iacute;cios a que vier a ser obrigado o LOCAT&Aacute;RIO em a&ccedil;&atilde;o que eventualmente lhe  venha ser proposta por falta de pagamento de alugueis e/ou encargos da loca&ccedil;&atilde;o,  renunciando ainda expressamente, aos benef&iacute;cios dos  Art. 821, 827, 834, 835, 837 e 838 do novo C&oacute;digo Civil Brasileiro.</p>
	<%
		sql = " SELECT C.codigo AS codCliente, C.NomeCompleto_RazaoSocial AS fiador, C.NomeCompletoConjuge AS NomeConjuge, C.Profissao, EC.Descricao AS EstadoCivil, C.Cpf_Cnpj AS cic, C.RG, C.OrgaoExp AS OrgaoExp, C.Endereco, C.Bairro, C.CEP, C.Cidade AS municipio, C.UF, C.CPFConjuge, C.RGConjuge, C.OrgaoExpConjuge AS OrgaoExpedidorConjuge "
		sql = sql & " FROM IMOB_EstadoCivil EC RIGHT JOIN ((IMOB_Cliente C INNER JOIN IMOB_ClienteTipoVinculo CTV ON C.codigo = CTV.CodCliente) INNER JOIN IMOB_ClienteFiador CF ON CTV.Codigo = CF.codClienteTipoVinculo) ON EC.Codigo = C.CodEstadoCivil "
		sql = sql & " WHERE CF.codLocatarioImovel="& intCodLocatarioImovel
		sql = sql & " and C.CodEmpresa = " & session("codEmpresa")
		ContFiador = 0
		rs.open sql, cnn
		if rs.eof = false then
			while not rs.eof 
				contFiador = ContFiador + 1
				strFiador	= rs("fiador")
				strFiadorConjuque	= rs("NomeConjuge")
				
				strProfissaoFiador 	= rs("profissao")
				strEstadoCivilFiador 	= rs("estadocivil")
				strCPFFiador 			= rs("cic")
				strCPFConjuque 			= rs("cpfConjuge")
				strRGFiador 			= rs("rg")
				strRGConjuqe 			= rs("rgConjuge")
				strOrgaoExpedidorFiador= rs("orgaoExp")
				strOrgaoExpedidorConjuqe= rs("OrgaoExpedidorConjuge")
				strEnderecoFiador		= rs("endereco")
				strBairroFiador 		= rs("bairro")
				strCepFiador 			= rs("cep")
				strEnderecoCompletoFiador = strEnderecoFiador
				if not isnull(rs("bairro")) then strEnderecoCompletoFiador = strEnderecoCompletoFiador & ", " & rs("bairro")
				if not isnull(rs("municipio")) and rs("municipio") <> "" then strEnderecoCompletoFiador = strEnderecoCompletoFiador & ", " & rs("municipio") 
				if not isnull(rs("uf")) and rs("uf") <> "" then strEnderecoCompletoFiador = strEnderecoCompletoFiador & ", " & rs("uf") 
				if not isnull(rs("cep")) and rs("cep") <> "" then strEnderecoCompletoFiador = strEnderecoCompletoFiador & ", " & rs("cep") 				
				if cInt(contFiador)=3 then
					intNumPagina=intNumPagina+1
                  	response.Write " "
                    response.Write "<td colspan='2' class='textoRelatorioContrato'><div align='justify'></div>"
                  	response.Write "</tr>"
                	response.Write "</div>"
                	response.Write "<br>"
                	response.Write "<table width='85%' class='textoRelatorioContrato' align='center'>"
                	response.Write "	 "
                	response.Write "		<td colspan='2' align='right' class='textoRelatorioContrato'>" & intNumPagina & "" & strNumTotalPaginas & ""
                	response.Write "	</tr>"
                	response.Write "   "
                	response.Write "    <td colspan='2' class='textoRelatorioContrato'><div align='justify'></div>"
                	response.Write "  </tr>"
				end if
				%>
<div align="justify"  class="textoRelatorioContrato"><%=contFiador%>º FIADOR(A): <strong><%=strFiador%></strong><strong>, </strong>brasileiro(a), <%=strEstadoCivilFiador%>(a), <%=strProfissaoFiador%>, portador da carteira de identidade n. <%=strRGFiador%>, <%=strOrgaoExpedidorFiador%>, CPF n. <%=strCPFFiador%>, residente e dominiciado na <%=strEnderecoCompletoFiador%>.</div>
<%	if strFiadorConjuque <> "" then	%>
			  
			  <div align="justify"  class="textoRelatorioContrato">ESPOSO(A) DO(A) <%=contFiador%>º FIADOR(A): <strong><%=strFiadorConjuque%></strong>, brasileiro(a), <%=strEstadoCivilFiador%>(a), portador da carteira de identidade n. <%=strRGConjuqe%>, <%=strOrgaoExpedidorConjuqe%>, CPF n. <%=strCPFFiador%>, residente e dominiciado na <%=strEnderecoCompletoFiador%>.</div>				
			  <%	end if	%>
<%
				rs.movenext
			wend
		end if
		rs.close
end if
if cInt(contFiador)<3 then
			%>
</div><%
end if
%>
  <div align="justify"  class="textoRelatorioContrato"> 
        <p><strong>PAR&Aacute;GRAFO PRIMEIRO</strong> - No caso de  morte, fal&ecirc;ncia, insolv&ecirc;ncia ou mudan&ccedil;a dos FIADORES para fora desta cidade, o  LOCAT&Aacute;RIO, se obriga dentro do prazo de 30 (trinta) dias a dar substituto id&ocirc;neo,  a ju&iacute;zo da ADMINISTRADORA, sob pena de incorrer em RESCIS&Atilde;O CONTRATUAL,  arcando com todos os encargos dela decorrente.</p>
      </div>
  
  <div align="justify"  class="textoRelatorioContrato">
      <p><strong>PAR&Aacute;GRAFO SEGUNDO</strong> - O  LOCAT&Aacute;RIO, desde j&aacute;, e por este instrumento, constitui como seus procuradores,  os fiadores da loca&ccedil;&atilde;o, acima qualificados (cl&aacute;usula vig&eacute;sima), e estes  aceitam, para o fim especial de, em conjunto ou separadamente,  independentemente da ordem de nomea&ccedil;&atilde;o, represent&aacute;-lo em quaisquer a&ccedil;&otilde;es  judiciais relacionadas com este contrato, inclusive execu&ccedil;&atilde;o, conferindo-lhes  poderes amplos e especiais para receber cita&ccedil;&otilde;es, inclusive inicial,  notifica&ccedil;&otilde;es e intima&ccedil;&otilde;es, bem como para confessar, reconhecer a proced&ecirc;ncia do  pedido, transigir, desistir, renunciar ao direito sobre o qual se funda a a&ccedil;&atilde;o,  firmar compromisso e devolver o im&oacute;vel, no caso de abandono, ainda que seja  necess&aacute;rio retirar os m&oacute;veis que ocupam, autorizando que elas procedam, p&ecirc;los  meios indicados neste contrato. Da mesma forma, os fiadores e seus c&ocirc;njuges,  outorgam, entre si, mandato rec&iacute;proco, para o fim espec&iacute;fico, de em conjunto ou  separadamente, independente da ordem de nomea&ccedil;&atilde;o, receber cita&ccedil;&atilde;o inclusive  inicial, notifica&ccedil;&atilde;o e intima&ccedil;&otilde;es, em qualquer a&ccedil;&atilde;o relacionada com o im&oacute;vel  objeto do presente contrato.</p>
    </div>
  
  <div align="justify"  class="textoRelatorioContrato">
      <p><strong>PAR&Aacute;GRAFO  TERCEIRO</strong> - Caso, todavia, em qualquer &eacute;poca, o inciso VII do art.  3o da Lei no. 8.009, de 29 de mar&ccedil;o de 1990, mandado acrescentar pelo art. 82  da Lei no. 8.245/81, ' venha a ser revogado e, conseq&uuml;entemente, o im&oacute;vel  utilizado como resid&ecirc;ncia do(s) fiador (es) e de sua fam&iacute;lia, venha a se tornar  impenhor&aacute;vel por d&iacute;vida civil, pactuada neste contrato, consistente nos  alugu&eacute;is e acess&oacute;rios da loca&ccedil;&atilde;o, expressamente, na forma do disposto no art.  683 e 684 do novo C&oacute;digo Civil Brasileiro, em car&aacute;ter irrevog&aacute;vel e  irretrat&aacute;vel, o (s) LOCAT&Aacute;RIO(S) nomeia (m) a representante legal do  propriet&aacute;rio (Administradora do Im&oacute;vel), outorgando-lhe(s) poderes especiais e  expresso para, em nome do(s) locador (es), contratar seguro de fian&ccedil;a  locat&iacute;cia, previsto no art. 41 da mencionada Lei no. 8.245/81, cujo premio de  seguro correr&aacute; por conta dele(s) LOCAT&Aacute;RIO(S), na forma do disposto no inciso  XI do artigo 23 da aludida Lei no. 8.245/81.</p>
    </div>
  
  <div align="justify"  class="textoRelatorioContrato">
      <p><strong>PAR&Aacute;GRAFO  QUARTO</strong> - Fica, tamb&eacute;m em car&aacute;ter irrevog&aacute;vel e irretrat&aacute;vel,  assegurado ao(s) locador (es) o mesmo direito de contratar (em) seguro fian&ccedil;a  locat&iacute;cia, previsto no par&aacute;grafo 3o. anterior, em substitui&ccedil;&atilde;o &agrave; fian&ccedil;a pessoal  prestada nesta cl&aacute;usula, se ocorreram, a qualquer tempo, quaisquer uma das  hip&oacute;teses previstas no art. 40 da Lei no. 8.245/81, a saber:</p>
    </div>
  <div align="justify"  class="textoRelatorioContrato">
      <p>1 - Morte do  fiador;<br>
        2 - Aus&ecirc;ncia, interdi&ccedil;&atilde;o, fal&ecirc;ncia ou insolv&ecirc;ncia do  fiador, declaradas judicialmente;<br>
        3 - Aliena&ccedil;&atilde;o ou grava&ccedil;&atilde;o de todos os bens im&oacute;veis do  fiador, ou sua mudan&ccedil;a de  resid&ecirc;ncia sem comunica&ccedil;&atilde;o ao locador;<br>
        4 - Exonera&ccedil;&atilde;o  do fiador;<br>
        5 - Prorroga&ccedil;&atilde;o da loca&ccedil;&atilde;o por prazo indeterminado, sendo  a fian&ccedil;a ajustada por prazo certo;<br>
        6 -  Desaparecimento dos bens m&oacute;veis;<br>
        7 -  Desapropria&ccedil;&atilde;o ou aliena&ccedil;&atilde;o do im&oacute;vel.</p>
    </div>
  
 <%if cInt(contFiador)<3 then%>  
  <div align="justify"  class="textoRelatorioContrato">
      <p><strong>PAR&Aacute;GRAFO QUINTO</strong> - As partes  contratantes, bem como os FIADORES, de comum acordo determinam que para efeito  de cita&ccedil;&otilde;es judiciais, as mesmas podem ser realizadas pelo CORREIO, via AR, de  conformidade com o que autoriza a LEI 8.245/81.</p>
    </div>
  
  <div align="justify"  class="textoRelatorioContrato">
      <p><strong>CL&Aacute;USULA VIG&Eacute;SIMA PRIMEIRA:</strong> OS  FIADORES j&aacute; qualificados e identificados, t&ecirc;m  pleno conhecimento e concordam que, em caso de RENOVA&Ccedil;&Atilde;O AUTOM&Aacute;TICA, ou seja,  RENOVA&Ccedil;&Atilde;O POR PRAZO INDETERMINADO da presente loca&ccedil;&atilde;o, suas responsabilidades  como FIADORES E PRINCIPAIS E SOLID&Aacute;RIOS  PAGADORES se estender&atilde;o at&eacute; a efetiva devolu&ccedil;&atilde;o do  im&oacute;vel e o aceite da ADMINISTRADORA no que diz respeito ao seu estado, conforme  vistoria inicial assinada pelo (a) LOCAT&Aacute;RIO (A). </p>
    </div>
 <%end if%>
<%
if cInt(contFiador)>=3 then
%>
  <div align="justify"  class="textoRelatorioContrato">&nbsp;</div>
<%
end if
%>
<div align="justify"  class="textoRelatorioContrato">
  <p align="justify" class="textoRelatorioContrato"><strong>CL&Aacute;USULA VIG&Eacute;SIMA SEGUNDA:</strong> A  ADMINISTRADORA pode, quando julgar necess&aacute;rio, VISTORIAR o im&oacute;vel e suas  depend&ecirc;ncias a fim de verificar se est&atilde;o sendo cumpridas as obriga&ccedil;&otilde;es aqui  assumidas, de conformidade com o que determina o artigo 23, inciso IX da Lei n&ordm;.  8.245/81.</p>    
</div>
<div align="justify"  class="textoRelatorioContrato">
  <p><strong>CL&Aacute;USULA VIG&Eacute;SIMA TERCEIRA:</strong> Quando da devolu&ccedil;&atilde;o do im&oacute;vel pelo LOCAT&Aacute;RIO, a simples entrega f&iacute;sica das  chaves n&atilde;o significar&aacute; quita&ccedil;&atilde;o dos d&eacute;bitos existentes, pois o resgate deste se  far&aacute; mediante recibo espec&iacute;fico. </p>
</div>  
<div align="justify"  class="textoRelatorioContrato">  
  <p><strong>PAR&Aacute;GRAFO &Uacute;NICO</strong> - Em hip&oacute;tese  alguma se aceitar&aacute; a devolu&ccedil;&atilde;o das chaves por meio de intermedi&aacute;rio n&atilde;o  autorizado.</p>
</div>  
<div align="justify"  class="textoRelatorioContrato">  
  <p align="justify"  class="textoRelatorioContrato"><strong>CLAUSULA VIG&Eacute;SIMA QUARTA:</strong> A presente loca&ccedil;&atilde;o &eacute; regida pela Lei Federal nr. 8.245/81.</p>
</div>  
<div align="justify"  class="textoRelatorioContrato">
 <p><strong>CL&Aacute;USULA VIG&Eacute;SIMA QUINTA:</strong> Depois  de lido e por estarem assim justos e contratados, assinam o presente em 02  (duas) vias de igual teor e forma, na presen&ccedil;a de duas testemunhas, tudo de  acordo com a lei. As partes contratantes elegem o Foro da Comarca de Goiânia(GO) para dirimir todas as questões contratuais.</p>
</div>  
<div align="justify"  class="textoRelatorioContrato">
  <strong>Goi&acirc;nia, <%=day(strDataAssinatura)%> de <%=monthname(month(strDataAssinatura))%> de <%=year(strDataAssinatura)%>. </strong>
</div>  
<div align="justify"  class="textoRelatorioContrato">
<br>
P/P Locador(a):
<br>
<table align="center" width="650">
  <tr>
    <td height="5" colspan="3" align="center" class="textoRelatorioContrato">_____________________________________</td>
  </tr>
  <tr>
    <td colspan="3" align="center" class="textoRelatorioContrato"><strong><%=ucase(session("strRazaoSocial"))%></strong></td>
  </tr>
  <tr>
    <td colspan="3" class="textoRelatorioContrato">&nbsp;</td>
  </tr>
  <%for i=0 to ubound(vetLocatario)
  	strLocatarioConj = vetLocatarioConjuge(i)%>
  <tr>
    <td width="50%" align="center" class="textoRelatorioContrato">_____________________________________</td>
    <td width="50%" align="center" class="textoRelatorioContrato"><%if trim(strLocatarioConj)<>"" then%>_____________________________________<%end if%></td>
  </tr>
  <tr>
    <td align="center" class="textoRelatorioContrato"><strong><%=vetLocatario(i)%></strong></td>
    <td align="center" class="textoRelatorioContrato"><strong><%=trim(strLocatarioConj)%></strong></td>
  </tr>
  <tr>
    <td align="center" class="textoRelatorio style2">LOCAT&Aacute;RIO(A)</td>
    <td align="center" class="textoRelatorioContrato"><%if trim(strLocatarioConj)<>"" then%>
      <span class="style3">CONJUGE DO(A) LOCAT&Aacute;RIO(A)</span>
    <%end if%></td>
  </tr>
  <%NEXT%>
  <tr>
    <td align="center" class="textoRelatorioContrato">&nbsp;</td>
    <td align="center" class="textoRelatorioContrato">&nbsp;</td>
  </tr>
<%
	sql = "SELECT C.codigo AS codCliente, C.NomeCompleto_RazaoSocial as fiador, C.NomeCompletoConjuge as NomeConjuge "
	sql = sql & " FROM IMOB_EstadoCivil EC RIGHT JOIN ((IMOB_Cliente C INNER JOIN IMOB_ClienteTipoVinculo CTV ON C.codigo = CTV.CodCliente) INNER JOIN IMOB_ClienteFiador CF ON CTV.Codigo = CF.codClienteTipoVinculo) ON EC.Codigo = C.CodEstadoCivil "
	sql = sql & " WHERE CF.codLocatarioImovel="& intCodLocatarioImovel
	sql = sql & " and C.CodEmpresa = " & session("codEmpresa")
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof 
		strFiador			= rs("fiador")
		strFiadorConjuque	= rs("NomeConjuge")
		
		if strFiador <> "" then	%>
		  <tr>
			<td align="center" class="textoRelatorioContrato">_____________________________________</td>
			<td align="center" class="textoRelatorioContrato"><%if strFiadorConjuque <> "" then%>_____________________________________<%end if%></td>
		  </tr>
		  <tr>
			<td align="center" class="textoRelatorioContrato"><strong><%=strFiador%></strong></td>
			<td align="center" class="textoRelatorioContrato"><strong><%=strFiadorConjuque%></strong></td>
		  </tr>
		  <tr>
			<td align="center" class="textoRelatorio style3">FIADOR(A)</td>
			<td align="center" class="textoRelatorioContrato"><%if strFiadorConjuque <> "" then%>
			  <span class="style3">CONJUGE(A) DO(A) FIADOR(A)</span>
		    <%end if%></td>
		  </tr>
		   <%
		   end if
		   rs.movenext
		   wend
		end if
		rs.close
		%>
  <tr> 
    <td colspan="3" align="left" class="textoRelatorio">TESTEMUNHAS:</td>
  </tr>
  <tr> 
    <td colspan="3" align="center" class="textoRelatorio">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="3" align="left" class="textoRelatorio">01)___________________________    </td>
  </tr>
  <tr> 
    <td height="37" colspan="3" align="left" class="textoRelatorio">02)___________________________</td>
  </tr>
		  <tr>
		    <td height="26" colspan="3" align="center" class="textoRelatorioContrato"><p align="center"><strong><br>
	        E INDISPENS&Aacute;VEL O RECONHECIMENTO DE TODAS AS ASSINATURAS</strong><br>
		    </p></td>
  </tr>       
</table>
</div>    
</div>
</div>
<%
strNotaEsclarecimentoLocatario = "N"
'carrega parametro sistema
sql = "SELECT  NotaEsclarecimentoLocatario "
sql = sql & " FROM SEG_imob_empresa "
sql = sql & " WHERE CODIGO = " & session("codEmpresa")
rs.open sql, cnn, 3, 3
if rs.eof = false then
	strNotaEsclarecimentoLocatario = rs("NotaEsclarecimentoLocatario")
end if 
rs.close
if strNotaEsclarecimentoLocatario = "S" then 
%>

<br>
	<!--#include file="EmitirNotaEsclarecimento_rel.asp"-->
<%
end if
%>

<%
	if request("w") <> "" then
		Response.ContentType = "application/vnd.ms-word"
        Response.AddHeader "content-disposition","attachment;filename="&nomeDocSalvo&".doc"
	end if


%>
</body>
</html>