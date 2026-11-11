<!--
	::	RSIMOBNET
	::	Data de Criação...: 25/02/2008
	::	Desenvolvedores...: sergio borges - sergiob76@hotmail.com
	::	Motivo............: verifica bloqueio
-->
<%
IF TRIM(intCodAluno) <> "" THEN
   strMsn = ""
   sql = "select ab.cod_aluno, ab.databloqueio, d.descricao as depto "
   sql = sql & " from SCA_BLOQUEIO_ALUNO ab "
   sql = sql & " left join seg_departamento d on d.codigo=ab.cod_departamento and d.cod_empresa=ab.cod_empresa "
   sql = sql & " where ab.cod_empresa = " & Session("CodEmpresa")
   sql = sql & " and ab.cod_aluno in (" & intCodAluno & ")"
   sql = sql & " and ab.situacao = 'B' "
   RS.OPEN SQL, CNN
   IF NOT RS.EOF THEN
      strMsn = "Dirija-se ao(s) Departamento(s): \n\n"
      WHILE NOT RS.EOF
  	      strMsn = strMsn & "Solicitado em: " & RS("databloqueio") & " - " & RS("depto") &" \n"
	      RS.MOVENEXT
	  WEND
	  %>
	  <script>
			alert("<%=strMsn%>");
			window.history.back();
	  </script>	
	  <%
   END IF
   RS.CLOSE
END IF
%>