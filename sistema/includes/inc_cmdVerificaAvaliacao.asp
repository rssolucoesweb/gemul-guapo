<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/08/2008
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Avaliação Institucional
-->
<%
    realizouAvaliacao = "S"
	
    sql = "SELECT Codigo, Descricao, Ano_Letivo, Semestre"
    sql = sql & " FROM SAV_AVALIACAO_INSTITUCIONAL"
    sql = sql & " WHERE cod_empresa=" & Session("CodEmpresa")
    sql = sql & " And Publicar = 'S'"
    sql = sql & " Order by Descricao"
    rs1.open sql, cnn	
    if not rs1.eof then 
	   While not rs1.eof
 		  codigoAvaliacao = trim(rs1("Codigo"))	  
		  ' Busca Tipo da Avalição
		  sql = "SELECT CodAvaliacao, Cod_Turma, Cod_aluno"
		  sql = sql & " FROM SAV_AVALIACAO_PERGUNTA_NOTA"
		  sql = sql & " Where CodAvaliacao = " & codigoAvaliacao
		  sql = sql & " And Cod_aluno = " & trim(Session("CodSeguranca"))
		  rs.open sql, cnn
		  if rs.eof then 
		     realizouAvaliacao = "N"
		  end if 
		  rs.close
		  rs1.movenext
	   wend 
   end if 
   if realizouAvaliacao = "N" then
	  %>
	  <script>
		 alert("A T E N C A O! Você ainda não respondeu a Avaliação Institucional.\nPara sua Liberação no Portal, responda o questionário.");
		 window.navigate('PortalAluno_NotasAvaliacaoInstitucional_cad.asp');
	  </script>
	  <%
   end if
   rs1.close  
%>
