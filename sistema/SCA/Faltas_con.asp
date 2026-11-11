<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>

<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 27/11/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Notas
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
<script type="text/javascript">
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
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif','../../images/botao_baixa_over.gif')">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<!--#include file="../../js/Calendario/Calendario.asp"-->
<script>
	
	function AbreFecha(Linha,Figura){
		if (Linha.style.display == "block"){
			Linha.style.display = "none";
			Figura.src="<%=session("strCaminhoRaiz")%>/images/plus.bmp"
		}
		else{
			Linha.style.display = "block";
			Figura.src="<%=session("strCaminhoRaiz")%>/images/minus.bmp"
		}
	}
	
	
	function cadastrarNotas(){
	
		var frm = document.getElementById("frm");
		var form = window.document.forms[0];
		var intContMarcado=0;
		var strAlunos='';
		var strEja='';
		
		if (frm.cmbSemestre.value == 0){
			alert("O Semestre deve ser informado!");
			frm.cmbSemestre.focus();
			return false;
		}
		
		if (frm.cmbTurma.value == 0){
			alert("A turma deve ser informada!");
			frm.cmbTurma.focus();
			return false;
		}		
		
		if (frm.cmbDisciplinaTurma.value == 0){
			alert("A disciplina deve ser informada!");
			frm.cmbDisciplinaTurma.focus();
			return false;
		}		

		if (frm.txtData.value == ""){
			alert("A data deve ser informada!");
			frm.txtData.focus();
			return false;
		}		

		//*****verifica se o chkTipoNota foi selecionado
		intContMarcado==0
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "radio"){
				if (form.elements[i].name == "chkTipoNota"){
					//verifica se o checkbox está marcado
					if (form.elements[i].checked){
						intContMarcado = intContMarcado + 1;
					}
				}
			}
		}
		
		if (intContMarcado==0){
			alert("A avaliação deve ser informada!");
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
		
		frm.action = "Faltas_cad.asp";
		frm.submit();
		return true;	
	}
	
	function ExcluirFaltas(acao, CodFalta, CodAlunoDisciplina, Faltas){
		
		var frm = document.getElementById("frm");
		var form = window.document.forms[0];
		var intContMarcado=0;
		
		if (frm.txtAnoLetivo.value == ""){
			alert("O Ano Letivo deve ser informado!")
			frm.txtAnoLetivo.focus();
			return false;
		}		
		
		if (frm.cmbSemestre.value == 0){
			alert("O Semestre deve ser informado!");
			frm.cmbSemestre.focus();
			return false;
		}
		
		//*****verifica se o chkTipoNota foi selecionado
		intContMarcado==0
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "radio"){
				if (form.elements[i].name == "chkTipoNota"){
					//verifica se o checkbox está marcado
					if (form.elements[i].checked){
						intContMarcado = form.elements[i].value;
					}
				}
			}
		}
		
		if (intContMarcado==0){
			alert("A avaliação deve ser informada!");
			return false;
		}
		

		var men = 'ATENÇÃO: \nDeseja realmente excluir essa falta?';
		if (confirm(men)) {
			window.open("Faltas_cod_e.asp?acao="+acao+"&CodAlunoDisciplina="+CodAlunoDisciplina+"&Falta="+Faltas +"&AnoLetivo="+frm.txtAnoLetivo.value +"&Semestre="+frm.cmbSemestre.value +"&CodBimestre="+intContMarcado,"Excluir", "top=0,left=0,height=150,width=150,menubar=no,toolbar=no,scrollbars=no,status=no");
			return true;
		} else {s
			return false;
		}
	
 	}
