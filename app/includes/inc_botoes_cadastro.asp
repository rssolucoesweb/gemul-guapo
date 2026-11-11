<%if acao = "" and retira_incluir="" then acao="I"%>
<%if retira_incluir="S" then%>								
<%else%>
<%if left(acao,1) = "I" then%>
	<button onClick="salvar('I')"  type="button" class="btn btn-outline-success">Incluir</button>
<%end if%>
<%end if%>
<%if left(acao,1) = "A" then%>
	<button onClick="salvar('A')"  type="button" class="btn btn-outline-info">Alterar</button>
<%end if%>
<%if right(acao,1) = "E" then%>
	<button onClick="salvar('E')"  type="button" class="btn btn-outline-danger">Excluir</button>
<%end if%>
<%if strBotaoLimparTela = "" then%>
<button onClick="window.location='<%=replace(pagina_atual,"/app/","")%>'"  type="button" class="btn btn-outline-warning">Limpar tela</button>
<%end if%>
<%if strBotaoVoltaTelaAnterior = "S" then%>
<button onClick="window.location='<%=pagina_anterior%>'"  type="button" class="btn btn-outline-info">Voltar</button>
<%end if%>


<%if strBotaoExcluirDiscGradeAluno = "S" then %>
<button onClick="ExcluirDisciplina()"  type="button" class="btn btn-outline-danger">Excluir Grade Disciplina</button>
<%end if%>

<%if strMostraBotaoAtualizacaoDocumentos = "S" and strCodAluno<>"" then %>
<button  onClick="return AlunoDocumentacoes('<%=strCodAluno%>')"  type="button" class="btn btn-outline-info">Atualizar Documentações Pendentes</button>
<%end if%>

<%if session("UsuarioMaster") = "S" and strCodAluno<>"" and mostra_botao_arquivo_notas = "S" then %>
<button onClick="return NotasFaltas('<%=strCodAluno%>')" type="button" class="btn btn-outline-info">Arquivo de Notas</button>
<%end if%>

<%if mostra_botao_resumo_turma_fechamento = "S" then %>
<button onClick="return abreModalSituacao('<%=strAnoLetivo%>','<%=session("codEmpresa")%>')" type="button" class="btn btn-outline-info">Resumo Fechamento</button>
<%end if%>