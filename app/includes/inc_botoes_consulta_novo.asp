 <%if strBotaoConsultarTelaAtual = "" then%>
 <button onClick="submit()" <%=strDesabilitaConsultar%>  type="button" class="btn btn-outline-success waves-effect waves-themed">Consultar</button>
 <%end if%>
 <%if strBotaoLimparTelaAtual = "" then%>
 <button onclick="window.location='<%=pagina_atual%>'" type="button" class="btn btn-outline-warning waves-effect waves-themed">Limpar tela</button>
 <%end if%>
 <%if strBotaoAtualizarTelaAtual = "S" then%>
 <button onclick="return gerar()" type="button" class="btn btn-outline-primary waves-effect waves-themed">Atualizar</button>
 <%end if%>
 <%if strBotaoVoltaTelaAnterior = "" then%>
<button onClick="window.location='<%=pagina_anterior%>'"  type="button" class="btn btn-outline-info">Voltar</button>
 <%end if%>
 <%if strBotaoVoltaTelaAnteriorSubmit = "S" then%>
 <button onClick="voltaTela('<%=pagina_anterior%>')"  type="button" class="btn btn-outline-info">Voltar</button>
 <%end if%>