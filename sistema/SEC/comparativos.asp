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
                
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->

    <div class="container content">		
    <form id="frm" class="margin-bottom-10" method="post">
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i><strong>DADOS COMPARATIVOS DA MATRÍCULA - 2013 À 2020</strong></h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">    
            
                    
                    <div class="table-responsive">
                    
                	<table class="table table-bordered">
                    <tr bgcolor="#E5E5E5">
                      <td height="21" colspan="9" align="center" class="celula"><strong>VAGAS OFERECIDAS (POR CURSO)</strong></td>
                      </tr>
                    <tr bgcolor="#E5E5E5">
                      <td width="15%" class="celula"><strong>CURSO</strong></td>
                      <td width="7%" align="center" class="celula"><strong>2013</strong></td>
                      <td width="7%" align="center" class="celula"><strong>2014</strong></td>
                    <td width="7%" align="center" class="celula"><strong>2015</strong></td>
                    <td width="7%" align="center" class="celula"><strong>2016</strong></td>
                    <td width="7%" align="center" class="celula"><strong>2017</strong></td>
                    <td width="7%" align="center" class="celula"><strong>2018</strong></td>
                    <td width="7%" height="23" align="center" class="celula"><strong>2019</strong></td>
					<td width="7%" height="23" align="center" class="celula"><strong>2020</strong></td>
                    </tr>
                    <tr>
                    <td width="15%" class="celula"><strong>EDUCAÇÃO INFANTIL</strong></td>
                    <td width="7%" align="center" class="celula">515</td>
                    <td width="7%" align="center" class="celula">1.187</td>
                    <td width="7%" align="center" class="celula">1.268</td>
                    <td width="7%" align="center" class="celula">1.800</td>
                    <td width="7%" align="center" class="celula">2.668</td>
                    <td width="7%" align="center" class="celula">2.691</td>
                    <td width="7%" height="20" align="center" class="celula">2.792</td>
					<td width="7%" height="20" align="center" class="celula">1.905</td>
                    </tr>
                    <tr>
                      <td width="15%" class="celula"><strong>ENSINO FUNDAMENTAL</strong></td>
                      <td width="7%" align="center" class="celula">11.215</td>
                      <td width="7%" align="center" class="celula">11.522</td>
                      <td width="7%" align="center" class="celula">10.958</td>
                      <td width="7%" align="center" class="celula">10.060</td>
                      <td width="7%" align="center" class="celula">10.879</td>
                      <td width="7%" align="center" class="celula">8.950</td>
                      <td width="7%" height="20" align="center" class="celula">11.463</td>
					  <td width="7%" height="20" align="center" class="celula">6.075</td>
                    </tr>
                    <tr>
                      <td width="15%" class="celula"><strong>TOTAL</strong></td>
                      <td width="7%" align="center" class="celula"><strong>11.730</strong></td>
                      <td width="7%" align="center" class="celula"><strong>12.709</strong></td>
                      <td width="7%" align="center" class="celula"><strong>12.226</strong></td>
                      <td width="7%" align="center" class="celula"><strong>11.860</strong></td>
                      <td width="7%" align="center" class="celula"><strong>13.547</strong></td>
                      <td width="7%" align="center" class="celula"><strong>11.641</strong></td>
                      <td width="7%" height="20" align="center" class="celula"><strong>14.255</strong></td>
					  <td width="7%" height="20" align="center" class="celula"><strong>8.380</strong></td>
                    </tr>
                    </table>
    
                   <br>
                   <table class="table table-bordered">
                     <tr bgcolor="#E5E5E5">
                       <td height="21" colspan="9" align="center" class="celula"><strong>INSCRITOS (POR CURSO)</strong></td>
                     </tr>
                     <tr bgcolor="#E5E5E5">
                       <td width="15%" class="celula"><strong>CURSO</strong></td>
                       <td width="7%" align="center" class="celula"><strong>2013</strong></td>
                       <td width="7%" align="center" class="celula"><strong>2014</strong></td>
                       <td width="7%" align="center" class="celula"><strong>2015</strong></td>
                       <td width="7%" align="center" class="celula"><strong>2016</strong></td>
                       <td width="7%" align="center" class="celula"><strong>2017</strong></td>
                       <td width="7%" align="center" class="celula"><strong>2018</strong></td>
                       <td width="7%" height="23" align="center" class="celula"><strong>2019</strong></td>
					   <td width="7%" height="23" align="center" class="celula"><strong>2020</strong></td>
                     </tr>
                     <tr>
                       <td width="15%" class="celula"><strong>EDUCAÇÃO INFANTIL</strong></td>
                       <td width="7%" align="center" class="celula">511</td>
                       <td width="7%" align="center" class="celula">1.187</td>
                       <td width="7%" align="center" class="celula">1.268</td>
                       <td width="7%" align="center" class="celula">1.800</td>
                       <td width="7%" align="center" class="celula">1.856</td>
                       <td width="7%" align="center" class="celula">2.691</td>
                       <td width="7%" height="20" align="center" class="celula">2.749</td>
					   <td width="7%" height="20" align="center" class="celula">1.664</td>
                     </tr>
                     <tr>
                       <td width="15%" class="celula"><strong>ENSINO FUNDAMENTAL</strong></td>
                       <td width="7%" align="center" class="celula">7.148</td>
                       <td width="7%" align="center" class="celula">8.582</td>
                       <td width="7%" align="center" class="celula">8.737</td>
                       <td width="7%" align="center" class="celula">8.245</td>
                       <td width="7%" align="center" class="celula">8.286</td>
                       <td width="7%" align="center" class="celula">7.409</td>
                       <td width="7%" height="20" align="center" class="celula">8.516</td>
					   <td width="7%" height="20" align="center" class="celula">4.007</td>
                     </tr>
                     <tr>
                       <td class="celula"><strong>EJA</strong></td>
                       <td align="center" class="celula">36</td>
                       <td align="center" class="celula">30</td>
                       <td align="center" class="celula">&nbsp;</td>
                       <td align="center" class="celula">&nbsp;</td>
                       <td align="center" class="celula">&nbsp;</td>
                       <td align="center" class="celula">&nbsp;</td>
                       <td height="20" align="center" class="celula">&nbsp;</td>
					   <td height="20" align="center" class="celula">&nbsp;</td>
                     </tr>
                     <tr>
                       <td width="15%" class="celula"><strong>TOTAL</strong></td>
                       <td width="7%" align="center" class="celula"><strong>7.695</strong></td>
                       <td width="7%" align="center" class="celula"><strong>9.799</strong></td>
                       <td width="7%" align="center" class="celula"><strong>10.005</strong></td>
                       <td width="7%" align="center" class="celula"><strong>9.254</strong></td>
                       <td width="7%" align="center" class="celula"><strong>10.142</strong></td>
                       <td width="7%" align="center" class="celula"><strong>10.009</strong></td>
                       <td width="7%" height="20" align="center" class="celula"><strong>11.265</strong></td>
					   <td width="7%" height="20" align="center" class="celula"><strong>5.671</strong></td>
                     </tr>
                   </table>
                    </div>
  
              <br>
			  
			  
              <table class="table table-bordered">
                <tr bgcolor="#E5E5E5">
                  <td height="21" colspan="9" align="center" class="celula"><strong>CADASTRO DE RESERVA</strong></td>
                </tr>
                <tr bgcolor="#E5E5E5">
                  <td width="15%" class="celula"><strong>CURSO</strong></td>
                  <td width="7%" align="center" class="celula"><strong>2013</strong></td>
                  <td width="7%" align="center" class="celula"><strong>2014</strong></td>
                  <td width="7%" align="center" class="celula"><strong>2015</strong></td>
                  <td width="7%" align="center" class="celula"><strong>2016</strong></td>
                  <td width="7%" align="center" class="celula"><strong>2017</strong></td>
                  <td width="7%" align="center" class="celula"><strong>2018</strong></td>
                  <td width="7%" height="23" align="center" class="celula"><strong>2019</strong></td>
				  <td width="7%" height="23" align="center" class="celula"><strong>2020</strong></td>
                </tr>
                <tr>
                  <td width="15%" class="celula"><strong>EDUCAÇÃO INFANTIL</strong></td>
                  <td width="7%" align="center" class="celula">1.621</td>
                  <td width="7%" align="center" class="celula">3.945</td>
                  <td width="7%" align="center" class="celula">6.253</td>
                  <td width="7%" align="center" class="celula">9.634</td>
                  <td width="7%" align="center" class="celula">9.737</td>
                  <td width="7%" align="center" class="celula">10.382</td>
                  <td width="7%" height="20" align="center" class="celula">12.122</td>
				  <td width="7%" height="20" align="center" class="celula">8.763</td>
                </tr>
              </table>
			  
			  
            </div>
       	</div>
					<%
					
						consultar = request.form("consultar")
						strDataI = request.form("txtDataI")
						strDataF = request.form("txtDataF")
						intEmpresaGrupoCMEI = request.form("cmbEmpresaGrupoCMEI")
						if intEmpresaGrupoCMEI = "" then intEmpresaGrupoCMEI= "0"
						
						'if strDataI = "" then strDataI = formataDataAP(date)
						'if strDataF = "" then strDataF = formataDataAP(date)
					
					%>            
                    <input name="consultar" type="hidden" value="S"> 
		
		
		<table class="table table-bordered">
			<tr bgcolor="#E5E5E5">
			  <td height="21" colspan="9" align="center" class="celula"><strong>INCLUSÃO NA EDUCAÇÃO INFANTIL - CMEI</strong></td>
			</tr>

			<tr bgcolor="#E5E5E5">
			  <td height="21" colspan="9" align="center" class="celula"><div align="center">
		Unidade: <!--#include file="../includes/inc_cmbEmpresaGrupoCMEI.asp" -->
		Período: 
			<input name="txtDataI" type="text" class="text" id="txtDataI" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataI%>"> 
			a
			<input name="txtDataF" type="text" class="text" id="txtDataF" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataF%>"> 
		
			<input type="button" name="cmdAtualiza" style="cursor:hand"   value="Consultar" class="botao" onClick="submit()">
		</div></td>
			</tr>			

			<tr bgcolor="#E5E5E5">
			  <td width="15%" class="celula"><strong>Nome</strong></td>
			  <td width="7%" align="center" class="celula"><strong>Data Nascimento</strong></td>
			  <td width="7%" align="center" class="celula"><strong>Unidade</strong></td>
			  <td width="7%" align="center" class="celula"><strong>Período</strong></td>
			  <td width="7%" align="center" class="celula"><strong>Usuário Inclusão</strong></td>
			  <td width="7%" align="center" class="celula"><strong>Data Inclusão</strong></td>
			</tr>
				
			<%
			if consultar <>"" then
				sql = "select distinct e.RAZAOSOCIAL as empresa, p.Descricao as periodo, I.nome, i.data_nascimento as datanascimento, i.usuario_incl,  i.data_hora_incl "
				sql = sql & " from mat_inscricao i"
				sql = sql & " inner join SCA_PERIODO p on p.cod_periodo = i.cod_periodo"
				sql = sql & " inner join SCA_CURSO c on c.cod_curso = p.cod_curso"
				sql = sql & " inner join SEG_EMPRESA e on e.codigo = i.cod_empresa"
				sql = sql & " inner join SEG_tipoEMPRESA te on te.codigo = e.codTipoEmpresa"
				sql = sql & " where c.descricao = 'EDUCAÇÃO INFANTIL'"
				sql = sql & " AND excluido = 'N'"
				sql = sql & " and efetivacao = 'S'"
				if strDataI <> "" and strDataF <> "" then
					sql = sql & " and data_hora_incl between '" & FORMATADATABD(strDataI) & " 00:00:00' and '" & FORMATADATABD(strDataF) & " 23:59:59'"
				end if
				sql = sql & " and te.descricao = 'CMEIS'"
				IF intEmpresaGrupoCMEI <>"0" then
					sql = sql & " and i.cod_empresa = " & intEmpresaGrupoCMEI
				end if
				sql = sql & " and year(i.data_hora_incl) = " & year(date)
				sql = sql & " union"
				sql = sql & " select distinct e.RAZAOSOCIAL as empresa, p.Descricao as periodo, I.NOMEALUNO as nome, i.datanascimento, i.usuario_incl, i.data_hora_incl"
				sql = sql & " from sca_aluno i"
				sql = sql & " inner join sca_aluno_turma at on at.cod_aluno = i.codigo"
				sql = sql & " inner join sca_turma tu on tu.cod_turma = at.cod_turma"
				sql = sql & " inner join SCA_PERIODO p on p.cod_periodo = tu.cod_periodo"
				sql = sql & " inner join SCA_CURSO c on c.cod_curso = p.cod_curso"
				sql = sql & " inner join SEG_EMPRESA e on e.codigo = tu.cod_empresa"
				sql = sql & " inner join SEG_tipoEMPRESA te on te.codigo = e.codTipoEmpresa and te.COD_GRUPO=7"
				sql = sql & " where c.descricao = 'EDUCAÇÃO INFANTIL'"
				if strDataI <> "" and strDataF <> "" then
					sql = sql & " and i.data_hora_incl between '" & FORMATADATABD(strDataI) & " 00:00:00' and '" & FORMATADATABD(strDataF) & " 23:59:59'"
				end if
				sql = sql & " and year(i.data_hora_incl) = " & year(date)
				sql = sql & " and te.descricao = 'CMEIS'"
				IF intEmpresaGrupoCMEI <>"0" then
					sql = sql & " and tu.cod_empresa = " & intEmpresaGrupoCMEI
				end if
				sql = sql & " and at.situacao = 'A'"
				sql = sql & " order by data_hora_incl desc"
				rs.open sql, cnn
				cont = 0
				if not rs.eof then 
					while not rs.eof
						%>

						<tr>
						  <td width="10%" class="celula"><%=rs("nome")%></td>
						  <td width="5%"  class="celula"><%=rs("datanascimento")%></td>
						  <td width="15%" class="celula"><%=rs("empresa")%></td>
						  <td width="5%"  class="celula"><%=rs("periodo")%></td>
						  <td width="5%" align="center" class="celula"><%=rs("usuario_incl")%></td>
						  <td width="7%" align="center" class="celula"><%=rs("data_hora_incl")%></td>
						</tr>
						
						<%
						cont = cont + 1
						rs.movenext
					wend
				end if
				rs.close
			%>		
			<tr bgcolor="#E5E5E5">
			  <td height="21" colspan="9" align="center" class="celula"><strong>Quantidade de alunos incluídos: <%=cont%></strong></td>
			</tr>
			<%
				
			end if
			%>	
			

			</table>
		
		
         	<!-- Fecha o Form -->  
      </div>
                      </form>  
    </div>
    <!--/container-->		
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 