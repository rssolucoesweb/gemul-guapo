<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
         <%if Session("mobile")<>"S" then%>
            <h1 class="pull-left">OS - Ordem de Serviço</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
          <%end if%>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strPaginaTitulo = "UsuarioExterno_cad.asp"
    
        intCodigo	 			= Trim(Request.Form("txtCodigo"))
		strNome		 			= Trim(Request.Form("txtNome"))
		strSecretaria 			= Trim(Request.Form("txtSecretaria"))
		strDepartamento			= Trim(Request.Form("txtDepartamento"))
		strCPF		 			= Trim(Request.Form("txtCPF"))
		strEmail	 			= Trim(Request.Form("txtEmail"))
		strTelefone 			= Trim(Request.Form("txtTelefone"))
		strSituacao 			= Trim(Request.Form("cmbSituacao"))
		strUsuarioPortal		= Trim(Request.Form("txtUsuarioPortal"))
		strSenhaPortal			= Trim(Request.Form("txtSenhaPortal"))
		intCodArea				= Trim(Request.Form("cmbArea"))
			
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
            
        if trim(intCodigo) <> "" then
        
            sql = "SELECT CODIGO, NOME, SECRETARIA, DEPARTAMENTO, TELEFONE, CPF, EMAIL, SITUACAO, codigo_seg_usuarios_sistema, cod_colaborador, cod_area"
            sql = sql & " FROM SOS_FUNCIONARIO_EXTERNO"
            sql = sql & " where CODIGO = " & intCodigo
            rs.open sql, cnn
            if rs.eof = false then
                codColaborador			= rs("cod_colaborador")
				intCodArea				= rs("cod_area")
                strNome					= rs("NOME")
				strDepartamento			= rs("DEPARTAMENTO")
				strSecretaria			= rs("SECRETARIA")
				strTelefone				= rs("TELEFONE")
				strCPF					= rs("CPF")
                strEmail				= rs("EMAIL")	
				strSituacao				= rs("SITUACAO")	
                strUsuarioPortal		= rs("codigo_seg_usuarios_sistema")
                strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
                strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
                strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
    			
            end if 
            rs.close
			
			sql = "select USUA_INFO_SENHA "
			sql = sql & " from SEG_USUARIOS_SISTEMA"
			sql = sql & " where USUA_CODG = '"&strUsuarioPortal & "'"
			rs.open sql, cnn
			if not rs.eof then
				strSenhaPortal = rs("USUA_INFO_SENHA")
			end if
			rs.close
			
        else
            strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
            strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
            strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
        end if 
		
		if trim(strCPF) <> "" and request("porCPF")="S" then
        
            sql = "select d.descricao as departamento, e.razaosocial as secretaria, c.nome, c.FoneCelular, c.email, c.codigo_SEG_USUARIOS_SISTEMA, c.cpf, c.situacao, c.codigo, ex.cod_area, ex.situacao as sitExt, ex.codigo as codFuncExt, ex.cod_colaborador"
            sql = sql & " from SRH_COLABORADOR c"
            sql = sql & " inner join seg_empresa e on e.codigo = c.codLotacao"
            sql = sql & " left join SOS_FUNCIONARIO_EXTERNO ex on ex.cod_colaborador = c.codigo"
			sql = sql & " left join SEG_DEPARTAMENTO d on d.codigo = c.codDepartamento"
            sql = sql & " where c.cpf = '" & strCPF & "'"
			sql = sql & " and e.cod_grupo=" & session("codGrupo")
            rs.open sql, cnn
            
            if rs.eof = false then
				intCodigo				= rs("codFuncExt")
				codColaborador			= rs("codigo")
                strNome					= rs("NOME")
				strDepartamento			= rs("DEPARTAMENTO")
				strSecretaria			= rs("SECRETARIA")
				strTelefone				= rs("FoneCelular")
				strCPF					= rs("CPF")
                strEmail				= rs("EMAIL")	
				strSituacao				= rs("sitExt")
				if isnull(strSituacao) then 	strSituacao				= rs("SITUACAO")	
				intCodArea				= rs("cod_area")
                strUsuarioPortal		= rs("codigo_seg_usuarios_sistema")
				if isnull(rs("cod_colaborador")) then
					strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
					strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
					strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
				else
					strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
					strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
					strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
				end if
    
            end if 
            rs.close
			
			sql = "select USUA_INFO_SENHA "
			sql = sql & " from SEG_USUARIOS_SISTEMA"
			sql = sql & " where USUA_CODG = '"&strUsuarioPortal & "'"
			rs.open sql, cnn
			if not rs.eof then
				strSenhaPortal = rs("USUA_INFO_SENHA")
			end if
			rs.close
        end if 

		if strUsuarioPortal <> "" AND intCodigo = "" and request("porCPF")="" then
			sql = "select count(*) as contLogin "
			sql = sql & " from SEG_USUARIOS_sistema"
			sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '"&strUsuarioPortal & "'"
			rs.open sql, cnn
			if not rs.eof then
				if not isnull(rs("contLogin")) then
					if rs("contLogin")>0 then
						bolExiste = true
						bolExisteUsuario = true
						%>
						<script>
							alert("ATENÇÃO: \n\nLogin já existe para outro usuário por favor tente outro.");
						</script>
						<%	
						strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
						strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
						strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
						
					end if
				end if
			end if
			rs.close
			
			' Verifica se existe o login já cadastrado para outro usuario
			sql = "select Usua_Codg From SEG_USUARIOS_SISTEMA"
			sql = sql & " where Usua_Codg = '"& trim(strUsuarioPortal) & "'"
			rs.open sql, cnn
			if rs.eof = false then
				bolExisteUsuario = true
				%>
				<script>
					alert("ATENÇÃO: \n\nLogin já existe para outro usuário por favor tente outro.");
				</script>
				<%	
						strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
						strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
						strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
				
			end if
			rs.close
		end if				
    %>
    
    
