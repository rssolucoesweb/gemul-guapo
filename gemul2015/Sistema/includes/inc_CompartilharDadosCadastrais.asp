<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/01/2008
	::	Desenvolvedores...: Roberto Barbosa Silva- robertobs7@gmail.com
	::	Objetivo Pagina...: Preenche combo Rota
-->
<%	
	if Session("CodEmpresa")<>"" then
		strCompartilharDados = ""
		sql = "SELECT COMPARTILHAR_DADOS "
		sql = sql & " FROM SEG_EMPRESA "
		sql = sql & " where CODIGO = " & Session("CodEmpresa")		
		rs.open sql, cnn
		if rs.eof = false then
		   strCompartilharDados = trim(rs("COMPARTILHAR_DADOS"))
		end if
		rs.close
	end if
%>
