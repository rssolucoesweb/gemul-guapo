<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Periodo
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script>
	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbCurso.value == "0") {
			alert("O Curso deve ser informado !");
			frm.cmbCurso.focus();
			return false;
		}
		
		if (frm.txtSequencia.value == "") {
			alert("A Sequencia deve ser informada !");
			frm.txtSequencia.focus();
			return false;
		}
		if (frm.txtDescricao.value == "") {
			alert("A Descrição deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		frm.action="Periodo_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%
	strPaginaTitulo 		= "Periodo_cad.asp"
	strExecutarSubmitCurso 	= "S"

	intCodPeriodo			= Trim(Request.Form("txtCodigo"))
	intCodCurso				= Trim(Request("cmbCurso"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strSequencia 			= Trim(Request.Form("txtSequencia"))
	strTipo		 			= Trim(Request.Form("cmbTipo"))
	strMatricula			= Trim(Request.Form("cmbMatricula"))
		
	if trim(intCodPeriodo) <> "" then
	
		sql = "SELECT Cod_Periodo, Cod_Curso, Descricao, Sequencia, Tipo, Matricula"
		sql = sql & " FROM SCA_PERIODO"
		sql = sql & " where Cod_Empresa = " & Session("CodEmpresa")			
		sql = sql & " and 	Cod_Periodo = " & intCodPeriodo
		rs.open sql, cnn
		if rs.eof = false then
			
			intCodPeriodo	 	= rs("Cod_Periodo")
			intCodCurso			= rs("Cod_Curso")
			strDescricao		= rs("Descricao")
			strSequencia		= rs("Sequencia")
			strTipo				= rs("Tipo")
			strMatricula		= rs("Matricula")
			
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir

		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="100%"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post" action="Periodo_cad.asp">
		  <table width="98%" border="0" cellpadding="0" cellspacing="0">

            <tr valign="top">
              <td width="100%" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
		  <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="142" height="23" class="texto1">Curso:</td>
            <td width="1209"><!--#include file="../includes/inc_cmdCurso.asp" --></td>
          </tr>
          <tr>
            <td height="23" class="texto1">Sequencia:</td>
            <td><span class="texto1">
              <input name="txtSequencia" type="text" class="text" id="txtSequencia" size="2" maxlength="2" value="<%=strSequencia%>"  onKeyPress="return formataCampo(this, 2, 2)" >
            </span></td>
          </tr>
          <tr>
            <td height="23" class="texto1">Descri&ccedil;&atilde;o:</td>
            <td><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodPeriodo%>" maxlength="10">
              <input name="txtDescricao" type="text" class="text" id="txtDescricao" size="40" maxlength="40" value="<%=strDescricao%>"></td>
          </tr>
          <tr>
            <td height="23" class="texto1">Tipo:</td>
            <td><select name="cmbTipo" id="cmbTipo" class="Combo">
              <option <%if strTipo = "D" then response.Write("selected")%> value="D">Disciplinar</option>
              <option <%if strTipo = "I" then response.Write("selected")%> value="I">Interdisciplinar</option>
            </select></td>
          </tr>
          <tr>
            <td height="23" class="texto1">Aparece na Matricula:</td>
            <td><select name="cmbMatricula" id="cmbMatricula" class="Combo">
             <option <%if strMatricula = "N" then response.Write("selected")%> value="N">Não</option>
             <option <%if strMatricula = "S" then response.Write("selected")%> value="S">Sim</option>
            </select></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><%
			cont =0
			if intCodCurso = "" then intCodCurso = 0
			if intCodCurso <> "0" then
				sql = " SELECT SCA_CURSO.Descricao as descCurso, SCA_PERIODO.Descricao, SCA_PERIODO.Cod_Periodo, SCA_PERIODO.Sequencia, SCA_PERIODO.tipo, SCA_PERIODO.Matricula"
				sql = sql & " FROM SCA_CURSO INNER JOIN SCA_PERIODO ON SCA_CURSO.Cod_curso = SCA_PERIODO.Cod_Curso "
				sql = sql & " AND SCA_CURSO.Cod_Empresa = SCA_PERIODO.Cod_Empresa "
				sql = sql & " where SCA_CURSO.cod_empresa = " & Session("CodEmpresa")	
				if intCodCurso <> "0" then
					sql = sql & " and SCA_PERIODO.Cod_Curso = " & intCodCurso
				end if
				sql = sql & " ORDER BY 	SCA_PERIODO.Sequencia, SCA_CURSO.Descricao, SCA_PERIODO.Descricao"
				rs.open sql, cnn
								
				if rs.eof = false then
				%>
					<table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
					  <tr bgcolor="#E5E5E5">
						<td width="4%" class="celula"><strong>C&oacute;digo</strong></td>
						<td width="27%" class="celula"><strong>Curso<span class="TextoForm"></span></strong></td>
						<td width="7%" height="21" class="celula"><strong>Sequencia</strong></td>
						<td width="15%" height="21" class="celula"><strong>Descri&ccedil;&atilde;o</strong></td>
						<td width="32%" class="celula"><strong>Tipo</strong></td>
						<td width="15%" class="celula"><strong>Aparece na Matricula</strong></td>
					  </tr>
					  <%
						while not rs.eof
							cont = cont + 1	
							strDescTipo = ""
							if rs("tipo") = "D" then strDescTipo = "Disciplinar"
							if rs("tipo") = "I" then strDescTipo = "Interdisciplinar"
						
							if rs("Matricula") = "S" then strMatricula = "Sim"
							if rs("Matricula") = "N" then strMatricula = "Não"
							
							
							%>
						  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Cod_Periodo")%>')">
							<td class="celula"><%=rs("Cod_Periodo")%></td>
							<td class="celula"><%=trim(rs("descCurso"))%></td>
							<td height="20" class="celula">&nbsp;<%=trim(rs("sequencia"))%></td>
							<td height="20" class="celula">&nbsp;<%=trim(rs("Descricao"))%></td>
							<td class="celula"><%=strDescTipo%></td>
							<td class="celula"><%=strMatricula%>&nbsp;</td>
						  </tr>
						  <%				
							rs.movenext
						wend
					  %>
					  <tr>
						<td height="21" colspan="6" class="celula">Total Registros : <%=cont%></td>
					  </table>
				  <%
				  end if
				  rs.close
			end if
		  %>		  </td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
        </table>
		</form>
		</td>
      </tr>
    </table>
	</td>
  </tr>
</table>
<!--#include file="../rodape.asp"-->
</body>
</html>