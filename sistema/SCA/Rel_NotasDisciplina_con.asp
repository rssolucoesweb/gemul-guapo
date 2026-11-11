<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Extrato de NOtas
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<script>
	function marcaTodos(valor){
	
		var frm = document.getElementById("frm");
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
	
	function gerar(){
		
		var frm = document.getElementById("frm");
		var form = window.document.forms[0];
		var intContMarcado=0;
		var strAlunos='';

	
		if (frm.cmbSemestre.value == 0){
			alert("O Semestre deve ser informado!");
			frm.cmbSemestre.focus();
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
		
		frm.action = "Rel_NotasDisciplina_rel.asp";
		frm.submit();
		
		return true;	
	}	
</script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<%
	strPaginaTitulo = "Rel_NotasDisciplina_con.asp"

	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	strExecutarSubmit	  = "S"
	strExecutarSubmitDisciplinaDoProfessor = "S"
	
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

    if strVerificaCategoria <> "Professor" then
	   intCodDisciplina			= Trim(Request("cmbDisciplinaTurma"))
	   intCodDisciplinaTurma	= Trim(Request.Form("cmbDisciplinaTurma"))
	else
	   intCodDisciplina		    = Trim(Request("cmbDisciplinaDoProfessor"))
	   intCodDisciplinaTurma	= Trim(Request("cmbDisciplinaDoProfessor"))
	end if   

    if strVerificaCategoria <> "Professor" then
		intCodTurma 			= Trim(Request("cmbTurma"))
		intCodTurmaProfessor	= Trim(Request("cmbTurma"))
	else   
		intCodTurma				= Trim(Request("cmbTurmaProfessor"))
		intCodTurmaProfessor	= Trim(Request("cmbTurmaProfessor"))
	end if   
	
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodGrade				= Trim(Request.Form("cmbGrade"))

	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")	
    strAtivos               = trim(request("cmbativos"))

	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp 	= "" then intCodComp = "0"
	if intCodSerie 	= "" then intCodSerie = "0"
	if intCodTurno 	= "" then intCodTurno = "0"
	if intCodTurma 	= "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	if intCodTipoLancamento 	= "" then intCodTipoLancamento = "0"
	if intCodDisciplinaTurma 	= "" then intCodDisciplinaTurma = "0"
	if intCodNota = "" then intCodNota="0"

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
<form method="post" id="frm" action="Rel_NotasDisciplina_con.asp">
<input name="cmbPeriodo" type="hidden" value="<%=intCodPeriodo%>">
<input name="cmbCurso" type="hidden" value="<%=intCodCurso%>">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
		<tr valign="top">
		  <td align="center">
<br>
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
          <tr> 
            <td width="15%" class="texto1">Ano Letivo:</td>
            <td width="85%"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
          </tr>
          <tr> 
            <td class="texto1">Semestre:</td>
            <td>
              <!--#include file="../includes/inc_cmdSemestre.asp" -->            </td>
          </tr>
          <tr> 
            <td class="texto1">Turma:</td>
            <td>
			  <% if strVerificaCategoria <> "Professor" then %>
                 <!--#include file="../includes/inc_cmdTurma.asp"-->
			  <% else %>	 
                 <!--#include file="../includes/inc_cmdTurmaProfessor.asp"-->
			  <% end if %>            </td>
          </tr>
          <tr> 
            <td class="texto1">Disciplina:</td>
            <td>
			  <% if strVerificaCategoria <> "Professor" then %>
			        <!--#include file="../includes/inc_cmbDisciplinaTurma.asp"-->
			  <% else %>
                    <!--#include file="../includes/inc_cmdDisciplinaDoProfessor.asp"-->			  
			  <% end if %>            </td>
          </tr>
          <tr>
            <td class="texto1">Situa&ccedil;&atilde;o Acad&ecirc;mica :</td>
            <td>
              <!--#include file="../includes/inc_cmbAtivos.asp"-->            </td>
          </tr>
          <tr>
            <td class="texto1">Filtrar Resultado? </td>
            <td><!--#include file="../includes/inc_cmdSituacaoPromocao.asp" --></td>
          </tr>
          <tr> 
            <td class="texto1">Mostrar Resultado:</td>
            <td><input type="checkbox" name="resultadoFinal" value="S"></td>
          </tr>
           <tr> 
            <td class="texto1">Mostrar Resumo dos Resultados:</td>
            <td><input type="checkbox" name="ResumoResultados" value="S"></td>
          </tr>
          <tr> 
            <td class="texto1">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td colspan="2"><hr size="1" color="#CCCCCC"></td>
          </tr>
          <tr> 
            <td colspan="2">
              <!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->
              &nbsp;</td>
          </tr>
          <tr> 
            <td colspan="2"> <br> 
              <%
			if intCodTurma    = "" then intCodTurma="0"
			if intCodPeriodo = "" then intCodPeriodo="0"

			if intCodTurma<>"0" and intCodPeriodo<>"0" then%>
              <table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
                <tr class="CabecalhoConsulta"> 
                  <td class="celula" width="30" align="center"><input type="checkbox" name="chkTodos" onClick="return marcaTodos(this.checked)"></td>
                  <td width="100" class="celula"><strong>Matrícula</strong></td>
                  <td width="696" class="celula"><strong>Nome do aluno </strong></td>
                  <td width="122" class="celula"><strong>&nbsp;Situa&ccedil;&atilde;o</strong></td>
                </tr>
                <%					
					'seleciona os alunos da turma através de sua disciplina
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
					
					' Se for professor busca dados somente no semestre atual
					if strVerificaCategoria = "Professor"  and trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  and trim(intSemestre) <> trim(session("strSemestre")) then
					    buscaHistorico = "N"
						%>
						<script>
							alert("Informação Anterior ao Semestre Letivo encontra-se Indisponível, procurar a Secretaria Geral.");
							window.location.href  = 'Rel_NotasDisciplina_con.asp'
						</script>
						<%
					end if	 
					'	 
					if buscaHistorico = "N" then
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
					   sql = sql & " SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa = A.COD_EMPRESA "
					   sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa") 
					   sql = sql & " AND AD.COD_DISCIPLINA= " & intCodDisciplinaTurma
					   sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO= " & intCodTurma
					   if strAtivos = "A" then	
						  sql = sql & "AND (SA.Desc_SituacaoAluno = 'ATIVO' OR SA.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA') " 
					   end if	  
					   sql = sql & " ORDER BY A.NOMEALUNO "
					   
					else   
					   'seleciona os alunos pelo ano e semestres do histórico 			
					   sql = " select DISTINCT A.CODIGO, AT.COD_TURMA, HED.COD_DISCIPLINA, A.NOMEALUNO, A.MATRICULA,  '' AS SEQUENCIA, SA.DESC_SITUACAOALUNO "
					   sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
					   sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "
					   sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO AND A.COD_EMPRESA = HE.COD_EMPRESA "
					   sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND SA.COD_EMPRESA = A.COD_EMPRESA " 
					   sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON  AT.COD_ALUNO=A.CODIGO AND AT.COD_EMPRESA = A.COD_EMPRESA "
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
							strCodigoAluno        = rs("codigo")
							strMatricula		  = rs("MATRICULA")
							'Função que verifica a siuação do aluno
							strSituacaoPromocao = "" 'Não é necessário mostrar a situação promoção nesta tela

							%>
                <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
                  <td class="celula" align="center"><input type="checkbox" id="chkAluno" name="chkAluno" <%=strDesabilitaAluno%> value="<%=rs("codigo")%>"></td>
                  <td class="celula"><%=strMatricula%></td>
                  <td class="celula"><%=rs("NOMEALUNO")& " " & strSituacaoAluno%>&nbsp;&nbsp;                  </td>
                  <td class="celula"><%=rs("DESC_SITUACAOALUNO")%>&nbsp;</td>
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
                            <tr>
                  <td colspan="4" align="left" class="celula"><strong>Total: <%=cont%></strong></td>
                </tr>

            </table>
            <br>
            </td>
          </tr>
        </table>
		  </td>
		</tr>
  </table><input type="hidden" name="txtHiddenAlunosTurma" value="<%=strAlunosTurma%>">
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>
