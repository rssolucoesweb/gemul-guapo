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
	strPagina			= "Controle_Acesso_cad.asp"
	strUsuarioPortal 	= Trim(Request.Form("txtUsuarioPortal"))
	intCodPerfil		= Trim(Request.Form("cmbPerfil"))
	
	if strUsuarioPortal <> "" and intCodPerfil <> "" then
	
		strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
		strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar'
		strDesabilitaExcluir = "" 'Desabilita o botão Excluir'
		strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
	
		sql = "SELECT Aces_Usua_Codg, Aces_Perf_Codg, Perf_desc"
		sql = sql & " FROM Seg_Acessos_Usuario, Seg_Perfis_Sistema"
		sql = sql & " WHERE Aces_Perf_Codg = Perf_Codg "
		sql = sql & " AND Aces_Usua_Codg = '" & strUsuarioPortal & "'"
		sql = sql & " AND Aces_Perf_Codg = " & intCodPerfil
		rs.open sql, cnn
		
		if rs.eof = false then
			strDescPerfil 			= Trim(rs("Perf_desc"))
			strUsuarioPortal 		= Trim(rs("Aces_Usua_Codg"))
			intCodPerfil			= Trim(rs("Aces_Perf_Codg"))
		
		else
			rs.close
			
			sql = "SELECT Perf_desc"
			sql = sql & " FROM Seg_Perfis_Sistema"
			sql = sql & " WHERE Perf_Codg = " & intCodPerfil
			rs.open sql, cnn
			
			if rs.eof = false then
				strDescPerfil 	= Trim(rs("Perf_desc"))
			end if 
			
			strDesabilitaIncluir = "" ' Desabilita o botão Incluir
			strDesabilitaAlterar = "disabled" ' Desabilita o botão Alterar
			strDesabilitaExcluir = "disabled" ' Desabilita o botão Excluir
			strDesabilitaLimpar  = "" ' Habilita o Botão Limpar
		
		end if
		rs.close
	
	else
		strDesabilitaIncluir = ""         ' Desabilita o botão Incluir
		strDesabilitaAlterar = "disabled" ' Desabilita o botão Alterar
		strDesabilitaExcluir = "disabled" ' Desabilita o botão Excluir
		strDesabilitaLimpar  = ""         ' Habilita o Botão Limpar
	end if
	%>

     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Controle de Acesso</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
              
                    <label>Usuário</label>
                    <div class="form-label">
                    	<input name="txtUsuarioPortal" type="text" class="form-control" id="txtUsuarioPortal" value="<%=strUsuarioPortal%>" size="30" maxlength="30" onBlur="submit()" style="width:200pt">
                    	<button class="btn-u btn-u-sea" onClick="return abreConsulta('Usuario_con.asp')" type="button"><i class="fa fa-search"></i></button> 
                    </div>
                    
                    <label>Perfil</label>
                    <div class="form-label">
                    	<!--#include file="../includes/inc_cmdPerfil.asp"-->
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
                                  <th width="4%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                                </tr>
                            </thead>
                            <%
							sql = "SELECT Aces_Usua_Codg, Perf_Codg, Perf_Sist_Sigl, Perf_Desc, "
							sql = sql & " SIST_DESC, MOD_DESCRICAO, SIST_STAT"
							sql = sql & " FROM Seg_Acessos_Usuario, Seg_Perfis_Sistema, "
							sql = sql & " Seg_Sistemas_informatica, SEG_MODULO"
							sql = sql & " WHERE Aces_Perf_Codg = Perf_Codg"
							sql = sql & " AND Seg_Perfis_Sistema.PERF_SIST_SIGL = SEG_SISTEMAS_INFORMATICA.SIST_SIGL"
							sql = sql & " AND Seg_Sistemas_informatica.MOD_COD = SEG_MODULO.MOD_COD"
							sql = sql & " AND SEG_SISTEMAS_INFORMATICA.SIST_STAT  = 'A'"
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
                                    <td><%=trim(rs("Perf_Codg"))%></td>
                                    <td><%=trim(rs("Perf_Desc"))%></td>
                                    <td align="center"><%=UCASE(trim(rs("Perf_Sist_Sigl")))%></td>
                                    <td><%=trim(rs("SIST_DESC"))%></td>
                                    <td ><%=trim(rs("MOD_DESCRICAO"))%></td>
                                    <td align="center" >
                                    <button class="btn-u btn-u-sea" onClick="resultadoConsulta(<%=trim(rs("Perf_Codg"))%>)" type="button"><i class="fa fa-file-text-o"></i></button>  
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
		
		if (frm.txtUsuarioPortal.value == "") {
			alert("O Usuário deve ser informado!");
			frm.txtUsuarioPortal.focus();
			return false;
		} 
	
		if (frm.cmbPerfil.value == "0") {
			alert("O Perfil do Usuário deve ser informado!");
			frm.cmbPerfil.focus();
			return false;
		} 

		frm.action="Controle_Acesso_cod.asp?acao=" + acao;
		frm.submit();
		return true;	 

	}
	
	function resultadoConsulta(intCodPerfil){
		frm.cmbPerfil.value=intCodPerfil;
		frm.submit();
	}
	
	function abreConsulta(caminho){
		window.open(caminho,"abreConsulta","top=5,left=5,height=510,width=1000,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}	
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 