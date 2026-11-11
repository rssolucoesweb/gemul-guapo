<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/01/2009
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Vincula a Rota ao Aluno
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

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif')">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script>
	
	function resultadoConsulta(intCodFrequenciaSeminario){
		
		var frm = document.getElementById("frm");

		frm.txtCodigoFrequenciaSeminario.value=intCodFrequenciaSeminario;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtAnoLetivo.value=="") {
			alert("Ano Letivo deve ser informado.");
			frm.txtAnoLetivo.focus();
			return false
		}
	
		if (frm.cmbSemestre.value == 0){
			alert("O Semestre deve ser informado!");
			frm.cmbSemestre.focus();
			return false;
		}

		if (frm.cmbEventoSeminario.value == "0") {
			alert("O Evento deve ser informado !");
			frm.cmbEventoSeminario.focus();
			return false;
		}
		
		if (frm.txtDescricaoEvento.value=="") {
			alert("A Atividade deve ser informada.");
			frm.txtDescricaoEvento.focus();
			return false
		}
		
		if (frm.txtDataInicial.value=="") {
			alert("A Data Inicial deve ser Informada.");
			frm.txtDataInicial.focus();
			return false
		}
		
		if (frm.txtDataFinal.value=="") {
			alert("A Data Final deve ser Informada.");
			frm.txtDataFinal.focus();
			return false
		}
		
		if (frm.txtCargaHoraria.value=="") {
			alert("A Carga Horária da Atividade deve ser informada.");
			frm.txtCargaHoraria.focus();
			return false
		}
					
		frm.action= "Evento_Frequencia_cod.asp?acao=" + acao;
		frm.submit();
		return true;
	}
</script>
<%
strPaginaTitulo 		  = "Evento_Frequencia_cad.asp"
strPagina                 = "Evento_Frequencia_cad.asp"
strExecutarSubmitSemestre = "S"

intCodFrequenciaSeminario	= Trim(Request("txtCodigoFrequenciaSeminario"))
intAnoLetivo            	= Trim(Request("txtAnoLetivo"))
intSemestre             	= Trim(Request.Form("cmbSemestre"))
intCodEventoSeminario		= Trim(Request.Form("cmbEventoSeminario"))
intCodigo 					= Trim(Request.Form("txtCodAluno"))
strDescricaoEvento      	= Trim(Request.Form("txtDescricaoEvento"))
strDataInicial				= Trim(Request.Form("txtDataInicial"))
strDataFinal				= Trim(Request.Form("txtDataFinal"))
strCargaHoraria         	= Trim(Request.Form("txtCargaHoraria"))

strCodAluno                 = Trim(Request("txtCodAluno"))
strMatricula 		    	= Trim(Request("txtMatricula"))
strNomealuno 		    	= Trim(Request("txtNomealuno"))

if Trim(Request.QueryString("txtMatricula")) <> "" then
   strMatricula        	= Trim(Request.QueryString("txtMatricula"))
end if


if intSemestre = "" then intSemestre = "0"
if intCodCurso = "" then intCodCurso = "0"

strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Alterar
strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

if strDescricaoEvento <> "" then
   strDesabilitaIncluir	= "" 'Habilita o botão Incluir
end if   
	
%>
<form id="frm" method="post">
<table width="98%" border="0" cellpadding="0" cellspacing="0">
<tr valign="top">
<td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
</tr>
</table>
<br>
<table width="99%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td height="28" class="texto1">Matr&iacute;cula : </td>
<td colspan="4"><span class="Formulario">
<span class="texto1">
<input name="txtMatricula" type="text" class="text" id="txtMatricula" size="20" maxlength="20" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 10)" onBlur="submit()"> 
-
<a  href="#" onClick="return abreConsulta('Aluno_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a></span>&nbsp;
<input readonly name="txtNomealuno" type="text" class="textDesabilita" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>" >
<input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="10" value="<%=intCodigo%>" maxlength="10">

</span></td>

<%

