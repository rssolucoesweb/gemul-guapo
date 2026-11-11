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
	
    anoLetivo = Trim(Request("anoLetivo"))	
    semestre = Trim(Request("semestre"))	
    cod_periodo = Trim(Request("codPeriodo"))	
    cod_disciplina = Trim(Request("codDisciplina"))	

	codigoPlanejamento	        = Trim(Request("codigoPlanejamento"))	
	codigoPlanejamentoEscola	= Trim(Request("codigoPlanejamentoEscola"))	

	codigoItemPai	= Trim(Request("codigoItemPai"))	
	codigoItem	= Trim(Request("codigoItem"))	
    codigoTipo  = Trim(Request("codigoTipo"))	
	descricao	= Trim(Request("descricao"))
    codBimestre    = Trim(Request("codBimestre"))
	acao			= Trim(Request("acao"))
    strPagina = Trim(Request("strPagina"))    

	' Dados do Usuario
	strUsuario_incl   	= session("usuarioWeb")
	strData_hora_incl 	= formataDataBDAccess(date) & " " & time
	strUsuario_altr   	= session("usuarioWeb")
	strData_hora_altr 	= formataDataBDAccess(date) & " " & time

FUNCTION excluiItem (codigoItem)

    sql="delete from SCA_ITEM_PLANEJAMENTO_GERAL where cod_item_planejamento_geral=" & codigoItem
    cnn.execute sql

end function

FUNCTION liberaPlanejamento (codigoPlanejamento)

    sql="update SCA_PLANEJAMENTO_GERAL"
    sql=sql & " set cod_situacao_planejamento = 3" 'Liberado
    sql=sql & " where cod_planejamento_geral=" & codigoPlanejamento
    cnn.execute sql

end function

FUNCTION enviarAutorizacaoPlanejamentoEscola (codigoPlanejamento, codigoPlanejamentoEscola)
	
	if codigoPlanejamentoEscola = "0" then
		codigoPlanejamentoEscola = inserePlanejamentoGeral(2,codigoPlanejamento)
	end if 
	
    sql="update SCA_PLANEJAMENTO_GERAL"
    sql=sql & " set cod_situacao_planejamento = 7" 'enviar para autorizacao
    sql=sql & " where cod_planejamento_geral=" & codigoPlanejamentoEscola
	
	'response.write sql
	'response.end
    cnn.execute sql

end function

FUNCTION liberaPlanejamentoEscola (codigoPlanejamentoEscola)
	
    sql="update SCA_PLANEJAMENTO_GERAL"
    sql=sql & " set cod_situacao_planejamento = 3" 'Liberado
    sql=sql & " where cod_planejamento_geral=" & codigoPlanejamentoEscola
    cnn.execute sql

end function

function excluiItemPlanejamento (codigoItem, codigoPlanejamento)

    sql="delete from SCA_ITEM_PLANEJAMENTO_GERAL"
    sql=sql & " where cod_item_planejamento_geral_pai in ("
    sql=sql & " 	select cod_item_planejamento_geral from SCA_ITEM_PLANEJAMENTO_GERAL"
    sql=sql & " 	where cod_item_planejamento_geral_pai =" & codigoItem
    sql=sql & " )"
    cnn.execute sql

    sql="delete from SCA_ITEM_PLANEJAMENTO_GERAL"
    sql=sql & " where cod_item_planejamento_geral in ("
    sql=sql & " 	select cod_item_planejamento_geral from SCA_ITEM_PLANEJAMENTO_GERAL"
    sql=sql & " 	where cod_item_planejamento_geral_pai =" & codigoItem 
    sql=sql & ")"
    cnn.execute sql

    sql="delete from SCA_ITEM_PLANEJAMENTO_GERAL"
    sql=sql & " where cod_item_planejamento_geral =" & codigoItem
    cnn.execute sql

    qtdRegistros = 0
    sql="select count(*) from SCA_ITEM_PLANEJAMENTO_GERAL where cod_planejamento_geral =" & codigoPlanejamento
    rs.open sql, cnn
    if rs.eof = false then
        qtdRegistros = rs(0)
    end if
    rs.close

    if qtdRegistros = 0 then
        sql="delete from SCA_PLANEJAMENTO_GERAL"
        sql=sql & " where cod_planejamento_geral =" & codigoPlanejamento
        cnn.execute sql    
    end if

    excluiItemPlanejamento = qtdRegistros

