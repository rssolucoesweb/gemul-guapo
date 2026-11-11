<style>
  #videoModalOverlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0,0,0,0.7);
    display: none;
    align-items: center;
    justify-content: center;
    z-index: 9999;
  }

  #videoModal {
    background: #000;
    padding: 10px;
    border-radius: 8px;
    max-width: 90%;
    max-height: 90%;
  }

  #videoModal video {
    max-width: 100%;
    max-height: 80vh;
  }

  #btnFecharVideo {
    color: #fff;
    text-align: right;
    cursor: pointer;
    font-size: 14px;
    margin-bottom: 5px;
  }
</style>

<div id="videoModalOverlay">
  <div id="videoModal">
    <div id="btnFecharVideo" onclick="fechaVideo()">✖ Fechar</div>
    <video id="videoPlayer" controls autoplay>
      Seu navegador não suporta vídeo HTML5.
    </video>
  </div>
</div>

<script>
  function abreVideo(nomeVideo) {
    var video = document.getElementById("videoPlayer");
    var overlay = document.getElementById("videoModalOverlay");

    // Ajuste o caminho se necessário
    video.src = nomeVideo;

    overlay.style.display = "flex";
    video.load();
    video.play();
  }

  function fechaVideo() {
    var video = document.getElementById("videoPlayer");
    var overlay = document.getElementById("videoModalOverlay");

    video.pause();
    video.src = "";
    overlay.style.display = "none";
  }
</script>