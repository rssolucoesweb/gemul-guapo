<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 29/07/2008
	::	Desenvolvedores...: Sergio Borges - Sergiob76@gmail.com
	::	Objetivo Pagina...: Cadastro de horario 
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script>
	function resultadoConsulta(intCodigo, intCodigoGradeCurricularDisciplina, intCodigoFicha){
	
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.txtCodigoGradeCurricularDisciplina.value=intCodigoGradeCurricularDisciplina;
		frm.txtCodigoFicha.value=intCodigoFicha;
		frm.submit();
	}
	function gerarImpressao(){
		var frm = document.getElementById("frm");
		frm.action="Rel_ParecerCurricular_rel.asp";
		frm.submit();
		return true;
 	}
	function AtualizarHistorico(){
		var frm = document.getElementById("frm");
		frm.action="parecerCurricularHistorico_cod.asp";
		frm.submit();
		return true;
 	}

	function salvar(acao){
		var frm = document.getElementById("frm");
		
		if (frm.txtCodigoGradeCurricularDisciplina.value == ""){
			alert("Disciplina da grade atual não foi selecionada.")	
			return false
		}
		
		frm.action="parecerCurricular_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%
strMostraBotaoImprimir = "S" 
strDesabilitaImprimir = "disabled"
strMostraBotaoAtualizarHistorico = ""

	strPaginaTitulo = "ParecerCurricular_cad.asp"

	intCodEmpresa 		= Session("CodEmpresa")
	strCodigo							= Trim(Request("txtCodigo"))
	strCodigoGradeCurricularDisciplina	= Trim(Request("txtCodigoGradeCurricularDisciplina"))
	intCodDisciplinaOutrasAnterior	= Trim(Request("txtCodDisciplinaOutrasAnterior"))
	strCodigoFicha			= Trim(Request("txtCodigoFicha"))
	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula 		= Trim(Request("txtMatricula"))
	
	strEscola 			= Trim(Request.Form("txtEscola"))
	strCidade 			= Trim(Request.Form("txtCidade"))
	strUfResidencia		= Trim(Request.Form("cmbUFResidencia"))
	
	strAnoLetivo 		= Trim(Request.Form("txtAnoLetivo"))
	intSemestre 		= Trim(Request.Form("cmbSemestre"))
	
    intCodDisciplina        = request("cmbDisciplina")
	intCodDisciplinaOutras	= Trim(Request.Form("cmbDisciplinaOutras"))
    strCH			        = request("txtCH")
	strNota				= Trim(Request.Form("txtNota"))

	strConceito				= Trim(Request.Form("txtConceito"))
	strSituacaoPromocao		= Trim(Request.Form("cmbSituacaoPromocao"))
	if intCodCurso = "" then intCodCurso = "0"
	if strMatricula <> "" or strCodAluno <> "" then 
		sql = "select top 1 p.Cod_Curso, A.MATRICULA, A.CODIGO, A.NOMEALUNO, G.AnoReferencia, G.SemestreReferencia"
		sql = sql & " from SCA_ALUNO_TURMA AT"
		sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = AT.COD_ALUNO"
		sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA"
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GradeCurricular = T.Cod_GradeCurricular AND G.COD_EMPRESA = T.COD_EMPRESA"
		sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_periodo = G.Cod_periodo AND G.COD_EMPRESA = T.COD_EMPRESA"
		sql = sql & " Where AT.COD_EMPRESA = " & Session("CodEmpresa")	
		if strMatricula<>"" then
			sql = sql & " and A.MATRICULA = " & strMatricula
		end if
		if strCodAluno <> "" then
			sql = sql & " and A.codigo = " & strCodAluno
		end if
		sql = sql & " and G.Situacao = 'A'"
		sql = sql & " order by AT.CODIGO desc"
		rs.open sql, cnn
		if rs.eof = false then
			strMatricula = TRIM(rs("Matricula"))
			strNomealuno = TRIM(rs("Nomealuno"))
			strCodAluno	 = TRIM(rs("Codigo"))
			intCodCurso	 = TRIM(rs("cod_curso"))
			strAnoLetivoGrade 		= Trim(rs("AnoReferencia"))
			intSemestreGrade 		= Trim(rs("SemestreReferencia"))
			strDesabilitaImprimir = ""
			strMostraBotaoAtualizarHistorico = "S"
		end if
		rs.close
	end if

	if trim(strCodigo) <> "" then
	
		sql = "select f.*, d.codigo, d.cod_ficha_equivalencia,  d.Cod_GradeCurricularDisciplina,  d.ano_letivo,  d.semestre,   d.Cod_DisciplinaOutrasInstituicoes,  d.CH,  d.Nota,"
		sql = sql & " d.Conceito, d.Cod_SituacaoPromocao, gd.cod_disciplina"
		sql = sql & " from SCA_FICHA_EQUIVALENCIA f"
		sql = sql & " inner join SCA_FICHA_EQUIVALENCIA_DISCIPLINA d on d.cod_ficha_equivalencia = f.codigo inner join SCA_GradeCurricularDisciplina gd on gd.Cod_GradeCurricularDisciplina = d.Cod_GradeCurricularDisciplina"
		sql = sql & " where f.cod_aluno = " & strCodAluno
		sql = sql & " and 	d.codigo = " & strCodigo
		sql = sql & " and 	f.cod_empresa = " & Session("CodEmpresa")			
		rs.open sql, cnn
		if rs.eof = false then
			
			strEscola 				= Trim(RS("Escola"))
			strCidade 				= Trim(RS("Cidade"))
			strUfResidencia			= Trim(RS("UF"))
			
			strAnoLetivo 			= Trim(RS("Ano_Letivo"))
			intSemestre 			= Trim(RS("Semestre"))
			intCod_GradeCurricularDisciplina  = RS("Cod_GradeCurricularDisciplina")
			if intCodDisciplinaOutras = "" or intCodDisciplinaOutras = "0" then intCodDisciplinaOutras	= Trim(RS("Cod_DisciplinaOutrasInstituicoes"))
			if intCodDisciplinaOutrasAnterior = "" then intCodDisciplinaOutrasAnterior = Trim(RS("Cod_DisciplinaOutrasInstituicoes"))
			strCH			        = rs("CH")
			strNota					= Trim(rs("Nota"))

			strConceito				= Trim(RS("Conceito"))
			strSituacaoPromocao		= Trim(RS("cod_SituacaoPromocao"))
			
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			strDesabilitaImprimir = ""

		end if 
		rs.close
	elseif trim(strCodigoGradeCurricularDisciplina) <> "" then
	
		sql = "select f.*"
		sql = sql & " from SCA_FICHA_EQUIVALENCIA f"
		sql = sql & " inner join SCA_FICHA_EQUIVALENCIA_DISCIPLINA d on d.cod_ficha_equivalencia = f.codigo "
		sql = sql & " where f.cod_aluno = " & strCodAluno
		sql = sql & " and 	f.cod_empresa = " & Session("CodEmpresa")	
		rs.open sql, cnn
		if rs.eof = false then
			strCodigoFicha			= Trim(RS("codigo"))
			strEscola 				= Trim(RS("Escola"))
			strCidade 				= Trim(RS("Cidade"))
			strUfResidencia			= Trim(RS("UF"))
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
%><form id="frm" name="frm" method="post" action="ParecerCurricular_cad.asp">
<input type="hidden" name="txtCodigoGradeCurricularDisciplina" value="<%=strCodigoGradeCurricularDisciplina%>">
<input type="hidden" name="txtCodDisciplinaOutrasAnterior" value="<%=intCodDisciplinaOutrasAnterior%>">
<input type="hidden" name="txtCodigo" value="<%=strCodigo%>">
<input type="hidden" name="txtCodigoFicha" value="<%=strCodigoFicha%>">

<table width="100%" height="355" border="0" class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
        <td>
    
		  <table width="98%" border="0" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
		 <table width="98%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="222" class="texto1">Matr&iacute;cula: </td>
            <td width="1054"><input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="10" value="<%=strCodAluno%>" maxlength="10"><span class="texto1">
        <input name="txtMatricula" type="text" class="text" id="txtMatricula" size="20" maxlength="20" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 10)" onBlur="submit()">
        <a  href="#" onClick="return abreConsulta('Aluno_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a></span><input readonly name="txtNomealuno" type="text" class="textDesabilita" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>" >&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2" class="texto1"><hr size="1" color="#E5E5E5" ></hr></td>
          </tr>
          <tr>
            <td class="texto1">Escola:</td>
            <td><span class="texto1">
              <input name="txtEscola" type="text" class="text" id="txtEscola" size="50" maxlength="100" value="<%=strEscola%>"  onKeyPress="return formataCampo(this, 1, 100)">
            </span></td>
          </tr>
          <tr>
            <td class="texto1">Cidade:</td>
            <td><span class="texto1">
              <input name="txtCidade" type="text" class="text" id="txtCidade" size="50" maxlength="50" value="<%=strCidade%>" onKeyPress="return formataCampo(this, 1, 100)">
            </span></td>
          </tr>
          <tr>
            <td class="texto1">UF:</td>
            <td><span class="texto1">
              <!--#include file="../includes/inc_cmdUFResidencia.asp"-->
            </span></td>
          </tr>
          <tr>
            <td colspan="2" class="texto1"><hr size="1" color="#E5E5E5"></hr></td>
          </tr>
          <tr>
            <td class="texto1">Ano Letivo:</td>
            <td><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
          </tr>
          <tr>
            <td class="texto1">Semestre:</td>
            <td><!--#include file="../includes/inc_cmdSemestreParecer.asp" --></td>
          </tr>
          <tr>
            <td class="texto1">Disciplina Outra Institui&ccedil;&atilde;o:</td>
            <td><span class="texto1">
              <!--#include file="../includes/inc_cmbDisciplinaOutrasInstituicoes.asp" -->
