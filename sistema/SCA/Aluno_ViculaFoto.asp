<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_cnn.asp"-->
<script>

	function SalvarFoto(acao){
			
		var frm = document.getElementById("frm");
		
		if (acao=="I") {
			
			if (editar.Foto.value == "") {
				alert("A Foto deve ser informada !");
				editar.Foto.focus();  
				return false;
			}	
		
			if((editar.Foto.value.lastIndexOf(".JPG")==-1) && (editar.Foto.value.lastIndexOf(".jpg")==-1) && (editar.Foto.value.lastIndexOf(".GIF")==-1) && (editar.Foto.value.lastIndexOf(".gif")==-1)){  
				alert("Só é permitido fazer Upload de JPG, GIF, BMP ou PNG!"); 
				frm.Arq1.focus();  
				return false  
			} 
			
			editar.action="Aluno_ViculaFoto_cod.asp?CodAluno="+editar.txtCodAluno.value+"&Matricula="+editar.txtMatricula.value;
			editar.submit();
			return true;
		}
		
		if (acao=="E"){
		
			var men = 'ATENÇÃO: Deseja realmente excluir esta Foto?\n '
			if (confirm(men)) {
				editar.action="Aluno_ViculaFoto_cod_e.asp?CodAluno="+editar.txtCodAluno.value+"&NomeArquivo="+editar.txtNomeArquivo.value;
				editar.submit();
			} else {
				return false;
			}
		
		}
			
	}
