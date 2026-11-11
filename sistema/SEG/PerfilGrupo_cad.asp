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
		strPaginaTitulo 			= "PerfilGrupo_cad.asp"
		strExecutarSubmitGrupo 		= "S"
		strExecutarSubmitPerfil 	= "S"
		strExecutarSubmitSistema 	= "S"
	
		intCodigo			= Trim(Request.Form("txtCodigo"))
		intCodGrupo			= Trim(Request("cmdGrupo"))
		if intCodGrupo = "" then intCodGrupo = "0"
		intCodPerfil		= Trim(Request.Form("cmbPerfil"))
		if intCodPerfil = "" then intCodPerfil = "0"
		intCodSistema		= Trim(Request.Form("cmdSistema"))
		if intCodSistema = "" then intCodSistema = "0"
			
		if trim(intCodigo) <> "" then
		
			sql = "SELECT *"
			sql = sql & " FROM seg_perfil_grupo"
			sql = sql & " where codigo = " & intCodigo
			rs.open sql, cnn
			if rs.eof = false then
				
				intCodGrupo			= rs("cod_grupo")
				intCodPerfil		= rs("cod_perfis_sistema")
				
				strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
				strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Perfil Grupo</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input type="hidden" name="txtCodigo" id="txtCodigo" value="<%=intCodigo%>">
                    <div class="form-group">
                        <label class="form-label">Grupo</label>
                         <!--#include file="../includes/inc_cmdGrupo.asp" -->
                    </div>
                   
                    <div class="form-group">
                        <label class="form-label">Sistema</label>
                         <!--#include file="../includes/inc_cmdSistema.asp" -->
                    </div>
                    
                     <div class="form-group">
                        <label class="form-label">Perfil</label>
                         <!--#include file="../includes/inc_cmdPerfil.asp" -->
                    </div>
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
       <%
			cont =0
			if intCodGrupo = "" then intCodGrupo = 0
			if intCodGrupo <> "0" then 
			%>
                <div class="panel panel-grey margin-bottom-40">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Perfil Grupo</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="5%" bgcolor="#95A5A6">Código</th>
                                    <th width="31%" bgcolor="#95A5A6">Grupo</th>
                                    <th width="18%" bgcolor="#95A5A6">Sistema</th>
                                    <th width="41%" bgcolor="#95A5A6">Perfil</th>
                                    <th width="5%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                                </tr>
                            </thead>
                            <%
							sql = "select pg.codigo, g.descricao as grupo, s.PERF_DESC as perfil, PERF_SIST_SIGL "
							sql = sql & " from seg_perfil_grupo pg"
							sql = sql & " inner join seg_grupo g on g.codigo = pg.cod_grupo"
							sql = sql & " inner join seg_perfis_sistema s on s.PERF_CODG = pg.cod_perfis_sistema where 1=1"	
							
							if intCodGrupo <> "0" then
								sql = sql & " and pg.cod_grupo = " & intCodGrupo
							end if
							sql = sql & " ORDER BY 	2,3"
							rs.open sql, cnn

							cont=0
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
							%>
                            <tbody>
                                <tr>
                                    <td><%=trim(rs("codigo"))%></td>
                                    <td><%=trim(rs("grupo"))%></td>
                                    <td><%=trim(rs("PERF_SIST_SIGL"))%></td>
                                    <td><%=trim(rs("perfil"))%></td>
                                    <td align="center" >
                                    <button class="btn-u btn-u-sea" onClick="resultadoConsulta(<%=trim(rs("codigo"))%>)" type="button"><i class="fa fa-file-text-o"></i></button>  
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
                <%end if %>
       <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
    <script>
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmdGrupo.value == "0") {
			alert("Grupo deve ser informado !");
			frm.cmdGrupo.focus();
			return false;
		}
		
		if (frm.cmbPerfil.value == "0") {
			alert("Perfil deve ser informado !");
			frm.cmbPerfil.focus();
			return false;
		}
		
		frm.action="PerfilGrupo_cod.asp?acao=" + acao;
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