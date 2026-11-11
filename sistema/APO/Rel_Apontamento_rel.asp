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
	    	  <td height="15" colspan="12" class="celula"><div align="center"><strong><%=strSubTitulo%></strong></div></td>
      		</tr>
	  <% end if %>	 
	
	  <tr bgcolor="#CCCCCC">
	    <td width="4%" rowspan="2" class="celula"><strong>Cod. Func.</strong></td>
	    <td width="25%" rowspan="2" class="celula"><div align="center"><strong>Colaboradores</strong></div></td>
        <td width="25%" rowspan="2" class="celula"><div align="center"><strong>Unidade</strong></div></td>
	    <td width="7%" rowspan="2" class="celula"><div align="center"><strong>Data</strong></div></td>
	    <td width="5%" rowspan="2" class="celula"><strong>Dia da Semana</strong></td>
	    <td height="15" colspan="2" class="celula"><div align="center"><strong>Hor&aacute;rio/Modulação</strong></div></td>
	    <td colspan="2" class="celula"><div align="center"><strong>Horário/Apontamento</strong></div></td>
	    <td colspan="2" class="celula"><div align="center"><strong>C&aacute;lculo</strong></div></td>
        <td class="celula" rowspan="2"><div align="center"><strong>Situação</strong></div></td>
      </tr>
	  <tr bgcolor="#CCCCCC">
	    <td width="5%" class="celula"><div align="center">Situa&ccedil;&atilde;o</div></td>
	    <td width="7%" height="15" class="celula">	      <p align="center">Horas</p></td>
	    <td width="6%" class="celula"><div align="center">Situa&ccedil;&atilde;o</div></td>
	    <td width="7%" class="celula"><div align="center">Horas</div></td>
        <td width="4%" align="center" class="celula"><strong>Atrasos</strong></td>
	    <td width="6%" align="center" class="celula"><strong>Excedente</strong></td>
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
	
	    MarcaColaborador = "0"

		sql = " SELECT DISTINCT CODIGO"
		sql = sql & " from SRH_COLABORADOR "
		sql = sql & " where codigo in (" & strCodFunc & ")"
		rs.open sql, cnn
		if rs.eof = false then
			while not rs.eof
                DataControle = DataInicial
				
				Do while year(DataControle) & zeroleft(month(DataControle),2) & zeroleft(day(DataControle),2) <= year(DataFinal) & zeroleft(month(DataFinal),2) & zeroleft(day(DataFinal),2)

					intcodColaborador	= trim(rs("codigo")) 
					strDataApontamento 	= trim(formatadataBD(DataControle)) 
					diaSemana		 	= trim(weekday(DataControle)) 
	
					'Capturando as marcações
					sql = "SELECT  min(SUBSTRING(CAST(PM.Hora AS VARCHAR(8)),1,2) + SUBSTRING(CAST(PM.Hora AS VARCHAR(8)),4,2)) as horaMarcacao,c.codFuncional as Matricula, PM.Data,C.nome, datepart(DW,PM.Data) AS Cod_DiaSemana, case when PM.COLETOR=999 then 'SECRETARIA MUN. DA EDUC. DE APARECIDA DE GOIANIA' else ISNULL(E.RAZAOSOCIAL,'') end AS RAZAOSOCIAL"
					sql = sql & "  FROM GEMUL5.DBO.COLETA PM "
					sql = sql & "  inner join SRH_COLABORADOR C ON C.codFuncional = PM.codi_func "
					sql = sql & "  left join SEG_EMPRESA E ON E.CODIGO = PM.COLETOR "
					sql = sql & "  WHERE c.codigo = " & intcodColaborador
					sql = sql & "  AND PM.Data = '" & strDataApontamento & "' AND (datepart(DW,PM.Data)) = " & diaSemana
					sql = sql & "  group by c.codFuncional, PM.Data,C.nome, datepart(DW,PM.Data), E.RAZAOSOCIAL, PM.COLETOR"
					sql = sql & "  union"
					sql = sql & "  SELECT  max(SUBSTRING(CAST(PM.Hora AS VARCHAR(8)),1,2) + SUBSTRING(CAST(PM.Hora AS VARCHAR(8)),4,2)) as horaMarcacao,c.codFuncional as Matricula, PM.Data,C.nome, datepart(DW,PM.Data) AS Cod_DiaSemana, case when PM.COLETOR=999 then 'SECRETARIA MUN. DA EDUC. DE APARECIDA DE GOIANIA' else ISNULL(E.RAZAOSOCIAL,'') end AS RAZAOSOCIAL"
					sql = sql & "  FROM GEMUL5.DBO.COLETA PM "
					sql = sql & "  inner join SRH_COLABORADOR C ON C.codFuncional = PM.codi_func "
					sql = sql & "  left join SEG_EMPRESA E ON E.CODIGO = PM.COLETOR "
					sql = sql & "  WHERE c.codigo = " & intcodColaborador
					sql = sql & "  AND PM.Data = '" & strDataApontamento & "' AND (datepart(DW,PM.Data)) = " & diaSemana
					sql = sql & "  group by c.codFuncional, PM.Data,C.nome, datepart(DW,PM.Data), E.RAZAOSOCIAL, PM.COLETOR"
					rsaux.open sql, cnn
					' Capturando as tabelas de horários
					sql = " select ROW_NUMBER() OVER (ORDER BY PHC.HORA_INICIO, PHC.MINUTO_INICIO) AS ORDEM, C.codFuncional as Matricula, C.nome, PHC.DIASEMANA, PHC.HORA_INICIO as HoraHorario, PHC.MINUTO_INICIO as MinutoHorario, ISNULL(E.RAZAOSOCIAL,'') AS RAZAOSOCIAL "
					sql = sql & " from APO_FAIXA_HORARIO_COLABORADOR PHC "
					sql = sql & " inner join SRH_COLABORADOR C ON C.codigo = PHC.Cod_Colaborador "
					sql = sql & " inner join SEG_EMPRESA E ON E.CODIGO = PHC.Cod_empresa "
					sql = sql & " WHERE C.codigo = " & intcodColaborador
					sql = sql & " and PHC.DIASEMANA = " & diaSemana
					sql = sql & " UNION select ROW_NUMBER() OVER (ORDER BY PHC.HORA_INICIO, PHC.MINUTO_INICIO) AS ORDEM, C.codFuncional as Matricula, C.nome, PHC.DIASEMANA, PHC.HORA_TERMINO as HoraHorario, PHC.MINUTO_TERMINO as MinutoHorario, ISNULL(E.RAZAOSOCIAL,'') AS RAZAOSOCIAL "
					sql = sql & " from APO_FAIXA_HORARIO_COLABORADOR PHC "
					sql = sql & " inner join SRH_COLABORADOR C ON C.codigo = PHC.Cod_Colaborador "
					sql = sql & " inner join SEG_EMPRESA E ON E.CODIGO = PHC.Cod_empresa "
					sql = sql & " WHERE C.codigo = " & intcodColaborador
					sql = sql & " and PHC.DIASEMANA = " & diaSemana
					sql = sql & " order by C.nome, PHC.DIASEMANA, 1, PHC.HORA_INICIO, PHC.MINUTO_INICIO "	
					'response.write sql & "<hr>"
					rs1.open sql, cnn
					if rs1.eof = false then
						controlaEntradaSaida = 1
						while not rs1.eof
							
							if rsaux.eof = false then
								if not isnull(left(rsaux("horaMarcacao"),2))  then HoraMarcacao 	= left(rsaux("horaMarcacao"),2)
								if not isnull(right(rsaux("horaMarcacao"),2)) then MinutoMarcacao 	= right(rsaux("horaMarcacao"),2)
								if not isnull(left(rsaux("horaMarcacao"),2)) then HoraMarcacao1 	= left(rsaux("horaMarcacao"),2)
								if not isnull(right(rsaux("horaMarcacao"),2)) then MinutoMarcacao1 	= right(rsaux("horaMarcacao"),2)
								razaosocial = rsaux("RAZAOSOCIAL")
							else
								HoraMarcacao = 0	
								MinutoMarcacao = 0
								HoraMarcacao1 = "-----"	
								MinutoMarcacao1 = "-----"	
								razaosocial = "&nbsp;"
							end if
							
							'if rsaux("HoraHorario") < rs1("HoraHorario") then
							
							if (controlaEntradaSaida MOD 2) = 0 then
								strEntradaSaida = "Saída"
								strCorLinha = " bgcolor='#EEEEEE' "
							else
								strEntradaSaida = "Entrada"
								strCorLinha = " bgcolor='#FFFFFF' "
							end if 

							IF trim(razaosocial)="" or razaosocial="&nbsp;" then
								razaosocial = "<font color='#FF0000'>" & rs1("RAZAOSOCIAL") & "</font>"
							end if
							
							HoraHorario = clng((rs1("HoraHorario")) * 60) + clng(rs1("MinutoHorario"))
							HoraMarcacao = (clng(HoraMarcacao) * 60) + clng(MinutoMarcacao)
							Calculo = (clng(HoraHorario) - clng(HoraMarcacao))
							HoraCalculada = abs(Calculo)
							if abs(Calculo) < 60 then
								HoraCalculada = 0
								MinutoCalculado = Calculo
								'
								AtrasoHoraCalculada = 0
								if strEntradaSaida = "Entrada" then
									if MinutoCalculado < 0 then 
									   AtrasoMinutoCalculado = abs(Calculo)
									else   
									   ExcedenteMinutoCalculado = abs(Calculo)
									end if
								else
									if MinutoCalculado < 0 then 
									   ExcedenteMinutoCalculado = abs(Calculo)
									else   
									   AtrasoMinutoCalculado = abs(Calculo)
									end if
								end if	
									   
							else	
								HoraCalculada = int(Calculo/60)
								MinutoCalculado = Calculo mod 60
								
								if strEntradaSaida = "Entrada" then
									if HoraCalculada < 0 then 
									   AtrasoHoraCalculada = int(abs(Calculo)/60)
									else   
									   ExcedenteHoraCalculado = int(abs(Calculo)/60)
									end if  
								 else
									if HoraCalculada < 0 then 
									   ExcedenteHoraCalculado = int(abs(Calculo)/60)
									else   
									   AtrasoHoraCalculada = int(abs(Calculo)/60)
									end if  
								end if
	
								if strEntradaSaida = "Entrada" then
									if MinutoCalculado < 0 then 
									   AtrasoMinutoCalculado = abs(Calculo) mod 60
									else   
									   ExcedenteMinutoCalculado = abs(Calculo) mod 60
									end if   
								else
									if MinutoCalculado < 0 then 
									   ExcedenteMinutoCalculado = abs(Calculo) mod 60
									else   
									   AtrasoMinutoCalculado = abs(Calculo) mod 60
									end if
								end if	   
							end if	
	
							'verifica se é dia letivo no calendário
							checafalta = "Nao"
							sql = "select ce.letivo "
							sql = sql & " from sca_calendario_dia c"
							sql = sql & " inner join sca_calendario_evento ce on ce.cod_calendario_evento = c.cod_calendario_evento"
							sql = sql & " where c.mes=" & month(strDataApontamento)
							sql = sql & " and c.dia_mes = " & day(strDataApontamento)
							sql = sql & " and c.dia_semana = " & rs1("DIASEMANA")
							rsaux1.open sql, cnn
							if rsaux1.eof = false then	
								if rsaux1("letivo")="S" then
									checafalta = "Sim"
								end if
							end if	
							rsaux1.close	
							statusFalta=""
							if checafalta = "Sim" then
								if HoraMarcacao1 = "-----" then
									statusFalta = "Falta"
								else
									if cInt(AtrasoHoraCalculada)>=1 then
										statusFalta = "Falta"
									else
										if cInt(AtrasoMinutoCalculado)>15 then
											statusFalta = "Falta"
										end if
									end if
								end if
							end if
							%>
							  <tr >
								<% if MarcaColaborador = "0" then 
									MarcaColaborador = "1"
									%> 
									<td align="left" class="celula"><strong><%=rs1("Matricula")%></strong>&nbsp;</td>
									<td height="19" align="left" class="celula"><strong><%=rs1("nome")%></strong>&nbsp;</td>
								<% else %>
								   <td align="left" class="celula">&nbsp;</td>
									<td height="19" align="left" class="celula">&nbsp;</td>
								<% end if %>
                                <td height="19" align="left" class="celula"><strong><%=razaosocial%></strong>&nbsp;</td>
								<td <%=strCorLinha%> align="center" class="celula"><%=trim(formatadataAP(strDataApontamento))%></td>
								<td <%=strCorLinha%> align="left" class="celula"><%=weekdayname(rs1("DIASEMANA"))%></td>
								<td <%=strCorLinha%> align="left" class="celula"><div align="center"><%=strEntradaSaida%></div></td>
								<td <%=strCorLinha%> align="left" class="celula"><div align="center"><%=zeroleft(rs1("HoraHorario"),2)%>:<%=zeroleft(rs1("MinutoHorario"),2)%>&nbsp;</div></td>
								<% if HoraMarcacao1 <> "-----" then %>
									<td <%=strCorLinha%> align="left" class="celula"><div align="center"><%=strEntradaSaida%></div></td>
									<td <%=strCorLinha%> align="left" class="celula"><div align="center"><%=zeroleft(HoraMarcacao1,2)%>:<%=zeroleft(MinutoMarcacao1,2)%>&nbsp;</div></td>
									<td <%=strCorLinha%> align="left" class="celula"><div align="center"><strong><%=zeroleft(AtrasoHoraCalculada,2)%>:<%=zeroleft(AtrasoMinutoCalculado,2)%>&nbsp;</strong></div></td>
									<td <%=strCorLinha%> align="left" class="celula"><div align="center"><strong><%=zeroleft(ExcedenteHoraCalculada,2)%>:<%=zeroleft(ExcedenteMinutoCalculado,2)%></strong></div></td>
								<% else %>    
									<td <%=strCorLinha%> align="left" class="celula"><div align="center"><%=strEntradaSaida%></div></td>
									<td <%=strCorLinha%> align="left" class="celula"><div align="center"><%=HoraMarcacao1%>:<%=MinutoMarcacao1%>&nbsp;</div></td>
									<td <%=strCorLinha%> align="left" class="celula"><div align="center">-----:-----&nbsp;</div></td>
									<td <%=strCorLinha%> align="left" class="celula"><div align="center">-----:-----</div></td>
								<% end if %>    
                                <td <%=strCorLinha%> height="19" align="center" class="celula"><strong><%=statusFalta%></strong>&nbsp;</td>
							  </tr>
							<%
							AtrasoHoraCalculada = 0
							ExcedenteHoraCalculado = 0
							AtrasoMinutoCalculado = 0
							ExcedenteMinutoCalculado = 0
	
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
							controlaEntradaSaida = controlaEntradaSaida + 1
	
							rs1.movenext
							if rsaux.eof = false then
								rsaux.movenext
							end if	
							
						wend
						rs1.close
						rsaux.close
					else
						rs1.close
						rsaux.close
					end if	
	
					 DataControle = DateAdd("d", 1, DataControle)
				 
				loop

				
				rs.movenext	
				
				if rs.eof = false then
					intcodColaborador1	= trim(rs("codigo"))
				else
				    intcodColaborador1	= ""
				end if	
				
                if trim(intcodColaborador) <> trim(intcodColaborador1) then
					%>				
					  <tr bgcolor="#CCCCCC">
						<td height="19" colspan="15" align="left" class="celula">&nbsp;</td>
					 </tr>
					<%
				   MarcaColaborador = "0"
				end if
			wend
		end if 
		rs.close
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