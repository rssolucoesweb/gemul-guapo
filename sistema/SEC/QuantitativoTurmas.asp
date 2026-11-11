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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Quantitativos de Turmas CMEIS/EMEI/ENSINO FUNDAMENTAL - <%=session("strAnoLetivo")%></h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">    
            
            	<form id="frm" class="margin-bottom-10" method="post">
                	
                    <div class="table-responsive">
                    
                	<table class="table table-bordered">
                    <tr bgcolor="#E5E5E5">
                      <td height="21" colspan="2" align="center" class="celula"><strong>QUANTITATIVOS DE TURMAS POR CURSO</strong></td>
                      </tr>
                    <tr bgcolor="#E5E5E5">
                      <td width="15%" height="23" class="celula"><strong>Curso</strong></td>
                      <td width="10%" align="center" class="celula"><strong>Turmas</strong></td>
                    </tr>
                    <%


				sql = "select c.descricao as curso, count(t.Cod_Turma) as turmas"
				sql = sql & " from sca_turma t"
				sql = sql & " inner join sca_GradeCurricular g on g.Cod_GradeCurricular = t.Cod_GradeCurricular"
				sql = sql & " inner join sca_turno tu on tu.Cod_Turno = t.cod_turno"
				sql = sql & " inner join sca_periodo p on p.Cod_Periodo = g.Cod_Periodo"
				sql = sql & " inner join sca_curso c on c.cod_curso = p.cod_curso"
				sql = sql & " inner join SEG_EMPRESA e on e.codigo = t.cod_empresa"
				sql = sql & " inner join SEG_TipoEmpresa te on te.CODIGO = e.codTipoEmpresa and e.cod_grupo = te.cod_grupo"
				sql = sql & " where t.anoletivo = " & session("strAnoLetivo")
				sql = sql & " and t.situacao = 'A' and e.bloqueio = 'N'"
				sql = sql & " and e.COD_GRUPO = " & session("CodGrupo")
				sql = sql & " and te.codigo<>3"
				sql = sql & " and NOT c.Descricao like '%PROJETO%'"
				sql = sql & " group by c.descricao"
				sql = sql & " order by 1,2"
				rs.open sql, cnn
				if rs.eof = false then
                    while not rs.eof
						%>
                        <tr>
                            <td height="20" class="celula"><strong><%=rs("curso")%></strong></td>
                            <td align="center" class="celula"><%=rs("turmas")%></td>
                        </tr>
                        
                        <%
						total = total + rs("turmas")
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
                      <td height="21" colspan="3" align="center" class="celula"><strong>QUANTITATIVOS DE TURMAS POR CURSO E TURNO</strong></td>
                      </tr>
                    <tr bgcolor="#E5E5E5">
                      <td width="15%" height="23" class="celula"><strong>Curso</strong></td>
					  <td width="15%" height="23" class="celula"><strong>Turno</strong></td>
                      <td width="10%" align="center" class="celula"><strong>Turmas</strong></td>
                    </tr>
                    <%

				total = 0
				sql = "select c.descricao as curso, tu.Desc_Turno as turno, count(t.Cod_Turma) as turmas"
				sql = sql & " from sca_turma t"
				sql = sql & " inner join sca_GradeCurricular g on g.Cod_GradeCurricular = t.Cod_GradeCurricular"
				sql = sql & " inner join sca_turno tu on tu.Cod_Turno = t.cod_turno"
				sql = sql & " inner join sca_periodo p on p.Cod_Periodo = g.Cod_Periodo"
				sql = sql & " inner join sca_curso c on c.cod_curso = p.cod_curso"
				sql = sql & " inner join SEG_EMPRESA e on e.codigo = t.cod_empresa"
				sql = sql & " inner join SEG_TipoEmpresa te on te.CODIGO = e.codTipoEmpresa and e.cod_grupo = te.cod_grupo"
				sql = sql & " where t.anoletivo = " & session("strAnoLetivo")
				sql = sql & " and t.situacao = 'A' and e.bloqueio = 'N'"
				sql = sql & " and e.COD_GRUPO = " & session("CodGrupo")
				sql = sql & " and te.codigo<>3"
				sql = sql & " and NOT c.Descricao like '%PROJETO%'"
				sql = sql & " group by c.descricao, tu.Desc_Turno"
				sql = sql & " order by 1,2"
				rs.open sql, cnn
				if rs.eof = false then
                    while not rs.eof
						%>
                        <tr>
                            <td height="20" class="celula"><strong><%=rs("curso")%></strong></td>
							<td height="20" class="celula"><strong><%=rs("turno")%></strong></td>
                            <td align="center" class="celula"><%=rs("turmas")%></td>
                        </tr>
                        
                        <%
						total = total + rs("turmas")
						rs.movenext	
					wend
				end if
				rs.close
					%><tr bgcolor="#E5E5E5">
                            <td height="20" colspan="2" class="celula"><strong>Total</strong></td>
                            <td align="center" class="celula"><strong><%=total%></strong></td>
                        </tr>
                    </table>
					
                   <br>
                   
				   
				   <table class="table table-bordered">
                    <tr bgcolor="#E5E5E5">
                      <td height="21" colspan="4" align="center" class="celula"><strong>QUANTITATIVOS DE TURMAS POR CURSO, PERÍODO E TURNO</strong></td>
                      </tr>
                    <tr bgcolor="#E5E5E5">
                      <td width="15%" height="23" class="celula"><strong>Curso</strong></td>
					  <td width="15%" height="23" class="celula"><strong>Período</strong></td>
					  <td width="15%" height="23" class="celula"><strong>Turno</strong></td>
                      <td width="10%" align="center" class="celula"><strong>Turmas</strong></td>
                    </tr>
                    <%

				total = 0
				sql = "select c.descricao as curso, p.descricao as periodo, tu.Desc_Turno as turno, count(t.Cod_Turma) as turmas"
				sql = sql & " from sca_turma t"
				sql = sql & " inner join sca_GradeCurricular g on g.Cod_GradeCurricular = t.Cod_GradeCurricular"
				sql = sql & " inner join sca_turno tu on tu.Cod_Turno = t.cod_turno"
				sql = sql & " inner join sca_periodo p on p.Cod_Periodo = g.Cod_Periodo"
				sql = sql & " inner join sca_curso c on c.cod_curso = p.cod_curso"
				sql = sql & " inner join SEG_EMPRESA e on e.codigo = t.cod_empresa"
				sql = sql & " inner join SEG_TipoEmpresa te on te.CODIGO = e.codTipoEmpresa and e.cod_grupo = te.cod_grupo"
				sql = sql & " where t.anoletivo = " & session("strAnoLetivo")
				sql = sql & " and t.situacao = 'A' and e.bloqueio = 'N'"
				sql = sql & " and e.COD_GRUPO = " & session("CodGrupo")
				sql = sql & " and te.codigo<>3"
				sql = sql & " and NOT c.Descricao like '%PROJETO%'"
				sql = sql & " group by c.descricao, p.descricao, tu.Desc_Turno"
				sql = sql & " order by 1,2,3"
				rs.open sql, cnn
				if rs.eof = false then
                    while not rs.eof
						%>
                        <tr>
                            <td height="20" class="celula"><strong><%=rs("curso")%></strong></td>
							<td height="20" class="celula"><strong><%=rs("Periodo")%></strong></td>
							<td height="20" class="celula"><strong><%=rs("turno")%></strong></td>
                            <td align="center" class="celula"><%=rs("turmas")%></td>
                        </tr>
                        
                        <%
						total = total + rs("turmas")
						rs.movenext	
					wend
				end if
				rs.close
					%><tr bgcolor="#E5E5E5">
                            <td height="20" colspan="3" class="celula"><strong>Total</strong></td>
                            <td align="center" class="celula"><strong><%=total%></strong></td>
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