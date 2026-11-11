	<!--#include file="config.asp"-->
    <!--#include file="../includes/inc_cnn.asp"-->
	<%	
        intCodEmpresa 			= Session("CodEmpresa")
        intCodChamado			= Trim(Request.QueryString("CodChamado"))
        strResponsavelAbertura	= Trim(session("UsuarioWeb"))
        strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
        strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
        strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
        if intCodChamado = "" then intCodChamado="0"
    
        BolDono = false
        sql = "SELECT Cod_Usuario_Abertura, ocorrencias, observacao, situacao, Cod_Usuario_Destino, ISNULL(Visto_Gestor,'N') as Visto_Gestor " 
        sql = sql & " FROM SCH_CHAMADO "
        sql = sql & " Where Codigo = " & intCodChamado	
        RS.OPEN SQL, CNN
        IF NOT RS.EOF THEN
           if ucase(trim(RS("Cod_Usuario_Abertura"))) = ucase(trim(strResponsavelAbertura)) then
              strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
              BolDono = true
           end if  
           strOBs			 	= RS("observacao")
           srtSituacao 			= RS("situacao")
           intCodUsuarioChamado = RS("Cod_Usuario_Destino")
		   intCodUsuarioAbertura = RS("Cod_Usuario_Abertura")
           strParecerSuporte 	= RS("Visto_Gestor")
		   strChamadoAbertura	= replace(RS("ocorrencias"),">","/")
        end if   
        RS.close
    
        if trim(strResponsavelAbertura) <> "" then
        
            sql = "SELECT ISNULL(USUARIO_MASTER,'N') AS USUARIO_MASTER, ISNULL(GESTOR_MANUTENCAO,'N') AS GESTOR_MANUTENCAO, ISNULL(GESTOR_SUPORTE,'N') AS GESTOR_SUPORTE "
            sql = sql & " FROM SEG_USUARIOS_SISTEMA"
            sql = sql & " Where USUA_CODG = '" & strResponsavelAbertura & "'"
            rs.open sql, cnn
            if rs.eof = false then
                UsuarioMaster				= Trim(rs("USUARIO_MASTER"))
                GestorManutencao			= Trim(rs("GESTOR_MANUTENCAO"))
                GestorSuporte				= Trim(rs("GESTOR_SUPORTE"))
            end if 
            rs.close
        end if 
        
        if  trim(UsuarioMaster) = "" then UsuarioMaster = "N"
        if  trim(GestorManutencao) = "" then GestorManutencao = "N"
        if  trim(GestorSuporte) = "" then GestorSuporte = "N"
        
    %>
     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Fechamento de Chamado</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">

                    <div class="form-group">
                        <label for="exampleInputEmail1">C&oacute;digo Chamado</label>
                         <input name="txtCodChamado" type="text" id="txtCodChamado" class="form-control" size="10" readonly=false value="<%=intCodChamado%>" maxlength="10">
                    </div>
                    <div class="form-group">
                        <label for="exampleInputEmail1">Aberto por</label>
                         <input readonly name="txtCodChamadoAbertura" type="text" id="txtCodChamadoAbertura" class="form-control" size="100" readonly=false value="<%=intCodUsuarioAbertura%>">
                         <input readonly name="txtChamadoAbertura" type="hidden" id="txtChamadoAbertura" value="<%=strChamadoAbertura%>">
                    </div>
                    <div class="form-group">
                        <label for="exampleInputEmail1">Observa&ccedil;&atilde;o</label>
                        <textarea name="txtOBs" cols="10" rows="2" class="form-control" id="txtOBs"><%=strOBs%></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="exampleInputEmail1">Encaminhamento Para</label>
                        <!--#include file="includes/inc_cmbUsuariosChamado.asp" -->
                    </div>
                    
                    <div class="form-group">
                        <label for="exampleInputEmail1">Situa&ccedil;&atilde;o</label>
                        <select name="cmbSituacao" class="form-control" id="cmbSituacao" style="width:80pt">
                        <!-- <option value="0">Selecione...</option>-->
                        <%' if BolDono then %>
                        <option value="A" <%if srtSituacao = "A" then response.Write("selected") %>>Ativo</option>
			<option value="P" <%if srtSituacao = "P" then response.Write("selected") %>>Pendente</option>
                        <option value="F" <%if srtSituacao = "F" then response.Write("selected") %>>Fechado</option>
                        <option value="S" <%if srtSituacao = "S" then response.Write("selected") %>>Suspenso</option>
                        <option value="E" <%if srtSituacao = "E" then response.Write("selected") %>>Executado</option>
                        <%' else %>
                        <!--option value="E" <%if srtSituacao = "E" then response.Write("selected") %>>Executado</option>
                        <option value="P" <%if srtSituacao = "P" then response.Write("selected") %>>Pendente</option-->
                        <%' end if %>
                      </select>
                    </div>
                    
                    <% 'if BolDono = true then %>
                        <div class="form-group">
                            <label for="exampleInputEmail1">Parecer do Suporte</label>
                            <select name="cmbParecerSuporte" class="form-control" id="cmbParecerSuporte" style="width:80pt">
                            <option value="S" <%if strParecerSuporte = "S" then response.Write("selected") %>>Sim</option>
                            <option value="N" <%if strParecerSuporte = "N" then response.Write("selected") %>>N&atilde;o</option>
                            </select>
                        </div>
                    <% 'end if%>
                    
                    <legend></legend>
                    <!--#include file="../includes/inc_botoes_cadastroPopap.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>

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
		
		if (frm.txtCodChamado.value == "") {
			alert("O Codigo do Chamado deve ser informado !");
			frm.txtCodChamado.focus();
			return false;
		}
		
		if (frm.cmbUsuarioChamado.value == "0") {
			alert("O Usuário de Destino deve ser informado !");
			frm.cmbUsuarioChamado.focus();
			return false;
		}
		if (frm.cmbSituacao.value == "0") {
			alert("A Situacao deve ser informada !");
			frm.cmbSituacao.focus();
			return false;
		}
		
		frm.action="FechamentoChamado_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<!--=== End Content Part ===-->
<!--include file="RodapeModulo.asp"-->
<!--#include file="jsModulo.asp"-->
</body>
</html> 