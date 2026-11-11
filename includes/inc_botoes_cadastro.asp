<% if session("UsuarioWeb") = "USUARIO.TESTE" then
	strDesabilitaIncluir = " Disabled "
	strDesabilitaAlterar = " Disabled "
	strDesabilitaExcluir = " Disabled "
end if

strClassBotaoIncluir = "btn-u btn-u-default"
strClassBotaoAlterar = "btn-u btn-u-default"
strClassBotaoExcluir = "btn-u btn-u-default"
strClassBotaoFechar  = "btn-u btn-u-default"
strClassBotaoLimpar  = "btn-u btn-u-default"
strClassBotaoEnviarParaAutorizacao	= "btn-u btn-u-default"
strClassBotaoCalendarioEvento		= "btn-u btn-u-default"
strClassBotaoExcessaoPorUnidade		= "btn-u btn-u-default"
strClassBotaoDefaultOutros 			= "btn-u float-shadow"
strClassBotaoResolucao = "btn-u btn-u-default"

if trim(strDesabilitaIncluir)	= "" then strClassBotaoIncluir = "btn-u float-shadow"
if trim(strDesabilitaAlterar)	= "" then 
	strClassBotaoAlterar 	= "btn-u btn-u-blue float-shadow"
	strClassBotaoResolucao = "btn-u float-shadow"
end if
if trim(strDesabilitaExcluir)	= "" then strClassBotaoExcluir = "btn-u btn-u-red float-shadow"
if trim(strDesabilitaFechar)	= "" then strClassBotaoFechar  = "btn-u btn-u-brown float-shadow"
if trim(strDesabilitaLimpar)	= "" then strClassBotaoLimpar  = "btn-u btn-u-orange float-shadow"
if trim(strDesabilitaBotaoEnviarParaAutorizacao) = "" then strClassBotaoEnviarParaAutorizacao 	= "btn-u float-shadow"
if trim(strDesabilitaBotaoCalendarioEvento) = "" then strClassBotaoCalendarioEvento 		= "btn-u float-shadow"
if trim(strDesabilitaExcessaoPorUnidade) 		 = "" then strClassBotaoExcessaoPorUnidade 		= "btn-u float-shadow"

strBotaoAcaoIncluir	= ""
strBotaoAcaoAlterar	= ""
strBotaoAcaoExcluir	= ""
strBotaoAcaoFechar	= ""
strBotaoAcaoLimpar	= ""

if trim(strDesabilitaIncluir)	= "" then strBotaoAcaoIncluir = "return salvar('I')"
if trim(strDesabilitaAlterar)	= "" then strBotaoAcaoAlterar = "return salvar('A')"
if trim(strDesabilitaExcluir)	= "" then strBotaoAcaoExcluir = "return salvar('E')"
if trim(strDesabilitaFechar)	= "" then strBotaoAcaoFechar  = "window.close()"
if trim(strDesabilitaLimpar)	= "" then strBotaoAcaoLimpar  = "window.location='" & strPagina & "'"
if trim(strDesabilitaBotaoEnviarParaAutorizacao) = "" then strBotaoAcaoEnviarParaAutorizacao = "enviar()"
if trim(strDesabilitaExcessaoPorUnidade) = "" then strBotaoAcaoExcessaoPorUnidade = "porUnidade('" & intCodigo & "')"

