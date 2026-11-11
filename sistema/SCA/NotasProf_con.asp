<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>

<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 27/11/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Notas professor
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
<!--#include file="../../includes/inc_aguarde.asp"-->
<script>

	function AlunoFoto(codAluno){
		window.open("AlunoFoto_con.asp?codAluno="+codAluno,"consulta", "top=0,left=0,height=400,width=578,menubar=no,toolbar=no,scrollbars=yes,status=yes");
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
		
		if (frm.cmbTurmaProfessor.value == 0){
			alert("A turma deve ser informada!");
			frm.cmbTurmaProfessor.focus();
			return false;
		}		
		
		if (frm.cmbDisciplinaDoProfessor.value == 0){
			alert("A disciplina deve ser informada!");
			frm.cmbDisciplinaDoProfessor.focus();
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
		
		frm.action = "NotasProf_cad.asp";
		frm.submit();
		return true;	
	}
</script>
<%
	strPaginaTitulo = "NotasProf_con.asp"
	strExecutarSubmitDisciplinaDoProfessor = "S"

	sql = "select codigo "
	sql = sql & " from SRH_COLABORADOR"
	sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
	sql = sql & " and codLotacao= " & Session("CodEmpresa")
	sql = sql & " and CodCategoria = 1"'professor
	sql = sql & " and Situacao = 'A'"'ativo
	rs.open sql, cnn
	if rs.eof then
		rs.close
		%>
		<script>
			alert("ATENÇÃO: \n\nAcesso não autorizado, ou usuário não pertence a categoria de professores.");
			window.history.back();
		</script>
		<%	
		response.End()
	else
		intCodColaboradorProfessor = rs("codigo")
	end if
	rs.close
	
	strBloqueia_NotasDocente = ""
	strSimouNaoCampoAcumuladaFalta = ""
	sql = " SELECT top 1 Bloqueia_NotasDocente, Bloqueia_CampoAcumuladaFalta "
	sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES "
	sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
	rs.Open SQL, cnn
	if rs.EOF = false then								
		strBloqueia_NotasDocente        = trim(rs("Bloqueia_NotasDocente"))
		strSimouNaoCampoAcumuladaFalta	= rs("Bloqueia_CampoAcumuladaFalta")
	end if
	rs.close
	
	if strSimouNaoCampoAcumuladaFalta = "S" or strSimouNaoCampoAcumuladaFalta = "" then
	   bloqueiaAcumuladaFalta = "readonly"
	else   
	   bloqueiaAcumuladaFalta = ""
	end if
	
	if strBloqueia_NotasDocente = "S" then
		%>
		<script>
			alert("ATENÇÃO: \n\nAplicação Bloqueada para Lançamento, procure a Secretaria Geral.");
			window.history.back();
		</script>
		<%	
		response.End()
	end if	


	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	strSemestre 		      = session("strSemestre")
	
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request.Form("txtAnoLetivo")
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
	
	intCodTurmaProfessor 	= Trim(Request("cmbTurmaProfessor"))
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
	intCodDisciplina  		= trim(request("cmbDisciplinaDoProfessor"))
    strAtivos               = trim(request("cmbativos"))

	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurmaProfessor = "" then intCodTurmaProfessor = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	if intCodTipoLancamento = "" then intCodTipoLancamento = "0"
	if intCodDisciplina= "" then intCodDisciplina = "0"

	sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma"
	sql = sql & " FROM SCA_TURMA "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
	SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
	sql = sql & " AND SCA_TURMA.Cod_Turma= " & intCodTurmaProfessor
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
<form method="post" id="frm" action="NotasProf_con.asp">
<input  name="cmbCurso" type="hidden" id="cmbCurso" value="<%=intCodCurso%>">
<input  name="cmbPeriodo" type="hidden" id="cmbPeriodo" value="<%=intCodPeriodo%>">
<input  name="cmbBloqueiaFaltas" type="hidden" id="cmbBloqueiaFaltas" value="<%=bloqueiaAcumuladaFalta%>">

<table width="100%" border="0" cellpadding="0" cellspacing="0"  bgcolor="#FFFFFF">
            <tr valign="top">
              <td  align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
  </table>
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" bgcolor="#FFFFFF">
    <tr>
      <td width="12%" class="texto1">Ano Letivo:</td>
      <td width="88%" colspan="2"><input  readonly name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
    </tr>
    <tr>
      <td class="texto1">Semestre:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
    </tr>
    <tr> 
      <td class="texto1">Turma : </td>
      <td colspan="2"><!--#include file="../includes/inc_cmdTurmaProfessor.asp"--></td>
    </tr>
    
    <tr>
      <td class="texto1">Disciplina : </td>
      <td colspan="2"><!--#include file="../includes/inc_cmdDisciplinaDoProfessor.asp"--></td>
    </tr>
    <tr> 
      <td class="texto1">Situa&ccedil;&otilde;es:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmbAtivos.asp"--></td>
    </tr>
    <tr align="left"> 
      <td colspan="3" class="texto1">
	  <br>

	  <%
			  	IF intCodCurso = "" THEN intCodCurso = 0
				if intCodCurso <> "0" then
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
							<td class="texto1"><strong>Bimestre</strong></td>
							<td class="texto1"><strong>Avaliação</strong></td>
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
					else
							response.Write("<br><div align='center'>Curso da turma esta sem critério de avaliação.</div>")
					end if
					rs.close
				end if
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
        <input type="button" name="cmdLimpar"  value="Limpar"  class="botao" <%=strDesabilitaLimpar%>  onClick="window.navigate('notasProf_con.asp')"> 
        <input class="botao" type="button" value="Principal" name="BtnFechar" onClick="window.navigate('default.asp')">      </td>
    </tr>
    <tr> 
      <td colspan="3" class="texto1"> <br> <%
			if intCodTurmaProfessor    = "" then intCodTurmaProfessor="0"
			if intCodSemestre = "" then intCodSemestre="0"
			if intCodTurmaProfessor<>"0" and intCodDisciplina<>"0" then%> 
			
			<table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
          <tr class="CabecalhoConsulta"> 
            <td class="celula" width="48" align="center">&nbsp;&nbsp;
              <input type="checkbox" name="chkTodos" onClick="return MarcaTodos(this.checked)"></td>
            <td width="64" class="celula"><strong>Ordem</strong></td>
            <td width="85" class="celula"><strong>Matr&iacute;cula</strong></td>
            <td width="626" class="celula"><strong>Nome</strong></td>
            <td width="100" align="center" class="celula"><strong>Situa&ccedil;&atilde;o </strong></td>
            <td width="100" align="center" class="celula"><strong>Visualizar Foto</strong></td></tr>
          <%					
			'seleciona os alunos da turma
					'seleciona os alunos da turma - intCodTurma
					'sql = sqlAlunoTurma(intCodTurma, intCodDisciplinaTurma)
					sql = " SELECT AD.CODIGO AS COD_ALUNO_DISCIPLINA, "
					sql = sql & " AD.COD_ALUNO AS CODIGO, " 
					sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
					sql = sql & " AD.COD_DISCIPLINA, "
					sql = sql & " A.NOMEALUNO, "
					sql = sql & " A.MATRICULA, "
					sql = sql & " '' AS SEQUENCIA, "
					sql = sql & " SA.DESC_SITUACAOALUNO "
					sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN " 
					sql = sql & " SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
					sql = sql & " SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO "
					sql = sql & " WHERE 1=1 "
					' AD.COD_EMPRESA = " & Session("CodEmpresa")
					sql = sql & " AND AD.COD_DISCIPLINA= " & intCodDisciplina
					sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO = " & intCodTurmaProfessor	
				    if strAtivos = "A" then	
					   sql = sql & "AND (SA.Desc_SituacaoAluno = 'ATIVO' OR SA.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA') " 
				    end if	  
					sql = sql & " ORDER BY A.NOMEALUNO "
	            	rs.open sql, cnn
					if rs.eof = false then
						while not rs.eof
				            strCodAlunoDisciplina  	= rs("COD_ALUNO_DISCIPLINA")
							strCodAluno             = rs("CODIGO")
							intCodEmp               = Session("CodEmpresa") 
							strDesabilitaAluno 	  	= ""
							strSituacaoAluno 		= ""
							if strCodAlunoDisciplina <> "0" then
								'VERIFICA SE EXISTE REGISTRO DE NOTAS PARA O ALUNO 
								strCriaNotas = "S"
								sql = "SELECT COD_ALUNO_DISCIPLINA "
								sql = sql & " FROM SCA_NOTAS_FALTAS "
								sql = sql & " WHERE	COD_ALUNO_DISCIPLINA = " & strCodAlunoDisciplina
								rsAux.open sql, cnn
								if rsAux.eof then
                                    strCriaNotas = "N"
									strDesabilitaAluno 	= " disabled "
									strSituacaoAluno	= " <strong>(Não não existe registro de notas)</strong>"
								end if
								rsAux.close
								if strCriaNotas = "N" then
								   SQL = "INSERT INTO SCA_NOTAS_FALTAS (cod_empresa, cod_aluno, cod_aluno_disciplina, cod_periodo, "
								   SQL = SQL & "ano_letivo, semestre, cod_disciplina, nota01, falta01, nota02, falta02, nota03, falta03, nota04, falta04, nota05, falta05, nota06, falta06, nota07, falta07, nota08, falta08, nota09, falta09, nota10, falta10, nota11, falta11, nota12, falta12, nota13, falta13, nota14, falta14, nota15, falta15, situacao, media )  VALUES ("
					               SQL = SQL & "" & intCodEmp & ","
					               SQL = SQL & "" & strCodAluno & ","
					               SQL = SQL & "" & strCodAlunoDisciplina & ","
					               SQL = SQL & "" & intCodPeriodo & ","
					               SQL = SQL & "" & strAnoLetivo & ","
					               SQL = SQL & "" & intSemestre & ","
					               SQL = SQL & "" & intCodDisciplina & ","
					               SQL = SQL & "null,"
				                   SQL = SQL & "null,"
					               SQL = SQL & "null,"
					               SQL = SQL & "null,"
					               SQL = SQL & "null,"
					               SQL = SQL & "null,"
					               SQL = SQL & "null,"
					               SQL = SQL & "null,"
					               SQL = SQL & "null,"
					               SQL = SQL & "null,"
					               SQL = SQL & "null,"
					               SQL = SQL & "null,"
					               SQL = SQL & "null,"
					               SQL = SQL & "null,"
				 	               SQL = SQL & "null,"
					               SQL = SQL & "null,"
					               SQL = SQL & "null,"
					               SQL = SQL & "null,"
					               SQL = SQL & "null,"
								   SQL = SQL & "null,"
					               SQL = SQL & "null,"
	    			               SQL = SQL & "null,"
					               SQL = SQL & "null,"
					               SQL = SQL & "null,"
					               SQL = SQL & "null,"
					               SQL = SQL & "null,"
					               SQL = SQL & "null,"
					               SQL = SQL & "null,"
					               SQL = SQL & "null,"
					               SQL = SQL & "null,"
					               SQL = SQL & "null,"
    				               SQL = SQL & "null)"
					               cnn.execute SQL
					               'GravarLog sql
								end if
							end if
							strMatricula		          = rs("MATRICULA")
							strDesc_SituacaoAluno		  = rs("Desc_SituacaoAluno")
							'intStatusAluno        = rs("codigo_status")
						    'strCodigoSituacao     = rs("codigoSitAluno")
            				'Função que verifica a siuação do aluno
							strSituacaoPromocao = "" 'Não é necessário mostrar a situação promoção nesta tela

			%>
          <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
            <td class="celula" align="center"><input type="hidden" value="<%=strCodAlunoDisciplina%>" name="txtCodAlunoDisciplina"><input type="checkbox" id="chkAluno" name="chkAluno" <%=strDesabilitaAluno%> value="<%=rs("codigo")%>"></td>
            <td class="celula"><%=rs("sequencia")%>&nbsp;</td>
            <td class="celula"><%=strMatricula%></td>
            <td class="celula"><%=rs("NOMEALUNO") & " " & strSituacaoAluno%>&nbsp;</td>
            <td align="center" class="celula"><%=strDesc_SituacaoAluno%></td>
		    <td align="center" class="celula" onClick="AlunoFoto('<%=strCodAluno%>')"> <a href="#"><img src="../../images/logo_camera.gif" width="22" height="18"></a></td>
            </tr>
          <%
						rs.movenext
					wend
					
					if strCriaNotas = "N" then
						 %>
						 <script>
							alert("ATENÇÃO! Arquivo de NOTAS e FALTAS criado com sucesso, tente novamente.");
							window.location.href = 'NotasProf_con.asp'
						 </script>
						 <%
					end if	

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
