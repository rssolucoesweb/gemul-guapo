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
        strPaginaTitulo			= "Ocorrencia_cad.asp"
        intCodOcorrencia 		= Trim(Request.Form("txtCodigo"))
        intCodDepartamento		= Session("CodDeptoUsuario")
        strCodFuncionario 		= Trim(Request.Form("txtCodFuncionario"))
        strNome		 			= Trim(Request.Form("txtNomeFuncionario"))
        strDataOcorrencia 		= Trim(Request.Form("txtDataOcorrencia"))
        IF strDataOcorrencia = "" THEN strDataOcorrencia = formatadataAP(date)
        strDataValidade 		= Trim(Request.Form("txtDataValidade"))
        strOcorrencia 			= Trim(Request.Form("txtOcorrencia"))
        
        if trim(strMatricula) <> "" then
           sql = "SELECT codigo from sca_aluno "
           sql = sql & " Where cod_empresa = " & Session("CodEmpresa")			
           sql = sql & " And matricula = '" & strMatricula & "'"
           rs.open sql, cnn
           if rs.eof = false then
              strCodAluno				= rs("codigo")
           end if
           rs.close	  
        end if   
        
        if trim(intCodDepartamento) <> "" then
        
           sql = "SELECT CODIGO, COD_EMPRESA, DESCRICAO "
           sql = sql & " From SEG_DEPARTAMENTO "
           sql = sql & " Where CODIGO = " & intCodDepartamento 
           rs.open sql, cnn
    
           if rs.eof = false then
              Session("DescDeptoUsuario") = rs("DESCRICAO")
           end if
           rs.close	  
        end if   
        
        if trim(intCodOcorrencia) <> "" then
        
            sql = "SELECT O.COD_OCORRENCIA, O.COD_DEPARTAMENTO, A.CODIGO, A.NOME, O.DATAOCORRENCIA, O.DATAVALIDADE, O.OCORRENCIA"
            sql = sql & " FROM SRH_OCORRENCIA O"
            sql = sql & " LEFT JOIN SRH_COLABORADOR A ON A.CODIGO = O.COD_COLABORADOR AND A.COD_EMPRESA = O.COD_EMPRESA"
            sql = sql & " Where O.COD_OCORRENCIA = " & intCodOcorrencia
            sql = sql & " And O.cod_empresa = " & Session("CodEmpresa")			
            
            rs.open sql, cnn
            
            if rs.eof = false then
                intCodOcorrencia 		= rs("COD_OCORRENCIA")
                intCodDepartamento		= rs("COD_DEPARTAMENTO")
                strCodFuncionario		= rs("CODIGO")
                strNome			 		= rs("NOME")
                strDataOcorrencia 		= FORMATADATAAP(rs("DATAOCORRENCIA"))
                strDataValidade 		= FORMATADATAAP(rs("DATAVALIDADE"))
                strOcorrencia 			= rs("OCORRENCIA")
    
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
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro de Ocorrências</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
            
                    <div class="form-group">
                        <label class="form-label">Consultar Ocorr&ecirc;ncias</label>
                        <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodOcorrencia%>" maxlength="10">
                        <button class="btn-u btn-u-sea" onClick="return abreConsultaOcorrencia()" type="button"><i class="fa fa-search"></i></button>  
                    </div>
                
                    <div class="form-group">
                        <label class="form-label">Colaborador</label>
                        <input name="txtCodFuncionario" type="text" class="form-control" id="txtCodFuncionario" size="10" maxlength="10" value="<%=strCodFuncionario%>"  onKeyPress="return formataCampo(this, 2, 10)" onChange="submit()">
                        <button class="btn-u btn-u-sea" onClick="return abreConsulta('Colaborador_con.asp')" type="button"><i class="fa fa-search"></i></button>  
                        <input name="txtNomeFuncionario" type="text" class="form-control" id="txtNomeFuncionario" size="50" maxlength="50" value="<%=strNome%>"  onKeyPress="return formataCampo(this, 1, 50)">
                    </div>
                
                     <div class="form-group">
                        <label class="form-label">Departamento</label>
                        <input name="cmbDepartamento" type="text" class="form-control" id="cmbDepartamento" value="<%=intCodDepartamento%>" size="10" maxlength="10" readonly="true">
                        <input readonly="true" name="txtDescDepto" type="text" class="form-control" id="txtDescDepto" size="50" value="<%=Session("DescDeptoUsuario")%>">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Data Ocorr&ecirc;ncia</label>
                        <input name="txtDataOcorrencia" type="text" class="form-control" id="txtDataOcorrencia" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataOcorrencia%>" title="Click aqui para visualizar o calend&aacute;rio">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Validade Ocorr&ecirc;ncia</label>
                   		<input name="txtDataValidade" type="text" class="form-control" id="txtDataValidade" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataValidade%>" title="Click aqui para visualizar o calend&aacute;rio">
                    </div>
                   
                    <div class="form-group">
                        <label class="form-label">Ocorr&ecirc;ncia</label>
                   		<textarea name="txtOcorrencia" cols="60" rows="5" class="form-control" id="txtOcorrencia"><%=strOcorrencia%></textarea>
                    </div>
                
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
       <%if trim(strCodFuncionario) <> "" then%>
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Ocorrências</h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="7%" bgcolor="#95A5A6">Data</th>
                          <th width="73%" bgcolor="#95A5A6">Ocorr&ecirc;ncia</th>
                          <th width="16%" bgcolor="#95A5A6">Validade</th>
                          <th width="16%" bgcolor="#95A5A6">Usu&aacute;rio</th>
                          <th width="4%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                      </tr>
                    </thead>
                     <tbody>
                    <%
                    cont =0
					sql = "SELECT O.COD_OCORRENCIA, O.COD_DEPARTAMENTO, A.CODIGO, A.NOME, O.DATAOCORRENCIA, O.DATAVALIDADE, O.OCORRENCIA, O.USUARIO_INCL"
					sql = sql & " FROM SRH_OCORRENCIA O"
					sql = sql & " LEFT JOIN SRH_COLABORADOR A ON A.CODIGO = O.COD_COLABORADOR AND A.COD_EMPRESA = O.COD_EMPRESA"
					sql = sql & " where O.cod_empresa = " & Session("CodEmpresa")			
					sql = sql & " and O.COD_DEPARTAMENTO = " & intCodDepartamento	
					sql = sql & " and O.COD_COLABORADOR = " & strCodFuncionario
					sql = sql & " order by O.DATAOCORRENCIA DESC"
                    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
                        cont = cont + 1	
                    	%>
                        <tr>
                            <td><%=trim(rs("DATAOCORRENCIA"))%></td>
                            <td><%=trim(rs("OCORRENCIA"))%></td>
                            <td><%=trim(rs("DATAVALIDADE"))%></td>
                            <td><%=trim(rs("USUARIO_INCL"))%></td>
                            <td align="center" >
                            <button class="btn-u btn-u-sea" onClick="resultadoConsulta(<%=trim(rs("COD_OCORRENCIA"))%>)" type="button"><i class="fa fa-file-text-o"></i></button>                            </td> 
                        </tr>
                    	<%				
                        rs.movenext
                        wend
                    end if
                    rs.close
                	%>
                    	<tr>
                    		<td colspan="5">Total Registros : <%=cont%></td>
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
	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	function abreConsultaOcorrencia(){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbDepartamento.value == "0") {
			alert("O Departamento deve ser informado !");
			frm.cmbDepartamento.focus();
			return false;
		}		
		var caminho = "Ocorrencia_con.asp?cmbDepartamento=" + frm.cmbDepartamento.value;
		window.open(caminho,"abreConsulta","top=5,left=5,height=510,width=519,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}	
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbDepartamento.value == "0") {
			alert("O Departamento deve ser informada !");
			frm.cmbDepartamento.focus();
			return false;
		}
		
		if (frm.txtCodFuncionario.value == "") {
			alert("O colaborador deve ser informado !");
			frm.txtCodFuncionario.focus();
			return false;
		}
		
		if (frm.txtDataOcorrencia.value == "") {
			alert("A Data da Ocorrência deve ser informada !");
			frm.txtDataOcorrencia.focus();
			return false;
		}
		
		if (frm.txtDataValidade.value == "") {
			alert("A Data de Validade da Ocorrência deve ser informada !");
			frm.txtDataValidade.focus();
			return false;
		}
		
		if (frm.txtOcorrencia.value == "") {
			alert("A Ocorrência deve ser informada !");
			frm.txtOcorrencia.focus();
			return false;
		}
		
		frm.action="Ocorrencia_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 