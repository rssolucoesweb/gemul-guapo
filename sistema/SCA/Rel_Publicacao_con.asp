<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Extrato de NOtas
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<script>
	function gerar(){
	
		var frm = document.getElementById("frm");
		
		frm.action = "Rel_Publicacao_rel.asp";
		frm.submit();
		return true;	
	}	
</script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	strPaginaTitulo = "Rel_Publicacao_con.asp"
	
	intCodLocalizacaoGeografica = Trim(Request.Form("cmbLocalizacaoGeografica"))
	strSituacao					= Trim(Request.Form("cmbSituacao"))	
	intCodCategoria				= Trim(Request.Form("cmbCategoria"))	
	intCodDepartamento			= Trim(Request.Form("cmbDepartamento"))
	intCodCdu					= Trim(Request.Form("txtCodCDU"))
	intCodCursoPrimeiraOpcao 	= Trim(Request.Form("cmbCursoPrimeiraOpcao"))
	strClassificacaoCurso 		= Trim(Request.Form("cmbClassificacaoCurso"))
	strClassificacao	= request.Form("cmbClassificacao")
	strTipoRelatorio	= Trim(Request.Form("cmbTipoRelatorio"))
	
%>
<form method="post" id="frm" action="#">
<input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
		<tr valign="top">
		  <td align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
		</tr>
		<tr valign="top">
		  <td align="center">
