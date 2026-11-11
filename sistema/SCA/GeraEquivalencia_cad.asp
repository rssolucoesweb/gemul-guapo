<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 04/08/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: troca situacao aluno
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
<script type="text/JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
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
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->

<script>
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtMatricula.value == "") {
			alert("A Matricula do Aluno deve ser informada !");
			frm.txtMatricula.focus();
			return false;
		}
		if (frm.txtNomealuno.value == "") {
			alert("Aluno deve ser informado!");
			frm.txtMatricula.focus();
			return false;
		}

		frm.action="GeraEquivalencia_cod.asp?acao=" + acao;
		frm.submit();
		return true;
	}
	function validaDocumentoData(valor, cod){
		if (valor==true){
			document.all["txtDataProrrogacao"+cod].value="";
			document.all["txtDataProrrogacao"+cod].disabled=true;
		}else{
			document.all["txtDataProrrogacao"+cod].value="";
			document.all["txtDataProrrogacao"+cod].disabled=false;
		}
	}
</script>
<%
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"

	strPaginaTitulo 	= "GeraEquivalencia_cad.asp"

	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula 		= Trim(Request("txtMatricula"))
	strNomealuno 		= Trim(Request("txtNomealuno"))
	intCodCurso	 		= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 		= Trim(Request.Form("cmbPeriodo"))
	if intCodPeriodo = "" then intCodPeriodo = "0"
	if intCodAluno = "" then intCodAluno = "0"

	if trim(strMatricula) <> "" then
	
		sql = "Select sca_aluno.Codigo, sca_aluno.NomeAluno, sca_aluno.matricula, sca_aluno.DATAFASTAMENTO, sca_aluno.DATAMATRICULA, sca_situacaoaluno.Desc_SituacaoAluno "
		sql = sql & " from sca_aluno"
		sql = sql & " left join sca_situacaoaluno on sca_situacaoaluno.Cod_SituacaoAluno = sca_aluno.cod_situacaoaluno and sca_situacaoaluno.cod_empresa = sca_aluno.cod_empresa"
		sql = sql & " where sca_aluno.cod_empresa = " & session("CodEmpresa")
		sql = sql & " and sca_aluno.matricula = " & strMatricula
		rs.open sql, cnn
		if rs.eof = false then  
			intCodAluno			= Trim(rs("codigo"))
			strCodAluno			= Trim(rs("codigo"))
			strMatricula 		= Trim(rs("Matricula"))
			strNomealuno 		= Trim(rs("Nomealuno"))
		else
		    intCodAluno         = "0"
			strCodAluno			= 0
			strNomealuno 		= ""
			%>
			<script>
				alert("Aluno não foi encontrado.");
			</script>
			<%
		end if
		rs.close	
	
	else
		strCodAluno			= "0"
	    intCodAluno         = "0"
		strMatricula 		= ""
		strNomealuno 		= ""
	end if

	if intCodPeriodo = "0" then
		strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
		strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
		strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
		strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
	else
		strDesabilitaIncluir = "" 'Desabilita o botão Incluir'
		strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
		strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
		strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
		
	end if	
		

%>

