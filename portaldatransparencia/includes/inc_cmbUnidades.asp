<%
strFuncao = "onchange='submit()'"

SQL = " select CODIGO AS COD_EMPRESA, razaosocial AS empresa from SEG_EMPRESA"
SQL = SQL & " where cod_grupo=1"
SQL = SQL & " and CodTipoEmpresa in (1,2)"
SQL = SQL & " and BLOQUEIO='N'"
SQL = SQL & " order by empresa"

RSAux.OPEN SQL, CNN
empresaSelecionadaNome = request.form("comboEmpresaInput")
%>
    <div class="combo-container">
		<input 
			type="text"
			id="comboEmpresaInput"
			name="comboEmpresaInput"
			placeholder="Digite para pesquisar a unidade..."
			autocomplete="off"
			onclick="abrirComboEmpresa()"
			onkeyup="filtrarComboEmpresa()"
		/>

        <input type="hidden" name="cmbEmpresa" id="cmbEmpresa" value="<%=intCodEmpresa%>">

        <div id="comboEmpresaDropdown" class="combo-dropdown">

            <div class="combo-item" onclick="selecionarEmpresa('0', 'Selecione...')">
                Selecione...
            </div>

            <%
			empresaSelecionadaNome = ""
            IF RSAux.EOF = FALSE THEN
                while not RSAux.eof

                    empresaNome = trim(RSAux("empresa"))
                    empresaCod  = RSAux("COD_EMPRESA")

					if Trim(empresaCod) = Trim(intCodEmpresa) then
						empresaSelecionadaNome = empresaNome
					end if					
            %>
                <div 
                    class="combo-item"
                    data-value="<%=empresaCod%>"
                    onclick="selecionarEmpresa('<%=empresaCod%>', '<%=Replace(empresaNome,"'","\'")%>')"
                >
                    <%=empresaNome%>
                </div>
            <%
                    RSAux.movenext
                wend
            END IF
            RSAux.close
            %>

        </div>
    </div>
