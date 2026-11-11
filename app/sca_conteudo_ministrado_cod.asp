<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<%

acao			               = Trim(Request("acao"))
codPlanejamentoProfessor       = trim(request("cod_planejamento_professor"))
codItemPlanejamentoProfessor   = trim(request("cod_item_planejamento_professor"))
codItemPlanejamentoGeral       = trim(request("cod_item_planejamento_geral"))
codConteudoMinistradoProfessor = trim(request("cod_conteudo_ministrado_professor"))
conteudoComplementar           = trim(request("conteudoComplementar"))


anoLetivo = trim(request("anoLetivo"))
Semestre = trim(request("Semestre"))
codPeriodo = trim(request("codPeriodo"))
codDisciplina = trim(request("codDisciplina"))
codTurma = trim(request("codTurma"))
codProfessor = trim(request("txtCodProfessor"))
aula = trim(request("aula"))
bolAulaExtra = request("bolAulaExtra")

dataAula = request("dataAula")

strPeriodoValido = Trim(Request("periodoValido"))

'campo da validação do coordenador
strComplemento 	= Trim(Request("complemento"))

' Dados do Usuario
strUsuario_incl   	= session("usuarioWeb")
strData_hora_incl 	= formataDataBDAccess(date) & " " & time
strUsuario_altr   	= session("usuarioWeb")
strData_hora_altr 	= formataDataBDAccess(date) & " " & time

'response.write "acao:" & acao

if acao = "executaConteudo" then
    
    bolItemExecutado = false


    'Verifica se o item já foi executado

    sql="select cod_conteudo_ministrado_professor from SCA_CONTEUDO_MINISTRADO_PROFESSOR"
    sql=sql & " where cod_planejamento_professor = " & codPlanejamentoProfessor
    if codItemPlanejamentoProfessor <> "" then
        sql=sql & " and cod_item_planejamento_professor=" & codItemPlanejamentoProfessor
    else
        sql=sql & " and cod_item_planejamento_geral=" & codItemPlanejamentoGeral
    end if
    'response.write sql
	
    RS.OPEN SQL, cnn
    if rs.eof = false then
        bolItemExecutado = true
    end if
    RS.CLOSE

    if bolItemExecutado = false then
        sql="insert into SCA_CONTEUDO_MINISTRADO_PROFESSOR (cod_planejamento_professor, cod_item_planejamento_professor, cod_item_planejamento_geral, data_aula, usuario_incl, data_hora_incl) values ("
        sql=sql & codPlanejamentoProfessor & ","
        if codItemPlanejamentoProfessor <> "" then
            sql=sql & codItemPlanejamentoProfessor & ","
        else
            sql=sql & "NULL,"
        end if
        if codItemPlanejamentoGeral <> "" then
            sql=sql & codItemPlanejamentoGeral & ","
        else
            sql=sql & "NULL,"
        end if
        sql=sql & "'" & formataDataBD(dataAula) & "',"
        sql=sql & "'" & strUsuario_incl & "','" & strData_hora_incl & "')"
        'response.write sql
        cnn.execute sql

    end if
elseif acao="removeConteudo" then

    sql="delete from SCA_CONTEUDO_MINISTRADO_PROFESSOR where cod_conteudo_ministrado_professor=" & codConteudoMinistradoProfessor
    cnn.execute sql

