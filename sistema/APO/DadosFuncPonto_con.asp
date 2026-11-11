<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
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
        pagina							= "DadosFuncPonto_con.asp"
        intCodColaborador				= Trim(Request.form("txtCodFuncionario"))
        intCodFuncional  				= Trim(Request.Form("txtCodigoFuncional"))
        strnome 						= Trim(Request.Form("txtNomeFuncionario"))
        intCodEmpresa 					= Session("CodEmpresa")	
		
        if intCodColaborador = "" then intCodColaborador = "0"
		
        if (Trim(Request.Form("LocalizarMatricula")) = "S" and intCodFuncional <> "") OR (intCodColaborador<>"" AND intCodColaborador<>"0") then
        
            sql = " Select c.codigo, c.nome, c.cpf, f.Tipo_Funcao, c.cod_nivel, c.codFuncao, c.situacao, "
            sql = sql & " c.codFuncional, tu.Desc_Turno as turno, c.cpf, n.Descricao as nivel, f.Desc_Funcao as funcao, "
            sql = sql & " ca.desc_categoria as categoria, isnull(n.total_aulas,0) as total_aulas_nivel, isnull(c.total_aulas,0) as total_aulas, c.cod_empresa"
            sql = sql & " from srh_colaborador c"
            
            if request("cmbNivel")<>"0" and request("cmbNivel")<>"" then
                sql = sql & " left join srh_nivel n on n.codigo = " & request("cmbNivel")
            else
                sql = sql & " left join srh_nivel n on n.codigo = c.cod_nivel"
            end if
            
            sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = c.codfuncao"
            sql = sql & " left join SRH_CATEGORIA ca on ca.Cod_Categoria = c.CodCategoria "
            sql = sql & " left join SRH_TURNO tu on tu.Cod_Turno = c.CodTurno WHERE 1=1 "
			IF intCodColaborador<>"" AND intCodColaborador<>"0" THEN
           	 sql = sql & " AND C.CODIGO = " & intCodColaborador
            END IF
			IF intCodFuncional<>"" AND (intCodColaborador="" OR intCodColaborador="0") THEN
           	 sql = sql & " AND C.CodFuncional = " & intCodFuncional
            END IF
            rs.open sql, cnn
            if rs.eof = false then
                
                intCodColaborador			= rs("Codigo")
                intCodEmp           		= rs("Cod_Empresa")
                strnome 					= Trim(Rs("nome"))
                intCodFuncional				= Trim(Rs("CodFuncional"))
                strNivel					= Trim(Rs("nivel"))
                strFuncao					= Trim(Rs("funcao"))
                strTurnoContratado			= rs("turno")
                strCategoria				= Trim(Rs("categoria"))
                intContratado	 			= rs("total_aulas")
                intContratadoNivel			= rs("total_aulas_nivel")
                strTipo_Funcao				= rs("Tipo_Funcao")
                strCPF  					= Trim(Rs("CPF"))
                strSituacaoColaborador 		= rs("situacao")
                intCodFuncaoColaborador		= rs("codFuncao")
                
                bolColaboradorEncontrato = "S"
                strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
                strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
                strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
                
            else
                %>
                    <script>
                        alert("Matrícula não Localizada. Verifique!")
                        window.location='DadosFuncPonto_con.asp';
                    </script>
                <%
                response.end	
            end if
            rs.close
        end if
		
		if intCodFuncional <> "" then
			sql = "SELECT excluido, data_update, IMAGEM_FACIAL FROM GEMUL5.DBO.FUNCIONARIOS WHERE CODI_FUNC=" & intCodFuncional
			rs.open sql, cnn
			if rs.eof = false then
				situacao = "Cadastrado com situação ATIVO"
				if rs("excluido") = "S" then situacao = "EXCLUÍDO"
				data_atualizacao = rs("data_update")
				facial = "Não"
				if not isnull(rs("IMAGEM_FACIAL")) then facial = "Sim"
			end if
			rs.close
			
			TabLotacao = ""
			sql = "SELECT e.razaosocial, e.codigo FROM GEMUL5.DBO.FUNC_COLETOR c inner join seg_empresa e on e.codigo = c.codi_cole WHERE c.CODI_FUNC=" & intCodFuncional
			rs.open sql, cnn
			if not rs.eof  then
				while not rs.eof
					TabLotacao = TabLotacao & rs("razaosocial") & " - " &  rs("codigo") & "<br>"
					rs.movenext
				wend
			end if
			rs.close
			
		end if    