if trim(intCodFrequenciaSeminario) <> "" then
	sql = "Select F.Codigo, F.Cod_aluno, F.Cod_Turma, F.Cod_Seminario_Evento, F.FrequenciaCH, F.Descricao_Evento, F.DataInicial, F.DataFinal, A.matricula, E.Ano_Letivo, E.Semestre, E.cod_curso, E.DataInicial as DataInicialEvento, E.DataFinal as DataFinalEvento"	
	sql = sql & " From sca_seminario_evento_frequencia F "
	sql = sql & " inner join sca_aluno A ON A.codigo = F.cod_aluno " 
	sql = sql & " inner join sca_seminario_evento E ON E.codigo = F.Cod_Seminario_Evento " 
    sql = sql & " Where F.codigo = " & intCodFrequenciaSeminario
	rs.open sql, cnn
	if rs.eof = false then
	    'intCodFrequenciaSeminario   = trim(rs("Codigo"))
	    strCodAluno			   		= Trim(rs("Cod_aluno"))
		strMatricula 		 		= Trim(rs("Matricula"))
		intAnoLetivo            	= rs("Ano_Letivo")
		intSemestre             	= rs("Semestre")
	   	intCodTurma   		    	= rs("Cod_Turma")
	    intCodCurso             	= rs("cod_curso") 
   	    strCargaHoraria   			= rs("FrequenciaCH")
		if strDescricaoEvento = "" then
 	       strDescricaoEvento   	    = rs("Descricao_Evento")
		end if 
		if intCodEventoSeminario = "0" then
           intCodEventoSeminario	    = trim(rs("Cod_Seminario_Evento"))
		end if   
		if isnull(rs("DataInicial")) then
		   strDataInicial           = formatadataAP(rs("DataInicialEvento"))
		else
           strDataInicial           = formatadataAP(rs("DataInicial"))
		end if 
	    if isnull(rs("DataFinal")) then
		   strDataFinal             = formatadataAP(rs("DataFinalEvento"))
		else
           strDataFinal             = formatadataAP(rs("DataFinal"))
		end if   
        
		strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
    end if
	rs.close
else
    intCodFrequenciaSeminario = "" 	
end if			

