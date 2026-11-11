<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 29/07/2008
	::	Desenvolvedores...: Sergio Borges - Sergiob76@gmail.com
	::	Objetivo Pagina...: Cadastro de Regime 
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodEmp				= Session("CodEmpresa")
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strSemestre 			= session("strSemestre")
	strAnoLetivo 			= session("strAnoLetivo")

	strSala		 			= Trim(Request.Form("txtSala"))
	strDataReserva 			= formatadataBD(Trim(Request.Form("txtDataReserva")))
	intCodHorarioAula 		= Trim(Request.Form("txtCodHorarioAula"))
	intCodSequenciaAulas	= Trim(Request.Form("txtCodSequenciaAulas"))

	intCodHorario			= Trim(Request.Form("cmbHorario"))
	intCodEquipamento		= Trim(Request.Form("cmbEquipamento"))
	strDataSolicitacao		= formatadataBD(date)
	strTipoAtividade        = Trim(Request.Form("optOpcao"))
	if strTipoAtividade = "S" then
		intCodProfessor		 	= Trim(Request.Form("cmbProfessor"))
	elseif strTipoAtividade = "E" then
		intCodProfessor		 	= Trim(Request.Form("cmbColaborador"))
	end if
	
			
	if acao="I" then
	
		if strDescEquip <> "" then
		
			sql = " Select  E.DESC_EQUIPAMENTO "
			sql = sql & " from SCA_EQUIPAMENTO_RESERVA R "
			sql = sql & " inner join SCA_EQUIPAMENTO E on E.COD_EQUIPAMENTO = R.COD_EQUIPAMENTO AND E.COD_EMPRESA = R.COD_EMPRESA "
			sql = sql & " WHERE E.COD_EMPRESA = " & intCodEmp
			sql = sql & " AND	R.data_utilizacao = '" & strDataReserva & "'"
			sql = sql & " AND R.cod_sequencia_aulas = " & intCodSequenciaAulas
			sql = sql & " AND R.cod_colaborador = " & intCodProfessor
			sql = sql & " AND	E.DESC_EQUIPAMENTO = '" & strDescEquip & "'"
	
			rs.open sql,cnn
			if rs.eof = false then
				rs.close		
				%>
				<script>
					alert("ATENÇÃO: Equipamento já reservado!");
					window.history.back();
				</script>
				<%
				response.end			
			end if
			rs.close	
		end if
	
		sql = "Select * from SCA_EQUIPAMENTO_RESERVA "
		sql = sql & " where cod_equipamento = " & intCodEquipamento
		sql = sql & " AND data_utilizacao = '" & strDataReserva & "'"
	    sql = sql & " AND cod_sequencia_aulas = " & intCodSequenciaAulas
		sql = sql & " AND COD_EMPRESA	= " & intCodEmp
		rs.open sql, cnn,3,3
		if not rs.eof then
			rs.close
			%>
			<script>
				alert("ATENÇÃO: \nLocação confirmada por outro usuários - Verifique outra disponibilidade.");
				window.history.back();
			</script>
			<%	
			response.End()	
		end if
		rs.close
		
	    strMensagem = "Registro Salvo com sucesso..."
		
        sql = "Insert Into SCA_EQUIPAMENTO_RESERVA(COD_EMPRESA, cod_equipamento, cod_colaborador, num_sala, data_solicitacao, data_utilizacao, cod_horario_aula, cod_horario, tipo_evento, cod_sequencia_aulas)"
  		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodEquipamento & ","
		if intCodProfessor = "" or intCodProfessor = "0" then
			sql = sql & "null,"
		else
			sql = sql & "" & intCodProfessor & ","
		end if
		sql = sql & "'" & strSala & "',"
		sql = sql & "'" & strDataSolicitacao & "',"
		sql = sql & "'" & strDataReserva & "',"
		if intCodHorarioAula = "" or intCodHorarioAula = "0" then
			sql = sql & "null,"
		else
			sql = sql & "" & intCodHorarioAula & ","
		end if
		if intCodHorario = "" or intCodHorario = "0" then
			sql = sql & "null,"
		else
			sql = sql & "" & intCodHorario & ","
		end if
		sql = sql & "'" & strTipoAtividade & "',"
	    sql = sql & "" & intCodSequenciaAulas & ")"
		  
	elseif acao="A" then
		
	elseif acao="E" then
		
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_EQUIPAMENTO_RESERVA "
		sql = sql & " where codigo = " & intCodigo
		sql = sql & " and	COD_EMPRESA	= " & intCodEmp
		
	end if
	cnn.execute sql
	GravarLog sql
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.navigate('ReservaEquipamento_cad.asp?optOpcao=<%=strTipoAtividade%>');
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