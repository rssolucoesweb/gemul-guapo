<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnnDocumento.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<script src="../ckeditor/ckeditor.js"></script>
<script src="../ckeditor/config.js"></script>
<script src="../../js/js_funcoes_gerais.js"></script>  

<%
	sql = "SELECT Count(Codigo)AS Total_AGRUPAMENTO_I"
	sql = sql & " FROM   MAT_Reserva"
	sql = sql & " WHERE  1 = 1"
	sql = sql & " 	   AND Situacao = 'R'"
	sql = sql & " 	   AND ISNULL(ATUALIZADO, 'N') = 'N'"
	sql = sql & " 	   AND Periodo = 'AGRUPAMENTO I'"
	rs.open sql, cnn
	if not rs.eof then 
		strTotal_AGRUPAMENTO_I = trim(rs("Total_AGRUPAMENTO_I"))
	end if
	rs.close
	
	sql = "SELECT Count(Codigo)AS Total_AGRUPAMENTO_II"
	sql = sql & " FROM   MAT_Reserva"
	sql = sql & " WHERE  1 = 1"
	sql = sql & " 	   AND Situacao = 'R'"
	sql = sql & " 	   AND ISNULL(ATUALIZADO, 'N') = 'N'"
	sql = sql & " 	   AND Periodo = 'AGRUPAMENTO II'"
	rs.open sql, cnn
	if not rs.eof then 
		strTotal_AGRUPAMENTO_II = trim(rs("Total_AGRUPAMENTO_II"))
	end if
	rs.close
	
	sql = "SELECT Count(Codigo)AS Total_AGRUPAMENTO_III"
	sql = sql & " FROM   MAT_Reserva"
	sql = sql & " WHERE  1 = 1"
	sql = sql & " 	   AND Situacao = 'R'"
	sql = sql & " 	   AND ISNULL(ATUALIZADO, 'N') = 'N'"
	sql = sql & " 	   AND Periodo = 'AGRUPAMENTO III'"
	rs.open sql, cnn
	if not rs.eof then 
		strTotal_AGRUPAMENTO_III = trim(rs("Total_AGRUPAMENTO_III"))
	end if
	rs.close
	
	sql = "SELECT Count(Codigo)AS Total_AGRUPAMENTO_IV"
	sql = sql & " FROM   MAT_Reserva"
	sql = sql & " WHERE  1 = 1"
	sql = sql & " 	   AND Situacao = 'R'"
	sql = sql & " 	   AND ISNULL(ATUALIZADO, 'N') = 'N'"
	sql = sql & " 	   AND Periodo = 'AGRUPAMENTO IV'"
	rs.open sql, cnn
	if not rs.eof then 
		strTotal_AGRUPAMENTO_IV = trim(rs("Total_AGRUPAMENTO_IV"))
	end if
	rs.close
	
	sql = "SELECT Count(Codigo)AS Total_AGRUPAMENTO_V"
	sql = sql & " FROM   MAT_Reserva"
	sql = sql & " WHERE  1 = 1"
	sql = sql & " 	   AND Situacao = 'R'"
	sql = sql & " 	   AND ISNULL(ATUALIZADO, 'N') = 'N'"
	sql = sql & " 	   AND Periodo = 'AGRUPAMENTO V'"
	rs.open sql, cnn
	if not rs.eof then 
		strTotal_AGRUPAMENTO_V = trim(rs("Total_AGRUPAMENTO_V"))
	end if
	rs.close
	
	TotalGeral = Cint(strTotal_AGRUPAMENTO_I) + Cint(strTotal_AGRUPAMENTO_II) + Cint(strTotal_AGRUPAMENTO_III) + Cint(strTotal_AGRUPAMENTO_IV) + Cint(strTotal_AGRUPAMENTO_V)