if trim(strMatricula) <> "" then
	sql = "Select Codigo, NomeAluno, matricula, cod_situacaoaluno from sca_aluno"
   	sql = sql & " where cod_empresa = " & session("CodEmpresa")
   	sql = sql & " and matricula = " & strMatricula
	rs.open sql, cnn
	if rs.eof = false then
		strCodAluno			= Trim(rs("codigo"))
		intCodAluno			= Trim(rs("codigo"))
		strMatricula 		= Trim(rs("Matricula"))
		strNomealuno 		= Trim(rs("Nomealuno"))
		if isnull(rs("cod_situacaoaluno")) then
			%>
      		<script>
				alert("Aluno não Vinculado a uma Situação Cadastral.");
				window.history.back();
			</script>
            <%
		end if   
	else
		strCodAluno			= 0
		intCodAluno         = 0
		strNomealuno 		= ""
		strMatricula        = ""
		%>
        <script>
			alert("Aluno não foi encontrado.");
			window.history.back();
		</script>
      	<%
	end if
	rs.close
	'
	' Verificando a alocação do aluno
	sql = "SELECT TOP 1 SCA_CURSO.Cod_Curso, SCA_TURMA.COD_SEMESTRE, SCA_TURMA.COD_TURMA, SCA_TURMA.ANOLETIVO, SCA_GRADECURRICULAR.COD_AGRUPAMENTO, SCA_TURMA.Cod_GradeCurricular, SCA_GRADECURRICULAR.AnoReferencia, SCA_GRADECURRICULAR.SemestreReferencia, SCA_TURMA.Nometurma "
	sql = sql & " FROM SCA_ALUNO_TURMA " 
	sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO " 
	sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo "
	sql = sql & " and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa "
	sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa "
	sql = sql & " where SCA_TURMA.cod_empresa = " & Session("CodEmpresa")
	sql = sql & " and 	SCA_ALUNO.CODIGO = " & strCodAluno
	sql = sql & " order by SCA_ALUNO_TURMA.CODIGO DESC "
	rs.open sql, cnn
	if not rs.eof then
	   	intCodCurso   					= rs("cod_curso") 
	   	intCodTurma    					= rs("COD_TURMA")
		intCodGradeagrupamento          = rs("COD_AGRUPAMENTO")
		if intsemestre = "0" then
	   	   intSemestre    = rs("COD_SEMESTRE")
		end if
	    if intAnoLetivo = "" then   
	 	   intAnoLetivo   = rs("ANOLETIVO")
		end if 
		if isnull(rs("COD_AGRUPAMENTO")) then
			%>
			<script>
				alert("ATENÇÃO: Código de agrupamento não vinculado a grade curricular n. <%=trim(rs("Cod_GradeCurricular") & " - " & rs("AnoReferencia") & "/" & rs("SemestreReferencia"))%> turma <%=trim(rs("Nometurma"))%>, procure a Secretaria Geral.");
				window.history.back();
			</script>
			<%
		end if
	else
		%>
        <script>
			alert("ATENÇÃO: O Aluno ainda não foi alocado em uma turma, verifique!");
			window.history.back();
		</script>
        <%
	end if
	rs.close

	sql = "SELECT ED.CODIGO, ED.COD_CURSO, ED.COD_DISCIPLINA, ED.CARGA_HORARIA, D.DESC_DISCIPLINA "
	sql = sql & " FROM SCA_EVENTO_DISCIPLINA ED "
	sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = ED.COD_DISCIPLINA AND D.COD_EMPRESA = ED.COD_EMPRESA "
	sql = sql & " WHERE ED.COD_EMPRESA = " & Session("CodEmpresa")	
	sql = sql & " AND ED.COD_CURSO = " & intCodCurso			
	sql = sql & " AND ED.COD_AGRUPAMENTO = " & intCodGradeagrupamento			
	sql = sql & " Order by D.DESC_DISCIPLINA"
	rs.open sql, cnn
	if rs.eof = false then
	   	if isnull(rs("cod_curso")) or rs("cod_curso") = "" or rs("cod_curso") = "0" then
		  	%>
        	<script>
				alert("ATENÇÃO: Valor Inválido para a Carga Horária, verifique!");
				window.history.back();
			</script>
        	<%
	   	end if

		strCargaHorariaCurricular	    = rs("CARGA_HORARIA")
		strDesc_Disciplina		        = rs("DESC_DISCIPLINA")

	else
		%>
        <script>
			alert("ATENÇÃO: Disciplina Complementar ainda não foi Cadastrada, verifique!");
			window.history.back();
		</script>
        <%
	end if 
	rs.close
	
	%>
	<tr bgcolor="#D3D3D3">
	  <td height="19" colspan="7" class="celula"><!--#include file="../includes/inc_sqlDadosEscolaresAluno.asp" --></td>
	</tr>
    <tr>
     <td colspan="4">&nbsp;</td>
    </tr>
	<tr>
	  <td class="texto1">Disciplina Curricular: </td>
	  <td colspan="3" class="texto1"><strong><%=strDesc_Disciplina%></strong>&nbsp;-&nbsp;Carga hor&aacute;ria:&nbsp;<span class="texto1"><strong><%=strCargaHorariaCurricular%></strong></span></td>
    </tr>
	<tr>
    <td width="116" class="texto1">Ano Letivo:</td>
    <td colspan="3"><span class="texto1"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=intAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></span></td>
    </tr>
	<tr>
	<td height="25" class="texto1">Semestre:</td>
	<td colspan="3"><span class="texto1"><!--#include file="../includes/inc_cmdSemestre.asp" --></span></td>
	</tr>
	<tr>
    <td height="27" class="texto1">Grupo de Evento :</td>
    <td colspan="3"><!--#include file="../includes/inc_cmdEventoSeminario.asp"--></td>
    </tr>
	<%
	if intCodEventoSeminario <> "" then
		sql = " SELECT CODIGO, EVENTO, DATAINICIAL, DATAFINAL, CARGAHORARIA "
		sql = sql & " FROM SCA_SEMINARIO_EVENTO "
		sql = sql & " WHERE CODIGO = " & intCodEventoSeminario
		rs.open sql, cnn
		if rs.eof = false then
			if strDescricaoEvento = "" then 
			   strDescricaoEvento 	= rs("EVENTO")
			end if
			if strDataInicial = "" then    
				strDataInicial 		= formatadataAP(rs("DATAINICIAL"))
			end if
			if strDataFinal = "" then 
				strDataFinal		= formatadataAP(rs("DATAFINAL"))
			end if
			if strCargaHoraria = "" then 
				strCargaHoraria 	= rs("CARGAHORARIA")
			end if
		end if   
		rs.close
     end if	
	%>
    <tr>
    <td height="27" class="texto1">Atividade n. <%=intCodFrequenciaSeminario%>:</td>
    <td width="375"><span class="texto1">
      <input name="txtDescricaoEvento" type="text" class="text" id="txtDescricaoEvento" onKeyPress="return" onBlur="submit()"  size="60" maxlength="100" value="<%=strDescricaoEvento%>"></span></td>
	<td width="262"><span class="texto1">Vig&ecirc;ncia: 
	  <input name="txtDataInicial" type="text" class="text" id="txtDataInicial" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataInicial%>">&nbsp;&agrave;&nbsp;<input name="txtDataFinal" type="text" class="text" id="txtDataFinal" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataFinal%>"></span></td>
	<td width="205"><span class="texto1">Frequ&ecirc;ncia/Carga Hor&aacute;ria: <span class="texto1">
	  <input name="txtCargaHoraria" type="text" class="text" id="txtCargaHoraria" onKeyPress="return formataCampo(this, 2, 6)"  size="5" maxlength="5" value="<%=strCargaHoraria%>"></span></span></td>
    </tr>
	<input name="txtCodTurma" type="hidden" id="txtCodTurma" class="text" size="10" value="<%=intCodTurma%>" maxlength="10">
    <input name="txtCodigoFrequenciaSeminario" type="hidden" id="txtCodigoFrequenciaSeminario" class="text" size="10" value="<%=intCodFrequenciaSeminario%>" maxlength="10">
    <input name="txtIDAluno" type="hidden" id="txtIDAluno" class="text" size="10" value="<%=strCodAluno%>" maxlength="10">
  <tr>
    <td colspan="4">&nbsp;</td>
    </tr>
    <tr>
    <td colspan="4"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
	</tr>
    <tr>
    <td colspan="4">&nbsp;</td>
    </tr>
  </table>
	
  <div align="center">
  <table class="tabela" width="94%" align="center" border="0" cellpadding="0" cellspacing="0">
    <tr bgcolor="#D3D3D3" height="25" class="celula">
      <td width="70" height="19" class="celula"><div align="center"><strong>Turma</strong></div></td>
        <td width="131" class="celula"><div align="center"><strong>C&oacute;digo da Atividade</strong></div></td>
        <td width="375" class="celula"><div align="center"><strong>Descri&ccedil;&atilde;o da Atividade</strong></div></td>
        <td width="115" class="celula"><div align="center"><strong>Frequ&ecirc;ncia/C.H</strong></div></td>
        <td width="113" class="celula"><div align="center"><strong>Data de In&iacute;cio </strong></div></td>
        <td width="118" class="celula"><div align="center"><strong>Data de Final </strong></div></td>
      </tr>
    <%
	
	sql = "Select EF.Codigo, EF.Cod_aluno, EF.Cod_Turma, EF.Cod_Seminario_Evento, EF.FrequenciaCH, EF.Descricao_Evento, EF.DataInicial, EF.DataFinal, T.NOMETURMA "		
	sql = sql & " From SCA_SEMINARIO_EVENTO_FREQUENCIA  EF "
	sql = sql & " inner join SCA_TURMA T ON T.COD_TURMA= EF.COD_TURMA "
	sql = sql & " Where Cod_aluno = " & strCodAluno
	sql = sql & " order by EF.Descricao_Evento "

	rsAux.open sql, cnn
	if rsAux.eof = false then
	   	while not rsaux.eof
		    if isnull(rsAux("DataInicial")) then
			   strDataInicialAtividade = ""
			else
 			   strDataInicialAtividade = formatadataAP(rsAux("DataInicial"))
			end if
		    if isnull(rsAux("DataFinal")) then
			   strDataFinalAtividade = ""
			else
 			   strDataFinalAtividade = formatadataAP(rsAux("DataFinal"))
			end if     
			%>
            <tr height="20" style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rsAux("Codigo")%>')">
      		<td class="celula"><div align="center"><%=rsAux("nometurma")%>&nbsp;</div></td>
	    	<td class="celula"><div align="center"><%=rsAux("Codigo")%>&nbsp;</div></td>
	    	<td class="celula"><%=rsAux("Descricao_Evento")%>&nbsp;</td>
	    	<td class="celula"><div align="center"><%=rsAux("FrequenciaCH")%>&nbsp;</div></td>
	    	<td class="celula"><div align="center"><%=strDataInicialAtividade%>&nbsp;</div></td>
	    	<td class="celula"><div align="center"><%=strDataFinalAtividade%>&nbsp;</div></td>
		    </tr>
		  <%	
			if isnull(rsaux("FrequenciaCH")) then
		       intTotalFrequenciaCH = intTotalFrequenciaCH + 0
			else   
		       intTotalFrequenciaCH = intTotalFrequenciaCH + rsaux("FrequenciaCH")
			end if   
			rsaux.movenext
		wend
		strAproveitamento  = (intTotalFrequenciaCH * 100)/strCargaHorariaCurricular
		strNota = (strAproveitamento / 10)
		if strNota > 10 then
		   strNota = 10
		end if   
		%>
		
	    <tr height="20">
	          <td colspan="4" align="center" class="celula">&nbsp;</td>
	          <td align="center" class="celula" bgcolor="#D3D3D3"><div align="right"><strong>C.H Cumprida: </strong></div></td>
	          <td align="center" bgcolor="#D3D3D3" class="celula"><strong><%=formatnumber(intTotalFrequenciaCH,0)%></strong>&nbsp;</td>
      </tr>
      <tr height="20">
      	<td colspan="4" align="center" class="celula">&nbsp;</td>
      	<td align="center" class="celula" bgcolor="#D3D3D3"><div align="right"><strong>Aproveitamento:</strong></div></td>
     	<td align="center" bgcolor="#D3D3D3" class="celula"><strong><%=formatnumber(strAproveitamento,0)%>%</strong></td>
   	  </tr>
   	  
		<%
	else
        %>
   	  <tr height="30">
     	<td colspan="6" align="center" class="celula">&nbsp;<%=session("strMensagemRelatorioNaoEncontrado")%></td>
      </tr>
    	<%
 	end if
    rsAux.close
else
    %>
    </tr>
    <tr>
      <td colspan="6">&nbsp;</td>
      </tr>
    <tr>
      <td colspan="6"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
      </tr>
    <tr>
      <td colspan="6">&nbsp;</td>
      </tr>
    <tr>
      <td colspan="6">&nbsp;</td>
      </tr>
    <tr height="120" >
      <td colspan="6">&nbsp;</td>
      </tr>
    <%
    intCodFrequenciaSeminario = "" 	
    strCodAluno			= ""
	strMatricula 		= ""
	strNomealuno 		= ""
end if
%>
    <tr>
      <td colspan="6"></td>
    </tr>
  </table>
  </table>
    </div>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>