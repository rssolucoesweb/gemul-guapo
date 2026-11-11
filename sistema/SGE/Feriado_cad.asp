<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../menuModulos.asp"-->
 <!--#include file="../../includes/inc_formatadata.asp"-->
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
        strPaginaTitulo 	= "Feriado_cad.asp"
        intCodigo	 		= Trim(Request.Form("txtCodigo"))
        strDescricao 		= Trim(Request.Form("txtDescricao"))
        strDescricaoAntiga	= Trim(Request.Form("txtDescricaoAntiga"))
        strData				= Trim(Request.Form("txtData"))
    
        strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
        if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
        intSemestre 			= Trim(Request.Form("cmbSemestre"))
        if intSemestre = "" then 	intSemestre  = session("strSemestre")
            
        if trim(intCodigo) <> "" then
        
            sql = "SELECT codigo, data, descricao, ano_letivo, semestre"
            sql = sql & " FROM SCA_Feriado"
            sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
            sql = sql & " and codigo = " & intCodigo
            rs.open sql, cnn
            
            if rs.eof = false then
                
                strDescricao			= rs("descricao")
                strDescricaoAntiga		= rs("descricao")
                strData					= formatadataAP(rs("data"))
                strAnoLetivo 			= Trim(rs("Ano_Letivo"))
                if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
                intSemestre 			= Trim(rs("Semestre"))
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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Tabela de Feriados</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" class="text" id="txtCodigo" value="<%=intCodigo%>" size="10">
                    
                    <div class="form-group">
                        <label class="form-label">Ano</label>
                         <input name="txtAnoLetivo" type="text" onKeyPress="return formataCampo(this,2,10)" class="form-control" id="txtAnoLetivo" style="width:50pt" value="<%=strAnoLetivo%>" size="80" maxlength="100" onBlur="submit()">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Semestre</label>
                         <!--#include file="../includes/inc_cmdSemestre.asp" -->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Data</label>
                         <input name="txtData" type="text" class="form-control" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)"  id="txtData" value="<%=strData%>" size="20" maxlength="100" >
                    </div>
                                
                    <div class="form-group">
                        <label class="form-label">Descrição</label>
                         <input name="txtDescricao" type="text" class="form-control" id="txtDescricao" value="<%=strDescricao%>" size="80" maxlength="100">
                         <input name="txtDescricaoAntiga" type="hidden" class="text" id="txtDescricaoAntiga" size="40" maxlength="40" value="<%=strDescricaoAntiga%>">
                    </div>
                    
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
     </div>
   	   
       <!--Table Bordered-->
                <div class="panel panel-grey margin-bottom-40">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Feriados</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="5%" bgcolor="#95A5A6">#</th>
                                    <th width="86%" bgcolor="#95A5A6">Descrição</th>
                                    <th width="86%" bgcolor="#95A5A6">Data</th>
                                    <th width="9%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                                </tr>
                            </thead>
                            <%
							sql = " SELECT codigo, data, descricao, ano_letivo, semestre"
							sql = sql & " FROM SCA_feriado"
							sql = sql & " where cod_empresa = " & Session("CodEmpresa")		
							sql = sql & " and ano_letivo = " & strAnoLetivo	
									
							IF intSemestre <> "0" THEN
								sql = sql & " and semestre in (" & intSemestre & ")"
							END IF
							sql = sql & " Order by data"
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
							%>
                            <tbody>
                                <tr>
                                    <td><%=trim(rs("Codigo"))%></td>
                                    <td><%=trim(rs("Descricao"))%></td>
                                     <td><%=trim(formatadataAP(rs("data")))%></td> 
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
		
		if (frm.txtDescricao.value == "") {
			alert("A Descrição deve ser informada!");
			frm.txtDescricao.focus();
			return false;
		}
		if (frm.txtData.value == "") {
			alert("A Data deve ser informada!");
			frm.txtData.focus();
			return false;
		}
		
		frm.action="Feriado_cod.asp?acao=" + acao;
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