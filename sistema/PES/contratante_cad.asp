<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<style>
.margin-bottom-30 {
    margin-left: 30px;
}
.pointer {cursor: pointer;}
.tamanho7 { font-size: 9px; }
.btnResposta {
    background: #339cff;
	color: aliceblue;
	}
</style>
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">PES - Sistema de Pesquisas</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
    acao = "I"
	strExecutarSubmitEstado						= "S"
	strPaginaTitulo                  			= "contratante_cad.asp"
	strPagina						 			= "contratante_cad.asp"

	intCodigo           	  					= Trim(Request.Form("txtCodigo"))
	nome										= Trim(Request.form("nome"))
	email										= Trim(Request.form("email"))
	celular										= Trim(Request.form("celular"))
	senha										= "123456"
	situacao									= Trim(Request.form("cmbSituacao"))

	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	
	if trim(intCodigo) <> "" then
		sql = "SELECT *"
		sql = sql & " FROM PES_contratante "
		sql = sql & " where codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			nome			= rs("nome")
			celular			= rs("celular")
			senha			= "******"
			email			= rs("email")
			situacao		= rs("situacao")
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
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
        <div class="row">
            <!-- Begin Content -->
            <div class="col-md-12" >     

       		<!-- Inicia o Painel do Formulario -->   

					<form id="frm" method="post" action="contratante_cad.asp" name="frm" class="sky-form panel-body0">
					<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                    <div style="background:#95a5a6;height:40px;padding-top: 8px;" class="panel-title">&nbsp;&nbsp;<font color="#FFFFFF"><i class="fa fa-tasks"></i>&nbsp;Cadastro de contratante</font></div>

                    <fieldset>
                        
                       	<div class="row">
							<section class="col col-8">
                                <label class="form-label">Nome</label>
                              
                                <label class="input">
                                    <input name="nome" type="text" class="form-control" id="nome" size="50" maxlength="50" value="<%=nome%>">
                                </label>
                             </section>
							 <section class="col col-4">
                                <label class="form-label">Celular</label>
                              
                                <label class="input">
                                    <input name="celular" type="text" class="form-control" id="celular" size="50" maxlength="30" value="<%=celular%>">
                                </label>
                             </section>
						</div>
						<div class="row">
							 <section class="col col-8">
                                <label class="form-label">Login <i>(será o acessar para consultar os resultados da pesquisa)</i></label>
                              
                                <label class="input">
                                    <input name="email" type="text" class="form-control" id="email" size="50" maxlength="50" value="<%=email%>"><%if strDesabilitaAlterar <> "" then%>Para padronização o sistema incluirá automaticamente .gemul no final do login, exemplo: xxxxxxxx.gemul<%end if%>
                                </label>
                             </section>
							  <section class="col col-4">
                                <label class="form-label">Senha (temporária) </label>
                              
                                <label class="input">
                                    <input name="senha" type="text" class="form-control" id="senha" disabled size="50" maxlength="30" value="<%=senha%>">No seu primeiro login será solicitada a sua alteração!
                                </label>
                             </section>
						</div>	 
						<div class="row">
							 <section class="col col-6">
                                <label class="form-label">Terá acesso as pesquisas, somente resumo e gráfico - marcar todas: <input name="chkTodos" type="checkbox" onClick="marcaPesquisas()"></label>
                              
                                    
										<%
										sql = "select p.codigo, p.nome, c.nome as cidade, e.nome as estado "
										sql = sql & " from PES_pesquisa p"
										sql = sql & " left join PES_cidade c on c.Codigo = p.cod_cidade"
										sql = sql & " left join PES_estado e on e.Codigo = c.cod_estado"										
										sql = sql & " where cod_grupo = " & session("codGrupo") & " and situacao = 'A' order by nome"
										rs.open sql, cnn
										cont=0
										if rs.eof = false then
										
											while not rs.eof
												cod_pesquisa =  rs("codigo")
												strMarca = ""
												if intCodigo<>"" then
													sql = "SELECT codigo"
													sql = sql & " FROM PES_contratante_pesquisa"
													sql = sql & " WHERE cod_pesquisa = " & cod_pesquisa
													sql = sql & " AND cod_contratante = " & intCodigo
													RsAux.open sql, cnn
													if RsAux.eof = false then
														strMarca = "checked"
													end if
													RsAux.close
												end if
												%>
												<input type="checkbox" name="chkPesquisa" value="<%=rs("codigo")%>" <%=strMarca%>> <%=trim(rs("nome"))%> | <%=trim(rs("cidade"))%>-<%=trim(rs("estado"))%><br>
												<%				
												rs.movenext
											wend
										end if
										rs.close
									%>
									
                                
                             </section>
						</div>
						
						<div class="row">
							<section class="col col-4">
								<label class="form-label">Situação</label>
							  
								<label class="input">
									<!--#include file="../includes/inc_cmbSituacaoAtivoInativo.asp" -->
								</label>
								
							</section>
							 
						</div>
                       
						</fieldset><fieldset>
					 
					</fieldset>
					 
					<div class="margin-left-60">
	                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
					</div>
                    
				<%
					sql = "select codigo, nome, email, situacao, usuario_altr, data_hora_altr"
					sql = sql & " from PES_contratante  "
					sql = sql & " order by situacao, nome"
                    RS.OPEN SQL, CNN
                    IF NOT RS.EOF THEN
                    %> 
                  <div class="panel panel-grey">
                        <div class="panel-heading">
                            <h3 class="panel-title"><i class="fa fa-tasks"></i> Contratantes cadastrados</strong>
                            </h3>
                        </div>
                        <div class="panel-body">
                        <table class="table table-bordered" >
                            <thead>
								<tr  bgcolor="#E2E2E2">
									<th width="5%" align="center">Login</th>
                                    <th width="30%"  align="center">Nome</th>
									<th width="15%"  align="center">Login</th>
                                    <th width="15%" align="center"><strong>Usuário</strong></td>
                                    <th width="15%" align="center"><strong>Data</strong></td>
									<th width="5%" align="center"><strong>Situação</strong></td>
									<th width="5%" align="center"><strong>Acesso(login)</strong></td>
                                </tr>
                            </thead>
                            <%
                            cont = 0
                            while not rs.eof
								cont = cont + 1	
								strCorlinha = "FFFFFF"
								if trim(rs("situacao")) = "A" then
									strSituacao = "Ativo"
								elseif trim(rs("situacao")) = "I" then
									strSituacao = "Inativo"
									strCorlinha = "F5A9A9"
								else
									strSituacao = "Não informada"
									strCorlinha = "F3E2A9"
								end if
                                %>
                                <tr  class="pointer" bgcolor="#<%=strCorlinha%>" onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)">
                                  	<td onclick="return resultadoConsulta('<%=rs("CODIGO")%>')"><%=rs("codigo")%></td>
									<td onclick="return resultadoConsulta('<%=rs("CODIGO")%>')"><%=RS("nome")%></td>
									<td onclick="return resultadoConsulta('<%=rs("CODIGO")%>')"><strong><%=RS("email")%></strong></td>
                                    <td onclick="return resultadoConsulta('<%=rs("CODIGO")%>')"><%=RS("usuario_altr")%></td>
									<td onclick="return resultadoConsulta('<%=rs("CODIGO")%>')"><%=RS("data_hora_altr")%></td>
									<td><%=strSituacao%></td>
									<td  align="center" onclick="return cadastrarRespostas()"><button class="btn u-btn-primary btnResposta" type="button" role="button"><i class="fa fa-tasks"></i></button></td>
                                </tr>
                                <%				
                                    rs.movenext
                                wend
                            %>
                        </table>
                      </div>
				</div>
                    <%
                    RS.CLOSE
                END IF
            %> 
			</div>
			</form>
         	<!-- Fecha o Form -->  
      </div>

        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
      
   	   
	<script>
	
	function marcaPesquisas(){
		var frm = document.getElementById("frm");
		if(frm.chkTodos.checked == true){ 
			for (var i = 0; i < frm.elements.length; i++) {
				if (frm.elements[i].type == "checkbox"){				
					frm.elements[i].checked = true;				
				}
			}
		}
		else {
				for (var i = 0; i < frm.elements.length; i++) {
					if (frm.elements[i].type == "checkbox"){				
						frm.elements[i].checked = false;				
					}
			}
		}
	}
	
	function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.action = "contratante_cad.asp";
		frm.submit();
	}
	
	function cadastrarRespostas(){
		window.open('http://www.gemul-aparecida.com.br/login.asp');
	}
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (acao=="E"){
			frm.action="contratante_cod.asp?acao=" + acao;
			frm.submit();
			return true;
		}
		else
		{
			if (frm.nome.value == "") {
				alert("O nome deve ser informado!");
				frm.nome.focus();
				return false;
			}
			if (frm.senha.value == "") {
				alert("A senha deve ser informada!");
				frm.senha.focus();
				return false;
			}
			if (frm.email.value == "") {
				alert("o email deve ser informado!");
				frm.email.focus();
				return false;
			}
			
			if (frm.cmbSituacao.value == "0") {
				alert("A situação deve ser informada!");
				frm.cmbSituacao.focus();
				return false;
			}
	
			frm.action="contratante_cod.asp?acao=" + acao;
			frm.submit();
			return true;
		}
 	}
	
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 