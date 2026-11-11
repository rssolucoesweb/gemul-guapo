<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Avaliação Educacional</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
	strExecutarSubmit                   = "S"
	strExecutarSubmitTurma				= "S"
	strReloadDisciplinaQuadro			= "S"
	strPaginaTitulo 					= "NotasAvaliacao_cad.asp"
	
	intCodAvaliacaoInstitucional		= Trim(Request.Form("cmbAvaliacaoInstitucional"))
	intCodTurma 						= Trim(Request.Form("cmbTurma"))
	intCodDisciplinaTurma				= Trim(Request.Form("cmbDisciplinaTurma"))
	
					

	if Trim(Request.Form("txtAnoLetivo")) 	= "" then
	   	intAnoLetivo 	= Session("strAnoLetivo")	
	else	
	    intAnoLetivo    = Trim(Request.Form("txtAnoLetivo"))	
	end if	
	
	if Trim(Request.Form("txtSemestre"))	 = "" then
	   	intSemestre 	= Session("strSemestre")
	else
		intSemestre    =  Trim(Request.Form("txtSemestre"))	
	end if	

	
	

	if intCodAvaliacaoInstitucional 	= "" then intCodAvaliacaoInstitucional 	= "0"
	if intCodTurma 						= "" then intCodTurma 					= "0"
	if intCodDisciplinaTurma 			= "" then intCodDisciplinaTurma 		= "0"
	
	cont = 0
	
	' Busca Tipo da Avalição
	if intCodAvaliacaoInstitucional <> "0" then 
		
		sql = "SELECT Codigo, Cod_empresa, Descricao, Ano_Letivo, Semestre, Tipo_Avaliacao, Tipo_Consulta, Observacoes, rodape"
		sql = sql & " FROM SAV_AVALIACAO_INSTITUCIONAL"
		sql = sql & " Where Codigo = " & intCodAvaliacaoInstitucional
		sql = sql & " And cod_empresa = " & Session("CodEmpresa")			
		rs.open sql, cnn
		
		if rs.eof = false then

			intCodAvaliacao			= rs("Codigo")
			strNomeAvaliacao		= rs("Descricao")
			strAnoLetivo			= rs("Ano_Letivo")
			strSemestre				= rs("Semestre")
			intTipoAvaliacao		= rs("Tipo_Avaliacao")
			intTipoConsulta			= rs("Tipo_Consulta")
			strObservacoes			= rs("Observacoes")
			strRodape				= rs("rodape")
		
		end if 
		rs.close
	end if
	
	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		
