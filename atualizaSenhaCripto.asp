<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/cripto.asp"-->
<%
strDataAtual = "2016-06-20 00:00:01"

'sql = "update SEG_USUARIOS_SISTEMA set USUA_DATA_ALTERACAO_SENHA = null"
'cnn.execute sql

'somente a primeira vez, depois comentar
'response.end

sql = " SELECT USUA_CODG, Usua_Info_senha "
sql = sql & " FROM SEG_USUARIOS_SISTEMA where USUA_STAT='A' and USUA_DATA_ALTERACAO_SENHA is null"
rs.open sql, cnn
if rs.eof = false then
	while not rs.eof	
		strSenha = Trim(rs("Usua_Info_senha"))
		if strSenha <> "" then
			strSenha = replace(FormatCripto(strSenha,false),"'","")
		end if
		
		sql = "update SEG_USUARIOS_SISTEMA set Usua_Info_senha = '" & strSenha & "', USUA_DATA_ALTERACAO_SENHA='" & strDataAtual & "' where USUA_CODG = '" & rs("USUA_CODG") & "'"
		response.write sql & "<hr>"
		cnn.execute sql
		
		rs.movenext
	wend		
end if
rs.close

response.write "FIM"
%>