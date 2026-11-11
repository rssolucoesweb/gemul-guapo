<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	Data de Criação...: 07/10/2008
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Processo Seletivo
	::	Data Atualizacao..: 
	::	Motivo Atualizacao:
-->
<html>
<head>
<title><%=session("Titulo")%> - Alunos Por Turma</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	
	intCodigo           = Trim(Request.Form("txtCodigo"))
	intCodVestibular	= Trim(Request("cmbVestibular"))	
	
	' Dados do processo Seletivo
	
	
	sql = "SELECT cod_empresa, Codigo, Descricao, Data, Horario, Campus, TipoProcesso"
	sql = sql & " FROM SCA_VESTIBULAR"
	sql = sql & " Where cod_empresa = " & Session("CodEmpresa")	
	sql = sql & " and codigo = " & intCodVestibular
	rs.open sql, cnn
	
	if rs.eof = false then
		strDescricao 			= rs("Descricao")
		strData		 			= FORMATADATAAP(rs("Data"))
		strHorario	 			= rs("Horario")
		strCampus 				= rs("Campus")
		strTipoProcesso			= rs("TipoProcesso")
	end if 
	rs.close

	strTituloRelatorio  	= strDescricao
	
	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, Cod_CursoPrimeiraOpcao, Cod_CursoSegundaOpcao, OptanteEnem, "
		sql = sql & " NomeAluno, Identidade, OrgaoExpedidor, UFExpedidor, DataNascimento, CidadeNascimento, "
		sql = sql & " UFNascimento, Nacionalidade, Sexo, Fone, "
		sql = sql & " LOGRADOURO, NUMERO_ENDERECO, COMP_ENDERECO, "
 		sql = sql & " BAIRRO, CIDADE, UF, CEP "
		sql = sql & " FROM SCA_VESTIBULAR_DADOS"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " and cod_empresa = " & Session("CodEmpresa")	
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodVestibular				= rs("Codigo")
			intCodCursoPrimeiraOpcao		= rs("Cod_CursoPrimeiraOpcao")
			intCodCursoSegundaOpcao			= rs("Cod_CursoSegundaOpcao")
			strOpcao	 					= rs("OptanteEnem")
			strNomealuno		 			= rs("NomeAluno")
			strIdentidade					= rs("Identidade")
			strOrgaoExpedidor				= rs("OrgaoExpedidor")
			strUFExpedidor		 			= rs("UFExpedidor")
			strDataNascimento 				= rs("DataNascimento")
			strCidadeNascimento 			= rs("CidadeNascimento")
			strUFNascimento 				= rs("UFNascimento")
			strNacionalidade 				= rs("Nacionalidade")
			strSexo							= rs("Sexo")
			strFone 						= rs("Fone")
			strLogradouro 					= rs("LOGRADOURO")
			strNumero_endereco 				= rs("NUMERO_ENDERECO")
			strComp_endereco 				= rs("COMP_ENDERECO")
			strBairro	 					= rs("BAIRRO")
			strCidade						= rs("CIDADE")
			strUfResidencia					= rs("UF")
			strCep			 				= rs("CEP")
			
			if trim(strOpcao) = "S" then
				strOpcao = "SIM"
			else
				strOpcao = "NÃO"
			end if

		end if 
		rs.close
		
		' Atualiza o Numero de Impressão
		sql = " Update SCA_VESTIBULAR_DADOS Set"
	    sql = sql & " NumeroImpressao = NumeroImpressao + 1"
		sql = sql & " Where Cod_Empresa = " & Session("CodEmpresa")
		sql = sql & " And codigo = " & intCodigo
		cnn.execute sql
	
	end if 
	
	if trim(intCodCursoPrimeiraOpcao) <> "" then 
	
		sql = "SELECT Cod_curso, Descricao, Desc_Abreviada, Sigla, Cod_Grau"
		sql = sql & " FROM SCA_CURSO"
		SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
		SQL = SQL & " AND Cod_curso=" & intCodCursoPrimeiraOpcao
		rs.open sql, cnn
		
		if rs.eof = false then
			strCursoPrimeiraOpcao = rs("Descricao")
		end if
		rs.close
		
	end if
	
	if trim(intCodCursoSegundaOpcao) <> "" then 
	
		sql = "SELECT Cod_curso, Descricao, Desc_Abreviada, Sigla, Cod_Grau"
		sql = sql & " FROM SCA_CURSO"
		SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
		SQL = SQL & " AND Cod_curso=" & intCodCursoSegundaOpcao
		rs.open sql, cnn
		
		if rs.eof = false then
			strCursoSegundaOpcao = rs("Descricao")
		end if
		rs.close
		
	end if
	
	intCodCursoPrimeiraOpcao = strCursoPrimeiraOpcao
	intCodCursoSegundaOpcao = strCursoSegundaOpcao
	
	%>
	<% if strTipoProcesso = "1" then %>
       <!--#include file="../includes/inc_ProcessoSeletivo.asp"-->
	<% else %>
       <!--#include file="../includes/inc_AtividadeExtraCurricular.asp"-->
	<% end if %>      
  <table width="98%" border="0" cellspacing="0" cellpadding="0">
  <tr valign="top">
    <td height="19" colspan="2" align="center" class="texto1">&nbsp;</td>
  </tr>
  <tr valign="top">
    <td height="19" colspan="2" align="center" class="texto2"><strong>FICHA DE INSCRI&Ccedil;&Atilde;O</strong></td>
  </tr>
  <tr valign="top">
    <td height="19" colspan="2" align="center" class="texto1">&nbsp;</td>
    </tr>
  <tr valign="top">
    <td width="52%" align="center"><table width="419" height="70" border="0" class="tabela" cellpadding="0" cellspacing="0">
      <tr>
		<% if strTipoProcesso = "1" then %>
		   <td width="394" height="67" align="center" class="celula"><strong><font size="2">DATA, HOR&Aacute;RIO e LOCAL DO EXAME<br>
			  <%=strData%>, das <%=strHorario%>, Campus <%=strCampus%>.<br>
		   </font></strong></td>
		   <% else %>
		<td width="394" height="67" align="center" class="celula"><strong><font size="2">DATA, HOR&Aacute;RIO e LOCAL DA ATIVIDADE<br>
			  <%=strData%>, das <%=strHorario%>, Campus <%=strCampus%>.<br>
		</font></strong></td>
		<% end if %>  
      </tr>
    </table></td>
    <td width="48%">
	<table width="98%" border="0" cellpadding="0" cellspacing="0">
      <tr>
      <td class="TituloFormulario"></td>
      </tr>
      
      <tr>
      <td class="TituloFormulario"></td>
      </tr>
      <%
	  if strTipoProcesso = "1" then 
	  	sql = "SELECT Cod_curso, Descricao, Desc_Abreviada, Sigla, Cod_Grau, processo_seletivo"
		sql = sql & " FROM SCA_CURSO"
		sql = sql & " WHERE cod_empresa=" & Session("CodEmpresa")
		sql = sql & " and processo_seletivo = 'S'"
		sql = sql & " Order by Cod_curso"
		RS.OPEN SQL, CNN
		
		IF RS.EOF = FALSE THEN
		   while not rs.eof
	       		%>
           		<tr>
	       		<td class="texto1"><%=rs("Cod_curso")%> - <%=rs("Descricao")%>&nbsp;</td>
           		</tr>
           		<%
				rs.movenext
		   wend
		END IF
	    rs.close
      end if 
	%>
    </table></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td rowspan="5" align="center"><table width="419" height="62" border="0" class="tabela" cellpadding="0" cellspacing="0">
        <tr>
          <td width="394" height="60" align="center" class="celula">N&Uacute;MERO DA INSCRI&Ccedil;&Atilde;O <br>
          <strong><%=ZeroLeft(intCodVestibular,5)%></strong></td>
        </tr>
      </table></td>
	<% if strTipoProcesso = "1" then %>
	   <td><span class="TituloFormulario">Optante ENEM ? </span><%=strOpcao%></td>
	<% else %>
		<td width="0%"><span class="TituloFormulario"></span></td>
	<% end if %>   
</tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
	<% if strTipoProcesso = "1" then %>
	   <td><span class="TituloFormulario">N&uacute;meros dos Cursos escolhidos : </span></td>
	<% else %>
	   <td><span class="TituloFormulario"></span></td>
	<% end if %>   
  </tr>
  <tr>
	<% if strTipoProcesso = "1" then %>
	   <td><span class="TituloFormulario">1&ordm; Op&ccedil;&atilde;o  : </span><%=intCodCursoPrimeiraOpcao%></td>
	<% else %>   
	   <td><span class="TituloFormulario"></span></td>
	<% end if %>   
</tr>
  <tr>
	<% if strTipoProcesso = "1" then %>
	   <td><span class="TituloFormulario">2&ordm; Op&ccedil;&atilde;o  : </span><%=intCodCursoSegundaOpcao%></td>
	<% else %>   
	   <td><span class="TituloFormulario"></span></td>
	<% end if %>   
  </tr>
</table>
<hr size="1" color="#CCCCCC">
<!-- FIM CAMPO - DADOS PESSOAIS-->
</td>
		<table width="98%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="13%" height="20"><span class="TituloFormulario">Nome : </span></td>
            <td colspan="5"><%=strNomealuno%></td>
          </tr>
          <tr>
            <td height="19"><span class="TituloFormulario">N&ordm; de Identidade :</span></td>
            <td><%=strIdentidade%>&nbsp;</td>
            <td><span class="TituloFormulario">Org&atilde;o Expedidor :</span></td>
            <td><%=strOrgaoExpedidor%>&nbsp;</td>
            <td><span class="TituloFormulario">Estado Expedidor: </span></td>
            <td><%=strUFExpedidor%>&nbsp;</td>
          </tr>
          <tr>
            <td height="19"><span class="TituloFormulario">Data Nascimento : </span></td>
            <td><%=strDataNascimento%>&nbsp;</td>
            <td><span class="TituloFormulario">Cidade / Nascimento : </span></td>
            <td><%=strCidadeNascimento%>&nbsp;</td>
            <td><span class="TituloFormulario">Estado : </span></td>
            <td><%=strUFNascimento%>&nbsp;</td>
          </tr>
          <tr>
            <td height="19"><span class="TituloFormulario">Nacionalidade : </span></td>
            <td width="26%"><%=strNacionalidade%>&nbsp;</td>
            <td width="13%"><span class="TituloFormulario">Sexo : </span></td>
            <td width="19%"><%=strSexo%>&nbsp;</td>
            <td width="12%"><span class="TituloFormulario">Fone : </span></td>
            <td width="17%"><%=strFone%>&nbsp;</td>
          </tr>
          <tr>
            <td height="19"><span class="TituloFormulario">Endere&ccedil;o : </span></td>
            <td><%=strLogradouro%>&nbsp;</td>
            <td><span class="TituloFormulario">Numero: </span></td>
            <td><%=strNumero_endereco%>&nbsp;</td>
            <td><span class="TituloFormulario">Complemento: </span></td>
            <td><%=strComp_endereco%>&nbsp;</td>
          </tr>
          <tr>
            <td height="19"><span class="TituloFormulario">Bairro  : </span></td>
            <td><%=strBairro%>&nbsp;</td>
            <td><span class="TituloFormulario">Cep : </span></td>
            <td><%=strCep%>&nbsp;</td>
            <td><span class="TituloFormulario">Cidade / Estado : </span></td>
            <td><%=strCidade%> / <%=strUFExpedidor%>&nbsp;</td>
          </tr>
          <tr>
            <td height="19">&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
			<% if strTipoProcesso = "1" then %>
               <td height="13" colspan="6"><font size="1">VEM REQUERER SUA INSCRI&Ccedil;&Atilde;O NO PROCESSO SELETIVO, DECLARANDO ESTAR CIENTE DO REGULAMENTO E DEMAIS
