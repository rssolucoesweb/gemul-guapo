<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<%
'on error resume next

acao			   = Trim(Request("acao"))
apenasConteudo     = trim(Request("apenasConteudo"))
paginaOrigem       = trim(Request("paginaOrigem"))

codPlanejamento = Trim(Request("codPlanejamento")) 
codItemPai	   = Trim(Request("codItemPai"))	
codBimestre        = Trim(Request("codBimestre"))

codPlanejamentoGeral      = trim(request("cod_planejamento_geral"))
codPlanejamentoProfessor = trim(request("cod_planejamento_professor"))
codItemPlanejamentoGeral  = trim(request("cod_item_planejamento_geral"))
codItemPlanejamentoProfessor = trim(request("cod_item_planejamento_professor"))
anoLetivo                 = Trim(Request("anoLetivo"))	
semestre                  = Trim(Request("semestre"))
numeroAula                = Trim(Request("numeroAula"))
bolAulaExtra              = Trim(Request("bolAulaExtra"))
codProfessor              = Trim(Request("codProfessor"))
codPeriodo                = Trim(Request("cod_periodo"))
codDisciplina             = Trim(Request("codDisciplina"))
codTurno                  = Trim(Request("codTurno"))
codTurma                  = Trim(Request("codTurma"))
codTipo                   = Trim(Request("codTipo"))	
descricao	              = Trim(Request("descricao"))

' Materiais de apoio
codigoRecurso            = Trim(Request("codigoRecurso"))
descricaoRecurso         = Trim(Request("descricaoRecurso"))
nomeArquivo              = Trim(Request("nomeArquivo"))
tipoArquivo              = Trim(Request("tipoArquivo"))
tamanhoArquivo           = Trim(Request("tamanhoArquivo"))
arquivoBase64            = Request.Form("arquivoBase64")
urlRecurso               = Trim(Request("urlRecurso"))
strEdicaoRecurso         = Trim(Request("edicao"))

'campo da validação do coordenador
strObservacao 	= Trim(Request("observacao"))
strObservacaoSecretaria 	= Trim(Request("observacaoSecretaria"))
strValidado 	= Trim(Request("validado"))

strPeriodoValido = Trim(Request("periodoValido"))

' Dados do Usuario
strUsuario_incl   	= session("usuarioWeb")
strData_hora_incl 	= formataDataBDAccess(date) & " " & time
strUsuario_altr   	= session("usuarioWeb")
strData_hora_altr 	= formataDataBDAccess(date) & " " & time


function carregaItensCadastroExterno(codTipo) 
    
    dim intCont
    intCont = 0
    if codTipo = 3 then
        sql = "select cod_planejamento_metodologia as codigo, descricao from SCA_PLANEJAMENTO_METODOLOGIA"
    else
        sql = "select cod_planejamento_avaliacao as codigo, descricao from SCA_PLANEJAMENTO_AVALIACAO"
    end if
    sql=sql & " where ANO_LETIVO =" & anoLetivo
    sql=sql & " and COD_EMPRESA=" & session("codEmpresa")
    sql=sql & " and situacao='A'"

    rs.open sql, cnn
    if rs.eof = false then
        while not rs.eof

            response.write "    <li id='item-" & codTipo & "-" & rs("codigo") & "' class='list-group-item item' onclick='incluiItemPlanejamento(" & codTipo & ",0,""" &  replace(rs("descricao"),"""","´´") & """,""S"","" & bolAulaExtra & "")'>" & rs("descricao") & "</li>"
            intCont = intCont + 1
            rs.movenext
        wend
    end if
    rs.close    
    carregaItensCadastroExterno = intCont
end function

