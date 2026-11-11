<html>
<head>
<title>:: Cadastrar Foto Album ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
<script language="JavaScript">

	function Valida(tipo){
		
		var FrmUpload = document.getElementById("FrmUpload");
		var caminho;
		
		if (FrmUpload.Arq.value==""){
			alert("A Foto deve ser informada!");
			FrmUpload.Arq1.focus();
			return false;
		}
		
		caminho= "UploadSimples.asp?CodAluno=" + FrmUpload.txtCodAluno.value;
		FrmUpload.action=caminho;
		FrmUpload.submit();
		return true;
	}
	
</script>
</head>
<body>
<%
	intCodAluno	= Trim(Request.QueryString("CodAluno"))
	
	NovaPasta 	= Session("CodEmpresa")
	caminhoFoto = Server.MapPath("../../FotoAluno/" & NovaPasta)
	Set FSO = Server.CreateObject("Scripting.FileSystemObject")
	
	'Verificar pasta (FolderExists)
	Sintaxe = FSO.FolderExists(caminhoFoto)
	
	if Sintaxe = False then
		' Função para criar pasta (CreateFolder)
		Set NovaPasta = FSO.CreateFolder(caminhoFoto)
	end if
%>
<form method="post" id="FrmUpload" ENCTYPE="multipart/form-data">
<table width="100%" border="0" bgcolor="#FFFFFF">
  <tr>
    <td align="center">
	<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td colspan="2" align="center" class="tituloPrincipal">Vincular Fotos do Aluno </td>
      </tr>
      <tr>
        <td width="78" height="27" class="texto">&nbsp;</td>
        <td width="535">
          <input name="txtCodAluno" type="hidden" id="txtCodAluno" value="<%=intCodAluno%>" >
        </td>
      </tr>
      <tr>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2" class="texto"> Para enviar fotos, selecione-a em seu computador clicando nos bot&otilde;es
          &quot;Procurar&quot;.</td>
      </tr>
      <tr>
        <td colspan="2">&nbsp;</td>
      </tr>
    </table>
      <table width="100%" border="0" cellpadding="0" cellspacing="0" class="border_basket_com_top">
        <tr>
          <td align="center"><table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
			  <tr>
			    <td height="27" align="center" class="texto"><strong>Foto :</strong><input class="text" name="Arq" type="file" size="30"></td>
			    </tr>
          </table>
            <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr>
                <td width="55" align="left">&nbsp;</td>
                <td width="64" align="left">&nbsp;</td>
                <td width="55" align="left">&nbsp;</td>
                <td width="55" align="left">&nbsp;</td>
                <td width="64" align="left">&nbsp;</td>
              </tr>
              <tr>
                <td colspan="5" align="center"><input type="button" name="Enter2" value="Enviar Foto" class="botao"  onClick="return Valida()">                  &nbsp;&nbsp;
                <input name="Fechar2" type="button" class="botao" id="Fechar2" value="Fechar" onClick="window.close()"></td>
                </tr>
            </table>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p></td>
        </tr>
      </table>
  </td>
  </tr>
</table>
</FORM>
</body>
</html>