<!--=== Content Part ===-->
    <div class="container content">
        <div class="row">
            <!-- Begin Content -->
            <div class="col-md-12" >     

       		<!-- Inicia o Painel do Formulario -->     

                <form id="frm" class="sky-form  panel-body0" method="post">
                	
                    <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                    <input name="codColaborador" type="hidden" id="codColaborador" class="text" size="10" value="<%=codColaborador%>" maxlength="10">
                    
                    <div style="background:#95a5a6;height:40px;padding-top: 8px;" class="panel-title">&nbsp;&nbsp;<font color="#FFFFFF"><i class="fa fa-tasks"></i>&nbsp;Cadastro de Executor</font></div>


                    <fieldset>
                        <div class="row">
                             <section class="col col-6">
                                <label class="form-label">CPF</label>
                              
                                <label class="input">
                                     <input name="txtCPF" type="text" class="form-control" id="txtCPF" size="20" maxlength="20" value="<%=strCPF%>" onkeypress="return formataCampo(this,5,14)" onblur="return validaCPFColaborador(this)">
                                </label>
                             </section>
                        </div>
                        <div class="row">
                             <section class="col col-12">
                                <label class="form-label">Nome do Funcionário</label>
                              
                                <label class="input">
                                    <input name="txtNome" type="text" class="form-control" id="txtNome" size="150" maxlength="70" value="<%=strNome%>">
                                </label>
                             </section>
                        </div>
                        
                         <div class="row">
                             <section class="col col-6">
                                <label class="form-label">Orgão</label>
                              
                                <label class="input">
                                    <input name="txtDepartamento" type="text" class="form-control" id="txtDepartamento" size="50" maxlength="70" value="<%=strDepartamento%>">
                                </label>
                             </section>
                             <section class="col col-6">
                                <label class="form-label">Secretaria</label>
                              
                                <label class="input">
                                     <input name="txtSecretaria" type="text" class="form-control" id="txtSecretaria" size="50" maxlength="70" value="<%=strSecretaria%>">
                                </label>
                             </section>
                        </div>
    
                        <div class="row">
                             <section class="col col-6">
                                <label class="form-label">Telefone</label>
                              
                                <label class="input">
                                    <input name="txtTelefone" type="text" class="form-control" id="txtTelefone" size="20" maxlength="20" value="<%=strTelefone%>">
                                </label>
                             </section>
                        </div>
    
                        <div class="row">
                             <section class="col col-12">
                                <label class="form-label">Email</label>
                              
                                <label class="input">
                                    <input name="txtEmail" type="text" class="form-control" id="txtEmail" size="150" maxlength="70" value="<%=strEmail%>">
                                </label>
                             </section>
                        </div>
    
    
                        <div class="row">
                             <section class="col col-6">
                                <label class="form-label">Login para acesso ao sistema</label>
                              
                                <label class="input">
                                    <input name="txtUsuarioPortal" type="text" class="form-control" id="txtUsuarioPortal" size="50" maxlength="50" value="<%=strUsuarioPortal%>">
                                </label>
                             </section>
                             <section class="col col-6">
                                <label class="form-label">Senha de acesso</label>
                              
                                <label class="input">
                                     <input name="txtSenhaPortal" type="password" class="form-control" id="txtSenhaPortal" size="20" maxlength="20" value="<%=strSenhaPortal%>">
                                </label>
                             </section>
                        </div>
                        
                        <div class="row">
                             <section class="col col-6">
                                <label class="form-label">Departamento</label>
                                <label class="input">
                                    <!--#include file="../includes/inc_cmbArea.asp" -->
                                </label>
                             </section>
                             
                              <section class="col col-6">
                                <label class="form-label">Situação</label>
                                <label class="input">
                                    <select name="cmbSituacao" class="form-control" id="cmbSituacao"  style="width:150pt" >
                                      <option value="0">Selecione...</option>
                                      <option value="A" <%if trim(strSituacao) = "A" then response.Write("selected") %>>ATIVO</option>
                                      <option value="I" <%if trim(strSituacao) = "I" then response.Write("selected") %>>INATIVO</option>
                                   </select>
                                </label>
                             </section>
                        </div>

                    </fieldset>
					
					<div class="margin-left-40">
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
					</DIV>
                    
                 </form>                
                
			</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i>Lista de Executor</h3>
          	</div>
      		<div class="panel-body">
            	<div class="table-responsive">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                              <th width="5%" bgcolor="#95A5A6">Código</th>
                              <th width="55%" bgcolor="#95A5A6">Nome</th>
                              <th width="35%" bgcolor="#95A5A6">Secretaria</th>
                              <th width="5%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                          </tr>
                        </thead>
                         <tbody>
                        <%
                        cont =0
                        sql = "SELECT nome, codigo, secretaria, situacao"
                        sql = sql & " FROM SOS_FUNCIONARIO_EXTERNO"
                        sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
                        sql = sql & " Order by nome"
                        rs.open sql, cnn
                        if rs.eof = false then
                        
                        while not rs.eof
                            cont = cont + 1
							cor = ""
							if trim(rs("situacao"))	 = "I" then cor = " bgcolor='#FFCACA'"
                            %>
                            <tr <%=cor%>>
                                <td><%=trim(rs("CODIGO"))%></td>
                                <td><%=trim(rs("NOME"))%></td>
                                <td><%=trim(rs("SECRETARIA"))%></td>
                                <td align="center" >
                                <button class="btn-u btn-u-sea" onclick="resultadoConsulta(<%=trim(rs("CODIGO"))%>)" type="button"><i class="fa fa-file-text-o"></i></button>                            </td> 
                            </tr>
                            <%				
                            rs.movenext
                            wend
                        end if
                        rs.close
                        %>
                            <tr>
                                <td colspan="4">Total Registros : <%=cont%></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
          	</div>                      
        </div>
        <!--End Table Bordered-->	
        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
    
   	   
	<script>
        function resultadoConsulta(intCodigo){
            
            var frm = document.getElementById("frm");
            frm.txtCodigo.value=intCodigo;
            frm.submit();
        }
		
        function salvar(acao){
            
            var frm = document.getElementById("frm");
            
            if (frm.txtNome.value == "") {
                alert("O nome deve ser informado!");
                frm.txtNome.focus();
                return false;
            }
            if (frm.txtSecretaria.value == "") {
                alert("A secretaria deve ser informada!");
                frm.txtSecretaria.focus();
                return false;
            }
            
            frm.action="usuarioExterno_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
    
	function validaCPFColaborador(campo) {
            var pcpf=campo.value;
            
            pcpf = pcpf.replace(".","");
            pcpf = pcpf.replace(".","");
            pcpf = pcpf.replace("-","");
            
            if (pcpf != "") {
            
                if (pcpf.length != 11){
                    sim=false;
                }
                else{
                    sim=true;
                }
                
                if ( (pcpf==11111111111) || (pcpf==22222222222) ||
                    (pcpf==33333333333) || (pcpf==44444444444) || (pcpf==55555555555) ||
                    (pcpf==66666666666) || (pcpf==77777777777) || (pcpf==88888888888) ||
                    (pcpf==99999999999) || (pcpf==00000000000) ){
                        sim=false;
                }
                
                if(sim){
                    for (i=0; i<=(pcpf.length-1) && sim; i++){
                        val = pcpf.charAt(i);
                        if((val!="9")&&(val!="0")&&(val!="1")&&(val!="2")&&(val!="3")&&(val!="4")&&( val!="5")&&(val!="6")&&(val!="7")&&(val!="8")){
                            sim=false;
                        }
                    }
                
                    if(sim){
                        soma=0;
                        for (i=0;i<=8;i++){
                            val = eval(pcpf.charAt(i));
                            soma = soma + (val*(i+1));
                        }
                    
                        resto = soma % 11;
                        
                        if (resto>9)
                            dig = resto -10;
                        else
                            dig = resto;
                        
                    
                        if (dig != eval(pcpf.charAt(9))){
                            sim=false
                        }else{
                            soma = 0
                            for (i=0;i<=7;i++){
                                val = eval(pcpf.charAt(i+1))
                                soma = soma +	(val*(i+1))
                            }
                            soma = soma + (dig * 9)
                            resto = soma % 11
                            if (resto>9){
                                dig = resto -10
                            }else{
                                dig = resto
                            }
                    
                            if (dig != eval(pcpf.charAt(10))){
                                sim = false
                            }else{
                                sim = true
                            }
                        }
                    }
                }
                
                if (!sim){
                    alert("CPF inválido!");
                    campo.focus();
                    campo.select();
                }else{
                    if (campo.value!=""){
						frm.txtCodigo.value="";
						frm.action="usuarioExterno_cad.asp?porCPF=S"
                        frm.submit();	
					}
                        
                }
                        
            }
        }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 