</script>
<%	
	intCodEmpresa 		= Session("CodEmpresa")
	intCodAluno			= Trim(Request.QueryString("codAluno"))
	orientacao			= request("orientacao")

	
	if intCodAluno <> 0 then 

		'valida os campos null
		sql = "SET NoCount ON create table #temp (descricao varchar(300)) "
		sql = sql & " insert #temp select 'NOME DO ALUNO' from sca_aluno where codigo = " & intCodAluno & " and NOMEALUNO is null"
		sql = sql & " insert #temp select 'DATA DA MATRICULA' from sca_aluno where codigo = " & intCodAluno & " and DATAMATRICULA is null"
		sql = sql & " insert #temp select 'SITUACAO DO ALUNO' from sca_aluno where codigo = " & intCodAluno & " and COD_SITUACAOALUNO is null"
		sql = sql & " insert #temp select 'SEXO DO ALUNO' from sca_aluno where codigo = " & intCodAluno & " and SEXOALUNO is null"
		sql = sql & " insert #temp select 'DATA DE NASCIMENTO' from sca_aluno where codigo = " & intCodAluno & " and DATANASCIMENTO is null"
		sql = sql & " insert #temp select 'DATA DE EMISSAO DA CERTIDAO DE NASCIMENTO' from sca_aluno where codigo = " & intCodAluno & " and DATAEMISSAOCERTIDAONASCIMENTO is null"
		sql = sql & " insert #temp select 'NUM. REGISTRO DE NASCIMENTO' from sca_aluno where codigo = " & intCodAluno & " and NUMREGISTRONASC is null"
		sql = sql & " insert #temp select 'FOLHA' from sca_aluno where codigo = " & intCodAluno & " and FOLHA is null"
		sql = sql & " insert #temp select 'LIVRO' from sca_aluno where codigo = " & intCodAluno & " and LIVRO is null"
		'sql = sql & " insert #temp select 'TERMO' from sca_aluno where codigo = " & intCodAluno & " and TERMO is null"
		sql = sql & " insert #temp select 'NOME DO CARTORIO' from sca_aluno where codigo = " & intCodAluno & " and NOMECARTORIO is null"
		sql = sql & " insert #temp select 'CIDADE DE NASCIMENTO' from sca_aluno where codigo = " & intCodAluno & " and CIDADENASCIMENTO is null"
		sql = sql & " insert #temp select 'UF DE NASCIMENTO' from sca_aluno where codigo = " & intCodAluno & " and UFNASCIMENTO is null"
		sql = sql & " insert #temp select 'LOGRADOURO' from sca_aluno where codigo = " & intCodAluno & " and LOGRADOURO is null"
		'sql = sql & " insert #temp select 'NUMERO DO ENDERECO' from sca_aluno where codigo = " & intCodAluno & " and NUMERO_ENDERECO is null"
		sql = sql & " insert #temp select 'COMP. ENDERECO' from sca_aluno where codigo = " & intCodAluno & " and COMP_ENDERECO is null"
		sql = sql & " insert #temp select 'BAIRRO' from sca_aluno where codigo = " & intCodAluno & " and BAIRROALUNO is null"
		sql = sql & " insert #temp select 'CIDADE DA RESIDENCIA' from sca_aluno where codigo = " & intCodAluno & " and CIDADERESIDENCIA is null"
		sql = sql & " insert #temp select 'UF DA RESIDENCIA' from sca_aluno where codigo = " & intCodAluno & " and UFRESIDENCIA is null"
		sql = sql & " insert #temp select 'CEP DA RESIDENCIA' from sca_aluno where codigo = " & intCodAluno & " and CEPRESIDENCIA is null"
		sql = sql & " insert #temp select 'ESTADO CIVIL' from sca_aluno where codigo = " & intCodAluno & " and COD_ESTADOCIVIL is null"
		sql = sql & " insert #temp select 'PROFISSAO' from sca_aluno where codigo = " & intCodAluno & " and COD_PROFISSAO is null"
		sql = sql & " insert #temp select 'RELIGIAO' from sca_aluno where codigo = " & intCodAluno & " and COD_RELIGIAO is null"
		sql = sql & " insert #temp select 'ETNIA' from sca_aluno where codigo = " & intCodAluno & " and COD_ETNIA is null"
		'sql = sql & " insert #temp select 'NEC. ESPECIAL' from sca_aluno where codigo = " & intCodAluno & " and COD_NECESPECIAL is null"
		'sql = sql & " insert #temp select 'ATENDIMENTO ESPECIAL' from sca_aluno where codigo = " & intCodAluno & " and ATENDIMENTOESPECIAL is null"
		sql = sql & " insert #temp select 'MAE' from sca_aluno where codigo = " & intCodAluno & " and MAE is null"
		sql = sql & " insert #temp select 'FONE RESIDENCIAL' from sca_aluno where codigo = " & intCodAluno & " and FONERESIDENCIAL is null"
		sql = sql & " insert #temp select 'NACIONALIDADE' from sca_aluno where codigo = " & intCodAluno & " and NACIONALIDADE is null"
		sql = sql & " insert #temp select 'TIPO DE NACIONALIDADE' from sca_aluno where codigo = " & intCodAluno & " and COD_TIPONACIONALIDADE is null"
		sql = sql & " SELECT DESCRICAO FROM #TEMP"
		Set rs = cnn.Execute(sql)
		mensagem = ""
		if not rs.eof then
			while not rs.eof
				mensagem = mensagem & "\n- " & rs("descricao")
				rs.movenext
			wend
		end if
		rs.close
		
		if mensagem<>"" then
			%>
			<script>
				alert("Atualize o cadastro antes de tirar a foto, os campos abaixo devem ser preenchidos:\n\n<%=mensagem%>");
				window.close();
			</script>
			<%
			response.End()
		end if
	
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
                    <td class="texto">C&oacute;digo Aluno:</td>
                    <td><input name="txtCodAluno" type="text" id="txtCodAluno" class="text" size="10" readonly=false value="<%=intCodAluno%>" maxlength="10"></td>
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
                    <td width="120" class="texto">Selecione a Foto:</td>
                    <td width="402"><input type="file" name="Foto" id="Foto" class="text" value="" style="width:400px;"></td>
                  </tr>
                  <tr>
                    <td colspan="2" class="texto">&nbsp;</td>
                  </tr>
                  <tr>
                    <td colspan="2" class="texto">Para enviar fotos, selecione-a em seu computador clicando nos bot&otilde;es
          &quot;Procurar&quot;.</td>
                    </tr>
                  <tr>
                    <td colspan="2" class="texto">Aviso: Envie apenas arquivo JPG, GIF, BMP ou PNG.</td>
                    </tr>
              </table></td>
            </tr>
            <tr>
              <td align="center"><input type="button" name="botao" class="botao" onClick="SalvarFoto('I')" value="Enviar Foto"></td>
            </tr>
            <tr>
              <td>&nbsp;</td>
            </tr>
            <tr>
            <td height="148" align="center"><%
			
			PastaFotos = Server.MapPath("../../../FotoAluno") & "/" & Session("CodEmpresa")
			
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
					<td height="110" align="center" title="Foto Destaque"><img src="../../../FotoAluno/<%=Session("CodEmpresa")%>/<%=strMatricula%>"></td>
					</tr>
					<tr>
					<td height="24" align="center" class="menu3" title="Foto Destaque"><a href="#" onClick="SalvarFoto('E')" title="Excluir"><img border="0" src="../../../images/icone_excluir.gif" width="13" height="13"> excluir foto</a>                          </td>
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
              <td height="19" align="center"><span class="titulo1">
                <input name="txtNomeArquivo" type="hidden" class="text" id="txtNomeArquivo" size="40" maxlength="40" value="<%=strNomeArquivo%>" />
              </span></td>
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