%>
    <!--=== Content Part ===-->
    <input name="txtCarregado" id="txtCarregado" value="<%=strCarregado%>" type="hidden" >

    <!--/inicio container-->
    <div class="container content">		
    
        <!-- Grey Panel -->            
        <div class="panel panel-grey">
        
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-tasks"></i>Consulta Dados Colaborador no Ponto</h3>
            </div>
        
            <!-- Inicia o Painel do Formulario -->     
            <div class="panel-body">
            
                    <!-- Inicia o Form -->     
                    <div class="panel-body">                                                        
                        <form id="frm" class="margin-bottom-10" method="post" action="DadosFuncPonto_con.asp">
                         <div class="form-group">
                        <label class="form-label">Matr&iacute;cula Funcional</label>
                                <input name="txtCodigoFuncional" type="text" class="form-control" id="txtCodigoFuncional" size="12" maxlength="8" value="<%=intCodFuncional%>"  onKeyPress="return formataCampo(this, 2, 8)">
                                          <input type="checkbox" name="LocalizarMatricula" value="S" onClick='submit()'> Localizar?
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">Nome</label>
                                  <input name="txtCodFuncionario" value="<%=intCodColaborador%>" type="hidden" id="txtCodFuncionario" onblur="submit()" >
                                  <input name="txtCodEmpresa" value="<%=intCodEmp%>" type="hidden" id="txtCodEmpresa" >
                                  <input name="txtCodFuncional" value="<%=intCodFuncional%>" type="hidden" id="txtCodFuncional" >
                                  <input name="txtcodLotacaoAnterior" value="<%=intcodLotacaoAnterior%>" type="hidden" id="txtcodLotacaoAnterior" >
                                  <input name="txtNomeFuncionario" type="text" class="form-control" id="txtNomeFuncionario" size="50" maxlength="70" value="<%=strNome%>">
                                  <button class="btn-u btn-u-green" onclick="return abreConsultaColaborador('Colaborador_con.asp?PaginaOrigem=colaborador_cad')" type="button"><i class="fa fa-search"></i></button>
                            </div>
                            
                            <legend></legend>
              <input type="button" name="cmdLimpar"  style="cursor:hand"  value="Limpar"   class="btn-u btn-u-orange float-shadow"  onClick="window.location='DadosFuncPonto_con.asp'">
          
                    </div>
                    <!-- Fecha o Form -->
            		<h3>Configurações do Funcionário no PONTO</h3>
                    <!-- Inicia o Form -->     
                    <div class="panel-body">                                                        
                        	 <div class="form-group">
                        		<label class="form-label">Funcionário com Biometria Facial</label>
                                <%=facial%>
                                
                            </div>
                             <div class="form-group">
                        		<label class="form-label">Funcionario no Ponto</label>
                                <%=situacao%>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">Atualizado em</label>
                                <%=data_atualizacao%>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">Tabela de Lotação no Ponto (FUNC_COLETOR)</label>
                                  <%=TabLotacao%>
                            </div>
                            
                             <div class="form-group">
                        		<label class="form-label">Tabela de Registro de Batidas no Ponto</label>
                              <%
								if intCodFuncional <> "" then									
									sql = "SELECT data, hora FROM GEMUL5.DBO.COLETA WHERE CODI_FUNC=" & intCodFuncional	& " order by data desc,hora "
									rs.open sql, cnn
									if rs.eof = false then
									%>
                                    <table width="80%" border="0" cellspacing="0" cellpadding="0" class="table">
                                              <tr>
                                                <td width="16%">Data</td>
                                                <td width="84%">Hora</td>
                                              </tr>
									<%	cont =0
										while not rs.eof
											cont = cont + 1
											%>
											
                                              <tr>
                                                <td><%=rs("data")%></td>
                                                <td><%=rs("hora")%></td>
                                              </tr>
                                            
											<%
											rs.movenext
										wend
										%>
                                        <tr>
                                        <td  colspan="2" align="center"><strong><%=cont%> registros</strong></td>
                                      </tr>
                                        </table>
									<%
									else
									%>
									 <table width="80%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td  align="center"><strong>Sem batida no ponto!</strong></td>
                                      </tr>
                                      </table>
									<%
									end if	
									rs.close
								end if    							  
							  %>
                              
                            </div>

                        
                    </div>
                    <!-- Fecha o Form -->
            </div>
            <!-- Fecha o Painel do Formulario -->
		</div>
		<!-- Grey Panel -->
	</div>
    <!--/container-->		
	<script>
    
        function abreConsultaColaborador(caminho){
            window.open(caminho,"abreConsulta","top=5,left=5,height=510,width=719,menubar=no,toolbar=no,scrollbars=yes,status=yes");
        }
        
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 