end function

FUNCTION consultaCodigoPlanejamentoGeral ()

    sql="select cod_planejamento_geral from SCA_PLANEJAMENTO_GERAL"
    sql=sql & " where anoLetivo = " & anoLetivo
    sql=sql & " and semestre = " & semestre
    sql=sql & " and cod_periodo = "  & cod_periodo
    sql=sql & " and cod_disciplina = " & cod_disciplina
    sql=sql & " and cod_situacao_planejamento = 3"
	'response.write sql
	
	rs.open sql, cnn
    if rs.eof = false then
        cod_planejamento_geral = rs("cod_planejamento_geral")
    end if
    rs.close
    
    consultaCodigoPlanejamentoGeral = cod_planejamento_geral

END FUNCTION

FUNCTION inserePlanejamentoGeral (origem, codigoPai)

    sql="insert into [SCA_PLANEJAMENTO_GERAL] ("
    sql=sql & " anoLetivo,"
    sql=sql & " semestre,"
    sql=sql & " cod_periodo,"
    sql=sql & " cod_disciplina,"
    sql=sql & " cod_situacao_planejamento,"
    sql=sql & " cod_planejamento_geral_pai,"
    sql=sql & " cod_empresa,"
    sql=sql & " usuario_incl,"
    sql=sql & " data_hora_incl,"
    sql=sql & " usuario_altr,"
    sql=sql & " data_hora_altr)"
    sql=sql & " Values("
    sql=sql & anoLetivo & ","
    sql=sql & semestre & ","
    sql=sql & cod_periodo & ","
    sql=sql & cod_disciplina & ","
    if origem = 2 then
		sql=sql & "3,"
        sql=sql & codigoPai & ","
        sql=sql & session("codEmpresa") & ","
    else
		sql=sql & "2,"
        sql=sql & "null,"
        sql=sql & "null,"
    end if
    sql=sql & "'" & strUsuario_incl & "',"
    sql=sql & "'" & strData_hora_incl & "',"
    sql=sql & "'" & strUsuario_altr & "',"
    sql=sql & "'" & strData_hora_altr & "')"
    cnn.execute sql

    'response.write sql & "<br><br>"

    sql="SELECT @@IDENTITY AS NewID"
    rs.open sql, cnn
    if rs.eof = false then
        newID = rs("NewID")
    end if
    rs.close
    
    inserePlanejamentoGeral = newID

END FUNCTION


FUNCTION insereItemPlanejamentoGeral (codigoPanejamentoGeral, codigoItemPai, bimestre, descricao, cod_tipo_planejamento )

    sql="insert into [SCA_ITEM_PLANEJAMENTO_GERAL] ("
    sql=sql & " cod_planejamento_geral,"
    sql=sql & " descricao,"
    sql=sql & " cod_tipo_planejamento,"
    sql=sql & " cod_bimestre,"
    sql=sql & " cod_item_planejamento_geral_pai,"
    sql=sql & " cod_empresa,"
    sql=sql & " usuario_incl,"
    sql=sql & " data_hora_incl,"
    sql=sql & " usuario_altr,"
    sql=sql & " data_hora_altr"	
    sql=sql & " ) values("
    sql=sql & codigoPanejamentoGeral & ","
    if descricao <> "" then
        sql=sql & "'" & descricao & "',"
    else
        sql=sql & "NULL,"
    end if
    if cod_tipo_planejamento <>"" then 
        sql=sql & cod_tipo_planejamento & ","
    else
        sql=sql & "NULL,"
    end if

    if bimestre <> 0 then
        sql=sql & bimestre & ","
    else
        sql=sql & "Null,"
    end if
    if codigoItemPai <> "" then
        sql=sql & codigoItemPai & ","
    else
        sql=sql & "NULL,"
    end if

    if SESSION("controleAcessoPlanejamentoAnual") = "2" then
        sql=sql & session("codEmpresa") & ","
    else
        sql=sql & "NULL,"
    end if

    sql=sql & "'" & strUsuario_incl & "',"
    sql=sql & "'" & strData_hora_incl & "',"
    sql=sql & "'" & strUsuario_altr & "',"
	sql=sql & "'" & strData_hora_altr & "')"
    'response.write sql
    cnn.execute sql

    sql="SELECT @@IDENTITY AS NewID"
    rs.open sql, cnn
    if rs.eof = false then
        newID = rs("NewID")
    end if
    rs.close    

    insereItemPlanejamentoGeral = newID