function carregaItensTipo(codItemPai, codTipo, codBimestre) 
    dim intContCadastroExterno, intContCadastro
    intContCadastroExterno = 0
    intContCadastro = 0
    response.write "<ul class='list-group list-group-flush'>"

    if codTipo = 3 or codTipo = 4 then
        intContCadastroExterno = carregaItensCadastroExterno(codTipo)
    end if

    sql="select * from SCA_ITEM_PLANEJAMENTO_GERAL"
    sql=sql & " where cod_item_planejamento_geral_pai =" & codItemPai
    sql=sql & " and cod_tipo_planejamento=" & codTipo
    sql=sql & " and (cod_empresa is null or cod_empresa=" & session("codEmpresa") & ")"
    sql=sql & " and cod_bimestre=" & codBimestre
    'response.write sql
    rs.open sql, cnn
    if rs.eof = false then

        while not rs.eof

            if strPeriodoValido = "S" then
                linha = "    <li id='item-" & rs("cod_item_planejamento_geral") & "' class='list-group-item item' onclick='incluiItemPlanejamento(" & codTipo & "," & rs("cod_item_planejamento_geral") & ",""" &  replace(rs("descricao"),"""","´´") & """,""S""," & bolAulaExtra & ")'>"
            else
                linha = "    <li id='item-" & rs("cod_item_planejamento_geral") & "' class='list-group-item item'>"
            end if

			if rs("cod_bimestre") <> "5" then
				linha = linha & "<b>" & rs("cod_bimestre") & "° " 
				if SESSION("controlePeriodoDeTempo") = 1 then 
					linha = linha & "Bim."
				elseif SESSION("controlePeriodoDeTempo") = 2 then 
					linha = linha & "Trim." 
				end if 
				
				linha = linha & "</b> - " & rs("descricao") & "</li>"
			else
				linha = linha & " " & rs("descricao") & "</li>"
			end if
			response.write linha
            intContCadastro = intContCadastro + 1
            rs.movenext
        wend
        
    end if
    rs.close    
    if intContCadastro = 0 and intContCadastroExterno = 0 then
        response.write "<li class='list-group-item'>Nenhum item cadastrado</li>"
    end if
    response.write "</ul>"
end function

function carregaPlanejamento(codPlanejamento)

        sql="select * from [SCA_TIPO_PLANEJAMENTO]"
        if apenasConteudo = "S" then
            sql=sql & " where cod_tipo_planejamento_anual in (2)"
        else
            sql=sql & " where cod_tipo_planejamento_anual in (1,2,3,4)"
        end if
		
        rsAux.open sql,cnn
        vetItemPlanejamento = rsAux.getRows
        rsAux.close

        for i=0 to ubound(vetItemPlanejamento,2)

                    if vetItemPlanejamento(0,i)=1 then 
                        strNomeAcao="novoItemHabilidade"
                    else 
                        strNomeAcao="novoItemConteudo"
                    end if

                    strTituloItem = vetItemPlanejamento(1,i)
                    strCodigoDiv = codPlanejamento & "-" & vetItemPlanejamento(0,i)
                    %>

                    <div class="accordion accordion-outline" id="divItemPlanejamento-<%=strCodigoDiv%>">
                        <div class="card">
                            <div class="card-header">
                                <input type="hidden" id="txtControleAbertura-<%=strCodigoDiv%>" value="N">
                                <a href="javascript:void(0);" class="card-title collapsed" data-toggle="collapse" id="card-<%=strCodigoDiv%>" data-target="#divItemPlanejamento-<%=strCodigoDiv%>a" aria-expanded="false" onclick="controleAbertura(<%=codPlanejamento%>,<%=vetItemPlanejamento(0,i)%>);carregaItensTipo(<%=codPlanejamento%>,<%=vetItemPlanejamento(0,i)%>)">
                                    <i class="fal fa-chalkboard-teacher width-2 fs-xl"></i>
                                    <%=vetItemPlanejamento(1,i)%>
                                    <span class="ml-auto">
                                        <span class="collapsed-reveal">
                                            <i class="fal fa-minus fs-xl"></i>
                                        </span>
                                        <span class="collapsed-hidden">
                                            <i class="fal fa-plus fs-xl"></i>
                                        </span>
                                    </span>
                                </a>
                            </div>

                            <div id="divItemPlanejamento-<%=strCodigoDiv%>a" class="collapse" data-parent="#divItemPlanejamento-<%=strCodigoDiv%>" style="">
                                <div class="card-body">

                                    <div id="div-<%=strCodigoDiv%>" class="card border  m-auto m-lg-0" style="width: 100%;">
                                    </div>		
                                    
                                </div>
                            </div>
                        </div>
                        
                    </div>							

                    <%
        next                  
        %>
<%
end function

