<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))

	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
   	strNumeroAula       = request("aulas")
    strHoraRelogio      = request("minutos")
	intCodTurno	       	= Trim(Request.Form("cmbTurno"))
	intCodSequenciaAula	= Trim(Request.Form("cmbSequenciaAula"))
	intCodTempoAula		= Trim(Request.Form("cmbTempoAula"))

	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
		
	end if
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
	
		sql = "Insert Into esp_faixa_horario(Ano_Letivo, Horario, aulas, minutos, Cod_Turno, Sequencia, Tempo)"
		sql = sql & " Values ("
		sql = sql & "" & strAnoLetivo & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "" & strNumeroAula & ","
		sql = sql & "" & strHoraRelogio & ","
		sql = sql & "" & intCodTurno & ","
		sql = sql & "" & intCodSequenciaAula & ","
		sql = sql & "" & intCodTempoAula & ")"
		cnn.execute sql
		GravarLog sql
	
	' Duplica o Ano anterior
	elseif acao="D" then
		
		strMensagem = "Registro copiado para ano informado..."
		
		' Consulta dados do ano Anterior
		sql = "SELECT codigo, horario, aulas, minutos, Cod_Turno, Sequencia, Tempo FROM esp_faixa_horario "
		sql = sql & " where Anoletivo = " & strAnoLetivoAnt
		rs.open sql, cnn
		if rs.eof = false then
			vetrs = rs.getRows
		end if
		rs.close
				
		for j=0 to ubound(vetrs,2)

			cont = cont + 1	

			strhorario  		= vetrs(2,j) 
			strNumeroAula  		= vetrs(3,j) 
			strHoraRelogio 		= vetrs(4,j) 
			intCodTurno			= vetrs(5,j) 
			intCodSequenciaAula	= vetrs(6,j)
			intCodTempoAula		= vetrs(7,j) 
			
			if isnull(intCodSequenciaAula) or intCodSequenciaAula = "" then intCodSequenciaAula = "0"
			if isnull(intCodTempoAula) or intCodTempoAula = "" then intCodTempoAula = "0"
					
			sql = "Insert Into esp_faixa_horario( Ano_Letivo, Horario, aulas, minutos, Cod_Turno, Sequencia, Tempo)"
			sql = sql & " Values ("
			sql = sql & "" & strAnoLetivo & ","
			sql = sql & "'" & strhorario & "',"
			sql = sql & "" & strNumeroAula & ","
			sql = sql & "" & strHoraRelogio & ","
			sql = sql & "" & intCodTurno & ","
			sql = sql & "" & intCodSequenciaAula & ","
			sql = sql & "" & intCodTempoAula & ")"
			cnn.execute sql
			
		next

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."

		sql = " Update esp_faixa_horario Set"
		sql = sql & " horario = '" & strDescricao & "',"
		sql = sql & " aulas = " & strNumeroAula & ","
		sql = sql & " minutos = " & strHoraRelogio & ","
		sql = sql & " Cod_Turno = " & intCodTurno & ","
		sql = sql & " Tempo = " & intCodTempoAula & ","
		sql = sql & " Sequencia = " & intCodSequenciaAula
		sql = sql & " where codigo = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
	elseif acao="E" then
	
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete from esp_faixa_horario "
		sql = sql & " where codigo = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
	end if
	
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='esp_faixa_horario.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>