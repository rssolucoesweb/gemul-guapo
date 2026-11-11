<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Seguran&ccedil;a</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%	
        strPagina			= "Sistemas_cad.asp"
        strSiglaSistema  	= Trim(Request.Form("txtSiglaSistema"))
        strDescSistema 		= Trim(Request.Form("txtDescSistema"))
        strMensagem			= Trim(Request.Form("txtMensagem"))
        strLogotipo			= Trim(Request.Form("txtLogotipo"))
        strSituacao			= Trim(Request.Form("optSituacao"))
        intCodModulo		= Trim(Request.Form("cmbModulo"))
                                
        if strSiglaSistema <> "" then
        
            sql = "SELECT Sist_Sigl, Sist_Desc, Sist_info_Mensagem, Sist_info_Logotipo,"
            sql = sql & " Sist_Stat, Mod_Cod" 
            sql = sql & " FROM SEG_SISTEMAS_INFORMATICA"
            sql = sql & " WHERE Sist_Sigl = '" & strSiglaSistema & "'"
            rs.open sql, cnn
            
            if rs.eof = false then
            
                strDescSistema 		= Trim(rs("Sist_Desc"))
                strMensagem			= Trim(rs("Sist_info_Mensagem"))
                strLogotipo			= Trim(rs("Sist_info_Logotipo"))
                strSituacao			= Trim(rs("Sist_Stat"))
                intCodModulo 		= Trim(rs("Mod_Cod"))
                
                strDesabilitaIncluir = "disabled"'Desabilita o botão Incluir
                strDesabilitaAlterar = "" 'Desabilita o botão Alterar
                strDesabilitaExcluir = "" 'Desabilita o botão Excluir
                strDesabilitaLimpar  = "" 'Habilita o Botão Limpar
                
            else
                
                strDesabilitaIncluir = ""'Desabilita o botão Incluir
                strDesabilitaAlterar = "disabled" 'Desabilita o botão Alterar
                strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
                strDesabilitaLimpar  = "" 'Habilita o Botão Limpar
    
            end if
            rs.close
        
        else
            
            strDesabilitaIncluir = ""'Desabilita o botão Incluir
            strDesabilitaAlterar = "disabled" 'Desabilita o botão Alterar
            strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
            strDesabilitaLimpar  = "" 'Habilita o Botão Limpar
            
            strDescSistema 		= ""
            strMensagem		 	= ""
            strSituacao			= ""
            intCodModulo		= ""
            
        end if
    %>
     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Sistemas</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                 <form method="post" id="frm">
                    <label>Sigla</label>
                    <div class="form-group">
                      <input id="txtSiglaSistema" name="txtSiglaSistema" type="text"  value="<%=strSiglaSistema%>"  size="10" class="form-control" maxlength="10" width="10" onBlur="submit()" style="width:100pt">
                    </div>
                    <label>Descri&ccedil;&atilde;o </label>
                    <div class="form-group">
                      <input id="txtDescSistema" name="txtDescSistema" type="text"  value="<%=strDescSistema%>"  size="50" class="form-control" maxlength="50" width="100" style="width:300pt">
                    </div>
                     <label>Mensagem</label>
                    <div class="form-group">
                      <input id="txtMensagem" name="txtMensagem" type="text"  value="<%=strMensagem%>"  size="50" class="form-control" maxlength="50" width="100" style="width:300pt">
                    </div>
                     <label>Modulo</label>
                    <div class="form-group">
                      <!--#include file="../includes/inc_cmdModulo.asp"-->
                    </div>
                    <label>Situação</label>
                    <div class="form-group">
                    <select name="cmbSituacao" id="cmbSituacao" style="width:70pt" class="form-control">
                    <option value="0">Selecione...</option>
                    <option value="A" <%if strSituacao = "A" then response.Write("selected") %>>Ativo</option>
                    <option value="I" <%if strSituacao = "I" then response.Write("selected") %>>Inativo</option>
                    <option value="D" <%if strSituacao = "D" then response.Write("selected") %>>Desabilitado</option>
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
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Sistemas</h3>
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
							sql = "SELECT Sist_Sigl, Sist_Desc, Sist_Stat "
							sql = sql & " FROM SEG_SISTEMAS_INFORMATICA"
							sql = sql & " ORDER BY Sist_Sigl"
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
							
							strSituacao = trim(rs("Sist_Stat"))
		
							if strSituacao = "A" then
								strSituacao = "Ativo"
							elseif strSituacao = "I" then
								strSituacao = "Inativo"
							elseif strSituacao = "D" then
								strSituacao ="Desabilitado"
							end if
		
							%>
                            <tbody>
                                <tr>
                                    <td><%=trim(rs("Sist_Sigl"))%></td>
                                    <td><%=trim(rs("Sist_Desc"))%></td>
                                    <td align="center"><%=trim(strSituacao)%></td>
                                    <td align="center" >
                                    <button class="btn-u btn-u-sea" onClick="return resultadoConsulta('<%=rs("Sist_Sigl")%>','<%=rs("Sist_Desc")%>')" type="button"><i class="fa fa-file-text-o"></i></button>  
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
	
		if (frm.txtSiglaSistema.value == "") {
			alert("A Sigla do Sistema deve ser informada!");
			frm.txtSiglaSistema.focus();
			return false;
		} 
		
		if (frm.txtDescSistema.value == "") {
			alert("A Descrição do Sistema deve ser informada!");
			frm.txtDescSistema.focus();
			return false;
		} 
		
		if (frm.txtMensagem.value == "") {
			alert("A Mensagem deve ser informada!");
			frm.txtMensagem.focus();
			return false;
		} 
		
		if (frm.cmbModulo.value == "0") {
			alert("O Modulo deve ser informado!");
			frm.cmbModulo.focus();
			return false;
		} 
		
		if (frm.cmbSituacao.value == "0") {
			alert("A Situação deve ser informada!!");
			frm.cmbSituacao.focus();
			return false;
		} 
		
		frm.action="Sistemas_cod.asp?acao=" + acao;
		frm.submit();
		return true;	
		
		} 
	
		function resultadoConsulta(strSigla, strDescSistema){
			var frm = document.getElementById("frm");
			frm.txtSiglaSistema.value=strSigla;
			frm.txtDescSistema.value=strDescSistema;
			frm.submit();
		}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 