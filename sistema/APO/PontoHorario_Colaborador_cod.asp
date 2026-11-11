<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/02/2010
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Colaborador Folha - Modulação Folha de Pagamento
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
	<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	acao 						= Trim(Request.QueryString("acao"))

	intCodigo	 				= Trim(Request.Form("txtCodigo"))
	intCodFuncionario			= Trim(Request.Form("txtCodFuncionario"))
	intCodTurno					= Trim(Request.Form("cmbTurno"))
	intPontoHorarioEntradaManha	= Trim(Request.Form("cmbPontoHorarioEntradaManha"))
	intPontoHorarioSaidaManha	= Trim(Request.Form("cmbPontoHorarioSaidaManha"))
	intPontoHorarioEntradaTarde	= Trim(Request.Form("cmbPontoHorarioEntradaTarde"))
	intPontoHorarioSaidaTarde	= Trim(Request.Form("cmbPontoHorarioSaidaTarde"))
	'
	intPontoHorarioEntradaManhaAnterior	= Trim(Request.Form("cmbPontoHorarioEntradaManha"))
	intPontoHorarioSaidaManhaAnterior	= Trim(Request.Form("cmbPontoHorarioSaidaManha"))
	intPontoHorarioEntradaTardeAnterior	= Trim(Request.Form("cmbPontoHorarioEntradaTarde"))
	intPontoHorarioSaidaTardeAnterior	= Trim(Request.Form("cmbPontoHorarioSaidaTarde"))
	'
	intPontoHorarioEntradaIntegralMatutino		= Trim(Request.Form("cmbPontoHorarioEntradaIntegralMatutino"))
	intPontoHorarioSaidaIntegralMatutino		= Trim(Request.Form("cmbPontoHorarioSaidaIntegralMatutino"))
	intPontoHorarioEntradaIntegralTarde			= Trim(Request.Form("cmbPontoHorarioEntradaIntegralTarde"))
	intPontoHorarioSaidaIntegralTarde			= Trim(Request.Form("cmbPontoHorarioSaidaIntegralTarde"))
	'
	intPontoHorarioEntradaIntegralMatutinoAnterior		= Trim(Request.Form("cmbPontoHorarioEntradaIntegralMatutino"))
	intPontoHorarioSaidaIntegralMatutinoAnterior		= Trim(Request.Form("cmbPontoHorarioSaidaIntegralMatutino"))
	intPontoHorarioEntradaIntegralTardeAnterior			= Trim(Request.Form("cmbPontoHorarioEntradaIntegralTarde"))
	intPontoHorarioSaidaIntegralTardeAnterior			= Trim(Request.Form("cmbPontoHorarioSaidaIntegralTarde"))

	if intCodTurno <> "" then
		str_SiglaTurno = ""
		sql = "SELECT SUBSTRING(DESC_TURNO,1,1) AS SIGLA_TURNO "
		sql = sql & " FROM SRH_TURNO"
		SQL = SQL & " WHERE COD_TURNO = " & intCodTurno
		rs.open sql, cnn
		if rs.eof = false then
			str_SiglaTurno				= rs("SIGLA_TURNO")
		end if 
		rs.close
	end if

	if acao="I" then

		strMensagem = "Registro Salvo com sucesso..."

		intCodLocatacao = "0"
		sql = " select CodTurno, codLotacao " 
		sql = sql & " from SRH_COLABORADOR " 
		sql = sql & " where codigo = " & intCodFuncionario
		rs.open sql, cnn
		if rs.eof = false then
			intCodLocatacao = rs("codLotacao")
		else
			%>
			<script>
				alert("Atencao! Verifique a Alocacao");
				window.location='PontoHorario_Colaborador_Cad.asp';
			</script>
			<%
			response.end
		end if
		rs.close

		sql = "Delete " 
		sql = sql & " from APO_PONTOHORARIO_COLABORADOR "  
		sql = sql & " where codigo in (SELECT pc.codigo "  
		sql = sql & " from APO_PONTOHORARIO_COLABORADOR PC " 
		sql = sql & " INNER JOIN APO_PONTOHORARIO P ON P.Codigo = PC.Cod_PontoHorario " 
		sql = sql & " where Cod_Colaborador = " & intCodFuncionario
		sql = sql & " and cod_turno = " & intCodTurno & ")"
		cnn.execute sql
		GravarLog sql
	
		for i=2 to 7
		
			if str_SiglaTurno <> "I" then 'Quando nao for Integral
				if intPontoHorarioEntradaManha <> "0" and intPontoHorarioEntradaManha <> "" then 
					sql = "Insert Into APO_PONTOHORARIO_COLABORADOR ( Cod_Colaborador, Cod_DiaSemana, Cod_PontoHorario ) "
					sql = sql & " Values ("
					sql = sql & "" & intCodFuncionario & ","
					sql = sql & "" & i & ","
					sql = sql & "" & intPontoHorarioEntradaManha & ")"
					cnn.execute sql	
					GravarLog sql
				end if	
				if intPontoHorarioSaidaManha <> "0" and intPontoHorarioSaidaManha <> "" then 
					sql = "Insert Into APO_PONTOHORARIO_COLABORADOR ( Cod_Colaborador, Cod_DiaSemana, Cod_PontoHorario ) "
					sql = sql & " Values ("
					sql = sql & "" & intCodFuncionario & ","
					sql = sql & "" & i & ","
					sql = sql & "" & intPontoHorarioSaidaManha & ")"
					cnn.execute sql	
					GravarLog sql
				end if	
				if intPontoHorarioEntradaTarde <> "0" and intPontoHorarioEntradaTarde <> "" then 
					sql = "Insert Into APO_PONTOHORARIO_COLABORADOR ( Cod_Colaborador, Cod_DiaSemana, Cod_PontoHorario ) "
					sql = sql & " Values ("
					sql = sql & "" & intCodFuncionario & ","
					sql = sql & "" & i & ","
					sql = sql & "" & intPontoHorarioEntradaTarde & ")"
					cnn.execute sql	
					GravarLog sql
				end if	
				if intPontoHorarioSaidaTarde <> "0" and intPontoHorarioSaidaTarde <> "" then 
					sql = "Insert Into APO_PONTOHORARIO_COLABORADOR ( Cod_Colaborador, Cod_DiaSemana, Cod_PontoHorario ) "
					sql = sql & " Values ("
					sql = sql & "" & intCodFuncionario & ","
					sql = sql & "" & i & ","
					sql = sql & "" & intPontoHorarioSaidaTarde & ")"
					cnn.execute sql	
					GravarLog sql
				end if	
			end if

			if str_SiglaTurno = "I" then 'Quando for Integral
				if intPontoHorarioEntradaIntegralMatutino <> "0" and intPontoHorarioEntradaIntegralMatutino <> "" then 
					sql = "Insert Into APO_PONTOHORARIO_COLABORADOR ( Cod_Colaborador, Cod_DiaSemana, Cod_PontoHorario ) "
					sql = sql & " Values ("
					sql = sql & "" & intCodFuncionario & ","
					sql = sql & "" & i & ","
					sql = sql & "" & intPontoHorarioEntradaIntegralMatutino & ")"
					cnn.execute sql	
					GravarLog sql
				end if	
				if intPontoHorarioSaidaIntegralMatutino <> "0" and intPontoHorarioSaidaIntegralMatutino <> "" then 
					sql = "Insert Into APO_PONTOHORARIO_COLABORADOR ( Cod_Colaborador, Cod_DiaSemana, Cod_PontoHorario ) "
					sql = sql & " Values ("
					sql = sql & "" & intCodFuncionario & ","
					sql = sql & "" & i & ","
					sql = sql & "" & intPontoHorarioSaidaIntegralMatutino & ")"
					cnn.execute sql	
					GravarLog sql
				end if	
				if intPontoHorarioEntradaIntegralTarde <> "0" and intPontoHorarioEntradaIntegralTarde <> "" then 
					sql = "Insert Into APO_PONTOHORARIO_COLABORADOR ( Cod_Colaborador, Cod_DiaSemana, Cod_PontoHorario ) "
					sql = sql & " Values ("
					sql = sql & "" & intCodFuncionario & ","
					sql = sql & "" & i & ","
					sql = sql & "" & intPontoHorarioEntradaIntegralTarde & ")"
					cnn.execute sql	
					GravarLog sql
				end if	
				if intPontoHorarioSaidaIntegralTarde <> "0" and intPontoHorarioSaidaIntegralTarde <> "" then 
					sql = "Insert Into APO_PONTOHORARIO_COLABORADOR ( Cod_Colaborador, Cod_DiaSemana, Cod_PontoHorario ) "
					sql = sql & " Values ("
					sql = sql & "" & intCodFuncionario & ","
					sql = sql & "" & i & ","
					sql = sql & "" & intPontoHorarioSaidaIntegralTarde & ")"
					cnn.execute sql	
					GravarLog sql
				end if	
			end if
				
		next

		'Atualiza Faixa Horario Colaborador
		sql = " delete from APO_FAIXA_HORARIO_COLABORADOR"
		sql = sql & " where Cod_Colaborador = " & intCodFuncionario
		sql = sql & " and cod_turno = " & intCodTurno
		cnn.execute sql
		GravarLog sql

		for i=2 to 7

			sql = " SELECT distinct ph.Cod_turno " 
			sql = sql & " FROM APO_PONTOHORARIO_COLABORADOR PHC " 
			sql = sql & " INNER JOIN APO_PONTOHORARIO PH ON PH.CODIGO = PHC.Cod_PontoHorario "  
			sql = sql & " WHERE PHC.Cod_Colaborador = " & intCodFuncionario
			sql = sql & " and Cod_DiaSemana = " & i
			rs.open sql, cnn
			if rs.eof = false then
 				while not rs.eof
				
					strHoraInicio	= "" 
					strMinutoInicio	= ""
					strHoraFim		= ""
					strMinutoFim    = ""
		
					if str_SiglaTurno <> "I" then 'Quando nao for Integral
						sql = " select TOP 1 H.hora, H.Minuto "  
						sql = sql & " from APO_PONTOHORARIO_COLABORADOR  HC " 
						sql = sql & " inner join APO_PONTOHORARIO h on h.codigo=HC.Cod_PontoHorario "
						sql = sql & " where HC.Cod_Colaborador = " & intCodFuncionario
						sql = sql & " and HC.Cod_DiaSemana = " & i
						sql = sql & " and H.tipo = 'E' " 
						sql = sql & " and H.Cod_turno = " & rs("Cod_Turno") 
						sql = sql & " order by h.hora, H.Minuto "
						rsaux.open sql, cnn
						if rsaux.eof = false then
							strHoraInicio = rsaux("hora")
							strMinutoInicio = rsaux("minuto")
						end if
						rsaux.close
					
						sql = " select TOP 1 H.hora, H.Minuto "  
						sql = sql & " from APO_PONTOHORARIO_COLABORADOR  HC " 
						sql = sql & " inner join APO_PONTOHORARIO h on h.codigo=HC.Cod_PontoHorario "
						sql = sql & " where HC.Cod_Colaborador = " & intCodFuncionario
						sql = sql & " and HC.Cod_DiaSemana = " & i
						sql = sql & " and H.tipo = 'S' " 
						sql = sql & " and H.Cod_turno = " & rs("Cod_Turno")
						sql = sql & " order by h.hora, H.Minuto desc "
						rsaux.open sql, cnn
						if rsaux.eof = false then
							strHoraFim = rsaux("hora")
							strMinutoFim = rsaux("minuto")
						end if
						rsaux.close
					
						if strHoraInicio <> "" and  strMinutoInicio <> "" and  strHoraFim <> "" and  strMinutoFim<> "" then
							sql = "insert APO_FAIXA_HORARIO_COLABORADOR "
							sql = sql & " select distinct " & intCodLocatacao & ", HC.Cod_Colaborador," & intCodTurno & ", "&i&", " & strHoraInicio &", " & strMinutoInicio &", " & strHoraFim &", " & strMinutoFim 
							sql = sql & " from APO_PONTOHORARIO_COLABORADOR HC " 
							sql = sql & " inner join APO_PONTOHORARIO h on h.codigo=HC.Cod_PontoHorario "
							sql = sql & " where hc.Cod_Colaborador = " & intCodFuncionario
							sql = sql & " and h.Cod_turno = " & rs("Cod_Turno")
							sql = sql & " and hc.Cod_DiaSemana = " & i
							cnn.execute sql	
							GravarLog sql
						end if
					else
						strHoraInicioM="" 
						strMinutoInicioM=""
						strHoraFimM=""
						strMinutoFimM=""
						strHoraInicioV="" 
						strMinutoInicioV=""
						strHoraFimV=""
						strMinutoFimV=""
			
						'INTEGRAL
						'atualiza o horario novo para a função alterada

						sql = " select TOP 1 H.hora, H.Minuto "  
						sql = sql & " from APO_PONTOHORARIO_COLABORADOR  HC " 
						sql = sql & " inner join APO_PONTOHORARIO h on h.codigo=HC.Cod_PontoHorario "
						sql = sql & " where HC.Cod_Colaborador = " & intCodFuncionario
						sql = sql & " and HC.Cod_DiaSemana = " & i
						sql = sql & " and H.tipo = 'E' " 
						sql = sql & " and H.Cod_turno = " & rs("Cod_Turno") 
						sql = sql & " order by h.hora "
						rsaux.open sql, cnn
						if rsaux.eof = false then
							strHoraInicioM = rsaux("hora")
							strMinutoInicioM = rsaux("minuto")
						end if
						rsaux.close
						
						sql = " select TOP 1 H.hora, H.Minuto "  
						sql = sql & " from APO_PONTOHORARIO_COLABORADOR  HC " 
						sql = sql & " inner join APO_PONTOHORARIO h on h.codigo=HC.Cod_PontoHorario "
						sql = sql & " where HC.Cod_Colaborador = " & intCodFuncionario
						sql = sql & " and HC.Cod_DiaSemana = " & i
						sql = sql & " and H.tipo = 'E' " 
						sql = sql & " and H.Cod_turno = " & rs("Cod_Turno") 
						sql = sql & " order by h.hora desc "
						rsaux.open sql, cnn
						if rsaux.eof = false then
							strHoraInicioV = rsaux("hora")
							strMinutoInicioV = rsaux("minuto")
						end if
						rsaux.close
			
						sql = " select TOP 1 H.hora, H.Minuto "  
						sql = sql & " from APO_PONTOHORARIO_COLABORADOR  HC " 
						sql = sql & " inner join APO_PONTOHORARIO h on h.codigo=HC.Cod_PontoHorario "
						sql = sql & " where HC.Cod_Colaborador = " & intCodFuncionario
						sql = sql & " and HC.Cod_DiaSemana = " & i
						sql = sql & " and H.tipo = 'S' " 
						sql = sql & " and H.Cod_turno = " & rs("Cod_Turno") 
						sql = sql & " order by h.hora "
						rsaux.open sql, cnn
						if rsaux.eof = false then
							strHoraFimM = rsaux("hora")
							strMinutoFimM = rsaux("minuto")
						end if
						rsaux.close
						
						sql = " select TOP 1 H.hora, H.Minuto "  
						sql = sql & " from APO_PONTOHORARIO_COLABORADOR  HC " 
						sql = sql & " inner join APO_PONTOHORARIO h on h.codigo=HC.Cod_PontoHorario "
						sql = sql & " where HC.Cod_Colaborador = " & intCodFuncionario
						sql = sql & " and HC.Cod_DiaSemana = " & i
						sql = sql & " and H.tipo = 'S' " 
						sql = sql & " and H.Cod_turno = " & rs("Cod_Turno") 
						sql = sql & " order by h.hora desc"
						rsaux.open sql, cnn
						if rsaux.eof = false then
							strHoraFimV = rsaux("hora")
							strMinutoFimV = rsaux("minuto")
						end if
						rsaux.close
					end if
					if strHoraInicioM <> "" and  strMinutoInicioM <> "" and  strHoraFimM <> "" and  strMinutoFimM<> "" then
						sql = "insert APO_FAIXA_HORARIO_COLABORADOR "
						sql = sql & " select distinct " & intCodLocatacao & ", HC.Cod_Colaborador," & intCodTurno & ", "&i&", " & strHoraInicioM &", " & strMinutoInicioM &", " & strHoraFimM &", " & strMinutoFimM 
						sql = sql & " from APO_PONTOHORARIO_COLABORADOR HC " 
						sql = sql & " inner join APO_PONTOHORARIO h on h.codigo=HC.Cod_PontoHorario "
						sql = sql & " where hc.Cod_Colaborador = " & intCodFuncionario
						sql = sql & " and h.Cod_turno = " & rs("Cod_Turno")
						sql = sql & " and hc.Cod_DiaSemana = " & i
						cnn.execute sql	
						GravarLog sql
					end if
					if strHoraInicioV <> "" and  strMinutoInicioV <> "" and  strHoraFimV <> "" and  strMinutoFimV<> "" then
						sql = "insert APO_FAIXA_HORARIO_COLABORADOR "
						sql = sql & " select distinct " & intCodLocatacao & ", HC.Cod_Colaborador," & intCodTurno & ", "&i&", " & strHoraInicioV &", " & strMinutoInicioV &", " & strHoraFimV &", " & strMinutoFimV
						sql = sql & " from APO_PONTOHORARIO_COLABORADOR HC " 
						sql = sql & " inner join APO_PONTOHORARIO h on h.codigo=HC.Cod_PontoHorario "
						sql = sql & " where hc.Cod_Colaborador = " & intCodFuncionario
						sql = sql & " and h.Cod_turno = " & rs("Cod_Turno")
						sql = sql & " and hc.Cod_DiaSemana = " & i
						cnn.execute sql	
						GravarLog sql
					end if

					rs.movenext

				wend
			end if
			rs.close
			
		next

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."

		sql = " delete from APO_FAIXA_HORARIO_COLABORADOR"
		sql = sql & " where Cod_Colaborador = " & intCodFuncionario
		sql = sql & " and cod_turno = " & intCodTurno
		cnn.execute sql
		GravarLog sql
		
		sql = "Delete " 
		sql = sql & " from APO_PONTOHORARIO_COLABORADOR "  
		sql = sql & " where codigo in (SELECT pc.codigo "  
		sql = sql & " from APO_PONTOHORARIO_COLABORADOR PC " 
		sql = sql & " INNER JOIN APO_PONTOHORARIO P ON P.Codigo = PC.Cod_PontoHorario " 
		sql = sql & " where Cod_Colaborador = " & intCodFuncionario
		sql = sql & " and cod_turno = " & intCodTurno & ")"
		cnn.execute sql
		GravarLog sql

		if intCodFuncionario <> "" then
			strAnoLetivo	= session("strAnoLetivo")
			'ATUALIZA PONTO - FAIXA 
			sql = "EXECUTE SP_APO_Atualiza_Faixa_Horario " & strAnoLetivo & "," & session("CodGrupo") & "," & intCodFuncionario
			cnn.execute sql
		end if
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='PontoHorario_Colaborador_Cad.asp';
		</script>
		<%
		response.end
	else
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>