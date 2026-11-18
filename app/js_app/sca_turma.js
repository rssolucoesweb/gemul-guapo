	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}


	function abreConsultaVincularTipoAC(caminho){
		window.open(caminho,"abreConsulta","top=5,left=5,height=600,width=1000,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (acao=="E") {
			var r = confirm("Deseja excluir esse registro?");
			if (r == true) {
			 frm.action="sca_turma_cod.asp?acao=" + acao;
				frm.submit();
				return true;
			} else {
			 return false;
			}	
			
		}else{	
			if (frm.txtAnoLetivo.value == "") {
				alert("O Ano Letivo deve ser informado !");
				frm.txtAnoLetivo.focus();
				return false;
			}
			if (frm.cmbSemestre.value == "0") {
				alert("O Semestre deve ser informada !");
				frm.cmbSemestre.focus();
				return false;
			}
			if (frm.cmbCurso.value == "0") {
				alert("O Curso deve ser informado !");
				frm.cmbCurso.focus();
				return false;
			}
			if (frm.cmbPeriodo.value == "0") {
				alert("O Período deve ser informado !");
				frm.cmbPeriodo.focus();
				return false;
			}
			
			if (frm.txtSala.value == "") {
				alert("A Sala deve ser informada !");
				frm.txtSala.focus();
				return false;
			}
			if (frm.cmbTurno.value == "0") {
				alert("O Turno deve ser informado !");
				frm.cmbTurno.focus();
				return false;
			}
			
			
			if (frm.cmbGrade.value == "0") {
				alert("A matriz/grade deve ser informada !");
				frm.cmbGrade.focus();
				return false;
			}

			
			
			if (frm.txtAno.value == "") {
				alert("O Ano criação deve ser informado !");
				frm.txtAno.focus();
				return false;
			}
			
			
			if (frm.cmbSemestreCriacao.value == "0") {
				alert("O semestre criação deve ser informado !");
				frm.cmbSemestreCriacao.focus();
				return false;
			}
			if (frm.txtNomeTurma.value == "") {
				alert("O Nome da Turma deve ser informada !");
				frm.txtNomeTurma.focus();
				return false;
			}
			
			if (frm.txtCapacidade.value == "") {
				alert("O Capacidade deve ser informada !");
				frm.txtCapacidade.focus();
				return false;
			}
					
			
			if (frm.txtCapacidade.value < frm.txtVagasMatriculas.value) {
				alert("O número de vagas não poderá ser superior que a Capacidade da turma !");
				frm.txtCapacidade.focus();
				return false;
			}

			frm.action="sca_turma_cod.asp?acao=" + acao;
			frm.submit();
			return true;
		}
 	}
	
function carregaTiposAtivCompl(strCodigosAtivCompl) {

    var hidden = document.getElementById("txtHiddenCodigoAtivCompl");

    var codigos = [];

    // já existentes
    if (hidden.value != "") {
        codigos = hidden.value.split(",");
    }

    // novos
    if (strCodigosAtivCompl != "") {

        var novos = strCodigosAtivCompl.split(",");

        for (var i = 0; i < novos.length; i++) {

            var codigo = novos[i];

            // adiciona somente se não existir
            if (codigos.indexOf(codigo) == -1) {
                codigos.push(codigo);
            }
        }
    }

    // valida máximo de 6
    if (codigos.length > 6) {
        alert("Somente pode ser vinculado até 6 tipos de atividade complementar!");
        return false;
    }

    hidden.value = codigos.join(",");

    document.getElementById("txtAlteracaoTipoAtvCompl").value = "S";

    frm.submit();
}

function removerLinha(obj) {

    // Capturamos a referência da TR (linha) pai do objeto
    var objTR = obj.parentNode.parentNode;
    // Capturamos a referência da TABLE (tabela) pai da linha
    var objTable = objTR.parentNode;
    // Capturamos o índice da linha
    var indexTR = objTR.rowIndex;
    // Chamamos o método de remoção de linha nativo do JavaScript, passando como parâmetro o índice da linha  
    objTable.deleteRow(indexTR);

    var form = document.getElementById("frm");
    var strCodigosAtivCompl = "";

    //*****verifica se uma atividade complementar foi selecionado

    document.getElementById("txtHiddenCodigoAtivCompl").value = "";

    for (var i = 0; i < form.elements.length; i++) {
        //verifica todos os checkbox
        if (form.elements[i].type == "checkbox") {
            if (form.elements[i].name == "chkCodigosAtivCompl") {
                //verifica se o checkbox está marcado
                if (form.elements[i].checked && !form.elements[i].disabled) {
                    if (strCodigosAtivCompl == "")
                        strCodigosAtivCompl = form.elements[i].value;
                    else
                        strCodigosAtivCompl = strCodigosAtivCompl + "," + form.elements[i].value;
                }
            }
        }
    }

    if (strCodigosAtivCompl != "") {

        if (document.getElementById("txtHiddenCodigoAtivCompl").value == "") {
            document.getElementById("txtHiddenCodigoAtivCompl").value = strCodigosAtivCompl;
        } else {
            strCodigosAtivCompl_aux = strCodigosAtivCompl + "," + document.getElementById("txtHiddenCodigoAtivCompl").value;
            document.getElementById("txtHiddenCodigoAtivCompl").value = strCodigosAtivCompl_aux;
        }
		
    }

    document.getElementById("txtAlteracaoTipoAtvCompl").value = "S"
}
