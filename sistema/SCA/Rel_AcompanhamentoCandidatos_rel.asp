<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
-->
<html>
<head>
<title><%=session("Titulo")%> - Candidatos </title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	dim intPagina
	
	intCodVestibular        	= Trim(Request.Form("cmbVestibular"))
	intTipoProcesso				= Trim(Request("cmbTipoProcesso"))
	strAnoLetivo 			    = Trim(Request.Form("txtAnoLetivo"))
	intSemestre 			    = Trim(Request.Form("cmbSemestre"))
	FonteDivulgacao				= Trim(Request.Form("FonteDivulgacao"))
	Graficos					= Trim(Request.Form("ckGraficos"))
	intVestibularTipoMidia		= Trim(Request.Form("cmbVestibularTipoMidia"))
	strDataI 					= trim(request.Form("txtDataI"))
	strDataF 					= trim(request.Form("txtDataF"))
	

	sql = "SELECT Descricao"
	sql = sql & " FROM SCA_VESTIBULAR"
    sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
	sql = sql & " and Codigo = " & intCodVestibular 
	rs.open sql, cnn
	if rs.eof = false then
	   while not rs.eof
	     strDescricao = trim(rs("Descricao"))
	     rs.movenext
       wend
	end if
	rs.close

	strDescricaoMidia = ""
	if intVestibularTipoMidia <> "0" and intVestibularTipoMidia <> "" then
		sql = "SELECT Descricao"
		sql = sql & " FROM SCA_VESTIBULAR_TIPOS_MIDIA"
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
		sql = sql & " and Codigo = " & intVestibularTipoMidia 
		rs.open sql, cnn
		if rs.eof = false then
		   while not rs.eof
			 strDescricaoMidia = "<br>" & trim(rs("Descricao"))
			 rs.movenext
		   wend
		end if
		rs.close
	end if
	
	if intSemestre = "3" then
		msgTituloRelatorio = strAnoLetivo
	else
		msgTituloRelatorio = strAnoLetivo & "/" & intSemestre
	end if	
	if strDataI <> "" and strDataF <> "" then
		strMensagemPeriodoInscricao = "<br>Per&iacute;odo " & strDataI & " a " & strDataF
	else
		strMensagemPeriodoInscricao = ""
	end if
	
	strTituloRelatorio  = strDescricao & "<BR>Mapa de Acompanhamento de Candidatos<br>Refer&ecirc;ncia: " & msgTituloRelatorio & strDescricaoMidia & strMensagemPeriodoInscricao

	sub mostraCabecalho()
%>
   <!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr height="29" bgcolor="#CCCCCC">
		<td width="8%" class="celula"><div align="center"><strong>Data</strong></div></td>
		<td width="28%" class="celula"><div align="center"><strong>Descricao</strong></div></td>
		<td width="7%" class="celula"><div align="center"><strong>Inscritos</strong></div></td>
		<td width="7%" class="celula"><div align="center"><strong>N&atilde;o Efetivados</strong></div></td>
		<td width="7%" class="celula"><div align="center"><strong>Pagas</strong></div></td>
		<td width="7%" class="celula"><div align="center"><strong>Valor pago</strong></div></td>
		<td width="7%" class="celula"><div align="center"><strong>Isentas</strong></div></td>
		<td width="7%" class="celula"><div align="center"><strong>Valor Isento</strong></div></td>
		<td width="7%" class="celula"><div align="center"><strong>Provas Realizadas</strong></div></td>
		<td width="7%" class="celula"><div align="center"><strong>Provas N&atilde;o Realizadas</strong></div></td>
	    <td width="8%" class="celula"><div align="center"><strong>Matriculados</strong></div></td>
      </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
