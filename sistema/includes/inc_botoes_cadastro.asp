<% if session("UsuarioWeb") = "USUARIO.TESTE" then
	strDesabilitaIncluir = " Disabled "
	strDesabilitaAlterar = " Disabled "
	strDesabilitaExcluir = " Disabled "
end if
%>
 <div class="margin-bottom-30">
 		
		<input type="button" name="cmdIncluir" style="cursor:hand"  value="Incluir"  class="btn btn-u float-shadow" <%=strDesabilitaIncluir%> onclick="return salvar('I')">
		<input type="button" name="cmdAlterar" style="cursor:hand"  value="Alterar"  class="btn btn-u btn-u-blue float-shadow" <%=strDesabilitaAlterar%> onclick="return salvar('A')">
		<input type="button" name="cmdLimpar"  style="cursor:hand"  value="Limpar"   class="btn btn-u btn-u-orange float-shadow" <%=strDesabilitaLimpar%> onClick="window.location='<%=strPagina%>'">
		<input type="button" name="cmdExcluir" style="cursor:hand"  value="Excluir"  class="btn btn-u btn-u-red float-shadow" <%=strDesabilitaExcluir%> onclick="return salvar('E')">

        <%if strVinculaRota = "S" then %>
        <input type="button" name="cmdVinculaRota" style="cursor:hand"  value="Vincula Rata a Unidade" class="btn-u" <%=strDesabilitaAlterar%> onclick="return VinculaRota()">
        <%end if%>
      
        <%if strExcessaoPorUnidade = "S" then %>
        	<input name="btnExcessaoPorUnidade" type="button"  class="btn-u float-shadow" id="btnExcessaoPorUnidade" style="cursor:hand" onclick="porUnidade('<%=intCodigo%>')"   value="Excessão Por Escola" <%=strDesabilitaExcessaoPorUnidade%> />
        <%end if%>
        
		<%if strMostraResolucaoCurso = "S" then %>
        	<input name="cmdCursoResolucao" type="button"  class="btn-u float-shadow" id="cmdCursoResolucao" style="cursor:hand" onclick="CursoResolucao()"   value="Resolução do Curso" <%=strDesabilitaAlterar%> />
        <%end if%>

		<%if strMostraPerguntas = "S" then %>
        	<input name="cmdPerguntas" type="button"  class="btn-u float-shadow" id="cmdPerguntas" style="cursor:hand" onclick="abrePerguntas()"   value="Perguntas Descritivas" <%=strDesabilitaPerguntas%> />
        <%end if%>

		<%if strMostraArtigo = "P" then %>
        <input name="cmdArtigo" type="button"  class="btn-u float-shadow" id="cmdArtigo" style="cursor:hand" onclick="abreArtigo()"   value="Artigo" <%=strDesabilitaArtigo%> />
        <%end if%>
        <%if strMostraExemplares = "E" then %>
        <input name="cmdExemplares" type="button"  class="btn-u float-shadow" id="cmdExemplares" style="cursor:hand" onclick="abreExemplares()"   value="Excluir Exemplares" <%=strDesabilitaExemplares%> />
        <%end if%>
        <%if strAlterarExemplares = "A" then %>
        <input name="cmdAlterarExemplares" type="button"  class="btn-u" id="cmdAlterarExemplares" style="cursor:hand" onclick="AlterarExemplares()"   value="Alterar Exemplares" <%=strDesabilitaExemplares%> />
        <%end if%>
        <%if strMostraBotaoCadastroPrincipal = "" then%>
		<input type="button" name="cmdPrincipal" style="cursor:hand"   value="Principal"  class="btn btn-u btn-u-brown float-shadow" onClick="window.location='default.asp'">
		<%end if%>
		<%if strMostraBotaoFechar = "S" then%>
		<input type="button" name="cmdFechar" style="cursor:hand"   value="Fechar"  class="btn-u float-shadow" onClick="window.close()">
		<%end if%>
		<%if strMostraBotaoFecharComSubmit = "S" then%>
		<input type="button" name="cmdFecharSubmit" style="cursor:hand"   value="Fechar"  class="btn-u float-shadow" onClick="fecharSubmit()">
		<%end if%>
		
		<%if strMostraBotaoImprimir = "S" then%>
		<input type="button" name="cmdImprimir" style="cursor:hand"   value="Imprimir"  <%=strDesabilitaImprimir%> class="btn-u float-shadow" onClick="gerarImpressao()">
		<%end if%>

		<%if strMostraBotaoAtualizarHistorico = "S" then%>
		<input type="button" name="cmdAtualizarHistorico" style="cursor:hand"   value="Atualizar Historico"  <%=strDesabilitaAtualizarHistorico%> class="btn-u float-shadow" onClick="AtualizarHistorico()">
		<%end if%>
        
		<%if strMostraBotaoImprimirBoleto = "S" then%>
		<input type="button" name="cmdImprimirBoleto" style="cursor:hand"   value="Imprimir Boleto"  <%=strDesabilitaImprimir%> class="btn-u float-shadow" onClick="gerarImpressaoBoleto()">
		<%end if%>
		
		<%if strMostraBotaoPrincipalAlterarSenha = "S" then%>
		<input type="button" name="cmdPrincipal" style="cursor:hand"   value="Principal"  class="btn-u btn-u-default float-shadow" <%=strDesabilitaPrincipal%> onClick="window.location='../principal.asp'">
		<%end if%>

        
        <%if strBotaoInativaModulacao = "S" then %>
        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input name="cmdInativar" type="button"  class="btn-u float-shadow" id="cmdInativar" style="cursor:hand" onclick="InativarModucacao()"   value="Inativar Modulação" <%=strDesabilitaBotaoInativar%> />
        <%end if%>

</div>