<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../menuModulos.asp"-->  
<script src="../../js/js_funcoes_gerais.js"></script>
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Gerencial</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strPaginaTitulo 	= "Bimestre_cad.asp"
        intCodigo	 		= Trim(Request.Form("txtCodigo"))
        strDescricao 		= Trim(Request.Form("txtDescricao"))
        strDescricaoAntiga	= Trim(Request.Form("txtDescricaoAntiga"))
        strPeriodo			= Trim(Request.Form("txtPeriodo"))
    
        strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
        if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
        intSemestre 			= Trim(Request.Form("cmbSemestre"))
        if intSemestre = "" then 	intSemestre  = session("strSemestre")
            
        if trim(intCodigo) <> "" then
        
            sql = "SELECT codigo, periodo, descricao, ano_letivo, semestre"
            sql = sql & " FROM SCA_bimestre"
            sql = sql & " where codigo = " & intCodigo
            rs.open sql, cnn
            
            if rs.eof = false then
                
                strDescricao				= rs("descricao")
                strDescricaoAntiga			= rs("descricao")
                strPeriodo					= rs("periodo")
                strAnoLetivo 				= Trim(rs("Ano_Letivo"))
                if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
                intSemestre 				= Trim(rs("Semestre"))
                if intSemestre = "" then 	intSemestre  = session("strSemestre")
                
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
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Tabela Bimestral</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" class="text" id="txtCodigo" value="<%=intCodigo%>" size="10">
                    
                    <div class="form-group">
                        <label class="form-label">Ano</label>
                         <input name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" style="width:50pt" value="<%=strAnoLetivo%>" size="80" maxlength="100" onblur="submit()">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Semestre</label>
                         <!--#include file="../includes/inc_cmdSemestre.asp" -->
                    </div>

                    <div class="form-group">
                        <label class="form-label">Descrição</label>
						 <input name="txtDescricaoAntiga" type="hidden" class="text" id="txtDescricaoAntiga" size="50" maxlength="50" value="<%=strDescricaoAntiga%>"></td>
						<select name="txtDescricao" id="txtDescricao" style="width:150pt" class="form-control" <%=strFuncao%>>
							<option value="1º BIMESTRE" <%IF strDescricao = "1º BIMESTRE" THEN RESPONSE.WRITE "SELECTED"%>>1º BIMESTRE</option>			
							<option value="2º BIMESTRE" <%IF strDescricao = "2º BIMESTRE" THEN RESPONSE.WRITE "SELECTED"%>>2º BIMESTRE</option>			
							<option value="3º BIMESTRE" <%IF strDescricao = "3º BIMESTRE" THEN RESPONSE.WRITE "SELECTED"%>>3º BIMESTRE</option>
							<option value="4º BIMESTRE" <%IF strDescricao = "4º BIMESTRE" THEN RESPONSE.WRITE "SELECTED"%>>4º BIMESTRE</option>
						</select>
						 
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Per&iacute;odo:</label>
                         <input name="txtPeriodo" type="text" class="form-control" id="txtPeriodo" style="width:350pt" value="<%=strPeriodo%>" size="80" maxlength="100" >
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
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Tabela Bimestral</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="3%" bgcolor="#95A5A6">#</th>
                                    <th width="41%" bgcolor="#95A5A6">Descrição</th>
                                    <th width="47%" bgcolor="#95A5A6">Data</th>
                                    <th width="9%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                                </tr>
                            </thead>
                            <%
							
							cont =0
							sql = "SELECT codigo, periodo, descricao, ano_letivo, semestre"
							sql = sql & " FROM SCA_bimestre"
							sql = sql & " where ano_letivo = " & strAnoLetivo		
								
							if intSemestre <> "0" then
								sql = sql & " and semestre in (" & intSemestre & ")"
							End if
							
							sql = sql & " Order by descricao"

							rs.open sql, cnn
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
							%>
                            <tbody>
                                <tr>
                                    <td><%=trim(rs("Codigo"))%></td>
                                    <td><%=trim(rs("Descricao"))%></td>
                                     <td><%=trim(rs("Periodo"))%></td> 
                                    <td align="center" >
                                    <button class="btn-u btn-u-sea" onclick="resultadoConsulta(<%=trim(rs("Codigo"))%>)" type="button"><i class="fa fa-file-text-o"></i></button> 
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
		
		if (frm.txtDescricao.value == "") {
			alert("A Descrição deve ser informada!");
			frm.txtDescricao.focus();
			return false;
		}
		if (frm.txtPeriodo.value == "") {
			alert("O Período deve ser informado!");
			frm.txtPeriodo.focus();
			return false;
		}
		
		frm.action="Bimestre_cod.asp?acao=" + acao;
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