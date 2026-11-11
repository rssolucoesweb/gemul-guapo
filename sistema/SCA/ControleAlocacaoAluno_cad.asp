<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 27/11/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Criterio de Avaliação
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
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
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script>

	function marcaTodos(valor){
		var form = window.document.forms[0];
		var i;
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "checkbox"){
				//verifica se o checkbox está marcado
				if (form.elements[i].disabled == false){
				form.elements[i].checked=valor;
				}
			}
		}
	}
	
	function salvar(acao){
		
		if (frm.txtAnoLetivo.value==""){
			alert("Selecione o Ano de Origem.")		
			frm.txtAnoLetivo.focus();
			return false
		}
		if (frm.cmbSemestre.value=="0"){
			alert("Selecione o semestre de Origem.")		
			frm.cmbSemestre.focus();
			return false
		}
		/*if (frm.cmbTurma.value=="0"){
			alert("Selecione a Turma de Origem.")		
			frm.cmbTurma.focus();
			return false
		}*/

		if (frm.txtAnoLetivoLocacao.value==""){
			alert("Selecione o Ano para Alocação.")		
			frm.txtAnoLetivoLocacao.focus();
			return false
		}
		if (frm.cmbSemestreAlocacao.value=="0"){
			alert("Selecione o semestre para Alocação.")		
			frm.cmbSemestreAlocacao.focus();
			return false
		}
		if (frm.cmbTurmaAlocacao.value=="0"){
			alert("Selecione a Nova Turma para Alocação.")		
			frm.cmbTurmaAlocacao.focus();
			return false
		}
		if (frm.cmbTipoAlocacao.value=="0"){
			alert("Selecione o Tipo de Alocação.")		
			frm.cmbSemestreAlocacao.focus();
			return false
		}
		if (frm.cmbTurma.value==frm.cmbTurmaAlocacao.value){
			alert("Turma para Alocação não poderá ser igual a Turma de Origem. Verifique!")		
			frm.cmbTurmaAlocacao.focus();
			return false
		}

		if (!confirm("ATENÇÃO! O ALUNO SERA ALOCADO PARA UMA NOVA TURMA, E SUA GRADE DE DISCIPLINAS SERÁ RECRIADA, Deseja continuar?"))
			return false;
		else{
			frm.action="ControleAlocacaoAluno_cod.asp";
			frm.submit();
			return true;
		}

 	}

</script>
<%
	strPaginaTitulo = "ControleAlocacaoAluno_cad.asp"

	strExecutarSubmitSemestre 		= "S"
	strExecutarSubmitSemestreAlocacao = "S"
	strExecutarSubmitTurma	 		= "S"	

	intSemestre 			= Trim(Request("cmbSemestre"))
	strSemestre 			= Trim(Request("cmbSemestre"))
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if
	if Trim(Request("cmbSemestreAlocacao")) <> "0" and Trim(Request("cmbSemestreAlocacao")) <> "" then
		intSemestreAlocacao 	= Trim(Request("cmbSemestreAlocacao"))
	else
		intSemestreAlocacao 	= session("strSemestre")
	end if
	if Trim(Request("txtAnoLetivoLocacao")) <> "" then
		strAnoLetivoLocacao 	= Trim(Request.Form("txtAnoLetivoLocacao"))
	else
		strAnoLetivoLocacao 	= session("strAnoLetivo")
	end if


	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodTurmaAlocacao 	= Trim(Request.Form("cmbTurmaAlocacao"))
	strTipoAlocacao 		= Trim(Request.Form("cmbTipoAlocacao"))
 	strLetraInicial        	= Trim(Request.Form("txtLetraInicial"))
	strLetraFinal          	= Trim(Request.Form("txtLetraFinal"))
	
	if intCodTurma 		= "" then intCodTurma 		= "0"

	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	strbotaoAtualizar		= "S"
	
	if intCodTurma = "0" or intCodTurma = "" then
		msgFiltroAZ = " Obrigratório"
	else
		msgFiltroAZ = " Opcional"
	end if
