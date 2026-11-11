<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"--> 
<!--#include file="../../includes/inc_replaceRequest.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script> 
	<%
        intCodEmpresa 			= Session("CodEmpresa")
        id						= Trim(Request.QueryString("id"))
		strOBs 					= Trim(Request("txtParecer"))
		codTipoUsuario 			= Trim(Request("cmbTipoUsuario"))
		if codTipoUsuario = "" then codTipoUsuario = "I"
		
		strRetiraBotaoExcluir 	= "N"
		strRetiraBotaoRecibo	= "S"
		
        strResponsavelAbertura	= Trim(session("UsuarioWeb"))
        strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
        strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
        strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
        if id = "" then id="0"
		if trim(id) <> "" then
            sql = "SELECT r.resumo, t.cod_Area, t.descricao as tipo_servico, a.descricao as area "
            sql = sql & " FROM SOS_REQUISICAO r "
            sql = sql & " inner join SOS_TIPO_SERVICO t on t.codigo = r.cod_tipo_servico "
			sql = sql & " inner join SOS_AREA a on a.codigo = t.cod_area"
            sql = sql & " where r.Codigo = " & id
            rs.open sql, cnn
            if rs.eof = false then
				intCodArea				= rs("cod_area")
                strResumo				= rs("resumo")
    			strTipoServico			= rs("tipo_servico")
				strArea					= rs("area")
            end if 
            rs.close
			
			
        else
            strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
            strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
            strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
        end if 

		strUsuarioPortal = trim(session("usuarioWeb"))
		strPerfilGestorArea = "N"
		sql = "select codigo "
		sql = sql & " from SOS_AREA"
		sql = sql & " where usua_codg = '"&strUsuarioPortal & "'"
		rs.open sql, cnn
		if not rs.eof then
			strPerfilGestorArea = "S"
		end if
		rs.close
		
		strPerfilExecutor = "N"
		sql = "select a.codigo "
		sql = sql & " from sos_requisicao_andamento a"
		sql = sql & " inner join sos_requisicao r on r.codigo = a.cod_requisicao"
		sql = sql & " where a.cod_requisicao=" & id
		sql = sql & " and a.cod_funcionario_externo in (select codigo from sos_funcionario_externo where codigo_seg_usuarios_sistema='"&strUsuarioPortal & "')"
		sql = sql & " order by a.codigo desc"	
		rs.open sql, cnn
		if not rs.eof then
			strPerfilExecutor = "S"
		end if
		rs.close
		
		if strPerfilExecutor = "S" then
			sql = "select codigo "
			sql = sql & " from SOS_FUNCIONARIO_EXTERNO"
			sql = sql & " where codigo_seg_usuarios_sistema = '"&strUsuarioPortal & "' "
			rs.open sql, cnn
			if not rs.eof then
				intCodExecutor = rs("codigo")
			end if
			rs.close
		end if		
		
		strPerfilMaster = "N"
		sql = "select usuario_master from [dbo].[SEG_USUARIOS_sistema] where usuario_master='S' and usua_codg='"&strUsuarioPortal & "'"	
		rs.open sql, cnn
		if not rs.eof then
			strPerfilMaster = "S"
			strPerfilExecutor = "N"
			strPerfilGestorArea = "N"
		end if
		rs.close
    %>
    <!--=== Content Part ===-->
    <form method="POST" id="frm" action="#">
    <input name="paginaOrigem" type="hidden" id="paginaOrigem" value="<%=paginaOrigem%>">

      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Encaminhar/Fechar OS</h3>
        </div>
        
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">   
               <form id="frm" class="margin-bottom-10" method="post">

                    <div class="form-group">
                        <label for="exampleInputEmail1">OS número:&nbsp;<%=id%></label><br>
                         <label for="exampleInputEmail1">Área:&nbsp;<%=strArea%></label><br>
                          <label for="exampleInputEmail1">Tipo de Serviço:&nbsp;<%=strTipoServico%></label><br>
                          <label for="exampleInputEmail1">Resumo:&nbsp;<%=strResumo%></label><br>
                         <input name="txtCodChamado" type="hidden" id="txtCodChamado" class="form-control" size="10" readonly=false value="<%=id%>" maxlength="10">
                    </div>
                    
                    <div class="form-group">
                        <label for="exampleInputEmail1">Executor:&nbsp;</label><br>
                        <!--#include file="../includes/inc_cmbExecutor.asp"-->
                    </div>
                    <div class="form-group">
                        <label>Serviço/Obs.:&nbsp;</label><br>
                        <textarea name="txtParecer"  style="width:320pt" cols="70" rows="6" class="form-control" id="txtParecer"><%=strOBs%></textarea>
                    </div>

                    
                    <input name="cmbTipoAndamento" type="hidden" id="cmbTipoAndamento" value="3">
                                        
                    <legend></legend>
                    <!--#include file="../includes/inc_botoes_cadastroPopap.asp"-->
                </form>
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
		
		if (frm.cmbExecutor.value == "0") {
			alert("O executor deve ser informado !");
			frm.cmbExecutor.focus();
			return false;
		}

		if (frm.txtParecer.value == "") {
			alert("O serviço ou obsservação deve ser informado !");
			frm.txtParecer.focus();
			return false;
		}

		if (frm.cmbTipoAndamento.value == "0") {
			alert("Tipo de andamento deve ser informada !");
			frm.cmbTipoAndamento.focus();
			return false;
		}
		
		frm.action="encaminhar_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<!--=== End Content Part ===-->
<!--include file="RodapeModulo.asp"-->
<!--#include file="../jsModulo.asp"-->
</body>
</html> 