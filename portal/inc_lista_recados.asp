
<%
	cont = 0
	SQL = "select m.cod_mensagem, m.ASSUNTO, m.DESCRICAO, m.data_hora_incl,"
	SQL = SQL & " CASE"
	SQL = SQL & "	WHEN m.cod_colaborador = '0' then 'SEDUC'"
	SQL = SQL & "	ELSE SUBSTRING(C.NOME, 0, CHARINDEX(' ', C.NOME)) + ' ' +  REVERSE(SUBSTRING(REVERSE(C.NOME), 0, CHARINDEX(' ', REVERSE(C.NOME))))"
	SQL = SQL & "	END AS COLABORADOR "
	SQL = SQL & " from EAD_MENSAGEM m "
	SQL = SQL & " left join srh_colaborador c on c.codigo = m.cod_colaborador"
	SQL = SQL & " WHERE m.situacao = 'E' and m.usuario_incl_aluno is null and m.cod_aluno=" & Session("CodAluno_GemulEad")
	SQL = SQL & " ORDER BY m.DATA_HORA_INCL DESC"

	RS.OPEN SQL, CNN
	IF RS.EOF = FALSE THEN
		%>
		<ul class="notes">
		<%
		while not rs.eof
			cont = cont + 1
			%>
			<li>
			<div class="recados">
				<small><%=rs("COLABORADOR")%>&nbsp;<%=rs("data_hora_incl")%></small>
				<h4><%=rs("assunto")%></h4>
				<p><%=left(rs("descricao"),200)%></p>
				<a href="mensagem_cod.asp?a=L&i=<%=rs("cod_mensagem")%>"><i class="fal fa-low-vision"></i></a>
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

