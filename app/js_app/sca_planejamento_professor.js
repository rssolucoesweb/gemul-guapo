$( document ).ready(function() {

  
});

toastr.options = {
    "closeButton": true,
    "newestOnTop": false,
    "progressBar": true,
    "positionClass": "toast-top-right",
    "preventDuplicates": false,
    "onclick": null,
    "showDuration": "300",
    "hideDuration": "1000",
    "timeOut": "5000",
    "extendedTimeOut": "1000",
    "showEasing": "swing",
    "hideEasing": "linear",
    "showMethod": "fadeIn",
    "hideMethod": "fadeOut"
  }


function carregaAulas(diaSemana, aulas, data, bolAulaExtra) {
	$('#modalNovoItem').modal('show');
	
    $('#divListaAulas').html('carregando...');
    $.post( "sca_planejamento_professor_cod.asp", 
        { 
            diaDaSemana: diaSemana,
            aulasProfessor: aulas,
            bolAulaExtra: bolAulaExtra,
			dataAula: data,
            txtAnoLetivo: $("#txtAnoLetivo").val(),
			txtCodCurso: $("#txtCodCurso").val(),
			txtCurso: $("#txtCurso").val(),
			txtCodPeriodo: $("#txtCodPeriodo").val(),
			txtPeriodo: $("#txtPeriodo").val(),
			txtCodTurno: $("#txtCodTurno").val(),
			txtTurno: $("#txtTurno").val(),
			txtCodDisciplina: $("#txtCodDisciplina").val(),
			txtDisciplina: $("#txtDisciplina").val(),
			txtCodTurma: $("#txtCodTurma").val(),
			txtTurma: $("#txtTurma").val(),
			txtCodProfessor: $("#txtCodProfessor").val(),
			txtProfessor: $("#txtProfessor").val(),
			
			acao: 'carregaAulas'
        }
    )
    .done(function( data ) {

        $("#divListaAulas").html(data);
        //verificaSituacaoEdicao();
 
    })
    .fail(function() {
        toastr.error("Ocorreu um erro");
    }); 

}

function abrePlanejamento(aula,data,valido,bolAulaExtra) {

    if (bolAulaExtra) {
        aula = data
    }
 
    if ($("#pagina").val()==="pp") {
        //Planejamento do Professor
        $('.form-control').removeAttr('disabled');
        document.getElementById('frm').action = 'sca_planejamento_professor_aula.asp?aula=' + aula + '&bolAulaExtra=' + bolAulaExtra + '&dataAula=' + data
        document.getElementById('frm').submit();
    }else {
        //Conteúdo Ministrado
        if (valido==="S") {
            $('.form-control').removeAttr('disabled');
            document.getElementById('frm').action = 'sca_conteudo_ministrado.asp?aula=' + aula + '&bolAulaExtra=' + bolAulaExtra + '&dataAula=' + data
            document.getElementById('frm').submit(); 
        }else {
            alert("O planejamento do professor não foi validado.");
        }    
    }
}