</script>
<%
	strPaginaTitulo = "Faltas_con.asp"

	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	strSemestre 			= session("strSemestre")
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if

	'REGRA QUANDO O ANO DIGITADO FOR MENOR QUE O DA SESSION
	'SERÁ GRAVADO DO ARQUIVO DE HISTORICO
	if Cint(strAnoLetivo) < Cint(session("strAnoLetivo")) then
		'GRAVANDO NO ARQUIVO DE HISTORICO
		strGravarOnde = "HISTORICO"
		strMsnBotaoHistorico  = " notas no Histórico"
		strBloqueiaVerificacao = "S"
	else
		'GRAVANDO NO ARQUIVO DE NOTAS
		strGravarOnde = "NOTA"
		strMsnBotaoHistorico  = ""
		strBloqueiaVerificacao = ""
	end if
	
	intCodTurma 			= Trim(Request("cmbTurma"))
	intCodCurso	 			= Trim(Request("cmbCurso"))
	intCodPeriodo 			= Trim(Request("cmbPeriodo"))
	intSemestre 			= Trim(Request("cmbSemestre"))
	intCodGrade				= Trim(Request("cmbGrade"))

	intCodTurno		 		= Trim(Request("cmbTurno"))
	intCodPlanoPagamento	= Trim(Request("cmbPlanoPagamento"))
	strSala		 			= Trim(Request("txtSala"))
	intAno		 			= Trim(Request("txtAno"))
	intAnoLetivo 			= Trim(Request("txtAnoLetivo"))
	
	intCodTipoLancamento    = trim(request("cmbTipoLancamento"))
	intCodDisciplinaTurma   = trim(request("cmbDisciplinaTurma"))
	strData					= trim(request("txtData"))
	
	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula 		= Trim(Request("txtMatricula"))
	strNomealuno 		= Trim(Request("txtNomealuno"))
	
	strVerificaFaltas 	= Trim(Request("optVerificaFaltas"))

	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	if intCodTipoLancamento = "" then intCodTipoLancamento = "0"
	if intCodDisciplinaTurma = "" then intCodDisciplinaTurma = "0"

	sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma"
	sql = sql & " FROM SCA_TURMA "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
	SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
	sql = sql & " AND SCA_TURMA.Cod_Turma= " & intCodTurma
	RS.OPEN SQL, CNN
	IF not RS.EOF THEN
		intCodCurso 	= rs("cod_curso")
		intCodPeriodo = rs("cod_periodo")
		intCodTurno = rs("cod_turno")
		intSemestre = rs("cod_Semestre")
	END IF
	rs.close
	
	if trim(strMatricula) <> "" then
	
		sql = "Select sca_aluno.Codigo, sca_aluno.NomeAluno, sca_aluno.matricula "
		sql = sql & " From sca_aluno"
		sql = sql & " Left join sca_situacaoaluno on sca_situacaoaluno.Cod_SituacaoAluno = sca_aluno.cod_situacaoaluno and sca_situacaoaluno.cod_empresa = sca_aluno.cod_empresa"
		sql = sql & " where sca_aluno.cod_empresa = " & session("CodEmpresa")
		sql = sql & " and sca_aluno.matricula = " & strMatricula
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

	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""
	if strVerificaFaltas = "" then strVerificaFaltas = "N"

%>
<form method="post" id="frm" action="Faltas_con.asp">
<input  name="cmbCurso" type="hidden" id="cmbCurso" value="<%=intCodCurso%>">
<input  name="cmbPeriodo" type="hidden" id="cmbPeriodo" value="<%=intCodPeriodo%>">

