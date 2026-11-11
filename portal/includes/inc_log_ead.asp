<%
	function GravarLogEAD(execucao,id_atividade_pai,id_mensagem,id_questionario,id_colaborador)
	
		ssql = "Insert Into EAD_LOG(cod_aluno, execucao, "
		if id_atividade_pai<>"0" then
			ssql = ssql & " cod_atividade_pai,"
		end if
		if id_mensagem<>"0" then
			ssql = ssql & " cod_mensagem,"
		end if
		if id_questionario<>"0" then
			ssql = ssql & " cod_questionario,"
		end if
		if id_colaborador<>"0" then
			ssql = ssql & " cod_colaborador,"
		end if
		ssql = ssql & " data_incl)"
		ssql = ssql & " Values ("
		ssql = ssql & "" & Session("CodAluno_GemulEad") & ","
		ssql = ssql & "'" & execucao & "',"
		if id_atividade_pai<>"0" then
			ssql = ssql & "" & id_atividade_pai & ","
		end if
		if id_mensagem<>"0" then
			ssql = ssql & "" & id_mensagem & ","
		end if
		if id_questionario<>"0" then
			ssql = ssql & "" & id_questionario & ","
		end if
		if id_colaborador<>"0" then
			ssql = ssql & "" & id_colaborador & ","
		end if
		ssql = ssql & "getdate())"
		cnn.execute ssql
	
	end function
%>