<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"--> 
<!--#include file="../../includes/inc_replaceRequest.asp"-->
<!--=== Breadcrumbs ===-->
<div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Seguraça</h1>
            <ul class="pull-right breadcrumb">
                <li>Consulta de Usuários</li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%  
  	strExecutarSubmitEmpresa = "S"
	strUsuario  	= ReplaceRequest(trim(request.form("txtUsuario")))
	strNome			= ReplaceRequest(trim(request.form("txtNome")))
	intCodEmpresa	= ReplaceRequest(trim(request("cmdEmpresa")))
	
	if intCodEmpresa = "" then intCodEmpresa = 0
	
	%>

    <!--=== Content Part ===-->
   <form id="frm" class="margin-bottom-10" method="post">
    <div class="container content">		
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Consulta de Usuários</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
               
                    <div class="form-group">
                        <label class="form-label">Empresa</label>
                         <!--#include file="../includes/inc_cmdEmpresa.asp"-->
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Usu&aacute;rio</label>
                         <input name="txtUsuario" type="text" id="txtUsuario" class="form-control" value="<%=strUsuario%>" size="30" maxlength="50">
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Nome</label>
                         <input name="txtNome" type="text" id="txtNome" class="form-control" size="50" value="<%=strNome%>"  maxlength="50">
                    </div>
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_consulta1.asp"-->
                
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
        <!--Table Bordered-->
        <%if strUsuario <> "" or strNome <> "" or  intCodEmpresa <> "0" then %>
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Usuários</h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th width="5%" bgcolor="#95A5A6">Usuário</th>
                            <th width="86%" bgcolor="#95A5A6">Nome Completo</th>
                            <th width="86%" bgcolor="#95A5A6">Empresa</th>
                            <% if session("NivelPermissao") = "A" then %>
                                <th width="86%" bgcolor="#95A5A6">Master</th>
                                <th width="86%" bgcolor="#95A5A6">Gestor Fin.</th>
                                <th width="86%" bgcolor="#95A5A6">Gestor Sup.</th>
                                <th width="86%" bgcolor="#95A5A6">Gestor Manut.</th>
                            <% end if%>
                            <th width="86%" bgcolor="#95A5A6">Situação</th>
                            <th width="9%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                        </tr>
                    </thead>
                    <%
                    sql = " SELECT Usua_Codg, Usua_Info_senha, Usua_Data_Ativacao, Usua_Stat, USUA_NOME_COMPLETO, SEG_EMPRESA.RAZAOSOCIAL," 
                    sql = sql & " USUARIO_MASTER, GESTOR_FINANCEIRO, GESTOR_SUPORTE, GESTOR_MANUTENCAO"
                    sql = sql & " FROM SEG_USUARIOS_SISTEMA"
                    sql = sql & " LEFT JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO=SEG_USUARIOS_SISTEMA.COD_EMPRESA"
                    sql = sql & " WHERE 1 = 1"
					
                    if intCodEmpresa <> "0" then
                        sql = sql & " AND SEG_USUARIOS_SISTEMA.COD_EMPRESA = " & intCodEmpresa
                    end if 
                    
                    if strUsuario <> ""then
                        sql = sql & " AND Usua_Codg LIKE '" & strUsuario & "%'"
                    end if 
                    
                    if strNome <> ""then
                        sql = sql & " AND USUA_NOME_COMPLETO LIKE '" &   strNome & "%'"
                    end if 
                            
                    sql = sql & " ORDER BY Usua_Codg"
					
					rs.open sql, cnn
                    
                    cont=0
                    if rs.eof = false then
        
                    while not rs.eof
                    
                        strStatus = trim(rs("Usua_Stat"))
                        
                        if strStatus = "A" then
                            strStatus = "Ativo"
                        elseif strStatus = "I" then
                            strStatus = "Inativo"
                        end if
                        
                        cont = cont + 1		
        
                    %>
                    <tbody>
                        <tr>
                            <td><%=trim(rs("Usua_Codg"))%></td>
                            <td><%=trim(rs("USUA_NOME_COMPLETO"))%></td>
                            <td><%=trim(rs("RAZAOSOCIAL"))%></td>
                            <% if session("NivelPermissao") = "A" then %>
                                <td><%=trim(rs("USUARIO_MASTER"))%></td>
                                <td><%=trim(rs("GESTOR_FINANCEIRO"))%></td>
                                <td><%=trim(rs("GESTOR_SUPORTE"))%></td>
                                <td><%=trim(rs("GESTOR_MANUTENCAO"))%></td>
                            <%end if %>
                            <td><%=strStatus%></td>
                            <td><button class="btn-u btn-u-sea" onClick="resultadoConsulta('<%=trim(rs("Usua_Codg"))%>')" type="button"><i class="fa fa-file-text-o"></i></button> 
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
        <%end if%>
        <!-- Fecha o Painel do Formulario -->        
    </div>
    </form>
    <!--/container-->		
	<script>
        function resultadoConsulta(strUsuario){
            window.opener.frm.txtUsuarioPortal.value=strUsuario;
            window.opener.frm.submit();
            window.close();
        }

function Consulta(){
            frm.submit();
        }    </script>
    <!--#include file="../jsModulo.asp"-->
</body>
</html> 