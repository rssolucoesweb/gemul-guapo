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
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<script>
	function marcaTodos(valor){
		
		var form = window.document.forms[0];
		var i;
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "checkbox"){
				//verifica se o checkbox está marcado
				form.elements[i].checked=valor;
			}
		}
	}
	
	function salvar(acao){
		
		if (acao=='E'){
		
			if (frm.txtAnoLetivo.value=="") {
				alert("Ano Letivo deve ser informado.");
				frm.txtAnoLetivo.focus();
				return false
			}
			
			if (frm.txtAnoLetivo.value>intAnoSession) {
				alert("Ano/Semestre letivo não permitido.");
				frm.txtAnoLetivo.focus();
				return false
			}
		
			if (frm.cmbSemestre.value == 0){
				alert("O Semestre deve ser informado!");
				frm.cmbSemestre.focus();
				return false;
			}

			if (frm.cmbCurso.value == 0){
				alert("O Curso deve ser informado!");
				frm.cmbCurso.focus();
				return false;
			}
			
			
			if (frm.cmbEventoSeminario.value == "0") {
				alert("O Evento deve ser informado !");
				frm.cmbEventoSeminario.focus();
				return false;
			}
			
			var men = 'ATENÇÃO: Deseja realmente excluir este Vinculo de Evento?\n '
			if (confirm(men)) {
			
				frm.action= "Evento_Frequencia_cod.asp?acao=" + acao;
				frm.submit();
				return true;
			} else {
				return false;
			}
		}
		else
		{
		
			var form = window.document.forms[0];
			var intContMarcado=0;
			var strAlunos='';
			var intAnoSession = <%=session("strAnoLetivo")%>;
			
			if (frm.txtAnoLetivo.value=="") {
				alert("Ano Letivo deve ser informado.");
				frm.txtAnoLetivo.focus();
				return false
			}
			
			if (frm.txtAnoLetivo.value>intAnoSession) {
				alert("Ano/Semestre letivo não permitido.");
				frm.txtAnoLetivo.focus();
				return false
			}
		
			if (frm.cmbSemestre.value == 0){
				alert("O Semestre deve ser informado!");
				frm.cmbSemestre.focus();
				return false;
			}
	
			if (frm.cmbCurso.value == 0){
				alert("O Curso deve ser informado!");
				frm.cmbCurso.focus();
				return false;
			}

			if (frm.cmbEventoSeminario.value == "0") {
				alert("O Evento deve ser informado !");
				frm.cmbEventoSeminario.focus();
				return false;
			}
					
			//*****verifica se um aluno foi selecionado
			intContMarcado=0;
			for (var i = 0; i < form.elements.length; i++) {
				//verifica todos os checkbox
				if (form.elements[i].type == "checkbox"){
					if (form.elements[i].name == "chkAluno"){
						//verifica se o checkbox está marcado
						if (form.elements[i].checked){
							intContMarcado = intContMarcado + 1;
						}
					}
				}
			}	
			
			if (intContMarcado==0){
				alert("O(s) aluno(s) deve(m) ser informado(s)!");
				return false;
			}
			
			frm.action= "Evento_Frequencia_cod.asp?acao=" + acao;
			frm.submit();
			
			return true;
			
		}	
	}
