<div class="loader-container"  id="aguarde_salvando" >
  <div class="spinner"></div>
  <div class="text">aguarde estamos salvando as notas...</div>
</div>

<style>
.loader-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 200px;
  background: transparent; /* fundo transparente */
}

.spinner {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  border: 6px solid #d1d5db;
  border-top: 6px solid #334155;
  animation: spin 1s linear infinite;
  margin-bottom: 15px;
}

.text {
  font-family: Arial, sans-serif;
  font-size: 22px;
  color: #334155;
}

@keyframes spin {
  100% {
    transform: rotate(360deg);
  }
}
</style>