elseif acao="listaConteudoExecutado" then
    response.write "<ul class='list-group list-group-flush'>" 
    
    sql="select cod_conteudo_ministrado_professor, p.cod_item_planejamento_professor, p.descricao as d1, p.complemento, g.cod_item_planejamento_geral, g.descricao as d2 from SCA_CONTEUDO_MINISTRADO_PROFESSOR cm"
    sql=sql & " left join sca_item_planejamento_professor p on cm.cod_item_planejamento_professor = p.cod_item_planejamento_professor"
    sql=sql & " left join sca_item_planejamento_geral g on cm.cod_item_planejamento_geral = g.cod_item_planejamento_geral"
    sql=sql & " where cm.cod_planejamento_professor=" & codPlanejamentoProfessor
	if ucase(session("usuarioWeb"))="SERGIO" then
		
		'response.write sql & "<hr>"
		'response.end
	end if
    rs.open sql, cnn
    if rs.eof = false then
        while not rs.eof
            if rs("d1") <>"" then
                'codItemPlanejProf = rs("cod_item_planejamento_professor")
                'codItemPlanejGeral = ""
                strDescricao = rs("d1")
            else
                'codItemPlanejProf = ""
                'codItemPlanejGeral = rs("cod_item_planejamento_geral")           
                strDescricao = rs("d2")
            end if
            strComplemento = ""
            if rs("complemento") <>"" then
                strComplemento = "<br><textarea disabled id='txtItem-"  & rs("cod_item_planejamento_professor") & "' class='textArea' onKeyUp=mostraBotaoSalvarConteudo(" & rs("cod_item_planejamento_professor") & ")>" & rs("complemento") & "</textArea><br>"
            end if
            if strPeriodoValido = "S" then
                btnExclusao = "<a onclick='removeConteudoExecutado(" & rs("cod_conteudo_ministrado_professor") & ")' class='btn btn-outline-danger btn-xs btn-icon rounded-circle waves-effect waves-themed'><i class='fal fa-times'></i></a>"
            end if
            response.write "<li class='list-group-item item' id='li-" & rs("cod_conteudo_ministrado_professor") & "'>" & btnExclusao & " " & strDescricao & strComplemento & "</li>"
            rs.movenext
        wend
    else
        response.write "Nenhum registro encontrado"
    end if
    rs.close
    response.write "</ul>"

elseif acao="salvaConteudoComplementar" then

    sql="update SCA_PLANEJAMENTO_PROFESSOR set" 
    if conteudoComplementar = "" then
        sql=sql & " desc_conteudo_complementar=null" 
    else
        sql=sql & " desc_conteudo_complementar='" & conteudoComplementar & "'" 
    end if
    sql=sql & " where cod_planejamento_professor=" & codPlanejamentoProfessor
    cnn.execute sql

