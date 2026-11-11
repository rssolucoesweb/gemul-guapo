<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/03/2010
	::	Desenvolvedores...: sergio borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de perfil
-->
<%	
	if strExecutarReplicarTurmaConteudo = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	sql = " select DISTINCT T.cod_turma, T.NomeTurma "
	sql = sql & " from SCA_HORARIO_AULA HA "
	sql = sql & " INNER JOIN SCA_TURMA T ON T.Cod_Turma=HA.Cod_turma "
	sql = sql & " where Cod_Colaborador =  " & intCodColaboradorProfessor  
	sql = sql & " and HA.anoletivo = " & strAnoLetivo 
	sql = sql & " and HA.semestre = " & intSemestre 
	sql = sql & " and Cod_Disciplina =  " & intCodDisciplina 	
	sql = sql & " and T.cod_turma not in (" & intCodTurmaProfessor & ")"
	RS.OPEN SQL, CNN

	IF RS.EOF = FALSE THEN
		while not rs.eof
			
			%>
			<input <%=strSelecionado%> name="cmbReplicarTurma" id="cmbReplicarTurma" type="checkbox" value="<%=rs("cod_turma")%>"  onclick="<%=strFuncao%>"/><%=rs("NomeTurma")%><BR>
			<%
			rs.movenext
		wend
	else
	    response.write "Sem turmas para Replicação"	
	END IF
	rs.close
%>
