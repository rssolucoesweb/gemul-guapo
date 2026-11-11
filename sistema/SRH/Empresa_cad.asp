<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../../includes/inc_formataCnpj.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
<script src="json/jquery-1.7.1/jquery-1.7.1.min.js"></script> <!--para o busca cep -->
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
    
    strSimouNao_submit	 = 	"N"
    strExecutarSubmitGrupo = "S" 
    intCodGrupo = Session("CodGrupo")  

    strPagina					= "Empresa_cad.asp"
    strCodigo 					= Trim(Request("txtCodEmpresa"))
    strCNPJ  					= Trim(Request.Form("txtCNPJ"))
    strRazaoSocial 				= Trim(Request.Form("txtRazaoSocial"))
    strMantenedora 				= Trim(Request.Form("txtMantenedora"))
    strAutorizacao 				= Trim(Request.Form("txtAutorizacao"))
    strSecretaria				= Trim(Request.Form("txtSecretaria"))
    strContato					= Trim(Request.Form("txtContato"))
    strContato1					= Trim(Request.Form("txtContato1"))
    strContato2					= Trim(Request.Form("txtContato2"))
    strEndereco					= Trim(Request.Form("txtEndereco"))
    strBairro					= Trim(Request.Form("txtBairro"))
    strMunicipio				= Trim(Request.Form("txtMunicipio"))
    strUF						= Trim(Request.Form("txtUF"))
    strCep						= Trim(Request.Form("txtCep"))
    strTelefone					= Trim(Request.Form("txtTelefone"))
    stremail					= Trim(Request.Form("txtemail"))
    stremailDiretoria			= Trim(Request.Form("txtemailDiretoria"))
    stremailFinanceiro			= Trim(Request.Form("txtemailFinanceiro"))
    stremailModulacao			= Trim(Request.Form("txtemailModulacao"))
    stremailLogins				= Trim(Request.Form("txtemailLogins"))
    strSimouNao					= Trim(Request.Form("cmbSimouNao"))
    strSimouNaoDadosCadastrais	= Trim(Request.Form("cmbSimouNaoDadosCadastrais"))
    strNotificacao				= Trim(Request.Form("txtNotificacao"))
    strCodigoCenso				= Trim(Request.Form("txtCodigoCenso"))
    strCodigoSetransp			= Trim(Request.Form("txtCodigoSetransp"))
    strNumeroSalaAula			= Trim(Request.Form("txtNumeroSalaAula"))
    strSimouNaoPersonalizarSistema	= Trim(Request.Form("cmbSimouNaoPersonalizarSistema"))
    intCodTipoEmpresa			= Trim(Request("cmbTipoEmpresa"))

    if strCodigo <> "" then
    
        strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
        strDesabilitaAlterar = "" 'Habilita o botão Alterar'
        strDesabilitaExcluir = "" 'Desabilita o botão Excluir'
        strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
        
        sql = "SELECT * "
        sql = sql & " FROM SEG_EMPRESA"
        sql = sql & " WHERE CODIGO = " & strCodigo
        
        rs.open sql, cnn
        if rs.eof = false then
            strCodigo  					= Trim(RS("CODIGO"))
            strCNPJ  					= Trim(RS("Cnpj"))
            strRazaoSocial 				= Trim(RS("RazaoSocial"))
            strMantenedora 				= Trim(RS("Mantenedora"))
            strAutorizacao 				= Trim(RS("Autorizacao"))
            strDiretor					= Trim(RS("Diretor"))
            strSecretaria				= Trim(RS("Secretaria"))
            strContato					= Trim(RS("Contato"))
            strContato1					= Trim(RS("Contato1"))
            strContato2					= Trim(RS("Contato2"))
            strEndereco					= Trim(RS("Endereco"))
            strBairro					= Trim(RS("Bairro"))
            strMunicipio				= Trim(RS("Municipio"))
            strUF						= Trim(RS("UF"))
            strCep						= Trim(RS("Cep"))
            strTelefone					= Trim(RS("Telefone"))
            strNomeLogo					= Trim(RS("LOGOMARCA"))	
            strLogoConvenio				= Trim(RS("LogoConvenio"))	
            intCodGrupo					= Trim(RS("COD_GRUPO"))	
            stremail					= Trim(RS("EMAIL"))	
            stremailDiretoria			= Trim(RS("EMAIL_DIRETORIA"))
            stremailFinanceiro			= Trim(RS("EMAIL_FINANCEIRO"))
            stremailModulacao			= Trim(RS("EMAIL_MODULACAO"))
            stremailLogins				= Trim(RS("EMAIL_LOGINS"))
            strSimouNao					= Trim(RS("BLOQUEIO"))
            strSimouNaoDadosCadastrais	= Trim(RS("COMPARTILHAR_DADOS"))
            strNotificacao				= Trim(RS("NOTIFICACAO"))
            
            strCodigoCenso					= Trim(RS("CODIGO_CENSO"))
            strCodigoSetransp				= Trim(RS("CODIGO_SETRANSP"))
            strNumeroSalaAula				= Trim(RS("TOTAL_SALAS_AULAS"))
            strSimouNaoPersonalizarSistema	= Trim(RS("PERSONALIZAR_SISTEMA"))
            intCodTipoEmpresa				= Trim(RS("CodTipoEmpresa"))
            
            
            
        else
            strDesabilitaIncluir = "disabled"'Desabilita o botão Incluir
            strDesabilitaAlterar = "disabled" 'Desabilita o botão Alterar
            strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
            strDesabilitaLimpar  = "" 'Habilita o Botão Limpar
        end if 
        rs.close
        
    else
        strDesabilitaIncluir = "disabled"'Desabilita o botão Incluir
        strDesabilitaAlterar = "disabled" 'Desabilita o botão Alterar
        strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
        strDesabilitaLimpar  = "" 'Habilita o Botão Limpar
    end if 
    
    IF strNomeLogo <> "" then
        strImagem = "<img src='..\..\LogoMarcas\" & strNomeLogo & "\" & strCodigo & "' border='1' width='85' height='113'>"
    else
        strImagem = "<font color='#CCCCCC'>  LOGO </font>"
    end if
    
    IF strLogoConvenio <> "" then
        strImagem = "<img src='..\..\LogoConvenio\" & intCodGrupo & "\" & strLogoConvenio & "' border='1' width='85' height='113'>"
    else
        strImagem = "<font color='#CCCCCC'>  LOGO </font>"
    end if
    if Session("NivelPermissao") <> "A" then
       bloqueiaAcessoAlteracao = "readonly"
       bloqueiaComboAlteracao = "disabled"
    end if   
    %>

    <!--=== Content Part ===-->
    <form method="post" id="frm" ENCTYPE="multipart/form-data">
    <input name="txtCodEmpresa" type="hidden" id="txtCodEmpresa" class="text" size="10" value="<%=strCodigo%>" maxlength="10">
    <div class="container content">		
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Empresa</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                
              <div class="form-group">
                    	
                  <table class="table table-bordered">
                    <tr>
                      <td colspan="5" bgcolor="#95A5A6"><strong>Dados Escola</strong></td>
                    </tr>
                    <tr>
                      <td>Grupo:</td>
                      <td colspan="4"><!--#include file="../includes/inc_cmdGrupo.asp"--></td>
                    </tr>
                    <tr> 
                      <td width="20%">CNPJ: </td>
                      <td colspan="4"><input <%=bloqueiaAcessoAlteracao%>  name="txtCNPJ" type="text" class="text" id="txtCNPJ" onkeypress="return FormataCNPJ(this, 18)" value="<%=formataCnpjAP(strCNPJ)%>" size="20" maxlength="18"> 
                      - <span class="style1">Obs: Para inclus&atilde;o de novas unidades, entrar em contato com nosso suporte.</span></td>
                    </tr>
                    <tr> 
                      <td height="26" >Raz&atilde;o Social: </td>
                      <td colspan="4"><input <%=bloqueiaAcessoAlteracao%> name="txtRazaoSocial" type="text" class="text" id="txtRazaoSocial" value="<%=strRazaoSocial%>" size="60" maxlength="50">			    </td>
                    </tr>
                    <tr>
                      <td>Mantenedora: </td>
                      <td colspan="4"><input <%=bloqueiaAcessoAlteracao%> name="txtMantenedora" type="text" class="text" id="txtMantenedora" value="<%=strMantenedora%>" size="60" maxlength="50"></td>
                    </tr>
                    <tr>
                      <td>Lei de Cria&ccedil;&atilde;o:</td>
                      <td colspan="4"><textarea name="txtAutorizacao" cols="60" rows="5" class="text" id="txtAutorizacao"><%=strAutorizacao%></textarea></td>
                    </tr>
                    <tr>
                      <td><strong>Diretor(a):</strong></td>
                      <td colspan="4"><input name="txtDiretor" type="text" class="text" id="txtDiretor" value="<%=strDiretor%>" size="60" maxlength="50"></td>
                    </tr>
                    <tr>
                      <td><strong>Secretario(a):</strong></td>
                      <td colspan="4"><input name="txtSecretaria" type="text" class="text" id="txtSecretaria" value="<%=strSecretaria%>" size="60" maxlength="50"></td>
                    </tr>
                    <tr>
                      <td><strong>1&ordm; Contato:</strong></td>
                      <td width="48%"><input name="txtContato" type="text" class="text" id="txtContato" value="<%=strContato%>" size="60" maxlength="50"></td>
                      <td width="12%">&nbsp;</td>
                      <td width="20%" colspan="2">&nbsp;</td>
                    </tr>
                    <tr>
                      <td><strong>2&ordm; Contato:</strong></td>
                      <td><input name="txtContato1" type="text" class="text" id="txtContato1" value="<%=strContato1%>" size="60" maxlength="50"></td>
                      <td>&nbsp;</td>
                      <td colspan="2">&nbsp;</td>
                    </tr>
                    <tr>
                      <td><strong>3&ordm; Contato:</strong></td>
                      <td><input name="txtContato2" type="text" class="text" id="txtContato2" value="<%=strContato2%>" size="60" maxlength="50"></td>
                      <td><strong>Telefone Unidade:</strong></td>
                      <td colspan="2"><input name="txtTelefone" type="text" class="text" id="txtTelefone" onkeypress="mascara(this,telefone)" value="<%=strTelefone%>" size="20" maxlength="14"></td>
                    </tr>
					<tr>
                      <td><strong>Cep:</strong></td>
                      <td colspan="3"><input name="txtCep" type="text" class="text" id="txtCep" onkeypress="return formataCampo(this,2,8)" size="10" maxlength="10" value="<%=strCep%>"></td>
                    </tr>
                    <tr>
                      <td><strong>Endere&ccedil;o:</strong></td>
                      <td colspan="3"><input name="txtEndereco" type="text" class="text" id="txtEndereco" value="<%=strEndereco%>" size="60" maxlength="50"></td>
                    </tr>
                    <tr> 
                      <td><strong>Bairro:</strong></td>
                      <td colspan="4"><input name="txtBairro" type="text" class="text" id="txtBairro" value="<%=strBairro%>" size="40" maxlength="30">			    </td>
                    </tr>
                    <tr>
                      <td><strong>Munic&iacute;pio:</strong></td>
                      <td><input name="txtMunicipio" type="text" class="text" id="txtMunicipio" value="<%=strMunicipio%>" size="60" maxlength="50"></td>
                      <td><strong>Estado:</strong></td>
                      <td colspan="2"><input name="txtUF" type="text" class="text" id="txtUF" size="3" maxlength="2" value="<%=strUF%>" onkeypress="return formataCampo(this, 1, 2)">                      </td>
                    </tr>
                    <tr>
                      <td>Avisos:</td>
                      <td colspan="4"><input <%=bloqueiaAcessoAlteracao%> name="txtNotificacao" type="text" class="text" id="txtNotificacao" size="120" maxlength="120" value="<%=strNotificacao%>">                      </td>
                    </tr>
                    <tr>
                      <td height="20" colspan="5" bgcolor="#95A5A6"><strong>Situa&ccedil;&atilde;o</strong></td>
                    </tr>
                    <tr>
                      <td>Compartilhar Dados Cadastrais? </td>
                      <td colspan="4" ><select <%=bloqueiaComboAlteracao%> name="cmbSimouNaoDadosCadastrais" class="combo" id="cmbSimouNaoDadosCadastrais"  style="width:70pt" onchange='' >
                        <option value="0">Selecione...</option>
                        <option value="S" <%if strSimouNaoDadosCadastrais = "S" then response.Write("selected") %>>SIM</option>
                        <option value="N" <%if strSimouNaoDadosCadastrais = "N" then response.Write("selected") %>>NAO</option>
                      </select></td>
                    </tr>
                    <tr>
                      <td>Bloquear Unidade?</td>
                      <td colspan="4"><!--#include file="../includes/inc_cmbSimouNao.asp"--></td>
                    </tr>
                        
                    <tr>
                      <td>Tipo Empresa:</td>
                      <td colspan="4"><!--#include file="../includes/inc_cmbTipoEmpresa.asp"--></td>
                    </tr>
                    <tr>
                      <td height="20" colspan="5" bgcolor="#95A5A6"><strong>NOTIFICA&Ccedil;&Otilde;ES:</strong></td>
                    </tr>
                    <tr>
                      <td ><strong>Email 01: </strong></td>
                      <td colspan="4" class="titulo1">
                        <input name="txtemailDiretoria" type="text" class="text" id="txtemailDiretoria" size="40" maxlength="70" value="<%=stremailDiretoria%>">
                      - Diretoria Geral</td>
                    </tr>
                    <tr>
                      <td><strong>Email 02: </strong></td>
                      <td colspan="4"><input name="txtemailFinanceiro" type="text" class="text" id="txtemailFinanceiro" size="40" maxlength="70" value="<%=stremailFinanceiro%>"> - Diretoria Financeira </td>
                    </tr>
                    <tr>
                      <td><strong>Email 03:</strong></td>
                      <td colspan="4" class="titulo1"><input name="txtemail" type="text" class="text" id="txtemail" size="40" maxlength="70" value="<%=stremail%>">- Secretaria Acad&ecirc;mica </span></td>
                    </tr>
                    <tr>
                      <td><strong>Email 04:</strong></td>
                      <td colspan="4"><input name="txtemailModulacao" type="text" class="text" id="txtemailModulacao" size="40" maxlength="70" value="<%=stremailModulacao%>">- Modula&ccedil;&atilde;o RH</td>
                    </tr>
                    <tr>
                      <td><strong>Email 05:</strong></td>
                      <td colspan="4" class="titulo1"><input name="txtemailLogins" type="text" class="text" id="txtemailLogins" size="40" maxlength="70" value="<%=stremailLogins%>">- Acompanhamento de Login </span></td>
                    </tr>
                    <tr>
                      <td height="20" colspan="5" bgcolor="#95A5A6"><strong>Dados Informativo</strong></td>
                    </tr>
                    <tr>
                      <td>C&oacute;digo Inep:</td>
                      <td colspan="4">
                        <input name="txtCodigoCenso" type="text" class="text" id="txtCodigoCenso" onkeypress="return formataCampo(this,2,8)" size="10" maxlength="10" value="<%=strCodigoCenso%>">                      </td>
                    </tr>
                    <tr>
                      <td>C&oacute;digo Setransp:</td>
                      <td colspan="4" class="titulo1">
                        <input name="txtCodigoSetransp" type="text" class="text" id="txtCodigoSetransp" onkeypress="return formataCampo(this,2,8)" size="10" maxlength="10" value="<%=strCodigoSetransp%>">                      </td>
                    </tr>
                    <tr>
                      <td>N&uacute;mero de Salas:</td>
                      <td colspan="4"><input name="txtNumeroSalaAula" type="text" class="text" id="txtNumeroSalaAula" onkeypress="return formataCampo(this,2,4)" size="4" maxlength="4" value="<%=strNumeroSalaAula%>">                     </td>
                    </tr>
                    <tr>
                      <td>Personalizar Sistema:</td>
                      <td colspan="4"><select <%=bloqueiaComboAlteracao%> name="cmbSimouNaoPersonalizarSistema" class="combo" id="cmbSimouNaoPersonalizarSistema"  style="width:70pt" onChange='' >
                        <option value="0">Selecione...</option>
                        <option value="S" <%if strSimouNaoPersonalizarSistema = "S" then response.Write("selected") %>>SIM</option>
                        <option value="N" <%if strSimouNaoPersonalizarSistema = "N" then response.Write("selected") %>>NAO</option>
                      </select></td>
                    </tr>
                </table>
              </div>
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Empresa</h3>
            </div>
            <div class="panel-body">
			  <%
                    cont =0
                    
                    sql = "SELECT SEG_EMPRESA.Codigo, Cnpj, RazaoSocial, LOGOMARCA, SEG_GRUPO.DESCRICAO AS GRUPO, LogoConvenio, SEG_EMPRESA.COD_GRUPO, CodTipoEmpresa, "
                    sql = sql & " SEG_TipoEmpresa.Descricao as TipoEmpresa "
                    sql = sql & " FROM SEG_EMPRESA "  
                    sql = sql & " LEFT JOIN SEG_GRUPO ON SEG_GRUPO.CODIGO = SEG_EMPRESA.COD_GRUPO "
                    sql = sql & " LEFT JOIN SEG_TipoEmpresa ON SEG_TipoEmpresa.CODIGO = SEG_EMPRESA.CodTipoEmpresa AND SEG_TipoEmpresa.COD_GRUPO = SEG_EMPRESA.COD_GRUPO"
                    sql = sql & " WHERE  1=1" 
                    sql = sql & " And  BLOQUEIO = 'N'"
                    
                    if Session("UsuarioMaster") = "S" or Session("NivelPermissao") = "A" then
                       sql = sql & "and SEG_EMPRESA.COD_GRUPO = " & Session("CodGrupo")
                    else
                       sql = sql & "and SEG_EMPRESA.CODIGO = " & Session("CodEmpresa")  
                    end if
                    
                    sql = sql & " Order by SEG_GRUPO.DESCRICAO, SEG_EMPRESA.RazaoSocial "
                    rs.open sql, cnn
                    if rs.eof = false then
                    %>
                        <table class="table table-bordered">
                          <tr bgcolor="#95A5A6">
                            <td width="21%"><strong>Grupo</strong></td>
                            <td width="3%"><strong>Cod.</strong></td>
                            <td width="13%"><strong>CNPJ </strong></td>
                            <td width="26%"><strong>Raz&atilde;o Social<span class="TextoForm"></span></strong></td>
                            <td width="20%"><strong>Tipo Empresa</strong></td>
                            <td width="9%"><strong>Logo Marca</strong></td>
                            <%if trim(Session("UsuarioMaster")) = "S" or Session("NivelPermissao") = "A" then%>
                            <td height="21" colspan="2" align="center" ><strong><span class="TextoForm">A&ccedil;&atilde;o</span></strong></td>
                            <%end if%>
                          </tr>
                          <%
                        while not rs.eof
                            cont = cont + 1	
                            
                            if isnull(rs("LOGOMARCA")) or rs("LOGOMARCA") = "" then
                                caminhoLogo = "../../LogoMarcas/LogoEmpresa.gif"
                            else
                                caminhoLogo = "../../LogoMarcas/" & rs("codigo")  & "/" & rs("LOGOMARCA")
                            end if
                        
                            %>
                          <tr>
                            <td><%=trim(rs("GRUPO"))%></td>
                            <td>&nbsp;<%=trim(rs("CODIGO"))%></td>
                            <td>&nbsp;<%=formataCnpjAP(rs("Cnpj"))%></td>
                            <td><%=trim(rs("RazaoSocial"))%></td>
                            <td><%=trim(rs("TipoEmpresa"))%>&nbsp;</td>
                            <td align="center"><img src="<%=caminhoLogo%>" width="47" height="50"></td>
                            
                            <%if trim(Session("UsuarioMaster")) = "S" or Session("NivelPermissao") = "A" then%>
                            	<td width="4%" align="center" ><button class="btn-u btn-u-sea" onclick="resultadoConsulta('<%=rs("Codigo")%>')" type="button"><i class="fa fa-file-text-o"></i></button></td>
							    <td width="4%" align="center" ><button class="btn-u btn-u-sea" onclick="AbreLogoConvenio(<%=rs("CODIGO")%>,<%=session("codGrupo")%>)" type="button"><i class="fa fa-search"></i></button></td>
						    <%end if%>
                          </tr>
                          <%				
                            rs.movenext
                            wend
                        %>
                         <tr>
                         <td height="18" colspan="8">Total Registros :<%=cont%></td>
                         </tr>
                         </table>
                        <%
                      end if
                      rs.close%>
          </div>
                          
            </div>                      
        </div>
        </form>
        <!--End Table Bordered-->	
        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
