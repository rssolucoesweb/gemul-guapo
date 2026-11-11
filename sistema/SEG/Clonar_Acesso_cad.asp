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
        strDesabilitaIncluir = "" 'Desabilita o botão Incluir'
        strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar'
        strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir'
        strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
            
        strUsuarioPortal 	= Trim(Request("txtUsuarioPortal"))
        strUsuarioNovo 		= Trim(Request("txtUsuarioNovo"))
		
		if strUsuarioPortal <> "" then 
		
			sql = " SELECT Usua_Codg, Usua_Info_senha, Usua_Data_Ativacao, Usua_Stat, USUA_NOME_COMPLETO" 
			sql = sql & " FROM SEG_USUARIOS_SISTEMA"
			sql = sql & " WHERE Usua_Codg LIKE '%" &   strUsuarioPortal & "%'"
			rs.open sql, cnn
		
			if rs.eof = true then
				%>
				<script>
					alert("Usuário não cadastrado");
					frm.txtUsuarioPortal.value="";
					frm.submit();
				</script>
				<%
			end if	
			rs.close
		
		end if
						
		if strUsuarioNovo <> "" then 
		
			sql = " SELECT Usua_Codg, Usua_Info_senha, Usua_Data_Ativacao, Usua_Stat, USUA_NOME_COMPLETO" 
			sql = sql & " FROM SEG_USUARIOS_SISTEMA"
			sql = sql & " WHERE Usua_Codg LIKE '%" &   strUsuarioNovo & "%'"
			rs.open sql, cnn
		
			if rs.eof = true then
					%>
					<script>
					alert("Usuário sem permissão ou não esta cadastrado");
					frm.txtUsuarioNovo.value="";
					frm.submit();
				</script>
			<%
			end if	
			rs.close
		
		end if
    %>
     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Clonar  Acesso de Usu&aacute;rio</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
               	
                	<div class="form-group">
                        <label class="form-label">Usu&aacute;rio Origem</label>
                         <input name="txtUsuarioPortal" type="text" class="form-control" id="txtUsuarioPortal" value="<%=strUsuarioPortal%>" size="30" maxlength="30" onBlur="submit()" style="width:200pt">
                    	 <button class="btn-u btn-u-sea" onClick="return abreConsulta('Usuario_con.asp')" type="button"><i class="fa fa-search"></i></button> 
                    </div>
                
                    <div class="form-group">
                        <label class="form-label">Usu&aacute;rio Destino</label>
                          <input name="txtUsuarioNovo" type="text" class="form-control" id="txtUsuarioNovo" value="<%=strUsuarioNovo%>" size="30" maxlength="30" onBlur="submit()" style="width:200pt"> 
                    </div>
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
       <%if strUsuarioPortal <> "" then%>
                <div class="panel panel-grey margin-bottom-40">
                   <div class="panel-heading">
                        <h3 class="panel-title"><i class="fa fa-globe"></i>Lista de Acessos</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="7%" bgcolor="#95A5A6">C&oacute;d.Perfil</th>
                                    <th width="21%" bgcolor="#95A5A6">Desc. Perfil</th>
                                    <th width="6%" bgcolor="#95A5A6">Sigla</th>
                                    <th width="26%" bgcolor="#95A5A6">Descri&ccedil;&atilde;o</th>
                                    <th width="36%" bgcolor="#95A5A6">Modulo Sistema</th>
                                </tr>
                            </thead>
                            <%
							sql = "SELECT Aces_Usua_Codg, Perf_Codg, Perf_Sist_Sigl, Perf_Desc, SIST_DESC, MOD_DESCRICAO"
							sql = sql & " FROM Seg_Acessos_Usuario, Seg_Perfis_Sistema, Seg_Sistemas_informatica, SEG_MODULO"
							sql = sql & " WHERE Aces_Perf_Codg = Perf_Codg"
							sql = sql & " AND Seg_Sistemas_informatica.MOD_COD = SEG_MODULO.MOD_COD"
							sql = sql & " AND Aces_Usua_Codg = '" & strUsuarioPortal & "'"
							sql = sql & " AND Seg_Perfis_Sistema.Perf_Sist_Sigl = Seg_Sistemas_informatica.SIST_SIGL"
							sql = sql & " ORDER BY Perf_Codg"
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
							%>
                            <tbody>
                                <tr>
                                  <td height="25" class="celula"><%=trim(rs("Perf_Codg"))%></td>
                                  <td class="celula"><%=UCASE(trim(rs("Perf_Desc")))%></td>
                                  <td class="celula"><%=UCASE(trim(rs("Perf_Sist_Sigl")))%></td>
                                  <td class="celula"><%=trim(rs("SIST_DESC"))%></td>
                                  <td class="celula"><%=trim(rs("MOD_DESCRICAO"))%></td>
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
    <script>
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtUsuarioPortal.value == "") {
			alert("O Usuário do Portal deve ser informado!");
			frm.txtUsuarioPortal.focus();
			return false;
		} 
	
	
		if (frm.txtUsuarioNovo.value == "") {
			alert("O Usuário Novo deve ser informado!");
			frm.txtUsuarioNovo.focus();
			return false;
		} 
		
		frm.action="clonar_Acesso_cod.asp?acao=" + acao;
		frm.submit();
		return true;	 
	}
	function abreConsulta(caminho){
		window.open(caminho,"abreConsulta","top=5,left=5,height=600,width=1000,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}	
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 