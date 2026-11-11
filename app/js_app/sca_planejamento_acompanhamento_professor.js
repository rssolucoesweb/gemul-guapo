$( document ).ready(function() {

    $("#btnReplicar").click(function() {

        event.preventDefault();
        
        var checkboxes = document.getElementsByName("chkTurma");
        var checkboxesChecked = [];
        var contChecked = 0;
        // loop over them all
        for (var i=0; i<checkboxes.length; i++) {
        // And stick the checked ones onto an array...
        if (checkboxes[i].checked) {
            contChecked ++
        }
        }   
        
        if (contChecked === 0 ) {
            alert("Nenhuma turma foi selecionada.")
            return
        } else {

            $("#btnReplicar").attr("disabled",true);
            $("#btnReplicar").html("Aguarde... Replicando a aula...");    
        
            replicar( $('#codigoPlanejamentoProf').val());
        }

    })

});

function abrePlanejamento(aula, cod_curso, curso, cod_periodo, periodo, cod_disciplina, disciplina, cod_turma, turma, bolAulaExtra, dataAula) {
    var frm = document.getElementById("frm");
    frm.txtCodCurso.value			= cod_curso;
    frm.txtCurso.value				= curso;
    frm.txtCodPeriodo.value			= cod_periodo;
    frm.txtPeriodo.value			= periodo;
    frm.txtCodDisciplina.value		= cod_disciplina;
    frm.txtDisciplina.value			= disciplina;
    frm.txtCodTurma.value			= cod_turma;
    frm.txtTurma.value				= turma;
    frm.bolAulaExtra.value			= bolAulaExtra;
    frm.dataAula.value				= dataAula;

    $('.form-control').removeAttr('disabled');
    document.getElementById('frm').action = 'sca_planejamento_professor_aula.asp?retorno=sca_planejamento_acompanhamento_professor.asp?cmbMes=' + $("#cmbMes").val() + '&aula=' + aula;
    document.getElementById('frm').submit();
}

// function validar(cod_disciplina) {

//     if (!confirm("Confirma a validação de TODOS os planejamentos dessa disciplina?")) {
//         return;
//     }

//     var frm = document.getElementById("frm");
//     $('.form-control').removeAttr('disabled');
	
//     document.getElementById('frm').action = 'sca_planejamento_acompanhamento_professor_cod.asp?acao=V&cod_disciplina=' + cod_disciplina;
//     document.getElementById('frm').submit();
// }


function validarTurma(cod_disciplina, codTurma, aulas) {

    if (!confirm("Confirma a validação de TODOS os planejamentos dessa Turma?")) {
        return;
    }

    var frm = document.getElementById("frm");
    $('.form-control').removeAttr('disabled');
	
    document.getElementById('frm').action = 'sca_planejamento_acompanhamento_professor_cod.asp?acao=VT&cod_disciplina=' + cod_disciplina + '&codTurma=' + codTurma + '&aulas=' + aulas;
    document.getElementById('frm').submit();
}

function desvalidarTurma(cod_disciplina, codTurma, aulas) {

    if (!confirm("Confirma a desvalidação de TODOS os planejamentos dessa Turma?")) {
        return;
    }

    var frm = document.getElementById("frm");
    $('.form-control').removeAttr('disabled');
	
    document.getElementById('frm').action = 'sca_planejamento_acompanhamento_professor_cod.asp?acao=DT&cod_disciplina=' + cod_disciplina + '&codTurma=' + codTurma + '&aulas=' + aulas;
    document.getElementById('frm').submit();
}


function abreModal(aula, cod_curso, curso, cod_periodo, periodo, cod_disciplina, disciplina, cod_turno, cod_turma, turma, codigoPlanejamentoProf, bolAulaExtra, dataAulaExtra, dataAula) {
    if (codigoPlanejamentoProf !== "0") {
        $('#modalReplicarAula').modal('show');
        $('#codigoPlanejamentoProf').val(codigoPlanejamentoProf);
        if (bolAulaExtra) {
            $('.spanAulaExtra').html("sábado letivo ")
            $('.numAula').html(dataAulaExtra)
        }else {
            $('.spanAulaExtra').html("")
            $('.numAula').html(aula)
        }
        
        $('#divListaTurmas').html('carregando turmas...');
        $.post( "sca_planejamento_acompanhamento_professor_cod.asp", 
        { 
            txtAnoLetivo: $("#txtHiddenAnoLetivo").val(),
            txtSemestre: $("#txtSemestre").val(),
            codPeriodo: cod_periodo,
            txtCodProfessor: $("#txtCodProfessor").val(),
            cod_disciplina: cod_disciplina,
	    cod_turno: cod_turno,
            codTurma: cod_turma,
            aula: aula,
            bolAulaExtra: bolAulaExtra,
		dataAula: dataAula,
            acao: 'listarTurmasDisciplinaProfessor'
        }
        )
        .done(function( data ) {
            
            $("#divListaTurmas").html(data);
            
        })
        .fail(function() {
            toastr.error("Ocorreu um erro");
        }); 
        
    }else {
        abrePlanejamento(aula, cod_curso, curso, cod_periodo, periodo, cod_disciplina, disciplina, cod_turma, turma, bolAulaExtra, dataAula)
    }

    $("#btnVisualizarPlanejamento").click(function() {
        event.preventDefault();
        abrePlanejamento(aula, cod_curso, curso, cod_periodo, periodo, cod_disciplina, disciplina, cod_turma, turma, bolAulaExtra, dataAula)
    });

}

function replicar(codigoPlanejamentoProf) {
    document.getElementById('frm').action = 'sca_planejamento_acompanhamento_professor_cod.asp?acao=R&codigoPlanejamentoProf=' + codigoPlanejamentoProf;
    document.getElementById('frm').submit();    
}

