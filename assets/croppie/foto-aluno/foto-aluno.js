//********* 
//********* WEBCAM AND CROPPIE IMAGE
//*********

//********* WEBCAM

Webcam.set({
    width: 320,
    height: 240,
    image_format: 'jpeg',
    jpeg_quality: 90
});

function attachWebCam() {
    $("#my_camera").show();
    Webcam.attach('#my_camera');
    //$(".upload-msg").hide();
    $('.upload-fotoAlunoSIGE').removeClass('ready');
    $("#btnCaptutarImagem").show();
}

function take_snapshot() {
    Webcam.snap(function (data_uri) {
        document.getElementById('fileFromWebCam').value = data_uri
    });
    $("#my_camera").hide();
}


//********* CROPPIE IMAGE

var FotoAlunoSIGE = (function () {

    function output(node) {
        var existing = $('#result .croppie-result');
        if (existing.length > 0) {
            existing[0].parentNode.replaceChild(node, existing[0]);
        }
        else {
            $('#result')[0].appendChild(node);
        }
    }

    function popupResult(result) {
        var html;
        if (result.html) {
            html = result.html;
        }
        if (result.src) {
            html = '<img id="fotoAluno" src="' + result.src + '" />';
        }
        //swal({
        //	title: '',
        //	html: true,
        //	text: html,
        //	allowOutsideClick: true
        //});
        //setTimeout(function(){
        //	$('.sweet-alert').css('margin', function() {
        //		var top = -1 * ($(this).height() / 2),
        //			left = -1 * ($(this).width() / 2);

        //		return top + 'px 0 0 ' + left + 'px';
        //	});
        //}, 1);
        $("#txtFotoAlunoHidden").val(result.src);
        $("#divFoto").html(html);
        $("#modalEditorFoto").modal('toggle');

    }

    function fotoAlunoSIGEUpload() {
        var $uploadCrop;

        function readFile(input) {

            //$(".upload-msg").hide();
            $('.upload-fotoAlunoSIGE').addClass('ready');

            if (input.files && input.files[0]) {

                var reader = new FileReader();

                reader.onload = function (e) {
                    console.log(e.target.result);
                    $uploadCrop.croppie('bind', {
                        url: e.target.result
                    }).then(function () {
                        console.log('jQuery bind complete');
                        console.log("file:");
                        console.log(e.target.result);
                    });

                }
                reader.readAsDataURL(input.files[0]);
                $("#my_camera").hide();
                $("#btnCaptutarImagem").hide();
            }
            else {
                swal("Sorry - you're browser doesn't support the FileReader API");
            }
        }

        function readWebCam() {
            $('.upload-fotoAlunoSIGE').addClass('ready');
            $uploadCrop.croppie('bind', {
                url: document.getElementById("fileFromWebCam").value
            }).then(function () {
                console.log('jQuery bind complete');
            });

        }

        $uploadCrop = $('#upload-fotoAlunoSIGE').croppie({
            viewport: {
                width: 120,
                height: 170,
                type: 'base64'
            },
            enableExif: true
        });

        $('#upload').on('change', function () { readFile(this); });
        $('#btnCaptutarImagem').on('click', function () {
            readWebCam();
            $("#btnRecortarImagem").show();
            $('#btnCaptutarImagem').hide();

        });
        $('#btnCancelarImagem').on('click', function () {
            cancelarImagem();
            $('#btnCancelarImagem').hide();
        });
        $('#btnImagemDoComputador').on('click', function () {
            $("#btnRecortarImagem").show();
            $('#divLocalImagem').hide();
            $('#btnCancelarImagem').show();
        });
        $('#btnImagemDaWebCam').on('click', function () {
            $("#btnRecortarImagem").hide();
            $('#divLocalImagem').hide();
            $('#btnCancelarImagem').show();
        });

        $('.upload-result').on('click', function (ev) {
            $uploadCrop.croppie('result', {
                type: 'base64',
                size: 'viewport'
            }).then(function (resp) {
                popupResult({
                    src: resp
                });
            });
        });
    }

    function init() {
        cancelarImagem();
        fotoAlunoSIGEUpload();
    }

    function cancelarImagem() {
        $("#my_camera").hide();
        $("#btnCaptutarImagem").hide();
        $("#btnRecortarImagem").hide();
        //$(".upload-msg").show();
        $('.upload-fotoAlunoSIGE').removeClass('ready');
        $('#divLocalImagem').show();
        $('#btnCancelarImagem').hide();
    }

    return {
        init: init
    };
})();


// Full version of `log` that:
//  * Prevents errors on console methods when no console present.
//  * Exposes a global 'log' function that preserves line numbering and formatting.
(function () {
    var method;
    var noop = function () { };
    var methods = [
        'assert', 'clear', 'count', 'debug', 'dir', 'dirxml', 'error',
        'exception', 'group', 'groupCollapsed', 'groupEnd', 'info', 'log',
        'markTimeline', 'profile', 'profileEnd', 'table', 'time', 'timeEnd',
        'timeStamp', 'trace', 'warn'
    ];
    var length = methods.length;
    var console = (window.console = window.console || {});

    while (length--) {
        method = methods[length];

        // Only stub undefined methods.
        if (!console[method]) {
            console[method] = noop;
        }
    }


    if (Function.prototype.bind) {
        window.log = Function.prototype.bind.call(console.log, console);
    }
    else {
        window.log = function () {
            Function.prototype.apply.call(console.log, console, arguments);
        };
    }
})();
