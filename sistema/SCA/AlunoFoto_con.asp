<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
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
<table width="500" height="398" cellpadding="0" cellspacing="0" class="CorFundo" bgcolor="#FFFFFF">
  <tr  valign="top">
    <td width="500" height="365" align="center"  class="celula">
	<form name="editar" action="" method="POST" enctype="multipart/form-data">
	  <table width="100%" border="0" cellpadding="0" cellspacing="0" >
        <tr valign="top">
          <td align="center" class="tituloPrincipal"><span class="tituloPrincipal style2">Foto Aluno </span></td>
        </tr>
        <tr valign="top">
          <td align="left" >
		 </td>
        </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2"><table width="557" border="0">
            <tr>
              <td width="581"><span class="texto">
                <input name="txtCodigo" type="hidden" class="text" id="txtCodigo" size="5" maxlength="5" value="<%=intCodDestaque%>" />
              </span></td>
            </tr>
            <tr>
              <td align="center" class="texto"><table border="0" cellpadding="3" cellspacing="0" width="534">

                  <tr>
                    <td width="120" class="texto">C&oacute;digo Aluno:</td>
                    <td width="402"><input name="txtCodAluno" type="text" id="txtCodAluno" class="text" size="10" readonly=false value="<%=intCodAluno%>" maxlength="10"></td>
                  </tr>
                  <tr>
                    <td class="texto">Matr&iacute;cula:</td>
                    <td><span class="texto1">
                      <input name="txtMatricula" type="text" class="text" id="txtMatricula" size="20" readonly=false maxlength="10" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 10)" onBlur="carregaAluno()">
                    </span></td>
                  </tr>
                  <tr>
                    <td class="texto">Nome Aluno</td>
                    <td><span class="texto1">
                      <input name="txtNomealuno" type="text" class="text" id="txtNomealuno"  readonly=false size="50" maxlength="50" value="<%=strNomealuno%>"  onKeyPress="return formataCampo(this, 1, 50)">
                    </span></td>
                  </tr>
                  <tr>
                    <td colspan="2" class="texto">&nbsp;</td>
                  </tr>
              </table></td>
            </tr>
            <tr>
              <td>&nbsp;</td>
            </tr>
            <tr>
            <td height="148" align="center"><%
			
			PastaFotos = Server.MapPath("../../FotoAluno") & "/" & Session("CodEmpresa")
			
			Set objFSO = CreateObject("Scripting.FileSystemObject")
			
			sql = "SELECT Cod_empresa, CodAluno, Arquivo"
			sql = sql & " FROM SCA_ALUNO_FOTO"
			sql = sql & " Where CodAluno = " & intCodAluno
			rs.open sql, cnn
			
			if rs.eof = false then
		
				strCaminhoFoto 	= PastaFotos & "\" & trim(rs("Arquivo")) 
				strMatricula	= trim(rs("Arquivo")) 
				strNomeArquivo  = trim(rs("Arquivo")) 
				
				IF objFSO.FileExists(strCaminhoFoto) = True THEN
				%>
			  	<table border="0" width="410" cellpadding="0" cellspacing="0" style="margin-left:15px;margin-right:15px;margin-top:0px;border-collapse: collapse" bordercolor="#111111">
					<tr>
					<td height="110" align="center" title="Foto Destaque"><img src="../../FotoAluno/<%=Session("CodEmpresa")%>/<%=strMatricula%>"></td>
					</tr>
					<tr>
					<td height="24" align="center" class="menu3" title="Foto Destaque">&nbsp;</td>
					</tr>
			 	</table>
				<%
				end if
			else
				Response.Write "<center class='texto'>Nenhuma Foto</center><br>"
			end if
			rs.close		
			%></td>
            </tr>
            <tr>
              <td height="19" align="center"><span class="titulo1"></span></td>
            </tr>
          </table></td>
        </tr>
      </table>
	  </form>
	  </td>
  </tr>
  <tr >
  <td height="31" align="center"  class="celula"><span class="textSite">
  <input name="cmdFechar" type="button"  class="botao" id="cmdFechar" style="cursor:hand" onClick="window.close()"   value="Fechar" <%=strDesabilitaPrincipal%>>
  </span></td>
  </tr>
</table>
</body>
</html>