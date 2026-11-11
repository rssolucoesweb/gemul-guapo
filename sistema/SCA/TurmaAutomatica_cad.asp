<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 27/11/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Cadastramento automatico de turmas
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
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<script>
	function salvar(acao,anoSession,regime){
		
		//anual
		if (regime==3){
			if (frm.txtAnoLetivo.value<=anoSession){
				alert("Ano letivo informado não permitido.");
				frm.txtAnoLetivo.focus();
				return false
			}
		}
		//1 semestre
		if (regime==1){
			if (frm.txtAnoLetivo.value<anoSession){
				alert("Ano letivo informado não permitido.");
				frm.txtAnoLetivo.focus();
				return false
			}
			if (frm.txtAnoLetivo.value==anoSession && frm.cmbSemestrePromocao.value==regime){
				alert("Semestre informado não permitido.");
				frm.cmbSemestrePromocao.focus();
				return false
			}
		}
		//2 semestre
		if (regime==2){
			if (frm.txtAnoLetivo.value<=anoSession){
				alert("Ano letivo informado não permitido.");
				frm.txtAnoLetivo.focus();
				return false
			}
			if (frm.txtAnoLetivo.value<=anoSession && frm.cmbSemestrePromocao.value==regime){
				alert("Semestre informado não permitido.");
				frm.cmbSemestrePromocao.focus();
				return false
			}
		}

		var form = window.document.forms[0];
		var intContMarcado=0;		
		if (frm.txtAnoLetivo.value==""){
			alert("Informe o ano letivo de destino.")		
			frm.txtAnoLetivo.focus();
			return false
		}
		if (frm.cmbSemestrePromocao.value=="0"){
			alert("Selecione o semestre de destino.")		
			frm.cmbSemestre.focus();
			return false
		}
		
		//*****verifica se a turma foi selecionada
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "checkbox"){
				if (form.elements[i].name == "chkTurma"){
					//verifica se o checkbox está marcado
					if (form.elements[i].checked){
						intContMarcado = intContMarcado + 1;
					}
				}
			}
		}	
		if (intContMarcado==0){
			alert("A(s) turma(s) deverá(ão) ser selecionada(s)!");
			return false;
		}		
		frm.action="TurmaAutomatica_cod.asp";
		frm.submit();
		return true;
 	}

</script>
<%
	strPaginaTitulo = "TurmaAutomatica_cad.asp"
	strExecutarSubmitSemestreTodos= "S"
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"

	strSemestre 			= Trim(Request("cmbSemestre"))
	if strSemestre = "" then strSemestre = "0"
	intSemestre 			= Trim(Request("cmbSemestre"))
	if intSemestre = "" then intSemestre = "0"	
	strAnoLetivo 			= session("strAnoLetivo")
	
	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula 		= Trim(Request("txtMatricula"))
	strNomealuno 		= Trim(Request("txtNomealuno"))

	if strMatricula <> "" then
	
		sql = "Select Codigo, NomeAluno, matricula from sca_aluno"
		sql = sql & " where cod_empresa = " & session("CodEmpresa")
		sql = sql & " and matricula = " & strMatricula
		rs.open sql, cnn
		if rs.eof = false then
			strCodAluno			= Trim(rs("codigo"))
			strMatricula 		= Trim(rs("Matricula"))
			strNomealuno 		= Trim(rs("Nomealuno"))
		end if
		rs.close	
	else
			strCodAluno			= ""
			strMatricula 		= ""
			strNomealuno 		= ""
	end if


	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	strMostraTurma	 		= Trim(Request.Form("strMostraTurma"))
	strSiglaTurmaPeriodo	= Trim(Request.Form("cmbSiglaTurmaPeriodo"))

	strFiltroSerie 			= "0"
	strFiltroTurno 			= "0"

	if intCodCurso 		= "" then intCodCurso 		= "0"
	if intCodSerie 		= "" then intCodSerie 		= "0"
	if intCodTurno 		= "" then intCodTurno 		= "0"
	if intCodTurma 		= "" then intCodTurma 		= "0"

	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	strbotaoAtualizar		= "S"
	
	'regra ano / semestre destino
	if strSemestre = "1" then
		intAnoLetivo = Session("strAnoLetivo")
		intSemestreDestino	 = 2
		strDesSemestre = "2º Semestre"
	elseif strSemestre = "2" then
		intAnoLetivo = Session("strAnoLetivo")+1
		intSemestreDestino	 = 1
		strDesSemestre = "1º Semestre"
	elseif strSemestre = "3" then
		intAnoLetivo = Session("strAnoLetivo")+1
		intSemestreDestino	= 3
		strDesSemestre = "Anual"
	end if