END FUNCTION

function carregaItensTipo(codigoItemPai, codigoTipo) 
    dim intContCadastroExterno, intContCadastro
    intContCadastroExterno = 0
    intContCadastro = 0
    response.write "<ul class='list-group list-group-flush'>"

    if codigoTipo = 3 or codigoTipo = 4 then
        intContCadastroExterno = carregaItensCadastroExterno(codigoTipo)
    end if

    sql="select * from SCA_ITEM_PLANEJAMENTO_GERAL"
    sql=sql & " where cod_item_planejamento_geral_pai =" & codigoItemPai
    sql=sql & " and cod_tipo_planejamento=" & codigoTipo
    if SESSION("controleAcessoPlanejamentoAnual")=1 then
        sql=sql & " and cod_empresa is null"
    else 
        sql=sql & " and (cod_empresa is null or cod_empresa=" & session("codEmpresa") & ")"
    end if
    sql=sql & " order by cod_bimestre, cod_item_planejamento_geral"
    
    rs.open sql, cnn
    if rs.eof = false then
        
        while not rs.eof
            btnExclusao = "<a onclick='removeItem(" & rs("cod_item_planejamento_geral") & ")' class='btn btn-outline-danger btn-xs btn-icon rounded-circle waves-effect waves-themed edicao'><i class='fal fa-times'></i></a>"
            btnBloqueado = "<a class='btn btn-xs btn-icon rounded-circle waves-effect waves-themed'><i class='fal fa-lock'></i></a>"

            if session("controleAcessoPlanejamentoAnual") = 2 and isnull(rs("cod_empresa")) then
                btnAcao = btnBloqueado
            else
                btnAcao = btnExclusao
            end if

            cod_bimestre = ""
			if rs("cod_bimestre") <> "5" then
				cod_bimestre = " - <b>" & rs("cod_bimestre") & "° "
			end if
			
			linha = "    <li id='item-" & rs("cod_item_planejamento_geral") & "' class='list-group-item'>" & btnAcao & cod_bimestre
			if SESSION("controlePeriodoDeTempo") = 1 then 
				if cod_bimestre="" then
					linha = linha & " "
				else
					linha = linha & "Bim.</b> - " 
				end if
			elseif SESSION("controlePeriodoDeTempo") = 2 then 
				if cod_bimestre="" then
					linha = linha & " "
				else
					linha = linha & "Trim.</b> - " 
				end if
			end if 
			
			linha = linha & rs("descricao")
			if Session("UsuarioMaster") = "S" or Session("AcessoAutorizadoReplicacao") = "S" then
				linha = linha & "<div style=""text-align: right;""><button type=""button"" class=""btn btn-outline-warning btn-sm btn-w-m waves-effect waves-themed"" data-toggle=""modal"" data-target=""#modalReplicar"" onclick=""carregaReplicarModal('" & complementoBim & trim(rs("descricao")) & "'," & rs("cod_item_planejamento_geral") & "," & codigoTipo & "," & anoLetivo & ")"">Replicar Item</button></div>"
			end if

			linha = linha & "</li>"
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

function carregaItensCadastroExterno(codigoTipo) 
    
    dim intCont
    intCont = 0
    if codigoTipo = 3 then
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
            btnBloqueado = "<a class='btn btn-xs btn-icon rounded-circle waves-effect waves-themed'><i class='fal fa-lock'></i></a>"
            btnAcao = btnBloqueado

            response.write "    <li id='item-" & codigoTipo & "-" & rs("codigo") & "' class='list-group-item'>" & btnAcao & " - " & rs("descricao") & "</li>"
            intCont = intCont + 1
            rs.movenext
        wend
    end if
    rs.close    
    carregaItensCadastroExterno = intCont
end function

'function carregaConteudos(codigoItemPai) 
'
'    sql="select * from SCA_ITEM_PLANEJAMENTO_GERAL"
'    sql=sql & " where cod_item_planejamento_geral_pai =" & codigoItemPai
'    rs.open sql, cnn
'    if rs.eof = false then
'        response.write "<ul class='list-group list-group-flush'>"
'        while not rs.eof
'
'            btnExclusao = "<a onclick='removeItem(" & rs("cod_item_planejamento_geral") & ")' class='btn btn-outline-danger btn-xs btn-icon rounded-circle waves-effect waves-themed edicao'><i class='fal fa-times'></i></a>"
'            response.write "    <li id='item-" & rs("cod_item_planejamento_geral") & "' class='list-group-item'>" & btnExclusao & " - <b>" & rs("cod_bimestre") & "° Bim.</b> - " & rs("descricao") & "</li>"
'
'            rs.movenext
'        wend
'        response.write "</ul>"
'    else
'        response.write "<ul class='list-group list-group-flush'><li class='list-group-item'>Nenhum conteúdo cadastrado</li></ul>"
'    end if
'    rs.close    
'
'end function

