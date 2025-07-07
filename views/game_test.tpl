<!DOCTYPE html>
<html lang="pt-br">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Teste API Steam</title>
  <link rel="stylesheet" href="/static/css/game_test.css">
  <img src="/static/img/FULL-removebg-preview_1.webp" alt="Full House Logo" class="full-house">
</head>
<body>
  <!-- Status da API + botão de perfil -->
  <div class="api-status-container" style="display: flex; justify-content: space-between; align-items: center; padding: 1rem;">
    <div class="api-status {{ 'working' if games else 'failed' }}">
      Status API Steam: {{ 'FUNCIONANDO' if games else 'FALHOU' }}
    </div>
    <!-- Botão único para Meu Perfil -->
    <button class="btn-profile" onclick="window.location.href='{{'/admin' if user and user.get('is_admin', False) else '/profile'}}'">
      Meu Perfil
    </button>
  </div>
  <div class="game-grid">
    % for game in games:
    <div class="game-card" onclick="redirectToGame('{{game.steam_id}}')" style="cursor: pointer;">
      % if game.poster_url:
      <img src="{{game.poster_url}}" alt="{{game.name}}" class="game-poster">
      % else:
      <div class="game-poster" style="background: #1a1a1a; display: flex; align-items: center; justify-content: center; color: #66c0f4; font-weight: bold;">
        Poster não disponível
      </div>
      % end
      <div class="game-content">
        <h2 class="game-title">{{game.name}}</h2>
        <p class="game-price">{{game.price}}</p>
      </div>
    </div>
    % end
  </div>
  <script>
    function redirectToGame(appid) {
      window.location.href = `/game/${appid}`;
    }
  </script>
</body>
</html>