%>
<form method="post" id="frm" action="TurmaAutomatica_cad.asp">
<input name="strMostraTurma" value="S" type="hidden">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td  align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
		<tr valign="top">
		  <td align="center">
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
    <tr> 
      <td width="21%" height="12"><span class="texto1"><strong>Dados Atuais </strong></span></td>
      <td width="79%" colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td class="texto1">Curso: </td>
      <td class="texto1"><!--#include file="../includes/inc_cmdCurso.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Regime:</td>
      <td colspan="2"><span class="texto1">
        <!--#include file="../includes/inc_cmdSemestreTodos.asp"-->
      </span></td>
    </tr>
    <tr>
      <td class="texto1">Incluir Turmas Iniciais? Informe:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdSiglaTurmaPeriodo.asp"--></td>
    </tr>
    <tr>
      <td class="texto1"><strong>Dados de Destino </strong></td>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td class="texto1">Ano Letivo:</td>
      <td colspan="2"><input readonly  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo"  value="<%=intAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
    </tr>
    <tr>
      <td class="texto1">Semestre:</td>
      <td colspan="2"><input readonly name="txtSemestre" type="text" class="text" id="txtSemestre"  value="<%=strDesSemestre%>" size="20" maxlength="20" onKeyPress="return formataCampo(this,2,10)">
	  <input name="cmbSemestrePromocao" type="hidden" id="cmbSemestrePromocao"  value="<%=intSemestreDestino%>"></td>
    </tr>
    <tr> 
      <td class="texto1">&nbsp;</td>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="3"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr> 
      <td colspan="3"><!--#include file="../../includes/inc_botoes_cad_con.asp"--></td>
    </tr>
    <tr> 
      <td colspan="3" class="texto1"> <br> 
	  <%
			if strMostraTurma = "S" then%> 
			
			<table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
          <tr class="CabecalhoConsulta"> 
            <td width="19" align="center" class="celula"><input type="checkbox" name="chkTodos" onClick="return MarcaTodos(this.checked)"></td>
            <td width="64" class="celula"><strong>C&oacute;digo</strong></td>
            <td width="110" class="celula"><strong>Turma</strong></td>
            <td width="326" class="celula"><strong>Curso</strong></td>
            <td width="103" class="celula"><strong>Per&iacute;odo</strong></td>
            <td width="114" class="celula"><strong>Semestre</strong></td>
            <td width="197" class="celula"><strong>Turno</strong></td>
          </tr>
          <%					
			sql = "SELECT "
			sql = sql & " 	T.cod_turma,"
			sql = sql & " 	T.NomeTurma,"
			sql = sql & " 	P.Descricao AS PERIODO,"
			sql = sql & " 	C.Descricao as CURSO,"
			sql = sql & " 	TU.Desc_Turno AS TURNO,"
			sql = sql & " 	T.Cod_Semestre"
			sql = sql & " FROM SCA_TURMA T"
			sql = sql & " INNER JOIN SCA_GradeCurricular GC ON GC.COD_EMPRESA = T.COD_EMPRESA "
			sql = sql & " AND GC.Cod_GradeCurricular = T.Cod_GradeCurricular"
			sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_EMPRESA = GC.COD_EMPRESA "
			sql = sql & " AND P.Cod_Periodo = GC.Cod_Periodo"
			sql = sql & " INNER JOIN SCA_CURSO C ON C.COD_EMPRESA = GC.COD_EMPRESA "
			sql = sql & " AND C.Cod_curso = P.Cod_curso AND C.SITUACAO = 'A'"
			sql = sql & " INNER JOIN SCA_TURNO TU ON TU.COD_EMPRESA = T.COD_EMPRESA "
			sql = sql & " AND T.Cod_Turno = TU.Cod_Turno"
			sql = sql & " WHERE T.COD_EMPRESA = " & session("CodEmpresa")
			sql = sql & " AND T.AnoLetivo = " & strAnoLetivo
			sql = sql & " AND T.Cod_Semestre = " & strSemestre
			if intCodCurso <> "0" then
				sql = sql & " AND P.Cod_curso = " & intCodCurso
			end if
			sql = sql & " Order By C.Descricao,P.Descricao,TU.Desc_Turno"
			rs.open sql, cnn
			if rs.eof = false then
				selecionado = "checked"
				while not rs.eof
					%>
          <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
            <td class="celula" align="center"><input type="checkbox" id="chkTurma" name="chkTurma" value="<%=rs("cod_turma")%>"></td>
            <td class="celula"><%=rs("cod_turma")%></td>
            <td class="celula"><%=rs("NomeTurma")%>&nbsp;</td>
            <td class="celula"><%=rs("CURSO")%></td>
            <td class="celula"><%=rs("PERIODO")%></td>
            <td class="celula"><%=rs("COD_SEMESTRE")%>º.</td>
            <td class="celula"><%=rs("TURNO")%></td>
          </tr>
          <%			selecionado = ""
						rs.movenext
					wend
				else
					%>
					  <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
						<td colspan="7" align="center" class="celula"><%=session("strMensagemRelatorioNaoEncontrado")%></td>
					  </tr>
					  <%
					end if
					rs.close
			end if
					%>
        </table><br></td>
    </tr>
  </table>
  		  </td>
		</tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>