<%
'------------------------
'testa modular da função:
'------------------------

'se for modular SIM
'	verfica modulação
'    	se for interdisciplinar -> faixa de horário
'       se for disciplinar 		-> horario de aula 
'se for modular NAO
'	verifica cadastro ->  faixa de horario
    
'onde será atualizado:
'	PONTO
'    	 - Faixa de Horário;
'        - Horario especial;
'	RH
'        - cadastro da função;
'        - cadastro colaborador;
'        - modulação de professor e funcionario;
'        - substituicao;
'	ACADEMICO
'		 - Horario de aula.
	
'parametro para utilizacao:
' - intCodFuncao
' - intCodTurno

	if modular = "S" then
		' Deleta a Tabela de Colaborador Folha
		sql = "delete f from APO_FAIXA_HORARIO_COLABORADOR f "
		sql = sql & " inner join SRH_MODULACAO_DISCIPLINAR_DOCENTE m on m.COD_COLABORADOR = f.COD_COLABORADOR"
		sql = sql & " inner join SRH_FUNCAOCOLABORADOR fu on fu.Cod_Funcao=m.Cod_Funcao"
		sql = sql & " Where m.Cod_Funcao = " & intCodFuncao
		sql = sql & " and m.cod_empresa in (select codigo from seg_empresa where cod_grupo=" & session("codGrupo")& ")"
		sql = sql & " and m.cod_turno=" & intCodTurno
		'response.write sql & "<hr>"
		cnn.execute sql
	else
		' Deleta a Tabela de Colaborador Folha
		sql = "delete f from APO_FAIXA_HORARIO_COLABORADOR f inner join SRH_COLABORADOR c on c.codigo=f.COD_COLABORADOR"
		sql = sql & " Where c.CodFuncao = " & intCodFuncao
		sql = sql & " and c.cod_empresa in (select codigo from seg_empresa where cod_grupo=" & session("codGrupo")& ")	"	
		sql = sql & " and c.codTurno = " & intCodTurno
		'response.write sql & "<hr>"
		'response.end
		cnn.execute sql
	end if

	for i=2 to 7
		
		strMensagem = "Registro Salvo com sucesso..."

		strHoraInicio="" 
		strMinutoInicio=""
		strHoraFim=""
		strMinutoFim=""

		'INTEGRAL
		if trim(intCodTurno) = "4" then
			'atualiza o horario novo para a função alterada
			sql = "select top 1 h.hora, h.Minuto "
			sql = sql & " from APO_PONTOHORARIO_FUNCAO cf"
			sql = sql & " inner join APO_PONTOHORARIO h on h.codigo=cf.Cod_PontoHorario"
			sql = sql & " where cod_funcao=" & intCodFuncao
			sql = sql & " and Cod_turno=" & intCodTurno
			sql = sql & " and Cod_DiaSemana=" & i
			sql = sql & " and tipo='E'"
			sql = sql & " order by h.hora "
			rs.open sql, cnn
			if rs.eof = false then
				strHoraInicioM = rs("hora")
				strMinutoInicioM = rs("minuto")
			end if
			rs.close
			
			sql = "select top 1 h.hora, h.Minuto "
			sql = sql & " from APO_PONTOHORARIO_FUNCAO cf"
			sql = sql & " inner join APO_PONTOHORARIO h on h.codigo=cf.Cod_PontoHorario"
			sql = sql & " where cod_funcao=" & intCodFuncao
			sql = sql & " and Cod_turno=" & intCodTurno
			sql = sql & " and Cod_DiaSemana=" & i
			sql = sql & " and tipo='E'"
			sql = sql & " order by h.hora desc "
			rs.open sql, cnn
			if rs.eof = false then
				strHoraInicioV = rs("hora")
				strMinutoInicioV = rs("minuto")
			end if
			rs.close

			sql = "select top 1 h.hora, h.Minuto "
			sql = sql & " from APO_PONTOHORARIO_FUNCAO cf"
			sql = sql & " inner join APO_PONTOHORARIO h on h.codigo=cf.Cod_PontoHorario"
			sql = sql & " where cod_funcao="&intCodFuncao
			sql = sql & " and Cod_turno=" & intCodTurno
			sql = sql & " and Cod_DiaSemana=" & i
			sql = sql & " and tipo='S'"
			sql = sql & " order by h.hora "
			rs.open sql, cnn
			if rs.eof = false then
				strHoraFimM = rs("hora")
				strMinutoFimM = rs("minuto")
			end if
			rs.close
			
			sql = "select top 1 h.hora, h.Minuto "
			sql = sql & " from APO_PONTOHORARIO_FUNCAO cf"
			sql = sql & " inner join APO_PONTOHORARIO h on h.codigo=cf.Cod_PontoHorario"
			sql = sql & " where cod_funcao="&intCodFuncao
			sql = sql & " and Cod_turno=" & intCodTurno
			sql = sql & " and Cod_DiaSemana=" & i
			sql = sql & " and tipo='S'"
			sql = sql & " order by h.hora desc"
			rs.open sql, cnn
			if rs.eof = false then
				strHoraFimV = rs("hora")
				strMinutoFimV = rs("minuto")
			end if
			rs.close
			
			if modular = "S" then
				' Deleta a Tabela de Colaborador Folha
				sql = "insert APO_FAIXA_HORARIO_COLABORADOR "
				sql = sql & " select distinct m.Cod_empresa, m.Cod_Colaborador, m.cod_Turno, "&i&", " & strHoraInicioM &", " & strMinutoInicioM &", " & strHoraFimM &", " & strMinutoFimM 
				sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE m "
				sql = sql & " inner join SRH_FUNCAOCOLABORADOR fu on fu.Cod_Funcao=m.Cod_Funcao"
				sql = sql & " Where m.Cod_Funcao = " & intCodFuncao & " and m.cod_Turno = " & intCodTurno & " and m.Status = 'A'"
				sql = sql & " and m.Cod_empresa in (select codigo from seg_empresa where cod_grupo=" & session("codGrupo")& ")"
				sql = sql & " and m.cod_turno=" & intCodTurno
					'response.write sql & "<hr>"
				cnn.execute sql
				sql = "insert APO_FAIXA_HORARIO_COLABORADOR "
				sql = sql & " select distinct m.Cod_empresa, m.Cod_Colaborador, m.cod_Turno, "&i&", " & strHoraInicioV &", " & strMinutoInicioV &", " & strHoraFimV &", " & strMinutoFimV 
				sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE m "
				sql = sql & " inner join SRH_FUNCAOCOLABORADOR fu on fu.Cod_Funcao=m.Cod_Funcao"
				sql = sql & " Where m.Cod_Funcao = " & intCodFuncao & " and m.cod_Turno = " & intCodTurno & " and m.Status = 'A'"
				sql = sql & " and m.Cod_empresa in (select codigo from seg_empresa where cod_grupo=" & session("codGrupo")& ")"
				sql = sql & " and m.cod_turno=" & intCodTurno
				cnn.execute sql
			else
				sql = "insert APO_FAIXA_HORARIO_COLABORADOR "
				sql = sql & " select codLotacao, codigo, codTurno, "&i&", " & strHoraInicioM &", " & strMinutoInicioM &", " & strHoraFimM &", " & strMinutoFimM 
				sql = sql & " from SRH_COLABORADOR"
				sql = sql & " where SITUACAO='A' and codfuncao="&intCodFuncao&" and codTurno = " & intCodTurno
				sql = sql & " and cod_empresa in (select codigo from seg_empresa where cod_grupo=" & session("codGrupo")& ")	"
				sql = sql & " and codTurno = " & intCodTurno