INSTRU&Ccedil;&Otilde;ES QUE REGEM A SELE&Ccedil;&Atilde;O E RESPONSABILIZANDO-ME PELAS INFORMA&Ccedil;&Otilde;ES PRESTADAS NESTE FORMUL&Aacute;RIO.</font></td>
            <% else %>
               <td height="13" colspan="6"><font size="1">VEM REQUERER SUA INSCRI&Ccedil;&Atilde;O NA ATIVIDADE ACIMA INFORMADA, DECLARANDO ESTAR CIENTE DO REGULAMENTO E DEMAIS
INSTRU&Ccedil;&Otilde;ES, RESPONSABILIZANDO-ME AINDA PELAS INFORMA&Ccedil;&Otilde;ES PRESTADAS NESTE FORMUL&Aacute;RIO.</font></td>
               <% end if %> 
          </tr>
        </table>
		<br>
		<table width="98%" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td height="19" colspan="3" align="center">_______________________________________________</td>
            <td width="34%" height="19" align="center">_______________________________________________</td>
            <td width="24%" height="19" colspan="2" align="right"><strong>DATA: _____/_____/_____</strong></td>
          </tr>
          <tr>
            <td height="19" colspan="3" align="center"><font size="1"><strong>ASSINATURA DO FUNCION&Aacute;RIO(A)</strong></font></td>
            <td height="19" align="center"><font size="1"><strong>ASSINATURA DO(A) CANDIDATO(A)</strong></font></td>
            <td height="19" colspan="2" align="right">&nbsp;</td>
          </tr>
        </table><br>

		<hr size="1" color="#CCCCCC">
	    <table width="98%" border="0" cellspacing="0" cellpadding="0">
          
          <tr>
            <td colspan="2" align="center" class="texto1">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2" align="center" class="texto2"><strong>DOCUMENTO DE IDENTIFICA&Ccedil;&Atilde;O</strong></td>
          </tr>
          <tr>
            <td colspan="2" align="center" class="texto1">&nbsp;</td>
          </tr>
          <tr>
            <td align="center">
			
			<table width="419" height="65" border="0" class="tabela" cellpadding="0" cellspacing="0">
              <tr>
		<% if strTipoProcesso = "1" then %>
		   <td width="394" height="67" align="center" class="celula"><strong><font size="2">DATA, HOR&Aacute;RIO e LOCAL DO EXAME<br>
			  <%=strData%>, das <%=strHorario%>, Campus <%=strCampus%>.<br>
		   </font></strong></td>
		   <% else %>
		<td width="394" height="67" align="center" class="celula"><strong><font size="2">DATA, HOR&Aacute;RIO e LOCAL DA ATIVIDADE<br>
			  <%=strData%>, das <%=strHorario%>, Campus <%=strCampus%>.<br>
		</font></strong></td>
		<% end if %>  
             </tr>
            </table></td>
            <td align="center"><table width="419" height="68" border="0" class="tabela" cellpadding="0" cellspacing="0">
              <tr>
                <td width="394" height="63" align="center" class="celula"><p>N&Uacute;MERO DA INSCRI&Ccedil;&Atilde;O <br>
                    <strong><%=ZeroLeft(intCodVestibular,5)%></strong></p>                </td>
              </tr>
            </table></td>
          </tr>
          
          <tr>
            <td><div align="center"></div></td>
 			<% if strTipoProcesso = "1" then %>
               <td><span class="TituloFormulario">Optante ENEM ? </span><%=strOpcao%></td>
			<% else %>
                <td><span class="TituloFormulario"></span></td>
			<% end if %>   
          </tr>
          <tr>
            <td><div align="center"><strong><font size="1">Aten&ccedil;&atilde;o: FIQUE ATENTO AO TURNO DE FUNCIONAMENTO DO CURSO</font></strong></div></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
			<% if strTipoProcesso = "1" then %>
               <td><span class="TituloFormulario">N&uacute;meros dos Cursos escolhidos : </span></td>
			<% else %>
               <td><span class="TituloFormulario"></span></td>
			<% end if %>   
          </tr>
          <tr>
            <td>&nbsp;</td>
			<% if strTipoProcesso = "1" then %>
               <td><span class="TituloFormulario">1&ordm; Op&ccedil;&atilde;o  : </span><%=intCodCursoPrimeiraOpcao%></td>
			<% else %>   
               <td><span class="TituloFormulario"></span></td>
			<% end if %>   
         </tr>
          <tr>
            <td>&nbsp;</td>
			<% if strTipoProcesso = "1" then %>
               <td><span class="TituloFormulario">2&ordm; Op&ccedil;&atilde;o  : </span><%=intCodCursoSegundaOpcao%></td>
			<% else %>   
               <td><span class="TituloFormulario"></span></td>
			<% end if %>   
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
        </table>