function carregaPlanejamento(codigoPlanejamento)

    sql="select * from SCA_ITEM_PLANEJAMENTO_GERAL"
    sql=sql & " WHERE cod_planejamento_geral =" & codigoPlanejamento
    sql=sql & " and cod_item_planejamento_geral_pai is null"
    if SESSION("controleAcessoPlanejamentoAnual")=1 then
        sql=sql & " and cod_empresa is null"
    else 
        sql=sql & " and (cod_empresa is null or cod_empresa=" & session("codEmpresa") & ")"
    end if

    rs.open sql, cnn,3,3
    if rs.eof = false then
        while not rs.eof
            %>
            <div class="accordion accordion-outline" id="divPlanejamento<%=rs("cod_item_planejamento_geral")%>">
                <div class="card">
                    <div class="card-header">
                        <a href="javascript:void(0);" class="card-title" data-toggle="collapse" data-target="#divPlanejamento_<%=rs("cod_item_planejamento_geral")%>" aria-expanded="true">
                            <i class="fal fa-chalkboard-teacher width-2 fs-xl"></i>
                            
                            <%=rs("descricao")%>
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
                    <div id="divPlanejamento_<%=rs("cod_item_planejamento_geral")%>" class="collapse show" data-parent="#divPlanejamento<%=rs("cod_item_planejamento_geral")%>" style="">
                        <div class="card-body">  

                            <div class="alert border-faded bg-transparent text-secondary fade show edicao" role="alert">
                                <div class="d-flex align-items-center">
                                    <div class="flex-1">
                                        <span class="h5 color-danger-600">Remover <%=rs("descricao")%></span>
                                        <br>
                                        <span class="edicao">Clique no botão para remover</span>
                                    </div>
                                    
                                    <button type="button" class="btn btn-outline-danger btn-sm btn-w-m waves-effect waves-themed" onclick="removeItemPlanejamento(<%=rs("cod_item_planejamento_geral")%>)">Remover Item</button>
                                </div>
                            </div>                        

                        <%
                        sql="select * from [SCA_TIPO_PLANEJAMENTO]"
                        if SESSION("controleAcessoPlanejamentoAnual") = 1 then
                            sql=sql & " where cod_tipo_planejamento_anual in (1,2)"
                        else 
                            sql=sql & " where cod_tipo_planejamento_anual in (1,2,3,4)"
                        end if
                        rsAux.open sql,cnn
                        vetItemPlanejamento = rsAux.getRows
                        rsAux.close

                        for i=0 to ubound(vetItemPlanejamento,2)

                            'sql="select ig.*, t.descricao as descTipo from SCA_ITEM_PLANEJAMENTO_GERAL ig"
                            'sql=sql & " inner join SCA_TIPO_PLANEJAMENTO t on ig.cod_tipo_planejamento = t.cod_tipo_planejamento_anual"
                            'sql=sql & " WHERE cod_item_planejamento_geral_pai =" & rs("cod_item_planejamento_geral")
                            'sql=sql & " and t.cod_tipo_planejamento_anual=" & vetItemPlanejamento(0,i)
                            'rsAux.open sql, cnn
                            'if rsAux.eof = false then
                                'while not rsAux.eof

                                    if vetItemPlanejamento(0,i)=1 then 
                                        strNomeAcao="novoItemHabilidade"
                                    else 
                                        strNomeAcao="novoItemConteudo"
                                    end if

                                    strTituloItem = vetItemPlanejamento(1,i)
                                    strCodigoDiv = rs("cod_item_planejamento_geral") & "-" & vetItemPlanejamento(0,i)
                                    %>

                                    <div class="accordion accordion-outline" id="divItemPlanejamento-<%=strCodigoDiv%>">
                                        <div class="card">
                                            <div class="card-header">
                                                <input type="hidden" id="txtControleAbertura-<%=strCodigoDiv%>" value="N">
                                                <a href="javascript:void(0);" class="card-title collapsed" data-toggle="collapse" id="card-<%=strCodigoDiv%>" data-target="#divItemPlanejamento-<%=strCodigoDiv%>a" aria-expanded="false" onclick="controleAbertura(<%=rs("cod_item_planejamento_geral")%>,<%=vetItemPlanejamento(0,i)%>);carregaItensTipo(<%=rs("cod_item_planejamento_geral")%>,<%=vetItemPlanejamento(0,i)%>)">
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

                                                    <div class="alert border-faded bg-transparent text-secondary fade show" role="alert">
                                                        <div class="d-flex align-items-center">
                                                            <div class="flex-1">
                                                                <span class="h5 color-success-600">Adicionar <%=vetItemPlanejamento(1,i)%></span>
                                                                <br>
                                                                Clique no botão para adicionar
                                                            </div>
                                                            
                                                            <button type="button" class="btn btn-outline-success btn-sm btn-w-m waves-effect waves-themed" data-toggle="modal" data-target="#modalNovoItem" onclick="carregaCamposModal(true,<%=rs("cod_item_planejamento_geral")%>,<%=vetItemPlanejamento(0,i)%>)">Novo Item</button>
                                                        </div>
                                                    </div>

                                                    <div id="div-<%=strCodigoDiv%>" class="card border  m-auto m-lg-0" style="width: 100%;">
                                                    </div>		
                                                    
                                                </div>
                                            </div>
                                        </div>
                                        
                                    </div>							

                                    <%
                                    'rsAux.movenext
                                'wend
                            'end if
                            'rsAux.close 
                        next                  
                        %>
                        </div>
                    </div>                    
                </div>
                
            </div>
            <%
            rs.movenext
        wend
    end if
    rs.close 
