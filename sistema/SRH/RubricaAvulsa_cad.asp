<!--#include file="../../includes/inc_verificaSession.asp"-->
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
        strPaginaTitulo 	= "RubricaAvulsa_cad.asp"
        strCodFunc			= Trim(Request("txtCodFuncionario"))
        strNome 			= Trim(Request("txtNomeFuncionario"))
        strCodRubrica		= Trim(Request("txtCodRubrica"))
        strNomeRubrica		= Trim(Request("txtNomeRubrica"))
        intValorRubrica		= Trim(Request("txtValorRubrica"))
        
        strMes				= Trim(Request("cmbMes"))
        strAno				= Trim(Request("cmbAno"))
        if strMes = "" then strMes = month(date)
        if strAno = "" then strAno = year(date)
        
        if trim(strCodFunc) <> "" then
        
            sql = "Select Codigo, nome, situacao "
            sql = sql & " from SRH_colaborador"
            sql = sql & " where cod_empresa = " & session("CodEmpresa")
            sql = sql & " and codigo = " & strCodFunc
            rs.open sql, cnn
            if rs.eof = false then
                strCodFunc			= Trim(rs("codigo"))
                strNome 			= Trim(rs("Nome"))
                if Trim(rs("situacao")) = "I" then
                    %>
                    <script>
                        alert("ATENÇÃO: Colaborador está inativo no cadastro.");
                    </script>
                    <%
                    strCodFunc			= ""
                    strNome 		= ""
                end if
            else
                strCodFunc			= ""
                strNome 		= ""
                %>
                <script>
                    alert("ATENÇÃO: Colaborador não foi encontrado.");
                </script>
                <%
            end if
            rs.close	
        
        else
            strCodFunc			= ""
            strNome 			= ""
        end if
        if trim(strCodRubrica) <> "" then
        
            sql = "Select Codigo, descricao, Situacao_rubrica, valor_rubrica"
            sql = sql & " from SRH_rubrica"
            sql = sql & " where cod_grupo = " & session("CodGrupo")
            sql = sql & " and codigo = " & strCodRubrica
            rs.open sql, cnn
            if rs.eof = false then
                strCodRubrica			= Trim(rs("codigo"))
                strNomeRubrica 			= Trim(rs("descricao"))
                intValorRubrica = ""
                if not isnull(rs("valor_rubrica")) then
                    intValorRubrica = formatNumber(rs("valor_rubrica"),2)	
                end if
                if Trim(rs("Situacao_rubrica")) = "I" then
                    %>
                    <script>
                        alert("ATENÇÃO: Rubrica está inativa no cadastro.");
                    </script>
                    <%
                    strCodRubrica		= ""
                    strNomeRubrica 		= ""
                    intValorRubrica		= ""
                end if
            else
                strCodRubrica			= ""
                strNomeRubrica 			= ""
                intValorRubrica			= ""
                %>
                <script>
                    alert("ATENÇÃO: Rubrica não foi encontrada.");
                </script>
                <%
            end if
            rs.close	
        
        else
            strCodRubrica			= ""
            strNomeRubrica 			= ""
        end if
    
        strDesabilitaIncluir = "" 'Desabilita o botão Incluir'
        strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
        strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
        strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
    
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Cadastro da Rubricas Avulsas</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                
                    <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                    
                    <div class="form-group">
                        <label class="form-label">Folha</label>
                        <!--#include file="../includes/inc_cmbTipoFolha.asp"-->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">M&ecirc;s/Ano</label>
                    	<!--#include file="../includes/inc_cmbMes.asp"-->/<!--#include file="../includes/inc_cmbAno.asp"-->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Colaborador</label>
                    	<input name="txtCodFuncionario" type="text" class="form-control" id="txtCodFuncionario" size="20" maxlength="20" value="<%=strCodFunc%>"  onKeyPress="return formataCampo(this, 2, 9)" onBlur="submit()">
                    	<button class="btn-u btn-u-green" onClick="return abreConsulta('Colaborador_con.asp')" type="button"><i class="fa fa-search"></i></button>
                    	<input readonly name="txtNomeFuncionario" type="text" class="form-control" id="txtNomeFuncionario" size="50" maxlength="50" value="<%=strNome%>" >
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Rubrica</label>
                    	<input name="txtCodRubrica" type="text" class="form-control" id="txtCodRubrica" size="20" maxlength="20" value="<%=strCodRubrica%>"  onKeyPress="return formataCampo(this, 2, 9)" onBlur="submit()">
                    	<button class="btn-u btn-u-green" onClick="return abreConsulta('Rubrica_con.asp')" type="button"><i class="fa fa-search"></i></button>
                    	<input readonly name="txtNomeRubrica" type="text" class="form-control" id="txtNomeRubrica" size="50" maxlength="50" value="<%=strNomeRubrica%>" >
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Valor</label>
                        <input name="txtValorRubrica" type="text" class="form-control" id="txtValorRubrica" onKeyPress="return currencyFormat(this,event)" size="11" maxlength="10" value="<%=intValorRubrica%>">
                    </div>

                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
       <%if strCodFunc <> "" and strCodFunc <> "0" then	%> 
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-h
            eading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Rubricas Avulsas</h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="5%" bgcolor="#95A5A6">C&oacute;digo</th>
                          <th width="59%" bgcolor="#95A5A6">Rubrica</th>
                          <th width="11%" bgcolor="#95A5A6">Valor da Rubrica</th>
                          <th width="6%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                      </tr>
                    </thead>
                     <tbody>
                    <%
                    cont =0
					sql = "SELECT SRH_RUBRICA_COLABORADOR_AVULSA.Cod_Empresa, SRH_RUBRICA_COLABORADOR_AVULSA.Codigo, SRH_RUBRICA_COLABORADOR_AVULSA.VALOR_RUBRICA, SRH_RUBRICA.Descricao AS RUBRICA, SRH_RUBRICA_COLABORADOR_AVULSA.COD_RUBRICA"
					sql = sql & " FROM SRH_RUBRICA_COLABORADOR_AVULSA "
					sql = sql & " INNER JOIN SRH_RUBRICA ON SRH_RUBRICA.CODIGO = SRH_RUBRICA_COLABORADOR_AVULSA.COD_RUBRICA "
					sql = sql & " where SRH_RUBRICA_COLABORADOR_AVULSA.Cod_Empresa = " & Session("CodEmpresa")	
					sql = sql & " and SRH_RUBRICA_COLABORADOR_AVULSA.Cod_Colaborador = " & strCodFunc	
					sql = sql & " and SRH_RUBRICA_COLABORADOR_AVULSA.Mes = " & strMes	
					sql = sql & " and SRH_RUBRICA_COLABORADOR_AVULSA.Ano = " & strAno
					sql = sql & " Order by SRH_RUBRICA.Descricao"
                    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
                        cont = cont + 1
						%>
                        <tr>
                            <td><%=trim(rs("COD_RUBRICA"))%></td>
                            <td><%=trim(rs("RUBRICA"))%></td>
                            <td><%=FORMATNUMBER(rs("VALOR_RUBRICA"),2)%></td>
                            <td align="center" >
                            <button class="btn-u btn-u-sea" onClick="ExcluirRubrica('<%=rs("codigo")%>')" type="button"><i class="fa fa-trash-o"></i></button>                            </td> 
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
        function salvar(acao){
                
            var frm = document.getElementById("frm");
            
            if (frm.txtCodFuncionario.value == "") {
                alert("O colaborador deve ser informado!");
                frm.txtCodFuncionario.focus();
                return false;
            }
            if (frm.txtNomeFuncionario.value == "") {
                alert("Colaborador deve ser informado!");
                frm.txtCodFuncionario.focus();
                return false;
            }
            if (frm.txtCodRubrica.value == "") {
                alert("Rubrica deve ser informada!");
                frm.txtCodRubrica.focus();
                return false;
            }
            if (frm.txtNomeRubrica.value == "") {
                alert("Rubrica deve ser informada!");
                frm.txtCodRubrica.focus();
                return false;
            }
    
            frm.action="RubricaAvulsa_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
        function ExcluirRubrica(Codigo){
            
            var frm = document.getElementById("frm");
            var men = 'ATENÇÃO: \nDeseja excluir a rubrica do colaborador?';
            if (confirm(men)) {
                var acao ="E";
                frm.action="RubricaAvulsa_cod.asp?txtCodigo=" +  Codigo  + "&acao=" + acao;
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