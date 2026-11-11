<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: sergio borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de grupo
-->
<%	
	contEmpresaDoGrupo = 0
	sql = "select SEG_USUARIOS_EMPRESA.COD_EMPRESA"
	sql = sql & " FROM SEG_USUARIOS_EMPRESA"
	sql = sql & " INNER JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO = SEG_USUARIOS_EMPRESA.COD_EMPRESA"
	sql = sql & " LEFT 	JOIN SEG_GRUPO 	 ON SEG_EMPRESA.COD_GRUPO = SEG_GRUPO.CODIGO"
	sql = sql & " WHERE CODIGO_SEG_USUARIOS_SISTEMA = '" & session("UsuarioWeb") & "'" 
	sql = sql & " Order by SEG_USUARIOS_EMPRESA.COD_EMPRESA"
	RSAux.OPEN SQL, CNN
	IF RSAux.EOF = FALSE THEN
		while not RSAux.eof
			intEmpresasDoGrupo = trim(intEmpresasDoGrupo) & trim(RSAux("COD_EMPRESA")) 
			RSAux.movenext
			if not RSAux.eof then
			   intEmpresasDoGrupo = intEmpresasDoGrupo & ","
			end if   
			contEmpresaDoGrupo = contEmpresaDoGrupo + 1
		wend
	END IF
	RSAux.close
%>
