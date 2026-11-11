<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">SRH - Recurso Humano</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	
    <%
	strExecutarSubmitModulacaoReferencia        = "S"
	strPaginaTitulo                  			= "FaltaColaboradorDevolucao_cad.asp"
	strPagina						 			= "FaltaColaboradorDevolucao_cad.asp"
	intCodModulacaoReferencia 					= Trim(Request.form("cmbModulacaoReferencia"))
	strOptTipoColaborador     					= Trim(Request("optTipoColaborador"))
	if strOptTipoColaborador = "" then strOptTipoColaborador = "1"
	strDesabilitaIncluir 	= "" ' Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" ' Desabilita o botão Alterar
	strDesabilitaExcluir 	= "disabled" ' Desabilita o botão Excluir
	strDesabilitaLimpar  	= "" ' Habilita o Botão Limpar
	
	%>
    <!--=== Content Part ===-->
    <form id="frm" method="post">
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-tasks"></i>Lançamento de Faltas - Devolução</h3>
            </div>
            <!-- Inicia o Painel do Formulario -->     
        	<div class="panel-body">
             <!-- Inicia o Form -->     
            	<div class="panel-body">                                                        
                   
                    <table width="98%" border="0" cellspacing="0"  align="center" cellpadding="0">
                      <tr>
                        <td width="245" class="texto1">&nbsp;</td>
                        <td width="1062"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10"></td>
                      </tr>
                      <tr>
                        <td height="20" bgcolor="#CCCCCC" class="texto1">&nbsp;Tipo de Falta: </td>
                        <td valign="middle" bgcolor="#CCCCCC" class="texto1">
                    <input  <% if strOptTipoColaborador = "1" then response.Write("checked")%> name="optTipoColaborador" type="radio" value="1" onClick='submit()'>
                          Professor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <input <% if strOptTipoColaborador = "0" then response.Write("checked")%> name="optTipoColaborador" type="radio" value="0" onClick='submit()'>
                          Funcion&aacute;rio</td>
                      </tr>
                      <tr>
                        <td height="13" class="texto1">&nbsp;</td>
                        <td class="texto1">&nbsp;</td>
                      </tr>
                      <tr>
                        <td height="27" class="texto1">Refer&ecirc;ncia:</td>
                        <td class="texto1"><!--#include file="../includes/inc_PeriodoModulacao.asp" -->
                          - De: <%=formataDataAP(strDataInicialModulacao)%> a <%=formataDataAP(strDataFinalModulacao)%></td>
                      </tr>
                      <tr>
                        <td colspan="2"><p>
                          <%
                          
                         if intCodModulacaoReferencia <> "" and intCodModulacaoReferencia <> "0" then
                            cont =0
                            sql = " SELECT "
							sql = sql & " (SELECT TOP 1 CODIGO from SRH_COLABORADOR_FREQUENCIA " 
							sql = sql & " where ANO_LETIVO = CF.ANO_LETIVO "
							sql = sql & " and SEMESTRE_LETIVO = CF.SEMESTRE_LETIVO "
							sql = sql & " and Cod_JustificativaFaltas = CF.Cod_JustificativaFaltas "
							sql = sql & " and codReferencia = CF.CodReferencia "
							sql = sql & " and DATALANCAMENTO = CF.DATALANCAMENTO "
							sql = sql & " and DATALANCAMENTOFINAL = CF.DATALANCAMENTOFINAL "
							sql = sql & " and DataDiaLancamento = CF.DataDiaLancamento "
							sql = sql & " and COD_COLABORADOR = CF.COD_COLABORADOR "
							sql = sql & " and isnull(COD_TURMA,0) = isnull(CF.COD_TURMA,0) "
							sql = sql & " and ISNULL(COD_DISCIPLINA,'0') = ISNULL(CF.COD_DISCIPLINA,'0')) AS CODIGO, "
							
							sql = sql & " CF.ANO_LETIVO, " 
							sql = sql & " CF.SEMESTRE_LETIVO, " 
							sql = sql & " CF.Cod_JustificativaFaltas, " 
							sql = sql & " CF.CodReferencia, " 
							sql = sql & " CF.DATALANCAMENTO, " 
							sql = sql & " CF.DATALANCAMENTOFINAL, " 
							sql = sql & " CF.DataDiaLancamento, " 
							sql = sql & " CF.COD_COLABORADOR, " 
							sql = sql & " CF.TIPO_COLABORADOR, " 
							sql = sql & " CF.COD_TURMA, " 
							sql = sql & " T.NOMETURMA, " 
							sql = sql & " C.NOME, " 
							sql = sql & " D.DESC_DISCIPLINA , " 
							sql = sql & " isnull(CF.COD_DISCIPLINA,'0') as COD_DISCIPLINA , " 
							sql = sql & " CS.NOME AS COLABORADOR_SUBSTITUTO, " 
							sql = sql & " CF.NUMERO_AULA, " 
							sql = sql & " CF.CONTEUDO_SUBSTITUICAO, " 
							sql = sql & " CF.COD_TURNO, " 
							sql = sql & " TUR.DESC_TURNO AS TURNO, " 
							sql = sql & " CF.SITUACAO as STATUS, "
							sql = sql & " isnull(CF.fechamento,'') as fechamento,  "
							sql = sql & " SUM(CONVERT(INT, CF.NUMERO_FALTA)) AS NUMERO_FALTA "
							sql = sql & " from SRH_COLABORADOR_FREQUENCIA CF " 
							sql = sql & " LEFT JOIN SCA_TURMA T ON T.COD_TURMA=CF.COD_TURMA  "
							sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.CODIGO = CF.COD_COLABORADOR " 
							sql = sql & " LEFT JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = CF.COD_DISCIPLINA " 
							sql = sql & " LEFT JOIN SRH_COLABORADOR CS ON CS.CODIGO = CF.COD_COLABORADORSUBSTITUTO " 
							sql = sql & " LEFT JOIN SCA_TURNO TUR ON TUR.Cod_Turno = CF.Cod_Turno " 
							sql = sql & " WHERE CodColaboradorJustificativa is null and CF.COD_EMPRESA = " & session("CodEmpresa")
							if strOptListarFaltas = "1" then
								sql = sql & " and convert(datetime,convert(varchar, cf.DataFalta , 103),103) >= convert(datetime, ' " & strDataInicialModulacao & " ',103)"
								sql = sql & " and convert(datetime,convert(varchar, cf.DataFalta, 103),103) <= convert(datetime, ' " & strDataFinalModulacao & " ',103)"
							else
								sql = sql & " and convert(datetime,convert(varchar, cf.DATALANCAMENTO , 103),103) >= convert(datetime, ' " & strDataInicialModulacao & " ',103)"
								sql = sql & " and convert(datetime,convert(varchar, cf.DATALANCAMENTO, 103),103) <= convert(datetime, ' " & strDataFinalModulacao & " ',103)"
							end if
							if trim(strOptTipoColaborador) = "1" then
								sql = sql & " and CF.TIPO_COLABORADOR in ('P','0','1') "
							else
								sql = sql & " and CF.TIPO_COLABORADOR = 'F' "
							end if
							sql = sql & " group by " 
							sql = sql & " ANO_LETIVO, " 
							sql = sql & " SEMESTRE_LETIVO, " 
							sql = sql & " CF.Cod_JustificativaFaltas, " 
							sql = sql & " CF.CodReferencia, " 
							sql = sql & " CF.DATALANCAMENTO, " 
							sql = sql & " CF.DATALANCAMENTOFINAL, " 
							sql = sql & " CF.DataDiaLancamento, " 
							sql = sql & " CF.COD_COLABORADOR, " 
							sql = sql & " CF.TIPO_COLABORADOR, " 
							sql = sql & " CF.COD_TURMA, " 
							sql = sql & " T.NOMETURMA, " 
							sql = sql & " C.NOME, " 
							sql = sql & " D.DESC_DISCIPLINA , " 
							sql = sql & " CF.COD_DISCIPLINA ,  "
							sql = sql & " CS.NOME , " 
							sql = sql & " CF.NUMERO_AULA,  "
							sql = sql & " CF.CONTEUDO_SUBSTITUICAO,  "
							sql = sql & " CF.COD_TURNO, " 
							sql = sql & " TUR.DESC_TURNO ,  "
							sql = sql & " CF.SITUACAO , "
							sql = sql & " CF.fechamento "
							sql = sql & " order by CF.DATALANCAMENTO desc " 
                            'response.write sql
                            rs.open sql, cnn
                            if rs.eof then
                            %>
                             <table width = "100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                              <tr bgcolor="#E5E5E5">
                                <td height="46" align="center" class="celula"><strong>Não existem registros a serem devolvidos.</strong></td>
                               </tr>
                              </table>
                            <%
                            else
                       %>
                            <table width = "100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                              <tr bgcolor="#E5E5E5">
                                <td width="2%" align="center" class="celula"><input type="checkbox" name="chkTodos" onclick="return MarcaTodos(this.checked)"></td>
                                <td width="7%" class="celula"><strong>Lan&ccedil;amento</strong></td>
                                <td width="4%" class="celula"><strong>Tipo </strong></td>
                                <td width="5%" height="21" class="celula"><strong>Exerc&iacute;cio<span class="TextoForm"></span></strong></td>
                                <td width="4%" class="celula"><strong>Turma</strong></td>
                                <td width="29%" class="celula"><strong>Professor</strong></td>
                                <td width="11%" class="celula"><strong>Disciplina</strong></td>
                                <td width="3%" class="celula"><strong>Falta</strong></td>
                                <td width="12%" class="celula"><strong>Per&iacute;odo Lan&ccedil;amento</strong></td>
                                <td width="4%" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
                                <td width="13%" align="center" class="celula"><strong>Falta Enviada</strong></td>
                                <td width="6%" align="center" class="celula"><strong class="texto1">Devolver<br>Faltas</strong></td>
                              </tr>
                              <%
                       while not rs.eof
                       
                            cont = cont + 1	
                            strDataLancamento          = formatadataAp(rs("DATALANCAMENTO"))
                            strDataLancamentoFinal     = formatadataAp(rs("DATALANCAMENTOFINAL"))
                            strDataDiaLancamento	   = formatadataAp(rs("DataDiaLancamento"))
                            
                            strTipoColaborador         = rs("TIPO_COLABORADOR")
                            strNomeTurma 			   = rs("NOMETURMA")
                            strNomeColaborador   	   = rs("NOME")
                            if not isnull(rs("DESC_DISCIPLINA")) then
                                strDescDisciplina          = rs("DESC_DISCIPLINA")
                            else
                                strDescDisciplina          = "Interdisciplinar"
                            end if			
                            intNumeroFalta             = rs("NUMERO_FALTA")
                            strCodProfessorSubstituto  = rs("COLABORADOR_SUBSTITUTO")
                            strNumeroAula              = rs("NUMERO_AULA") 
                            strConteudoSubstituicao    = rs("CONTEUDO_SUBSTITUICAO")
                            if trim(rs("STATUS")) = "S" then
                                strSituacao = "ABONO"
                            else
                                strSituacao = "-----"
                            end if
                            if trim(strTipoColaborador) = "F" then
                               DescricaoTipoColaborador = "Func."
                            else  
                               DescricaoTipoColaborador = "Prof."
                            end if   
                            AnoLetivo = rs("ANO_LETIVO")
                            if rs("SEMESTRE_LETIVO") = "3" then
                               nomeSemestre = "Anual"
                            else  
                               nomeSemestre = intSemestre
                            end if  
                            if trim(rs("fechamento")) = "S" then
                                strEnviouFalta = "<strong>Sim</strong>"
                                strCorlinha = "C1FFC1"
                            else
                                strEnviouFalta = "Não"
                                strCorlinha = "FFFFFF"
                            end if
                             
                            %>
                              <tr bgcolor="#<%=strCorlinha%>">
                                <td align="center" class="celula"><input name="chkCodigo" type="checkbox" value="<%=rs("Codigo")%>" <%=strMarca%>></td>
                                <td class="celula">&nbsp;<%=strDataDiaLancamento%></td>
                                <td class="celula">&nbsp;<%=DescricaoTipoColaborador%></td>
                                <td height="20" class="celula">&nbsp;<%=AnoLetivo%>/<%=nomeSemestre%></td>
                                <td height="20" class="celula">&nbsp;<%=strNomeTurma%></td>
                                <td height="20" class="celula">&nbsp;<%=strNomeColaborador%></td>
                                <td height="20" class="celula">&nbsp;<%=strDescDisciplina%></td>
                                <td height="20" class="celula">&nbsp;<%=intNumeroFalta%></td>
                                <td height="20" class="celula">&nbsp;<%=strDataLancamento%> - <%=strDataLancamentoFinal%></td>
                                <td height="20" align="center" class="celula"><%=strSituacao%></td>
                                <td align="center" class="celula"><%=strEnviouFalta%></td>
                                <td align="center" class="celula">
                                <%if trim(rs("fechamento")) = "S" then%>
                                <a href="#" onclick="devolverFaltas()" ><img src="../../assets/img/botao_azul_normal.gif" alt="Devolução faltas" width="26" height="26" border="0"></a>
                                <%else%>
                                ------
                                <%end if%>
                                </td>
                              </tr>
                              <%				
                                rs.movenext
                           wend
                           rs.close
                           %>
                              <tr>
                                <td height="32" colspan="12" class="celula">Total Registros : <%=cont%></td>
                              </table>
                              <%   
                        end if   
                        
                        end if
                        
                        %></tr>
                    </table>
                  
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
        <!-- Fecha o Painel do Formulario -->        
    </div>
    </form>
    <!--/container-->		
	<script>	
        function devolverFaltas(){
            
            var intContMarcado =0;
            var intCodigo = "0";
    
            var frm = document.getElementById("frm");
        
            for (var i = 0; i < frm.elements.length; i++) 
            {
                //verifica todos os checkbox
                if (frm.elements[i].name.substring(0,9) == "chkCodigo"){				
                    if (frm.elements[i].checked) {
                        intContMarcado = intContMarcado + 1;
                        intCodigo = intCodigo + "," + frm.elements[i].value;
                    }
                }
            }
            
            if (intContMarcado==0){
                alert("ATENÇÃO: Pelo menos uma colaborador deve ser selecionado, Verifique!");
                return false;
            }
        
            var men = 'ATENÇÃO: Deseja devolver a falta desse(s) colaborador(es) selecionado?'
            if (confirm(men)) {
                frm.action="FaltaColaboradorDevolucao_cod.asp?devolverFalta=S&acao=ENVIAR";
                frm.submit();
                return true;
            } else {
                return false;
            }
        }
        function salvar(acao){
            
            var frm = document.getElementById("frm");
            
            var men = 'ATENÇÃO: Toda movimentação de faltas desta referência será devolvida para GESTOR da unidade, confirma?'
            if (confirm(men)) {
                frm.action="FaltaColaboradorDevolucao_cod.asp";
                frm.submit();
                return true;
            }
        }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 