</script>
<%
	strPaginaTitulo 		  = "Evento_Frequencia_cad.asp"
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	
    intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intAno		 			= Trim(Request.Form("txtAno"))
	intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	intCodEventoSeminario	= Trim(Request.Form("cmbEventoSeminario"))
	
   
	
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")

	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	if intCodEventoSeminario = "" then intCodEventoSeminario = "0"
	
	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula 		= Trim(Request("txtMatricula"))
	strNomealuno 		= Trim(Request("txtNomealuno"))

	if trim(strMatricula) <> "" then
	
		sql = "Select Codigo, NomeAluno, matricula from sca_aluno"
		sql = sql & " where cod_empresa = " & session("CodEmpresa")
		sql = sql & " and matricula = " & strMatricula
		rs.open sql, cnn
		if rs.eof = false then
			strCodAluno			= Trim(rs("codigo"))
			strMatricula 		= Trim(rs("Matricula"))
			strNomealuno 		= Trim(rs("Nomealuno"))
		else
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
		strCodAluno			= ""
		strMatricula 		= ""
		strNomealuno 		= ""
	end if
	
	if intCodEventoSeminario <> "0" then 
		sql = "Select Codigo, Cod_Empresa, CargaHoraria"
		sql = sql & " From SCA_SEMINARIO_EVENTO "
		sql = sql & " Where Codigo = " & intCodEventoSeminario
		rsAux.open sql, cnn
		if rsAux.eof = false then
			strCargaHorariaEvento 	= trim(rsAux("CargaHoraria"))
		end if
		rsAux.close	
	end if
	if intCodEventoSeminario <> "0" then 
		sql = "Select Cod_aluno, Cod_Turma, Cod_Seminario_Evento, FrequenciaCH"
		sql = sql & " From SCA_SEMINARIO_EVENTO_FREQUENCIA "
		sql = sql & " Where Cod_Seminario_Evento = " & intCodEventoSeminario
		rsAux.open sql, cnn
		if rsAux.eof = false then
			strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
			strDesabilitaAlterar = "" 'Habilita o botão Alterar
			strDesabilitaExcluir = "" 'Desabilita o botão Excluir
			strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
		else
			strDesabilitaIncluir = "" 'Desabilita o botão Incluir'
			strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
			strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
			strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
		end if
		rsAux.close
	else
		strDesabilitaIncluir = "" 'Desabilita o botão Incluir'
		strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
		strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
		strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
	end if
	%>