<table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td  align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
  </table>
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
    <tr>
      <td width="12%" class="texto1">Ano Letivo:</td>
      <td width="88%" colspan="2"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
    </tr>
    <tr>
      <td class="texto1">Semestre:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
    </tr>
    <tr> 
      <td class="texto1">Turma:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdTurma.asp"--></td>
    </tr>
    
    <tr>
      <td class="texto1">Matr&iacute;cula: </td>
      <td colspan="2"><input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="10" value="<%=strCodAluno%>" maxlength="10">
        <span class="texto1">
        <input name="txtMatricula" type="text" class="text" id="txtMatricula" size="20" maxlength="20" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 9)" onBlur="submit()">
        <a  href="#" onClick="return abreConsulta('Aluno_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a></span>&nbsp;
      <input readonly name="txtNomealuno" type="text" class="textDesabilita" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>" ></td>
    </tr>
    <tr> 
      <td class="texto1">Disciplina:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmbDisciplinaTurma.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Data:</td>
      <td colspan="2"><input name="txtData" type="text" class="text" id="txtData" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strData%>" title="Click aqui para visualizar o calend&aacute;rio"></td>
    </tr>
    <tr>
      <td class="texto1">Verificar Faltas</td>
      <td colspan="2"class="texto1" >
      <strong>
        <%if strBloqueiaVerificacao = "S" then  strVerificaFaltas = "N"  %>
        <%if strBloqueiaVerificacao = "S" then %>
             strVerificaFaltas = "N" 
            <input  <% if strVerificaFaltas = "S" then response.Write("checked")%> name="optVerificaFaltas" type="radio" value="S"  onClick="submit()"> Sim <br>
        <% end if %>    
		<input <% if strVerificaFaltas = "N" then response.Write("checked")%> name="optVerificaFaltas" type="radio" value="N" onClick="submit()"> Não
		</strong>
        </td>
    </tr>
    <tr align="left"> 
      <td colspan="3" class="texto1">
	  <br>
	  <%
			  	IF intCodCurso = "" THEN intCodCurso = 0

				sql="SELECT TA.CODIGO, TA.DESCRICAO, TA.BIMESTRE"
				sql=sql & " FROM SCA_CRITERIO_AVALIACAO CA"
				sql=sql & " INNER JOIN SCA_AVALIACAO A ON A.CODCRITERIOAVALIACAO = CA.CODIGO AND A.COD_EMPRESA = CA.COD_EMPRESA"
				sql=sql & " INNER JOIN SCA_TIPO_AVALIACAO TA ON A.CODTIPOAVALIACAO = TA.CODIGO AND A.COD_EMPRESA = TA.COD_EMPRESA"
				sql=sql & " WHERE	CA.COD_EMPRESA = " & Session("CodEmpresa") 
				sql=sql & " AND		CA.COD_CURSO = " & intCodCurso
				sql=sql & " AND		TA.digitar = 'S'"
				sql=sql & " ORDER BY TA.POSICAO"
				rs.open sql, cnn
				intCont = 0
				if rs.eof = false then
				%>
					<table width="50%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td width="23%" class="texto1"><strong>Bimestre</strong></td>
						<td width="77%" class="texto1"><strong>Avaliação</strong></td>
					  </tr>
				<%
					while not rs.eof
						if rs("bimestre") = "1" then strBim = "1º Bimestre"
						if rs("bimestre") = "2" then strBim = "2º Bimestre"
						if rs("bimestre") = "3" then strBim = "3º Bimestre"
						if rs("bimestre") = "4" then strBim = "4º Bimestre"
						if rs("bimestre") = "5" then strBim = "Exame Final"
						%>
						<tr>
						<td class="texto1"><%=strBim%></td>
						<td class="texto1"><input type="radio" name="chkTipoNota" value="<%=rs("codigo")%>"><%=rs("descricao")%></td>
						</tr>
						<%					
						trocaBim = trim(rs("bimestre"))
						rs.movenext
					wend
					%>
					</table>
	 			<%
				end if
				rs.close
				%> </td>
    </tr>
	 <tr align="center"> 
      <td colspan="3" class="texto1"></td>
    </tr>
    <tr> 
      <td colspan="3"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr> 
      <td colspan="3"><input type="button" name="cmdCadastrar" value="Cadastrar<%=strMsnBotaoHistorico%>" class="botao" onClick="return cadastrarNotas()"> 
        <input type="button" name="cmdLimpar"  value="Limpar"  class="botao" <%=strDesabilitaLimpar%>  onClick="window.navigate('Faltas_con.asp')"> 
        <input class="botao" type="button" value="Principal" name="BtnFechar" onClick="window.navigate('default.asp')">      </td>
    </tr>
    <tr> 
      <td colspan="3" class="texto1"> <br> <%
			if intCodTurma    = "" then intCodTurma="0"
			if intCodSemestre = "" then intCodSemestre="0"
			
			if intCodTurma<>"0" and (strMatricula <> "" or intCodDisciplinaTurma <> "0") then%> 
			
			<table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
          <tr class="CabecalhoConsulta"> 
            <td class="celula" align="center"><input type="checkbox" name="chkTodos" onClick="return MarcaTodos(this.checked)"></td><td width="42" class="celula"><strong>Ordem</strong></td>
            <td width="73" class="celula"><strong>Matr&iacute;cula</strong></td>
            <td width="516" class="celula"><strong>Nome</strong></td>
            <td width="521" class="celula"><strong>Disciplina</strong></td>
          </tr>
          <%					
			buscaHistorico = "N"
			if trim(intSemestre) = "3" then
			   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  then
				  buscaHistorico = "S"
			   end if
			else
			   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  or trim(intSemestre) <> trim(session("strSemestre")) then
				  buscaHistorico = "S"
			   end if	   
			end if


				if buscaHistorico = "N" then
				   sql = " SELECT AD.CODIGO AS COD_ALUNO_DISCIPLINA, "
				   sql = sql & " AD.COD_ALUNO AS CODIGO, " 
				   sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
				   sql = sql & " AD.COD_DISCIPLINA, "
				   sql = sql & " A.NOMEALUNO, "
				   sql = sql & " A.MATRICULA, "
				   sql = sql & " '' AS SEQUENCIA, "
				   sql = sql & " SA.DESC_SITUACAOALUNO, D.Desc_Disciplina "
				   sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD " 
				   sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO   "
				   sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa = A.COD_EMPRESA "
				   sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.Cod_Disciplina =  AD.Cod_Disciplina And D.Cod_Empresa = AD.COD_EMPRESA"
				   sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa") 
				   sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO= " & intCodTurma
				   
				   if intCodDisciplinaTurma <> "0" then
				   		sql = sql & " AND AD.COD_DISCIPLINA= " & intCodDisciplinaTurma
				   end if
				   
				   if strMatricula <> "" then	
					  sql = sql & "AND A.MATRICULA = '" & strMatricula & "'"
				   end if
				   
				   if strAtivos = "A" then	
					  sql = sql & "AND (SA.Desc_SituacaoAluno = 'ATIVO' OR SA.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA') " 
				   end if
				   sql = sql & " ORDER BY A.NOMEALUNO "
				else
				   	'seleciona os alunos pelo ano e semestres do histórico 			
				   	sql = " select DISTINCT A.CODIGO, AT.COD_TURMA, HED.COD_DISCIPLINA, A.NOMEALUNO, A.MATRICULA,  '' AS SEQUENCIA, SA.DESC_SITUACAOALUNO, D.Desc_Disciplina "
				   	sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
				   	sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "
				   	sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO AND A.COD_EMPRESA = HE.COD_EMPRESA "
				   	sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND SA.COD_EMPRESA = A.COD_EMPRESA " 
				   	sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON  AT.COD_ALUNO=A.CODIGO AND AT.COD_EMPRESA = A.COD_EMPRESA "
				  	sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.Cod_Disciplina =  hed.Cod_Disciplina And D.Cod_Empresa = he.COD_EMPRESA"
				   	sql = sql & " WHERE A.COD_EMPRESA = " & Session("CodEmpresa")
				   	sql = sql & " AND AT.COD_TURMA = " & intCodTurma	
				   	sql = sql & " AND HE.ANO_LETIVO = " & strAnoLetivo
				   	sql = sql & " AND HE.SEMESTRE = " & intSemestre 
				   	sql = sql & " AND HED.COD_DISCIPLINA= " & intCodDisciplinaTurma
				   	sql = sql & " ORDER BY NOMEALUNO "
					
				end if	
				rs.open sql, cnn
				if rs.eof = false then
					while not rs.eof
							
							cont = cont + 1
							strCodigoAluno        	= rs("codigo")
							strDesabilitaAluno 	  	= ""
							strSituacaoAluno 		= ""
							strCodAlunoDisciplina	= ""
							
							if buscaHistorico = "N" then
								if intCodDisciplinaTurma <> "0" then
									'VERIFICA SE O ALUNO EXISTE A DISCIPLINA NA GRADE DO ALUNO
									sql = "SELECT AD.CODIGO "
									sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD"
									sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AD.COD_TURMA AND T.COD_EMPRESA = AD.COD_EMPRESA"
									sql = sql & " WHERE	AD.COD_ALUNO = " & strCodigoAluno
									sql = sql & " AND	AD.COD_DISCIPLINA = " & intCodDisciplinaTurma
									sql = sql & " AND	T.AnoLetivo = " & strAnoLetivo
									sql = sql & " AND	T.Cod_Semestre = " & intSemestre
									sql = sql & " AND	T.COD_EMPRESA = " & Session("CodEmpresa") 
									rsAux.open sql, cnn
									if rsAux.eof then
										strDesabilitaAluno 	= " disabled "
										strSituacaoAluno	= " <strong>(Não tem a disciplina na grade)</strong>"
									else
										strCodAlunoDisciplina	= rsAux("codigo")
									end if
									rsAux.close
								end if	
							end if
							strMatricula		  = rs("MATRICULA")