%>

    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Questionário - Lancto Avulso</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                  <div class="form-group">
                    
                      <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2">
                        <tr>
                        <td height="46" class="texto1">Ano/Semestre:</td>
                        <td width="7%" class="texto1"><span class="texto">
                        <input name="txtAnoLetivo" value="<%=intAnoLetivo%>" style="width:50pt" onKeyPress="return formataCampo(this, 2, 6)"  type="text" class="form-control" id="txtAnoLetivo" size="4" maxlength="4" onChange='submit()'>
                        </span></td>
                        <td width="82%" class="texto1"><span class="texto">
                          <input name="txtSemestre" value="<%=intSemestre%>" style="width:50pt" onKeyPress="return formataCampo(this, 2, 6)"  type="text" class="form-control" id="txtSemestre" size="3" maxlength="1" onChange='submit()'>
                        </span></td>
                        </tr>
                        <tr>
                        <td height="23" class="texto1">Avalia&ccedil;&atilde;o : </td>
                        <td colspan="2" class="texto1"><!--#include file="../includes/inc_cmdAvaliacaoInstitucional.asp" --></td>
                        </tr>
                        <% if intTipoAvaliacao =  1 and intTipoConsulta = 1 or intTipoAvaliacao =  2 and intTipoConsulta = 1 then %>
                        <tr>
                        <td height="23" class="texto1">Turma : </td>
                        <td colspan="3"><!--#include file="../includes/inc_cmdTurma.asp"--></td>
                        </tr>
                        <% end if %>	
                        <tr>
                        <td colspan="4" class="texto1">&nbsp;</td>
                        </tr>
                        <td colspan="4" class="texto1">	</td>
                        <tr> 
                        <td height="57" colspan="4" class="texto1">
                        <table "91%" border="0" cellspacing="0" align="center" cellpadding="0">
                        <tr>
                        <td width="112" class="texto2" height="23" align="center">(<strong>A</strong>) Excelente</td>
                        <td width="111" class="texto2" align="center">(<strong>B</strong>) Muito Bom</td>
                        <td width="87"  class="texto2" align="center">(<strong>C</strong>) Bom </td>
                        <td width="114" class="texto2" align="center">(<strong>D</strong>) Regular</td>
                        <td width="111" class="texto2" align="center">(<strong>E</strong>) Insuficiente</td>
                        </tr>
                        <tr>
                        <td height="21" colspan="8" class="texto2" align="center"><strong><%=strNomeAvaliacao%></strong></td>
                        </tr>
                        </table>    </td>
                        </tr>
                        <tr>
                        <td height="30" colspan="4"  border="1" class="celula"><%=strObservacoes%></td>
                        </tr>
                        <tr>
                        <td height="247" colspan="4" class="texto1"><%
                        
                        ' Tipo Avaliação: 
                        ' 1 - Curricular     ---> Buscao consulta do aluno
                        ' 2 - Não Curricular 
                        
                        ' Tipo Consulta: 
                        ' 1 - Curricular  		-->> 1 - Aluno
                        ' 2 - Não Curricular	-->> 1 - Aluno ou 2 - Colaborador
                        
                        ' 1 - Curricular	-->> 1 - Aluno 
                        ' Busca todos os alunos pela turma informada, gerendo uma avaliação por disciplina
                        
                        ' Tipo Avaliação: 
                        ' 1 - Curricular     ---> Buscao consulta do aluno
                        ' 2 - Não Curricular 
                        
                        ' Tipo Consulta: 
                        ' 1 - Curricular  		-->> 1 - Aluno
                        ' 2 - Não Curricular	-->> 1 - Aluno ou 2 - Colaborador
                        
                        ' 1 - Curricular	-->> 1 - Aluno 
                        ' Busca todos os alunos pela turma informada, gerendo uma avaliação por disciplina
                        
                        if intTipoAvaliacao =  1 and intTipoConsulta = 1 then
                        
                        sql = " SELECT SCA_DISCIPLINA.Cod_Disciplina, SCA_DISCIPLINA.Desc_Disciplina as DISCIPLINA, "
                        sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina, "
                        sql = sql & " SCA_TURMA.Cod_Turma, SCA_TURMA.NomeTurma"
                        sql = sql & " FROM  SCA_TURMA "
                        sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
                        sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA ON SCA_GRADECURRICULAR.Cod_GradeCurricular = SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular "
                        sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.Cod_Disciplina"
                        sql = sql & " WHERE 1=1"
                        sql = sql & " AND SCA_TURMA.Cod_Empresa= " & session("CodEmpresa")
                        sql = sql & " AND SCA_TURMA.Cod_Turma = " & intCodTurma
                        sql = sql & " ORDER BY Desc_Disciplina"
                        end if
                        
                        ' 2 - Não Curricular	-->> 1 - Aluno 
                        ' Busca todos os alunos pela turma informada
                        
                        if intTipoAvaliacao =  2 and intTipoConsulta = 1 then
                        
                        sql = " SELECT top 1 SCA_DISCIPLINA.Cod_Disciplina, SCA_DISCIPLINA.Desc_Disciplina as DISCIPLINA, "
                        sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina, "
                        sql = sql & " SCA_TURMA.Cod_Turma, SCA_TURMA.NomeTurma"
                        sql = sql & " FROM  SCA_TURMA "
                        sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
                        sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA ON SCA_GRADECURRICULAR.Cod_GradeCurricular = SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular "
                        sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.Cod_Disciplina"
                        sql = sql & " WHERE 1=1"
                        sql = sql & " AND SCA_TURMA.Cod_Empresa= " & session("CodEmpresa")
                        sql = sql & " AND SCA_TURMA.Cod_Turma = " & intCodTurma
                        sql = sql & " ORDER BY Desc_Disciplina"
                        
                        
                        
                        'sql = "select top 1 AT.COD_TURMA, T.NOMETURMA, AT.COD_ALUNO "
                        'sql = sql & " from SCA_ALUNO_TURMA AT"
                        'sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA "
                        'sql = sql & " INNER JOIN SCA_ALUNO AL ON AL.COD_EMPRESA = AT.COD_EMPRESA AND AL.CODIGO = AT.COD_ALUNO"
                        'sql = sql & " AND AT.ANO_LETIVO = T.AnoLetivo AND AT.SEMESTRE = T.Cod_Semestre"
                        'sql = sql & " where AT.COD_EMPRESA = " &  Session("CodEmpresa")
                        'sql = sql & " and T.Cod_Turma = " & intCodTurma
                        'sql = sql & " order by AT.CODIGO desc"
                        
                        end if
                        
                        ' 2 - Não Curricular	-->> 2 - Colaborador
                        ' Busca todos os colaboradores, com situacao Ativo
                        if intTipoAvaliacao =  2 and intTipoConsulta = 2 then
                        
                        sql = "SELECT TOP 1 Codigo, cod_empresa, Nome From SRH_COLABORADOR" 
                        sql = sql & " 	Where cod_empresa = " & session("CodEmpresa")
                        sql = sql & " 	And Situacao = 'A'"
                        if intCodCategoria <> 0 then
                        sql = sql & " 	And CodCategoria = " & intCodCategoria
                        end if
                        
                        end if
                        
                        rs.open sql, cnn
                        if not rs.eof then 
                        
                        While not rs.eof 
                        
                        if intTipoAvaliacao =  1 and intTipoConsulta = 1 then
                        
                        strCodTurma			= rs("Cod_Turma") 
                        strTurma			= rs("NomeTurma")
                        intCodDisciplina 	= rs("Cod_Disciplina")
                        strDisciplina 		= rs("DISCIPLINA")
                        
                        sql = " SELECT DISTINCT C.CODIGO, C.NOME FROM SCA_HORARIO_AULA HA"
                        sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.COD_EMPRESA = HA.COD_EMPRESA AND C.CODIGO = HA.Cod_Colaborador"
                        sql = sql & " WHERE HA.COD_EMPRESA = " & session("CodEmpresa")
                        sql = sql & " AND HA.ANOLETIVO = " & intAnoLetivo 
                        sql = sql & " AND HA.SEMESTRE = " & intSemestre
                        sql = sql & " AND HA.cod_Turma = " & intCodTurma
                        sql = sql & " and HA.Cod_Disciplina = " & intCodDisciplina
                        rsAux.open sql, cnn
                        if not rsAux.eof then 
                        strNome 			= rsAux("NOME")	
                        else
                        strNome 			= ""
                        end if 	
                        rsAux.close
                        end if
                        
                        if intTipoAvaliacao =  2 and intTipoConsulta = 1 then
                        strCodTurma			= rs("COD_TURMA") 
                        strTurma			= rs("NOMETURMA")
                        intCodAluno 		= ""
                        end if
                        
                        if intTipoAvaliacao =  2 and intTipoConsulta = 2 then
                        strDisciplina 	= ""
                        strNome 		= rs("Nome")	
                        intCodAluno 	= rs("Codigo")
                        strCurso		= ""
                        strTurma		= ""
                        end if
                        
                        sql = "SELECT Codigo, Cod_Avaliacao_Institucional, Descricao, Tipo_Pergunta, Subtitulo"
                        sql = sql & " FROM SAV_AVALIACAO_PERGUNTA "
                        sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
                        sql = sql & " And Cod_Avaliacao_Institucional = " & intCodAvaliacaoInstitucional
                        rsAux.open sql, cnn
                        if not rsAux.eof then
                        %>
                        <table width = "91%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                        <%
                        if intTipoAvaliacao =  1 and intTipoConsulta = 1 or intTipoAvaliacao =  2 and intTipoConsulta = 1 then
                        %>
                        <tr bgcolor="#E5E5E5">
                        <td width="11%" height="21" class="celula"><strong>TURMA: </strong></td>
                        <td width="21%" height="21" class="celula"><%=strTurma%></td>
                        <td width="15%" height="21" class="celula"><strong>PROFESSOR(A) : </strong></td>
                        <td height="21" colspan="6" class="celula"><%=strNome%>&nbsp;</td>
                        </tr>
                        <tr bgcolor="#E5E5E5">
                        <td height="21" class="celula"><strong>DISCIPLINA</strong>:</td>
                        <td height="21" colspan="8" class="celula"><%=strDisciplina%>&nbsp;</td>
                        </tr>
                        <%
                        end if
                        %>
                        <tr bgcolor="#E5E5E5">
                        <td height="21" colspan="4" class="celula">&nbsp;</td>
                        <td colspan="5" align="center" class="celula"><strong>Conceito</strong></td>
                        </tr>
                        <tr bgcolor="#E5E5E5">
                        <td height="21" colspan="4" class="celula">&nbsp;&nbsp;</td>
                        <td width="5%" align="center" class="celula"><strong>A</strong></td>
                        <td width="5%" align="center" class="celula"><strong>B</strong></td>
                        <td width="5%" align="center" class="celula"><strong>C</strong></td>
                        <td width="5%" align="center" class="celula"><strong>D</strong></td>
                        <td width="5%" align="center" class="celula"><strong>E</strong></td>
                        </tr>
                        <%
                        while not rsAux.eof
                        
                        intCodItemAvaliacao = rsAux("codigo")
                        strTipo_pergunta 	= rsAux("Tipo_Pergunta")
                        
                        strMarca	= ""
                        strMarcaA 	= ""
                        strMarcaB 	= ""
                        strMarcaC 	= ""
                        strMarcaD 	= ""
                        strMarcaE 	= ""
                        
                        
                        if trim(rsAux("Subtitulo")) <> "" then
                        %>
                        <tr bgcolor="#E5E5E5">
                        <td height="21" colspan="9" class="celula"><strong><%=trim(rsAux("Subtitulo"))%></strong></td>
                        </tr>
                        <%
                        end if 
                        if strTipo_pergunta = "O" then
                        %>
                        <tr>
                        <td height="21" colspan="4" class="celula">
                        <input name="chkAvaliacao" type="hidden" id="chkAvaliacao" value="<%=intCodItemAvaliacao%>" checked <%=strDesabilitaAluno%> >
                        <input name="txtCodDisciplina_<%=cont%>" value="<%=intCodDisciplina%>"  type="hidden" class="text" id="txtCodDisciplina" size="5"><%=trim(rsAux("Descricao"))%></td>
                        <td height="21" align="center" class="celula"><input name="optConceito_<%=cont%>" type="radio" value="A" <%=strMarcaA%>></td>
                        <td height="21" align="center" class="celula"><input name="optConceito_<%=cont%>" type="radio" value="B" <%=strMarcaB%>></td>
                        <td height="21" align="center" class="celula"><input name="optConceito_<%=cont%>" type="radio" value="C" <%=strMarcaC%>></td>
                        <td height="21" align="center" class="celula"><input name="optConceito_<%=cont%>" type="radio" value="D" <%=strMarcaD%>></td>
                        <td height="21" align="center" class="celula"><input name="optConceito_<%=cont%>" type="radio" value="E" <%=strMarcaE%>></td>
                        </tr>
                        <%
                        else
                        %>
                        <tr>
                        <td height="21" colspan="9" class="celula">
                        <input name="chkAvaliacao" type="hidden" id="chkAvaliacao" value="<%=intCodItemAvaliacao%>" checked <%=strDesabilitaAluno%> >
                        <input name="txtCodDisciplina_<%=cont%>" value="<%=intCodDisciplina%>"  type="hidden" class="text" id="txtCodDisciplina" size="5"><%=trim(rsAux("Descricao"))%>               </td>
                        </tr>
                        <tr>
                          <td height="30" colspan="9" class="celula"><textarea name="txtResposta_<%=cont%>" cols="100" rows="2" class="text" id="txtResposta"><%=strResposta%></textarea></td>
                        </tr>
                        <tr>
                        <td height="30" colspan="9" class="celula">&nbsp;</td>
                        </tr>
                        <%
                        end if
                        cont = cont + 1 
                        rsAux.movenext
                        wend
                        rsAux.close
                        else
                        rsAux.close 	
                        end if
                        rs.movenext
                        wend
                        end if
                        %>
                        </table></td>
                        </tr>
                        <tr>
                        <td colspan="4"  border="1" class="celula"><%=strRodape%></td>
                        </tr>
                        <tr>
                        <td colspan="4" class="texto1">&nbsp;</td>
                        </tr>
                        <tr>
                        <td colspan="4" class="texto1">
                        <%if intCodAvaliacaoInstitucional <> 0 then %>
                        <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                        <%end if%>	  </td>
                        </tr>
                        <tr>
                        <td colspan="4" class="texto1">&nbsp;</td>
                        </tr>
                      </table>
                  </div>
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
      <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
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
            
            var frm = document.getElementById("frm");
            
            if (frm.cmbAvaliacaoInstitucional.value == "0"){
                alert("A Avaliação deve ser informada.");
                frm.cmbAvaliacaoInstitucional.focus();
                return false;
            }
        
            frm.action = "NotasAvaliacao_cod.asp?acao=" + acao;
            frm.submit();
            
            return true;	
        }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 