%>
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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Inscritos Matricula / Cadastro de Reserva</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">    
            
            	              <form id="frm" class="margin-bottom-10" method="post">
                	
                    <div class="table-responsive">
                    
                	<table class="table table-bordered">
                    <tr bgcolor="#E5E5E5">
                      <td height="21" colspan="6" align="center" class="celula"><strong>Inscritos Matricula</strong></td>
                      </tr>
                    <tr bgcolor="#E5E5E5">
                      <td width="8%" rowspan="2" class="celula"><strong>Ano</strong></td>
                      <td height="21" colspan="5" align="center"><strong>Série/Segmento</strong></td>
                      </tr>
                    <tr bgcolor="#E5E5E5">
                      <td width="14%" align="center" class="celula"><strong>EI</strong></td>
                      <td width="19%" align="center" class="celula"><strong>E.F</strong></td>
                    <td width="20%" align="center" class="celula"><strong>EJA</strong></td>
                    <td width="17%" height="23" align="center" class="celula"><strong>Total<span class="TextoForm"></span></strong></td>
                    </tr>
                    <tr>
                    <td class="celula"><strong>2013</strong></td>
                    <td align="center" class="celula">515</td>
                    <td align="center" class="celula">7.145</td>
                    <td align="center" class="celula">36</td>
                    <td height="20" align="center" class="celula">7.696</td>
                    </tr>
                    <tr>
                      <td class="celula"><strong>2014</strong></td>
                      <td align="center" class="celula">1.187</td>
                      <td align="center" class="celula">8.552</td>
                      <td align="center" class="celula">30</td>
                      <td height="20" align="center" class="celula">9.769</td>
                    </tr>
                    <tr>
                      <td class="celula"><strong>2015</strong></td>
                      <td align="center" class="celula">1.268</td>
                      <td align="center" class="celula">8.737</td>
                      <td align="center" class="celula">--</td>
                      <td height="20" align="center" class="celula">10005</td>
                    </tr>
                    </table>
    
                   <br>
                    <table class="table table-bordered">
                      <tr bgcolor="#E5E5E5">
                        <td height="21" colspan="7" align="center" class="celula"><strong>Cadastro de Reserva (Ensino Infantil)</strong></td>
                      </tr>
                      <tr bgcolor="#E5E5E5">
                        <td width="15%" rowspan="2" class="celula"><strong>Ano</strong></td>
                        <td height="21" colspan="6" align="center"><strong>Série/Segmento</strong></td>
                      </tr>
                      <tr bgcolor="#E5E5E5">
                        <td width="13%" align="center" class="celula"><strong>AGRUPAMENTO I</strong></td>
                        <td width="14%" align="center" class="celula"><strong>AGRUPAMENTO II</strong></td>
                        <td width="17%" align="center" class="celula"><strong>AGRUPAMENTO III<span class="TextoForm"></span></strong></td>
                        <td width="17%" align="center" class="celula"><strong>AGRUPAMENTO IV</strong></td>
                        <td width="14%" align="center" class="celula"><strong>AGRUPAMENTO V</strong></td>
                        <td width="10%" height="28" align="center" class="celula"><strong>Total<span class="TextoForm"></span></strong></td>
                      </tr>
                      <tr>
                        <td class="celula"><strong>2013</strong></td>
                        <td align="center" class="celula">315</td>
                        <td align="center" class="celula">429</td>
                        <td align="center" class="celula">402</td>
                        <td align="center" class="celula">398</td>
                        <td align="center" class="celula">78</td>
                        <td height="20" align="center" class="celula">1699</td>
                      </tr>
                      <tr>
                        <td class="celula"><strong>2014</strong></td>
                        <td align="center" class="celula">587</td>
                        <td align="center" class="celula">775</td>
                        <td align="center" class="celula">908</td>
                        <td align="center" class="celula">941</td>
                        <td align="center" class="celula">734</td>
                        <td height="20" align="center" class="celula">3945</td>
                      </tr>
                      <tr>
                        <td class="celula"><strong>2015</strong></td>
                        <td align="center" class="celula"><%=strTotal_AGRUPAMENTO_I%>&nbsp;</td>
                        <td align="center" class="celula"><%=strTotal_AGRUPAMENTO_II%></td>
                        <td align="center" class="celula"><%=strTotal_AGRUPAMENTO_III%></td>
                        <td align="center" class="celula"><%=strTotal_AGRUPAMENTO_IV%></td>
                        <td align="center" class="celula"><%=strTotal_AGRUPAMENTO_V%></td>
                        <td height="20" align="center" class="celula"><%=TotalGeral%>&nbsp;</td>
                      </tr>
                    </table>
                    </div>
                </form>                                                    
  
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