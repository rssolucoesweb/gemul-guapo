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
        strPaginaTitulo = "solicitacao_modulacao_cad.asp"
	    strBotaoEnviarParaSecSolicModucacao	= "S"
        intCodFuncionario 			= Trim(Request.Form("txtCodFuncionario"))
        intCodigo 					= Trim(Request.Form("txtCodigo"))
		strAno 						= Trim(Request.Form("txtAno"))
		if strAno = "" then strAno = year(date)
		
		intCodFuncao				= Request.Form("cmbFuncao")	
		intCodTurno					= Request.Form("cmbTurnoRH")	
		intCodLotacao				= Request.Form("cmbLotacao")
		intCodFuncaoCategoria		= Request.Form("cmbFuncaoCategoria")
		deficit						= Request.Form("deficit")
		
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
            
        if trim(intCodFuncionario) <> "" then
        
			sql = "select c.nome, c.codFuncional,c.codLotacao, c.carga_horario_contratada, c.codfuncao, f.Desc_Funcao, c.CodFormaNomeacao, m.Desc_FormaNomeacao, c.CodCargo, ca.Desc_Cargo, c.CodTurno, tu.Desc_Turno, f.Cod_funcaoCategoria"
            sql = sql & " from srh_colaborador c"
            sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = c.codfuncao"
            sql = sql & " left join SRH_FORMANOMEACAOCOLABORADOR m on m.Cod_FormaNomeacao = c.CodFormaNomeacao"
            sql = sql & " left join SRH_CARGOCOLABORADOR ca on ca.Cod_Cargo = c.CodCargo"
            sql = sql & " left join SRH_TURNO tu on tu.Cod_Turno = c.CodTurno"
            sql = sql & " where c.codigo=" & intCodFuncionario
		'	response.write sql	
            rs.open sql, cnn
            
            if rs.eof = false then
                
				strNome					= rs("nome")
				carga_horaria			= rs("carga_horario_contratada")
				
				if intCodFuncao = "" or intCodFuncao = "0" then
                    intCodFuncao		= rs("codfuncao")
                end if					
				if intCodTurno = "" or intCodTurno = "0" then
                    intCodTurno		= rs("CodTurno")
                end if					
				if intCodLotacao = "" or intCodLotacao = "0" then
                    intCodLotacao		= rs("codLotacao")
                end if					
				if intCodFuncaoCategoria = "" or  intCodFuncaoCategoria = "0" then
                    intCodFuncaoCategoria		= rs("cod_FuncaoCategoria")
                end if					
				
				cargo					= rs("Desc_Cargo")
				vinculo					= rs("Desc_FormaNomeacao")	
                cod_cargo				= rs("CodCargo")	
                cod_FormaNomeacao		= rs("CodFormaNomeacao")	

                strObs					= ""
                strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
                strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
                strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
    
            end if 
            rs.close
        end if 

            
        if trim(intCodigo) <> "" then
        
			sql = "select c.nome, c.codFuncional, s.codigo, s.cod_lotacao, s.cod_colaborador, s.cod_funcao, s.cod_cargo, s.cod_FormaNomeacao, s.cod_turno, s.carga_horaria, s.observacao, m.Desc_FormaNomeacao, ca.Desc_Cargo, fa.Cod_funcaoCategoria"
            sql = sql & " from srh_colaborador c"
            sql = sql & " inner join SRH_SOLICITACAO_MODULACAO s on s.Cod_colaborador = c.codigo"
			sql = sql & " left join SRH_FORMANOMEACAOCOLABORADOR m on m.Cod_FormaNomeacao = c.CodFormaNomeacao"
            sql = sql & " left join SRH_CARGOCOLABORADOR ca on ca.Cod_Cargo = c.CodCargo"
            sql = sql & " left join SRH_FUNCAOCOLABORADOR fa on fa.Cod_funcao = s.cod_funcao"
			sql = sql & " left join SRH_FUNCAOCATEGORIA fc on fc.codigo = fa.Cod_funcaoCategoria"
            sql = sql & " where s.codigo=" & intCodigo
            rs.open sql, cnn
            
            if rs.eof = false then
                
				strNome					= rs("nome")
				carga_horaria			= rs("carga_horaria")
            	intCodFuncionario		= rs("cod_colaborador")    
                intCodLotacao			= rs("cod_lotacao")
                intCodFuncao			= rs("cod_funcao")	
				intCodFuncaoCategoria	= rs("cod_FuncaoCategoria")
                intCodTurno				= rs("cod_turno")	
                cod_cargo				= rs("cod_cargo")	
                cod_FormaNomeacao		= rs("cod_FormaNomeacao")	
				
				cargo					= rs("Desc_Cargo")
				vinculo					= rs("Desc_FormaNomeacao")	
				strObs					= rs("observacao")
				
                strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
                strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Solicitação de Modulação</h3>
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
                         <input name="cod_cargo" value="<%=cod_cargo%>" type="hidden" id="cod_cargo" >
                          <input name="cod_FormaNomeacao" value="<%=cod_FormaNomeacao%>" type="hidden" id="cod_FormaNomeacao" >
                        <input name="txtNomeFuncionario" type="text" class="form-control" id="txtNomeFuncionario" size="50" maxlength="70" value="<%=strNome%>">&nbsp;<strong>*</strong>
                        <button class="btn btn-success" onclick="return abreConsultaColaborador('Colaborador_con.asp?PaginaOrigem=csolitacao_modulacao_cad')" type="button"><i class="fa fa-search"></i></button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>Déficit</strong>&nbsp;&nbsp;<input <%if deficit<>"" then response.write "checked"%> name="deficit" id="deficit" type="checkbox" value="S">
                    </div>
              
              		<div class="form-group">
                        <label class="form-label">Lotação</label>
                          <!--#include file="../includes/inc_cmbLotacao.asp" -->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Função Categoria</label>
                        <!--#include file="../includes/inc_cmbFuncaoCategoria.asp" -->
                    </div>

              
                    <div class="form-group">
                        <label class="form-label">Função</label>
                         <!--#include file="../includes/inc_cmbFuncao.asp" -->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Carga Horária</label>
                        <input name="carga_horaria" type="text" class="form-control" id="carga_horaria" size="20" maxlength="5" value="<%=carga_horaria%>" />
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Graduação</label>
                          <strong><%=cargo%></strong>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Vinculo</label>
                        <strong><%=vinculo%></strong>
                    </div>
                    
                   <div class="form-group">
                        <label class="form-label">Turno</label>
                          <!--#include file="../includes/inc_cmbTurno.asp" -->
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
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Solicitações de <strong><%=strAno%></strong></h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="4%" bgcolor="#95A5A6">Cód.</th>
                          <th width="21%" bgcolor="#95A5A6">Colaborador</th>
                          <th width="21%" bgcolor="#95A5A6">Unidade</th>
                          <th width="16%" bgcolor="#95A5A6">Função</th>
                          <th width="13%" bgcolor="#95A5A6">Cargo</th>
                          <th width="7%" bgcolor="#95A5A6">Turno</th>
                          <th width="13%" bgcolor="#95A5A6" align="center">Situação</th>
                          <th width="5%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                      </tr>
                    </thead>
                     <tbody>
                    <%
                    cont =0
					sql = "select isnull(c.nome,'DÉFICIT') as nome, c.codFuncional, e.razaosocial, s.situacao, s.codigo, s.cod_lotacao, fc.descricao as categoria, fa.desc_funcao, s.cod_colaborador, s.data_hora_altr, s.cod_funcao, s.cod_cargo, s.cod_FormaNomeacao, s.cod_turno, s.carga_horaria, s.observacao, m.Desc_FormaNomeacao, ca.Desc_Cargo, tu.desc_turno"
					sql = sql & " from SRH_SOLICITACAO_MODULACAO s"
					sql = sql & " left join srh_colaborador c on s.Cod_colaborador = c.codigo"
					sql = sql & " left join SEG_EMPRESA e on e.codigo = s.cod_empresa"
					sql = sql & " left join SRH_FORMANOMEACAOCOLABORADOR m on m.Cod_FormaNomeacao = c.CodFormaNomeacao"
					sql = sql & " left join SRH_CARGOCOLABORADOR ca on ca.Cod_Cargo = c.CodCargo"
				 	sql = sql & " left join SRH_TURNO tu on tu.Cod_Turno = c.CodTurno"
					sql = sql & " left join SRH_FUNCAOCOLABORADOR fa on fa.Cod_funcao = s.cod_funcao"
					sql = sql & " left join SRH_FUNCAOCATEGORIA fc on fc.codigo = fa.Cod_funcaoCategoria"
					'sql = sql & " where e.cod_Grupo = "& Session("CodGrupo")	
					sql = sql & " where s.cod_empresa = "& Session("CodEmpresa")
					sql = sql & " and s.ano_letivo = " & strAno
					sql = sql & " Order by fc.descricao, s.codigo "
                    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
                        cont = cont + 1	
						IF trim(RS("categoria"))<>trim(categoria) then
						%>
                        <tr>
                          <td colspan="8" align="center" bgcolor="#CCCCCC"><strong><%=rs("categoria")%></strong></td>
                        </tr>
                        <%
						end if
						
						if rs("situacao") = "A" then situacao = "Digitação"
						if rs("situacao") = "F" then situacao = "Enviado"
						%>
                        <tr>
                            <td><%=trim(rs("codigo"))%></td>
                            <td><%=trim(rs("nome"))%></td>
                            <td><%=trim(rs("razaosocial"))%></td>
                            <td><%=trim(rs("desc_funcao"))%></td>
                            <td><%=trim(rs("Desc_Cargo"))%></td>
                            <td><%=trim(rs("desc_turno"))%></td>
                            <td align="center" ><strong><%=situacao%></strong><br><font size="-1"><%=rs("data_hora_altr")%></font></td>
                            <td align="center" >
                            <%if rs("situacao") = "A" then%>
                            <button class="btn-u btn-u-sea" onclick="resultadoConsulta(<%=trim(rs("codigo"))%>)" type="button"><i class="fa fa-file-text-o"></i></button>                            
                            <%end if%>
							<%if session("nivelPermissao")="A" then%> 
                                <%if trim(rs("situacao")) = "F" then%><a href="#" onclick="devolver('<%=rs("CODIGO")%>')" ><img src="../../images/botao_azul_normal.gif" alt="Devolver" width="26" height="26" border="0"></a><%end if%>
                            <%end if%>
                            </td> 
                        </tr>
                    	<%		
						categoria = rs("categoria")		
                        rs.movenext
                        wend
                    end if
                    rs.close
                	%>
                    	<tr>
                    		<td colspan="8">Total Registros : <%=cont%></td>
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
            if (frm.deficit.checked == false){
				if (frm.txtCodFuncionario.value == "") {
					alert("O Colaborador deve ser informado !");
					frm.txtCodFuncionario.focus();
					return false;
				}
			}
            if (frm.cmbLotacao.value == "0") {
                alert("A lotação deve ser informada !");
                frm.cmbLotacao.focus();
                return false;
            }
            if (frm.cmbFuncao.value == "0") {
                alert("A função deve ser informada !");
                frm.cmbFuncao.focus();
                return false;
            }
            if (frm.cmbTurnoRH.value == "0") {
                alert("O turno deve ser informado !");
                frm.cmbTurnoRH.focus();
                return false;
            }            
			frm.action="solicitacao_modulacao_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
		
		function enviar(){
            var frm = document.getElementById("frm");
			frm.action="solicitacao_modulacao_cod.asp?acao=F";
            frm.submit();
            return true;
        }
		function devolver(cod){
            var frm = document.getElementById("frm");
			frm.action="solicitacao_modulacao_cod.asp?acao=D&txtCodigo="+cod;
            frm.submit();
            return true;
        }
    	function estrutura(){
            var frm = document.getElementById("frm");
			frm.action="DiretrizesFisica_cad.asp";
            frm.submit();
            return true;
        }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 