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
        strPagina			= "Configurar_Perfil_cad.asp"
        strSiglaSistema 	= Trim(Request("cmbSistemas"))
        intCodPerfil		= Trim(Request("cmbPerfil"))
        strSiglaModulo		= Trim(Request("cmbModulosSistema"))
        intCodMenu			= Trim(Request("cmbMenu"))
    
        ' Busca o Sistema 					
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
        
        ' Busca o Modulo
        if strSiglaSistema <> "" then
            sql = "SELECT Modu_Sist_Sigl, Modu_Sigl, Modu_Desc, Modu_Stat"
            sql = sql & " FROM SEG_MODULOS_SISTEMA"
            sql = sql & " WHERE Modu_Sist_Sigl = '" & strSiglaSistema  & "'"
        
            rs.open sql, cnn
                
            if rs.eof = false then
                strSiglaModulo		=	Trim(rs("Modu_Sigl"))
                strDescModulo		=	Trim(rs("Modu_Desc"))
            end if
            rs.close
        end if
        
        if intCodPerfil <> "" then
        
            sql = "SELECT Perf_Desc" 
            sql = sql & " FROM Seg_Perfis_Sistema"
            sql = sql & " WHERE Perf_Codg = " & intCodPerfil
            rs.open sql, cnn
            if rs.eof = false then
                strDescPerfil  = Trim(rs("Perf_Desc"))
            end if
            rs.close
        end if
        
        strDesabilitaIncluir = "" 'Desabilita o botão Incluir'
        strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
        strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
        strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
        
    %>
    <form method="post" id="frm">
  <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        <h3 class="panel-title"><i class="fa fa-tasks"></i>Configurar Perfil</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                
                <input name="txtCodItem" type="hidden" class="text" id="txtCodItem" value="<%=intCodItem%>" size="10">
                <input name="txtCodMenu" type="hidden" class="text" id="txtCodMenu"  value="<%=intCodMenu%>" size="10">
                <label>Sistema</label>
                <div class="form-group">
                <!--#include file="../includes/inc_cmdSistemas.asp"-->
                </div>
                <label>Módulo</label>
                <div class="form-group">
                <!--#include file="../includes/inc_cmdModulosSistema.asp"-->
                </div>
                <label>Perfil</label>
                <div class="form-group">
                <!--#include file="../includes/inc_cmdPerfil.asp"-->
                </div>
                <label>Menu</label>
                <div class="form-group">
                <!--#include file="../includes/inc_cmdMenus.asp"-->
                </div>
                <legend></legend>
                <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
       <% if intCodMenu <> "" and strSiglaModulo  <> "" then %>
                <div class="panel panel-grey margin-bottom-40">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class="fa fa-globe"></i>Item Menu</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                  <th width="5%" bgcolor="#95A5A6"><input name="chkTodos" type="checkbox" value="" onClick="return marcaTodos()"></th>
                                    <th width="49%" bgcolor="#95A5A6">Descri&ccedil;&atilde;o Item </th>
                                  <th width="46%" bgcolor="#95A5A6">Tipo Permiss&atilde;o</th>
                              </tr>
                            </thead>
                            <%
							sql = "SELECT Item_Codg, Item_Desc"
							sql = sql & " FROM SEG_ITENS_SISTEMA"
							sql = sql & " WHERE Item_Menu_Codg = " & intCodMenu
							sql = sql & " AND Item_Menu_Modu_Sigl = '" & strSiglaModulo & "'" 
							sql = sql & " AND ITEM_SIST_SIGL = '" & strSiglaSistema & "'" 
							sql = sql & " ORDER BY Item_Desc"
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
							while not rs.eof
							
								strMarca  = ""
			strMarcaI = ""
			strMarcaA = ""
			strMarcaE = ""
			strMarcaC = ""
			
			sql = "SELECT Pite_Info_Permissao"
			sql = sql & " FROM Seg_Perfis_Itens_Sistema"
			sql = sql & " WHERE Pite_perf_Codg = " & intCodPerfil
			sql = sql & " AND Pite_Item_Codg = " & trim(rs("Item_Codg"))
			RsAux.open sql, cnn
	
				if RsAux.eof = false then
			
					strMarca = "checked"
					strTipoPermissao     = RsAux("Pite_Info_Permissao")
					
					if strTipoPermissao <> "" then  
						vetPermissao = split(strTipoPermissao, ",")			 
					end if
					
					if strTipoPermissao <> "" then
					
						for intContador = 0 to ubound(vetPermissao)
						
							strTipoPermissao 	= trim(vetPermissao(intContador))
							
							' Inclus&atilde;o
							if strTipoPermissao = "I" then
							strMarcaI = "checked"
							end if 
							
							' Altera&ccedil;&atilde;o
							if strTipoPermissao = "A" then
							strMarcaA = "checked"
							end if 
							
							' Exclus&atilde;o			
							if strTipoPermissao = "E" then
							strMarcaE = "checked"
							end if 
							
							' Consulta
							if strTipoPermissao = "C" then
							strMarcaC = "checked"
							end if 
						
						next
						end if 
						
					end if
					rsAux.close
					cont = cont + 1	
							
							%>
                            <tbody>
                                <tr>
                                    <td><input name="chkInserir" type="checkbox" value="<%=rs("Item_Codg")%>"<%=strMarca%>></td>
                                    <td><%=trim(rs("Item_Desc"))%></td>
                                    <td>
                                    <input name="chkTipoPermissao_<%=trim(rs("Item_Codg"))%>" type="checkbox" value="I"<%=strMarcaI%>>                    Inclus&atilde;o
                <input name="chkTipoPermissao_<%=trim(rs("Item_Codg"))%>" type="checkbox" value="A"<%=strMarcaA%>>                    Altera&ccedil;&atilde;o
                <input name="chkTipoPermissao_<%=trim(rs("Item_Codg"))%>" type="checkbox" value="E"<%=strMarcaE%>>                    Exclus&atilde;o               
                                    </td>
                                    
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
                <% end if %>
                <!--End Table Bordered-->	
       <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->	
    </form>	
    <script>
	function salvar(acao){
	
		var intContMarcado=0;
		var frm = document.getElementById("frm");
		
		if (frm.cmbSistemas.value == "0") {
			alert("O Sistema deve ser informado!");
			frm.cmbSistemas.focus();
			return false;
		} 
		
		if (frm.cmbModulosSistema.value == "0") {
			alert("A Sigla do Modulo deve ser informada!");
			frm.cmbModulosSistema.focus();
			return false;
		} 
		
		if (frm.cmbPerfil.value == "0") {
			alert("O Perfil deve ser informado!");
			frm.cmbPerfil.focus();
			return false;
		} 
		
		if (frm.cmbMenu.value == "0") {
			alert("O Menu deve ser informado!");
			frm.cmbMenu.focus();
			return false;
		} 
		
		frm.action="Configurar_Perfil_cod.asp?acao=" + acao;
		frm.submit();
		return true;	 

	}
	
	function marcaTodos(){

	  if(frm.chkTodos.checked == true){ 
		  if(!confirm("Deseja selecionar todos os registros?")){
				return false;    
		  }
		  for (var i = 0; i < frm.elements.length; i++) {
					//verifica todos os checkbox
					if (frm.elements[i].type == "checkbox"){				
						frm.elements[i].checked = true;				
					}
		  }
	  }else{
	  
		 if(!confirm("Deseja desmarcar todos os registros selecionados?")){
				return false;    
		  }
		  for (var i = 0; i < frm.elements.length; i++) {
					//verifica todos os checkbox
					if (frm.elements[i].type == "checkbox"){				
						frm.elements[i].checked = false;				
					}
		  }
	  }
	  return true;
	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 