elseif acao = "listarTurmasDisciplinaProfessor" then

    sql = " SELECT distinct "
    sql=sql & " 		t.Cod_Empresa,"
    sql=sql & " 		HA.AnoLetivo,"
    sql=sql & " 		HA.Semestre,"
    sql=sql & " 		P.Cod_Periodo,"
    sql=sql & " 		HA.Cod_Colaborador as codProfessor," 
    sql=sql & " 		DI.Cod_Disciplina,"
    sql=sql & " 		TU.Cod_Turno,"
    sql=sql & " 		T.Cod_Turma," 
    sql=sql & " 		T.TurmaAluno" 
    if not bolAulaExtra then
        sql=sql & " FROM SCA_HORARIO_AULA HA" 
    else
        sql=sql & " FROM SCA_HORARIO_AULA_extra HA" 
    end if
    sql=sql & " INNER JOIN SCA_HORARIO H ON H.codigo = HA.COD_HORARIO" 
    sql=sql & " INNER JOIN SRH_COLABORADOR C ON C.codigo = HA.Cod_Colaborador" 
    sql=sql & " INNER JOIN SCA_TURMA T ON T.COD_EMPRESA=HA.COD_EMPRESA AND T.COD_TURMA=HA.COD_TURMA" 
    sql=sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR" 
    sql=sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO=G.COD_PERIODO" 
    sql=sql & " INNER JOIN SCA_CURSO CU ON CU.COD_CURSO=P.COD_CURSO" 
    sql=sql & " INNER JOIN SRH_TURNO TU ON TU.Cod_Turno = H.CodTurno" 
    sql=sql & " INNER JOIN SCA_DISCIPLINA DI ON DI.Cod_Disciplina = HA.Cod_Disciplina"
    sql=sql & " WHERE HA.COD_EMPRESA =" & Session("CodEmpresa") 
    sql=sql & " AND HA.ANOLETIVO =" & anoLetivo 
    sql=sql & " AND HA.SEMESTRE in (" & Semestre & ")" 
    sql=sql & " AND P.COD_PERIODO =" & codPeriodo
    'sql=sql & " AND HA.Cod_Colaborador =" & codProfessor
    sql=sql & " AND HA.Cod_Colaborador in (select codigo from SRH_COLABORADOR where cpf in  (select cpf from SRH_COLABORADOR where codigo =" & codProfessor & "))"
    sql=sql & " AND DI.Cod_Disciplina =" & codDisciplina
    sql=sql & " AND T.COD_TURMA <>" & codTurma
    if bolAulaExtra then
        sql=sql & " AND HA.dataLancamento='" & formataDataBd(aula) & "'"
    end if    
    'if ucase(session("usuarioWeb"))="ROBERTO.JUNIOR" then
    '    response.write sql
    'end if
    rs.open sql, cnn,3,1
    if rs.eof = false then
        response.write "<ul style='padding-top: 15px ;'>"
        while not rs.eof 
            codPlanejamentoProfTurma = ""    
            strObservacaoPlanejamento = ""
            
            ' Verifica se a turma já possui conteúdo ministrado na aula
            sql="select" 
            sql=sql & " pp.cod_planejamento_professor, "
            sql=sql & " cm.cod_conteudo_ministrado_professor, "
            sql=sql & " pp.desc_conteudo_complementar,"
            sql=sql & " pp.validado"
            sql=sql & " from SCA_PLANEJAMENTO_PROFESSOR PP"
            sql=sql & " left join SCA_CONTEUDO_MINISTRADO_PROFESSOR CM "
            sql=sql & " on PP.cod_planejamento_professor = CM.cod_planejamento_professor"
            sql=sql & " where pp.cod_empresa =" &  Session("CodEmpresa") 
            sql=sql & " and pp.anoLetivo =" & anoLetivo
            sql=sql & " and pp.semestre =" & Semestre
            sql=sql & " and pp.cod_periodo =" & codPeriodo
            sql=sql & " and pp.cod_disciplina =" & codDisciplina
            sql=sql & " and pp.cod_turma =" & rs("Cod_Turma")
            'sql=sql & " and pp.numero_aula =" & aula
            if not bolAulaExtra then
                sql=sql & " and pp.numero_aula =" & aula
            else
                sql=sql & " and pp.data_aula_extra ='" & formataDataBD(aula) & "'"
            end if

            'response.write sql
            rsAux.open sql,cnn
            if rsAux.eof = false then
                if rsAux("validado") = "S" then
                    if not isnull(rsAux("cod_conteudo_ministrado_professor")) or not isnull(rsAux("desc_conteudo_complementar")) then
                        strDesabilitaTurma = "S"
                        strObservacaoPlanejamento = "(já possui conteúdo ministrado para a aula " & aula & ")"
                    else
                        strDesabilitaTurma = "N"
                        codPlanejamentoProfTurma = rsAux("cod_planejamento_professor")
                    end if
                else
                    strDesabilitaTurma = "S"
                    strObservacaoPlanejamento = "(não possui planejamento Validado)"
                end if 
            else
                strDesabilitaTurma = "S"
                strObservacaoPlanejamento = "(não possui planejamento Validado)"
            end if
            
            rsAux.close
            strObsTurma = ""
            if cint(rs("codProfessor")) <> cint(intCodProfessor) then
                strObsTurma = "<i>(turma de outro contrato)</i>"
            end if

            if strObservacaoPlanejamento <>"" then strObservacaoPlanejamento = "<i>" & strObservacaoPlanejamento & "</i>"

            %>
                <li><input type="checkbox" value="<%=rs("Cod_Turma") & "|" & rs("codProfessor")%>" name="chkTurma" codPlanejamentoProfTurma="<%=codPlanejamentoProfTurma%>" id="chkTurma<%=rs("Cod_Turma")%>" <%if strDesabilitaTurma="S" then response.write "disabled"%>> <%=rs("TurmaAluno")%> <%=strObsTurma%> <%=strObservacaoPlanejamento%></li>
            <%
            rs.movenext
        wend
        response.write "</ul>"
    else
        response.write "Não é possível replicar"
    end if
    rs.close        
