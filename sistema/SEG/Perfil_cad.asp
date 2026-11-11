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
	strPagina				= "Perfil_cad.asp"
	strSiglaSistema 		= Trim(Request("cmbSistemas"))
	strDescSistema 			= Trim(Request.Form("txtDescSistema"))
	intCodPerfil			= Trim(Request.Form("txtCodPerfil"))
	strDescPerfil 			= Trim(Request.Form("txtDescPerfil"))
	strPublicar 			= Trim(Request.Form("cmbPublicar"))
							
	if strSiglaSistema <> "" then
		
		sql = "SELECT Sist_Stat, Sist_Desc "
		sql = sql & " FROM SEG_SISTEMAS_INFORMATICA"
		sql = sql & " WHERE Sist_Sigl = '" & strSiglaSistema & "'"
		rs.open sql, cnn
			
		if rs.eof = false then
			strSituacaoSist 	=	Trim(rs("Sist_Stat"))
			strDescSistema		=	Trim(rs("Sist_Desc"))
		end if
		rs.close
	end if
	
	if strSiglaSistema <> "" and intCodPerfil <> "" then
	
			strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
			strDesabilitaAlterar = "" 'Habilita o botão Alterar'
			strDesabilitaExcluir = "" 'Desabilita o botão Excluir'
			strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
	
			sql = "SELECT Perf_Codg, Perf_Sist_Sigl, Perf_Desc, Sist_Desc, Publicar"
			sql = sql & " FROM SEG_PERFIS_SISTEMA, SEG_SISTEMAS_INFORMATICA"
			sql = sql & " WHERE Perf_Sist_Sigl = Sist_Sigl "
			sql = sql & " AND Perf_Sist_Sigl = '" & strSiglaSistema  & "'"
			sql = sql & " AND Perf_Codg = " & intCodPerfil
			rs.open sql, cnn
			
			if rs.eof = false then
				
				intCodPerfil		= Trim(rs("Perf_Codg"))
				strDescSistema 		= Trim(rs("Sist_Desc"))
				strDescPerfil   	= Trim(rs("Perf_Desc"))
				strPublicar			= Trim(rs("Publicar"))
	
			else
				
				strDesabilitaIncluir = ""'Desabilita o botão Incluir
				strDesabilitaAlterar = "disabled" 'Desabilita o botão Alterar
				strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
				strDesabilitaLimpar  = "" 'Habilita o Botão Limpar
				strDescPerfil  			 = ""
			
			end if
			rs.close
	
	else
	
		strDesabilitaIncluir = ""'Desabilita o botão Incluir
		strDesabilitaAlterar = "disabled" 'Desabilita o botão Alterar
		strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
		strDesabilitaLimpar  = "" 'Habilita o Botão Limpar
		strDescPerfil   		 = ""
				
	end if
	%>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Perfil</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" class="text" id="txtCodigo" value="<%=intCodigo%>" size="10">
                        <label>Sistema</label>
                        <div class="form-group">
                          <!--#include file="../includes/inc_cmdSistemas.asp"-->
                        </div>
                        <input name="txtCodPerfil" type="hidden" class="text" id="txtCodPerfil" value="<%=intCodPerfil%>" size="10">
                        <label>Perfil </label>
                         <div class="form-group">
                        <input id="txtDescPerfil" name="txtDescPerfil" type="text"  value="<%=strDescPerfil%>"  size="50" class="form-control" maxlength="50" width="100" style="width:300pt">
                        </div>
                        <label>Publicar</label>
                        <div class="form-group">
                        <select name="cmbPublicar" id="cmbPublicar" style="width:80pt" class="form-control">
                            <option value="0">Selecione...</option>
                             <option value="S" <%if strPublicar = "S" then response.Write("selected") %>>Sim</option>
                             <option value="N" <%if strPublicar = "N" then response.Write("selected") %>>Não</option>
                        </select>
                        </div>
                        <br>
                        <legend></legend>
                    	<!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
       			<%if strSiglaSistema <> "" then %>
                <div class="panel panel-grey margin-bottom-40">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Perfil</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="10%" bgcolor="#95A5A6">Código Perfil</th>
                                    <th width="17%" bgcolor="#95A5A6">Sigla Sistema</th>
                                  <th width="20%" bgcolor="#95A5A6">Descri&ccedil;&atilde;o do  Sistema</th>
                                     <th width="29%" bgcolor="#95A5A6">Descri&ccedil;&atilde;o do  Perfil</th>
                                     <th width="12%" bgcolor="#95A5A6">Publicar</th>
                                  <th width="12%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                                </tr>
                            </thead>
                            <%
							sql = "SELECT Perf_Codg, Perf_Sist_Sigl, Perf_Desc, SIST_DESC, Publicar"
							sql = sql & " FROM SEG_PERFIS_SISTEMA, SEG_SISTEMAS_INFORMATICA "
							sql = sql & " WHERE SEG_PERFIS_SISTEMA.Perf_Sist_Sigl = SEG_SISTEMAS_INFORMATICA.SIST_SIGL"
							sql = sql & " AND SEG_PERFIS_SISTEMA.Perf_Sist_Sigl LIKE '%" & strSiglaSistema  & "%'"
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
                                    <td><%=trim(rs("Perf_Sist_Sigl"))%></td>
                                    <td><%=trim(rs("SIST_DESC"))%></td>
                                    <td><%=trim(rs("Perf_Desc"))%></td>
                                    <td><%=trim(rs("Publicar"))%></td>
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
		
		if ((acao=="I") || (acao=="A")) {
		
			if (frm.cmbSistemas.value == "0") {
				alert("O Sistema deve ser informado!");
				frm.cmbSistemas.focus();
				return false;
			} 
			
			if (frm.txtDescPerfil.value == "") {
				alert("A Descrição do Perfil deve ser informada!");
				frm.txtDescPerfil.focus();
				return false;
			} 
			
			if (frm.cmbPublicar.value == "0") {
				alert("Pulicar deve ser informado!");
				frm.cmbPublicar.focus();
				return false;
			} 
	
			frm.action="Perfil_cod.asp?acao=" + acao;
			frm.submit();
			return true;
		 }
		 
		 if (acao=="E"){
				
			var men = 'ATENÇÃO: Deseja realmente excluir este Perfil, Todos os Perfil Sistema relacionados ao Perfil será excluido também, Verifique!'
			if (confirm(men)) {
				frm.action="Perfil_cod.asp?acao=" + acao;
				frm.submit();
			} else {
				return false;
			}
	
		}	 
	
	}
	
	function resultadoConsulta(intCodPerfil){
	
		var frm = document.getElementById("frm");
		frm.txtCodPerfil.value=intCodPerfil;
		frm.submit();
			
	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 