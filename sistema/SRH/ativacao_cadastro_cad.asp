<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
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
        strPaginaTitulo = "ativacao_cadastro_cad.asp"
        intCodFuncionario 			= Trim(Request.Form("txtCodFuncionario"))
        intCodigo 					= Trim(Request.Form("txtCodigo"))
		strAno 						= Trim(Request.Form("txtAno"))
		if strAno = "" then strAno = year(date)
		
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
            
        if trim(intCodFuncionario) <> "" then
        
			sql = "select c.nome, c.codFuncional, c.codlotacao"
            sql = sql & " from srh_colaborador c"
            sql = sql & " where c.codigo=" & intCodFuncionario
            rs.open sql, cnn
            
            if rs.eof = false then
                
				strNome					= rs("nome")
				codFuncional			= rs("codFuncional")
				cod_lotacao				= rs("codlotacao")
                strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
                strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
                strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
    
            end if 
            rs.close
        end if 

            
        if trim(intCodigo) <> "" then
        
			sql = "select c.nome, c.codFuncional, a.codigo, a.observacao, c.codlotacao "
            sql = sql & " from SRH_ATIVACAO_CADASTRO a "
			sql = sql & " inner join SRH_COLABORADOR c on c.codigo = a.cod_colaborador"
            sql = sql & " where a.codigo=" & intCodigo
            rs.open sql, cnn
            
            if rs.eof = false then
                
				strNome					= rs("nome")
            	intCodFuncionario		= rs("codigo")    
				codFuncional			= rs("codFuncional")
				cod_lotacao				= rs("codlotacao")
				strObs					= rs("observacao")
                strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
                strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
                strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
    
            end if 
            rs.close
        end if 
    %>
     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Ativação de Cadastro</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
              
                    <div class="form-group">
                        <label class="form-label">Ano</label>
                        <input  name="txtAno" type="text" class="form-control" id="txtAno" value="<%=strAno%>" size="5" maxlength="5" onkeypress="return formataCampo(this,2,10)" onchange="submit()">
                    </div>
                    
             		<div class="form-group">
                    <label class="form-label">Colaborador</label>
                        <input name="txtCodFuncionario" value="<%=intCodFuncionario%>" type="hidden" id="txtCodFuncionario" >
                        <input name="cod_lotacao" value="<%=cod_lotacao%>" type="hidden" id="cod_lotacao" >
						<input name="txtNomeFuncionario" type="text" class="form-control" id="txtNomeFuncionario" size="50" maxlength="70" value="<%=strNome%>">&nbsp;<strong>*</strong>
                        <button class="btn btn-success" onclick="return abreConsultaColaborador('ColaboradorInativo_con.asp?PaginaOrigem=csolitacao_modulacao_cad')" type="button"><i class="fa fa-search"></i></button>
                    </div>
              
              		<div class="form-group">
                        <label class="form-label"></label>
                          <strong>Solicitar Ativação do Cadastro</strong>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Observação</label>
                        <textarea  onkeyup="blocTexto(this.value,'<%=cont%>')"  name="txtObs" cols="70" rows="4" class="text" id="txtObs"><%=strObs%></textarea>
                         <br /><font color="#FF0000">(caracteres restantes: <span id="cont">300</span>)</font></span>
                    </div>
                    
              
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Solicitações de Ativação de Cadastro de <strong><%=strAno%></strong></h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="4%" bgcolor="#95A5A6">Cód.</th>
                          <th width="35%" bgcolor="#95A5A6">Colaborador</th>
						  <th width="5%" bgcolor="#95A5A6">Matrícula</th>
						  <th width="25%" bgcolor="#95A5A6">Observação</th>
                          <th width="15%" bgcolor="#95A5A6">Usuário</th>
                          <th width="16%" bgcolor="#95A5A6">Situação</th>
						  <th width="1%" bgcolor="#95A5A6">Ação</th>
                      </tr>
                    </thead>
                     <tbody>
                    <%
                    cont =0
					sql = "select c.nome, c.codFuncional, s.situacao, s.observacao, s.codigo, s.cod_colaborador, s.data_hora_incl, s.usuario_incl, s.data_hora_autorizacao"
					sql = sql & " from SRH_ATIVACAO_CADASTRO s"
					sql = sql & " left join srh_colaborador c on s.Cod_colaborador = c.codigo"
					sql = sql & " where s.cod_Grupo = "& Session("CodGrupo")
					sql = sql & " and s.ano_letivo = " & strAno
					sql = sql & " Order by s.data_hora_incl desc "
                    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
                        cont = cont + 1	
						
						if rs("situacao") = "G" then situacao = "Enviado para autorização"
						if rs("situacao") = "F" then situacao = "Autorizado em "
						if rs("situacao") = "N" then situacao = "Não atendido em "
						%>
                        <tr>
                            <td><%=trim(rs("codigo"))%></td>
                            <td><%=trim(rs("nome"))%></td>
                            <td><%=trim(rs("codFuncional"))%></td>
							<td><%=trim(rs("observacao"))%></td>
                            <td align="left" ><strong><%=rs("usuario_incl")%></strong><br><font size="-1"><%=rs("data_hora_incl")%></font></td>
                            <td align="left" ><%=situacao%><br><font size="-1"><%=rs("data_hora_autorizacao")%></font></td> 
							<td align="center" >
							<%if rs("situacao") = "A" then %>
							<button class="btn-u btn-u-blue" onclick="resultadoConsulta('<%=trim(rs("codigo"))%>')" type="button"><i class="fa fa-edit"></i></button>
							<%end if%> 
							
							</td> 
                        </tr>
                    	<%		
                        rs.movenext
                        wend
                    end if
                    rs.close
                	%>
                    	<tr>
                    		<td colspan="7">Total Registros : <%=cont%></td>
                    	</tr>
                    </tbody>
                </table>
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
 		function abreConsultaColaborador(caminho){
            window.open(caminho,"abreColoborador","top=5,left=5,height=510,width=1000,menubar=no,toolbar=no,scrollbars=yes,status=yes");
        }
		
		function blocTexto(valor, id)
        {
            quant = 300;
            total = valor.length;
            if(total <= quant)
            {
                resto = quant - total;
                document.getElementById('cont').innerHTML = resto;
            }
            else
            {
                document.getElementById('txtResposta_'+id).value = valor.substr(0,quant);
            }
        }       
        function salvar(acao){
            
            var frm = document.getElementById("frm");

            if (frm.txtCodFuncionario.value == "") {
                alert("O colaborador deve ser informado!");
                frm.txtCodFuncionario.focus();
                return false;
            }

            if (frm.txtObs.value == "") {
                alert("A observação deve ser informada !");
                frm.txtObs.focus();
                return false;
            }

			frm.action="ativacao_cadastro_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
		
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 