%>
<%
	intPagina = 1
	intQtdeRegistroPorPagina = 1
	mostraCabecalho
	cont = 0

	sql = " select "
	sql = sql & " v.Data, "
	sql = sql & " v.Descricao, "
	''---
	sql = sql & " isnull((select count(codigo) from SCA_VESTIBULAR_DADOS " 
	sql = sql & " where Cod_Vestibular = v.codigo "
	if strDataI <> "" and strDataF <> "" then
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) >= convert(datetime, ' " & strDataI & " ',103) " 
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) <= convert(datetime, ' " & strDataF & " ',103) "
	end if
	if intVestibularTipoMidia <> "0" then
		sql = sql & " and Cod_FonteDivulcacao = " & intVestibularTipoMidia
	end if	
	sql = sql & " ),'0') as Inscritos, "
	''---
	sql = sql & " isnull((select count(codigo) from SCA_VESTIBULAR_DADOS " 
	sql = sql & " where Cod_Vestibular = v.codigo "
	if strDataI <> "" and strDataF <> "" then
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) >= convert(datetime, ' " & strDataI & " ',103) " 
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) <= convert(datetime, ' " & strDataF & " ',103) "
	end if
	if intVestibularTipoMidia <> "0" then
		sql = sql & " and Cod_FonteDivulcacao = " & intVestibularTipoMidia
	end if	
	sql = sql & " and datapagamento is null ),'0') as NaoEfetivados, "
	''---
	sql = sql & " isnull((select count(codigo) FROM SCA_VESTIBULAR_DADOS " 
	sql = sql & " where Cod_Vestibular =  v.codigo "
	if strDataI <> "" and strDataF <> "" then
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) >= convert(datetime, ' " & strDataI & " ',103) " 
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) <= convert(datetime, ' " & strDataF & " ',103) "
	end if
	if intVestibularTipoMidia <> "0" then
		sql = sql & " and Cod_FonteDivulcacao = " & intVestibularTipoMidia
	end if	
	sql = sql & " and cod_situacao_pagamento =  2 and isnull(ValorPagamento,'0')>0),'0') AS Pago, "
	''---
	sql = sql & " isnull((select SUM(ValorPagamento) FROM SCA_VESTIBULAR_DADOS " 
	sql = sql & " where Cod_Vestibular =  v.codigo "
	if strDataI <> "" and strDataF <> "" then
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) >= convert(datetime, ' " & strDataI & " ',103) " 
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) <= convert(datetime, ' " & strDataF & " ',103) "
	end if
	if intVestibularTipoMidia <> "0" then
		sql = sql & " and Cod_FonteDivulcacao = " & intVestibularTipoMidia
	end if	
	sql = sql & " and cod_situacao_pagamento =  2 ),'0') as ValorPago, "
	''---
	sql = sql & " isnull((select count(codigo) FROM SCA_VESTIBULAR_DADOS " 
	sql = sql & " where Cod_Vestibular = v.codigo "
	if strDataI <> "" and strDataF <> "" then
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) >= convert(datetime, ' " & strDataI & " ',103) " 
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) <= convert(datetime, ' " & strDataF & " ',103) "
	end if
	if intVestibularTipoMidia <> "0" then
		sql = sql & " and Cod_FonteDivulcacao = " & intVestibularTipoMidia
	end if	
	sql = sql & " and cod_situacao_pagamento =  2 "
	sql = sql & " and ValorPagamento  =  0 ),'0') as Isentos, "
	''---
	sql = sql & " isnull((select SUM(Valor) FROM SCA_VESTIBULAR_DADOS " 
	sql = sql & " where Cod_Vestibular = v.codigo "
	if strDataI <> "" and strDataF <> "" then
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) >= convert(datetime, ' " & strDataI & " ',103) " 
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) <= convert(datetime, ' " & strDataF & " ',103) "
	end if
	if intVestibularTipoMidia <> "0" then
		sql = sql & " and Cod_FonteDivulcacao = " & intVestibularTipoMidia
	end if	
	sql = sql & " and cod_situacao_pagamento =  2 "
	sql = sql & " and ValorPagamento  =  0 ),'0') as ValorIsento, "
	''---
	sql = sql & " isnull((select count(codigo) FROM SCA_VESTIBULAR_DADOS " 
	sql = sql & " where Cod_Vestibular = v.codigo "
	if strDataI <> "" and strDataF <> "" then
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) >= convert(datetime, ' " & strDataI & " ',103) " 
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) <= convert(datetime, ' " & strDataF & " ',103) "
	end if
	if intVestibularTipoMidia <> "0" then
		sql = sql & " and Cod_FonteDivulcacao = " & intVestibularTipoMidia
	end if	
	sql = sql & " and ( isnull(N1,'0') <> '0' " 
	sql = sql & " or isnull(N2,'0') <> '0' " 
	sql = sql & " or isnull(N3,'0') <> '0' " 
	sql = sql & " or isnull(N4,'0') <> '0' " 
	sql = sql & " or isnull(N5,'0') <> '0' )),'0') as ProvasRealizadas, "
	
	sql = sql & " isnull((select count(codigo) FROM SCA_VESTIBULAR_DADOS " 
	sql = sql & " where Cod_Vestibular = v.codigo "
	if strDataI <> "" and strDataF <> "" then
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) >= convert(datetime, ' " & strDataI & " ',103) " 
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) <= convert(datetime, ' " & strDataF & " ',103) "
	end if
	if intVestibularTipoMidia <> "0" then
		sql = sql & " and Cod_FonteDivulcacao = " & intVestibularTipoMidia
	end if	
	sql = sql & " and isnull(N1,'') = '' "
	sql = sql & " and isnull(N2,'') = '' " 
	sql = sql & " and isnull(N3,'') = '' "
	sql = sql & " and isnull(N4,'') = '' " 
	sql = sql & " and isnull(N5,'') = '' "
	sql = sql & " and " 
	sql = sql & " codigo not in ( "
	sql = sql & " select codigo FROM SCA_VESTIBULAR_DADOS " 
	sql = sql & " where Cod_Vestibular = v.codigo "
	sql = sql & " and N1 = 0) "
	sql = sql & " and "
	sql = sql & " codigo not in ( "
	sql = sql & " select codigo FROM SCA_VESTIBULAR_DADOS " 
	sql = sql & " where Cod_Vestibular =  v.codigo "
	sql = sql & " and N2 = 0) "
	sql = sql & " and "
	sql = sql & " codigo not in ( "
	sql = sql & " select codigo FROM SCA_VESTIBULAR_DADOS  "
	sql = sql & " where Cod_Vestibular = v.codigo "
	sql = sql & " and N3 = 0)),'0') as ProvasNaoRealizadas, "
	
	sql = sql & " isnull((select count(MA.codigo) from SCA_ALUNO MA "
	sql = sql & " inner join SCA_VESTIBULAR_DADOS MVD ON MVD.codigo = MA.Cod_ProcessoSeletivo "
	sql = sql & " where Cod_Vestibular = v.codigo "
	if strDataI <> "" and strDataF <> "" then
		sql = sql & " and convert(datetime,convert(varchar, MVD.dataInscricao, 103),103) >= convert(datetime, ' " & strDataI & " ',103) " 
		sql = sql & " and convert(datetime,convert(varchar, MVD.dataInscricao, 103),103) <= convert(datetime, ' " & strDataF & " ',103) "
	end if
	if intVestibularTipoMidia <> "0" then
		sql = sql & " and Cod_FonteDivulcacao = " & intVestibularTipoMidia
	end if	
	sql = sql & " ),'0') as Matriculados " 	
	sql = sql & " from SCA_vestibular v "
	sql = sql & " where v.cod_empresa = " & Session("CodEmpresa") 
	sql = sql & " and v.Ano_letivo = " & strAnoLetivo
	sql = sql & " and v.Semestre = " & intSemestre
	if intCodVestibular <> "0" then
		sql = sql & " and v.codigo = " & intCodVestibular
	end if	
	if intTipoProcesso <> "0" then
		sql = sql & " and v.TipoProcesso = " & intTipoProcesso
	end if	
	sql = sql & " order by data "
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			%>
			  <tr>
				<td class="celula" align="left"><div align="center"><%=formatadataAP(rs("Data"))%>&nbsp;</div></td>
				<td align="left" class="celula"><%=rs("Descricao")%>&nbsp;</td>
				<td align="left" class="celula"><div align="center"><%=rs("Inscritos")%>&nbsp;</div></td>
				<td align="left" class="celula"><div align="center"><%=rs("NaoEfetivados")%>&nbsp;</div></td>
				<td align="left" class="celula"><div align="center"><%=rs("Pago")%>&nbsp;</div></td>
				<td align="left" class="celula"><div align="right"><%=formatnumber(rs("ValorPago"),2)%></div></td>
				<td align="left" class="celula"><div align="center"><%=rs("Isentos")%></div></td>
				<td align="left" class="celula"><div align="right"><%=formatnumber(rs("ValorIsento"),2)%></div></td>
				<td class="celula" align="center"><%=rs("ProvasRealizadas")%>&nbsp;</td>
				<td class="celula"><div align="center"><%=rs("ProvasNaoRealizadas")%>&nbsp;</div></td>
				<td class="celula"><div align="center"><%=rs("Matriculados")%>&nbsp;</div></td>
			  </tr>
			<%
			Inscritos = Inscritos + rs("Inscritos")
			NaoEfetivados = NaoEfetivados + rs("NaoEfetivados")
			Pago = Pago + rs("Pago")
			ValorPago = ValorPago + rs("ValorPago")
			Isentos = Isentos + rs("Isentos")
			ValorIsento = ValorIsento + rs("ValorIsento")
			ProvasRealizadas = ProvasRealizadas + rs("ProvasRealizadas")
			ProvasNaoRealizadas = ProvasNaoRealizadas + rs("ProvasNaoRealizadas")
			Matriculados = Matriculados + rs("Matriculados")
			
			'quantidade de registros da página
			if intQtdeRegistroPorPagina = 50 then
				 intPagina = intPagina + 1
				 intQtdeRegistroPorPagina = 1
				 fimTabela
				%>
				<pre> </pre>				
				<%			
				mostraCabecalho
			end if	
			cont = cont + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			rs.movenext
		wend
		%>
        <tr bgcolor="#CCCCCC">
            <td height="29" colspan="2" align="left" class="celula"><div align="right"><strong>Totais&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong></div></td>
            <td align="left" class="celula"><div align="center"><strong><%=Inscritos%></strong></div></td>
            <td align="left" class="celula"><div align="center"><strong><%=NaoEfetivados%></strong></div></td>
            <td align="left" class="celula"><div align="center"><strong><%=Pago%></strong></div></td>
            <td align="left" class="celula"><div align="right"><strong><%=formatnumber(ValorPago,2)%></strong></div></td>
            <td align="left" class="celula"><div align="center"><strong><%=Isentos%></strong></div></td>
            <td align="left" class="celula"><div align="right"><strong><%=formatnumber(ValorIsento,2)%></strong></div></td>
            <td align="center" class="celula"><strong><%=ProvasRealizadas%></strong></td>
            <td class="celula"><div align="center"><strong><%=ProvasNaoRealizadas%></strong></div></td>
            <td class="celula"><div align="center"><strong><%=Matriculados%></strong></div></td>
      	</tr>

		  <tr>
			<td colspan="11" class="celula"><div align="center"><strong>Total de Eventos: <%=cont%></strong></div></td>
	  </tr>
		 <%
	else
		%>
		  <tr>
			<td height="171" colspan="11" align="center" class="celula"><p>&nbsp;</p>
			  <p><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></p>
		    </td>
	  </tr>
		<%
	end if
	rs.close
