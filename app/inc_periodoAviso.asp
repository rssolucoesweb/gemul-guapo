<%
	'Aviso na própria tela quando a funcionalidade está fora do período (Matrícula > Configurações)
	'(strPeriodoMensagem preenchida pela página antes do include; a gravação é barrada no _cod)
	if strPeriodoMensagem <> "" then
		strPeriodoMensagemJs = replace(replace(replace(strPeriodoMensagem, "\", "\\"), "'", "\'"), vbcrlf, " ")
%>
<script>
	(function(){
		var msg = '<%=strPeriodoMensagemJs%>';
		function avisoPeriodo(){
			try {
			var main = document.getElementById('js-page-content');
			if (main) {
				var div = document.createElement('div');
				div.className = 'alert alert-warning d-flex align-items-center';
				div.setAttribute('role', 'alert');
				div.innerHTML = '<i class="fal fa-clock fa-2x mr-3"></i><div><strong>Fora do período de funcionamento.</strong><br><span></span><br><small>Consulta liberada; alterações não serão gravadas.</small></div>';
				div.querySelector('span').textContent = msg;
				var ref = main.querySelector('.subheader');
				//o subheader pode estar dentro do <form>: insere no mesmo pai dele
				if (ref) ref.parentNode.insertBefore(div, ref.nextSibling); else main.insertBefore(div, main.firstChild);
			}
			} catch (e) {}
			alert('Fora do período de funcionamento.\n\n' + msg);
		}
		if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', avisoPeriodo); else avisoPeriodo();
	})();
</script>
<%
	end if
%>
