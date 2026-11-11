	<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Biblioteca</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strPaginaTitulo 		= "Rel_EtiquetasAcervo_con.asp"
        intCodModeloEtiqueta	= Trim(Request.Form("cmbModeloEtiqueta"))
        intCodCdu				= Trim(Request.Form("txtCdu"))
        strValidar				= Trim(Request.Form("cmbValidar"))
        strCutter				= Trim(Request.Form("cmbCutter"))
        intCodEmpresa			= Session("CodEmpresa")
        
        if request("ad") = "s" then
            if session("strCodPublicacaoExemplares") = "" then
                session("strCodPublicacaoExemplares") = request.form("txtAdicionar")
            else
                bolInsere = true
                vetCodPublicacaoExemplares	= split(session("strCodPublicacaoExemplares"),",")
                for i=0 to ubound(vetCodPublicacaoExemplares)
                    if trim(request.form("txtAdicionar")) = trim(vetCodPublicacaoExemplares(i)) then
                        bolInsere = false
                    end if
                next
                if bolInsere then
                    
                    IF  request.form("txtAdicionar") <> "" THEN
                        session("strCodPublicacaoExemplares") = session("strCodPublicacaoExemplares") & "," & request.form("txtAdicionar")
                    END IF
                end if
            end if
        end if
        
        if request("ad") = "e" then
            session("strCodPublicacaoExemplares") = ""
        end if
        
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Relatório Etiquetas de Identificação</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                <input name="txtAdicionar" type="hidden" id="txtAdicionar" />
                <div class="form-group">
                <label class="form-label">ATEN&Ccedil;&Atilde;O!</label>
                    Antes de imprimir configurar em seu navegador as margens:<br>
                    Esquerda: 7mm - Superior: 10mm <br>
                    Direita: 0mm - Inferior: 0
                 </div>
                <div class="form-group">
                <label class="form-label">Modelo da Etiqueta:</label>
                    <!--#include file="../includes/inc_cmbModeloEtiqueta.asp"-->
                 </div>
                <div class="form-group">
                <label class="form-label">CDU</label>
                    <input name="txtCdu" type="text" class="form-control" id="txtCdu" size="40" maxlength="40" value="<%=intCodCdu%>"   onBlur="submit()" style="width: 100pt" >
                 </div>
                 
                 <div class="form-group">
                 <label class="form-label">Incluir Cutter</label>
                    <select name="cmbCutter" class="form-control" id="cmbCutter"  style="width: 70pt" >
                    <option value="N" >N&Atilde;O</option>
                    <option value="S" >SIM</option>
                    </select>
                 </div>
                
                 <div class="form-group">
                 <label class="form-label">Validar Impress&atilde;o:</label>
                <select name="cmbValidar" class="form-control" id="cmbValidar"  style="width: 70pt" >
                <option value="N" >NÃO</option>
                <option value="S" >SIM</option>
                </select>
                 </div>
                <legend></legend>
                 <!--#include file="../../includes/inc_botoes_consulta.asp"-->
                <br>
                <legend></legend>
                ATENÇÃO! Para gerar o relatório clique no botão Gerar Relatório do carinho de Impressão, ele apare será quando alguma publicação for selecionada.
                </form>
            	</div></div>
                <%
				cont = 0
				if intCodCdu <> "" then   %>
                
                <!--Table Bordered-->
                <div class="panel panel-grey margin-bottom-40">
                <div class="panel-heading">
                	<h3 class="panel-title"><i class="fa fa-globe"></i>Publicação</h3>
                </div>
                <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th bgcolor="#95A5A6"><input type="checkbox" name="chkTodos" onClick="return marcaTodos(this.checked)"></th>
                          <th bgcolor="#95A5A6">Cod. Publicacao</th>
                          <th bgcolor="#95A5A6">Cod. Exemplar</th>
                          <th bgcolor="#95A5A6">Titulo</th>
                          <th bgcolor="#95A5A6">Autor</th>
                          <th bgcolor="#95A5A6">Edição</th>
                          <th bgcolor="#95A5A6">CDU</th>
                        </tr>
                    </thead>
                    <%
					'seleciona os Exemplares'					
					sql = "SELECT "
					sql = sql & " P.COD_PUBLICACAO, "
					sql = sql & " PE.COD_PUBLICACAOEXEMPLARES, "
					sql = sql & " P.TITULO, "
					sql = sql & " P.COD_CDU, "
					sql = sql & " P.EDICAOPUBLICACAO, "
					sql = sql & " PE.NUMERO_EXEMPLAR, "
					sql = sql & " CONVERT(VARCHAR, P.EDICAOPUBLICACAO) + ' ed. - v. ' + CONVERT(VARCHAR, P.VOLUMEPUBLICACAO) + ' - ex. ' + CONVERT(VARCHAR, PE.NUMERO_EXEMPLAR) as Edicao, "
					sql = sql & " E.RAZAOSOCIAL "
					sql = sql & " FROM SCB_PUBLICACAOEXEMPLARES PE "
					sql = sql & " INNER JOIN SCB_PUBLICACAO P ON P.COD_PUBLICACAO = PE.COD_PUBLICACAO "
					sql = sql & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = P.COD_EMPRESA "
					sql = sql & " WHERE P.COD_EMPRESA = " & session("CodEmpresa")
					sql = sql & " AND ETIQUETA = 'N' "
					sql = sql & " AND SUBSTRING(P.COD_CDU,1," & len(intCodCdu) & " ) = '" & intCodCdu & "'" 
					sql = sql & " ORDER BY P.TITULO, P.EDICAOPUBLICACAO  "
					rs.open sql, cnn
					if rs.eof = false then
						selecionado = "checked"
						while not rs.eof
							sql = " SELECT DISTINCT "
							sql = sql & " PA.COD_AUTOR, A.NOME_AUTOR "
							sql = sql & " FROM  SCB_PUBLICACAOAUTORES PA "
							sql = sql & " INNER JOIN SCB_AUTORES A ON A.COD_AUTOR = PA.COD_AUTOR "
							sql = sql & " WHERE PA.COD_PUBLICACAO = " & rs("COD_PUBLICACAO")
							rsaux.OPEN SQL, CNN
							IF not rsaux.EOF THEN
								strAutor 		= " " & rsaux("NOME_AUTOR")
							END IF
							rsaux.close
								%>
                                <tbody>
                                    <tr>
                                      <td><input type="checkbox" id="chkExemplares" name="chkExemplares" value="<%=rs("COD_PUBLICACAOEXEMPLARES")%>"></td>
                                      <td><%=rs("COD_PUBLICACAO")%></td>
                                        <td><%=rs("COD_PUBLICACAOEXEMPLARES")%></td>
                                        <td><%=rs("TITULO")%></td> 
                                        <td><%=strAutor%></td>
                                        <td><%=rs("EDICAOPUBLICACAO")%>ª</td>
                                        <td><%=rs("COD_CDU")%></td>
                                    </tr>
                                </tbody>
                                <%				
								selecionado = ""
								cont = cont + 1
								rs.movenext
								wend
			               end if
						rs.close
		        %>
                </table>
                </div>                      
                </div>
                </div>
                <%end if%>
                <br>
				<%if trim(session("strCodPublicacaoExemplares")) <> "" then   %>
                
                    <!--Table Bordered-->
                    <div class="panel panel-grey margin-bottom-40">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class="fa fa-globe"></i>Carrinho de Impress&atilde;o </h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                  <th bgcolor="#95A5A6">Cod. Publicacao</th>
                                  <th bgcolor="#95A5A6">Cod. Exemplar</th>
                                  <th bgcolor="#95A5A6">Titulo</th>
                                </tr>
                            </thead>
                            <%
                            sql = "select pe.Cod_Publicacao, pe.Cod_PublicacaoExemplares, p.titulo from scb_publicacao p"
                            sql = sql & " inner join scb_publicacaoExemplares pe on pe.Cod_Publicacao=p.Cod_Publicacao"
                            sql = sql & " where pe.Cod_PublicacaoExemplares in (" & session("strCodPublicacaoExemplares") & ")"
                            sql = sql & " and p.cod_Empresa=" & intCodEmpresa
                            rs.open sql, cnn
                            if not rs.eof then
                            while not rs.eof
                            cont = cont + 1	
                            %>
                            <tbody>
                                <tr>
                                <td><%=rs("Cod_Publicacao")%></td>
                                <td><%=rs("Cod_PublicacaoExemplares")%></td>
                                <td><%=rs("Titulo")%></td>
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
                 <legend></legend>
                 <input name="cmdLimparTitulos" type="button"  class="btn-u btn-u-orange float-shadow" id="cmdLimparTitulos" style="cursor:hand" onClick="limparCarrinho()" value="Limpar T&iacute;tulos" <%=strDesabilitaPrincipal%> />&nbsp;
          		 <input name="cmdRelatorios" type="button"  class="btn-u float-shadow" id="cmdRelatorios" style="cursor:hand" onClick="gerar()" value="Gerar Relatório" <%=strDesabilitaPrincipal%> />
                <%end if%>
         	<!-- Fecha o Form -->  
      </div>
       <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
   <script>
	function limparCarrinho(){
		frm.action="Rel_EtiquetasAcervo_con.asp?ad=e";
		frm.submit();
	}		
		
	function adicionar(){
		
		var form = window.document.forms[0];
		var intContMarcado=0;
		var intCodSelecionados='';
		
		//*****verifica se um aluno foi selecionado
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "checkbox"){
				//verifica se o checkbox está marcado
				if (form.elements[i].checked){
					
					if (frm.elements[i].name == "chkExemplares"){
					//verifica se o checkbox está marcado
						if (frm.elements[i].checked){
							intContMarcado = intContMarcado + 1;
						}
						
						if (intContMarcado == 1){
							intCodSelecionados = form.elements[i].value;
						}else{
							intCodSelecionados = intCodSelecionados + ',' + form.elements[i].value;
						}

					}
				}
			}
		}
		
		if (intContMarcado==0){
			alert("Selecione pelo menos uma Publicacao!");
			return false;
		}

		frm.txtAdicionar.value = intCodSelecionados;
		frm.action="Rel_EtiquetasAcervo_con.asp?ad=s";
		frm.submit();
	}
	
	function marcaTodos(valor){
		var form = window.document.forms[0];
		var i;
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "checkbox"){
				//verifica se o checkbox está marcado
				form.elements[i].checked=valor;
			}
		}
	}
	
	function reload(){
		frm.submit();
		return true;
	}

	function gerar(){
	
		var caminho;
		if (frm.cmbModeloEtiqueta.value=='0'){
			alert('Modelo da etiqueta deve ser informada.');
			frm.cmbModeloEtiqueta.focus();
			return false
		}
		
		caminho = "Rel_EtiquetasAcervo_rel.asp"
		frm.action = caminho;
		frm.submit();
		return true;	
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 