<script>
	
	function AbreLogoConvenio(Codigo, CodGrupo){
		window.open("EmpresaLogoMarca_cad.asp?CodGrupo=" + CodGrupo + "&CodEmpresa=" + Codigo, "consulta6", "top=0,left=0,height=480,width=550,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		return true;
 	}
	
	function resultadoConsulta(intCodigo){
		frm.action="Empresa_cad.asp?txtCodEmpresa="+intCodigo;
		frm.submit();
	}
	
	function salvar(acao){
	
		if (acao=="I") {
		
			if (frm.cmdGrupo.value == "0") {
				alert("O Grupo deve ser informado!");
				frm.cmdGrupo.focus();
				return false;
			} 
			if (frm.txtCNPJ.value == "") {
				alert("O CNPJ deve ser informado!");
				frm.txtCNPJ.focus();
				return false;
			} 
			
			if (frm.txtRazaoSocial.value == "") {
				alert("A Razão Social deve ser informada!");
				frm.txtRazaoSocial.focus();
				return false;
			} 
			
			if (frm.txtMantenedora.value == "") {
				alert("A Mantenedora deve ser informada!");
				frm.txtMantenedora.focus();
				return false;
			} 
			
			if (frm.txtAutorizacao.value == "") {
				alert("A Autorizacao de Funcionamento deve ser informada!");
				frm.txtAutorizacao.focus();
				return false;
			} 
			if (frm.txtEndereco.value == "") {
				alert("O Endereço deve ser informado!");
				frm.txtEndereco.focus();
				return false;
			} 
			
			if (frm.txtBairro.value == "") {
				alert("O Bairro deve ser informado!");
				frm.txtBairro.focus();
				return false;
			} 
			
			if (frm.txtMunicipio.value == "") {
				alert("O Municipio deve ser informado!");
				frm.txtMunicipio.focus();
				return false;
			} 
			
			if (frm.txtUF.value == "") {
				alert("O Estado deve ser informado!");
				frm.txtUF.focus();
				return false;
			} 
			
			if (frm.txtTelefone.value == "") {
				alert("O Telefone deve ser informado!");
				frm.txtTelefone.focus();
				return false;
			} 

			
			if (frm.Arq1.value == "") {
					alert("A Logo Marca deve ser informada !");
					frm.Arq1.focus();  
					return false;
			}	
			
			if((frm.Arq1.value.lastIndexOf(".jpg")==-1) && (frm.Arq1.value.lastIndexOf(".JPG")==-1) && (frm.Arq1.value.lastIndexOf(".gif")==-1)){  
				alert("Só é permitido fazer Upload das Imagens em JPG ou GIF!"); 
				frm.Arq1.focus();  
				return false  
			} 
		
			frm.action="Empresa_cod.asp?acao=" + acao + "&txtCodEmpresa=" + frm.txtCodEmpresa.value;
			frm.submit();
			return true;	
			
		} 
			
		if (acao=="A") {
		
			var parametro;
			parametro = "&txtCodEmpresa="+frm.txtCodEmpresa.value;
			parametro = parametro + "&txtCNPJ="+frm.txtCNPJ.value;
			parametro = parametro + "&txtRazaoSocial="+frm.txtRazaoSocial.value;
			parametro = parametro + "&txtMantenedora="+frm.txtMantenedora.value;
			parametro = parametro + "&txtAutorizacao="+frm.txtAutorizacao.value;
			parametro = parametro + "&txtDiretor="+frm.txtDiretor.value;
			parametro = parametro + "&txtSecretaria="+frm.txtSecretaria.value;
			parametro = parametro + "&txtContato="+frm.txtContato.value;
			parametro = parametro + "&txtContato1="+frm.txtContato1.value;
			parametro = parametro + "&txtContato2="+frm.txtContato2.value;
			parametro = parametro + "&txtEndereco="+frm.txtEndereco.value;
			parametro = parametro + "&txtBairro="+frm.txtBairro.value;
			parametro = parametro + "&txtMunicipio="+frm.txtMunicipio.value;
			parametro = parametro + "&txtUF="+frm.txtUF.value;
			parametro = parametro + "&txtCep="+frm.txtCep.value;
			parametro = parametro + "&txtTelefone="+frm.txtTelefone.value;
			parametro = parametro + "&cmdGrupo="+frm.cmdGrupo.value;
			parametro = parametro + "&txtemail="+frm.txtemail.value;
			parametro = parametro + "&txtemailDiretoria="+frm.txtemailDiretoria.value;
			parametro = parametro + "&txtemailFinanceiro="+frm.txtemailFinanceiro.value;
			parametro = parametro + "&txtemailModulacao="+frm.txtemailModulacao.value;
			parametro = parametro + "&txtemailLogins="+frm.txtemailLogins.value;
			parametro = parametro + "&cmbSimouNao="+frm.cmbSimouNao.value;
			parametro = parametro + "&cmbSimouNaoDadosCadastrais="+frm.cmbSimouNaoDadosCadastrais.value;
			parametro = parametro + "&txtNotificacao="+frm.txtNotificacao.value;
			parametro = parametro + "&txtCodigoCenso="+frm.txtCodigoCenso.value;
			parametro = parametro + "&txtCodigoSetransp="+frm.txtCodigoSetransp.value;
			parametro = parametro + "&txtNumeroSalaAula="+frm.txtNumeroSalaAula.value;
			parametro = parametro + "&cmbSimouNaoPersonalizarSistema="+frm.cmbSimouNaoPersonalizarSistema.value;
			parametro = parametro + "&cmbTipoEmpresa="+frm.cmbTipoEmpresa.value;
			frm.action="EmpresaAE_cod.asp?acao=" + acao + parametro;
			frm.submit();
			return true;	
		}
		
		if (acao=="E") {
		
			var parametro;
			parametro = "&txtCodEmpresa="+frm.txtCodEmpresa.value;
			frm.action="EmpresaAE_cod.asp?acao=" + acao + parametro;
			frm.submit();
			return true;	
		}
	}
	
	$(document).ready(function () {
		 $("#txtCep").on("blur", function () {
			var cep = $(this).val();
			if (cep != ""){
				obterEndercoPorCEP(cep);			
			}
		});
	});
	
	var obterEndercoPorCEP = function (numeroCEP) {
		$("#txtEndereco").val("");
		$("#txtBairro").val("");
		$("#txtUF").val("");
		$("#txtMunicipio").val("");

		var cep = numeroCEP.replace("-", "");
		var url = "https://viacep.com.br/ws/" + cep + "/json/";

		$.getJSON(url, cep)
		 .done(function (endereco) {
			 if (endereco != null) {
				 $("#txtEndereco").val($.trim(endereco.logradouro));
				 $("#txtBairro").val(endereco.bairro);
				 $("#txtUF").val(endereco.uf);
				 $("#txtMunicipio").val(endereco.localidade);
			 }
		 });
	};
</script>
<!--=== End Content Part ===-->
<!--#include file="../RodapeModulo.asp"-->
<!--#include file="../jsModulo.asp"-->
</body>
</html> 