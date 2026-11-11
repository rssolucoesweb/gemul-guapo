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
        strExecutarSubmitGrupo = "S"
        strExecutarSubmitEmpresa = "S"
        
        intCodGrupo 		= Trim(Request("cmdGrupo"))
        intCodEmpresa 		= Trim(Request.Form("cmdEmpresa"))
        strCodAluno 		= Trim(Request.Form("txtCodAluno"))
        strLogin 			= Trim(Request.Form("txtLogin"))
        
        if intCodEmpresa = "" then intCodEmpresa = "0"
        if intCodGrupo = "" then intCodGrupo = "0"
        
        strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
        strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
        strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
        
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Consulta Log Aluno</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                    <div class="form-group">
                        <label class="form-label">Empresa</label>
                        <!--#include file="../includes/inc_cmdEmpresa.asp"-->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Cod. Aluno</label>
                        <input name="txtCodAluno" type="text" class="form-control" id="txtCodAluno" value="<%=strCodAluno%>" size="30" maxlength="30">
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Login</label>
                        <input name="txtLogin" type="text" class="form-control" id="txtLogin" value="<%=strLogin%>" size="30" maxlength="30">
                    </div>
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_consulta.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	 
     <%if intCodEmpresa <> "0" and strCodAluno <> "" or strLogin <> ""  then %>  
     <!--Table Bordered-->
     <div class="panel panel-grey margin-bottom-40">
        <div class="panel-heading">
            <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Log</h3>
        </div>
        <div class="panel-body">
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th width="7%" bgcolor="#95A5A6">Empresa</th>
                        <th width="11%" bgcolor="#95A5A6">Login</th>
                        <th width="16%" bgcolor="#95A5A6">Data</th>
                        <th width="66%" bgcolor="#95A5A6">SQL</th>
                  </tr>
                </thead>
                <%
			   	cont =0
						
				sql = " SELECT * FROM SEG_LOG"
				sql = sql & " WHERE COD_EMPRESA = " & intCodEmpresa
				
				if strCodAluno <> "" then 
					sql = sql & " AND SQL LIKE '%" & strCodAluno & "%'"
				end if
				
				if strLogin <> "" then 
					sql = sql & " AND login_Usuario = '" & strLogin & "'"
				end if
				
				sql = sql & " Order by dataLog"

                rs.open sql, cnn
                cont=0
                if rs.eof = false then
                
                while not rs.eof
					cont = cont + 1	
					sql = mid(rs("sql"),1,100)
                %>
                <tbody>
                    <tr>
                        <td><%=trim(rs("cod_Empresa"))%></td>
                        <td><%=trim(rs("login_Usuario"))%></td>
                        <td><%=trim(rs("dataLog"))%></td>
                        <td><%=trim(sql)%></td> 
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
    <!--End Table Bordered-->	
    <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 