<table width="100%" height="355" border="0" bgcolor="#FFFFFF"  cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="100%"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post">
		  <table width="98%" border="0" cellpadding="0" cellspacing="0">

            <tr valign="top">
              <td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
		  <table width="98%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="92" class="texto1">Ano Letivo:</td>
            <td width="897"><span class="texto1">
              <input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
            </span></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Semestre:</td>
            <td><span class="texto1">
              <!--#include file="../includes/inc_cmdSemestre.asp" -->
            </span></td>
          </tr>
          <tr>
            <td height="30" class="texto1">Curso:</td>
            <td colspan="2"><span class="texto1"><!--#include file="../includes/inc_cmdCurso.asp"--></span></td>
          </tr>
          <tr>
            <td height="30" class="texto1">Turma : </td>
            <td><!--#include file="../includes/inc_cmdTurma.asp"--></td>
          </tr>
          <tr>
            <td height="27" class="texto1">Matr&iacute;cula : </td>
            <td width="89%" class="Formulario"><input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="10" value="<%=strCodAluno%>" maxlength="10">
                <span class="texto1">
                <input name="txtMatricula" type="text" class="text" id="txtMatricula" size="20" maxlength="20" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 9)" onBlur="submit()">
                <a  href="#" onClick="return abreConsulta('Aluno_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a></span>&nbsp;
              <input readonly name="txtNomealuno" type="text" class="textDesabilita" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>" ></td>
          </tr>
          <tr>
            <td height="27" class="texto1">Evento :</td>
            <td><span class="texto1">
              <!--#include file="../includes/inc_cmdEventoSeminario.asp"-->
            </span></td>
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
            <td colspan="2"><br>
              <%
			if intCodTurma    = "" then intCodTurma="0"
			if intCodPeriodo  = "" then intCodPeriodo="0"
			If intCodCurso	  = "" then intCodCurso ="0" 	

			'if intCodTurma<>"0" then%>
              <table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
                <tr class="CabecalhoConsulta">
                  <td width="32" align="center" class="celula"><input type="checkbox" name="chkTodos" onClick="return MarcaTodos(this.checked)"></td>
                  <td width="128" class="celula"><strong>Matr&iacute;cula</strong></td>
                  <td width="436" class="celula"><strong>Nome</strong></td>
                  <td width="108" class="celula"><strong>Turma</strong></td>
                  <td width="101" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
                  <td width="120" align="center" class="celula"><strong>Frequ&ecirc;ncia (C.H) </strong></td>
                </tr>
                <%					
				sql = "SELECT  SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.MAE , SCA_PERIODO.DESCRICAO AS PERIODO, SCA_CURSO.DESCRICAO AS CURSO, SCA_TURMA.COD_TURMA, SCA_TURMA.NomeTurma, SCA_SITUACAOALUNO.Desc_Situacaoaluno"
				sql = sql & " FROM SCA_ALUNO_TURMA "
				sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
				sql = sql & " INNER JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.COD_SITUACAOALUNO = SCA_ALUNO.COD_SITUACAOALUNO "
				sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular"
				sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa"
				sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa"
				sql = sql & " where SCA_TURMA.cod_empresa = " & session("CodEmpresa")
				sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A'"
				sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & strAnoLetivo
				sql = sql & " and 	SCA_ALUNO_TURMA.Semestre IN (" & intSemestre & ")"
				if intCodCurso <> "0" then
					sql = sql & " and SCA_CURSO.Cod_Curso = " & intCodCurso
				end if
				if intCodPeriodo <> "0" then
					sql = sql & " and SCA_GRADECURRICULAR.Cod_Periodo = " & intCodPeriodo
				end if
				if intCodTurno <> "0" then
					sql = sql & " and SCA_TURMA.COD_TURNO = " & intCodTurno
				end if
				if strCodAluno <> "0" and strCodAluno <> ""  then
				   sql = sql & " and SCA_ALUNO_TURMA.COD_ALUNO = " & strCodAluno
				else
				   if intCodTurma <> "0"  then
  				      sql = sql & " and SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma   
				   end if
				end if
				sql = sql & " Order By SCA_ALUNO.NOMEALUNO"
				rs.open sql, cnn
				if rs.eof = false then
				   while not rs.eof
				
					i = i + 1
					
					strCargaHoraria			= ""
					strMarca  				= ""
					strCodigoAluno        	= rs("CODIGO")
					strMatricula		  	= rs("MATRICULA")
					strNomeTurma		  	= rs("NOMETURMA")
												
					sql = "Select Cod_aluno, Cod_Turma, Cod_Seminario_Evento, FrequenciaCH"
					sql = sql & " From SCA_SEMINARIO_EVENTO_FREQUENCIA "
					sql = sql & " Where Cod_Seminario_Evento = " & intCodEventoSeminario
					sql = sql & " and Cod_aluno = " & trim(rs("CODIGO"))
					rsAux.open sql, cnn
					if rsAux.eof = false then
						strCargaHoraria 	= trim(rsAux("FrequenciaCH"))
						strMarca			= "checked"
					else
						strCargaHoraria 	= strCargaHorariaEvento
					end if
					rsAux.close
					%>
                	<tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
                 		<td class="celula" align="center"><input type="checkbox" id="chkAluno" name="chkAluno" <%=strMarca%> value="<%=rs("codigo")%>"></td>
                  		<td class="celula"><%=strMatricula%></td>
                  		<td class="celula"><%=rs("NOMEALUNO")%>&nbsp;</td>
                  		<td class="celula"><%=rs("NOMETURMA")%></td>
                  		<td class="celula"><%=rs("DESC_SITUACAOALUNO")%></td>
                  		<td align="center" class="celula"><input name="txtCargaHoraria<%=i%>" type="text" class="text" id="txtCargaHoraria<%=i%>" onKeyPress="return formataCampo(this, 2, 6)"  size="5" maxlength="5" value="<%=strCargaHoraria%>"></td>
                	</tr>
                	<%
						rs.movenext
					wend
				else
				%>
                <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
                <td colspan="6" align="center" class="celula">&nbsp;<%=session("strMensagemRelatorioNaoEncontrado")%></td>
                </tr>
                <%
				end if
				rs.close
			'end if
			%>
              </table>
              <br></td>
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