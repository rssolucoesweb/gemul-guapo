<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
SESSION.Timeout = 1200
%>
<!--include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
					response.write "inicio"
	strCodEmpresa 			= 16'Session("cmbEmpresa")
	strReferencia			= 95'Trim(Request.Form("cmbCategoria"))	
	
	'sql = "SELECT Codigo, AnoReferencia, MesReferencia, SemestreReferencia, Data_Inicial, Data_Final"
'	sql = sql & " FROM SRH_MODULACAO_REFERENCIA"
'	sql = sql & " where codigo =" & strReferencia
'	rs.open sql, cnn
'	if rs.eof = false then
'		DataInicial		= rs("Data_Inicial")
'		DataFinal		= rs("Data_Final")
'		DataControle	= rs("Data_Final")
'	end if
'	rs.close

	DataInicial		= DateAdd("d", -3, date)
	DataFinal		= DataInicial
	DataControle	= DataInicial

	
	'DataInicial = Trim(Request("txtDataInicial"))
	'DataFinal = Trim(Request("txtDataFinal"))
	'DataControle = Trim(Request("txtDataInicial"))

	if trim(strCodEmpresa) <> "" and  DataInicial <> "" and DataFinal <> ""  then
	
	    MarcaColaborador = "0"

		sql = " SELECT DISTINCT c.CODIGO"
		sql = sql & " from SRH_COLABORADOR c inner join seg_empresa e on e.codigo=c.codLotacao "
		sql = sql & " where c.situacao = 'A' and e.cod_grupo=7"
'		sql = sql & " where PM.data between '" & formatadataBD(DataInicial) & "' and '" & formatadataBD(DataFinal) & "'"
		rs.open sql, cnn
		if rs.eof = false then
			while not rs.eof
                DataControle = DataInicial
				strDataValidacao = ""
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
							
							if (controlaEntradaSaida MOD 2) = 0 then
								strEntradaSaida = "Saída"
							else
								strEntradaSaida = "Entrada"
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
							response.Write "<hr>strDataValidacao:" &  strDataValidacao
							response.Write "<br>strDataApontamento:" &  strDataApontamento
							if trim(statusFalta) = "Falta" and trim(strDataValidacao)<>trim(strDataApontamento) then
								sql = "insert into APO_faltas (cod_colaborador, data) values (" & intcodColaborador & ",'" & formatadataBD(strDataApontamento) & "')"
								response.write sql & "<hr>"
								cnn.execute sql
								strDataValidacao = strDataApontamento
							end if

							AtrasoHoraCalculada = 0
							ExcedenteHoraCalculado = 0
							AtrasoMinutoCalculado = 0
							ExcedenteMinutoCalculado = 0
	
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
				   MarcaColaborador = "0"
				end if
			wend
		end if 
		rs.close
		
		%>
		<script>
			alert("Atualização finalizada!");
			window.history.back();
		</script>
		<%
		response.end

	else
		%>
		<script>
			alert("Colaborador não foi encontrato ou a data informada é inválida, verifique.");
			
		</script>
		<%
		response.end
	end if 
%>