<table width="98%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="13%" height="20"><span class="TituloFormulario">Nome : </span></td>
            <td colspan="5"><%=strNomealuno%>&nbsp;</td>
          </tr>
          <tr>
            <td height="19"><span class="TituloFormulario">N&ordm; de Indentidade :</span></td>
            <td width="26%"><%=strIdentidade%>&nbsp;</td>
            <td width="13%"><span class="TituloFormulario">Org&atilde;o Expeditor :</span></td>
            <td width="25%"><%=strOrgaoExpedidor%>&nbsp;</td>
            <td width="11%"><span class="TituloFormulario">Estado : </span></td>
            <td width="12%"><%=strUFExpedidor%>&nbsp;</td>
          </tr>

          <tr>
            <td height="19">&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
			<% if strTipoProcesso = "1" then %>
               <td height="13" colspan="6"><font size="1">VEM REQUERER SUA INSCRI&Ccedil;&Atilde;O NO PROCESSO SELETIVO, DECLARANDO ESTAR CIENTE DO REGULAMENTO E DEMAIS
INSTRU&Ccedil;&Otilde;ES QUE REGEM A SELE&Ccedil;&Atilde;O E RESPONSABILIZANDO-ME PELAS INFORMA&Ccedil;&Otilde;ES PRESTADAS NESTE FORMUL&Aacute;RIO.</font></td>
            <% else %>
               <td height="13" colspan="6"><font size="1">VEM REQUERER SUA INSCRI&Ccedil;&Atilde;O NA ATIVIDADE ACIMA INFORMADA, DECLARANDO ESTAR CIENTE DO REGULAMENTO E DEMAIS
INSTRU&Ccedil;&Otilde;ES, RESPONSABILIZANDO-ME AINDA PELAS INFORMA&Ccedil;&Otilde;ES PRESTADAS NESTE FORMUL&Aacute;RIO.</font></td>
               <% end if %> 
          </tr>
        </table>
	    <table width="98%" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td height="19" colspan="3" align="center">&nbsp;</td>
            <td height="19" align="center">&nbsp;</td>
            <td height="19" colspan="2" align="right">&nbsp;</td>
          </tr>
          <tr>
            <td height="19" colspan="3" align="center">_______________________________________________</td>
            <td width="34%" height="19" align="center">_______________________________________________</td>
            <td width="27%" height="19" colspan="2" align="right"><strong>DATA: _____/_____/_____</strong></td>
          </tr>
          <tr>
            <td height="19" colspan="3" align="center"><font size="1"><strong>ASSINATURA DO FUNCION&Aacute;RIO(A)</strong></font></td>
            <td height="19" align="center"><font size="1"><strong>ASSINATURA DO(A) CANDIDATO(A)</strong></font></td>
            <td height="19" colspan="2" align="right">&nbsp;</td>
          </tr>
        </table>
		 <script>
		aguarde.style.display="none";
	</script>
</body>
</html>