'							intStatusAluno        = rs("codigo_status")
'							strCodigoSituacao     = rs("codigoSitAluno")

							'Função que verifica a siuação do aluno
							strSituacaoPromocao = "" 'Não é necessário mostrar a situação promoção nesta tela

							%>
          <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
            <td class="celula" align="center"><input type="hidden" value="<%=strCodAlunoDisciplina%>" name="txtCodAlunoDisciplina">
            <input type="checkbox" id="chkAluno" name="chkAluno" <%=strDesabilitaAluno%> value="<%=rs("codigo")%>"></td>
            <td class="celula"><%=rs("sequencia")%>&nbsp;</td>
            <td class="celula"><%=strMatricula%></td>
            <td class="celula"><%=rs("NOMEALUNO") & " " & strSituacaoAluno%></td>
            <td class="celula"><%=rs("Desc_Disciplina")%></td>
          </tr>
          <%if strVerificaFaltas = "S" then%>
          <tr>
            <td colspan="5" align="center" class="celula">
            	<br>
                <table width="96%" align="center" cellpadding="0" cellspacing="0"  bordercolor="#CCCCCC" class="tabela">
                	<tr bgcolor="#E5E5E5">
                		<td width="3%" height="20" class="celula" align="center" style="cursor:hand" onClick="AbreFecha(L<%=cont%>,F<%=cont%>)"><img src="<%=session("strCaminhoRaiz")%>/images/plus.bmp" id="F<%=cont%>"></td>
                		<td class="celula"><strong>Verifica as Faltas</strong></td>
                	</tr>
                	<tr id="L<%=cont%>" style="display:none" >
               			<td height="64" class="celula">&nbsp;</td>
                		<td valign="top" align="center" class="celula">
                    <%
					SQL = "SELECT Codigo, Data, Falta FROM SCA_FALTAS_DIARIA "
					SQL = SQL & " WHERE cod_empresa = " & Session("CodEmpresa") 
					SQL = SQL & " AND cod_aluno_disciplina = " & rs("COD_ALUNO_DISCIPLINA")
					SQL = SQL & " AND ano_letivo = " & strAnoLetivo
					SQL = SQL & " AND semestre = " & intSemestre
					rsAux.open sql, cnn
						%>
                        <table width="582" border="0" cellspacing="0" cellpadding="0" class="tabela">
                		  <tr bgcolor="#E5E5E5">
                           <td width="144" height="24" class="celula">&nbsp;<strong>Seq.</strong></td>
                		    <td width="153" class="celula">&nbsp;<strong>Data</strong></td>
                		    <td width="157" class="celula">&nbsp;<strong>FALTA</strong></td>
                		    <td width="127" align="center" class="celula"><strong>A&ccedil;&atilde;o&nbsp;</strong></td>
              		    	</tr>
                          <%
						  if rs.eof = false then
							while not rsAux.eof
						  %>
                		   
                		  <tr>
                		    <td height="24" align="center" class="celula"><%=rsAux("Codigo")%>&nbsp;</td>
                		    <td align="center" class="celula"><%=formataDataAP(rsAux("Data"))%>&nbsp;</td>
                		    <td align="center" class="celula"><%=rsAux("Falta")%>&nbsp;</td>
                            <td class="celula" align="center"><a href="#" onClick="ExcluirFaltas('E','<%=rsAux("Codigo")%>','<%=rs("COD_ALUNO_DISCIPLINA")%>','<%=rsAux("Falta")%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cinzaImage<%=rs("Codigo")%>','','../../images/botao_vermelho_over.gif',1)" ><img align="absmiddle" src="../../images/botao_vermelho_normal.gif" alt="Clique para excluir as faltas." name="cinzaImage<%=rs("codigo")%>" width="26" height="26" border="0" <%=estiloImagemPago%> ></a></td>
              		    </tr>
                		  <%
		  					rsAux.movenext
		 					wend
						end if
		  				rsAux.close
		  				%>
              		  </table>
                     <br>
                     </td>
               		</tr>
                </table>
                <br>
            </td>
            </tr>
           
            <tr> 
            <td colspan="5" align="center" class="celula">&nbsp;</td>
            </tr>
            <%end if%> 
          	<%
						rs.movenext
					wend
				else
					%>
          <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
            <td colspan="5" align="center" class="celula"><%=session("strMensagemNaoEncontrado")%></td>
          </tr>
          <%
					end if
					rs.close
			end if
					%>
        </table>
		<p>&nbsp;</p>
        <p><br>
        </p></td>
    </tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