function incluiPlanejamentoProfessor()

    sql="SET NoCount ON insert SCA_PLANEJAMENTO_PROFESSOR("
    sql=sql & " cod_planejamento_geral,"
    sql=sql & " cod_empresa,"
    sql=sql & " anoLetivo,"
    sql=sql & " semestre,"
    if not bolAulaExtra then
        sql=sql & " numero_aula,"
    else
        sql=sql & " data_aula_extra,"
    end if
    sql=sql & " cod_periodo,"
    sql=sql & " cod_disciplina,"
    sql=sql & " cod_turno,"
    sql=sql & " cod_turma,"
    sql=sql & " cod_colaborador,"
    sql=sql & " cod_colaborador_ultima_interacao,"
    sql=sql & " desc_metodologia,"
    sql=sql & " desc_avaliacao,"
    sql=sql & " observacao,"
    sql=sql & " validado,"
    sql=sql & " usuario_validado,"
    sql=sql & " data_hora_validado,"
    sql=sql & " usuario_incl,"
    sql=sql & " data_hora_incl,"
    sql=sql & " usuario_altr,"
    sql=sql & " data_hora_altr)"
    sql=sql & " values ("
    sql=sql & codPlanejamentoGeral & ","
    sql=sql & session("codEmpresa") & ","
    sql=sql & anoLetivo & ","
    sql=sql & semestre & ","
    if not bolAulaExtra then
        sql=sql & numeroAula & ","
    else
        sql=sql & "'" & formataDataBD(numeroAula) & "',"
    end if
    sql=sql & codPeriodo & ","
    sql=sql & codDisciplina & ","
    sql=sql & codTurno & ","
    sql=sql & codTurma & ","
    sql=sql & codProfessor & ","
    sql=sql & codProfessor & "," 'Na inclusão os códigos cod_colaborador e cod_colaborador_ultima_interacao são iguais
    sql=sql & "null,null,null,'N',null,null,"
    sql=sql & "'" & strUsuario_incl & "',"
    sql=sql & "'" & strData_hora_incl & "',"
    sql=sql & "'" & strUsuario_altr & "',"
    sql=sql & "'" & strData_hora_altr & "')" 
	sql=sql & ";SELECT @@IDENTITY "		
	Set rs = cnn.Execute(sql)
	newID = rs(0)
	rs.close
	'GravarLog sql

    incluiPlanejamentoProfessor = newID

end function

function itemPlanejamentoJaCadastrado(codPlanejamentoProfessor, codItemPlanejamentoGeral, codTipo)

    itemPlanejamentoJaCadastrado = false

    sql = "SELECT COUNT(*) AS total "
    sql = sql & " FROM SCA_ITEM_PLANEJAMENTO_PROFESSOR "
    sql = sql & " WHERE cod_planejamento_professor = " & codPlanejamentoProfessor
    sql = sql & " AND cod_item_planejamento_geral = " & codItemPlanejamentoGeral
    sql = sql & " AND cod_tipo_planejamento = " & codTipo

    rsAux.open sql, cnn

    if rsAux("total") > 0 then
        itemPlanejamentoJaCadastrado = true
    end if

    rsAux.close

end function

function incluiItemPlanejamento() 

    sql="SET NoCount ON insert into SCA_ITEM_PLANEJAMENTO_PROFESSOR ("
    sql=sql & " cod_planejamento_professor,"
    sql=sql & " cod_item_planejamento_geral,"
    sql=sql & " cod_tipo_planejamento,"
    sql=sql & " descricao,"
    sql=sql & " usuario_incl,"
    sql=sql & " data_hora_incl,"
    sql=sql & " usuario_altr,"
    sql=sql & " data_hora_altr) values ("
    sql=sql & codPlanejamentoProfessor & ","
    sql=sql & codItemPlanejamentoGeral & ","
    sql=sql & codTipo & ","
    sql=sql & "'" & descricao & "'," 
    sql=sql & "'" & strUsuario_incl & "',"
    sql=sql & "'" & strData_hora_incl & "',"
    sql=sql & "'" & strUsuario_altr & "',"
    sql=sql & "'" & strData_hora_altr & "')" 
	sql=sql & ";SELECT @@IDENTITY "
	Set rs = cnn.Execute(sql)
	newID = rs(0)
	rs.close
	'GravarLog sql

    incluiItemPlanejamento = newID    

end function

function alteraMetodologiaAvaliacao(codTipo)

    sql="update SCA_PLANEJAMENTO_PROFESSOR set"
    if codTipo = 3 then
        sql=sql & " desc_metodologia='" & descricao & "',"
    else
        sql=sql & " desc_avaliacao='" & descricao & "',"
    end if
    sql=sql & " cod_colaborador_ultima_interacao=" & codProfessor
    sql=sql & " where cod_planejamento_professor=" & codPlanejamentoProfessor
    cnn.execute sql
	'GravarLog sql
end function

function alteraRegistroReflexivo(codTipo)

    sql="update SCA_PLANEJAMENTO_PROFESSOR set"
    sql=sql & " desc_RegistroReflexivo='" & descricao & "',"
    sql=sql & " cod_colaborador_ultima_interacao=" & codProfessor
    sql=sql & " where cod_planejamento_professor=" & codPlanejamentoProfessor
    cnn.execute sql
	'GravarLog sql
end function

