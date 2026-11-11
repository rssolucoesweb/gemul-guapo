<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <script src="../../ckeditor/ckeditor.js"></script>
	<script src="../../ckeditor/config.js"></script>
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Help</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%	
    intCodigo				= Trim(Request.Form("txtCodigo"))
    intCodModulo 			= Trim(Request.Form("cmbModulo"))
	strTitulo 				= Trim(Request.Form("txtTitulo"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strLinkTela 			= Trim(Request.Form("txtLinkTela"))
	strLinkVideo 			= Trim(Request.Form("txtLinkVideo"))
	strSituacao 			= Trim(Request.Form("cmbSituacao"))
                        
    if intCodigo <> "" then
    
        strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
        strDesabilitaAlterar = "" 'Habilita o botão Alterar'
        strDesabilitaExcluir = "" 'Desabilita o botão Excluir'
        strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
    
        sql = "SELECT *"
        sql = sql & " FROM Help_Sistema"
        sql = sql & " where Codigo = " & intCodigo
        rs.open sql, cnn
        
        if rs.eof = false then
            
			intCodigo			= Trim(rs("codigo"))
            intCodModulo 		= Trim(rs("CodModulo"))
		    strTitulo 			= Trim(rs("Titulo"))
  			strDescricao 		= Trim(rs("Descricao"))
		    strLinkTela 		= Trim(rs("LinkTela"))	
			strLinkVideo 		= Trim(rs("LinkVideo"))	
			strSituacao 		= Trim(rs("Situacao"))	
					
        else
            strDesabilitaIncluir = ""'Desabilita o botão Incluir
            strDesabilitaAlterar = "disabled" 'Desabilita o botão Alterar
            strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
            strDesabilitaLimpar  = "" 'Habilita o Botão Limpar
            strDescricao  			 = ""
        end if
        rs.close
    
    else
		strDesabilitaIncluir = ""'Desabilita o botão Incluir
		strDesabilitaAlterar = "disabled" 'Desabilita o botão Alterar
		strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
		strDesabilitaLimpar  = "" 'Habilita o Botão Limpar
		strDescricao   		 = ""
    end if
    %>
     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Help</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" class="text" id="txtCodigo" value="<%=intCodigo%>" size="10">
                   
                    <div class="form-group">
                        <label class="form-label">Modulo</label>
                         <!--#include file="../includes/inc_cmdModulo.asp"-->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Titulo</label>
                         <input name="txtTitulo" type="text" class="form-control" id="txtTitulo" style="width:350pt" value="<%=strTitulo%>" size="80" maxlength="100">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Descrição</label>
                        <Textarea class="ckeditor" cols="90"  id="txtDescricao" name="txtDescricao"><%=strDescricao%></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">link Tela</label>
                         <input name="txtLinkTela" type="text" class="form-control" id="txtLinkTela" style="width:350pt" value="<%=strLinkTela%>" size="80" maxlength="100">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">link Video</label>
                         <input name="txtLinkVideo" type="text" class="form-control" id="txtLinkVideo" style="width:350pt" value="<%=strLinkVideo%>" size="80" maxlength="100">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Situação</label>
                        <select name="cmbSituacao" class="form-control" id="cmbSituacao"  style="width:130pt">
                          <option value="A" <%if strSituacao = "A" then response.Write("selected") %>>Ativo</option>
                          <option value="I" <%if strSituacao = "I" then response.Write("selected") %>>Inativo</option>
                        </select>
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
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Helps</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="5%" bgcolor="#95A5A6">#</th>
                                    <th width="86%" bgcolor="#95A5A6">Descrição</th>
                                    <th width="86%" bgcolor="#95A5A6">Situação</th>
                                    <th width="9%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                                </tr>
                            </thead>
                            <%
							sql = "SELECT Codigo, Titulo, Situacao"
							sql = sql & " FROM Help_Sistema"
							sql = sql & " ORDER BY Codigo"
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
							
							if trim(rs("Situacao")) = "A" then
								strSituacao = "Ativo"
							else
								strSituacao = "Inativo"
							end if	
							%>
                            <tbody>
                                <tr>
                                    <td><%=trim(rs("Codigo"))%></td>
                                    <td><%=trim(rs("Titulo"))%></td>
                                    <td align="center"><%=trim(strSituacao)%></td>
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
			
			if (frm.cmbModulo.value == "0") {
				alert("O Modulo deve ser informado!");
				frm.cmbModulo.focus();
				return false;
			} 
			
			if (frm.txtTitulo.value == "") {
				alert("O Titilo deve ser informado!");
				frm.txtTitulo.focus();
				return false;
			}
		
			frm.action="Help_cod.asp?acao=" + acao;
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