<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->

<%
	
anoLetivo = Trim(Request("txtAnoLetivo"))	
semestre = Trim(Request("semestre"))	

codigoPlanejamento	        = Trim(Request("codigoPlanejamento"))	
codigoPlanejamentoEscola	= Trim(Request("codigoPlanejamentoEscola"))	

acao			= Trim(Request("acao"))

intCodCurso 	= Trim(Request("txtCodCurso"))	
strCurso 		= Trim(Request("txtCurso"))
intCodPeriodo 	= Trim(Request("txtCodPeriodo"))
strPeriodo 		= Trim(Request("txtPeriodo"))
intCodTurno 	= Trim(Request("txtCodTurno"))
strTurno 		= Trim(Request("txtTurno"))
intCodDisciplina= Trim(Request("txtCodDisciplina"))
strDisciplina 	= Trim(Request("txtDisciplina"))
intCodTurma 	= Trim(Request("txtCodTurma"))
strTurma 		= Trim(Request("txtTurma"))
intCodProfessor	= Trim(Request("txtCodProfessor"))
strProfessor 	= Trim(Request("txtProfessor"))
strAulas 		= Trim(Request("aulasProfessor"))
bolAulaExtra    = Trim(Request("bolAulaExtra"))
strDiaDaSemana 	= Trim(Request("diaDaSemana"))


if strDiaDaSemana = "1" then strSemana = "Domingo"
if strDiaDaSemana = "2" then strSemana = "Segunda-feira"
if strDiaDaSemana = "3" then strSemana = "Terça-feira"
if strDiaDaSemana = "4" then strSemana = "Quarta-feira"
if strDiaDaSemana = "5" then strSemana = "Quinta-feira"
if strDiaDaSemana = "6" then strSemana = "Sexta-feira"

strDataAula 	= Trim(Request("dataAula"))

' Dados do Usuario
strUsuario_incl   	= session("usuarioWeb")
strData_hora_incl 	= formataDataBDAccess(date) & " " & time
strUsuario_altr   	= session("usuarioWeb")
strData_hora_altr 	= formataDataBDAccess(date) & " " & time

if acao = "carregaAulas" then

	vetAulas = Split(strAulas,",")
	
	%>
	<div class="row">
		<div class="col-xl-12">
			<div id="panel-1" class="panel">
				<div class="panel-container show">
					<div class="panel-content">					
						<div class="table-responsive-lg">
							<table class="table table-bordered table-hover m-0">
								<thead class="thead-themed">
								  <tr>
									<th><strong>Aula <% if not bolAulaExtra then response.write "de " & strSemana else response.write "Extra"%> no dia <%=strDataAula%> - <%=strDisciplina%> </strong></th>
								  </tr>
								</thead>
								<tbody>
							  <%

							For i = 0 to Ubound(vetAulas)
								
								strCorDia = "amarelo"
								bolValido = "N"

								sql="select pp.cod_planejamento_geral, pp.validado, pp.observacao, (select COUNT(*) from SCA_CONTEUDO_MINISTRADO_PROFESSOR where cod_planejamento_professor = pp.cod_planejamento_professor) as qtde_conteudo_ministrado  "
								sql=sql & " from SCA_PLANEJAMENTO_PROFESSOR pp"
								sql=sql & " left join SCA_ITEM_PLANEJAMENTO_PROFESSOR ip on ip.cod_planejamento_professor = pp.cod_planejamento_professor"
								sql=sql & " where pp.cod_empresa =" & session("codEmpresa")
								sql=sql & " and pp.anoLetivo =" & anoLetivo
								if not bolAulaExtra then
									sql=sql & " and pp.numero_aula =" & vetAulas(i)
								else
									sql=sql & " and pp.data_aula_extra ='" & formataDataBD(strDataAula) & "'"
								end if
								sql=sql & " and pp.cod_periodo =" & intCodPeriodo
								sql=sql & " and pp.cod_disciplina =" & intCodDisciplina
								sql=sql & " and pp.cod_turno =" & intCodTurno 
								sql=sql & " and pp.cod_turma =" & intCodTurma
								sql=sql & " order by cod_planejamento_geral desc"
								'sql=sql & " and cod_colaborador =" & intCodProfessor
								'response.write sql
								if session("usuarioWeb") = "SERGIO" then
									response.write sql
								end if
								
								rs.open sql, cnn
								if rs.eof = false then
									
									if rs("qtde_conteudo_ministrado")=0 then
										if trim(rs("validado")) = "N" then
											bolValido = "N"
											strCorDia = "vermelho"
										elseif trim(rs("validado")) = "S" then
											bolValido = "S"
											strCorDia = "verde"
											if not isnull(rs("observacao")) then
												strCorDia = "azul"
											end if
										end if
									else
										bolValido = "S"
										strCorDia = "laranja"
									end if

									'response.write "|" & vetAulas(i) & " - " & rs("validado")
								end if
								rs.close


								%>
								  <tr class="<%=strCorDia%>" style="cursor: pointer" onClick="return abrePlanejamento('<%=vetAulas(i)%>','<%=strDataAula%>','<%=bolValido%>',<%=bolAulaExtra%>)">
									<td height="20" >Aula <%if bolAulaExtra then response.write "Extra " & strDataAula else response.write vetAulas(i)%></td>
								  </tr>
								  <%				
							next
							%>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div> 

	<div class="row">
		<div class="col-sm-4">
			<div class="estilo_legenda amarelo">
				<strong>Aguardando Planejamento</strong>
			</div>
		</div>
		<div class="col-sm-4">
			<div class="estilo_legenda vermelho">
				<strong>Planejado e não validado</strong>
			</div>
		</div>
		<div class="col-sm-4">
			<div class="estilo_legenda verde">
				<strong>Planejado e validado</strong>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-6">
			<div class="estilo_legenda azul">
				<strong>Planejado e validado com observação</strong>
			</div>
		</div>
		<div class="col-sm-6">
			<div class="estilo_legenda laranja">
				<strong>Conteúdo ministrado</strong>
			</div>
		</div>
	</div>

<%
end if
%>
