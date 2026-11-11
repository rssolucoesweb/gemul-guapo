<%
	cont = 0
	SQL = "select cod_lembrete, ASSUNTO, DESCRICAO, case when SITUACAO = 'V' then 'Visível' else 'Oculto' end as situacao, data_hora_incl"
	SQL = SQL & " from EAD_LEMBRETE m "
	SQL = SQL & " WHERE situacao = 'V' and cod_aluno=" & Session("CodAluno_GemulEad")
	SQL = SQL & " ORDER BY DATA_HORA_INCL DESC"
	RS.OPEN SQL, CNN
	IF RS.EOF = FALSE THEN
		%>
		<ul class="notes">
		<%
		while not rs.eof
			cont = cont + 1
			%>
			<li>
			<div>
				<small><%=rs("data_hora_incl")%></small>
				<h4><%=rs("assunto")%></h4>
				<p><%=left(rs("descricao"),200)%></p>
				<a href="lembrete_cod.asp?a=E&i=<%=rs("cod_lembrete")%>"><i class="fal fa-window-close"></i></a>
			</div>
			</li>
			<%
			rs.movenext
		wend
		%>
		</ul>
		<%
	END IF
	rs.close
	%>