function carregaPlanejamentoProfessor(codTipo)
    if codTipo=1 or codTipo = 2 then
        response.write "<ul class='list-group list-group-flush' id='ul-" & codTipo & "'>" 
        sql="select i.cod_item_planejamento_professor, i.descricao, i.complemento, p.validado"
        sql=sql & " from SCA_ITEM_PLANEJAMENTO_PROFESSOR i " 
		sql=sql & " inner join SCA_PLANEJAMENTO_PROFESSOR p on p.cod_planejamento_professor = i.cod_planejamento_professor"
        sql=sql & " where i.cod_planejamento_professor =" & codPlanejamentoProfessor
        sql=sql & " and i.cod_tipo_planejamento =" & codTipo
        if ucase(session("usuarioWeb"))="SERGIO" then
			'response.write sql & "<hr>"
			'response.end
		end if
        rs.open sql, cnn
        if rs.eof = false then
            while not rs.eof
				bloq = ""
				if rs("validado") = "S" then
					bloq = " disabled='disabled' "
				else
					btnExclusao = "<a onclick='removeItemPlanejamentoProfessor(" & rs("cod_item_planejamento_professor") & "," & codTipo & ")' class='btn btn-outline-danger btn-xs btn-icon rounded-circle waves-effect waves-themed'><i class='fal fa-times'></i></a>"
				end if
                strComplemento = ""
                'if codTipo = 2 and paginaOrigem <> "cm" then
                    'Não mostra o complemento para o Conteúdo ministrado
                    strComplemento = "<br><textarea " & bloq & " id='txtItem-"  & rs("cod_item_planejamento_professor") & "' class='textArea' onKeyUp=mostraBotaoSalvarConteudo(" & rs("cod_item_planejamento_professor") & ")>" & rs("complemento") & "</textArea><br>"
                    strComplemento = strComplemento & "<button " & bloq & " style='display:none' id='btnItem-" & rs("cod_item_planejamento_professor") & "' type='button' class='btn btn-success btn-pills btn-sm btn-block waves-effect waves-themed salvar' onClick='salvaComplemento(" & rs("cod_item_planejamento_professor") & ")'>Salvar alterações</button>"
                'end if
                strOnClick = ""
                if paginaOrigem = "cm" then
                    if strPeriodoValido = "S" then
                        strOnClick = "onClick = 'executaConteudo(" &  rs("cod_item_planejamento_professor") & ","""")'"
                    end if
                end if
                response.write "<li " & strOnClick & " class='list-group-item item' id='li-" & codTipo & "-" & rs("cod_item_planejamento_professor") & "'>" & btnExclusao & " " & rs("descricao") & strComplemento & "</li>"
                rs.movenext
            wend
        else
            response.write "<li class='list-group-item'>Nenhum item incluído</li>"
        end if
        rs.close
        response.write "</ul>"
    else

        sql="select "

        if codTipo = 3 then
            sql=sql & " desc_metodologia"
        elseif codTipo = 4 then
            sql=sql & " desc_avaliacao"
        elseif codTipo = 5 then
            sql=sql & " desc_RegistroReflexivo"
        end if
        sql=sql & " from SCA_PLANEJAMENTO_PROFESSOR"
        sql=sql & " where cod_planejamento_professor=" & codPlanejamentoProfessor
		
        rs.open sql, cnn
        if rs.eof= false then
            response.write rs(0)
        end if
        rs.close
    end if
end function

function removeItemPlanejamentoProfessor()

    'exclui os conteúdos ministrados
    sql="delete from SCA_CONTEUDO_MINISTRADO_PROFESSOR where cod_item_planejamento_professor=" & codItemPlanejamentoProfessor
    cnn.execute sql                        
	'GravarLog sql
	
    sql="delete from SCA_ITEM_PLANEJAMENTO_PROFESSOR where cod_item_planejamento_professor=" & codItemPlanejamentoProfessor
	'response.write sql
	
    cnn.execute sql
	'GravarLog sql
end function

function salvaComplemento()

    sql="update SCA_item_PLANEJAMENTO_PROFESSOR set"
    sql=sql & " complemento='" & descricao & "'"
    sql=sql & " where cod_item_planejamento_professor=" & codItemPlanejamentoProfessor
    cnn.execute sql
	'GravarLog sql
end function

function validarPlanejamentoProfessor()

    sql="update SCA_PLANEJAMENTO_PROFESSOR set "
    if trim(strObservacao) = "" then
        sql = sql & " observacao=null, "
    else
        sql = sql & " observacao='" & strObservacao & "', "
    end if
    sql = sql & " validado='" & strValidado & "',"
    sql = sql & " usuario_validado = '" & strUsuario_incl & "',"
    sql = sql & " data_hora_validado = getdate()"
    sql = sql & " where cod_planejamento_professor = " & codPlanejamentoProfessor
    cnn.execute sql
	'GravarLog sql
end function

function salvarObservacaoSecretaria()

    sql="update SCA_PLANEJAMENTO_PROFESSOR set "
    if trim(strObservacaoSecretaria) = "" then
        sql = sql & " observacao_secretaria=null, "
    else
        sql = sql & " observacao_secretaria='" & strObservacaoSecretaria & "', "
    end if
    sql = sql & " usuario_observacao_secretaria = '" & strUsuario_incl & "',"
    sql = sql & " data_hora_observacao_secretaria = getdate()"
    sql = sql & " where cod_planejamento_professor = " & codPlanejamentoProfessor
    cnn.execute sql
	'GravarLog sql
end function

function cancelarValidacaoPlanejamentoProfessor()

    sql="update SCA_PLANEJAMENTO_PROFESSOR set "
    sql = sql & " observacao=null, "
    sql = sql & " validado='N',"
    sql = sql & " usuario_validado = null,"
    sql = sql & " data_hora_validado = null"
    sql = sql & " where cod_planejamento_professor = " & codPlanejamentoProfessor
	'response.write sql
    cnn.execute sql
	'GravarLog sql
end function


function recursoTextoSeguro(valor)
    if isnull(valor) then
        recursoTextoSeguro = ""
    else
        recursoTextoSeguro = Server.HTMLEncode(CStr(valor))
    end if
end function

function urlHttpValida(valor)
    dim v
    v = lcase(trim(valor & ""))
    urlHttpValida = (left(v,7) = "http://" or left(v,8) = "https://")
end function

function garantePlanejamentoProfessorRecurso()
    if codPlanejamentoProfessor = "" or codPlanejamentoProfessor = "0" then
        codPlanejamentoProfessor = incluiPlanejamentoProfessor()
    end if
    garantePlanejamentoProfessorRecurso = codPlanejamentoProfessor
end function

function planejamentoRecursoBloqueado()
    dim rsBloq, sqlBloq
    planejamentoRecursoBloqueado = false

    if codPlanejamentoProfessor = "" or codPlanejamentoProfessor = "0" or not isnumeric(codPlanejamentoProfessor) then exit function

    sqlBloq = "SELECT validado FROM SCA_PLANEJAMENTO_PROFESSOR WHERE cod_planejamento_professor=" & CLng(codPlanejamentoProfessor) & _
              " AND cod_empresa=" & CLng(session("codEmpresa"))
    set rsBloq = cnn.Execute(sqlBloq)
    if not rsBloq.eof then
        if ucase(trim(rsBloq("validado") & "")) = "S" then planejamentoRecursoBloqueado = true
    end if
    rsBloq.close
    set rsBloq = nothing
end function

function incluirArquivoPlanejamento()
    dim cmdRecurso, rsRecurso, tamanhoBase64

    if nomeArquivo = "" or arquivoBase64 = "" then
        incluirArquivoPlanejamento = 0
        exit function
    end if

    if not isnumeric(tamanhoArquivo) then tamanhoArquivo = 0
    if clng(tamanhoArquivo) > (10 * 1024 * 1024) then
        incluirArquivoPlanejamento = -2
        exit function
    end if

    if len(tipoArquivo) > 100 then tipoArquivo = left(tipoArquivo,100)
    if len(nomeArquivo) > 255 then nomeArquivo = left(nomeArquivo,255)
    if len(descricaoRecurso) > 500 then descricaoRecurso = left(descricaoRecurso,500)

    tamanhoBase64 = len(arquivoBase64)

    set cmdRecurso = Server.CreateObject("ADODB.Command")
    set cmdRecurso.ActiveConnection = cnn
    cmdRecurso.CommandType = 1
    cmdRecurso.CommandText = "SET NOCOUNT ON; INSERT INTO SCA_PLANEJAMENTO_PROFESSOR_RECURSO " & _
        "(cod_planejamento_professor,tipo,descricao,nome_arquivo,tipo_arquivo,tamanho_arquivo,arquivo_base64,url,usuario_incl,data_hora_incl) " & _
        "VALUES (?,?,?,?,?,?,?,NULL,?,GETDATE()); SELECT CAST(SCOPE_IDENTITY() AS INT) AS codigo;"

    cmdRecurso.Parameters.Append cmdRecurso.CreateParameter("@cod_planejamento_professor", 3, 1, , CLng(codPlanejamentoProfessor))
    cmdRecurso.Parameters.Append cmdRecurso.CreateParameter("@tipo", 200, 1, 1, "A")
    cmdRecurso.Parameters.Append cmdRecurso.CreateParameter("@descricao", 200, 1, 500, descricaoRecurso)
    cmdRecurso.Parameters.Append cmdRecurso.CreateParameter("@nome_arquivo", 200, 1, 255, nomeArquivo)
    cmdRecurso.Parameters.Append cmdRecurso.CreateParameter("@tipo_arquivo", 200, 1, 100, tipoArquivo)
    cmdRecurso.Parameters.Append cmdRecurso.CreateParameter("@tamanho_arquivo", 3, 1, , CLng(tamanhoArquivo))
    cmdRecurso.Parameters.Append cmdRecurso.CreateParameter("@arquivo_base64", 201, 1, tamanhoBase64, arquivoBase64)
    cmdRecurso.Parameters.Append cmdRecurso.CreateParameter("@usuario_incl", 200, 1, 100, strUsuario_incl)

    set rsRecurso = cmdRecurso.Execute
    incluirArquivoPlanejamento = rsRecurso("codigo")
    rsRecurso.close
    set rsRecurso = nothing
    set cmdRecurso = nothing
end function

function incluirLinkPlanejamento()
    dim cmdRecurso, rsRecurso

    if urlRecurso = "" or not urlHttpValida(urlRecurso) then
        incluirLinkPlanejamento = 0
        exit function
    end if

    if len(urlRecurso) > 2000 then
        incluirLinkPlanejamento = -2
        exit function
    end if
    if len(descricaoRecurso) > 500 then descricaoRecurso = left(descricaoRecurso,500)

    set cmdRecurso = Server.CreateObject("ADODB.Command")
    set cmdRecurso.ActiveConnection = cnn
    cmdRecurso.CommandType = 1
    cmdRecurso.CommandText = "SET NOCOUNT ON; INSERT INTO SCA_PLANEJAMENTO_PROFESSOR_RECURSO " & _
        "(cod_planejamento_professor,tipo,descricao,nome_arquivo,tipo_arquivo,tamanho_arquivo,arquivo_base64,url,usuario_incl,data_hora_incl) " & _
        "VALUES (?,'L',?,NULL,NULL,NULL,NULL,?,?,GETDATE()); SELECT CAST(SCOPE_IDENTITY() AS INT) AS codigo;"

    cmdRecurso.Parameters.Append cmdRecurso.CreateParameter("@cod_planejamento_professor", 3, 1, , CLng(codPlanejamentoProfessor))
    cmdRecurso.Parameters.Append cmdRecurso.CreateParameter("@descricao", 200, 1, 500, descricaoRecurso)
    cmdRecurso.Parameters.Append cmdRecurso.CreateParameter("@url", 200, 1, 2000, urlRecurso)
    cmdRecurso.Parameters.Append cmdRecurso.CreateParameter("@usuario_incl", 200, 1, 100, strUsuario_incl)

    set rsRecurso = cmdRecurso.Execute
    incluirLinkPlanejamento = rsRecurso("codigo")
    rsRecurso.close
    set rsRecurso = nothing
    set cmdRecurso = nothing
end function

sub listarRecursosPlanejamento()
    dim rsRecurso, sqlRecurso, descExibicao, nomeExibicao, urlExibicao, btnExcluir, temRegistro

    if codPlanejamentoProfessor = "" or codPlanejamentoProfessor = "0" or not isnumeric(codPlanejamentoProfessor) then
        response.write "<div class='text-muted'>Nenhum material de apoio incluído.</div>"
        exit sub
    end if

    sqlRecurso = "SELECT r.codigo,r.tipo,r.descricao,r.nome_arquivo,r.tipo_arquivo,r.tamanho_arquivo,r.url,r.data_hora_incl " & _
                 "FROM SCA_PLANEJAMENTO_PROFESSOR_RECURSO r " & _
                 "INNER JOIN SCA_PLANEJAMENTO_PROFESSOR p ON p.cod_planejamento_professor=r.cod_planejamento_professor " & _
                 "WHERE r.cod_planejamento_professor=" & CLng(codPlanejamentoProfessor) & _
                 " AND p.cod_empresa=" & CLng(session("codEmpresa")) & " ORDER BY r.data_hora_incl,r.codigo"

    set rsRecurso = Server.CreateObject("ADODB.Recordset")
    rsRecurso.open sqlRecurso, cnn
    temRegistro = false

    if not rsRecurso.eof then
        response.write "<div class='list-group'>"
        do while not rsRecurso.eof
            temRegistro = true
            descExibicao = recursoTextoSeguro(rsRecurso("descricao"))
            btnExcluir = ""
            if ucase(strEdicaoRecurso) <> "S" then
                btnExcluir = " <button type='button' class='btn btn-outline-danger btn-xs ml-2' title='Excluir' onclick='excluirRecursoPlanejamento(" & rsRecurso("codigo") & ");'><i class='fal fa-trash'></i></button>"
            end if

            if rsRecurso("tipo") = "A" then
                nomeExibicao = recursoTextoSeguro(rsRecurso("nome_arquivo"))
                response.write "<div class='list-group-item d-flex justify-content-between align-items-center'>"
                response.write "<div><i class='fal fa-file mr-2'></i><strong>" & nomeExibicao & "</strong>"
                if descExibicao <> "" then response.write "<div class='text-muted small mt-1'>" & descExibicao & "</div>"
                response.write "</div><div class='text-nowrap'>"
                response.write "<a class='btn btn-outline-primary btn-xs' target='_blank' href='sca_planejamento_professor_recurso_visualizar.asp?codigo=" & rsRecurso("codigo") & "'><i class='fal fa-eye mr-1'></i> Abrir</a>"
                response.write btnExcluir & "</div></div>"
            else
                urlExibicao = recursoTextoSeguro(rsRecurso("url"))
                response.write "<div class='list-group-item d-flex justify-content-between align-items-center'>"
                response.write "<div><i class='fal fa-link mr-2'></i>"
                if descExibicao <> "" then
                    response.write "<strong>" & descExibicao & "</strong><div class='text-muted small text-truncate' style='max-width:550px'>" & urlExibicao & "</div>"
                else
                    response.write "<span class='text-muted'>" & urlExibicao & "</span>"
                end if
                response.write "</div><div class='text-nowrap'>"
                response.write "<a class='btn btn-outline-primary btn-xs' target='_blank' rel='noopener noreferrer' href='" & urlExibicao & "'><i class='fal fa-external-link mr-1'></i> Abrir</a>"
                response.write btnExcluir & "</div></div>"
            end if

            rsRecurso.movenext
        loop
        response.write "</div>"
    end if

    if not temRegistro then
        response.write "<div class='text-muted'>Nenhum material de apoio incluído.</div>"
    end if

    rsRecurso.close
    set rsRecurso = nothing
end sub

sub excluirRecursoPlanejamento()
    if codigoRecurso = "" or not isnumeric(codigoRecurso) then
        response.write "ERRO|Recurso inválido."
        exit sub
    end if
    if codPlanejamentoProfessor = "" or not isnumeric(codPlanejamentoProfessor) then
        response.write "ERRO|Planejamento inválido."
        exit sub
    end if

    if planejamentoRecursoBloqueado() then
        response.write "ERRO|Este planejamento está bloqueado para edição."
        exit sub
    end if

    sql = "DELETE r FROM SCA_PLANEJAMENTO_PROFESSOR_RECURSO r " & _
          "INNER JOIN SCA_PLANEJAMENTO_PROFESSOR p ON p.cod_planejamento_professor=r.cod_planejamento_professor " & _
          "WHERE r.codigo=" & CLng(codigoRecurso) & _
          " AND r.cod_planejamento_professor=" & CLng(codPlanejamentoProfessor) & _
          " AND p.cod_empresa=" & CLng(session("codEmpresa"))
    cnn.execute sql
    'GravarLog sql
    response.write "OK"
end sub

function excluirPlanejamentoProfessor()

    sql="delete from SCA_PLANEJAMENTO_PROFESSOR_RECURSO where cod_planejamento_professor=" & codPlanejamentoProfessor
    cnn.execute sql
    'GravarLog sql

    sql="delete from SCA_ITEM_PLANEJAMENTO_PROFESSOR where cod_planejamento_professor=" & codPlanejamentoProfessor
    cnn.execute sql
	GravarLog sql
    sql="delete SCA_CONTEUDO_MINISTRADO_PROFESSOR "
    sql = sql & " where cod_planejamento_professor = " & codPlanejamentoProfessor
    cnn.execute sql
	'GravarLog sql	
	sql="delete SCA_PLANEJAMENTO_PROFESSOR "
    sql = sql & " where cod_planejamento_professor = " & codPlanejamentoProfessor
    cnn.execute sql
	'GravarLog sql
end function


if acao = "carregaPlanejamento" then

    carregaPlanejamento codPlanejamento

elseif acao = "carregaItensTipo" then

    carregaItensTipo codItemPai, codTipo, codBimestre

elseif acao = "incluiItemPlanejamento" then
    
    cnn.beginTrans

    if codPlanejamentoProfessor = "" or codPlanejamentoProfessor = "0" then
        codPlanejamentoProfessor = incluiPlanejamentoProfessor()
    end if

    '=========================================================
    ' VALIDAÇÃO DE ITEM DUPLICADO
    ' Tipo 1 = Habilidade
    ' Tipo 2 = Objeto de conhecimento / Conteúdo
    '=========================================================
    if codTipo = "1" or codTipo = "2" then

        if itemPlanejamentoJaCadastrado(codPlanejamentoProfessor, codItemPlanejamentoGeral, codTipo) then

            cnn.RollbackTrans

            if codTipo = "1" then
                response.write "DUPLICADO|HABILIDADE"
            else
                response.write "DUPLICADO|CONTEUDO"
            end if

            response.end

        end if

    end if


    select case codTipo

        case 1, 2

            novoCodigoItem = incluiItemPlanejamento()

        case 3, 4

            alteraMetodologiaAvaliacao codTipo
            novoCodigoItem = "0"
		case 5

            alteraRegistroReflexivo codTipo
            novoCodigoItem = "0"

    end select


    if err.number <> 0 then

        cnn.RollbackTrans
        response.write "ERRO|" & err.description

    else

        cnn.CommitTrans
        response.write codPlanejamentoProfessor & "," & novoCodigoItem

    end if
    

elseif acao = "carregaPlanejamentoProfessor" then

    carregaPlanejamentoProfessor codTipo

elseif acao = "removeItemPlanejamentoProfessor" then

    cnn.beginTrans

    removeItemPlanejamentoProfessor

    if err.number <> 0 then
        cnn.RollbackTrans  
    else
        cnn.CommitTrans 
    end if

elseif acao = "salvaComplemento" then
    cnn.beginTrans

    salvaComplemento

    if err.number <> 0 then
        cnn.RollbackTrans  
    else
        cnn.CommitTrans 
    end if    

elseif acao = "ValidarPlanejamentoProfessor" then

    cnn.beginTrans

    validarPlanejamentoProfessor

    if err.number <> 0 then
        cnn.RollbackTrans  
    else
        cnn.CommitTrans 
    end if    

elseif acao = "salvarObservacaoSecretaria" then

    cnn.beginTrans

    salvarObservacaoSecretaria

    if err.number <> 0 then
        cnn.RollbackTrans  
    else
        cnn.CommitTrans 
    end if    
	
elseif acao = "CancelarValidacaoPlanejamentoProfessor" then

    cnn.beginTrans

    cancelarValidacaoPlanejamentoProfessor	

    if err.number <> 0 then
        cnn.RollbackTrans  
    else
        cnn.CommitTrans 
    end if         
	
elseif acao = "incluirArquivoPlanejamento" then

    if strPeriodoValido <> "S" then
        response.write "ERRO|Período não autorizado para edição."
    elseif planejamentoRecursoBloqueado() then
        response.write "ERRO|Este planejamento está bloqueado para edição."
    elseif nomeArquivo = "" or arquivoBase64 = "" then
        response.write "ERRO|Arquivo não informado."
    else
        cnn.beginTrans
        codPlanejamentoProfessor = garantePlanejamentoProfessorRecurso()
        codigoNovoRecurso = incluirArquivoPlanejamento()

        if err.number <> 0 or codigoNovoRecurso <= 0 then
            cnn.RollbackTrans
            if codigoNovoRecurso = -2 then
                response.write "ERRO|O arquivo deve possuir no máximo 10 MB."
            else
                response.write "ERRO|Não foi possível gravar o arquivo."
            end if
        else
            cnn.CommitTrans
            response.write "OK|" & codPlanejamentoProfessor & "|" & codigoNovoRecurso
        end if
    end if

elseif acao = "incluirLinkPlanejamento" then

    if strPeriodoValido <> "S" then
        response.write "ERRO|Período não autorizado para edição."
    elseif planejamentoRecursoBloqueado() then
        response.write "ERRO|Este planejamento está bloqueado para edição."
    elseif not urlHttpValida(urlRecurso) then
        response.write "ERRO|Informe um link iniciado por http:// ou https://."
    else
        cnn.beginTrans
        codPlanejamentoProfessor = garantePlanejamentoProfessorRecurso()
        codigoNovoRecurso = incluirLinkPlanejamento()

        if err.number <> 0 or codigoNovoRecurso <= 0 then
            cnn.RollbackTrans
            if codigoNovoRecurso = -2 then
                response.write "ERRO|O link excede o tamanho máximo permitido."
            else
                response.write "ERRO|Não foi possível gravar o link."
            end if
        else
            cnn.CommitTrans
            response.write "OK|" & codPlanejamentoProfessor & "|" & codigoNovoRecurso
        end if
    end if

elseif acao = "listarRecursosPlanejamento" then

    listarRecursosPlanejamento

elseif acao = "excluirRecursoPlanejamento" then

    excluirRecursoPlanejamento

elseif acao = "ExcluirPlanejamentoProfessor" then
    
    cnn.beginTrans

    excluirPlanejamentoProfessor  
    
    if err.number <> 0 then
        cnn.RollbackTrans  
    else
        cnn.CommitTrans 
    end if 

end if


%>                    