%>
</table>
<% if FonteDivulgacao = "S" then
	strTituloRelatorio  = strTituloRelatorio & "<BR>" & "** FONTES DE DIVULGA&Ccedil;&Otilde;ES **" 

	sub mostraCabecalho1()
	%>
	   <pre> </pre>
<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
		<br>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
		
		<tr height="29" bgcolor="#CCCCCC">
		<td width="2%" class="celula"><div align="center"><strong>M&iacute;dias</strong></div></td>
		<td width="7%" class="celula"><div align="center"><strong>Total</strong></div></td>
		<td width="7%" class="celula"><div align="center"><strong>Percentual</strong></div></td>
		</tr>
	<%
	end Sub

    intQtdeRegistroPorPagina = 1
	mostraCabecalho1

	sql = " select MD.CODIGO, "
	sql = sql & " ISNULL(MD.Descricao,'Não Informado') as Descricao, "
	sql = sql & " COUNT(VD.CODIGO) as total, "
	
	sql = sql & " ROUND((COUNT(VD.CODIGO) * 100.0) "
	sql = sql & " / "
	sql = sql & " (select COUNT(VD.CODIGO) "  
	sql = sql & " from SCA_VESTIBULAR_DADOS VD "
	sql = sql & " inner join SCA_VESTIBULAR V ON V.codigo = VD.Cod_Vestibular "
	sql = sql & " where v.cod_empresa = " & Session("CodEmpresa") 
	sql = sql & " and v.Ano_letivo = " & strAnoLetivo
	if intTipoProcesso <> "0" then
		sql = sql & " and v.Semestre = " & intSemestre
		sql = sql & " and v.TipoProcesso = " & intTipoProcesso & "),1) as Percentual "
	else	
		sql = sql & " and v.Semestre = " & intSemestre & "),1) as Percentual "
	end if	
	sql = sql & " from SCA_VESTIBULAR_DADOS VD "
	sql = sql & " inner join SCA_VESTIBULAR V ON V.codigo = VD.Cod_Vestibular "
	sql = sql & " left JOIN SCA_VESTIBULAR_TIPOS_MIDIA MD ON MD.Codigo = VD.Cod_FonteDivulcacao "
	sql = sql & " where v.cod_empresa = " & Session("CodEmpresa") 
	sql = sql & " and v.Ano_letivo = " & strAnoLetivo
	sql = sql & " and v.Semestre = " & intSemestre
	if intTipoProcesso <> "0" then
		sql = sql & " and v.TipoProcesso = " & intTipoProcesso
	end if	
	sql = sql & " GROUP BY MD.CODIGO, MD.Descricao "
	sql = sql & " order by total desc "	

	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
		
			valores = valores & ";" & rs("total")
			categoria = categoria & ";" & rs("Descricao")
			cont_conceito = cont_conceito + 1
			%>
		<tr>
		  <td align="left" class="celula">&nbsp;&nbsp;&nbsp;&nbsp;<strong><%=rs("Descricao")%></strong>&nbsp;</td>
		  <td align="left" class="celula"><div align="center"><strong><%=rs("total")%></strong>&nbsp;</div></td>
		  <td align="left" class="celula"><div align="center"><strong><%=formatnumber(rs("Percentual"),2)%></strong>%</div></td>
	  </tr>
		<%
			
			'quantidade de registros da página
			if intQtdeRegistroPorPagina = 50 then
				 intPagina = intPagina + 1
				 intQtdeRegistroPorPagina = 1
				 fimTabela
				%>
                <pre> </pre>				
                <%			
				mostraCabecalho1
			end if	
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			rs.movenext
		wend
		%>
		
		
		<%
	else
		%>
		<tr>
		  <td colspan="3" class="celula" align="center"><p><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></p>	      </td>
		</tr>
		<%
	end if
	rs.close
	%>
	</table>
	<%