elseif acao="replicar" then
    
    codPlanejamentoProfessorOrigem = request("strPlanejamentoOrigem")
    destino = request("strPlanejamentoDestino") & ","
    vetCodPlanejamentoDestino = split(destino,",")
   
    cnn.BeginTrans

    for plan=0 to ubound(vetCodPlanejamentoDestino)
            if vetCodPlanejamentoDestino(plan) <> "" then
                replicarConteudoMinistrado codPlanejamentoProfessorOrigem, vetCodPlanejamentoDestino(plan)
            end if
    next
    'cnn.RollbackTrans
    cnn.CommitTrans
    
end if


sub replicarConteudoMinistrado( codPlanejamentoProfessorOrigem,  codPlanejamentoProfessorDestino)

    'conteúdo Complementar
    strConteudoComplementar = ""
    sql="select desc_conteudo_complementar from SCA_PLANEJAMENTO_PROFESSOR where cod_planejamento_professor=" & codPlanejamentoProfessorOrigem
    rs.open sql, cnn
    if rs.eof = false then
        if not isnull(rs("desc_conteudo_complementar")) then
            strConteudoComplementar = rs("desc_conteudo_complementar")
        end if
    end if
    rs.close

    if strConteudoComplementar <> "" then
        sql="update SCA_PLANEJAMENTO_PROFESSOR set desc_conteudo_complementar='" & strConteudoComplementar & "' where cod_planejamento_professor=" & codPlanejamentoProfessorDestino
        cnn.execute sql
    end if

    sql="select CM.cod_item_planejamento_professor, CM.cod_item_planejamento_geral, pp.cod_disciplina, pp.cod_empresa, pp.anoletivo, pp.numero_aula "
	sql = sql & " from SCA_PLANEJAMENTO_PROFESSOR PP left "
	sql = sql & " join SCA_CONTEUDO_MINISTRADO_PROFESSOR CM on PP.cod_planejamento_professor = CM.cod_planejamento_professor "
	sql = sql & " where pp.cod_planejamento_professor =" & codPlanejamentoProfessorOrigem
	'if ucase(session("usuarioWeb"))="SERGIO" then
	'	response.write sql & "<hr>"
	'end if
	rs.open sql, cnn
    vetPlanejamentoProfessorOrigem = rs.getRows()
    rs.close

    for i=0 to ubound(vetPlanejamentoProfessorOrigem,2)
		
		cod_item_planejamento_professor = vetPlanejamentoProfessorOrigem(0,i)
		if isnull(cod_item_planejamento_professor) then cod_item_planejamento_professor = ""
		cod_item_planejamento_geral = vetPlanejamentoProfessorOrigem(1,i)
		if isnull(cod_item_planejamento_geral) then cod_item_planejamento_geral = ""
		
		cod_empresa		= vetPlanejamentoProfessorOrigem(3,i)
		ano_letivo 		= vetPlanejamentoProfessorOrigem(4,i)
		cod_disciplina 	= vetPlanejamentoProfessorOrigem(2,i)
		numero_aula 	= vetPlanejamentoProfessorOrigem(5,i)

	'if ucase(session("usuarioWeb"))="SERGIO" then
	'	response.write "<br>cod_empresa: " & cod_empresa
	'	response.write "<br>ano_letivo: " & ano_letivo
	'	response.write "<br>cod_disciplina: " & cod_disciplina
	'	response.write "<br>numero_aula: " & numero_aula
	'end if
		
        codItemPlanejamentoGeral = ""
		if cod_item_planejamento_professor<>"" then 
            'Buscar o código ítem planejamento geral
            sql="SELECT cod_item_planejamento_geral FROM SCA_ITEM_PLANEJAMENTO_PROFESSOR WHERE cod_item_planejamento_professor = " & cod_item_planejamento_professor
            rsAux.open sql, cnn
			codItemPlanejamentoGeral = rsAux("cod_item_planejamento_geral")
            rsAux.close
        else
            codItemPlanejamentoGeral = cod_item_planejamento_geral
        end if

        'Busca o codigo_item_planejamento_geral no planejamento da turma de destino
        sql="select ipp.cod_item_planejamento_professor, pp.cod_turma"
        sql=sql & " from SCA_PLANEJAMENTO_PROFESSOR pp"
        sql=sql & " inner join SCA_ITEM_PLANEJAMENTO_PROFESSOR ipp on pp.cod_planejamento_professor = ipp.cod_planejamento_professor"
        sql=sql & " where ipp.cod_tipo_planejamento = 2"
        sql=sql & " and pp.cod_planejamento_professor =" & codPlanejamentoProfessorDestino
        sql=sql & " and cod_item_planejamento_geral =" & codItemPlanejamentoGeral     
        rsAux.open sql, cnn
        if rsAux.eof = false then
            codItemPlanejamentoProfessorDestino = rsAux("cod_item_planejamento_professor")
			cod_turma = rsAux("cod_turma")
        else
            codItemPlanejamentoProfessorDestino = ""
			cod_turma = ""
        end if
        rsAux.close
        
		
		if cod_turma <> "" then
			sql = "execute SP_BuscaDataNoCalendario " & cod_empresa & "," & ano_letivo & "," & cod_turma & "," & cod_disciplina & "," & numero_aula 
			rsAux.open sql, cnn
			if rsAux.eof = false then
				dataAula = formataDataBD(rsAux("dia_mes") & "/" & rsAux("mes") & "/" & rsAux("ano"))
			end if
			rsAux.close
		end if
		
        if codItemPlanejamentoProfessorDestino <> "" then
            'Encontrou o codigo_item_planejamento_geral no destino
			if dataAula<>"" then
				sql="insert into SCA_CONTEUDO_MINISTRADO_PROFESSOR (cod_planejamento_professor, cod_item_planejamento_professor, cod_item_planejamento_geral, data_aula, usuario_incl, data_hora_incl)"
				sql=sql & " values (" & codPlanejamentoProfessorDestino & "," & codItemPlanejamentoProfessorDestino & ",null,'" & dataAula & "','" & strUsuario_incl & "',getdate())"
				cnn.execute sql
			end if
        else
            'Não Encontrou o codigo_item_planejamento_geral no destino. Nesse caso deve incluir o codItemPlanejamentoGeral
            
            'Verifica se o codItemPlanejamentoGeral já está cadastrado.
            bolPodeIncluir = false
            sql="select * from SCA_CONTEUDO_MINISTRADO_PROFESSOR where cod_item_planejamento_geral=" & codItemPlanejamentoGeral
            sql=sql & " and cod_planejamento_professor=" & codPlanejamentoProfessorDestino
			rsAux.open sql, cnn
            if rsAux.eof then
                bolPodeIncluir = true
            end if
            rsAux.close

            if bolPodeIncluir then
				if dataAula<>"" then
					sql="insert into SCA_CONTEUDO_MINISTRADO_PROFESSOR (cod_planejamento_professor, cod_item_planejamento_professor, cod_item_planejamento_geral, data_aula, usuario_incl, data_hora_incl)"
					sql=sql & " values (" & codPlanejamentoProfessorDestino & ",NULL," & codItemPlanejamentoGeral & ",'" & dataAula & "','" & strUsuario_incl & "',getdate())"
					cnn.execute SQL
				end if
            end if
        end if
        
    next


end sub

%>                    


