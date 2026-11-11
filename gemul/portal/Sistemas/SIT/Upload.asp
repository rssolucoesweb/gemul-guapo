<!--#include file="PatUpload.asp"-->
<!--#include file="../includes/inc_cnn.asp"-->
<HTML>
<HEAD>
<link href="../estilo/css.css" rel="stylesheet" type="text/css">
</HEAD>
<BODY>
<%
	On error resume next
	
	dim oUpload, i
	dim caminho

	set oUpload  = new PatUpload
	caminho = Server.MapPath("../FotoNoticia")
	oUpload.SetData Request, caminho, 1
	
	Arquivo				= oUpload.File("Arq1")
	intCodigo 			= oUpload.Form("codigo")
	
	sql = "Update Noticias set notNomeFoto = '" & Arquivo & "' where notCodigo = " & intCodigo
	
	cnn.execute sql
%>
<table width="98%" align="center">
<%
if err.number =0 then
	%>
	<tr>
    <td><div align="center"><font color="#0066CC" size="2" face="Arial"><strong><br>
        <br>
        <font color="#000000">A Foto foi enviada com sucesso!</font><br>
        <br>
        </strong></font></div></td>
	</tr>
	<%
else
	%>
	<tr>
		
    <td><div align="center"><strong><font color="#FF0000" size="2" face="Arial"> 
        <br>
        Erro ao Enviar o Arquivo </font></strong><br>
        <font color="#FF0000" size="2" face="Arial">Descri&ccedil;&atilde;o do 
        erro: <%=err.description%><br>
        <br>
        </font></div></td>
	</tr>	
	<%
end if
%>
<tr>
    <td> <form name="form1" method="post" action="">
        <div align="center">
          <input name="cmdFechar" type="button" id="cmdFechar" value="Fechar" onClick="window.close()" class="botao">
        </div>
      </form> </td>
</tr>
</table>
</BODY>
</HTML>