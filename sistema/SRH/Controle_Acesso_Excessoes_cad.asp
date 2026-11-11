<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">SRH - Recurso Humano</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strUsuarioPortal 		= Trim(Request("txtUsuarioPortal"))
        intCodPerfil 			= Trim(Request("txtCodPerfil"))
        strDescPerfil 			= Trim(Request("txtDescPerfil"))
        strSiglaSistema			= Trim(Request("txtSiglaSistema"))
        intCodEmpresaUsuario 	= Trim(Request("cmdEmpresaUsuario"))
        intCodCategoria			= Trim(Request("cmbCategoria"))	
        intCodFuncao 	  		= TRIM(Request("cmbFuncao"))
        intCodTurno 			= TRIM(Request.Form("cmbTurnoRH"))
    
        
        if intCodEmpresaUsuario = "" then intCodEmpresaUsuario = "0"
        if strUsuarioPortal  = "" then strUsuarioPortal = "0"
        if intCodPerfil = "" then intCodPerfil = "0"
        if intCodEmpresaUsuario = "" then intCodEmpresaUsuario = "0"
       
        strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
        strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar'
        strDesabilitaExcluir = "" 'Desabilita o botão Excluir'
        strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
    
        sql = "SELECT Aces_Usua_Codg, Aces_Perf_Codg, Perf_desc, cod_categoria, Cod_funcao, Cod_turno"
        sql = sql & " FROM Seg_Acessos_Usuario_Excessoes, Seg_Perfis_Sistema  "
        sql = sql & " WHERE Aces_Perf_Codg = Perf_Codg "
        sql = sql & " AND Aces_Usua_Codg = '" & strUsuarioPortal & "'"
        sql = sql & " AND Cod_Empresa = " & intCodEmpresaUsuario
        
        rs.open sql, cnn
        if rs.eof = false then
            strDescPerfil 			= Trim(rs("Perf_desc"))
            strUsuarioPortal 		= Trim(rs("Aces_Usua_Codg"))
            intCodPerfil			= Trim(rs("Aces_Perf_Codg"))
            intCodCategoria			= Trim(rs("cod_categoria"))	
            intCodFuncao			= Trim(rs("Cod_funcao"))
            intCodTurno				= Trim(rs("Cod_turno"))
            
        end if	
        rs.close
        
        strDesabilitaIncluir = ""         ' Desabilita o botão Incluir
        strDesabilitaAlterar = "disabled" ' Desabilita o botão Alterar
        strDesabilitaExcluir = "" ' Desabilita o botão Excluir
        strDesabilitaLimpar  = ""         ' Habilita o Botão Limpar
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

                    <div class="form-group">
                        <label class="form-label">Login / Usu&aacute;rio</label>
                        <input readonly  name="txtUsuarioPortal" type="text" class="form-control" id="txtUsuarioPortal" value="<%=strUsuarioPortal%>" size="30" maxlength="30" onBlur="submit()">
                    	<button class="btn-u btn-u-sea" onClick="return abreConsulta('Usuario_Excessoes_con.asp')" type="button"><i class="fa fa-search"></i></button>  
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Unidade</label>
                        <!--#include file="../includes/inc_cmdEmpresaUsuario_Excessoes.asp"-->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Categoria</label>
                    	<!--#include file="../includes/inc_cmdCategoria.asp" -->
                    </div>

                    <div class="form-group">
                        <label class="form-label">Fun&ccedil;&atilde;o</label>
                         <!--#include file="../includes/inc_cmbFuncao.asp" -->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Turno</label>
                        <!--#include file="../includes/inc_cmbTurno.asp" -->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Perfil</label><br>
                        <!--#include file="../includes/inc_cmdPerfilGrupoExcessoes.asp" -->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Obs: Clicando em Excluir, todos perfis especiais para esse usu&aacute;rio ser&atilde;o exclu&iacute;dos.</label>
                    </div>
              
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
       <%if strUsuarioPortal <> "" and  strUsuarioPortal <> "0" then
	   
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
		if strUsuarioPortal <> "" then 
	    %>
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Perfil</h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="5%" bgcolor="#95A5A6">C&oacute;d.Perfil</th>
                          <th width="59%" bgcolor="#95A5A6">Desc. Perfil</th>
                          <th width="19%" bgcolor="#95A5A6">Modulo Sistema</th>
                          <th width="11%" bgcolor="#95A5A6">Unidade</th>
                          <th width="11%" bgcolor="#95A5A6">Fun&ccedil;&atilde;o</th>
                          <th width="11%" bgcolor="#95A5A6">Categoria</th>
                          <th width="11%" bgcolor="#95A5A6">Turno</th>
                          <th width="6%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                      </tr>
                    </thead>
                     <tbody>
                    <%
                    cont =0
					sql = "SELECT Aces_Usua_Codg, Perf_Codg, Perf_Sist_Sigl, Perf_Desc, "
					sql = sql & " SIST_DESC, MOD_DESCRICAO, SIST_STAT, "
					sql = sql & " (SELECT ISNULL(Desc_Turno,'Não Informado') FROM SRH_TURNO WHERE cod_Turno = Seg_Acessos_Usuario_Excessoes.Cod_Turno) as Turno, "
					sql = sql & " (SELECT Desc_Categoria FROM SRH_CATEGORIA WHERE Cod_Categoria = Seg_Acessos_Usuario_Excessoes.Cod_Categoria) AS categoria, "
					sql = sql & " (SELECT Desc_Funcao FROM SRH_FUNCAOCOLABORADOR WHERE Cod_Funcao = Seg_Acessos_Usuario_Excessoes.Cod_Funcao) AS funcao, "
					sql = sql & " (SELECT RAZAOSOCIAL FROM SEG_EMPRESA WHERE CODIGO = Seg_Acessos_Usuario_Excessoes.COD_EMPRESA) AS UNIDADE "
					sql = sql & " FROM Seg_Acessos_Usuario_Excessoes, Seg_Perfis_Sistema, "
					sql = sql & " Seg_Sistemas_informatica, SEG_MODULO"
					sql = sql & " WHERE Aces_Perf_Codg = Perf_Codg"
					sql = sql & " AND Seg_Perfis_Sistema.PERF_SIST_SIGL = SEG_SISTEMAS_INFORMATICA.SIST_SIGL"
					sql = sql & " AND Seg_Sistemas_informatica.MOD_COD = SEG_MODULO.MOD_COD"
					sql = sql & " AND SEG_SISTEMAS_INFORMATICA.SIST_STAT  = 'A'"
					sql = sql & " AND Aces_Usua_Codg = '" & strUsuarioPortal & "'"
					sql = sql & " AND Seg_Perfis_Sistema.Perf_Sist_Sigl = Seg_Sistemas_informatica.SIST_SIGL"
					'sql = sql & " AND Cod_Empresa = " & intCodEmpresaUsuario
					sql = sql & " ORDER BY Perf_Codg"
                    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
                        cont = cont + 1	
                    	%>
                        <tr>
                            <td><%=trim(rs("Perf_Codg"))%></td>
                            <td><%=trim(rs("Perf_Desc"))%></td>
                            <td><%=trim(rs("MOD_DESCRICAO"))%></td>
                            <td><%=trim(rs("UNIDADE"))%></td>
                            <td><%=trim(rs("funcao"))%></td>
                            <td><%=trim(rs("CATEGORIA"))%></td>
                            <td><%=trim(rs("TURNO"))%></td>
                            <td align="center" >
                            <button class="btn-u btn-u-sea" onClick="resultadoConsulta('<%=rs("Perf_Codg")%>','<%=rs("Perf_Sist_Sigl")%>')" type="button"><i class="fa fa-file-text-o"></i></button>                            </td> 
                        </tr>
                    	<%				
                        rs.movenext
                        wend
                    end if
                    rs.close
                	%>
                    	<tr>
                    		<td colspan="8">Total Registros : <%=cont%></td>
                    	</tr>
                    </tbody>
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
                alert("O Usuário deve ser informado !");
                frm.txtUsuarioPortal.focus();
                return false;
            }
            
            if (frm.cmdEmpresaUsuario.value == "0") {
                alert("A Unidade deve ser informada !");
                frm.cmdEmpresaUsuario.focus();
                return false;
            }
    
            if (frm.cmbFuncao.value == "0") {
                alert("A Função deve ser informada!");
                frm.cmbFuncao.focus();
                return false;
            }
    
            if (frm.cmbTurnoRH.value == "0") {
                alert("O Turno deve ser informado!");
                frm.cmbTurnoRH.focus();
                return false;
            }
    
            frm.action="Controle_Acesso_Excessoes_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 