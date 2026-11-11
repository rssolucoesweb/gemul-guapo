<div class="combo-wrapper">
<h3><i class="fa-solid fa-magnifying-glass"></i> Selecione sua unidade </h3><br>
    <!-- input visível -->
    <input type="text" id="comboInput" class="combo-input" placeholder="Clique para selecionar ou digite para pesquisar...">

    <!-- dropdown visual -->
    <div id="comboDropdown" class="combo-dropdown"></div>

    <!-- SELECT REAL (funciona escondido) -->
    <select 
        id="cmdEmpresaUsuario" 
        name="cmdEmpresaUsuario" 
        style="display:none"
        onchange="document.getElementById('frm').submit()"
    >
        <option value="0">Selecione...</option>
<%	
			if intCodGrupo = "" then intCodGrupo = SESSION("codGrupo")
			if intCodGrupo = "" then intCodGrupo = 1
			anoLogado = SESSION("strAnoLetivo")
			if anoLogado = "" then anoLogado = year(date)


			sql = "select ue.COD_EMPRESA, e.RAZAOSOCIAL as empresa, "
			sql = sql & " ("
			sql = sql & " select count(*) "
			sql = sql & " FROM SCA_ALUNO a "
			sql = sql & " inner join sca_aluno_turma at on at.cod_aluno = a.codigo and at.COD_EMPRESA = e.CODIGO"
			sql = sql & " inner join sca_turma t on t.cod_turma = at.cod_turma "
			sql = sql & " WHERE t.anoLetivo = " & anoLogado 
			sql = sql & " and at.situacao = 'A' "
			sql = sql & " and t.Situacao = 'A' "
			sql = sql & " and a.COD_SITUACAOALUNO = 1 "
			sql = sql & " )"
			sql = sql & "  as ativos "
			sql = sql & " FROM SEG_USUARIOS_EMPRESA ue INNER JOIN SEG_EMPRESA e ON e.CODIGO = ue.COD_EMPRESA "
			sql = sql & " WHERE e.CodTipoEmpresa<>5 "
			sql = sql & " and ue.CODIGO_SEG_USUARIOS_SISTEMA = '" & Session("UsuarioWeb") & "' and e.BLOQUEIO = 'N' "
			if intCodGrupo <> "0" then
				sql = sql & " AND e.COD_GRUPO = " & intCodGrupo
			end if
			if intContratoAcesso<>"0" and intContratoAcesso <> "" then
				sql = sql & " AND ue.COD_EMPRESA in (select Cod_empresa from SRH_MODULACAO_DISCIPLINAR_DOCENTE where Cod_Colaborador in (" & intContratoAcesso & "))"
			end if
			
			sql = sql & " union "
			sql = sql & " select ue.COD_EMPRESA, e.RAZAOSOCIAL as empresa, 0 as ativos "
			sql = sql & " FROM SEG_USUARIOS_EMPRESA ue INNER JOIN SEG_EMPRESA e ON e.CODIGO = ue.COD_EMPRESA "
			sql = sql & " WHERE e.CodTipoEmpresa=5 "
			sql = sql & " and ue.CODIGO_SEG_USUARIOS_SISTEMA = '" & Session("UsuarioWeb") & "'"
			sql = sql & " and e.BLOQUEIO = 'N'"
			if intCodGrupo <> "0" then
				sql = sql & " AND e.COD_GRUPO = " & intCodGrupo
			end if
			if intContratoAcesso<>"0" and intContratoAcesso <> "" then
				sql = sql & " AND ue.COD_EMPRESA in (select Cod_empresa from SRH_MODULACAO_DISCIPLINAR_DOCENTE where Cod_Colaborador in (" & intContratoAcesso & "))"
			end if
			sql = sql & "  Order by e.RAZAOSOCIAL"
			'response.write sql
			RSAux.OPEN SQL, CNN%>
        <%  
            IF RSAux.EOF = FALSE THEN
                WHILE NOT RSAux.EOF
                    
                    desc = RSAux("empresa")
                    IF RSAux("COD_EMPRESA") <> "9" THEN
                        desc = desc & " - ( Ativos: " & RSAux("ATIVOS") & " - Ano: " & anoLogado & " )"
                    END IF

                    response.write "<option value='" & RSAux("COD_EMPRESA") & "' " & _
                                   "data-text=""" & desc & """>" & _
                                   desc & "</option>"

                    RSAux.MoveNext
                WEND
            END IF
            RSAux.Close
        %>

    </select>

</div>
<br>		