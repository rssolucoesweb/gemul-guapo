<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 15/03/2010
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Ficha Individual do Colaborador
-->
<html>
<head>
<title><%=session("Titulo")%> - Ficha Individual do Aluno</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--  include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file=../../includes/inc_aguarde.asp-->
<br>
<%
	dim intPagina
	
	strCod_empresa 			= Session("CodEmpresa")
	strCodFunc				= Trim(Request("txtCodFunc"))
	
	
	
	if strCodFunc = "" then
		strCodFunc			=	Trim(Request.form("chkFunc"))
	end if
	intCodCategoria			= Trim(Request.Form("cmbCategoria"))	
	
'	
	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <% if strSubTitulo <> "" then %>
	  		<tr bgcolor="#CCCCCC">
	    	  <td height="15" colspan="10" class="celula"><div align="center"><strong><%=strSubTitulo%></strong></div></td>
      		</tr>
	  <% end if %>	 
	
	  <tr bgcolor="#CCCCCC">
	    <td width="20%" rowspan="2" class="celula"><div align="center"><strong>Unidade</strong></div></td>
	    <td width="5%" rowspan="2" class="celula"><div align="center"><strong>Data</strong></div></td>
	    <td width="5%" rowspan="2" align="center" class="celula"><strong>Semana</strong></td>
	    <td  height="15" colspan="2" class="celula"><div align="center"><strong>Hor&aacute;rio/Modulação</strong></div></td>
	    <td  colspan="2" class="celula"><div align="center"><strong>Horário/Apontamento</strong></div></td>
	    <td width="15%" rowspan="2" align="center" class="celula"><strong>Justificativa</strong></td>
	    <td width="15%" rowspan="2" align="center" class="celula"><strong>Calendário</strong></td>
	    <td width="2%" rowspan="2" align="center" class="celula"><strong>Falta</strong></td>
      </tr>
	  <tr bgcolor="#CCCCCC">
	    <td width="5%" align="center" class="celula"><strong>Início</strong></td>
	    <td width="5%" height="15" align="center" class="celula">	      <p align="center"><strong>Término</strong></p></td>
	    <td width="5%" align="center" class="celula"><strong>Início</strong></td>
	    <td width="5%" align="center" class="celula"><div align="center"><strong>Término</strong></div></td>
      </tr>
	  
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	DataInicial = Trim(Request("txtDataInicial"))
	DataFinal = Trim(Request("txtDataFinal"))
	DataControle = Trim(Request("txtDataInicial"))

	strTituloRelatorio  	= "APONTAMENTO DE COLABORADORES <BR> Período de: " & formatadataAP(Trim(Request("txtDataInicial"))) & " a " & formatadataAP(Trim(Request("txtDataFinal")))

	intPagina = 1
	mostraCabecalho


	if trim(strCodFunc) <> "" and  DataInicial <> "" and DataFinal <> ""  then
	
	    cont = 0

		sql = " SELECT *, case when falta_periodo=1 then 'X' else ' ' end as falta"
		sql = sql & " from APO_APONTAMENTO "
		sql = sql & " where cod_colaborador in (" & strCodFunc & ")"
		sql = sql & " and data between '" & formatadataBD(DataInicial) & "' and '" & formatadataBD(DataFinal) & "' order by colaborador, cod_funcional, data, diasemana, faixa_inicio"
		rs.open sql, cnn
		if rs.eof = false then
			while not rs.eof
			
				if trim(colaborador) <> trim(rs("colaborador")) then
					if cont>0 then
						total_falta = 0
						sql = "SELECT distinct cod_colaborador, data from APO_APONTAMENTO_FALTA  where cod_colaborador =" & cod_colaborador & "  and data between '" & formatadataBD(DataInicial) & "' and '" & formatadataBD(DataFinal) & "'" 
						rs1.open sql, cnn,3,1
						if rs1.eof = false then
							total_falta = rs1.recordCount
						end if
						rs1.close
						%>
						<tr  bgcolor="#AAD5FF" >
                            <td height="19" colspan="9" align="right" class="celula"><strong>Total de Faltas no Período&nbsp;<% response.write formatadataAP(Trim(DataInicial)) & " a " & formatadataAP(Trim(DataFinal))%></strong>&nbsp;</td>
                            <td height="19" align="center" class="celula"><strong><%=total_falta%></strong></td>
                        </tr>
						<%
						fimTabela
						%>
						<pre></pre>				
						<%	
						intPagina = intPagina + 1		
						mostraCabecalho
					end if
					%>				
					  <tr bgcolor="#AAD5FF">
						<td height="25" colspan="10" align="center" class="celula" ><font size="+1"><%=rs("cod_funcional")%> - <%=rs("colaborador")%></font></td>
					 </tr>
					<%
				end if
				calendario = " "	
				if rs("dia_letivo") = "N" then calendario = rs("evento")	
				
				justificativa = " "	
				if not isnull(rs("cod_JustificativaFaltas")) then justificativa = rs("justificativa") & " (" & 	formatadataAP(Trim(rs("justificativa_inicio"))) & " a " & formatadataAP(Trim(rs("justificativa_termino"))) & ")"
				
				if data<>rs("data") then
					if strCorLinha = "" then
						strCorLinha = "bgcolor='#D7EBFF'"
					else
						strCorLinha = ""
					end if
				end if
				%>
				  <tr <%=strCorLinha%> >
					<td height="19" align="left" class="celula"><%=rs("lotacao")%>&nbsp;(<%=rs("cod_lotacao")%>)&nbsp;</td>
					<td align="center" class="celula"><%=trim(formatadataAP(rs("data")))%></td>
					<td align="left" class="celula"><%=rs("DIASEMANA")%></td>
					<td align="center" class="celula"><%=rs("faixa_inicio")%></td>
					<td align="center" class="celula"><div align="center"><%=rs("faixa_termino")%>&nbsp;</div></td>
					<td align="center" class="celula"><%=rs("batida_inicio")%></td>
                    <td align="center" class="celula"><div align="center"><%=rs("batida_termino")%>&nbsp;</div></td>
                    <td align="center" class="celula"><%=justificativa%>&nbsp;</td>
                    <td align="center" class="celula"><%=calendario%>&nbsp;</td>
					<td height="19" align="center" class="celula"><strong><%=rs("falta")%></strong>&nbsp;</td>
				  </tr>
				<%
				colaborador = rs("colaborador")
				cod_colaborador = rs("cod_colaborador")
				data=rs("data")
				'quantidade de registros da página
				if intQtdeRegistroPorPagina = 50 then
					 intPagina = intPagina + 1
					 intQtdeRegistroPorPagina = 1
					 fimTabela
					%>
					<pre></pre>				
					<%			
					mostraCabecalho
				end if	
				cont = cont + 1
				
				rs.movenext	
               
			wend
			rs.close
			
			total_falta = 0
			sql = "SELECT distinct cod_colaborador, data from APO_APONTAMENTO_FALTA  where cod_colaborador =" & cod_colaborador & "  and data between '" & formatadataBD(DataInicial) & "' and '" & formatadataBD(DataFinal) & "'" 
			rs1.open sql, cnn,3,1
			if rs1.eof = false then
				total_falta = rs1.recordCount
			end if
			rs1.close
			%>
			<tr  bgcolor="#AAD5FF" >
				<td height="19" colspan="9" align="right" class="celula"><strong>Total de Faltas no Período&nbsp;<% response.write formatadataAP(Trim(DataInicial)) & " a " & formatadataAP(Trim(DataFinal))%></strong>&nbsp;</td>
				<td height="19" align="center" class="celula"><strong><%=total_falta%></strong></td>
			</tr>
			<%
		else
		rs.close
			%>
			<tr >
                <td height="155" colspan="10" align="center" class="celula" bgcolor="#9BCDFF"><strong>Nunhum registro encontrado!</strong></td>
			<%
		end if 
		
	else
		%>
		<script>
			alert("Colaborador não foi encontrato ou a data informada é inválida, verifique.");
			window.history.back();
		</script>
		<%
		response.end
	end if 
%>
</table>

<script>
	aguarde.style.display="none";
</script>
</body>
</html>