%>

 <div class="margin-bottom-30">
 		
		<input type="button" name="cmdIncluir" style="cursor:hand"  value="Incluir"  class="<%=strClassBotaoIncluir%>" 	<%=strDesabilitaIncluir%> onclick="<%=strBotaoAcaoIncluir%>">
		<input type="button" name="cmdAlterar" style="cursor:hand"  value="Alterar"  class="<%=strClassBotaoAlterar%>" 	<%=strDesabilitaAlterar%> onclick="<%=strBotaoAcaoAlterar%>">
		<input type="button" name="cmdLimpar"  style="cursor:hand"  value="Limpar"   class="<%=strClassBotaoLimpar%>" 	<%=strDesabilitaLimpar%>  onClick="<%=strBotaoAcaoLimpar%>">
		<input type="button" name="cmdExcluir" style="cursor:hand"  value="Excluir"  class="<%=strClassBotaoExcluir%>" 	<%=strDesabilitaExcluir%> onclick="<%=strBotaoAcaoExcluir%>">
		
        <%if strMostraBotaoEnviarParaAutorizacao = "S" then%>
			<input type="button" name="cmdAutorizacao"  style="cursor:hand"  value="Enviar para Autorização"  class="<%=strClassBotaoEnviarParaAutorizacao%>" <%=strDesabilitaBotaoEnviarParaAutorizacao%>  onClick="<%=strBotaoAcaoEnviarParaAutorizacao%>">
		<%end if%> 
        
        <%if strMostraBotaoCalendarioEvento = "S" then%>
			<input type="button" name="cmdAutorizacao"  style="cursor:hand"  value="Eventos do Calendário"  class="<%=strClassBotaoCalendarioEvento%>" <%=strDesabilitaBotaoCalendarioEvento%>  onClick="eventoCalendario()">
			<input type="button" name="cmdAutorizacao1"  style="cursor:hand"  value="Visualizar Calendário"  class="<%=strClassBotaoCalendarioEvento%>" <%=strDesabilitaBotaoCalendarioEvento%>  onClick="emitirCalendario()">
		<%end if%>      
        
        <%if strVinculaRota = "S" then %>
        <input type="button" name="cmdVinculaRota" style="cursor:hand"  value="Vincula Rata a Unidade" class="<%=strClassBotaoAlterar%>" <%=strDesabilitaAlterar%> onclick="return VinculaRota()">
        <%end if%>
      
        <%if strExcessaoPorUnidade = "S" then %>
        	<input name="btnExcessaoPorUnidade" type="button"  class="<%=strClassBotaoExcessaoPorUnidade%>" id="btnExcessaoPorUnidade" style="cursor:hand" onclick="<%=strBotaoAcaoExcessaoPorUnidade%>"   value="Exceção Por Escola" <%=strDesabilitaExcessaoPorUnidade%> />
        <%end if%>
        
		<%if strMostraResolucaoCurso = "S" then %>
        	<input name="cmdCursoResolucao" type="button"  class="<%=strClassBotaoResolucao%>" id="cmdCursoResolucao" style="cursor:hand" onclick="CursoResolucao()"   value="Resolu&ccedil;&atilde;o do Curso" <%=strDesabilitaAlterar%> />
        <%end if%>

		<%if strMostraPerguntas = "S" then %>
        	<input name="cmdPerguntas" type="button"  class="<%=strClassBotaoDefaultOutros%>" id="cmdPerguntas" style="cursor:hand" onclick="abrePerguntas()"   value="Perguntas Descritivas" <%=strDesabilitaPerguntas%> />
        <%end if%>

		<%if strMostraArtigo = "P" then %>
        <input name="cmdArtigo" type="button"  class="<%=strClassBotaoDefaultOutros%>" id="cmdArtigo" style="cursor:hand" onclick="abreArtigo()"   value="Artigo" <%=strDesabilitaArtigo%> />
        <%end if%>
        <%if strMostraExemplares = "E" then %>
        <input name="cmdExemplares" type="button"  class="<%=strClassBotaoDefaultOutros%>" id="cmdExemplares" style="cursor:hand" onclick="abreExemplares()"   value="Excluir Exemplares" <%=strDesabilitaExemplares%> />
        <%end if%>
        <%if strAlterarExemplares = "A" then %>
        <input name="cmdAlterarExemplares" type="button"  class="btn-u" id="cmdAlterarExemplares" style="cursor:hand" onclick="AlterarExemplares()"   value="Alterar Exemplares" <%=strDesabilitaExemplares%> />
        <%end if%>
         <%if Session("mobile")<>"S" then%>
        <%if strMostraBotaoCadastroPrincipal = "" then%>
		<input type="button" name="cmdPrincipal" style="cursor:hand"   value="Principal"  class="btn-u btn-u-brown float-shadow" onClick="window.location='default.asp'">
		<%end if%>
          <%end if%>
		<%if strMostraBotaoFechar = "S" then%>
		<input type="button" name="cmdFechar" style="cursor:hand"   value="Fechar"  class="<%=strClassBotaoDefaultOutros%>" onClick="window.close()">
		<%end if%>
		<%if strMostraBotaoFecharComSubmit = "S" then%>
		<input type="button" name="cmdFecharSubmit" style="cursor:hand"   value="Fechar"  class="<%=strClassBotaoDefaultOutros%>" onClick="fecharSubmit()">
		<%end if%>
		
		<%if strMostraBotaoImprimir = "S" then%>
		<input type="button" name="cmdImprimir" style="cursor:hand"   value="Imprimir"  <%=strDesabilitaImprimir%> class="<%=strClassBotaoDefaultOutros%>" onClick="gerarImpressao()">
		<%end if%>

		<%if strMostraBotaoAtualizarHistorico = "S" then%>
		<input type="button" name="cmdAtualizarHistorico" style="cursor:hand"   value="Atualizar Historico"  <%=strDesabilitaAtualizarHistorico%> class="<%=strClassBotaoDefaultOutros%>" onClick="AtualizarHistorico()">
		<%end if%>
        
		<%if strMostraBotaoImprimirBoleto = "S" then%>
		<input type="button" name="cmdImprimirBoleto" style="cursor:hand"   value="Imprimir Boleto"  <%=strDesabilitaImprimir%> class="<%=strClassBotaoDefaultOutros%>" onClick="gerarImpressaoBoleto()">
		<%end if%>
		
		<%if strMostraBotaoPrincipalAlterarSenha = "S" then%>
		<input type="button" name="cmdPrincipal" style="cursor:hand"   value="Principal"  class="btn-u btn-u-brown float-shadow" <%=strDesabilitaPrincipal%> onClick="window.location='default.asp">
		<%end if%>
        
        <%if strMostraBotaoVoltar = "S" then%>
		<input type="button" name="cmdFechar" style="cursor:hand"   value="  Voltar  "  class="btn-u btn-u-brown float-shadow" <%=strDesabilitaVoltar%> onClick="window.location='<%=strPaginaVoltar%>'">
		<%end if%>

        
        <%if strBotaoInativaModulacao = "S" then %>
        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input name="cmdInativar" type="button"  class="<%=strClassBotaoDefaultOutros%>" id="cmdInativar" style="cursor:hand" onclick="InativarModucacao()"   value="Inativar Modula&ccedil;&atilde;o" <%=strDesabilitaBotaoInativar%> />
        <%end if%>
        <%if strBotaoPedidoDeRemocaoSolicitados = "S" then %>
        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input name="cmdPedido" type="button"  class="<%=strClassBotaoIncluir%>" id="cmdPedido" style="cursor:hand" onclick="pedidoRemocaoSolicitados()" value="Pedido de Remoção Solicitados" />
        <%end if%>
		<%if strBotaoPedidoDeRemocaoAutorizacao = "S" then %>
        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input name="cmdPedido" type="button"  class="<%=strClassBotaoIncluir%>" id="cmdPedido" style="cursor:hand" onclick="pedidoRemocaoSolicitados()" value="Voltar a lista de pedidos" />
        <%end if%>
        <%if strBotaoEnviarParaSecSolicModucacao = "S" then %>
        	&nbsp;&nbsp;<input name="cmdEstrtura" type="button"  class="btn-u btn-u-blue float-shadow" id="cmdestrutura" style="cursor:hand" onclick="estrutura()" value="Estrutura Físíca - Sede" />
        	&nbsp;&nbsp;<input name="cmdEnviar" type="button"  class="<%=strClassBotaoLimpar%>" id="cmdEnviar" style="cursor:hand" onclick="enviar()" value="Enviar Secretaria de Educação" />
        <%end if%>
        <%if strBotaoVoltarParaSecSolicModucacao = "S" then %>
        	&nbsp;&nbsp;<input name="cmdEstrtura" type="button"  class="<%=strClassBotaoLimpar%>" id="cmdestrutura" style="cursor:hand" onclick="voltar()" value="Voltar para Solicitação de Modulação" />
        <%end if%>
		<%if strBotaoPerguntas = "S" then %>
        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input name="cmdPergunta" type="button"  class="btn-u float-shadow" id="cmdPergunta" style="cursor:hand" onclick="perguntas('<%=cod_pesquisa%>')" value="Volta para Pergunta" />
        <%end if%>
		<%if strBotaoPerguntasEAD = "S" then %>
        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input name="cmdPergunta" type="button"  class="btn-u float-shadow" id="cmdPergunta" style="cursor:hand" onclick="perguntas('<%=cod_questionario%>')" value="Volta para Pergunta" />
        <%end if%>
		<%if strBotaoExluirEntrevistas = "S" then %>
        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input name="cmdExcluirEntrevista" type="button"  class="btn-u btn-u-red float-shadow" id="cmdExcluirEntrevista" style="cursor:hand" onclick="excluirEntrevistas('<%=cod_pesquisa%>')" value="Remover Todas Entrevistas" />
        <%end if%>
		<%if strBotaoExluirRespostas = "S" then %>
        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input name="cmdExcluirEntrevista" type="button"  class="btn-u btn-u-red float-shadow" id="cmdExcluirEntrevista" style="cursor:hand" onclick="excluirRespostas('<%=cod_questionario%>')" value="Remover Todas Respostas" />
        <%end if%>
		<%if Session("CodPerfilAcessoRH") = "72" then%>
			<%if strBotaoAutorizarModulacao = "S" then %>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input name="cmdAutorizarModulacao" type="button"  class="btn-u btn-u-blue float-shadow" id="cmdAutorizarModulacao" style="cursor:hand" onclick="consultarModulacao()" value="Pedidos de Modulação" />
			<%end if%>
			
		<%end if%>
        
</div>