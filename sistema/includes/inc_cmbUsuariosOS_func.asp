<%
	
	sql = " select c.codigo, c.nome"
	sql = sql & " from SRH_COLABORADOR c"
	sql = sql & " inner join SEG_USUARIOS_EMPRESA u on u.CODIGO_SEG_USUARIOS_SISTEMA = c.codigo_SEG_USUARIOS_SISTEMA and c.codLotacao = u.COD_EMPRESA"
	sql = sql & " inner join SEG_ACESSOS_USUARIO a on a.ACES_USUA_CODG = c.codigo_SEG_USUARIOS_SISTEMA"
	sql = sql & " where a.ACES_PERF_CODG in (66,67,69)"
	sql = sql & " order by 2"
'
'	sql = sql & " WHERE 1=1 "
'	if UsuarioMaster = "N" and GestorSuporte = "N" and GestorManutencao = "N" then ' Considerado como usuário comum nas unidades escolares
'	   	sql = sql & " And GESTOR_MANUTENCAO = 'S' "
'  		sql = sql & " And COD_GRUPO = " & session("CodGrupo")
'	elseif UsuarioMaster = "N" and GestorSuporte = "N" and GestorManutencao = "S" then
'	   	sql = sql & " And GESTOR_SUPORTE = 'S' "
'	elseif UsuarioMaster = "N" and GestorSuporte = "S" and GestorManutencao = "S" then
'	   	sql = sql & " And ( USUARIO_MASTER = 'S' OR GESTOR_SUPORTE = 'S' OR GESTOR_MANUTENCAO = 'S' )"
'	elseif UsuarioMaster = "N" and GestorSuporte = "S" and GestorManutencao = "N" then
'	   	sql = sql & " And ( USUARIO_MASTER = 'S' OR GESTOR_SUPORTE = 'S' OR GESTOR_MANUTENCAO = 'S' )"
'	elseif UsuarioMaster = "S" then
'	   	sql = sql & " And ( USUARIO_MASTER = 'S' OR GESTOR_SUPORTE = 'S' OR GESTOR_MANUTENCAO = 'S' )"
'    else
'	   	sql = sql & " And GESTOR_MANUTENCAO = 'X' "
'	   	sql = sql & " And USUARIO_MASTER = 'X' "
'	   	sql = sql & " And GESTOR_SUPORTE = 'X' "
'    end if
'	sql = sql & " And USUA_STAT = 'A'"
'	sql = sql & " order by 1"
	RS.OPEN SQL, CNN
%>
<select name="cmbUsuarioOS_func" id="cmbUsuarioOS_func" style="width:300pt" class="form-control">
    <option value="0">Selecione...</option>
    <%	
    IF RS.EOF = FALSE THEN
        while not rs.eof
            if trim(intCodUsuarioOSFunc) = trim(rs("codigo")) then
                strSelecionado = " selected"
            else
                strSelecionado = ""
            end if
            response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & ucase(rs("nome")) & "</option> "  & vbcrlf
            rs.movenext
        wend
    END IF
    rs.close
%>
</select>