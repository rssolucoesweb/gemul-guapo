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
	strExecutarSubmit				= "S"
	strPaginaTitulo 				= "AvaliacaoPergunta_cad.asp"
	intCodigo						= Trim(Request.Form("txtCodigo"))
	strSubtitulo 					= Trim(Request.Form("txtSubtitulo"))
	strDescricao 					= Trim(Request.Form("txtDescricao"))
	strTipoPerguntaAvaliacao		= Trim(Request.Form("cmbTipoPerguntaAvaliacao"))

	if Trim(Request.QueryString("CodAvaliacaoInstitucional")) <> "" then
		intCodAvaliacaoInstitucional	=Trim(Request.QueryString("CodAvaliacaoInstitucional"))
	else
		intCodAvaliacaoInstitucional	= Trim(Request.Form("cmbAvaliacaoInstitucional"))
	end if
	
	
	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, Cod_Avaliacao_Institucional, Subtitulo, Descricao, Tipo_Pergunta"
		sql = sql & " FROM SAV_AVALIACAO_PERGUNTA"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " And cod_empresa = " & Session("CodEmpresa")			
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo								= rs("Codigo")
			intCodAvaliacaoInstitucional	 		= rs("Cod_Avaliacao_Institucional")
			strSubtitulo							= trim(rs("Subtitulo"))
			strDescricao							= trim(rs("Descricao"))
			strTipoPerguntaAvaliacao				= trim(rs("Tipo_Pergunta"))
			
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			

		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
	
	if intCodAvaliacaoInstitucional = "" then intCodAvaliacaoInstitucional = 0
%>

    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Questões</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                	
                    <div class="form-group">
                        <label class="form-label">Avalia&ccedil;&atilde;o:</label>
                        <!--#include file="../includes/inc_cmdAvaliacaoInstitucional.asp" -->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Subt&iacute;tulo:</label>
                        <input name="txtSubtitulo" type="text" class="form-control" id="txtSubtitulo" style="width:300pt"  size="70" maxlength="100" value="<%=strSubtitulo%>">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Pergunta</label>
                        <input name="txtDescricao" type="text" class="form-control" id="txtDescricao" style="width:300pt" size="70" maxlength="250" value="<%=strDescricao%>">
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Tipo Pergunta</label>
                        <!--#include file="../includes/inc_cmdTipoPergundaAvaliacao.asp" -->
                    </div>
                    
                    <div class="form-group">
                        <label>Obs: Informar o subt&iacute;tulo somente quando houver a necessidade de quebrar um determinado assunto dentro do question&aacute;rio./label>
                    </div>
             
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
                <div class="panel panel-grey margin-bottom-40">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Questões</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="5%" bgcolor="#95A5A6">Ordem</th>
                                    <th width="29%" bgcolor="#95A5A6">Cod.Quest&atilde;o</th>
                                    <th width="28%" bgcolor="#95A5A6"><strong>Descri<span class="TextoForm">&ccedil;&atilde;o</span></strong></th>
                                    <th width="33%" bgcolor="#95A5A6"><strong>Tipo Pergunta <span class="TextoForm"></span></strong></th>
                                    <th width="5%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                                </tr>
                            </thead>
                            <%
							
							if intCodAvaliacaoInstitucional <> 0 then
			
							sql = "SELECT Codigo, Cod_Avaliacao_Institucional, Subtitulo, Descricao, Tipo_Pergunta"
							sql = sql & " FROM SAV_AVALIACAO_PERGUNTA"
							sql = sql & " Where cod_empresa = " & Session("CodEmpresa")	
							sql = sql & " And Cod_Avaliacao_Institucional = " & intCodAvaliacaoInstitucional
							sql = sql & " Order by Codigo"
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
								
								cont = cont + 1	
								if trim(rs("Subtitulo")) <> "" then
								   %>
								   <tr bgcolor="#E5E5E5">
								   <td height="21" colspan="5" class="celula">&nbsp;&nbsp;<%=trim(rs("Subtitulo"))%></td>
								   </tr>
								   <%
								end if   
								if trim(rs("Tipo_Pergunta")) = "O" then
								   strTipoPergunta = "Objetiva" 
								elseif trim(rs("Tipo_Pergunta")) = "D" then
								   strTipoPergunta = "Discursiva" 
								end if


							%>
                            <tbody>
                                <tr>
                                    <td><%=cont%></td>
                                    <td><%=trim(rs("Codigo"))%></td>
                                    <td><%=trim(rs("Descricao"))%></td>
                                    <td><%=strTipoPergunta%></td>
                                    <td align="center" >
                                    <button class="btn-u btn-u-sea" onClick="resultadoConsulta(<%=trim(rs("Codigo"))%>)" type="button"><i class="fa fa-file-text-o"></i></button> 
                                    </td> 
                                </tr>
                            </tbody>
                            <%				
								rs.movenext
								wend
							end if
							rs.close
							
						end if
						%>
                        </table>
                    </div>                      
                </div>
                <!--End Table Bordered-->	
       <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
    <script>
	function salvar(acao){
			
		var frm = document.getElementById("frm");
		
		if (frm.cmbAvaliacaoInstitucional.value == "0"){
			alert("A Avaliação deve ser informada.");
			frm.cmbAvaliacaoInstitucional.focus();
			return false;
		}
		
		if (frm.txtDescricao.value == "") {
			alert("A Pergunta deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		if (frm.cmbTipoPerguntaAvaliacao.value == "0"){
			alert("O Tipo de Pergunta deve ser informado.");
			frm.cmbTipoPerguntaAvaliacao.focus();
			return false;
		}
	
		frm.action="AvaliacaoPergunta_cod.asp?acao=" + acao;
		frm.submit();
		return true;
	
	}
	
	function resultadoConsulta(intCodigo){
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 