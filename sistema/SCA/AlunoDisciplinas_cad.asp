<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 02/03/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Grade Disciplina
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

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script></head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif','<%=session("strCaminhoRaiz")%>/images/botao_vermelho_over.gif')">
<iframe name="iframeAlunoDisciplina" height="0" width="0"></iframe>	
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<script>
	
	function resultadoConsulta(intCodigo){
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function ExcluirDisciplina(){
		var form = window.document.forms[0];
		var intContMarcado=0;
		
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "checkbox"){
				if (form.elements[i].name == "cod_excluirDisc"){
					//verifica se o checkbox está marcado
					if (form.elements[i].checked){
						intContMarcado = intContMarcado + 1;
					}
				}
			}
		}
		
		if (intContMarcado==0){
			alert("As grades disciplinas devem ser selecionadas!");
			return false;
		}		
		
		var men = 'ATENCAO: \nA(s) disciplina(s) selecionada(s) sera(ao) excluida(s), deseja continuar?';
		if (confirm(men)) {
			frm.action = "AlunoDisciplinas_cod.asp?acao=ED";
			frm.submit();
			return true;	
		}
	}

	function gerarImpressao(){
		frm.action = "Rel_GradeDisciplinar.asp?codigo=" + frm.txtCodAluno.value;
		frm.submit();
		return true;	
	}

	function salvar(acao){
		
		if (frm.txtMatricula.value == "") {
			alert("A matrícula do aluno deve ser informada !");
			frm.txtMatricula.focus();
			return false;
		}
	
		if (frm.cmbDisciplinaGrade.value == "0") {
			alert("A Disciplina deve ser informada !");
			frm.cmbDisciplinaGrade.focus();
			return false;
		}
		
		if (frm.cmbTurmaGradeRemanejamento.value == "0") {
			alert("A Turma deve ser informada !");
			frm.cmbTurmaGradeRemanejamento.focus();
			return false;
		}
		
		
		if (frm.cmbSituacaoDisciplina.value == "0") {
			alert("A Situação deve ser informada !");
			frm.cmbSituacaoDisciplina.focus();
			return false;
		}
		
		
		if (frm.cmbTurmaRem.value == "0") {
			alert("A Turma Remanejamento deve ser informada !");
			frm.cmbTurmaRem.focus();
			return false;
		}
		
		if (frm.cmbDisciplinaRemanejamento.value == "0") {
			alert("A Disciplina Remanejamento deve ser informada !");
			frm.cmbDisciplinaRemanejamento.focus();
			return false;
		}
		
		frm.action="AlunoDisciplinas_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
		
	function NotasFaltas(intCodigo) {
		window.open("EditarNotasFaltas_con.asp?cod_aluno="+intCodigo,"cadAltr", "top=0,left=0,height=450,width=750,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		return true;
	}
</script>
<%



	strPaginaTitulo 			= "AlunoDisciplinas_cad.asp"
	strPagina					= "AlunoDisciplinas_cad.asp"
	
	if  Trim(Request("txtMatricula")) <> "" then
		strMostraBotaoImprimir	= "S"
	end if	
	strExecutarSubmitCurso	  			= "S"
	strExecutarSubmitPeriodo  			= "S"
	strExecutarSubmitTurno	  			= "S"
	strExecutarSubmitSemestre 			= "S"
	strExecutarSubmitTurma	  			= "S"
	strExecutarSubmitSitDisciplina      = "S"
	strReloadDisciplinaRem				= "S"
	strExecutarSubmitGradeCurricular 	= "S"
	strExecutarDisciplinaGrade 			= "S"
	strExecutarSubmitSituacaoPromocaoSemCriterio = "S"
	strBotaoEcluirDiscGradeAluno = ""	
	
	' Consulta a Categoria Colaborador
	sql = "select codigo "
	sql = sql & " from SRH_COLABORADOR"
	sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
	sql = sql & " and CodCategoria = 1 "'professor
	sql = sql & " and Situacao = 'A'" 'Ativo
	rs.open sql, cnn
	if rs.EOF = false then	
		strVerificaTipolancamento = "Professor"
	else
		strVerificaTipolancamento = ""
	end if
	rs.close
	
	intCodigo = Trim(Request.Form("txtCodigo"))
	
	if  session("NivelPermissao") <> "A" then
		strSemestre 						= session("strSemestre")
		intSemestre 						= session("strSemestre")
		strAnoLetivo 						= session("strAnoLetivo")
	else
		intSemestre 						= Trim(Request.Form("cmbSemestre"))
		strSemestre 						= Trim(Request.Form("cmbSemestre"))
		strAnoLetivo 						= Trim(Request.Form("txtAnoLetivo"))
	end if	
	if strSemestre = "" then strSemestre = session("strSemestre")
	if intSemestre = "" then intSemestre = session("strSemestre")
	if strAnoLetivo = "" then strAnoLetivo = session("strAnoLetivo")
	
	strCodAluno							= Trim(Request("txtCodAluno"))
	strMatricula 						= Trim(Request("txtMatricula"))
	strNomealuno 						= Trim(Request("txtNomealuno"))

	intCodCurso	 						= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 						= Trim(Request.Form("cmbPeriodo"))
	intCodGrade 						= Trim(Request.Form("cmbGrade"))
	
	intCodDisciplinaGrade				= Trim(Request.Form("cmbDisciplinaGrade"))
	strFiltraTurmasGrade				= Trim(Request("txtFiltraTurmasGrade"))
	intCodTurmaGradeRemanejamento   	= Trim(Request.Form("cmbTurmaGradeRemanejamento"))
	strSituacaoDisciplina 				= Trim(Request.Form("cmbSituacaoDisciplina"))
    strSituacaoPromocao 				= Trim(Request("cmbSituacaoPromocao"))
	strSituacaoPromocaoTodos			= Trim(Request("txtSituacaoPromocaoTodos"))

	intCodTurmaRemejamento				= Trim(Request.Form("cmbTurmaRem"))
	intCodGradeRemanejamento			= Trim(Request.Form("cmbGradeRemanejada"))
	intCodDisciplinaRemanejamento 		= Trim(Request.Form("cmbDisciplinaRemanejamento"))

	if intCodCurso 		= "" then intCodCurso 		= "0"
	if intCodSerie 		= "" then intCodSerie 		= "0"
	if intCodTurno 		= "" then intCodTurno 		= "0"
	if intCodTurma 		= "" then intCodTurma 		= "0"
	if intCodGradeRemanejamento = "" then intCodGradeRemanejamento 		= "0"
	
	if intCodTurmaRemejamento 	= "" then intCodTurmaRemejamento 		= "0"
	if intCodDisciplinaRemanejamento = "" then intCodDisciplinaRemanejamento 		= "0"
	
	strMostraAlunos = ""

	strBloqueiaInclusaoDisciplinar = ""
	sql = " SELECT top 1 isnull(Limite_Inclusao_Disciplinar,'99') as Limite_Inclusao_Disciplinar "
	sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES "
	sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
	rs.Open SQL, cnn
	if rs.EOF = false then								
		strLimiteInclusaoDisciplinar  = trim(rs("Limite_Inclusao_Disciplinar"))
	end if
	rs.close

	strMsgExisteHorario  	= ""
	strFlagExisteHorario 	= "S"
	sql = " SELECT TOP 1 CODIGO FROM SCA_HORARIO_AULA "  
	sql = sql & " WHERE AnoLetivo = " & strAnoLetivo  
	sql = sql & " AND Semestre = " & intSemestre  
	rs.Open SQL, cnn
	if rs.EOF = false then
	else								
		strMsgExisteHorario  	= " - Hor&aacute;rio n&atilde;o cadastrado para o ano e semestre informado."
		strFlagExisteHorario 	= "N"
	end if
	rs.close


 	strSituacaoAluno = ""
	if strMatricula <> "" then
		
		sql = " SELECT TOP 1"
		sql = sql & " A.CODIGO,"	
		sql = sql & " A.MATRICULA,"	
		sql = sql & " A.NOMEALUNO,"
		sql = sql & " C.Cod_curso,"
		sql = sql & " C.DESCRICAO AS CURSO,"
		sql = sql & " C.SIGLA,"
		sql = sql & " C.Gerenciar_Acompanhamento,"
		sql = sql & " P.DESCRICAO AS PERIODO,"
		sql = sql & " AT.COD_TURMA AS TURMA_ATUAL, T.COD_TURNO AS TURNO_ATUAL, T.cod_gradecurricular, P.Cod_Periodo, C.Tipo_Modulacao,"
		sql = sql & " T.cod_planopagamento AS PlanoPagamento, SA.Desc_SituacaoAluno"
		sql = sql & " FROM SCA_ALUNO A"
		sql = sql & " LEFT JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND A.COD_EMPRESA = SA.COD_EMPRESA"
		sql = sql & " LEFT JOIN SCA_ALUNO_TURMA AT ON AT.COD_ALUNO = A.CODIGO AND A.COD_EMPRESA = AT.COD_EMPRESA"
		sql = sql & " LEFT JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA"
		sql = sql & " LEFT JOIN SCA_GRADECURRICULAR GC ON GC.COD_GRADECURRICULAR = T.COD_GRADECURRICULAR AND T.COD_EMPRESA = GC.COD_EMPRESA"
		sql = sql & " LEFT JOIN SCA_PERIODO P ON GC.COD_PERIODO = P.COD_PERIODO AND P.COD_EMPRESA = GC.COD_EMPRESA"
		sql = sql & " LEFT JOIN SCA_CURSO C ON C.COD_CURSO = P.COD_CURSO AND C.COD_EMPRESA = P.COD_EMPRESA"
		sql = sql & " LEFT JOIN SCA_GRAU G ON G.COD_GRAU = C.COD_GRAU AND G.COD_EMPRESA = C.COD_EMPRESA"
		sql = sql & " LEFT JOIN SCF_PLANO PL ON PL.CODIGO = T.Cod_PlanoPagamento AND PL.COD_EMPRESA = T.COD_EMPRESA "
		sql = sql & " LEFT JOIN SCF_UF UF ON UF.CODIGO = A.UFRESIDENCIA"
		sql = sql & " LEFT JOIN SCF_UF UFI ON UFI.CODIGO = A.IDENTIDADEUF"
		sql = sql & " WHERE A.MATRICULA = " & strMatricula
		sql = sql & " AND A.cod_empresa = " & Session("CodEmpresa")	
		sql = sql & " Order BY AT.CODIGO DESC "
		rs.open sql, cnn
		
		if rs.eof = false then
			strCodAluno						= Trim(rs("CODIGO"))
			strMatricula 					= Trim(rs("Matricula"))
			strNomealuno 					= Trim(rs("Nomealuno"))
			''intCodCurso 					= Trim(rs("Cod_curso"))
			strGerenciarAcompanhamento 		= Trim(rs("Gerenciar_Acompanhamento"))
			intTurmaAtual       			= Trim(rs("TURMA_ATUAL"))
			intTurnoAtual       			= Trim(rs("TURNO_ATUAL"))
			intPlanoPagamento   			= Trim(rs("PlanoPagamento"))
			strTipoModulacao				= trim(rs("Tipo_Modulacao"))
			strSituacaoAluno				= TRIM(rs("Desc_SituacaoAluno"))
			'intCodGrade			 	= Trim(rs("cod_gradecurricular"))
			''intCodPeriodo	    	= Trim(rs("Cod_Periodo"))	
			strBotaoEcluirDiscGradeAluno = "S"	
		end if
		rs.close	
		
	end if

	if strCodAluno <> "" and intCodDisciplinaGrade <> "" then
		sql = "SELECT HD.SITUACAO"
		sql = sql & " FROM SCA_HISTORICO_ESCOLAR H"
		sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR_DISCIPLINA HD ON HD.cod_historico_escolar = H.CODIGO"
		sql = sql & " WHERE	H.COD_ALUNO = " & strCodAluno
		sql = sql & " AND	HD.COD_DISCIPLINA = " & intCodDisciplinaGrade			
		sql = sql & " AND	( HD.SITUACAO = 'AP' OR	HD.SITUACAO = 'DI' OR HD.SITUACAO = 'AC' )"		
		sql = sql & " AND	H.COD_EMPRESA = " & Session("CodEmpresa")	
		Rs1.open sql, cnn,3,3
		if not Rs1.EOF then				
			%>
			<script>
				//alert("Disciplina Integralizada! Verifique.");
			</script>
			<%
			''strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			''strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			''strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		end if
		rs1.close

		sql = " Select codigo "
		sql = sql & " From sca_aluno_disciplina ad " 
		sql = sql & " left join sca_gradecurriculardisciplina gcd on gcd.Cod_GradeCurricularDisciplina = ad.COD_GRADECURRICULARDISCIPLINA "  
		sql = sql & " where ad.COD_ALUNO = " & strCodAluno
		sql = sql & " and gcd.Cod_Disciplina = " & intCodDisciplinaGrade	
		Rs1.open sql, cnn,3,3
		if not Rs1.EOF then				
			%>
			<script>
				alert("Disciplina Selecionada! Verifique.");
			</script>
			<%
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		else
		    rs1.close
			sql = " Select codigo "
			sql = sql & " From sca_aluno_disciplina ad " 
			sql = sql & " left join sca_gradecurriculardisciplina gcd on gcd.Cod_GradeCurricularDisciplina = ad.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO "  
			sql = sql & " where ad.COD_ALUNO = " & strCodAluno
			sql = sql & " and gcd.Cod_Disciplina = " & intCodDisciplinaGrade	
			Rs1.open sql, cnn,3,3
			if not Rs1.EOF then				
				%>
				<script>
					alert("Disciplina Selecionada para um Remanejamento! Verifique.");
				</script>
				<%
				strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
				strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
				strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
			end if

		end if
		rs1.close
		
	end if
		
	
	if trim(intCodigo) <> "" then
		
		sql = " SELECT AL.COD_EMPRESA, AL.COD_ALUNO, AL.COD_TURMA, AL.COD_TURMA_REMANEJAMENTO, "
		sql = sql & " AL.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO, AL.COD_SITUACAO_ACADEMICA,"
		sql = sql & " AL.COD_GRADECURRICULARDISCIPLINA, AL.SITUACAO, "
		sql = sql & " P.Cod_Periodo, GC.Cod_GradeCurricular, "
		sql = sql & " GCD.Cod_Disciplina, GCD1.Cod_Disciplina as DisciplinaRemanejamento "
		sql = sql & " FROM SCA_ALUNO_DISCIPLINA AL "
		sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AL.COD_TURMA AND T.COD_EMPRESA = AL.COD_EMPRESA"
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.COD_GRADECURRICULAR = T.COD_GRADECURRICULAR AND T.COD_EMPRESA = GC.COD_EMPRESA"
		sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO = GC.COD_PERIODO "
		sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricularDISCIPLINA = AL.COD_GRADECURRICULARDISCIPLINA"
		sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD1 ON GCD1.Cod_GradeCurricularDISCIPLINA = AL.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO"

		sql = sql & " where AL.cod_empresa = " & Session("CodEmpresa")	
		sql = sql & " and AL.CODIGO = " & intCodigo
			response.write sql
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodGrade										= rs("Cod_GradeCurricular")
			intCodPeriodo									= rs("Cod_Periodo")
			intCodTurmaGradeRemanejamento					= rs("COD_TURMA")
			strSituacaoDisciplina							= rs("SITUACAO")
			intCodDisciplinaGrade							= rs("Cod_Disciplina")
			
			if strTipoModulacao = "P" then
				if intCodDisciplinaRemanejamento = "0" or intCodDisciplinaRemanejamento = "" then
					intCodDisciplinaRemanejamento						= rs("DisciplinaRemanejamento")
				end if
		
				if intCodTurmaRemejamento = "0" or intCodTurmaRemejamento = "" then
					intCodTurmaRemejamento					= rs("COD_TURMA_REMANEJAMENTO")
				end if
			else
				intCodDisciplinaRemanejamento				= rs("DisciplinaRemanejamento")
				intCodTurmaRemejamento						= rs("COD_TURMA_REMANEJAMENTO")

				if strSituacaoPromocao = "0" or strSituacaoPromocao = "" then
					strSituacaoPromocao					= rs("COD_TURMA_REMANEJAMENTO")
				end if

			end if	

			strCodGradeCurricularDisciplina					= rs("COD_GRADECURRICULARDISCIPLINA")
			strCodGradeCurricularDisciplinaRemanejamento	= rs("COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO")
			
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

		end if 
		rs.close
		
	else
	
		'controla os botões
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if
	
	if strMatricula <> "" then
		if strSituacaoAluno <> "ATIVO" then
			%>
			<script>
				alert("Situacao Academica nao Permitida, verifique se o mesmo esteja ATIVO.");
			</script>
			<%
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		end if
	end if
	
	if intCodTurmaRemejamento = "0" then intCodTurmaRemejamento = intCodTurmaGradeRemanejamento
	if intCodDisciplinaRemanejamento = "0" then intCodDisciplinaRemanejamento = intCodDisciplinaGrade
	
	if intCodTurmaOrigem = "0" then intCodTurmaOrigem = intCodTurmaGradeRemanejamento
	if strNomeTurmaOrigem = "0" then strNomeTurmaOrigem = strNomeTurma
	
	if trim(intSemestre) = "" or  trim(intSemestre) = "0"  then intSemestre  = session("strSemestre")
	%>
	<form method="post" id="frm" action="#">
  	<table width="100%" border="0" align="center" cellpadding="0" cellspacing="2" bgcolor="#FFFFFF">
    <tr>
      <td height="17" colspan="3" align="center" class="texto1"><span class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></span></td>
    </tr>
    <tr>
      <td height="17" colspan="3" bgcolor="#CCCCCC" class="texto1"><strong>Dados Aluno</strong></td>
    </tr>
    <tr>
      <td colspan="3" class="texto1"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">&nbsp;</td>
    </tr>
    <tr>
      <td width="18%" class="texto1">Ano Letivo:</td>
      <td width="52%"><span class="texto1">
        <input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
      </span></td>
      <td width="30%"><%if session("UsuarioMaster") = "S" and strCodAluno <> "" then %><input type="button" name="cmdNotasFaltas" style="cursor:hand"   value="  Arquivo de Notas  " class="botao" onClick="return NotasFaltas('<%=strCodAluno%>')"><% end if%></td>
    </tr>
    <tr>
      <td class="texto1">Semestre:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
    </tr>
    <tr>
      <td class="texto1">Matr&iacute;cula:</td>
      <td colspan="2"><input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="10" value="<%=strCodAluno%>" maxlength="10"><span class="texto1">
        <input name="txtMatricula" type="text" class="text" id="txtMatricula" size="20" maxlength="20" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 11)" onBlur="submit()">
        <a  href="#" onClick="return abreConsulta('Aluno_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a></span><input readonly name="txtNomealuno" type="text" class="textDesabilita" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>" ></td>
    </tr>
    <tr>
      <td class="texto1">Curso:</td>
      <td colspan="2"><span class="texto1">
      <!--#include file="../includes/inc_cmdCurso.asp"--></span></td>
    </tr>
    <tr>
      <td class="texto1">Per&iacute;odo:</td>
		<%
        if request.Form("txtHiddenStatus") <> "" then
           strDesabilitaSerie = "disabled"
        end if
        %>
      <td colspan="2"><!--#include file="../includes/inc_cmdPeriodo.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Grade:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdGradeCurricular.asp" --></td>
    </tr>
    <tr>
      <td class="texto1">Disciplina:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdDisciplinaGrade.asp" --></td>
    </tr>
     <tr>
      <td class="texto1">Situa&ccedil;&atilde;o Disciplinar:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdSituacaoDisciplina.asp"--></td>
    </tr>
    <% if strTipoModulacao = "T" then %>
         <tr>
           <td class="texto1">Situa&ccedil;&atilde;o Acad&ecirc;mica:</td>
           <td colspan="2" class="texto1"><!--#include file="../includes/inc_cmdSituacaoPromocao_SemCriterio.asp" -->
           <% if strDesabilitaAlterar = "" then %>
             - Aplicar esta situac&atilde;o para todos alunos que cursam essa disciplina?
             <input <%if trim(strSituacaoPromocaoTodos) = "S" then response.Write("checked")%>  type="checkbox" name="txtSituacaoPromocaoTodos" value="S" onClick="submit()">
             <% end if%>
             - Opcional</td>
         </tr>
    <% end if %>     
     <tr>
      <td class="texto1">Turma - Dispon&iacute;vel no Hor&aacute;rio:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdTurmaGradeRemanejamento.asp"-->
        <span class="texto1"> - Listar Todas as Turmas?
        <input <%if trim(strFiltraTurmasGrade) = "S" then response.Write("checked")%>  type="checkbox" name="txtFiltraTurmasGrade" value="S" onClick="submit()"> <%=strMsgExisteHorario%>        </span></td>
    </tr>
    <tr>
      <td class="texto1">&nbsp;</td>
      <td colspan="2">
        <input  name="txtCodGrade" type="hidden" class="text" id="txtCodGrade"   value="<%=strCodGradeCurricularDisciplina%>" size="10" maxlength="10" ></td>
    </tr>
    <tr>
      <td height="16" colspan="3" bgcolor="#CCCCCC" class="texto1"><strong>Dados Remanejamento - ( Opcional )</strong></td>
    </tr>
    <tr>
      <td height="19" class="texto1"><strong>Remanejamento - Turmas no Hor&aacute;rio:</strong></td>
      <td colspan="2"><!--#include file="../includes/inc_cmdTurmaRem.asp"--></td>
    </tr>
    <tr>
      <td class="texto1"><strong>Matriz Curricular:</strong></td>
      <td colspan="2"><!--#include file="../includes/inc_cmdGradeCurricularRemanejada.asp" --></td>
    </tr>
    <tr>
      <td class="texto1"><strong>Disciplina Remanejada:</strong></td>
      <td colspan="2"><!--#include file="../includes/inc_cmbDisciplinaRemanejada.asp"-->
      <input  name="txtCodGradeRemanejamento" type="hidden" class="text" id="txtCodGradeRemanejamento"   value="<%=strCodGradeCurricularDisciplinaRemanejamento%>" size="10" maxlength="10" ></td>
    </tr>
    
    
    <tr> 
      <td colspan="3"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr>
      <td colspan="3" class="texto1">
	  <%
			if strCodAluno <> "" then
			 
			    if strGerenciarAcompanhamento = "A" then
			
					if intPlanoPagamento <> "" then 
						sql = " select top 1 valor1, valor2, valor3, valor4 from scf_planoparcela "
						sql = sql & " where cod_plano = " & intPlanoPagamento
						sql = sql & " and ano = " & strAnoLetivo
						sql = sql & " and CodSemestre = " & intSemestre
						sql = sql & " order by Ano, parcela desc "
						rs.open sql, cnn
						if rs.eof = false then
							ValorApagar1 = Trim(rs("valor1"))
							if ValorApagar1 = "" or isnull(ValorApagar1) then ValorApagar1 = "0"
						end if   
						rs.close
					else	
						ValorApagar1 ="0"
					end if	
	
					sql = " Select sum(ch_horas) as CH_Aluno, Count(ch_horas) as TotalDisciplina_ALuno "
					sql = sql & " From sca_aluno_disciplina ad "
					sql = sql & " left join sca_gradecurriculardisciplina gcd on gcd.Cod_GradeCurricularDisciplina = ad.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO "
					sql = sql & " where ad.cod_aluno = " & strCodAluno
					sql = sql & " and ad.situacao <> 'AD'"
					rs.open sql, cnn		
					if not rs.eof then
						intCHAluno 				=  rs("CH_Aluno")
						intTotalDisciplinaALuno	=  rs("TotalDisciplina_ALuno")
						if isnull(intCHAluno) then intCHAluno = 0
						if isnull(intTotalDisciplinaALuno) then intTotalDisciplinaALuno = 0
					end if			
					rs.close
	
					sql = " SELECT sum(ch_horas) as CH_Matriz, Count(ch_horas) as TotalDisciplina_Matriz "
					sql = sql & " FROM SCA_TURMA T "
					sql = sql & " LEFT JOIN SCA_GRADECURRICULAR GC ON GC.COD_GRADECURRICULAR = T.COD_GRADECURRICULAR "
					sql = sql & " LEFT JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular and GC.Situacao='A' "
					sql = sql & " WHERE Cod_Turma = " & intTurmaAtual
					rs.open sql, cnn		
					if not rs.eof then
						intCHMatriz 		    	=  rs("CH_Matriz")
						intTotalDisciplinaMatriz	=  rs("TotalDisciplina_Matriz")
						if isnull(intCHMatriz) then intCHMatriz = 0
						if isnull(intTotalDisciplinaMatriz) then intTotalDisciplinaMatriz = 0
					end if			
					rs.close
					
					if Session("NivelPermissao") <> "A" then
	
						if intTotalDisciplinaALuno > strLimiteInclusaoDisciplinar then
							%>
							<script>
								alert("Foi atingido o numero máximo de inclusões, procure a Secretaria Geral.");
							</script>
							<%
							strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
							strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
							strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
						end if

					end if	
	
					TotalInclusoes = 0
					ValorAcrescimo = 0
					ValorFinal = 0
					if intCHAluno > intCHMatriz then TotalInclusoes = 1
					if intTotalDisciplinaALuno >  intTotalDisciplinaMatriz then 
					   TotalInclusoes = intTotalDisciplinaALuno - intTotalDisciplinaMatriz
					end if 
					if intCHAluno <= intCHMatriz then TotalInclusoes = 0  
					ValorAcrescimo = ((ValorApagar1 * 25 ) / 100) * TotalInclusoes
					ValorFinal = ValorAcrescimo + ValorApagar1

				else
				
					if intPlanoPagamento <> "" then 

				        ' Primeiro Valor do Aluno
						ValorApagar1 = "0"
						sql = " select top 1 valor1, valor2, valor3, valor4 from scf_planoparcela "
						sql = sql & " where cod_plano = " & intPlanoPagamento
						sql = sql & " and ano = " & strAnoLetivo
						sql = sql & " and CodSemestre = " & intSemestre
						sql = sql & " order by Ano, parcela desc "
						rs.open sql, cnn
						if rs.eof = false then
							ValorApagar1 = Trim(rs("valor1"))
							if ValorApagar1 = "" or isnull(ValorApagar1) then ValorApagar1 = "0"
						end if   
						rs.close

					    ' Base de Calculo para achar hora aula - Valor bruto
						ValorApagarBruto = "0"
						sql = " select top 1 valor1, valor2, valor3, valor4 from scf_planoparcela "
						sql = sql & " where cod_plano = " & intPlanoPagamento
						sql = sql & " and ano = " & strAnoLetivo
						sql = sql & " and CodSemestre = " & intSemestre
						sql = sql & " order by Ano, parcela desc "
						rs.open sql, cnn
						if rs.eof = false then
						    ValorApagarBruto = Trim(rs("valor4"))
						    if isnull(rs("valor4")) or rs("valor4") = "" then ValorApagarBruto = Trim(rs("valor3"))
						    if isnull(rs("valor3")) or rs("valor3") = "" then ValorApagarBruto = Trim(rs("valor2"))
						    if isnull(rs("valor2")) or rs("valor2") = "" then ValorApagarBruto = Trim(rs("valor1"))
							if ValorApagarBruto = "" or isnull(ValorApagarBruto) then ValorApagarBruto = "0"
							
							ValorApagarBruto = Trim(rs("valor1"))
							
						end if   
						rs.close

					end if	
	
					sql = " Select sum(ch_horas) as CH_Aluno, Count(ch_horas) as TotalDisciplina_ALuno "
					sql = sql & " From sca_aluno_disciplina ad "
					sql = sql & " left join sca_gradecurriculardisciplina gcd on gcd.Cod_GradeCurricularDisciplina = ad.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO "
					sql = sql & " where ad.cod_aluno = " & strCodAluno
					sql = sql & " and ad.situacao <> 'AD'"
					rs.open sql, cnn		
					if not rs.eof then
						intCHAluno 				=  rs("CH_Aluno")
						intTotalDisciplinaALuno	=  rs("TotalDisciplina_ALuno")
						if isnull(intCHAluno) then intCHAluno = 0
						if isnull(intTotalDisciplinaALuno) then intTotalDisciplinaALuno = 0
					end if			
					rs.close
	
					sql = " SELECT sum(ch_horas) as CH_Matriz, Count(ch_horas) as TotalDisciplina_Matriz "
					sql = sql & " FROM SCA_TURMA T "
					sql = sql & " LEFT JOIN SCA_GRADECURRICULAR GC ON GC.COD_GRADECURRICULAR = T.COD_GRADECURRICULAR "
					sql = sql & " LEFT JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricular = GC.Cod_GradeCurricular and GC.Situacao='A' "
					sql = sql & " WHERE Cod_Turma = " & intTurmaAtual
					rs.open sql, cnn		
					if not rs.eof then
						intCHMatriz 		    	=  rs("CH_Matriz")
						intTotalDisciplinaMatriz	=  rs("TotalDisciplina_Matriz")
						if isnull(intCHMatriz) then intCHMatriz = 0
						if isnull(intTotalDisciplinaMatriz) then intTotalDisciplinaMatriz = 0
					end if			
					rs.close
	
					if intTotalDisciplinaALuno > (intTotalDisciplinaMatriz + strLimiteInclusaoDisciplinar)  then
						%>
						<script>
							alert("Foi atingido o numero maximo de inclusoes, procure a Secretaria Geral.");
						</script>
						<%
						
						strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
						strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
						strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

					end if
					
					TotalInclusoes = 0
					ValorAcrescimo = 0
					ValorFinal = 0

					if intCHAluno > intCHMatriz then
					   if intCHMatriz > 0 then 
					   	  ValorAcrescimo = (ValorApagarBruto/intCHMatriz) * (intCHAluno - intCHMatriz)
					   else
					      ValorAcrescimo = 0
					   end if 
					   ValorFinal = ValorAcrescimo + ValorApagar1
					else
					   ValorFinal = ValorApagar1
					end if

				end if	

				sql = " Select ad.COD_TURMA_REMANEJAMENTO, ad.codigo, gcd.CH_horas,"
				sql = sql & " ad.cod_disciplina, ad.situacao, sp.DESCRICAO, "
				sql = sql & " d.desc_disciplina, gc.cod_periodo as Periodo_Disciplina, "
				sql = sql & " dr.desc_disciplina as desc_disciplinaRema ,"
				sql = sql & " t.cod_semestre, t.AnoLetivo, t.nometurma, t.cod_gradecurricular, "
				sql = sql & " tr.nometurma as nometurmaRema "
				sql = sql & " From sca_aluno_disciplina ad "
				sql = sql & " left join sca_disciplina d on d.cod_disciplina = ad.cod_disciplina "
				sql = sql & " left join sca_gradecurriculardisciplina gcd on gcd.Cod_GradeCurricularDisciplina = ad.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO "
				sql = sql & " left join sca_gradecurricular gc on gc.Cod_GradeCurricular = gcd.Cod_GradeCurricular "
				sql = sql & " left join sca_disciplina dr on dr.cod_disciplina = gcd.Cod_Disciplina "
				sql = sql & " left join sca_turma t on t.cod_turma = ad.cod_turma "
				sql = sql & " left join sca_turma tr on tr.cod_turma = ad.COD_TURMA_REMANEJAMENTO "
				sql = sql & " left join SCA_PERIODO p ON p.Cod_Periodo = gc.Cod_Periodo"
				sql = sql & " left join SCA_SITUACAO_PROMOCAO sp ON sp.CODIGO = ad.COD_SITUACAO_ACADEMICA"
				sql = sql & " where	ad.cod_aluno = " & strCodAluno
				sql = sql & " order by p.sequencia, d.desc_disciplina"
				rs.open sql, cnn		
				if not rs.eof then
					
					%>
        	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" class="tabela" >
                <tr bgcolor="#D3D3D3">
                <td height="19" colspan="12" align="center" class="celula"><strong>Disciplinas Dispon&iacute;veis para o Aluno </strong></td>
          	</tr>
          	<tr bgcolor="#D3D3D3">
                <td width="2%" class="celula">&nbsp;</td>
                <td width="8%" align="center" class="celula"><strong>Turma Curricular</strong></td>
                <td width="9%" class="celula"><div align="center"><strong>Grade</strong></div></td>
                <td width="11%" class="celula"><strong>Disciplina</strong></td>
                <td width="11%" class="celula"><strong>Turma Remanejamento</strong></td>
                <td width="16%" class="celula"><strong>Disciplina Remanejamento</strong></td>
                <td width="5%" align="center" class="celula"><strong><strong>C.H horas</strong></strong></td>
                <td width="7%" align="center" class="celula"><strong>Ano Letivo</strong></td>
                <td width="7%" align="center" class="celula"><strong><strong>Semestre</strong></strong></td>
                <td width="14%" colspan="2" align="center" class="celula"><p><strong>Situa&ccedil;&atilde;o<Br>Curricular</strong></p>                </td>
          	    <td width="17%" align="center" class="celula"><strong>Situa&ccedil;&atilde;o<Br>
       	        Acad&ecirc;mica</strong></td>
          	</tr>
          	<%
				id = 0
				while not rs.eof 
				
					strSituacaoDisciplinaAbreviado 	=  rs("situacao")
					intCodAlunoDisciplina 			=  rs("codigo")
					intCodTurmaRemejamento 			=  rs("COD_TURMA_REMANEJAMENTO")
					intCodGradeCurricular 			=  rs("cod_gradecurricular")
					
					
					if trim(rs("SITUACAO")) = "CR" then 
						strSituacao = "Curricular"
					end if
					
					if trim(rs("SITUACAO")) = "DE" then 
						strSituacao = "Dep./Acompanhamento"
					end if

					if trim(rs("SITUACAO")) = "AD" then 
						strSituacao = "Adapta&ccedil;&atilde;o"
					end if
					
					if trim(rs("SITUACAO")) = "DI" then 
						strSituacao = "Dispensa"
					end if
					if trim(rs("DESCRICAO")) = "" or isnull(rs("DESCRICAO")) then 
						strDescSituacaoAluno = "A CURSAR"
					else
						strDescSituacaoAluno =  "<font color='#FF0000'>" & rs("DESCRICAO") & "</font>"
					end if
					'
					'Parametros pra carregar Optativas
					'
					AnoLetivoMostraOptativa = strAnoLetivo
					SemestreMostraOptativa = intSemestre
					CursoMostraOptativa = trim(intCodCurso)
					PeriodoMostraOptativa = trim(rs("Periodo_Disciplina"))
					TurnoMostraOptativa = trim(intTurnoAtual)
					DisciplinaMostraOptativa = trim(rs("cod_disciplina"))    
					CodigoAlunoMostraOptativa = strCodAluno
					' Mensagem Carrega em: - (MsgOptativa)
				
					%>
					<!--#include file="../includes/inc_MostraOptativas.asp"-->
    
                      	<tr bgcolor="#F3F3F3" height="23px"  onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
                            <td class="celula" align="center"><input name="cod_excluirDisc" type="checkbox" value="<%=rs("codigo")%>"></td>
                            <td style="cursor:hand" onClick="return resultadoConsulta('<%=rs("codigo")%>')" class="celula"><strong><%=rs("nometurma")%>&nbsp;</strong></td>
                            <td class="celula"><div align="center"><strong><strong><%=rs("cod_gradecurricular")%></strong></strong></div></td>
                            <td class="celula"><strong><%=rs("DESC_Disciplina")%>&nbsp;<font color='#FF0000'><strong><%=MsgOptativa%></strong></font></strong></td>
                          <td class="celula"><%=rs("nometurmaRema")%></td>
                            <td class="celula"><strong>&nbsp;</strong><%=rs("desc_disciplinaRema")%></td>
                            <td class="celula" align="center"><strong><strong><%=rs("CH_Horas")%></strong></strong></td>
                            <td class="celula" align="center"><strong><strong><%=rs("anoletivo")%></strong>&nbsp;</strong></td>
                            <td class="celula" align="center"><strong>&nbsp;<strong><%=rs("cod_semestre")%></strong></strong></td>
                            <td colspan="2" align="center" class="celula"><%=strSituacao%>&nbsp;</td>
                      	    <td align="center" class="celula"><%=strDescSituacaoAluno%>&nbsp;</td>
                      	</tr>
          			<%
					id = id + 1
					rs.movenext
				wend 
			end if			
			rs.close
			%>
      </table>
        <%end if%>
    <tr> 
      <td colspan="3"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
    </tr>
        <td colspan="3" class="texto1">      
    </table>
	</td>
    </tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>