%>
<form method="post" id="frm" action="ControleAlocacaoAluno_cad.asp">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td  align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
		<tr valign="top">
		  <td align="center">
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
    <tr>
      <td class="texto1">&nbsp;</td>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="3" class="texto1"><strong>Dados de Origem</strong></td>
      </tr>
    <tr>
      <td class="texto1">Ano:</td>
      <td colspan="2"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
    </tr>
    <tr>
      <td class="texto1">Semestre:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
    </tr>
    <tr> 
      <td width="14%" class="texto1">Turma Origem:</td>
      <td width="86%" colspan="2" class="texto1"><!--#include file="../includes/inc_cmdTurmaModulacaoTotal.asp"--></td>
    </tr>
    <tr>
      <td height="18" class="texto1">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td height="18" class="texto1"><strong>Nova Aloca&ccedil;&atilde;o</strong></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td height="18" class="texto1"><strong>Ano:</strong></td>
      <td><input  name="txtAnoLetivoLocacao" type="text" class="text" id="txtAnoLetivoLocacao" onBlur="submit()"  value="<%=strAnoLetivoLocacao%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
    </tr>
    <tr>
      <td height="18" class="texto1"><strong>Semestre:</strong></td>
      <td><!--#include file="../includes/inc_cmdSemestreAlocacao.asp" --></td>
    </tr>
    <tr>
      <td height="18" class="texto1"><strong>Turma:</strong>:</td>
      <td><!--#include file="../includes/inc_cmdTurmaModulacaoTotalAlocacao.asp"--></td>
    </tr>
    <tr>
      <td height="18" class="texto1"><strong>Tipo de Aloca&ccedil;&atilde;o:</strong></td>
      <td><select name="cmbTipoAlocacao" class="combo" id="cmbTipoAlocacao"  style="width:110pt" onchange='submit()' >
            <option value="TG" <%if strTipoAlocacao = "TG" then response.Write("selected") %>>TURMA E GRADE</option>
      </select></td>
    </tr>
    <tr> 
      <td class="texto1">&nbsp;</td>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="3"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr> 
      <td colspan="3"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
    </tr>
    <tr> 
      <td colspan="3" class="texto1"> 
      <%
	  if intCodTurma <> "0"  and intCodTurma <> "" then
	  %>
      <br> 
			<table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
          <tr class="CabecalhoConsulta"> 
            <td width="36" align="center" class="celula"><input type="checkbox" name="chkTodos" onClick="return marcaTodos(this.checked)"></td>
            <td width="133" class="celula"><strong>Matr&iacute;cula</strong></td>
            <td width="470" class="celula"><strong>Nome</strong></td>
            <td width="150" class="celula"><strong>Turma</strong></td>
            <td width="150" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
          </tr>
          <%					
			'seleciona os alunos da turma'					

			
			sql = "SELECT SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, "
			sql = sql & " SCA_ALUNO.NOMEALUNO, SCA_ALUNO_TURMA.COD_TURMA, "
			sql = sql & " SCA_TURMA.NomeTurma, SCA_SITUACAOALUNO.Desc_SituacaoAluno, I.EFETIVACAO, I.codigo as codInscricao  "
			sql = sql & " FROM SCA_ALUNO_TURMA "
			sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
			sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma "
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular"
			sql = sql & " LEFT JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.COD_SITUACAOALUNO"
			sql = sql & " LEFT JOIN MAT_INSCRICAO I ON I.COD_ALUNO = SCA_ALUNO.CODIGO"
			sql = sql & " where SCA_TURMA.cod_empresa = " & Session("CodEmpresa")			
			sql = sql & " and SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma & ""	
			sql = sql & " and SCA_ALUNO_TURMA.situacao = 'A'"
			if strLetraInicial <> "" and strLetraFinal <> "" then
			   sql = sql & " and SUBSTRING(NomeAluno,1,1) >= '" & strLetraInicial & "'"
			   sql = sql & " and SUBSTRING(NomeAluno,1,1) <= '" & strLetraFinal & "'"
			end If 
			sql = sql & " order by SCA_ALUNO.NOMEALUNO"
			rs.open sql, cnn
			if rs.eof = false then
				selecionado = "checked"
				cont = 0
				while not rs.eof
				    cont = cont+1
					strCodigoAluno        = rs("codigo")
					strMatricula		  = rs("MATRICULA")
					strEfetivacao		  = rs("EFETIVACAO")
					strBloqAltrExcl 	  = ""
					corLinha 			  = " "
					if not isnull(rs("codInscricao")) then
						if strEfetivacao = "S" then
							strBloqAltrExcl = ""
							corLinha = " "
						else
							strBloqAltrExcl = "disabled"
							strMensagemEfetivacao = "<br><table class='tabela' width='50%' border='0' cellspacing='0' cellpadding='0'><tr  bgcolor='#9BCDFF'><td class='celula'><strong>* Aluno não está efetivado!</strong></td></tr></table><br><br>"
							corLinha = " bgcolor='#9BCDFF' "
						end if
					end if			
					%>
          			<tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" <%=corLinha%>> 
           			<td class="celula" align="center"><input type="checkbox"  <%=strBloqAltrExcl%>  id="chkAluno" name="chkAluno" value="<%=rs("codigo")%>"></td>
                    <td class="celula">&nbsp;<%=strMatricula%></td>
                    <td class="celula"><%=rs("NOMEALUNO")%>&nbsp;</td>
                    <td class="celula"><%=rs("NOMETURMA")%>&nbsp;</td>
                    <td class="celula"><%=rs("Desc_SituacaoAluno")%>&nbsp;</td>
                  	</tr>
          			<%			
					selecionado = ""
					rs.movenext
				wend
			else
					%>
					  <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
						<td colspan="5" align="center" class="celula"><%=session("strMensagemRelatorioNaoEncontrado")%></td>
					  </tr>
					  <%
			end if
			rs.close
					%>
          <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
            <td colspan="5" align="center" class="celula">Total de Alunos:&nbsp;<%=cont%> </td>
            </tr>
        </table>
			<br><strong><%=strMensagemEfetivacao%></strong>
            
       <%
	   end if
	   %>     
            </td>
    </tr>
  </table>
  		  </td>
		</tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>