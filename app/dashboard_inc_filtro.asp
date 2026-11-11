	<div class="row">
		<div class="col-xl-12">
			<div id="divFiltro" class="panel">
				<div class="panel-hdr">
					<h2>
						Filtros <span class="fw-300"><i></i></span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel ni ni-chevron-down" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Recolher"></button>
						<button class="btn btn-panel ni ni-size-fullscreen" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Tela cheia"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content" style="display: flex; gap: 10px;">
						<div class="form-group" style="flex: auto">
							<label class="form-label">Tipo de Unidade:<%retirarDaComboTipoUnidade=5%></label>
							<!--#include file="includes/inc_cmbTipoEmpresa.asp" -->
						</div>
						<div class="form-group" style="flex: auto">
							<label class="form-label">Unidade:</label>
							<!--#include file="includes/inc_cmbEmpresaGrupo.asp" -->
						</div>
						<div class="form-group">
							<label class="form-label">Ano letivo <%=strAnoLetivo%></label>
							<select name="cmbAnoLetivo" id="cmbAnoLetivo" class="form-control">
								<option value="0">Selecione...</option>
								<%
								if qtdeAnosCombo = "" then qtdeAnosCombo = 5
								for i=session("strAnoLetivo") to session("strAnoLetivo")-qtdeAnosCombo step -1
									strAnoSelecionado = ""
									if CSTR(strAnoLetivo) = cstr(i) then strAnoSelecionado="selected"
									%>
									<option value="<%=i%>" <%=strAnoSelecionado%>><%=i%></option>
									<%
								next
								%>
							</select>
						</div>
						<div class="form-group" style="display: flex; align-items: center; gap: 4px;">
							<button type="button" id='btnFiltrar' class="btn btn-primary" onclick="filtrarDados()">
								<i class="fal fa-filter" size="40px" aria-hidden="true"></i>  Filtrar
							</button>		
			
							<button type="button" id='btnFiltrar' class="btn btn-outline-info waves-effect waves-themed" onclick="window.history.back()">
								<i class="fal fa-arrow-left" size="40px" aria-hidden="true"></i>  Voltar
							</button>	

						</div>
					</div>
				</div>
			</div>
		</div>
	</div>