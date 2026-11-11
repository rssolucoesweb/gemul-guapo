<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<%
ano_letivo = request("ano_letivo")
cod_empresa = request("cod_empresa")
%>
<!--Table hover-->
<div id="panel-5" class="panel">
	<div class="panel-container show">
		<div class="panel-content">
			<div class="frame-wrap">
			
			<div class="table-responsive-lg">				
			
				<table class="table table-bordered table-hover m-0">
					<thead class="thead-themed">
						<tr>
							<th>Curso</th>
							<th>Período</th>
							<th>Nome</th>
							<th>Desc.Fisíca</th>
							<th>Situação</th>
						</tr>
					</thead>
					<tbody>
					<%
					cont = 0
					sql = " select distinct replace(replace(C.Descricao,'EDUCAÇÃO INFANTIL','E.INFANTIL'),'ENSINO FUNDAMENTAL','E.FUNDAMENTAL') AS CURSO, P.Descricao AS PERIODO, t.cod_turma, t.NomeTurma, t.TurmaAluno, "
					sql = sql & " 	case"	
					sql = sql & " 		when f.SITUACAO = 'A' then 'Aguardando processamento'"
					sql = sql & " 		when f.SITUACAO = 'F' then 'Finalizado'"
					sql = sql & " 		else 'Não Iniciado'"
					sql = sql & " 	end as situacao"
					sql = sql & " from sca_turma t"
					sql = sql & " Left join SCA_PERIODO P on P.COD_PERIODO = T.COD_PERIODO"
					sql = sql & " left join SCA_CURSO C on C.COD_CURSO = P.COD_CURSO"
					sql = sql & " left join SCA_FECHAMENTO_AGENDAMENTO f on f.COD_TURMA = t.cod_turma and t.AnoLetivo = f.ANO_LETIVO"
					sql = sql & " where t.Cod_Empresa = " & cod_empresa
					sql = sql & " and t.Situacao = 'A'"
					sql = sql & " and t.AnoLetivo = " & ano_letivo
					sql = sql & " order by 1,2"
					RS.OPEN SQL, CNN
					if not rs.eof then
						while not rs.eof	
							cor = "#000000"
							if rs("situacao") = "Não Iniciado" then cor = "#000000"
							if rs("situacao") = "Aguardando processamento" then cor = "#f3ce07"
							if rs("situacao") = "Finalizado" then cor = "green"
							%>
							<tr>
								<td align="left">&nbsp;<%=rs("curso")%></td>
								<td align="left">&nbsp;<%=rs("PERIODO")%></td>
								<td align="left">&nbsp;<%=rs("NomeTurma")%></td>
								<td align="left">&nbsp;<%=rs("TurmaAluno")%></td>
								<td align="left">&nbsp;<strong><font color="<%=cor%>"><%=rs("situacao")%></font></strong></td>

							</tr>
							<%
							cont = cont  + 1
							rs.movenext
							
						wend
						
					end if
					rs.close
					%>	
							<tr>
								<td colspan="6" align="left">Quantidade de turmas:&nbsp;<%=cont%></td>
							</tr>
						</tbody>
					</table>
			</div>
			
		</div>
	</div>
</div>
