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
    intCodigo				= Trim(Request.Form("txtCodigo"))
    strDescricao 			= Trim(Request.Form("txtDescricao"))
                        
    if intCodigo <> "" then
    
        strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
        strDesabilitaAlterar = "" 'Habilita o botão Alterar'
        strDesabilitaExcluir = "" 'Desabilita o botão Excluir'
        strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
    
        sql = "SELECT *"
        sql = sql & " FROM SEG_GRUPO"
        sql = sql & " where codigo = " & intCodigo
        rs.open sql, cnn
        
        if rs.eof = false then
            intCodigo			= Trim(rs("codigo"))
            strDescricao 		= Trim(rs("descricao"))
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
     <form method="post" id="frm" action="">
     <input name="txtCodEmpresa" type="hidden" id="txtCodEmpresa" class="text" size="10" value="<%=strCodigo%>" maxlength="10">
    <div class="container content">		
        <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
        <div class="panel-heading">
            <h3 class="panel-title"><i class="fa fa-globe"></i>Troca de Empresa</h3>
        </div>
        <div class="panel-body">
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th width="3%" bgcolor="#95A5A6">#</th>
                        <th width="31%" bgcolor="#95A5A6">CNPJ</th>
                        <th width="43%" bgcolor="#95A5A6">Raz&atilde;o Social</th>
                      <th width="23%" bgcolor="#95A5A6">Logo Marca</th>
                    </tr>
                </thead>
                <%
				sql = "SELECT Codigo, Cnpj, RazaoSocial, LOGOMARCA"
				sql = sql & " FROM SEG_EMPRESA"
				sql = sql & " Order by Codigo"
                rs.open sql, cnn
                cont=0
                if rs.eof = false then
                
                while not rs.eof
                
				cont = cont + 1	
				if isnull(rs("LOGOMARCA")) or rs("LOGOMARCA") = "" then
					caminhoLogo = "../../LogoMarcas/LogoEmpresa.gif"
				else
					caminhoLogo = "../../LogoMarcas/" & rs("Codigo") & "/" & rs("LOGOMARCA")
				end if
					
                %>
                <tbody>
                    <tr>
                        <td><input <%if trim(Session("CodEmpresa")) = trim(rs("codigo")) then%> checked<%end if%> name="codEmpresa" type="radio" value="<%=rs("Codigo")%>"></td>
                        <td><%=rs("Cnpj")%></td>
                        <td><%=trim(rs("Codigo"))%> - <%=trim(rs("RazaoSocial"))%></td>
                        <td><img src="<%=caminhoLogo%>" width="50" height="50"></td> 
                    </tr>
                </tbody>
                <%				
                    rs.movenext
                    wend
                end if
                rs.close
            %>
            </table>
            <br>
            <input type="button" name="cmdIncluir" style="cursor:hand"   value="Troca de Empresa" class="btn btn-success" onClick="return trocaEmpresa()">
			<input type="button" name="cmdPrincipal" style="cursor:hand"   value="Principal"  class="btn-u btn-u-default float-shadow" onClick="window.location='../principal.asp'">

        </div>                      
        </div>
        <!--End Table Bordered-->	
        <!-- Fecha o Painel do Formulario -->        
    </div>
    </form>
    <!--/container-->		
    <script>
		function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		
		frm.action="Empresa_cad.asp?txtCodEmpresa="+intCodigo;
		frm.submit();
	}
	
	function trocaEmpresa(){
	
		var frm = document.getElementById("frm");
		
		frm.action="TrocaEmpresa_cod.asp";
		frm.submit();
		return true;	 

	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 