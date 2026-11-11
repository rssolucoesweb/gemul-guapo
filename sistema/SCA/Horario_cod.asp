<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 29/07/2008
	::	Desenvolvedores...: Sergio Borges - Sergiob76@gmail.com
	::	Objetivo Pagina...: Cadastro de Regime 
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
 	strHoraInicio 		= Trim(Request.Form("txtHoraInicio"))
	strMinutoInicio 	= Trim(Request.Form("txtMinutoInicio"))
	strHoraTermino 		= Trim(Request.Form("txtHoraTermino"))
	strMinutoTermino 	= Trim(Request.Form("txtMinutoTermino"))
   	strNumeroAula       = request("txtNumeroAula")
    strHoraRelogio      = request("txtHoraRelogio")
	intCodTurno	       	= Trim(Request.Form("cmbTurno"))
	intCodSequenciaAula	= Trim(Request.Form("cmbSequenciaAula"))
	intCodTempoAula		= Trim(Request.Form("cmbTempoAula"))

	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
		
	end if
	if trim(request("cmbSemestre")) = "" then 
		strSemestre = session("strSemestre")
	else
		strSemestre = request("cmbSemestre")
	end if
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "Insert Into SCA_horario(Cod_Empresa, AnoLetivo, Semestre, Horario, hora_Inicio, minuto_Inicio, hora_termino, minuto_termino, Numero_aula, Hora_relogio, CodTurno, Sequencia_Aulas,Tempo)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & strAnoLetivo & ","
		sql = sql & "" & strSemestre & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "" & strHoraInicio & ","
		sql = sql & "" & strMinutoInicio & ","
		sql = sql & "" & strHoraTermino & ","
		sql = sql & "" & strMinutoTermino & ","
		sql = sql & "" & strNumeroAula & ","
		sql = sql & "" & strHoraRelogio & ","
		sql = sql & "" & intCodTurno & ","
		sql = sql & "" & intCodSequenciaAula & ","
		sql = sql & "" & intCodTempoAula & ")"
		'cnn.execute sql
		'GravarLog sql
	
		sql = "Insert Into SCA_horario(Cod_Empresa, AnoLetivo, Semestre, Horario, Numero_aula, Hora_relogio, CodTurno, Sequencia_Aulas,Tempo)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & strAnoLetivo & ","
		sql = sql & "" & strSemestre & ","
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
		
		strMensagem = "Registro Duplicado para Ano e Semestre informado..."
		
		' Pega o Ano Anterior
	   if Session("strSemestre") = "1" then
	  	  strAnoLetivoAnt = Trim(Request.Form("txtAnoLetivo")) - 1
		  strSemestreAnt	 = 2
	   elseif Session("strSemestre") = "2" then
		  strAnoLetivoAnt = Trim(Request.Form("txtAnoLetivo"))
		  strSemestreAnt	 = 1
	   elseif Session("strSemestre") = "3" then
		  strAnoLetivoAnt = Trim(Request.Form("txtAnoLetivo")) - 1
		  strSemestreAnt	 = 3
	   end if
	   
	   
		
		' Apaga o resgito do novo ano 
		sql = " Delete From SCA_horario "
		sql = sql & " where Anoletivo = " & strAnoLetivo
		sql = sql & " and semestre in (" & strSemestre & ")"
		sql = sql & " and Cod_Empresa = " & Session("CodEmpresa")	
		cnn.execute sql
		GravarLog sql
		
		' Consulta dados do ano Anterior
		sql = "SELECT codigo, cod_empresa, horario, numero_aula, hora_relogio, CodTurno, Sequencia_Aulas, Tempo FROM SCA_HORARIO "
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
		sql = sql & " and Anoletivo = " & strAnoLetivoAnt
		rs.open sql, cnn
		if rs.eof = false then
			vetrs = rs.getRows
		end if
		rs.close

		if isArray(vetrs) then

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
						
				sql = "Insert Into SCA_horario(Cod_Empresa, AnoLetivo, Semestre, Horario, Numero_aula, Hora_relogio, CodTurno, Sequencia_Aulas, Tempo)"
				sql = sql & " Values ("
				sql = sql & "" & intCodEmp & ","
				sql = sql & "" & strAnoLetivo & ","
				sql = sql & "" & strSemestre & ","
				sql = sql & "'" & strhorario & "',"
				sql = sql & "" & strNumeroAula & ","
				sql = sql & "" & strHoraRelogio & ","
				sql = sql & "" & intCodTurno & ","
				sql = sql & "" & intCodSequenciaAula & ","
				sql = sql & "" & intCodTempoAula & ")"
				cnn.execute sql
				GravarLog sql
				
			next
		else
		   cnn.rollbackTrans
		   %>
			<script>
				alert("ATENÇÃO! Não existe registro de horário para o ano e semestre anterior. Verifique!");
				window.location='horario_cad.asp';
			</script>
			<%
            response.end
		end if

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."

		sql = " Update SCA_horario Set"
		sql = sql & " horario = '" & strDescricao & "',"
		'sql = sql & " hora_Inicio = " & strHoraInicio & ","
		'sql = sql & " minuto_Inicio = " & strMinutoInicio & ","
		'sql = sql & " hora_termino = " & strHoraTermino & ","
		'sql = sql & " minuto_termino = " & strMinutoTermino & ","
		sql = sql & " numero_aula = " & strNumeroAula & ","
		sql = sql & " hora_relogio = " & strHoraRelogio & ","
		sql = sql & " CodTurno = " & intCodTurno & ","
		sql = sql & " Tempo = " & intCodTempoAula & ","
		sql = sql & " Sequencia_Aulas = " & intCodSequenciaAula
		sql = sql & " where codigo = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
	elseif acao="E" then
	
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete from SCA_horario "
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
			window.location='Horario_cad.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		
		if err.number = "-2147217873" then
			%>
			<script>
              alert("ATENÇÃO: Já existe essa faixa de horário informada no HORARIO AULA, verifique!.");
               window.history.back();
            </script>
			<%
		
		end if
		response.end
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>