<form method="post" id="frm" action="GeraEquivalencia_cad.asp">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td width="100%" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
		<tr valign="top">
		  <td align="center" valign="top">
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
    <tr>
      <td class="texto1">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="14%" class="texto1">Matr&iacute;cula: </td>
      <td width="86%"><input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="10" value="<%=strCodAluno%>" maxlength="10"><span class="texto1">
        <input name="txtMatricula" type="text" class="text" id="txtMatricula" size="20" maxlength="20" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 9)" onBlur="submit()">
        <a  href="#" onClick="return abreConsulta('Aluno_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a></span>&nbsp;<input readonly name="txtNomealuno" type="text" class="textDesabilita" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>" ></td>
    </tr>
    <tr>
      <td height="18" colspan="2" class="texto1">&nbsp;</td>
      </tr>
    <tr>
      <td height="18" colspan="2" class="texto1"><!--#include file="../includes/inc_sqlDadosAluno.asp"--></td>
      </tr>
    <tr>
      <td height="18" class="texto1">&nbsp;</td>
      <td class="texto1">&nbsp;</td>
    </tr>
    <tr>
      <td height="18" class="texto1">Curso de Equivalente::</td>
      <td class="texto1"><!--#include file="../includes/inc_cmdCurso.asp"--></td>
    </tr>
    <tr>
      <td height="18" class="texto1">P&eacute;riodo de Equivalente:</td>
      <td class="texto1"><!--#include file="../includes/inc_cmdPeriodo.asp"--></td>
    </tr>
    <tr> 
      <td height="18" class="texto1">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td height="18" class="texto1" colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td height="18" class="texto1" colspan="2">
      <%
		'historico disciplinas
		sql = "SELECT H.*, D.DESC_DISCIPLINA, P.DESCRICAO AS PERIODO, H.situacao AS SITPROMOCAO"
		sql = sql & " FROM SCA_HISTORICO_ESCOLAR E"
		sql = sql & " inner JOIN SCA_HISTORICO_ESCOLAR_DISCIPLINA H ON H.cod_historico_escolar = E.CODIGO"
		sql = sql & " LEFT JOIN SCA_PERIODO P ON P.COD_PERIODO = E.COD_PERIODO AND P.COD_EMPRESA = E.COD_EMPRESA"
		sql = sql & " LEFT JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = H.COD_DISCIPLINA AND D.COD_EMPRESA = E.COD_EMPRESA"
		sql = sql & " WHERE P.COD_PERIODO  = " & intCodPeriodo
		sql = sql & " AND 	E.COD_EMPRESA  = " & Session("CodEmpresa") 
		sql = sql & " AND 	E.COD_ALUNO  = " & intCodAluno
		sql = sql & " AND 	H.situacao  <> 'AC'"
		sql = sql & " order by H.ano_letivo, H.semestre, P.DESCRICAO "
		rs.open sql, cnn
		if not rs.eof then	%>
        	<table width="99%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
            <tr bgcolor="#EEEEEE">
            <td height="20" colspan="6" class="celula"><div align="center"><strong>Disciplinas do Hist&oacute;rico </strong></div></td>
            </tr>
            <tr bgcolor="#EEEEEE">
            <td width="52%" class="celula">&nbsp;<strong>Disciplina</strong></td>
            <td width="13%" class="celula">&nbsp;<strong>Per&iacute;odo</strong></td>
            <td width="8%" height="20" class="celula">&nbsp;<strong>Ano/Sem.</strong></td>
            <td width="6%" class="celula">&nbsp;<strong>C.H.</strong></td>
            <td width="6%" class="celula">&nbsp;<strong>M&eacute;dia</strong></td>
            <td width="8%" class="celula"><strong>&nbsp;Situa&ccedil;&atilde;o</strong></td>
            </tr>
		    <%
			while not rs.eof 
				%>
       			<tr bgcolor="#FFFFFF"  style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
            	<td class="celula">&nbsp;<%=rs("DESC_DISCIPLINA")%></td>
            	<td class="celula">&nbsp;<%=rs("PERIODO")%></td>
            	<%
				if trim(rs("SEMESTRE")) = 3  then
				   	%>
       				<td height="20" class="celula">&nbsp;&nbsp;&nbsp;&nbsp;<%=rs("ANO_LETIVO")%></td>
                    <%
				else	 
				    %>
            		<td height="20" class="celula">&nbsp;<%=rs("ANO_LETIVO")%>/<%=rs("SEMESTRE")%></td>
                    <%
				end if
				%>
            	<td class="celula" onClick="return resultadoConsultaDisciplina('<%=rs("cod_historico_escolar")%>','<%=rs("CODIGO")%>')">&nbsp;<%=rs("CARGA_HORARIA")%></td>
            	<% 
				if not isnull(rs("MEDIA")) then
				    %>
            		<td class="celula">&nbsp;<%=round(rs("MEDIA"),1)%></td>
            		<%	 
		   	    else
				    %>
            		<td width="2%" class="celula">&nbsp;----</td>
            		<%	 
				end if	
				%>
            	<td width="2%" class="celula">&nbsp;<%=rs("SITPROMOCAO")%></td>
                </tr>
                <%
				rs.movenext
			wend
		 else
    		strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
	    	if trim(strMatricula) <> "" then
				%>
				  <tr>
					<td colspan="6" class="<%=strclasse%>" align="center"><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
				  </tr>
				<%
			end if	
         end if
		 %>   
        <tr>
          <td class="texto1" colspan="6">&nbsp;</td>
        </tr>
        </table></td>
    </tr>
    <tr> 
      <td class="texto1" colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
    </tr>    
        <tr>
          <td class="texto1" colspan="2">&nbsp;</td>
        </tr>
  </table>
  		  </td>
		</tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>