end if	
%>
<table>
	<tr>
<% if Graficos = "G" then

	''
	'' GRAFICO MAPA DE ACOMPANHAMENTO
	''
	Inscritos = 0
	NaoEfetivados = 0
	Pago = 0
	ValorPago = 0
	Isentos = 0
	ValorIsento = 0
	ProvasRealizadas = 0
	ProvasNaoRealizadas = 0
	Matriculados = 0
	'
	sql = " select "
	sql = sql & " v.Data, "
	sql = sql & " v.Descricao, "
	''---
	sql = sql & " isnull((select count(codigo) from SCA_VESTIBULAR_DADOS " 
	sql = sql & " where Cod_Vestibular = v.codigo "
	if strDataI <> "" and strDataF <> "" then
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) >= convert(datetime, ' " & strDataI & " ',103) " 
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) <= convert(datetime, ' " & strDataF & " ',103) "
	end if
	if intVestibularTipoMidia <> "0" then
		sql = sql & " and Cod_FonteDivulcacao = " & intVestibularTipoMidia
	end if	
	sql = sql & " ),'0') as Inscritos, "
	''---
	sql = sql & " isnull((select count(codigo) from SCA_VESTIBULAR_DADOS " 
	sql = sql & " where Cod_Vestibular = v.codigo "
	if strDataI <> "" and strDataF <> "" then
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) >= convert(datetime, ' " & strDataI & " ',103) " 
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) <= convert(datetime, ' " & strDataF & " ',103) "
	end if
	if intVestibularTipoMidia <> "0" then
		sql = sql & " and Cod_FonteDivulcacao = " & intVestibularTipoMidia
	end if	
	sql = sql & " and datapagamento is null ),'0') as NaoEfetivados, "
	''---
	sql = sql & " isnull((select count(codigo) FROM SCA_VESTIBULAR_DADOS " 
	sql = sql & " where Cod_Vestibular =  v.codigo "
	if strDataI <> "" and strDataF <> "" then
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) >= convert(datetime, ' " & strDataI & " ',103) " 
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) <= convert(datetime, ' " & strDataF & " ',103) "
	end if
	if intVestibularTipoMidia <> "0" then
		sql = sql & " and Cod_FonteDivulcacao = " & intVestibularTipoMidia
	end if	
	sql = sql & " and cod_situacao_pagamento =  2 and isnull(ValorPagamento,'0')>0),'0') AS Pago, "
	''---
	sql = sql & " isnull((select SUM(ValorPagamento) FROM SCA_VESTIBULAR_DADOS " 
	sql = sql & " where Cod_Vestibular =  v.codigo "
	if strDataI <> "" and strDataF <> "" then
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) >= convert(datetime, ' " & strDataI & " ',103) " 
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) <= convert(datetime, ' " & strDataF & " ',103) "
	end if
	if intVestibularTipoMidia <> "0" then
		sql = sql & " and Cod_FonteDivulcacao = " & intVestibularTipoMidia
	end if	
	sql = sql & " and cod_situacao_pagamento =  2 ),'0') as ValorPago, "
	''---
	sql = sql & " isnull((select count(codigo) FROM SCA_VESTIBULAR_DADOS " 
	sql = sql & " where Cod_Vestibular = v.codigo "
	if strDataI <> "" and strDataF <> "" then
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) >= convert(datetime, ' " & strDataI & " ',103) " 
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) <= convert(datetime, ' " & strDataF & " ',103) "
	end if
	if intVestibularTipoMidia <> "0" then
		sql = sql & " and Cod_FonteDivulcacao = " & intVestibularTipoMidia
	end if	
	sql = sql & " and cod_situacao_pagamento =  2 "
	sql = sql & " and ValorPagamento  =  0 ),'0') as Isentos, "
	''---
	sql = sql & " isnull((select SUM(Valor) FROM SCA_VESTIBULAR_DADOS " 
	sql = sql & " where Cod_Vestibular = v.codigo "
	if strDataI <> "" and strDataF <> "" then
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) >= convert(datetime, ' " & strDataI & " ',103) " 
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) <= convert(datetime, ' " & strDataF & " ',103) "
	end if
	if intVestibularTipoMidia <> "0" then
		sql = sql & " and Cod_FonteDivulcacao = " & intVestibularTipoMidia
	end if	
	sql = sql & " and cod_situacao_pagamento =  2 "
	sql = sql & " and ValorPagamento  =  0 ),'0') as ValorIsento, "
	''---
	sql = sql & " isnull((select count(codigo) FROM SCA_VESTIBULAR_DADOS " 
	sql = sql & " where Cod_Vestibular = v.codigo "
	if strDataI <> "" and strDataF <> "" then
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) >= convert(datetime, ' " & strDataI & " ',103) " 
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) <= convert(datetime, ' " & strDataF & " ',103) "
	end if
	if intVestibularTipoMidia <> "0" then
		sql = sql & " and Cod_FonteDivulcacao = " & intVestibularTipoMidia
	end if	
	sql = sql & " and ( isnull(N1,'0') <> '0' " 
	sql = sql & " or isnull(N2,'0') <> '0' " 
	sql = sql & " or isnull(N3,'0') <> '0' " 
	sql = sql & " or isnull(N4,'0') <> '0' " 
	sql = sql & " or isnull(N5,'0') <> '0' )),'0') as ProvasRealizadas, "
	
	sql = sql & " isnull((select count(codigo) FROM SCA_VESTIBULAR_DADOS " 
	sql = sql & " where Cod_Vestibular = v.codigo "
	if strDataI <> "" and strDataF <> "" then
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) >= convert(datetime, ' " & strDataI & " ',103) " 
		sql = sql & " and convert(datetime,convert(varchar, dataInscricao, 103),103) <= convert(datetime, ' " & strDataF & " ',103) "
	end if
	if intVestibularTipoMidia <> "0" then
		sql = sql & " and Cod_FonteDivulcacao = " & intVestibularTipoMidia
	end if	
	sql = sql & " and isnull(N1,'') = '' "
	sql = sql & " and isnull(N2,'') = '' " 
	sql = sql & " and isnull(N3,'') = '' "
	sql = sql & " and isnull(N4,'') = '' " 
	sql = sql & " and isnull(N5,'') = '' "
	sql = sql & " and " 
	sql = sql & " codigo not in ( "
	sql = sql & " select codigo FROM SCA_VESTIBULAR_DADOS " 
	sql = sql & " where Cod_Vestibular = v.codigo "
	sql = sql & " and N1 = 0) "
	sql = sql & " and "
	sql = sql & " codigo not in ( "
	sql = sql & " select codigo FROM SCA_VESTIBULAR_DADOS " 
	sql = sql & " where Cod_Vestibular =  v.codigo "
	sql = sql & " and N2 = 0) "
	sql = sql & " and "
	sql = sql & " codigo not in ( "
	sql = sql & " select codigo FROM SCA_VESTIBULAR_DADOS  "
	sql = sql & " where Cod_Vestibular = v.codigo "
	sql = sql & " and N3 = 0)),'0') as ProvasNaoRealizadas, "
	
	sql = sql & " isnull((select count(MA.codigo) from SCA_ALUNO MA "
	sql = sql & " inner join SCA_VESTIBULAR_DADOS MVD ON MVD.codigo = MA.Cod_ProcessoSeletivo "
	sql = sql & " where Cod_Vestibular = v.codigo "
	if strDataI <> "" and strDataF <> "" then
		sql = sql & " and convert(datetime,convert(varchar, MVD.dataInscricao, 103),103) >= convert(datetime, ' " & strDataI & " ',103) " 
		sql = sql & " and convert(datetime,convert(varchar, MVD.dataInscricao, 103),103) <= convert(datetime, ' " & strDataF & " ',103) "
	end if
	if intVestibularTipoMidia <> "0" then
		sql = sql & " and Cod_FonteDivulcacao = " & intVestibularTipoMidia
	end if	
	sql = sql & " ),'0') as Matriculados " 	
	sql = sql & " from SCA_vestibular v "
	sql = sql & " where v.cod_empresa = " & Session("CodEmpresa") 
	sql = sql & " and v.Ano_letivo = " & strAnoLetivo
	sql = sql & " and v.Semestre = " & intSemestre
	if intCodVestibular <> "0" then
		sql = sql & " and v.codigo = " & intCodVestibular
	end if	
	if intTipoProcesso <> "0" then
		sql = sql & " and v.TipoProcesso = " & intTipoProcesso
	end if	
	sql = sql & " order by data "
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			Inscritos = Inscritos + rs("Inscritos")
			NaoEfetivados = NaoEfetivados + rs("NaoEfetivados")
			Pago = Pago + rs("Pago")
			ValorPago = ValorPago + rs("ValorPago")
			Isentos = Isentos + rs("Isentos")
			ValorIsento = ValorIsento + rs("ValorIsento")
			ProvasRealizadas = ProvasRealizadas + rs("ProvasRealizadas")
			ProvasNaoRealizadas = ProvasNaoRealizadas + rs("ProvasNaoRealizadas")
			Matriculados = Matriculados + rs("Matriculados")
			rs.movenext
		wend
	end if
	rs.close

	'
	' Gerando Apresentacao
	'
	ListaCategoria = ""
	ListaCategoria = ListaCategoria & "['Não Efetivados'," & NaoEfetivados & "]," 
	ListaCategoria = ListaCategoria & "['Pago'," & Pago & "]," 
	ListaCategoria = ListaCategoria & "['Isentos'," & Isentos & "]" 
	%>
    <!--Load the AJAX API-->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">

      // Load the Visualization API and the piechart package.
      google.load('visualization', '1.0', {'packages':['corechart','table']});

      // Set a callback to run when the Google Visualization API is loaded.
      google.setOnLoadCallback(drawChart);

      // Callback that creates and populates a data table,
      // instantiates the pie chart, passes in the data and
      // draws it.
      function drawChart() {

        // Create the data table.
        var data = new google.visualization.DataTable();
        //data.addColumn('string', 'Topping');
        //data.addColumn('number', 'Slices');
		data.addColumn('string', 'Mídias');
		data.addColumn('number', 'Valores');
        data.addRows([
          <%=ListaCategoria%>
        ]);

        // Set chart options
        var options = {'title':'INSCRIÇÕES - <%=msgTituloRelatorio%>',
					   'legend':'center',
					   'is3D':true,
					   'width':500,
                       'height':500};

        // Instantiate and draw our chart, passing in some options.
		//ColumnChart  
		//PieChart
		//LineChart 
        var chart = new google.visualization.PieChart(document.getElementById('chart_div'));
        chart.draw(data, options);
      }
    </script>
    <!--Div that will hold the pie chart-->
    <td>
    <div align="center" id="chart_div"></div>
    </td>
    <%
	'Fim Apresentacao







end if	
%>
	</tr>
</table>

<script>
	aguarde.style.display="none";
</script>
</body>
</html>




