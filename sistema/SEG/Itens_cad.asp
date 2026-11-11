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
	strPagina			= "Itens_cad.asp"
	intCodItem			= Trim(Request("txtCodItem"))
	strSiglaSistema 	= Trim(Request("cmbSistemas"))
	strSiglaModulo		= Trim(Request("cmbModulosSistema"))
	intCodMenu			= Trim(Request.Form("cmbMenu"))
	
	strDescItem			= Trim(Request.Form("txtDescItem"))
	strNome				= Trim(Request.Form("txtNome"))
	strURL				= Trim(Request.Form("txtURL")) 
	strURL_NOVO			= Trim(Request.Form("txtURL_NOVO")) 
	strURL_TESTE		= Trim(Request.Form("txtURL_TESTE")) 
	intNumPosicao		= Trim(Request.Form("txtNumPosicao"))	
	strSituacao			= Trim(Request.Form("cmbSituacao"))
	
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
	
							
	if intCodItem <> "" then
		
		strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
		strDesabilitaAlterar = "" 'Habilita o botão Alterar'
		strDesabilitaExcluir = "" 'Desabilita o botão Excluir'
		strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
										
		sql = "SELECT Item_Codg,  Item_Sist_Sigl , Item_Nome, Item_Desc, Item_Stat, "
		sql = sql & " Item_Info_Url, ITEM_INFO_URL_NOVO, ITEM_INFO_URL_TESTE, Item_Numr_Posicao"
		sql = sql & " FROM SEG_ITENS_SISTEMA"
		sql = sql & " WHERE Item_Sist_Sigl = '" & strSiglaSistema  & "'"
		sql = sql & " AND Item_Menu_Modu_Sigl = '" & strSiglaModulo  & "'"
		sql = sql & " AND Item_Menu_Codg = " & intCodMenu  & ""
		sql = sql & " AND Item_Codg = " & intCodItem 
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodItem				= Trim(rs("Item_Codg"))
			strDescItem				= Trim(rs("Item_Desc"))
			strNome					= Trim(rs("Item_Nome"))
			strURL					= Trim(rs("ITEM_INFO_URL"))
			strURL_NOVO				= Trim(rs("ITEM_INFO_URL_NOVO"))
			strURL_TESTE			= Trim(rs("ITEM_INFO_URL_TESTE"))
			intNumPosicao			= Trim(rs("Item_Numr_Posicao"))	
			strSituacao				= Trim(rs("Item_Stat"))

		else
			strDesabilitaIncluir = ""'Desabilita o botão Incluir
			strDesabilitaAlterar = "disabled" 'Desabilita o botão Alterar
			strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
			strDesabilitaLimpar  = "" 'Habilita o Botão Limpar
	
		end if
		rs.close
	else
		strDesabilitaIncluir = ""'Desabilita o botão Incluir
		strDesabilitaAlterar = "disabled" 'Desabilita o botão Alterar
		strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
		strDesabilitaLimpar  = "" 'Habilita o Botão Limpar
	end if
	%>

     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Itens</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
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
                     <label>Menu</label>
                    <div class="form-group">
                     <!--#include file="../includes/inc_cmdMenus.asp"-->
                    </div>
                    <label>Descrição Item</label>
                     <div class="form-group">
                    <input id="txtDescItem" name="txtDescItem" type="text"  value="<%=strDescItem%>"  size="50" class="form-control" maxlength="50" width="100" style="width:300pt">
                    </div>
                    <label>Nome</label>
                    <div class="form-group">
                    <input id="txtNome" name="txtNome" type="text"  value="<%=strNome%>"  size="50" class="form-control" maxlength="50" width="100" style="width:300pt">
                    </div>
                    <label>URL</label>
                    <div class="form-group">
                    <input id="txtURL" name="txtURL" type="text"  value="<%=strURL%>"  size="50" class="form-control" maxlength="50" width="100" style="width:300pt">
                    </div>
					<label>URL EM TESTE</label>
                    <div class="form-group">
                    <input id="txtURL_TESTE" name="txtURL_TESTE" type="text"  value="<%=strURL_TESTE%>"  size="50" class="form-control" maxlength="50" width="100" style="width:300pt">
                    </div>
					<label>URL EM PRODUÇÃO</label>
                    <div class="form-group">
                    <input id="txtURL_NOVO" name="txtURL_NOVO" type="text"  value="<%=strURL_NOVO%>"  size="50" class="form-control" maxlength="50" width="100" style="width:300pt">
                    </div>
					
                    <label>Posição</label>
                    <div class="form-group">
                    <input id="txtNumPosicao" name="txtNumPosicao" type="text"  value="<%=intNumPosicao%>"  size="10" class="form-control" maxlength="10" width="10" style="width:60pt">
                    </div>
                    <label>Situação</label>
                    <div class="form-group">
                    <select name="cmbSituacao" id="cmbSituacao" style="width:70pt" class="form-control">
                      <option value="0">Selecione...</option>
                      <option value="A" <%if strSituacao = "A" then response.Write("selected") %>>Ativo</option>
                      <option value="I" <%if strSituacao = "I" then response.Write("selected") %>>Inativo</option>
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
	 <% if strSiglaSistema <> "" and  strSiglaModulo <> "" and  intCodMenu <> "" then  %>
    <div class="panel panel-grey margin-bottom-40">
        <div class="panel-heading">
            <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Grupos</h3>
        </div>
        <div class="panel-body">
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th width="4%" bgcolor="#95A5A6">Itens</th>
                      <th width="20%" bgcolor="#95A5A6">Sistema</th>
                      <th width="33%" bgcolor="#95A5A6">Descri&ccedil;&atilde;o</th>
                      <th width="5%" bgcolor="#95A5A6">Ordem</th>
					  <th width="25%" bgcolor="#95A5A6">Página em</th>
					  <th width="10%" bgcolor="#95A5A6">Situação</th>
                      <th width="5%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                    </tr>
                </thead>
                <%
                sql = "SELECT Item_Codg,  Item_Sist_Sigl,ITEM_INFO_URL_NOVO, ITEM_INFO_URL_TESTE , Item_Nome, Item_Desc, Item_Stat, ITEM_NUMR_POSICAO"
                sql = sql & " FROM SEG_ITENS_SISTEMA"
                sql = sql & " WHERE Item_Sist_Sigl = '" & strSiglaSistema  & "'"
                sql = sql & " AND Item_Menu_Modu_Sigl = '" & strSiglaModulo  & "'"
                sql = sql & " AND Item_Menu_Codg = " & intCodMenu  & ""
                sql = sql & " ORDER BY Item_Stat, ITEM_NUMR_POSICAO"
                rs.open sql, cnn
                cont=0
                if rs.eof = false then
                
                while not rs.eof
                cont = cont + 1	
				corlinha=""
				sit = "Ativo"
				if rs("Item_Stat") = "I" then
					corlinha = " bgcolor='#FFB6C1' "
					sit = "Inativo"
				end if
				
				novo = ""
				if rs("ITEM_INFO_URL_NOVO") <> "" then
					novo = " produção "
				end if
				teste = ""
				if rs("ITEM_INFO_URL_TESTE") <> "" then
					teste = " teste "
				end if
				
                %>
                <tbody>
                    <tr <%=corlinha%>>
                        <td><%=trim(rs("Item_Codg"))%></td>
                        <td><%=trim(rs("Item_Sist_Sigl"))%></td>
                        <td><%=trim(rs("Item_Desc"))%></td>
                        <td><%=trim(rs("ITEM_NUMR_POSICAO"))%></td>
						<td><%=teste%> <%=novo%></td>
						<td><%=sit%></td>
                        <td align="center" >
                        <button class="btn-u btn-u-sea" onClick="resultadoConsulta(<%=trim(rs("Item_Codg"))%>)" type="button"><i class="fa fa-file-text-o"></i></button>  
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
	
			if (frm.cmbMenu.value == "0") {
				alert("O Menu deve ser informado!");
				frm.cmbMenu.focus();
				return false;
			} 
			
			if (frm.txtDescItem.value == "") {
				alert("A Descrição Item deve ser informada!");
				frm.txtDescItem.focus();
				return false;
			} 
			
			if (frm.txtNome.value == "") {
				alert("O Nome deve ser informado!");
				frm.txtNome.focus();
				return false;
			} 
			
			if (frm.txtURL.value == "") {
				alert("A URL deve ser informada!");
				frm.txtURL.focus();
				return false;
			} 
			
			if (frm.txtNumPosicao.value == "") {
				alert("A Posição deve ser informada!");
				frm.txtNumPosicao.focus();
				return false;
			} 
			
			if (frm.cmbSituacao.value == "0") {
				alert("A Situação deve ser informado!");
				frm.cmbSituacao.focus();
				return false;
			} 
	
			frm.action="Itens_cod.asp?acao=" + acao;
			frm.submit();
			return true;	 
	
	}
	
	function resultadoConsulta(intCodItem){
	
		var frm = document.getElementById("frm");
		frm.txtCodItem.value=intCodItem;
		frm.submit();
	
	}

	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 