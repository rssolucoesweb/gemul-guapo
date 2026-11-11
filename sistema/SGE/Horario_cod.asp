	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 23/03/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Cadastro de Regime
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	
	paginaRetorno			= "Regime_cad.asp"
	strAcao 				= Request.QueryString("acao")

	intCodEmp			= Session("CodEmpresa")
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strDescricaoAntiga	= Trim(Request.Form("txtDescricaoAntiga"))
    strNumeroAula       = request("txtNumeroAula")
    strHoraRelogio      = request("txtHoraRelogio")
	strTurno	       	= Trim(Request.Form("cmbTurno"))
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

	'on error resume next
	
	cnn.begintrans

	if strAcao = "I" then  
		
		'*****************************************************************
		'todas unidades
		vetCodTodasEmpresa	= split(Session("CodTodasEmpresaGrupo"),",")
		
		
		'percorre todas unidades
		for i=0 to ubound(vetCodTodasEmpresa)
		
			intCodEmp = vetCodTodasEmpresa(i)
			bolExiste = false
			
			sql = "SELECT Cod_Turno, Desc_Turno " 
			sql = sql & " FROM SCA_TURNO"
			sql = sql & " where Desc_Turno = '" & trim(strTurno) & "'"
			rs.open sql, cnn
			if not RS.EOF then
				intCodTurno = trim(rs("Cod_Turno"))
			end if
			rs.close
		
			sql = "SELECT horario " 
			sql = sql & " FROM SCA_horario"
			sql = sql & " where AnoLetivo = " & strAnoLetivo
			sql = sql & " and Semestre = " & strSemestre 
			sql = sql & " and Horario = '" & strDescricaoAntiga & "'"
			rs.open sql, cnn
			if not RS.EOF then
				bolExiste = true
			end if
			rs.close
			
			if bolExiste=false then
			
				strMensagem = "Registro Salvo com sucesso..."
				
				sql = "Insert Into SCA_horario( AnoLetivo, Semestre, Horario, Numero_aula, Hora_relogio, CodTurno, Sequencia_Aulas, Tempo)"
				sql = sql & " Values ("
				sql = sql & "" & strAnoLetivo & ","
				sql = sql & "" & strSemestre & ","
				sql = sql & "'" & strDescricao & "',"
				sql = sql & "" & strNumeroAula & ","
				sql = sql & "" & strHoraRelogio & ","
				sql = sql & "" & intCodTurno & ","
				sql = sql & "" & intCodSequenciaAula & ","
				sql = sql & "" & intCodTempoAula & ")"
				cnn.execute sql
			else
				strMensagem = "Registro Alterado com sucesso..."
				sql = "Update SCA_horario Set"
				sql = sql & " horario = '" & strDescricao & "',"
				sql = sql & " numero_aula = " & strNumeroAula & ","
				sql = sql & " hora_relogio = " & strHoraRelogio & ","
				sql = sql & " CodTurno = " & intCodTurno & ","
				sql = sql & " Sequencia_Aulas = " & intCodSequenciaAula & ","
				sql = sql & " Tempo = " & intCodTempoAula
				sql = sql & " where AnoLetivo = " & strAnoLetivo
				sql = sql & " and Semestre = " & strSemestre 
				sql = sql & " and Horario = '" & strDescricaoAntiga & "'"
				cnn.execute sql
			end if
			
		next
		
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
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>