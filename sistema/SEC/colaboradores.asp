<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnnDocumento.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<script src="../ckeditor/ckeditor.js"></script>
<script src="../ckeditor/config.js"></script>
<script src="../../js/js_funcoes_gerais.js"></script>  

    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">SEC - Secretario(a)</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->

    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Quantitativos de Colaboradores - <%=session("strAnoLetivo")%></h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">    
            
            	<form id="frm" class="margin-bottom-10" method="post">
                	
                    <div class="table-responsive">
                    
                	<table class="table table-bordered">
                    <tr bgcolor="#E5E5E5">
                      <td height="21" colspan="2" align="center" class="celula"><strong>QUANTITATIVOS POR CATEGORIA</strong></td>
                      </tr>
                    <tr bgcolor="#E5E5E5">
                      <td width="15%" height="23" class="celula"><strong>Categoria</strong></td>
                      <td width="10%" align="center" class="celula"><strong>Colaborador</strong></td>
                    </tr>
                    <%

				sql = "select cc.Descricao as categoria, COUNT(*) as quantitativo"
				sql = sql & " from SRH_COLABORADOR c"
				sql = sql & " inner join SRH_CARGOCOLABORADOR ca on ca.Cod_Cargo = c.codCargo"
				sql = sql & " inner join SRH_CARGOCATEGORIA cc on cc.Codigo = ca.CodCargoCategoria"
				sql = sql & " where c.Situacao = 'A'"
				sql = sql & " and c.codLotacao in (select codigo from SEG_EMPRESA where Cod_Grupo = " & session("CodGrupo") & " and BLOQUEIO='N')"
				sql = sql & " group by cc.Descricao"
				sql = sql & " order by 1,2"
				rs.open sql, cnn
				if rs.eof = false then
                    while not rs.eof
						%>
                        <tr>
                            <td height="20" class="celula"><strong><%=rs("categoria")%></strong></td>
                            <td align="center" class="celula"><%=rs("quantitativo")%></td>
                        </tr>
                        
                        <%
						total = total + rs("quantitativo")
						rs.movenext	
					wend
				end if
				rs.close
					%><tr bgcolor="#E5E5E5">
                            <td height="20" class="celula"><strong>Total</strong></td>
                            <td align="center" class="celula"><strong><%=total%></strong></td>
                        </tr>
                    </table>
					
                   <br>
				   
				   <table class="table table-bordered">
                    <tr bgcolor="#E5E5E5">
                      <td height="21" colspan="3" align="center" class="celula"><strong>QUANTITATIVOS POR CARGO</strong></td>
                      </tr>
                    <tr bgcolor="#E5E5E5">
                      <td width="15%" height="23" class="celula"><strong>Cargo</strong></td>
                      <td width="10%" align="center" class="celula"><strong>Colaborador</strong></td>
                    </tr>
                    <%

				total = 0
				sql = "select ca.Desc_Cargo, COUNT(*) as quantitativo"
				sql = sql & " from SRH_COLABORADOR c"
				sql = sql & " inner join SRH_CARGOCOLABORADOR ca on ca.Cod_Cargo = c.codCargo"
				sql = sql & " where c.Situacao = 'A'"
				sql = sql & " and c.codLotacao in (select codigo from SEG_EMPRESA where Cod_Grupo = " & session("CodGrupo") & " and BLOQUEIO='N')"
				sql = sql & " group by ca.Desc_Cargo"
				sql = sql & " ORDER BY 1,2"
				rs.open sql, cnn
				if rs.eof = false then
                    while not rs.eof
						%>
                        <tr>
                            <td height="20" class="celula"><strong><%=rs("Desc_Cargo")%></strong></td>
                            <td align="center" class="celula"><%=rs("quantitativo")%></td>
                        </tr>
                        
                        <%
						total = total + rs("quantitativo")
						rs.movenext	
					wend
				end if
				rs.close
					%><tr bgcolor="#E5E5E5">
                            <td height="20" class="celula"><strong>Total</strong></td>
                            <td align="center" class="celula"><strong><%=total%></strong></td>
                        </tr>
                    </table>
					
                   <br>
                   
				   
				   <table class="table table-bordered">
                    <tr bgcolor="#E5E5E5">
                      <td height="21" colspan="4" align="center" class="celula"><strong>QUANTITATIVOS POR UNIDADE / CATEGORIA CARGO</strong></td>
                      </tr>
                    <tr bgcolor="#E5E5E5">
                      <td width="35%" height="23" class="celula"><strong>Unidade</strong></td>
					  <td width="15%" align="center" height="23" class="celula"><strong>Administrativo</strong></td>
					  <td width="15%" align="center" height="23" class="celula"><strong>Profissional da Educação</strong></td>
                      <td width="15%" align="center" class="celula"><strong>Total</strong></td>
                    </tr>
                    <%

				total = 0
				
				sql = " exec [s_SEC_ColaboradoresPorCategoriaCargo]"
				rs.open sql, cnn
				if rs.eof = false then
                    while not rs.eof
						%>
                        <tr>
                            <td height="20" class="celula"><strong><%=rs("unidade")%></strong></td>
							<td align="center" height="20" class="celula"><strong><%=rs("categoria_adm")%></strong></td>
							<td align="center" height="20" class="celula"><strong><%=rs("categoria_prof")%></strong></td>
                            <td align="center" class="celula"><strong><%=rs("categoria_adm")+rs("categoria_prof")%></strong></td>
                        </tr>
                        
                        <%
						total_adm = total_adm + rs("categoria_adm")
						total_prof = total_prof + rs("categoria_prof")
						total_geral = total_geral + rs("categoria_adm")+rs("categoria_prof")
						rs.movenext	
					wend
				end if
				rs.close
					%><tr bgcolor="#E5E5E5">
                            <td height="20" class="celula"><strong>Total</strong></td>
                            <td align="center" class="celula"><strong><%=total_adm%></strong></td>
							<td align="center" class="celula"><strong><%=total_prof%></strong></td>
							<td align="center" class="celula"><strong><%=total_geral%></strong></td>
                        </tr>
                    </table>
					
                   <br>
					</div>
                </form>
              <p>&nbsp;</p>
            </div>
       	</div>
         	<!-- Fecha o Form -->  
      </div>
    </div>
    <!--/container-->		
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 