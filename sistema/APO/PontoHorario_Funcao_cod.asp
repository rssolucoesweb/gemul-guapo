<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
	<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	'cnn.begintrans
	acao 						= Trim(Request.QueryString("acao"))

	intCodigo	 				= Trim(Request.Form("txtCodigo"))
	intCodFuncao				= Trim(Request.Form("cmbFuncao"))
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

	sql = " select modular "
	sql = sql & " FROM SRH_FUNCAOCOLABORADOR "
	sql = sql & " where cod_funcao  = " & intCodFuncao 
	rs.open sql, cnn
	if rs.eof = false then
		modular = rs("modular")
	end if
	rs.close

	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."

		' Deleta a Tabela de Especial Colaborador 
		sql = "Delete from APO_PONTOHORARIO_FUNCAO "
		sql = sql & " where cod_funcao=" & intCodFuncao
		sql = sql & " and Cod_PontoHorario in ( select codigo from APO_PONTOHORARIO where Cod_turno in (" & intCodTurno & "))"
		cnn.execute sql
		GravarLog sql
		
		for i=2 to 7
		
			if str_SiglaTurno <> "I" then 'Quando nao for Integral

				if intPontoHorarioEntradaManha <> "0" and intPontoHorarioEntradaManha <> "" then 
					sql = "Insert Into APO_PONTOHORARIO_FUNCAO ( Cod_Funcao, Cod_DiaSemana, Cod_PontoHorario ) "
					sql = sql & " Values ("
					sql = sql & "" & intCodFuncao & ","
					sql = sql & "" & i & ","
					sql = sql & "" & intPontoHorarioEntradaManha & ")"
					cnn.execute sql	
					GravarLog sql
					
					IF intPontoHorarioEntradaManhaAnterior = "" THEN intPontoHorarioEntradaManhaAnterior = "0"
					sql = "Insert Into APO_Ocorrencia ( pagina, acao, Cod_Funcao, cod_PontoHorario_anterior, cod_PontoHorario_novo, usuario, datahora ) "
					sql = sql & " Values ("
					sql = sql & "'PontoHorario_funcao_cod.asp',"
					sql = sql & "'" & acao & "',"
					sql = sql & "" & intCodFuncao & ","
					sql = sql & "" & intPontoHorarioEntradaManhaAnterior & ","
					sql = sql & "" & intPontoHorarioEntradaManha & ","
					sql = sql & "'" & Session("UsuarioWeb") & "',"
					sql = sql & "getdate())"
					cnn.execute sql	
	
				end if	
				if intPontoHorarioSaidaManha <> "0" and intPontoHorarioSaidaManha <> "" then 
					sql = "Insert Into APO_PONTOHORARIO_FUNCAO ( Cod_Funcao, Cod_DiaSemana, Cod_PontoHorario ) "
					sql = sql & " Values ("
					sql = sql & "" & intCodFuncao & ","
					sql = sql & "" & i & ","
					sql = sql & "" & intPontoHorarioSaidaManha & ")"
					cnn.execute sql	
					GravarLog sql
	
					IF intPontoHorarioSaidaManhaAnterior = "" THEN intPontoHorarioSaidaManhaAnterior = "0"
					sql = "Insert Into APO_Ocorrencia ( pagina, acao, Cod_Funcao, cod_PontoHorario_anterior, cod_PontoHorario_novo, usuario, datahora ) "
					sql = sql & " Values ("
					sql = sql & "'PontoHorario_funcao_cod.asp',"
					sql = sql & "'" & acao & "',"
					sql = sql & "" & intCodFuncao & ","
					sql = sql & "" & intPontoHorarioSaidaManhaAnterior & ","
					sql = sql & "" & intPontoHorarioSaidaManha & ","
					sql = sql & "'" & Session("UsuarioWeb") & "',"
					sql = sql & "getdate())"
					cnn.execute sql	
					
				end if	
				if intPontoHorarioEntradaTarde <> "0" and intPontoHorarioEntradaTarde <> "" then 
					sql = "Insert Into APO_PONTOHORARIO_FUNCAO ( Cod_Funcao, Cod_DiaSemana, Cod_PontoHorario ) "
					sql = sql & " Values ("
					sql = sql & "" & intCodFuncao & ","
					sql = sql & "" & i & ","
					sql = sql & "" & intPontoHorarioEntradaTarde & ")"
					cnn.execute sql	
					GravarLog sql
					
					IF intPontoHorarioEntradaTardeAnterior = "" THEN intPontoHorarioEntradaTardeAnterior = "0"
					sql = "Insert Into APO_Ocorrencia ( pagina, acao, Cod_Funcao, cod_PontoHorario_anterior, cod_PontoHorario_novo, usuario, datahora ) "
					sql = sql & " Values ("
					sql = sql & "'PontoHorario_funcao_cod.asp',"
					sql = sql & "'" & acao & "',"
					sql = sql & "" & intCodFuncao & ","
					sql = sql & "" & intPontoHorarioEntradaTardeAnterior & ","
					sql = sql & "" & intPontoHorarioEntradaTarde & ","
					sql = sql & "'" & Session("UsuarioWeb") & "',"
					sql = sql & "getdate())"
					cnn.execute sql	
					
				end if	
				if intPontoHorarioSaidaTarde <> "0" and intPontoHorarioSaidaTarde <> "" then 
					sql = "Insert Into APO_PONTOHORARIO_FUNCAO ( Cod_Funcao, Cod_DiaSemana, Cod_PontoHorario ) "
					sql = sql & " Values ("
					sql = sql & "" & intCodFuncao & ","
					sql = sql & "" & i & ","
					sql = sql & "" & intPontoHorarioSaidaTarde & ")"
					cnn.execute sql	
					GravarLog sql
					
					IF intPontoHorarioSaidaTardeAnterior = "" THEN intPontoHorarioSaidaTardeAnterior = "0"
					sql = "Insert Into APO_Ocorrencia ( pagina, acao, Cod_Funcao, cod_PontoHorario_anterior, cod_PontoHorario_novo, usuario, datahora ) "
					sql = sql & " Values ("
					sql = sql & "'PontoHorario_funcao_cod.asp',"
					sql = sql & "'" & acao & "',"
					sql = sql & "" & intCodFuncao & ","
					sql = sql & "" & intPontoHorarioSaidaTardeAnterior & ","
					sql = sql & "" & intPontoHorarioSaidaTarde & ","
					sql = sql & "'" & Session("UsuarioWeb") & "',"
					sql = sql & "getdate())"
					cnn.execute sql	
					
				end if	

			end if
			
			if str_SiglaTurno = "I" then 'Quando nao for Integral

				if intPontoHorarioEntradaIntegralMatutino <> "0" and intPontoHorarioEntradaIntegralMatutino <> "" then 
					sql = "Insert Into APO_PONTOHORARIO_FUNCAO ( Cod_Funcao, Cod_DiaSemana, Cod_PontoHorario ) "
					sql = sql & " Values ("
					sql = sql & "" & intCodFuncao & ","
					sql = sql & "" & i & ","
					sql = sql & "" & intPontoHorarioEntradaIntegralMatutino & ")"
					cnn.execute sql	
					GravarLog sql
					
					IF intPontoHorarioEntradaIntegralMatutinoAnterior = "" THEN intPontoHorarioEntradaIntegralMatutinoAnterior = "0"
					sql = "Insert Into APO_Ocorrencia ( pagina, acao, Cod_Funcao, cod_PontoHorario_anterior, cod_PontoHorario_novo, usuario, datahora ) "
					sql = sql & " Values ("
					sql = sql & "'PontoHorario_funcao_cod.asp',"
					sql = sql & "'" & acao & "',"
					sql = sql & "" & intCodFuncao & ","
					sql = sql & "" & intPontoHorarioEntradaIntegralMatutinoAnterior & ","
					sql = sql & "" & intPontoHorarioEntradaIntegralMatutino & ","
					sql = sql & "'" & Session("UsuarioWeb") & "',"
					sql = sql & "getdate())"
					cnn.execute sql	
	
				end if	
				if intPontoHorarioSaidaIntegralMatutino <> "0" and intPontoHorarioSaidaIntegralMatutino <> "" then 
					sql = "Insert Into APO_PONTOHORARIO_FUNCAO ( Cod_Funcao, Cod_DiaSemana, Cod_PontoHorario ) "
					sql = sql & " Values ("
					sql = sql & "" & intCodFuncao & ","
					sql = sql & "" & i & ","
					sql = sql & "" & intPontoHorarioSaidaIntegralMatutino & ")"
					cnn.execute sql	
					GravarLog sql
	
					IF intPontoHorarioSaidaIntegralMatutinoAnterior = "" THEN intPontoHorarioSaidaIntegralMatutinoAnterior = "0"
					sql = "Insert Into APO_Ocorrencia ( pagina, acao, Cod_Funcao, cod_PontoHorario_anterior, cod_PontoHorario_novo, usuario, datahora ) "
					sql = sql & " Values ("
					sql = sql & "'PontoHorario_funcao_cod.asp',"
					sql = sql & "'" & acao & "',"
					sql = sql & "" & intCodFuncao & ","
					sql = sql & "" & intPontoHorarioSaidaIntegralMatutinoAnterior & ","
					sql = sql & "" & intPontoHorarioSaidaIntegralMatutino & ","
					sql = sql & "'" & Session("UsuarioWeb") & "',"
					sql = sql & "getdate())"
					cnn.execute sql	
					
				end if	
				if intPontoHorarioEntradaIntegralTarde <> "0" and intPontoHorarioEntradaIntegralTarde <> "" then 
					sql = "Insert Into APO_PONTOHORARIO_FUNCAO ( Cod_Funcao, Cod_DiaSemana, Cod_PontoHorario ) "
					sql = sql & " Values ("
					sql = sql & "" & intCodFuncao & ","
					sql = sql & "" & i & ","
					sql = sql & "" & intPontoHorarioEntradaIntegralTarde & ")"
					cnn.execute sql	
					GravarLog sql
					
					IF intPontoHorarioEntradaIntegralTardeAnterior = "" THEN intPontoHorarioEntradaIntegralTardeAnterior = "0"
					sql = "Insert Into APO_Ocorrencia ( pagina, acao, Cod_Funcao, cod_PontoHorario_anterior, cod_PontoHorario_novo, usuario, datahora ) "
					sql = sql & " Values ("
					sql = sql & "'PontoHorario_funcao_cod.asp',"
					sql = sql & "'" & acao & "',"
					sql = sql & "" & intCodFuncao & ","
					sql = sql & "" & intPontoHorarioEntradaIntegralTardeAnterior & ","
					sql = sql & "" & intPontoHorarioEntradaIntegralTarde & ","
					sql = sql & "'" & Session("UsuarioWeb") & "',"
					sql = sql & "getdate())"
					cnn.execute sql	
					
				end if	
				if intPontoHorarioSaidaIntegralTarde <> "0" and intPontoHorarioSaidaIntegralTarde <> "" then 
					sql = "Insert Into APO_PONTOHORARIO_FUNCAO ( Cod_Funcao, Cod_DiaSemana, Cod_PontoHorario ) "
					sql = sql & " Values ("
					sql = sql & "" & intCodFuncao & ","
					sql = sql & "" & i & ","
					sql = sql & "" & intPontoHorarioSaidaIntegralTarde & ")"
					cnn.execute sql	
					GravarLog sql
					
					IF intPontoHorarioSaidaIntegralTardeAnterior = "" THEN intPontoHorarioSaidaIntegralTardeAnterior = "0"
					sql = "Insert Into APO_Ocorrencia ( pagina, acao, Cod_Funcao, cod_PontoHorario_anterior, cod_PontoHorario_novo, usuario, datahora ) "
					sql = sql & " Values ("
					sql = sql & "'PontoHorario_funcao_cod.asp',"
					sql = sql & "'" & acao & "',"
					sql = sql & "" & intCodFuncao & ","
					sql = sql & "" & intPontoHorarioSaidaIntegralTardeAnterior & ","
					sql = sql & "" & intPontoHorarioSaidaIntegralTarde & ","
					sql = sql & "'" & Session("UsuarioWeb") & "',"
					sql = sql & "getdate())"
					cnn.execute sql	
					
				end if	

			end if
				
		next

		vetFuncao = null
		sql = "select codigo from srh_colaborador where codFuncao = " & intCodFuncao & " and situacao = 'A'"
		rs.open sql, cnn
		if not rs.eof then
			vetFuncao = rs.getRows
		end if
		rs.close
		
		if isArray(vetFuncao) then
			for i=0 to ubound(vetFuncao,2)
	
				intCodFunc  	= vetFuncao(0,i) 

				'ATUALIZA PONTO - FAIXA 
				sql = "EXECUTE SP_APO_Atualiza_Faixa_Horario " & year(date) & "," & session("CodGrupo") & "," & intCodFunc
				'response.write sql & "<hr>" 
				cnn.execute sql
		
			next
		end if


	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."

		vetFuncao = null
		sql = "select codigo from srh_colaborador where codFuncao = " & intCodFuncao & " and situacao = 'A'"
		rs.open sql, cnn
		if not rs.eof then
			vetFuncao = rs.getRows
		end if
		rs.close
		
		if isArray(vetFuncao) then
			for i=0 to ubound(vetFuncao,2)
	
				intCodFunc  	= vetFuncao(0,i) 

				'ATUALIZA PONTO - FAIXA 
				sql = "EXECUTE SP_APO_Atualiza_Faixa_Horario " & year(date) & "," & session("CodGrupo") & "," & intCodFunc
				'response.write sql & "<hr>" 
				cnn.execute sql
		
			next
		end if
		
    else
	
		strMensagem = "Registro Excluido com sucesso..."

		sql = "insert APO_Ocorrencia "
		sql = sql & " select DISTINCT 'PontoHorario_funcao_cod.asp', '" & acao & "', Cod_Funcao, Cod_PontoHorario,0,'" & Session("UsuarioWeb") & "',getdate() "
		sql = sql & " from APO_PONTOHORARIO_FUNCAO "
		sql = sql & " Where Cod_Funcao = " & intCodFuncao
		sql = sql & " and Cod_PontoHorario in ( SELECT DISTINCT Cod_PontoHorario FROM APO_PONTOHORARIO_FUNCAO WHERE Cod_Funcao = " & intCodFuncao & " )"
		cnn.execute sql

		vetFuncao = null
		sql = "select codigo from srh_colaborador where codFuncao = " & intCodFuncao & " and situacao = 'A'"
		rs.open sql, cnn
		if not rs.eof then
			vetFuncao = rs.getRows
		end if
		rs.close
		
		if isArray(vetFuncao) then
			for i=0 to ubound(vetFuncao,2)
	
				intCodFunc  	= vetFuncao(0,i) 

				'ATUALIZA PONTO - FAIXA 
				sql = "EXECUTE SP_APO_Atualiza_Faixa_Horario " & year(date) & "," & session("CodGrupo") & "," & intCodFunc
				'response.write sql & "<hr>" 
				cnn.execute sql
		
			next
		end if
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		'cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='PontoHorario_Funcao_cad.asp?cmbFuncao=<%=intCodFuncao%>';
		</script>
		<%
		response.end
	else
		'cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>