end function

cnn.begintrans

if acao = "novoCurriculo" or acao = "novoCurriculoEscola" then

    if acao = "novoCurriculo" then
        if codigoPlanejamento = "0" then
            codigoPlanejamento = inserePlanejamentoGeral(1,0)
            'retorna o código
            response.write codigoPlanejamento        
        end if    
    else
        if codigoPlanejamentoEscola = "0" then
            codigoPlanejamentoEscola = inserePlanejamentoGeral(2,codigoPlanejamento)
            'retorna o código
            response.write codigoPlanejamentoEscola        
        end if    
    end if

    if codigoItemPai = "0" then
        codigoItemPai = insereItemPlanejamentoGeral (codigoPlanejamento,null,0,descricao,null)
    end if


elseif acao = "novoItem" or acao="novoItemEscola" then

        if acao="novoItemEscola" and codigoPlanejamentoEscola = "0" then
            codigoPlanejamentoEscola = inserePlanejamentoGeral(2,codigoPlanejamento)
            'retorna o código
            response.write codigoPlanejamentoEscola        
        end if 

    insereItemPlanejamentoGeral codigoPlanejamento, codigoItemPai, codBimestre, descricao, codigoTipo 

elseif acao = "novoItemUnidadeTematica" then
	'busca planejamento geral do periodo e disciplina para inclusão do item planejemanto 
	codigoPlanejamentoGeral = consultaCodigoPlanejamentoGeral()
	
    insereItemPlanejamentoGeral codigoPlanejamentoGeral, "", 0, descricao, ""
  
elseif acao = "carregaItensTipo" then

    carregaItensTipo codigoItemPai, codigoTipo

'elseif acao = "carregaConteudos" then
'
'    carregaConteudos codigoItemPai   

elseif acao = "carregaPlanejamento" then

    carregaPlanejamento codigoPlanejamento

elseif acao = "excluiItem" then   
    excluiItem codigoItem

elseif acao = "excluiItemPlanejamento" then  

    qtdRegistros = excluiItemPlanejamento (codigoItem, codigoPlanejamento)
    response.write qtdRegistros

elseif acao="liberaPlanejamento" then
	
	
    if SESSION("controleAcessoPlanejamentoAnual") = 1 then
        liberaPlanejamento codigoPlanejamento
    else
        liberaPlanejamentoEscola codigoPlanejamentoEscola
    end if
	
elseif acao="enviarAutorizacaoPlanejamentoEscola" then

    enviarAutorizacaoPlanejamentoEscola codigoPlanejamento, codigoPlanejamentoEscola

end if

cnn.commitTrans
%>
