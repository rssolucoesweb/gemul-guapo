<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	strCodGrupo		        = Session("CodGrupo")
	acao 				 	= Trim(Request.QueryString("acao"))

    intCodCalendario 			= Trim(Request("txtCodigo"))
    strAno	 					= Trim(Request("txtAno"))
	intCodEvento 				= Trim(Request("cmbEvento"))
	strMes				 		= Trim(Request("cmbMes"))
	strDiaEvento		 		= Trim(Request("chkEventoDia"))
	strEventoEditado		 	= Trim(Request("txtEventoEditado"))
	strCodEventoEditado		 	= Trim(Request("txtCodEventoEditado"))
	
	'removendo os eventos editados
	if strEventoEditado <> "" then   
		vetEventoEditado = split(trim(strEventoEditado),",")
		vetCodEventoEditado = split(trim(strCodEventoEditado),",")	
			
		for i = 0 to ubound(vetEventoEditado)
			sql = "Delete from sca_Calendario_dia_ue "
			sql = sql & " Where Cod_calendario_ue = " & intCodCalendario
			sql = sql & " And dia_mes = " & trim(vetEventoEditado(i))
			sql = sql & " And cod_calendario_evento = " & trim(vetCodEventoEditado(i))
			sql = sql & " And mes = " & strMes
			sql = sql & " And ano = " & strAno
			cnn.execute sql
			GravarLog sql	
		next
			 
	end if

	sql = "Delete from sca_Calendario_dia_ue "
	sql = sql & " Where Cod_calendario_ue = " & intCodCalendario
	sql = sql & " And cod_calendario_evento = " & intCodEvento
	sql = sql & " And mes = " & strMes
	sql = sql & " And ano = " & strAno
	cnn.execute sql
	GravarLog sql	
	
	strMensagem = "Registro Salvo com sucesso..."
	if strDiaEvento <> "" then   
		vetDiaEvento = split(trim(strDiaEvento),",")			 
	end if

	if strDiaEvento <> "" then	
		for i = 0 to ubound(vetDiaEvento)
			strDetalhe = request.form("txtDetalhe_" & trim(vetDiaEvento(i)))
			
			sql = "Insert Into sca_Calendario_dia_ue (cod_calendario_ue, cod_calendario_evento, dia_mes, dia_semana, detalhes, mes, ano)"          
			sql = sql & " Values ("
			sql = sql & "" & intCodCalendario & ","
			sql = sql & "" & intCodEvento & ","
			sql = sql & "" & vetDiaEvento(i) & ","
			sql = sql & "" & Weekday(DateSerial(strAno,strMes,vetDiaEvento(i))) & ","
			sql = sql & "'" & strDetalhe & "',"
			sql = sql & "" & strMes & ","
			sql = sql & "" & strAno & ") "
			cnn.Execute(sql)
		next
	end if
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='EventoCalendarioUE_cad.asp?txtCodigo=<%=intCodCalendario%>&cmbEventoRetorno=<%=intCodEvento%>&cmbMesRetorno=<%=strMes%>&txtAno=<%=strAno%>';
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