<br>
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
     
     <tr>
       <td colspan="5" class="texto1">Op&ccedil;&otilde;es de Filtros: </td>
       </tr>
     <tr>
       <td class="texto1">&nbsp;</td>
       <td colspan="4">&nbsp;</td>
     </tr>
     <tr>
       <td class="texto1">Localiza&ccedil;&atilde;o Geogr&aacute;fica:</td>
       <td colspan="4"><!--#include file="../includes/inc_cmbLocalizacaoGeografica.asp" --></td>
     </tr>
     <tr>
       <td class="texto1">Autoria:</td>
       <td colspan="4"><!--#include file="../includes/inc_cmdAutoria.asp" --></td>
     </tr>
     <tr>
       <td class="texto1">Autor:</td>
       <td colspan="4"><input name="txtAutor" type="text" class="text" id="txtAutor" size="50" maxlength="50" value="<%=strAutor%>" /></td>
     </tr>
     <tr>
       <td class="texto1">Palavra Chave:</td>
       <td colspan="4"><input name="txtPalavraChave" type="text" class="text" id="txtPalavraChave" size="50" maxlength="50" value="<%=strPalavraChave%>" /></td>
     </tr>
     <tr>
       <td class="texto1">T&iacute;tulo:</td>
       <td colspan="4"><input name="txtTitulo" type="text" class="text" id="txtTitulo" size="50" maxlength="50" value="<%=strTitulo%>" /></td>
     </tr>
     <tr>
       <td class="texto1">Curso:</td>
       <td colspan="4"><!--#include file="../includes/inc_cmdCursoPrimeraOpcao.asp" --></td>
     </tr>
      <tr>
        <td class="texto1">Classifica&ccedil;&atilde;o da Pub. no Curso:</td>
        <td colspan="4"><span class="texto1">
          <select name="cmbClassificacaoCurso" id="cmbClassificacaoCurso" class="Combo">
            <option <%if strClassificacaoCurso = "B" then%> selected <%end if%> value="B">B&aacute;sica</option>
            <option <%if strClassificacaoCurso = "C" then%> selected <%end if%> value="C">Complementar</option>
          </select>
        </span></td>
      </tr>
      <tr>
       <td class="texto1">Cdu:</td>
       <td colspan="4"><input name="txtCodCDU" type="text" id="txtCodCDU" class="text" size="70" maxlength="70"></td>
     </tr>
     <tr>
       <td class="texto1">Tipo Relat&oacute;rio:</td>
       <td colspan="4"><span class="texto1">
         <select name="cmbTipoRelatorio" id="cmbTipoRelatorio" class="Combo">
           <option <%if strTipoRelatorio = "1" then%> selected <%end if%> value="1">Exemplares</option>
           <option <%if strTipoRelatorio = "2" then%> selected <%end if%> value="2">Títulos</option>
         </select>
       </span></td>
     </tr>
     
     <tr>
       <td width="17%" class="texto1">Classificando por: </td>
       <td colspan="4"><span class="texto1">
         <select name="cmbClassificacao" id="cmbClassificacao" class="Combo">
           <option <%if strClassificacao = "TIT" then%> selected <%end if%> value="TIT">Título</option>
           <option <%if strClassificacao = "CDU" then%> selected <%end if%> value="CDU">C.D.U</option>
           <option <%if strClassificacao = "TITCDU" then%> selected <%end if%> value="TITCDU">Titulo e C.D.U</option>
          </select>
       </span></td>
     </tr>
     <tr>
       <td class="texto1">&nbsp;</td>
       <td colspan="4">&nbsp;</td>
     </tr>
     <tr>
       <td colspan="5" class="texto1"><div align="center"><strong>Configurando Colunas para o Relat&oacute;rio </strong></div></td>
     </tr>
     <tr>
       <td colspan="5" class="texto1">&nbsp;</td>
     </tr>
     <tr>
       <td colspan="5" class="texto1"><div align="center"></div></td>
       </tr>
     
     <tr>
       <td height="20" class="texto1">&nbsp;</td>
       <td colspan="4" class="texto1"><strong>Dados da Publica&ccedil;&atilde;o: </strong></td>
       <td class="texto1">&nbsp;</td>
     </tr>
     <tr>
       <td height="20" class="texto1">&nbsp;</td>
       <td width="14%" class="texto1"><input type="checkbox" name="filtro01" value="S"> 01).Tipo de Publica&ccedil;&atilde;o </td>
       <td width="21%" class="texto1"><input type="checkbox" name="filtro02" value="S"> 02).Autoria</td>
       <td width="21%" class="texto1"><input type="checkbox" name="filtro03" value="S"> 03).Editora</td>
       <td width="26%" class="texto1"><input type="checkbox" name="filtro04" value="S"> 04).C.D.U</td>
       <td width="1%" class="texto1">&nbsp;</td>
     </tr>
     <tr>
       <td class="texto1">&nbsp;</td>
       <td class="texto1"><input type="checkbox" name="filtro05" value="S"> 05).Periodicidade</td>
       <td class="texto1"><input type="checkbox" name="filtro06" value="S"> 06).Autores</td>
       <td class="texto1"><input type="checkbox" name="filtro07" value="S"> 07).Palavras Chaves </td>
       <td class="texto1"><input type="checkbox" name="filtro08" value="S"> 08).Sub-T&iacute;tulo</td>
       <td class="texto1">&nbsp;</td>
     </tr>
     <tr>
       <td class="texto1">&nbsp;</td>
       <td class="texto1"><input type="checkbox" name="filtro09" value="S"> 09).Local de Publica&ccedil;&atilde;o </td>
       <td class="texto1"><input type="checkbox" name="filtro10" value="S"> 10).Ano de Publica&ccedil;&atilde;o </td>
       <td class="texto1"><input type="checkbox" name="filtro11" value="S"> 11).Edi&ccedil;&atilde;o</td>
       <td class="texto1"><input type="checkbox" name="filtro12" value="S"> 12).Volume</td>
       <td class="texto1">&nbsp;</td>
     </tr>
     <tr>
       <td class="texto1">&nbsp;</td>
       <td class="texto1"><input type="checkbox" name="filtro13" value="S"> 13).ISBN</td>
       <td class="texto1"><input type="checkbox" name="filtro14" value="S"> 14).Data de Inclus&atilde;o </td>
       <td class="texto1"><input type="checkbox" name="filtro15" value="S"> 15).Gerar Etiquetas</td>
       <td class="texto1"><input type="checkbox" name="filtro16" value="S"> 16). P&aacute;ginas </td>
       <td class="texto1">&nbsp;</td>
     </tr>
     <tr>
       <td class="texto1">&nbsp;</td>
       <td class="texto1"><input type="checkbox" name="filtro17" value="S"> 17).Origem</td>
       <td class="texto1"><input type="checkbox" name="filtro18" value="S"> 18).Destino</td>
       <td class="texto1"><input type="checkbox" name="filtro19" value="S"> 19).Resumo</td>
       <td class="texto1"><input type="checkbox" name="filtro20" value="S"> 20).&Uacute;ltimo Exemplar </td>
       <td class="texto1">&nbsp;</td>
     </tr>
     <tr>
       <td class="texto1">&nbsp;</td>
       <td class="texto1"><input type="checkbox" name="filtro21" value="S"> 21).Quant. de Exemplar </td>
       <td class="texto1">&nbsp;</td>
       <td class="texto1">&nbsp;</td>
       <td class="texto1">&nbsp;</td>
       <td class="texto1">&nbsp;</td>
     </tr>
     <tr>
       <td class="texto1">&nbsp;</td>
       <td class="texto1">&nbsp;</td>
       <td class="texto1">&nbsp;</td>
       <td class="texto1">&nbsp;</td>
       <td class="texto1">&nbsp;</td>
       <td class="texto1">&nbsp;</td>
     </tr>
     <tr>
       <td class="texto1">&nbsp;</td>
       <td colspan="4" class="texto1"><strong>Dados Complementares: </strong></td>
       <td class="texto1">&nbsp;</td>
     </tr>
     <tr>
       <td class="texto1">&nbsp;</td>
       <td class="texto1"><input type="checkbox" name="filtro22" value="S"> 22).Data do Contrato </td>
       <td class="texto1"><input type="checkbox" name="filtro23" value="S"> 23).Contato</td>
       <td class="texto1"><input type="checkbox" name="filtro24" value="S"> 24).Endere&ccedil;o</td>
       <td class="texto1"><input type="checkbox" name="filtro25" value="S"> 25).Bairro</td>
       <td class="texto1">&nbsp;</td>
     </tr>
     <tr>
       <td class="texto1">&nbsp;</td>
       <td class="texto1"><input type="checkbox" name="filtro26" value="S"> 26).Cidade</td>
       <td class="texto1"><input type="checkbox" name="filtro27" value="S"> 27).UF</td>
       <td class="texto1"><input type="checkbox" name="filtro28" value="S"> 28).CEP</td>
       <td class="texto1"><input type="checkbox" name="filtro29" value="S"> 29).N&uacute;mero</td>
       <td class="texto1">&nbsp;</td>
     </tr>
     <tr>
       <td class="texto1">&nbsp;</td>
       <td class="texto1"><input type="checkbox" name="filtro30" value="S"> 30).Email</td>
       <td class="texto1">&nbsp;</td>
       <td class="texto1">&nbsp;</td>
       <td class="texto1">&nbsp;</td>
       <td class="texto1">&nbsp;</td>
     </tr>
     <tr>
       <td class="texto1">&nbsp;</td>
       <td class="texto1">&nbsp;</td>
       <td class="texto1">&nbsp;</td>
       <td class="texto1">&nbsp;</td>
       <td class="texto1">&nbsp;</td>
       <td class="texto1">&nbsp;</td>
     </tr>
     
    <tr>
      <td class="texto1">&nbsp;</td>
      <td colspan="5">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="6"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr>
      <td colspan="6"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->&nbsp;</td>
    </tr>
  </table>
<br>
<br>		  </td>
		</tr>
  </table>

</form>
<!--#include file="../rodape.asp"-->
</body>
</html>
