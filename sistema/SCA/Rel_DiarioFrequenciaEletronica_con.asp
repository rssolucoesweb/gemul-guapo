<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 19/11/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Diário de frequencia Eletronica
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<script>
	function GerarRelatorio(){
		
		var form = window.document.forms[0];
		var intContMarcado=0;
		var strAlunos='';
		var strEja='';
		
		if (frm.cmbSemestre.value == 0){
			alert("O Semestre deve ser informado!");
			frm.cmbSemestre.focus();
			return false;
		}
		
		if (frm.cmbMes.value == "0"){
			alert("Mês deve ser informado!");
			frm.cmbMes.focus();
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
		
		frm.action = "Rel_DiarioFrequenciaEletronica_rel.asp";
		frm.submit();
		
		return true;	
	}
</script>
<%
	strPaginaTitulo = "Rel_DiarioFrequenciaEletronica_con.asp"
	
	strExecutarSubmitDisciplinaDoProfessor = "S"
	strBloqueia_NotasDocente = ""
	
	' Consulta a Categoria	
	sql = "select codigo "
	sql = sql & " from SRH_COLABORADOR"
	sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
	sql = sql & " and cod_empresa = " & Session("CodEmpresa")
	sql = sql & " and CodCategoria = 1 "'professor
	sql = sql & " and Situacao = 'A'" 'Ativo
	rs.open sql, cnn
	if rs.EOF = false then	
		strVerificaCategoria 		= "Professor"
		intCodColaboradorProfessor 	= trim(rs("codigo"))
	else
		strVerificaCategoria = ""
	end if
	rs.close
	
	strBloqueia_NotasDocente = ""
	sql = " SELECT top 1 Bloqueia_NotasDocente, Bloqueia_NotasSecretaria "
	sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES "
	sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
	rs.Open SQL, cnn
	
	if rs.EOF = false then								
		strBloqueia_NotasDocente 	 = trim(rs("Bloqueia_NotasDocente"))
		strBloqueia_NotasSecretaria  = trim(rs("Bloqueia_NotasSecretaria"))
	end if
	rs.close
	
	if strVerificaCategoria = "Professor" then 
		
		if strBloqueia_NotasDocente = "S" then
		%>
		<script>
			alert("Sistema Bloqueado para Lancamento, procure a Secretaria Geral.");
			window.location.href  = 'Default.asp'
		</script>
		<%
		end if
	else
		if strBloqueia_NotasSecretaria = "S" then
		%>
		<script>
			alert("Sistema Bloqueado para Lancamento, procure a Secretaria Geral.");
			window.location.href  = 'Default.asp'
		</script>
		<%
		end if
	end if
	
	strExecutarSubmitCurso	  	= "S"
	strExecutarSubmitPeriodo  	= "S"
	strExecutarSubmitSemestre 	= "S"
	strExecutarSubmitTurno	  	= "S"
	strExecutarSubmitTurma	 	= "S"
	strSemestre 				= session("strSemestre")
	
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
	else
		'GRAVANDO NO ARQUIVO DE NOTAS
		strGravarOnde = "NOTA"
		strMsnBotaoHistorico  = ""
	end if
	
	if  Trim(Request("cmbTurma")) <> "" then
		intCodTurma 			= Trim(Request("cmbTurma"))
		intCodTurmaProfessor	= Trim(Request("cmbTurma"))
	else
		intCodTurma				= Trim(Request("cmbTurmaProfessor"))
		intCodTurmaProfessor	= Trim(Request("cmbTurmaProfessor"))
	end if
	
	if  Trim(Request("cmbDisciplinaTurma")) <> "" then
		intCodDisciplina			= Trim(Request("cmbDisciplinaTurma"))
		intCodDisciplinaTurma		= Trim(Request("cmbDisciplinaTurma"))
	else
		intCodDisciplina			 = Trim(Request("cmbDisciplinaDoProfessor"))
		intCodDisciplinaTurma		 = Trim(Request("cmbDisciplinaDoProfessor"))
	end if
	
	if intCodTurma = "" then intCodTurma = "0"
	if intCodTurmaProfessor = "" then intCodTurmaProfessor = "0"
	if intCodDisciplina = "" then intCodDisciplina = "0"
	if intCodDisciplinaTurma = "" then intCodDisciplinaTurma = "0"
	
	intCodCurso	 			= Trim(Request("cmbCurso"))
	intCodPeriodo 			= Trim(Request("cmbPeriodo"))
	intSemestre 			= Trim(Request("cmbSemestre"))
	intCodGrade				= Trim(Request("cmbGrade"))
	
	intCodDisciplina		= Trim(Request("cmbDisciplinaDoProfessor"))
	strMes					= Trim(Request("cmbMes"))
	intCodEstagio     		= Trim(Request.Form("cmbEstagio"))

	intCodTurno		 		= Trim(Request("cmbTurno"))
	intCodPlanoPagamento	= Trim(Request("cmbPlanoPagamento"))
	strSala		 			= Trim(Request("txtSala"))
	intAno		 			= Trim(Request("txtAno"))
	intAnoLetivo 			= Trim(Request("txtAnoLetivo"))
	
	intCodTipoLancamento    = trim(request("cmbTipoLancamento"))
	intCodDisciplina  		= trim(request("cmbDisciplinaDoProfessor"))
	strData					= trim(request("txtData"))

	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	if intCodTipoLancamento = "" then intCodTipoLancamento = "0"
	if intCodDisciplina = "" then intCodDisciplina = "0"
	if intCodEstagio = "" then intCodEstagio = "0"

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
	
	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""
%>
<form method="post" id="frm" action="Rel_DiarioFrequenciaEletronica_con.asp">
<input name="cmbCurso" type="hidden" id="cmbCurso" value="<%=intCodCurso%>">
<input name="cmbPeriodo" type="hidden" id="cmbPeriodo" value="<%=intCodPeriodo%>">
<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
    <tr valign="top">
      <td  align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
    </tr>
    </table>
  <table width="100%" border="0" align="center"  bgcolor="#FFFFFF" cellpadding="0" cellspacing="2" class="Formulario">
    <tr>
      <td width="13%" class="texto1">Ano Letivo:</td>
      <td width="87%" colspan="2"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
    </tr>
    <tr>
      <td class="texto1">Semestre:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
    </tr>
     <% if strVerificaCategoria = "" then%>
    <tr>
      <td class="texto1">Turma:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdTurma.asp"--></td>
    </tr>
     <%end if%>
     	
     <% if strVerificaCategoria = "Professor" then%>
    <tr> 
      <td class="texto1">Turma:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdTurmaProfessor.asp"--></td>
    </tr>
    <%end if%>
    <% if strVerificaCategoria = "Professor" then%>
    <tr>
      <td class="texto1">Disciplina:</td>
      <td colspan="2" class="texto"><!--#include file="../includes/inc_cmdDisciplinaDoProfessor.asp"--></td>
    </tr>
    <%end if%>
    <% if strVerificaCategoria = "" then%>
    <tr>
     	<td class="texto1">Disciplina:</td>
   		<td colspan="2" class="texto"><!--#include file="../includes/inc_cmbDisciplinaTurma.asp"--></td>
    </tr>
     <%end if%>
     <tr>
       <td class="texto1">Est&aacute;gio: </td>
       <td class="texto1"><!--#include file="../includes/inc_cmdEstagio.asp"--></td>
     </tr>
    <tr>
      <td class="texto1"> Conte&uacute;do Program&aacute;tico: </td>
      <td class="texto1"><input type="checkbox" name="mostraConteudo" value="S"></td>
    </tr>
    <tr>
      <td class="texto1">M&ecirc;s:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmbMes.asp"--></td>
    </tr>
    
    <tr align="left"> 
      <td colspan="3" class="texto1"><%
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
						<td width="77%" class="texto1"><strong>Avalia&ccedil;&atilde;o</strong></td>
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
				%>      </td>
    </tr>
	 <tr align="center"> 
      <td colspan="3" class="texto1"><BR><font color="#FF0000">Obs: Para emiss&atilde;o do di&aacute;rio frequencia eletr&ocirc;nico o conteudo programatico dever&aacute; estar enviado para a disciplina selecionada.</font><BR></td>
    </tr>
    <tr> 
      <td colspan="3"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr> 
      <td colspan="3"><input type="button" name="cmdCadastrar" value="Gerar Relat&oacute;rio" class="botao" onClick="return GerarRelatorio()"> 
        <input type="button" name="cmdLimpar"  value="Limpar"  class="botao" <%=strDesabilitaLimpar%>  onClick="window.navigate('Rel_DiarioFrequenciaEletronica_con.asp')"> 
        <input class="botao" type="button" value="Principal" name="BtnFechar" onClick="window.navigate('default.asp')">      </td>
    </tr>
    <tr> 
      <td colspan="3" class="texto1"> <br> <%
			if intCodTurma    	= "" then intCodTurma="0"
			if intCodSemestre 			= "" then intCodSemestre="0"
			if intCodTurma<>"0" then%> 
			
			<table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
          <tr class="CabecalhoConsulta"> 
            <td width="34" align="center" class="celula"><input type="checkbox" name="chkTodos" onClick="return MarcaTodos(this.checked)"></td>
            <td width="81" class="celula"><strong>Ordem</strong></td>
            <td width="126" class="celula"><strong>Matr&iacute;cula</strong></td>
            <td width="722" class="celula"><strong>Nome</strong></td>
          </tr>
          <%					
					'seleciona os alunos da turma
					'seleciona os alunos da turma - intCodTurma
					'sql = sqlAlunoTurma(intCodTurma, "")

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
						sql = " SELECT distinct "
						sql = sql & " AD.COD_ALUNO AS CODIGO, " 
						sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
						sql = sql & " A.NOMEALUNO, "
						sql = sql & " A.MATRICULA, "
						sql = sql & " '' AS SEQUENCIA, "
						sql = sql & " SA.DESC_SITUACAOALUNO "
						sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN " 
						sql = sql & " SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
						sql = sql & " SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa = A.COD_EMPRESA "
					    if intCodEstagio <> "0" then
							sql = sql & " INNER JOIN SCA_ESTAGIO_VINCULO EV ON EV.Cod_Aluno = A.CODIGO and CodEstagio = " & intCodEstagio
						end if
						sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa")
						' Filtra o estagio
						if intCodEstagio <> "0" then
							sql = sql & " and EV.CodEstagio = " & intCodEstagio
						else	
							sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO = " & intCodTurma	
						end if
					  	sql = sql & " AND AD.COD_DISCIPLINA= " & intCodDisciplinaTurma
						sql = sql & " AND (SA.Desc_SituacaoAluno = 'ATIVO' OR SUBSTRING(SA.Desc_SituacaoAluno,1,2)+SUBSTRING(SA.Desc_SituacaoAluno,4,5)+SUBSTRING(SA.Desc_SituacaoAluno,10,4) = 'PR-MATRCULA') "
						sql = sql & " ORDER BY A.NOMEALUNO "
						
					else   
					   'seleciona os alunos pelo ano e semestres do histórico 			
					   sql = " select DISTINCT A.CODIGO, AT.COD_TURMA, HED.COD_DISCIPLINA, A.NOMEALUNO, A.MATRICULA,  '' AS SEQUENCIA, SA.DESC_SITUACAOALUNO "
					   sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
					   sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "
					   sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO AND A.COD_EMPRESA = HE.COD_EMPRESA "
					   sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND SA.COD_EMPRESA = A.COD_EMPRESA " 
					   sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON  AT.COD_ALUNO=A.CODIGO AND AT.COD_EMPRESA = A.COD_EMPRESA "
					   if intCodEstagio <> "0" then
							sql = sql & " INNER JOIN SCA_ESTAGIO_VINCULO EV ON EV.Cod_Aluno = A.CODIGO and EV.CodEstagio = " & intCodEstagio
					   end if
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

							strCodigoAluno      = rs("codigo")
							strMatricula		= rs("MATRICULA")

							'Função que verifica a siuação do aluno
							strSituacaoPromocao = "" 'Não é necessário mostrar a situação promoção nesta tela

							%>
          <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
            <td class="celula" align="center"><input type="checkbox" id="chkAluno" name="chkAluno" value="<%=rs("codigo")%>"></td>
            <td class="celula"><%=rs("sequencia")%>&nbsp;</td>
            <td class="celula"><%=strMatricula%></td>
            <td class="celula"><%=rs("NOMEALUNO") & " " & strSituacaoAluno%>&nbsp;</td>
            </tr>
          <%
						rs.movenext
					wend
				else
					%>
          <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
            <td colspan="4" align="center" class="celula"><%=session("strMensagemNaoEncontrado")%></td>
          </tr>
          <%
					end if
					rs.close
			end if
		%>
        </table></td>
    </tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