<%
if intCodDisciplinaOutras = "-1" then
%>
            <br><input name="txtDisciplinaNova" type="text" class="text" id="txtDisciplinaNova" size="50" maxlength="100" onKeyPress="return formataCampo(this, 1, 100)">
<%
end if
%>          </span></td>
          </tr>
          <tr>
            <td class="texto1">C.H.:</td>
            <td class="texto1"><input  name="txtCH" type="text" class="text" id="txtCH" value="<%=strCH%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
          </tr>
          <tr>
            <td class="texto1">Nota:</td>
            <td class="texto1"><input  name="txtNota" type="text" class="text" id="txtNota" value="<%=strNota%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
          </tr>
          <tr>
            <td class="texto1">Conceito: </td>
            <td class="texto1"><input  name="txtConceito" type="text" class="text" id="txtConceito" value="<%=strConceito%>" size="15" maxlength="20"></td>
          </tr>
          <tr>
            <td class="texto1">Situa&ccedil;&atilde;o: </td>
            <td class="texto1"><!--#include file="../includes/inc_cmdSituacaoPromocao.asp" --></td>
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
<td colspan="2">
            
			
				<%
                cont = 0
                if strAnoLetivoGrade = "" then strAnoLetivoGrade = 0
                if intSemestreGrade = "" then intSemestreGrade = 0
                if strCodAluno = "" then strCodAluno = 0
				sql = "SELECT SCA_GRADECURRICULAR.Cod_GRADECURRICULAR, "
				sql = sql & " SCA_GRADECURRICULAR.Cod_AGRUPAMENTO, SCA_CURSO.COD_CURSO, "
				sql = sql & " SCA_CURSO.DESCRICAO, SCA_PERIODO.cod_periodo, SCA_PERIODO.Descricao as PERIODO, "
				sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina, SCA_DISCIPLINA.DESC_Disciplina, "
				sql = sql & " SCA_GRAU.DESC_GRAU, SCA_GRADECURRICULARDISCIPLINA.Ch_Semanal, SCA_GRADECURRICULARDISCIPLINA.Ch_Mensal, SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina,"
				sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Ch_Anual, SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR_EQUIVALENTE, SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULARDISCIPLINA_EQUIVALENTE, SCA_GRADECURRICULARDISCIPLINA.COD_DISCIPLINA_EQUIVALENTE,"
				sql = sql & " SCA_FICHA_EQUIVALENCIA_DISCIPLINA.ano_letivo, SCA_FICHA_EQUIVALENCIA_DISCIPLINA.semestre,SCA_FICHA_EQUIVALENCIA_DISCIPLINA.ch as Ch_Anual_origem, SCA_FICHA_EQUIVALENCIA_DISCIPLINA.Nota, SCA_FICHA_EQUIVALENCIA_DISCIPLINA.Conceito, SCA_FICHA_EQUIVALENCIA_DISCIPLINA.codigo as codEquivDisc, "
				sql = sql & " SCA_FICHA_EQUIVALENCIA_DISCIPLINA.cod_situacaopromocao as situacao, SCA_DisciplinaOutrasInstituicoes.Desc_Disciplina AS Desc_Disciplina_origem, SCA_FICHA_EQUIVALENCIA_DISCIPLINA.cod_ficha_equivalencia  as codFicha, SCA_FICHA_EQUIVALENCIA.Cod_Aluno"
				sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA "
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_GRADECURRICULAR.Cod_GRADECURRICULAR = SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_periodo = SCA_GRADECURRICULAR.COD_periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa INNER JOIN SCA_GRAU ON SCA_GRAU.Cod_Grau = SCA_CURSO.Cod_Grau and SCA_GRAU.cod_empresa = SCA_CURSO.cod_empresa INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina "
				sql = sql & " LEFT JOIN SCA_FICHA_EQUIVALENCIA_DISCIPLINA ON SCA_FICHA_EQUIVALENCIA_DISCIPLINA.Cod_GradeCurricularDisciplina = SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina"
				sql = sql & " LEFT JOIN SCA_FICHA_EQUIVALENCIA ON SCA_FICHA_EQUIVALENCIA.CODIGO = SCA_FICHA_EQUIVALENCIA_DISCIPLINA.cod_ficha_equivalencia"
				sql = sql & " LEFT JOIN SCA_DisciplinaOutrasInstituicoes ON SCA_DisciplinaOutrasInstituicoes.cod_Disciplina = SCA_FICHA_EQUIVALENCIA_DISCIPLINA.Cod_DisciplinaOutrasInstituicoes"
				sql = sql & " WHERE 	SCA_GRADECURRICULAR.AnoReferencia = " & strAnoLetivoGrade 
				sql = sql & " AND 		SCA_GRADECURRICULAR.SemestreReferencia = " & intSemestreGrade
				sql = sql & " AND 		SCA_CURSO.Cod_Curso = " & intCodCurso
				sql = sql & " AND		SCA_GRADECURRICULAR.situacao = 'A'"
				sql = sql & " AND 		(SCA_FICHA_EQUIVALENCIA.Cod_Aluno IS NULL OR SCA_FICHA_EQUIVALENCIA.Cod_Aluno = "&strCodAluno&")  "
				sql = sql & " ORDER BY SCA_PERIODO.SEQUENCIA, SCA_DISCIPLINA.DESC_Disciplina "
                rs.open sql, cnn
                if rs.eof = false then
                %>
                  <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                    <tr bgcolor="#E5E5E5">
                      <td colspan="3" align="center" class="celula"><strong>Dados da Institui&ccedil;&atilde;o Atual</strong></td>
                      <td height="21" colspan="7" align="center" class="celula"><strong>Dados da Insctitui&ccedil;&atilde;o de Origem</strong></td>
                    </tr>
                    <tr bgcolor="#E5E5E5">
                        <td width="9%" align="center" class="celula"><strong>Per&iacute;odo/S&eacute;rie</strong></td>
                      <td width="32%" align="center" class="celula"><strong>Disciplina</strong></td>
                      <td width="5%" align="center" class="celula"><strong><strong>C.H.</strong></strong></td>
                      <td width="14%" align="center" class="celula"><strong><strong>Disciplina </strong></strong></td>
                      <td width="9%" align="center" class="celula"><strong>Ano</strong></td>
                      <td width="9%" align="center" class="celula"><strong>Semestre</strong></td>
                      <td width="8%" height="21" align="center" class="celula"><strong>C.H<span class="TextoForm">.</span></strong></td>
                      <td width="4%" align="center" class="celula"><strong>Nota</strong></td>
                      <td width="4%" align="center" class="celula"><strong>Conceito</strong></td>
                      <td width="15%" align="center" class="celula"><strong>Parecer</strong></td>
                    </tr>
                    <%
					strPeriodoQuebra = ""
                    while not rs.eof
                        cont = cont + 1	
						sem = rs("semestre")
						if rs("semestre") = "3" then sem = "Anual"
						
						if strPeriodoQuebra <> rs("periodo") and strPeriodoQuebra<>"" then
                        %>
                        <tr >
                          <td class="celula" colspan="10" height="6" bgcolor="#E5E5E5"></td>
                        </tr>
						<%
						end if
						%>
                        <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("codEquivDisc")%>','<%=rs("Cod_GradeCurricularDisciplina")%>','<%=rs("CodFicha")%>')">
                          <td class="celula">&nbsp;<%=rs("periodo")%></td>
                          <td class="celula">&nbsp;<%=rs("desc_disciplina")%></td>
                          <td class="celula">&nbsp;<%=trim(rs("Ch_Anual"))%></td>
                          <td class="celula">&nbsp;<%=rs("desc_Disciplina_origem")%></td>
                          <td align="center" class="celula"><%=rs("ano_letivo")%>&nbsp;</td>
                          <td align="center" class="celula"><%=sem%>&nbsp;</td>
                          <td height="20" class="celula">&nbsp;<%=trim(rs("Ch_Anual_origem"))%></td>
                          <td class="celula">&nbsp;<%=trim(rs("nota"))%></td>
                          <td class="celula">&nbsp;<%=trim(rs("conceito"))%></td>
                          <td class="celula">&nbsp;<%=trim(rs("situacao"))%></td>
                        </tr>
                            <%		
							strPeriodoQuebra = rs("periodo")
                        	rs.movenext
                        wend
                        	%>
                            </table><br>
                            <br>
                            <%
                  end if
                  rs.close%>
              
		
		
	</td>
  </tr>
</table></form>
<!--#include file="../rodape.asp"-->
</body>
</html>