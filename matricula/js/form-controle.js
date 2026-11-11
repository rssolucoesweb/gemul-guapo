$(document).ready(function() {
    $('.form-horizontal').formValidation({
        icon: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        err: {
            container: 'tooltip'
        },
		
        fields: {
            'nome': {
                validators: {
                    notEmpty: {
                        message: 'Este campo é necessário.'
                    }
                }
            },
            'email': {
                validators: {
                    emailAddress: {
                        message: 'Este endereço não é valido.'
                    }
                }
            },
            'sexo': {
                validators: {
                    notEmpty: {
                        message: 'Este campo é necessário.'
                    }
                }
            },
            'arquivo': {
                validators: {
                    notEmpty: {
                        message: 'Este campo é necessário.'
                    }
                }
            },		
            'browsers[]': {
                validators: {
                    notEmpty: {
                        message: 'Este campo é necessário.'
                    }
                }
            }
        }
    })
        .on('success.form.fv', function(e) {
            $.ajax({
                type: "POST",
                url: "salvar.php",
                data: $('.form-horizontal').serialize(),
                success: function (retorno) {							
                    //$("#resposta").html(retorno);							
                    alert(retorno);						
                },
                error: function (retorno) {
                    alert(retorno);
                    //$("#resposta").html(retorno);
                }
            });
        });
});