'		response.write sql & "<hr>"
				cnn.execute sql	
				
				sql = "insert APO_FAIXA_HORARIO_COLABORADOR "
				sql = sql & " select codLotacao, codigo, codTurno, "&i&", " & strHoraInicioV &", " & strMinutoInicioV &", " & strHoraFimV &", " & strMinutoFimV 
				sql = sql & " from SRH_COLABORADOR"
				sql = sql & " where SITUACAO='A' and codfuncao="&intCodFuncao&" and codTurno = " & intCodTurno
				sql = sql & " and cod_empresa in (select codigo from seg_empresa where cod_grupo=" & session("codGrupo")& ")	"
				sql = sql & " and codTurno = " & intCodTurno
				cnn.execute sql	
'			response.write sql & "<hr>"
			end if
		
		'MATUTINO E VESPERTINO OU NOTURNO
		else
			'atualiza o horario novo para a função alterada
			sql = "select top 1 h.hora, h.Minuto "
			sql = sql & " from APO_PONTOHORARIO_FUNCAO cf"
			sql = sql & " inner join APO_PONTOHORARIO h on h.codigo=cf.Cod_PontoHorario"
			sql = sql & " where cod_funcao=" & intCodFuncao
			sql = sql & " and Cod_turno=" & intCodTurno
			sql = sql & " and Cod_DiaSemana=" & i
			sql = sql & " and tipo='E'"
			sql = sql & " order by h.hora "
		'response.write sql & "<hr>"
			rs.open sql, cnn
			if rs.eof = false then
				strHoraInicio = rs("hora")
				strMinutoInicio = rs("minuto")
			end if
			rs.close

			sql = "select top 1 h.hora, h.Minuto "
			sql = sql & " from APO_PONTOHORARIO_FUNCAO cf"
			sql = sql & " inner join APO_PONTOHORARIO h on h.codigo=cf.Cod_PontoHorario"
			sql = sql & " where cod_funcao="&intCodFuncao
			sql = sql & " and Cod_turno=" & intCodTurno
			sql = sql & " and Cod_DiaSemana=" & i
			sql = sql & " and tipo='S'"
			sql = sql & " order by h.hora desc"
		'response.write sql & "<hr>"
			rs.open sql, cnn
			if rs.eof = false then
				strHoraFim = rs("hora")
				strMinutoFim = rs("minuto")
			end if
			rs.close
			
			sql = "insert APO_FAIXA_HORARIO_COLABORADOR "
			sql = sql & " select codLotacao, codigo, codTurno, "&i&", " & strHoraInicio &", " & strMinutoInicio &", " & strHoraFim &", " & strMinutoFim 
			sql = sql & " from SRH_COLABORADOR"
			sql = sql & " where SITUACAO='A' and codfuncao="&intCodFuncao& " and codTurno = " & intCodTurno
			sql = sql & " and cod_empresa in (select codigo from seg_empresa where cod_grupo=" & session("codGrupo")& ")	"
		'response.write sql & "<hr>"
			cnn.execute sql	
		end if
	next
%>