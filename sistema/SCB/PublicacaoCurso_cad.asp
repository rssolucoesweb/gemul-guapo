	<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Biblioteca</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
<%
	strPagina 				= "PublicacaoCurso_cad.asp"
	intCodPublicacao		= Trim(Request.Form("txtCodigo"))
	
	'Dados da Publicação
	strTitulo 				= Trim(Request.Form("txtTitulo"))
	strSubTitulo 			= Trim(Request.Form("txtSubTitulo"))
		
	if trim(intCodPublicacao) <> "" then
	
		sql = "SELECT Cod_Publicacao, Cod_LocalizacaoGeografica, Cod_TipoPublicacao, Cod_Autoria, Cod_Editora, Cod_CDU, Cod_Periodicidade, "
		sql = sql & " Instituicao, Orientador, Curso, MesReferencia, Serie, Nota, CodTipoAquisicao, NumeroNotaFiscal, Fornecedor, CodGenero, "
		sql = sql & " Titulo, SubTitulo, LocalPublicacao, AnoPublicacao, EdicaoPublicacao, VolumePublicacao, ISBN, ISSN, DataInclusao, Etiqueta, "
		sql = sql & " NumPaginas, Origem, Destino, Resumo, DataContrato, Contato, Endereco, Bairro, Cidade, UF, CEP, Numero, Email"
		sql = sql & " FROM SCB_PUBLICACAO"
		sql = sql & " Where Cod_Publicacao = " & intCodPublicacao
		sql = sql & " And Cod_empresa = " & session("codEmpresa")
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodPublicacao			= rs("Cod_Publicacao")
			strTitulo 					= rs("Titulo")
			strSubTitulo 				= rs("SubTitulo")
			
			strDesabilitaIncluir		= "" 'Desabilita o botão Incluir
			strDesabilitaArtigo			= "disabled" 'Desabilita o botão Excluir
			strDesabilitaAlterar 		= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir		= "" 'Desabilita o botão Excluir
		
		else

			strDesabilitaIncluir		= "" 'Desabilita o botão Incluir
			strDesabilitaArtigo			= "disabled" 'Desabilita o botão Excluir
			strDesabilitaAlterar 		= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir		= "disabled" 'Desabilita o botão Excluir

		end if 
		rs.close

	else
	
		strDesabilitaIncluir		= "" 'Desabilita o botão Incluir
		strDesabilitaArtigo			= "disabled" 'Desabilita o botão Excluir
		strDesabilitaAlterar 		= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir		= "disabled" 'Desabilita o botão Excluir
	
	end if 
	
	if intCodPublicacao = "" then intCodPublicacao = 0
	%>
     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Publicação Curso</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                    <div class="headline"><h2>Consulta Publica&ccedil;&atilde;o</h2></div>
                                 
                    <div class="form-group">
                        <label class="form-label">Cód. Publicação</label>
                         <input name="txtCodigo" type="text" class="form-control" id="txtCodigo" value="<%=intCodPublicacao%>" size="30" maxlength="30" style="width:200pt">
                         <button class="btn-u btn-u-sea" onClick="return abreConsulta('Publicacao_con.asp')" type="button"><i class="fa fa-search"></i></button> 
                    </div>
                    
                    
                    <div class="headline"><h2>Dados Publica&ccedil;&atilde;o</h2></div>
                    
                    <div class="form-group">
                        <label class="form-label">Titulo</label>
                         <input name="txtTitulo" type="text" class="form-control" id="txtTitulo" style="width:350pt" value="<%=strTitulo%>" size="80" maxlength="100">
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Sub Titulo</label>
                         <input name="txtSubTitulo" type="text" class="form-control" id="txtSubTitulo" style="width:350pt" value="<%=strSubTitulo%>" size="80" maxlength="100">
                    </div>
                    
                    <%if intCodPublicacao <> "0" then %>
                         <!--Table Bordered-->
                        <div class="panel panel-grey margin-bottom-40">
                        <div class="panel-heading">
                            <h3 class="panel-title"><i class="fa fa-globe"></i>Dados Curso</h3>
                        </div>
                        <div class="panel-body">
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                      <th bgcolor="#95A5A6">Curso</th>
                                      <th colspan="2" align="center" bgcolor="#95A5A6"><strong>Classificaç&atilde;o</strong></th>
                                    </tr>
                                    <tr>
                                        <th bgcolor="#95A5A6">&nbsp;</th>
                                        <th width="19%" bgcolor="#95A5A6" align="center"><strong>B&aacute;sica</strong></th>
                                        <th width="19%" bgcolor="#95A5A6" align="center"><strong>Complementar</strong></th>
                                  </tr>
                                </thead>
                                <%
                              	sql = "SELECT  Cod_curso, Descricao"
								sql = sql & " FROM SCA_Curso "
								sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
								sql = sql & " And processo_seletivo = 'S'"
								sql = sql & " Order by Cod_curso"
                                rs.open sql, cnn
                                cont=0
                                if rs.eof = false then
                                
                                while not rs.eof
                                cont = cont + 1	
								
										strClassificacao = ""
						
										sql = " SELECT Cod_Empresa, Cod_Publicacao, Cod_Curso, Classificacao "
										sql = sql & " FROM SCB_PublicacaoCurso "
										sql = sql & " WHERE Cod_Publicacao = " & intCodPublicacao
										sql = sql & " AND Cod_Empresa = " &  Session("CodEmpresa")
										sql = sql & " AND Cod_Curso = " &  rs("Cod_Curso")
										rs1.open sql, cnn
										
										if not rs1.eof then 
											strClassificacao = rs1("Classificacao")	
										end if 	
										rs1.close

                                %>
                                <tbody>
                                    <tr>
                                        <td><input name="chkCurso" type="hidden" id="chkCurso" value="<%=rs("Cod_Curso")%>"><strong><%=trim(rs("Descricao"))%></strong></td>
                                        <td align="center" ><input name="txtClassificao_<%=cont%>" type="radio" value="B" <%if strClassificacao ="B" then response.Write("checked")%>></td> 
                                        <td align="center" ><input name="txtClassificao_<%=cont%>" type="radio" value="C" <%if strClassificacao ="C" then response.Write("checked")%>></td>
                                    </tr>
                                </tbody>
                                <%				
                                    rs.movenext
                                    wend
                                end if
                                rs.close
                            %>
                            </table>
                        </div>                      
                         </div>
                
                	<%end if%>
                    
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
      
                <!--End Table Bordered-->	
       <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
    <script>
	function abreConsulta(caminho){
		window.open(caminho,"abreConsulta","top=5,left=5,height=510,width=519,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}	
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
			
		if (frm.txtCodigo.value == "") {
			alert("O Codigo Publicação deve ser informado !");
			frm.txtCodigo.focus();
			return false;
		}

		if (frm.txtTitulo.value == "") {
			alert("O Titulo deve ser informado !");
			frm.txtTitulo.focus();
			return false;
		}
		
		if (frm.txtSubTitulo.value == "") {
			alert("O Sub Titulo deve ser informado !");
			frm.txtSubTitulo.focus();
			return false;
		}
		
		frm.action="PublicacaoCurso_cod.asp?acao=" + acao;
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