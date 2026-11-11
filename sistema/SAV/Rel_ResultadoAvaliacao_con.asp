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
	strExecutarSubmit = "S"
	strSimouNao_submit = "S"
	strExecutarSubmitCurso = "S"
	strExecutarSubmitTurma =  "S"
	strPaginaTitulo = "Rel_ResultadoAvaliacao_con.asp"
	intCodAvaliacaoInstitucional   	= Trim(Request.Form("cmbAvaliacaoInstitucional"))
	intCodCurso        	            = Trim(Request.Form("cmbCurso"))
	intCodTurma 					= Trim(Request.Form("cmbTurma"))
	intCodDisciplinaTurma  			= trim(request("cmbDisciplinaTurma"))
	strQuestaoInicial         	    = Trim(Request.Form("txtQuestaoInicial"))
	strQuestaoFinal               	= Trim(Request.Form("txtQuestaoFinal"))
	strOpcaoRelatorio               = Trim(Request.Form("optOpcao"))
	strOpcaoGrafico                 = Trim(Request.Form("optOpcaoGrafico"))
	strSimouNao                     = Trim(Request.Form("cmbSimouNao"))
	if strOpcaoRelatorio = "" then
	   strSimouNao = "N"
	end if   
  
	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""

%>

    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i> Resultado das Avaliações</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                  <div class="form-group">
                        
                      <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2">
                     <tr>
                       <td class="texto1">Avalia&ccedil;&atilde;o:</td>
                       <td class="texto1"><!--#include file="../includes/inc_cmdAvaliacaoInstitucionalTodas.asp"--></td>
                       <td valign="top" class="texto1">&nbsp;</td>
                     </tr>
                     <%
                     if trim(intCodAvaliacaoInstitucional) <> "" then
                    
                        sql = "SELECT Tipo_Avaliacao, Tipo_Consulta, Ano_Letivo, semestre"
                        sql = sql & " FROM SAV_AVALIACAO_INSTITUCIONAL"
                        sql = sql & " Where Codigo = " & intCodAvaliacaoInstitucional
                        sql = sql & " And cod_empresa = " & Session("CodEmpresa")			
                        rs.open sql, cnn
                        if rs.eof = false then
                            intTipoAvaliacao		= rs("Tipo_Avaliacao")
                            intTipoConsulta			= rs("Tipo_Consulta")
                            intSemestre             = rs("semestre")
                            strAnoLetivo            = rs("Ano_Letivo")
                        end if 
                        rs.close
                    end if 
                    %>
                     
                     
                     <tr>
                       <td width="15%" class="texto1"><strong>Op&ccedil;&atilde;o de Relat&oacute;rio: </strong></td>
                       <td width="41%" class="texto1"><strong>
                         <input <% if strOpcaoRelatorio = "0" then response.Write("checked")%> name="optOpcao" type="radio" value="0" onClick='submit()'>
                         Frequ&ecirc;ncia quantitativa por Avalia&ccedil;&atilde;o <br>
                  <input <% if strOpcaoRelatorio = "1" then response.Write("checked")%> name="optOpcao" type="radio" value="1" onClick='submit()'>
                         Relat&oacute;rio da Discursiva
                         <br>
                  <br>
                       </strong></td>
                       <td width="42%" valign="top" class="texto1"><strong><br>
                         <br>
                       </strong></td>
                       </tr>
                    <% if strOpcaoRelatorio = "0" then %> 
                        <tr>
                          <td class="texto1">Gerar Gr&aacute;fico? </td>
                          <td colspan="3"><!--#include file="../includes/inc_cmbSimouNao.asp"-->
                            <strong><br>
                            </strong></td>
                        </tr>
                        
                    <% end if %>
                    <% if strSimouNao = "S" then %>	
                       <tr>
                       <td class="texto1">Tipo de Gr&aacute;fico: </td>
                       <td colspan="3" class="texto1"><strong>
                       <input  <% if strOpcaoGrafico = "1" then response.Write("checked")%> name="optOpcaoGrafico" type="radio" value="1" onClick='submit()'>
                Colunas 3D - <input <% if strOpcaoGrafico = "0" then response.Write("checked")%> name="optOpcaoGrafico" type="radio" value="0" onClick='submit()'>
                Pizza</strong></td>
                       </tr>
                    <% end if %> 
                
                    <% if (intTipoAvaliacao =  1 and intTipoConsulta = 1) or (intTipoAvaliacao =  2 and intTipoConsulta = 1)  then %>
                        <tr>
                          <td class="texto1">Curso:</td>
                          <td colspan="3"><!--#include file="../includes/inc_cmdCurso.asp"--></td>
                        </tr>
                        <tr>
                          <td class="texto1">Turma:</td>
                          <td colspan="2"><!--#include file="../includes/inc_cmdTurma.asp"--></td>
                          <td>&nbsp;</td>
                        </tr>
                    <% end if %>
                    <% if intTipoAvaliacao = 1 then %>
                        <tr>
                          <td class="texto1">Disciplina:</td>
                          <td colspan="2"><!--#include file="../includes/inc_cmbDisciplinaTurma.asp"--></td>
                          <td>&nbsp;</td>
                        </tr>
                    <% end if %>
                    <tr>
                      <td class="texto1">Classificar Quest&otilde;es:</td>
                      <td colspan="2"><span class="texto1">C&oacute;digo da quest&atilde;o Inicial:
                          <input  name="txtQuestaoInicial" type="text" class="form-control" id="txtQuestaoInicial" style="width:70pt" value="<%=strQuestaoInicial%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,3)">
                          - 
                           C&oacute;digo da quest&atilde;o Final:
                           <input  name="txtQuestaoFinal" type="text" class="form-control" style="width:70pt" id="txtQuestaoFinal" value="<%=strQuestaoFinal%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,3)">
                </span></td>
                      <td width="2%">&nbsp;</td>
                    </tr>
                    <%
                    if intCodAvaliacaoInstitucional <> "0" and intCodAvaliacaoInstitucional <> ""  then
                        sql = "SELECT Codigo, Cod_Avaliacao_Institucional, Subtitulo, Descricao, Tipo_Pergunta"
                        sql = sql & " FROM SAV_AVALIACAO_PERGUNTA"
                        sql = sql & " Where cod_empresa = " & Session("CodEmpresa")	
                        sql = sql & " And Cod_Avaliacao_Institucional = " & intCodAvaliacaoInstitucional
                        sql = sql & " Order by Codigo"
                        rs.open sql, cnn
                                    
                        if rs.eof = false then
                            %>
                            <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                            <tr bgcolor="#E5E5E5">
                            <td width="6%" class="celula"><strong>Ordem</strong></td>
                            <td width="7%" class="celula"><strong>Cod.Quest&atilde;o</strong></td>
                            <td width="71%" height="21" class="celula"><strong>Descri<span class="TextoForm">&ccedil;&atilde;o</span></strong></td>
                            <td width="16%" align="center" class="celula"><strong>Tipo Pergunta <span class="TextoForm"></span></strong></td>
                            </tr>
                            <%
                            while not rs.eof
                                cont = cont + 1	
                                if trim(rs("Subtitulo")) <> "" then
                                   %>
                                   <tr bgcolor="#E5E5E5">
                                   <td height="21" colspan="4" class="celula">&nbsp;&nbsp;<%=trim(rs("Subtitulo"))%></td>
                                   </tr>
                                   <%
                                end if   
                                if trim(rs("Tipo_Pergunta")) = "O" then
                                   strTipoPergunta = "Objetiva" 
                                elseif trim(rs("Tipo_Pergunta")) = "D" then
                                   strTipoPergunta = "Discursiva" 
                                end if
                                %>
                                <tr>
                                <td class="celula"><%=cont%></td>
                                <td align="center" class="celula"><%=trim(rs("Codigo"))%></td>
                                <td height="21" class="celula"><%=trim(rs("Descricao"))%></td>
                                <td height="21" align="center" class="celula"><%=strTipoPergunta%></td>
                                </tr>
                                <%				
                                rs.movenext
                            wend
                            %>
                            <tr>
                            <td height="21" colspan="4" class="celula">Total de Quest&otilde;es : <%=cont%></td>
                            </table>
                            <%
                       end if
                       rs.close
                    end if %>
                
                    <tr>
                      <td class="texto1">&nbsp;</td>
                      <td colspan="3">&nbsp;</td>
                    </tr>
                    
                    <tr>
                      <td colspan="4"><hr size="1" color="#CCCCCC"></td>
                    </tr>
                    <tr>
                      <td colspan="4"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->&nbsp;</td>
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
        function gerar(){
            
            var caminho;
            var frm = document.getElementById("frm");
            
            if (frm.optOpcao[0].checked==false && frm.optOpcao[1].checked==false) {
                alert("Opção de relatório deve ser informada !");
                frm.optOpcao[0].focus();
                return false;
            }
            
            if (frm.optOpcao[0].checked) {
                caminho = "Rel_ResumoQuantitativoAvaliacao_rel.asp"
            }	
            if (frm.optOpcao[1].checked) {
                caminho = "Rel_ResumoDiscursivoAvaliacao_rel.asp"
            }	
            frm.action = caminho;
            frm.submit();
            
            return true;	
        }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 