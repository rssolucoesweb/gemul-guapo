<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Tirar Foto Aluno</title>
    <meta name="generator" content="TextMate http://macromates.com/" />
	<title><%=session("Titulo")%></title>
	<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<!--#include file="../../includes/inc_cnn.asp"-->
<%	
	intCodEmpresa 		= Session("CodEmpresa")
	intCodAluno			= Trim(Request.QueryString("codAluno"))
	orientacao			= request("orientacao")
	
	if intCodAluno <> 0 then 
		
		sql = "SELECT S.Desc_SituacaoAluno, A.* "
		sql = sql & " FROM SCA_ALUNO A"
		sql = sql & " LEFT JOIN SCA_SITUACAOALUNO S ON S.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND S.COD_EMPRESA = A.COD_EMPRESA"
		sql = sql & " Where A.COD_EMPRESA = " & intCodEmpresa
		sql = sql & " And 	A.codigo = " & intCodAluno
		rs.open sql, cnn
		
		if rs.eof = false then
			strMatricula 		= TRIM(rs("Matricula"))
			strNomealuno 		= TRIM(rs("Nomealuno"))
			intCodAluno			= TRIM(rs("Codigo"))
		end if
		rs.close
	end if

%>
<table width="500" height="58" cellpadding="0" cellspacing="0" class="CorFundo" bgcolor="#FFFFFF">
  <tr  valign="top">
    <td width="500" height="30" align="center"  class="celula"><table width="100%" border="0" cellpadding="0" cellspacing="0" >
      <tr valign="top">
        <td align="center" class="tituloPrincipal"><span class="tituloPrincipal style2">Tirar Foto Aluno </span></td>
      </tr>
      <tr valign="top">
        <td align="left" ></td>
      </tr>
    </table>     </td>
  </tr>
  <tr  valign="top">
    <td height="13" align="center"  class="celula">
    
    <table width="557" border="0">
            <tr>
              <td width="581"><span class="texto">
                <input name="txtCodigo" type="hidden" class="text" id="txtCodigo" size="5" maxlength="5" value="<%=intCodDestaque%>" />
              </span></td>
            </tr>
            <tr>
              <td align="center" class="texto"><table border="0" cellpadding="3" cellspacing="0" width="534">

                  <tr>
                    <td width="120" class="texto">C&oacute;digo Aluno:</td>
                    <td width="402" align="left"><input name="txtCodAluno" type="text" id="txtCodAluno" class="text" size="10" readonly=false value="<%=intCodAluno%>" maxlength="10"></td>
                  </tr>
                  <tr>
                    <td class="texto">Matr&iacute;cula:</td>
                    <td align="left">
                      <input name="txtMatricula" type="text" class="text" id="txtMatricula" size="20" readonly=false maxlength="10" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 10)" onBlur="carregaAluno()">
                    </td>
                  </tr>
                  <tr>
                    <td class="texto">Nome Aluno</td>
                    <td align="left">
                      <input name="txtNomealuno" type="text" class="text" id="txtNomealuno"  readonly=false size="50" maxlength="50" value="<%=strNomealuno%>"  onKeyPress="return formataCampo(this, 1, 50)">
                    </td>
                  </tr>
              </table></td>
            </tr>
            <tr>
              <td align="center">&nbsp;</td>
            </tr>
            <tr>
              <td align="center">
           	
	<!-- First, include the JPEGCam JavaScript Library -->
	<script type="text/javascript" src="../../php/jpegcam/htdocs/webcam.js"></script>
	
	<!-- Configure a few settings -->
	<script language="JavaScript">
		webcam.set_api_url( '../../php/jpegcam/htdocs/test.php' );
		webcam.set_quality( 90 ); // JPEG quality (1 - 100)
		webcam.set_shutter_sound( true ); // play shutter click sound
	</script>
	
	<!-- Next, write the movie to the page at 320x240 -->
	<script language="JavaScript">
		document.write( webcam.get_html(320, 240) );
	</script>
	
	<!-- Some buttons for controlling things -->
	<br/><form>
		<input type=button value="Configurar" onClick="webcam.configure()" />
		&nbsp;&nbsp;
		<input type=button value="Tirar Foto" onClick="webcam.freeze()" />
		&nbsp;&nbsp;
		<input type=button value="Enviar" onClick="do_upload()" />
		&nbsp;&nbsp;
		<input type=button value="Inicializar" onClick="webcam.reset()" />
	</form>
	
	<!-- Code to handle the server response (see test.php) -->
	<script language="JavaScript">
		webcam.set_hook( 'onComplete', 'my_completion_handler' );
		
		function do_upload() {
			// upload to server
			document.getElementById('upload_results').innerHTML = '<h1>Uploading...</h1>';
			webcam.upload();
		}
		
		function my_completion_handler(msg) {
			// extract URL out of PHP output
			if (msg.match(/(http\:\/\/\S+)/)) {
				var image_url = RegExp.$1;
				// show JPEG image in page
				document.getElementById('upload_results').innerHTML = 
					'<h1>Upload Successful!</h1>' + 
					'<h3>JPEG URL: ' + image_url + '</h3>' + 
					'<img src="' + image_url + '">';
				
				// reset camera for another shot
				webcam.reset();
			}
			else alert("PHP Error: " + msg);
		}
	</script>
	

              
              </td>
            </tr>
            <tr>
              <td height="19" align="center">&nbsp;</td>
            </tr>
            <tr>
              <td height="19" align="center">&nbsp;</td>
            </tr>
         
        
    
  
  <tr >
  <td height="31" align="center"  class="celula"><span class="textSite">
  <input name="cmdFechar" type="button"  class="botao" id="cmdFechar" style="cursor:hand" onClick="window.close()"   value="Fechar" <%=strDesabilitaPrincipal%>>
  </span></td>
  </tr>
</table>
    
    </td>
  </tr>
  <tr  valign="top">
    <td height="13" align="center"  class="celula">&nbsp;</td>
  </tr>
</table>
</body>
</html>