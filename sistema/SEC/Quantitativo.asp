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
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Quantitativos de Alunos <%=YEAR(DATE)%></h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">    
            
            	              <form id="frm" class="margin-bottom-10" method="post">
                	
                    <div class="table-responsive">
                    
					<%
				feminino = 0
				masculino = 0
				sql = " select count(distinct a.codigo) as qtde, a.SEXOALUNO"
				sql = sql & " from sca_aluno a"
				sql = sql & " inner join sca_aluno_turma at on at.COD_ALUNO = a.codigo"
				sql = sql & " inner join sca_turma tu on tu.cod_turma = at.cod_turma"
				sql = sql & " inner join seg_empresa e on e.codigo = tu.Cod_Empresa"
				
				'--------------------------------------------------------
				'-- Recupera apenas a última situação do aluno
				'--------------------------------------------------------
				sql = sql & " OUTER APPLY"
				sql = sql & " ("
				sql = sql & " 	SELECT TOP 1"
				sql = sql & " 		SS.Desc_SituacaoAluno"
				sql = sql & " 	FROM SCA_CONTROLE_SITUACAO_ALUNO CS"
				sql = sql & " 	INNER JOIN SCA_SITUACAOALUNO SS"
				sql = sql & " 		ON SS.Cod_SituacaoAluno = CS.COD_SITUACAOALUNO"
				sql = sql & " 	WHERE CS.COD_EMPRESA = at.COD_EMPRESA"
				sql = sql & " 		AND CS.COD_ALUNO   = at.COD_ALUNO"
				sql = sql & " 		AND CS.ANO_LETIVO  = at.ANO_LETIVO"
				sql = sql & " 	ORDER BY CS.CODIGO DESC"
				sql = sql & " ) SIT"
				
				
				sql = sql & " where tu.Situacao='A' and at.ANO_LETIVO = year(getdate())"
				sql = sql & " AND ISNULL("
				sql = sql & "            SIT.Desc_SituacaoAluno,"
				sql = sql & "            'ATIVO'"
				sql = sql & "        ) = 'ATIVO'"
				sql = sql & " and tu.AnoLetivo = year(getdate())"
				sql = sql & " and at.situacao = 'A'"
				sql = sql & " and tu.cod_empresa in (select codigo from seg_empresa where bloqueio='N' and cod_grupo=" & session("codGrupo")& ")"
				sql = sql & " group by a.SEXOALUNO"
				sql = sql & " order by 1"
				rs.open sql, cnn
				if rs.eof = false then
                    while not rs.eof
						if rs("SEXOALUNO") = "F" then
							feminino = rs("qtde")
						elseif rs("SEXOALUNO") = "M" then
							masculino = rs("qtde")
						else
							sem_sexo = rs("qtde")
						end if
						rs.movenext	
					wend
				end if
				rs.close
				   %>
                    <table class="table table-bordered">
                      <tr bgcolor="#E5E5E5">
                        <td height="21" colspan="2" align="center" class="celula"><strong>Alunos por Sexo</strong></td>
                      </tr>
                      <tr bgcolor="#E5E5E5">
                        <td width="50%" height="28" align="center" class="celula"><strong>Masculino</strong></td>
                        <td width="50%" align="center" class="celula"><strong>Feminino<span class="TextoForm"></span></strong></td>
                      </tr>
                      <tr>
                        <td height="20" align="center" class="celula"><%=masculino%></td>
                        <td align="center" class="celula"><%=feminino%></td>
                      </tr>
                    </table>
					<br>
					
                	<table class="table table-bordered">
                    <tr bgcolor="#E5E5E5">
                      <td height="21" colspan="3" align="center" class="celula"><strong>Alunos por Curso</strong></td>
                      </tr>
                    <tr bgcolor="#E5E5E5">
                      <td width="8%" height="23" class="celula"><strong>Curso</strong></td>
                      <td width="14%" align="center" class="celula"><strong>Alunos</strong></td>
                    </tr>
                    <%

				sql = " select count(distinct a.codigo) as qtde, c.Descricao as curso"
				sql = sql & " from sca_aluno a"
				sql = sql & " inner join sca_aluno_turma at on at.COD_ALUNO = a.codigo"
				sql = sql & " inner join sca_turma tu on tu.cod_turma = at.cod_turma"
				sql = sql & " inner join SCA_GRADECURRICULAR g on g.Cod_GradeCurricular = tu.Cod_GradeCurricular"
				sql = sql & " inner join SCA_PERIODO P on P.Cod_Periodo = G.Cod_Periodo"
				sql = sql & " inner join SCA_CURSO c on c.Cod_curso = p.Cod_curso"
				sql = sql & " inner join seg_empresa e on e.codigo = tu.Cod_Empresa"
				'--------------------------------------------------------
				'-- Recupera apenas a última situação do aluno
				'--------------------------------------------------------
				sql = sql & " OUTER APPLY"
				sql = sql & " ("
				sql = sql & " 	SELECT TOP 1"
				sql = sql & " 		SS.Desc_SituacaoAluno"
				sql = sql & " 	FROM SCA_CONTROLE_SITUACAO_ALUNO CS"
				sql = sql & " 	INNER JOIN SCA_SITUACAOALUNO SS"
				sql = sql & " 		ON SS.Cod_SituacaoAluno = CS.COD_SITUACAOALUNO"
				sql = sql & " 	WHERE CS.COD_EMPRESA = at.COD_EMPRESA"
				sql = sql & " 		AND CS.COD_ALUNO   = at.COD_ALUNO"
				sql = sql & " 		AND CS.ANO_LETIVO  = at.ANO_LETIVO"
				sql = sql & " 	ORDER BY CS.CODIGO DESC"
				sql = sql & " ) SIT"

				sql = sql & " where tu.Situacao='A' and at.ANO_LETIVO = year(getdate())"
				sql = sql & " AND ISNULL("
				sql = sql & "            SIT.Desc_SituacaoAluno,"
				sql = sql & "            'ATIVO'"
				sql = sql & "        ) = 'ATIVO'"
				sql = sql & " and tu.AnoLetivo = year(getdate())"
				sql = sql & " and at.situacao = 'A'"
				sql = sql & " and tu.cod_empresa in (select codigo from seg_empresa where bloqueio='N' and cod_grupo=" & session("codGrupo")& ")"
				sql = sql & " group by c.Descricao"
				sql = sql & " order by 2	"	
		
				rs.open sql, cnn
				if rs.eof = false then
                    while not rs.eof
						%>
                        <tr>
                            <td height="20" class="celula"><strong><%=rs("curso")%></strong></td>
                            <td align="center" class="celula"><%=rs("qtde")%></td>
                        </tr>
                        
                        <%
						total = total + rs("qtde")
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
                      <td height="21" colspan="3" align="center" class="celula"><strong>Alunos por Curso</strong></td>
                      </tr>
                    <tr bgcolor="#E5E5E5">
                      <td width="8%" height="23" class="celula"><strong>Curso</strong></td>
					  <td width="10%" height="23" class="celula"><strong>Período</strong></td>
                      <td width="14%" align="center" class="celula"><strong>Alunos</strong></td>
                    </tr>
                    <%
				total = 0
				sql = " select count(distinct a.codigo) as qtde, c.Descricao as curso, P.Descricao as periodo"
				sql = sql & " from sca_aluno a"
				sql = sql & " inner join sca_aluno_turma at on at.COD_ALUNO = a.codigo"
				sql = sql & " inner join sca_turma tu on tu.cod_turma = at.cod_turma"
				sql = sql & " inner join SCA_GRADECURRICULAR g on g.Cod_GradeCurricular = tu.Cod_GradeCurricular"
				sql = sql & " inner join SCA_PERIODO P on P.Cod_Periodo = G.Cod_Periodo"
				sql = sql & " inner join SCA_CURSO c on c.Cod_curso = p.Cod_curso"
				sql = sql & " inner join seg_empresa e on e.codigo = tu.Cod_Empresa"
				'--------------------------------------------------------
				'-- Recupera apenas a última situação do aluno
				'--------------------------------------------------------
				sql = sql & " OUTER APPLY"
				sql = sql & " ("
				sql = sql & " 	SELECT TOP 1"
				sql = sql & " 		SS.Desc_SituacaoAluno"
				sql = sql & " 	FROM SCA_CONTROLE_SITUACAO_ALUNO CS"
				sql = sql & " 	INNER JOIN SCA_SITUACAOALUNO SS"
				sql = sql & " 		ON SS.Cod_SituacaoAluno = CS.COD_SITUACAOALUNO"
				sql = sql & " 	WHERE CS.COD_EMPRESA = at.COD_EMPRESA"
				sql = sql & " 		AND CS.COD_ALUNO   = at.COD_ALUNO"
				sql = sql & " 		AND CS.ANO_LETIVO  = at.ANO_LETIVO"
				sql = sql & " 	ORDER BY CS.CODIGO DESC"
				sql = sql & " ) SIT"				
				sql = sql & " where tu.Situacao='A' and at.ANO_LETIVO = year(getdate())"
				sql = sql & " AND ISNULL("
				sql = sql & "            SIT.Desc_SituacaoAluno,"
				sql = sql & "            'ATIVO'"
				sql = sql & "        ) = 'ATIVO'"
				sql = sql & " and tu.AnoLetivo = year(getdate())"
				sql = sql & " and at.situacao = 'A'"
				sql = sql & " and tu.cod_empresa in (select codigo from seg_empresa where bloqueio='N' and cod_grupo=" & session("codGrupo")& ")"
				sql = sql & " group by c.Descricao, P.Descricao"
				sql = sql & " order by 2, 3	"	
				rs.open sql, cnn
				if rs.eof = false then
                    while not rs.eof
						%>
                        <tr>
                            <td height="20" class="celula"><strong><%=rs("curso")%></strong></td>
							<td height="20" class="celula"><strong><%=rs("periodo")%></strong></td>
                            <td align="center" class="celula"><%=rs("qtde")%></td>
                        </tr>
                        
                        <%
						total = total + rs("qtde")
						rs.movenext	
					wend
				end if
				rs.close
					%><tr bgcolor="#E5E5E5">
                            <td height="20" colspan="2" class="celula"><strong>Total</strong></td>
                            <td align="center" class="celula"><strong><%=total%></strong></td>
                        </tr>
                    </table>
					
					
                    <p>&nbsp;</p>
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