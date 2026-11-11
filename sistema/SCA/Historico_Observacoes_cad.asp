<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 24/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Ocorrencia 
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
<script type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
//-->
</script>
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif')">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script>

	function resultadoConsulta(intCodigo){
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function blocTexto(valor, id)
	{
		quant = 500;
		total = valor.length;
		if(total <= quant)
		{
			resto = quant - total;
			document.getElementById('cont').innerHTML = resto;
		}
		else
		{
			document.getElementById('txtResposta_'+id).value = valor.substr(0,quant);
		}
	}

	
	function salvar(acao){
	
		if (frm.txtAnoLetivo.value == ""){
			alert("O Ano Letivo deve ser informado.");
			frm.txtAnoLetivo.focus();
			return false;
		}
		
		if (frm.cmbSemestre.value == ""){
			alert("O Semestre deve ser informado.");
			frm.cmbSemestre.focus();
			return false;
		}
		
		if (frm.txtOcorrencia.value == "") {
			alert("A Observação deve ser informada !");
			frm.txtOcorrencia.focus();
			return false;
		}
		
		frm.action="Historico_Observacoes_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%
	strPaginaTitulo = "Historico_Observacoes_cad.asp"
	strExecutarSubmitSemestreTodos	= "S"
	strExecutarSubmitCurso	        = "S"
	strExecutarSubmitTurma       	 = "S"
	
	intAnoLetivo 			= Trim(Request("txtAnoLetivo"))
	if Trim(Request("cmbSemestre")) <> "0" then
		intSemestre 		= Trim(Request("cmbSemestre"))
	else	
		intSemestre 		=  Session("strSemestre")
	end if	
	if intAnoLetivo = "" then intAnoLetivo = session("strAnoLetivo")
	if intSemestre = "" then intSemestre = Session("strSemestre")

	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	strCodAluno 			= Trim(Request.Form("txtCodAluno"))
	strNomealuno 			= Trim(Request("txtNomealuno"))
	strMatricula 			= Trim(Request.Form("txtMatricula"))
	strOcorrencia 			= Trim(Request.Form("txtOcorrencia"))
 
    if Trim(Request.Form("txtMatricula")) = "" then 
	   strNomealuno = "" 
	end if   

	if trim(intCodigo) <> "" then
	
		sql = "SELECT CODIGO, ANO, SEMESTRE, isnull(COD_CURSO,'0') as COD_CURSO , isnull(COD_TURMA,'0') as COD_TURMA,  isnull(COD_ALUNO,'0') as COD_ALUNO, OBSERVACOES FROM SCA_HISTORICO_OBSERVACOES "
		sql = sql & " Where codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			intAnoLetivo	 		= rs("ANO")
			intSemestre 			= rs("SEMESTRE")
			intCodCurso	 			= rs("COD_CURSO")
			intCodTurma 			= rs("COD_TURMA")
			strCodAluno 			= rs("COD_ALUNO")
			strOcorrencia 			= rs("OBSERVACOES")
			
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

	if Trim(Request.Form("txtMatricula")) <> "" then
		sql = "SELECT CODIGO, MATRICULA, NOMEALUNO "
		sql = sql & " FROM SCA_ALUNO "
		sql = sql & " Where matricula = '" & Trim(Request.Form("txtMatricula")) & "'"
		sql = sql & " and cod_empresa = " & Session("CodEmpresa")
    	rs.open sql, cnn
		if rs.eof = false then
			strCodAluno 		= TRIM(rs("CODIGO"))
			strMatricula 		= TRIM(rs("Matricula"))
			strNomealuno 		= TRIM(rs("Nomealuno"))
			intCodCurso	 		= "0"
			intCodTurma 		= "0"
		end if 
		rs.close
	end if	
	
%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="1223"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td width="993" colspan="2" align="center">
		<form id="frm" method="post">
		  <table width="1224" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td  class="texto1">&nbsp;</td>
            <td colspan="3"  class="tituloSistema"><div align="center"><%=carregaTituloPaginaASP(strPaginaTitulo)%></div></td>
          </tr>
          <tr>
            <td class="texto1">&nbsp;</td>
            <td colspan="3">&nbsp;</td>
          </tr>
         <tr>
            <td class="texto1">Ano Letivo:</td>
            <td ><input onBlur="submit()" name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo"  value="<%=intAnoLetivo%>" size="5" maxlength="4" onKeyPress="return formataCampo(this,2,4)"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
          </tr>
          <tr>
            <td class="texto1">Semestre Letivo:</td>
            <td><!--#include file="../includes/inc_cmdSemestreTodos.asp" -->
              <span class="texto1">- Mostra observa&ccedil;&otilde;es para todos os alunos de todos os cursos no ano e semestre informado.</span></td>
          </tr>
          <tr>
            <td class="texto1">Matricula:</td>
            <td colspan="3"><input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="10" value="<%=strCodAluno%>" maxlength="10"><span class="texto1">
        <input name="txtMatricula" type="text" class="text" id="txtMatricula" size="20" maxlength="20" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 10)" onBlur="submit()">
        <a  href="#" onClick="return abreConsulta('Aluno_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a></span><input readonly name="txtNomealuno" type="text" class="textDesabilita" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>" >
        <span class="texto1">- Mostra observa&ccedil;&atilde;o apenas para o aluno informado no ano e semestre.</span></td>
          </tr>
          <% if strMatricula = "" then %>
              <tr>
                <td class="texto1">Curso:</td>
                <td class="texto1"><!--#include file="../includes/inc_cmdCurso.asp" --> 
                  - Mostra observa&ccedil;&otilde;es para todos os alunos do curso no ano e semestre informado.</td>
              </tr>
              <tr>
                <td class="texto1">Turma:</td>
                <td colspan="3"><!--#include file="../includes/inc_cmdTurma.asp"-->
                  <span class="texto1">- Mostra observa&ccedil;&otilde;es para todos alunos da turma do referido curso, no ano e semestre informado.</span></td>
              </tr>
          <% end if %>
          
          <tr>
            <td class="texto1">&nbsp;</td>
            <td colspan="3">&nbsp;</td>
          </tr>
          <tr>
            <td class="texto1">Observa&ccedil;&otilde;es: </td>
            <td colspan="3" class="texto1"><textarea onKeyUp="blocTexto(this.value,'<%=cont%>')" name="txtOcorrencia" cols="60" rows="5" class="text" id="txtOcorrencia"><%=strOcorrencia%></textarea><font color="#FF0000">(caracteres restantes: <span id="cont">500</span>)</font></td>
          </tr>
          <tr>
            <td width="108" class="texto1">&nbsp;</td>
            <td width="1116" colspan="3">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="4" class="texto1">&nbsp;* Os campos Curso, Turma e aluno s&atilde;o opcionais. Sua utiliza&ccedil;&atilde;o ser&aacute; conforme a necessidade de distribui&ccedil;&atilde;o das observa&ccedil;&otilde;es no hist&oacute;rico.</td>
          </tr>
          <tr>
            <td colspan="4" class="texto1">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="4"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
          </tr>
          <tr>
            <td colspan="4">&nbsp;</td>
          </tr>
		  <%

		if trim(intAnoLetivo) <> "" AND intSemestre <> "0" then

		     if strCodAluno = "" or isnull(strCodAluno) then strCodAluno = "0"
		     if intCodCurso = "" or isnull(intCodCurso) then intCodCurso = "0"
		     if intCodTurma = "" or isnull(intCodTurma) then intCodTurma = "0"

			sql = "SELECT OB.CODIGO, OB.ANO, OB.SEMESTRE, isnull(OB.COD_CURSO,'0') as COD_CURSO, isnull(OB.COD_TURMA,'0') as COD_TURMA,  isnull(OB.COD_ALUNO,'0') as COD_ALUNO, OB.OBSERVACOES, a.matricula, c.descricao, t.nometurma  FROM SCA_HISTORICO_OBSERVACOES OB"
			sql = sql & " left join sca_aluno a on a.codigo = ob.cod_aluno "
			sql = sql & " left join sca_curso c on c.cod_curso = ob.cod_curso "
			sql = sql & " left join sca_turma t on t.cod_turma = ob.cod_turma "
			sql = sql & " Where OB.cod_empresa = " & Session("CodEmpresa") 
			sql = sql & " and OB.ANO = " & intAnoLetivo 
			sql = sql & " and OB.SEMESTRE = " & intSemestre
            if strMatricula = "" and intCodCurso = "0" and intCodTurma = "0"  then
				sql = sql & " and OB.ANO = " & intAnoLetivo 
				sql = sql & " and OB.SEMESTRE = " & intSemestre
				sql = sql & " and isnull(OB.COD_ALUNO,'0') = " & strCodAluno
				sql = sql & " and isnull(OB.COD_CURSO,'0') = " & intCodCurso
				sql = sql & " and isnull(OB.COD_TURMA,'0') = " & intCodTurma
			else	
				if strMatricula <> "" and intCodCurso = "0" and intCodTurma = "0"  then
					sql = sql & " and OB.COD_ALUNO = " & strCodAluno
					sql = sql & " and isnull(OB.COD_CURSO,'0') = " & intCodCurso
					sql = sql & " and isnull(OB.COD_TURMA,'0') = " & intCodTurma
				else
					if strMatricula = "" and intCodCurso <> "0" and intCodTurma = "0"  then
						sql = sql & " and OB.COD_CURSO = " & intCodCurso
						sql = sql & " and isnull(OB.COD_TURMA,'0') = " & intCodTurma
					end if	
					if strMatricula = "" and intCodCurso <> "0" and intCodTurma <> "0"  then
						sql = sql & " and OB.COD_CURSO = " & intCodCurso
						sql = sql & " and OB.COD_TURMA = " & intCodTurma
					end if
				end if

			end if
			rs.open sql, cnn
			if rs.eof = false then
			%>
			</table>
			<table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
				<tr bgcolor="#E5E5E5" class="celula">
					<td class="celula">Ano</td>
					<td class="celula">Semestre</td>
					<td height="26" class="celula">Curso</td>
					<td class="celula">Turma</td>
					<td class="celula">Matr&iacute;cula</td>
					<td class="celula">Observa&ccedil;&otilde;es</td>
				</tr>
				<%
				while not rs.eof
					contreg = contreg + 1	
					%>
					<tr bgcolor="#FFFFFF" class="celula"  style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"  onClick="return resultadoConsulta('<%=rs("CODIGO")%>')">
						<td width="56" class="celula">&nbsp;<%=trim(rs("ANO"))%></td>
						<td width="66" class="celula">&nbsp;<%=trim(rs("SEMESTRE"))%></td>
						<td width="292" height="26" class="celula">&nbsp;<%=trim(rs("descricao"))%></td>
						<td width="67" height="26" class="celula">&nbsp;<%=trim(rs("nometurma"))%></td>
						<td width="66" height="26" class="celula">&nbsp;<%=trim(rs("matricula"))%></td>
						<td height="26" class="celula">&nbsp;<%=trim(rs("OBSERVACOES"))%></td>
					</tr>
					<%				
					rs.movenext
				wend
				%>
				<tr> 
					<td height="21" colspan="7" class="celula"><span class="texto">Total Registros :</span> <%=contreg%></td>
				<%
			else
				%>
				</table>
				<table width="883" border="0" cellpadding="0" cellspacing="0">
					<tr bgcolor="#E5E5E5" class="celula">
						<td  height="19" class="texto1"><div align="center">Não Existe Lançamento de observações para esse ANO E SEMESTRE.</div></td>
					</tr>
					<%				
			end if
			rs.close
		end if	
		%>
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