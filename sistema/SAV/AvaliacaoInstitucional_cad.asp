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
        strPaginaTitulo 				= "AvaliacaoInstitucional_cad.asp"
        intCodigo						= Trim(Request.Form("txtCodigo"))
        strDescricao 					= Trim(Request.Form("txtDescricao"))
        intAnoLetivo					= Trim(Request.Form("txtAnoLetivo"))
        intSemestre 					= Trim(Request.Form("txtSemestre"))
        intTipoAvaliacao 				= Trim(Request.Form("cmbTipoAvaliacao"))
        strSimouNao                     = Trim(Request.Form("cmbSimouNao"))
        intTipoConsulta					= Trim(Request.Form("cmbTipoConsultaAvaliacao"))
        strSituacao						= Trim(Request.Form("cmbSituacao"))
        strObservacao	                = Trim(Request.Form("txtObservacao"))
        strRodape	                    = Trim(Request.Form("txtRodape"))
        if strSimouNao = "" then
           strSimouNao      = "N"
        end if   
        
        if trim(intCodigo) <> "" then
        
            sql = "SELECT Codigo, Cod_empresa, Descricao, Ano_Letivo, Semestre, Tipo_Avaliacao, Tipo_Consulta, Situacao, observacoes, rodape, Publicar"
            sql = sql & " FROM SAV_AVALIACAO_INSTITUCIONAL"
            sql = sql & " Where Codigo = " & intCodigo
            sql = sql & " And cod_empresa = " & Session("CodEmpresa")			
            rs.open sql, cnn
            
            if rs.eof = false then
                intCodigo	 			= rs("Codigo")
                strDescricao			= rs("Descricao")
                intAnoLetivo			= rs("Ano_Letivo")
                intSemestre				= rs("Semestre")
                if intTipoAvaliacao = "0" then
                   intTipoAvaliacao		= rs("Tipo_Avaliacao")
                end if   
                intTipoConsulta			= rs("Tipo_Consulta")
                strSituacao				= rs("Situacao")
                strObservacao			= rs("Observacoes")
                strRodape				= rs("Rodape")
                strSimouNao				= rs("Publicar")
                    
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
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Avaliação Institucional</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                	
                    <div class="form-group">
                        <label class="form-label">Ano/Semestre:</label>
                        <input name="txtAnoLetivo" value="<%=intAnoLetivo%>" onKeyPress="return formataCampo(this, 2, 6)" style="width:50pt"  type="text" class="form-control" id="txtAnoLetivo" size="4" maxlength="4">	
                        /
                        <input name="txtSemestre" value="<%=intSemestre%>" onKeyPress="return formataCampo(this, 2, 6)"  style="width:50pt"  type="text" class="form-control" id="txtSemestre" size="3" maxlength="1">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Descri&ccedil;&atilde;o</label>
                        <input name="txtDescricao" type="text" class="form-control" id="txtDescricao" style="width:350pt" size="100" maxlength="100" value="<%=strDescricao%>">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Tipo Avalia&ccedil;&atilde;o</label>
                        <!--#include file="../includes/inc_cmdTipoAvaliacaoInstitucional.asp" -->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Tipo Consulta</label>
                        <!--#include file="../includes/inc_cmdTipoConsultaAvaliacao.asp" -->
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Publicar</label>
                        <select name="cmbSimouNao" class="form-control" id="cmbSimouNao"  style="width:70pt" >
                        <option value="0">Selecione...</option>
                        <option value="S" <%if strSimouNao = "S" then response.Write("selected") %>>SIM</option>
                        <option value="N" <%if strSimouNao = "N" then response.Write("selected") %>>NAO</option>
                        </select>  
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Situa&ccedil;&atilde;o</label>
                        <!--#include file="../includes/inc_cmdSituacao.asp" -->
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Observa&ccedil;&otilde;es com m&aacute;ximo de 3000 caractereso</label>
                       <textarea name="txtObservacao" cols="90" rows="5" class="form-control" id="txtObservacao"><%=strObservacao%></textarea>
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Rodap&eacute; com M&aacute;ximo 200 caracteres</label>
                        <textarea name="txtRodape" cols="90" rows="3" class="form-control" id="txtRodape"><%=strRodape%></textarea>
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
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Avaliação</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="5%" bgcolor="#95A5A6">Código</th>
                                    <th width="86%" bgcolor="#95A5A6">Ano/Semestre</th>
                                    <th width="86%" bgcolor="#95A5A6">Descrição</th>
                                    <th width="86%" bgcolor="#95A5A6">Situação</th>
                                    <th width="9%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                                </tr>
                            </thead>
                            <%
							sql = "SELECT Codigo, Cod_empresa, Descricao, Ano_Letivo, Semestre, Situacao"
							sql = sql & " FROM SAV_AVALIACAO_INSTITUCIONAL"
							sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
							sql = sql & " Order by Ano_Letivo, Semestre, Descricao"
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
								
								if rs("Situacao") = "A" then strSituacao = "Ativo" 
					  			if rs("Situacao") = "I" then strSituacao = "Inativo" 


							%>
                            <tbody>
                                <tr>
                                    <td><%=trim(rs("Codigo"))%></td>
                                    <td><%=trim(rs("Ano_Letivo"))%> / <%=trim(rs("Semestre"))%></td>
                                    <td><%=trim(rs("Descricao"))%></td>
                                    <td><%=trim(strSituacao)%></td>
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
		
		if (frm.txtAnoLetivo.value == ""){
			alert("O Ano Letivo deve ser informado.");
			frm.txtAnoLetivo.focus();
			return false;
		}
		
		if (frm.txtSemestre.value == ""){
			alert("O Semestre deve ser informado.");
			frm.txtSemestre.focus();
			return false;
		}
	
		if (frm.txtDescricao.value == "") {
			alert("A Descrição da Avaliação deve ser informada !");
			frm.txtDescricao.focus();
			return false;
		}
		
		if (frm.cmbTipoAvaliacao.value == "0") {
			alert("O Tipo da Avaliação deve ser informada !");
			frm.cmbTipoAvaliacao.focus();
			return false;
		}
	
		if (frm.cmbTipoConsultaAvaliacao.value == "0") {
			alert("O Tipo de consulta deve ser informada !");
			frm.cmbTipoConsultaAvaliacao.focus();
			return false;
		}
	
		if (frm.cmbSituacao.value == "0") {
			alert("A Situação deve ser informada !");
			frm.cmbSituacao.focus();
			return false;
		}
		
		frm.action="AvaliacaoInstitucional_cod.asp?acao=" + acao;
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