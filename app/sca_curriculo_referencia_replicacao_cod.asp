<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--include file="includes/inc_log.asp"-->
<!--include file="includes/inc_formatadata.asp"-->
<%
	
	cnn.begintrans

	cod_item_planejamento_geral	        = Trim(Request("cod_item_planejamento_geral"))	
	ano_letivo	        				= Trim(Request("ano_letivo"))	
	intCodEmpresaDestino	        	= Trim(Request("cod_empresa"))	
	if intCodEmpresaDestino = "" then intCodEmpresaDestino = "0"
	
	if cod_item_planejamento_geral<>"" then
		'consulta o item planejamento geral da unidade atual
		sql="select  i.cod_item_planejamento_geral_pai, g.semestre, g.cod_disciplina, i.cod_bimestre, g.cod_periodo, p.cod_curso, i.descricao, i.cod_tipo_planejamento"
		sql=sql & " from SCA_ITEM_PLANEJAMENTO_GERAL i"
		sql=sql & " inner join SCA_PLANEJAMENTO_GERAL g on g.cod_planejamento_geral = i.cod_planejamento_geral"
		sql=sql & " inner join SCA_PERIODO p on p.Cod_Periodo = g.cod_periodo"
		sql=sql & " where cod_item_planejamento_geral = " & cod_item_planejamento_geral
		'response.write sql & "<hr>"

		vetPlanejamento = null
		rs.open sql, cnn, 3, 1
		if not rs.eof then
			vetPlanejamento = rs.getRows
		end if
		rs.close
			
		if isArray(vetPlanejamento) then
		
			for i=0 to ubound(vetPlanejamento,2)
				'response.write "1 - vetPlanejamento<hr>"
				cod_item_planejamento_geral_pai  	= vetPlanejamento(0,i)  'cod_item_planejamento_geral_pai
				semestre  							= vetPlanejamento(1,i)  'semestre
				cod_disciplina  					= vetPlanejamento(2,i)  'cod_disciplina
				cod_bimestre  						= vetPlanejamento(3,i)  'cod_bimestre
				cod_periodo  						= vetPlanejamento(4,i)  'cod_periodo
				cod_curso  							= vetPlanejamento(5,i)  'cod_curso
				descricao_item  					= vetPlanejamento(6,i)  'descricao
				cod_tipo_planejamento  				= vetPlanejamento(7,i)  'cod_tipo_planejamento

				'busca a unidade tematica
				descricao_unidade_tematica = ""
				sql=" select descricao"
				sql=sql & " from SCA_ITEM_PLANEJAMENTO_GERAL i"
				sql=sql & " inner join SCA_PLANEJAMENTO_GERAL g on g.cod_planejamento_geral = i.cod_planejamento_geral"
				sql=sql & " where cod_item_planejamento_geral = " & cod_item_planejamento_geral_pai
				'response.write sql & "<hr>"
				vetUnidadeTematica = null
				rs.open sql, cnn, 3, 1
				if not rs.eof then
					vetUnidadeTematica = rs.getRows
				end if
				rs.close
					
				if isArray(vetUnidadeTematica) then
					for j=0 to ubound(vetUnidadeTematica,2)
						'response.write "2 - vetUnidadeTematica<hr>"
						descricao_unidade_tematica  = vetUnidadeTematica(0,j)
					next
				end if
				
				'busca as unidades
				sql=" select distinct codigo as cod_empresa_destino"
				sql=sql & " from SEG_EMPRESA "
				sql=sql & " where codigo <> " & cod_empresa
				if intCodEmpresaDestino <> "0" then
					sql=sql & " and codigo =" & intCodEmpresaDestino
				end if
				sql=sql & " order by codigo"
				
				vetUnidades = null
				rs.open sql, cnn, 3, 1
				if not rs.eof then
					vetUnidades = rs.getRows
				end if
				rs.close
					
				if isArray(vetUnidades) then
					for j=0 to ubound(vetUnidades,2)
						cod_empresa_destino  	= vetUnidades(0,j)
						cod_disciplina_destino = 0
						
						'response.write "3 - vetUnidades cod. " & cod_empresa_destino & "<hr>"
						
						sql = "select top 1 cod_disciplina as cod_disciplina_destino"
						sql=sql & " from SCA_DISCIPLINA "
						sql=sql & " where situacao = 'A' "
						
						vetDisciplina = null
						rs.open sql, cnn, 3, 1
						if not rs.eof then
							vetDisciplina = rs.getRows
						end if
						rs.close
							
						if isArray(vetDisciplina) then
						
							for h=0 to ubound(vetDisciplina)
								
								cod_disciplina_destino  	= vetDisciplina(0,h)
								
								'response.write "4 - vetDisciplina cod. " & cod_disciplina_destino & "<hr>"
								
								'verifica se a unidade tematica tem cadastrada para a unidade de destino, se não tiver será incluida
								existeUnidadeTematica = "N"
								sql = "select i.cod_planejamento_geral"
								sql=sql & " from SCA_ITEM_PLANEJAMENTO_GERAL i "
								sql=sql & " inner join SCA_PLANEJAMENTO_GERAL g on g.cod_planejamento_geral = i.cod_planejamento_geral "
								sql=sql & " where i.descricao='" & descricao_unidade_tematica & "'"
								sql=sql & " and g.cod_disciplina = " & cod_disciplina_destino
								sql=sql & " and g.cod_periodo = " & cod_periodo_destino
								sql=sql & " and g.anoLetivo = " & ano_letivo
								'response.write sql & "<hr>"
								strExisteUnidadeTematica = "N"
								rs.open sql, cnn, 3, 1
								if not rs.eof then
									cod_planejamento_geral_nova_unidade_tematica = rs("cod_planejamento_geral")
									strExisteUnidadeTematica = "S"
								end if
								rs.close
								
								if strExisteUnidadeTematica = "N" then
									'response.write "5 - vetExisteUnidadeTematica = null<hr>"
									cod_planejamento_geral_nova_unidade_tematica=""
									sql = "select distinct g.cod_planejamento_geral"
									sql=sql & " from SCA_ITEM_PLANEJAMENTO_GERAL i "
									sql=sql & " inner join SCA_PLANEJAMENTO_GERAL g on g.cod_planejamento_geral = i.cod_planejamento_geral "
									sql=sql & " where g.cod_disciplina = " & cod_disciplina_destino
									sql=sql & " and g.cod_periodo = " & cod_periodo_destino
									sql=sql & " and i.cod_tipo_planejamento = " & cod_tipo_planejamento
									sql=sql & " and g.anoLetivo = " & ano_letivo
									'response.write sql & "<hr>"

									cod_planejamento_geral_nova_unidade_tematica = 0
									rs.open sql, cnn, 3, 1
									if not rs.eof then
										cod_planejamento_geral_nova_unidade_tematica = rs("cod_planejamento_geral")
									end if
									rs.close
										
									if cod_planejamento_geral_nova_unidade_tematica = 0 then
										'response.write "NÃO EXISTE PLANEJAMENTO GERAL CRIADO"
										'não existe planejamento geral para essa unidade para essa disciplina e periodo 
										'será criar o planejamento geral com a situação inicial e com a situação liberado
										cod_situacao_planejamento = 3 'inicial
				
										sql = "SET NOCOUNT ON INSERT INTO SCA_PLANEJAMENTO_GERAL (anoLetivo, semestre, cod_periodo, cod_disciplina, cod_situacao_planejamento, cod_planejamento_geral_pai, cod_empresa, usuario_incl, data_hora_incl, usuario_altr, data_hora_altr) VALUES ("
										sql=sql & ano_letivo & ","
										sql=sql & semestre & ","
										sql=sql & cod_periodo_destino & ","
										sql=sql & cod_disciplina_destino & ","
										sql=sql & cod_situacao_planejamento & ","
										sql=sql & "null,"
										sql=sql & "null,"
										sql=sql & "'" & session("usuarioWeb") & "',"
										sql=sql & " getdate(),"
										sql=sql & "'" & session("usuarioWeb") & "',"
										sql=sql & " getdate()) ;SELECT @@IDENTITY"
										'response.write sql & "<hr>"
										Set rsAux1 = cnn.Execute(sql)
										cod_planejamento_geral_nova_unidade_tematica = rsAux1(0)
										rsAux1.close
										if err.number <> 0 then cnn.rollbackTrans
										
										cod_situacao_planejamento = 7 'liberado
										sql = "INSERT INTO SCA_PLANEJAMENTO_GERAL (anoLetivo, semestre, cod_periodo, cod_disciplina, cod_situacao_planejamento, cod_planejamento_geral_pai, cod_empresa, usuario_incl, data_hora_incl, usuario_altr, data_hora_altr) VALUES ("
										sql=sql & ano_letivo & ","
										sql=sql & semestre & ","
										sql=sql & cod_periodo_destino & ","
										sql=sql & cod_disciplina_destino & ","
										sql=sql & cod_situacao_planejamento & ","
										sql=sql & cod_planejamento_geral_nova_unidade_tematica & ","
										sql=sql & cod_empresa_destino & ","
										sql=sql & "'" & session("usuarioWeb") & "',"
										sql=sql & " getdate(),"
										sql=sql & "'" & session("usuarioWeb") & "',"
										sql=sql & " getdate())"
										cnn.Execute(sql)
										if err.number <> 0 then cnn.rollbackTrans
										
									end if
									
									'insere nova unidade tematica para a unidade que não existe o item
									sql="insert SCA_ITEM_PLANEJAMENTO_GERAL (cod_planejamento_geral, descricao, usuario_incl, data_hora_incl, usuario_altr, data_hora_altr ) values ("
									sql=sql & cod_planejamento_geral_nova_unidade_tematica & ","
									sql=sql & "'" & descricao_unidade_tematica & "',"
									sql=sql & "'" & session("usuarioWeb") & "',"
									sql=sql & " getdate(),"
									sql=sql & "'" & session("usuarioWeb") & "',"
									sql=sql & " getdate())"
									'response.write sql & "<hr>"
									cnn.execute sql
									if err.number <> 0 then cnn.rollbackTrans

									
								end if
								
								
								sql= " select cod_planejamento_geral "
								sql=sql & " from SCA_ITEM_PLANEJAMENTO_GERAL "
								sql=sql & " where cod_planejamento_geral = " & cod_planejamento_geral_nova_unidade_tematica
								sql=sql & " and descricao in "
								sql=sql & " ("
								sql=sql & " select i.descricao"
								sql=sql & " from SCA_ITEM_PLANEJAMENTO_GERAL i "
								sql=sql & " inner join SCA_PLANEJAMENTO_GERAL g on g.cod_planejamento_geral = i.cod_planejamento_geral "
								sql=sql & " inner join SCA_PERIODO p on p.Cod_Periodo = g.cod_periodo "
								sql=sql & " where cod_item_planejamento_geral = " & cod_item_planejamento_geral
								sql=sql & " )"
								sql=sql & " and cod_tipo_planejamento = " & cod_tipo_planejamento
								sql=sql & " and cod_bimestre = " & cod_bimestre
								'response.write sql
								
								itemExiste = "N"
								rs.open sql, cnn, 3, 1
								if not rs.eof then
									itemExiste = "S"
								end if
								rs.close
								
								if itemExiste = "N" then
									sql="insert SCA_ITEM_PLANEJAMENTO_GERAL ("
									sql=sql & " cod_planejamento_geral,"
									sql=sql & " descricao,"
									sql=sql & " cod_tipo_planejamento,"
									sql=sql & " cod_bimestre,"
									sql=sql & " cod_item_planejamento_geral_pai,"
									sql=sql & " cod_empresa,"
									sql=sql & " usuario_incl,"
									sql=sql & " data_hora_incl,"
									sql=sql & " usuario_altr,"
									sql=sql & " data_hora_altr)"
									sql=sql & " select "
									sql=sql & " i.cod_planejamento_geral,"
									sql=sql & "'" & descricao_item & "',"
									sql=sql & cod_tipo_planejamento & ","
									sql=sql & cod_bimestre & ","
									sql=sql & " i.cod_item_planejamento_geral as cod_item_planejamento_geral_pai,"
									sql=sql & " null as cod_empresa,"
									sql=sql & "'" & session("usuarioWeb") & "' as usuario_incl,"
									sql=sql & " getdate(),"
									sql=sql & "'" & session("usuarioWeb") & "' as usuario_altr,"
									sql=sql & " getdate()"
									sql=sql & " from SCA_ITEM_PLANEJAMENTO_GERAL i"
									sql=sql & " inner join SCA_PLANEJAMENTO_GERAL g on g.cod_planejamento_geral = i.cod_planejamento_geral"
									sql=sql & " where i.descricao='" & descricao_unidade_tematica & "'"
									sql=sql & " and g.cod_disciplina = " & cod_disciplina_destino
									sql=sql & " and g.cod_periodo = " & cod_periodo_destino
									sql=sql & " and g.anoLetivo = " & ano_letivo
									'response.write sql & "<hr>"
									'response.end
									cnn.execute sql
									if err.number <> 0 then cnn.rollbackTrans
								end if
							next
							
						end if
						
					next
					
				end if				

			next
	
		end if
		
	end if 
	response.write "OK"
	cnn.commitTrans
	
%>
