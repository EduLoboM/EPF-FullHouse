<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>Perfil de {{user['name']}}</title>
  <link rel="stylesheet" href="/css/profile.css">
</head>
<body>
  <header class="profile-header">
    <h1>Olá, {{user['name']}}</h1>
    <a href="/" class="btn-back">← Voltar para os jogos</a>
  </header>

  <main class="profile-main">
    <!-- Seção de Listas de Favoritos -->
    <section class="favorites-section">
      <h2>Minhas Listas de Favoritos</h2>

      % if favorite_lists:
      <div class="favorite-lists">
        % for item in favorite_lists:
        % lst = item['list']
        % games = item['games']
        <div class="fav-list-card">
          <h3>{{lst.name}}</h3>

          % if games:
          <ul class="games-list">
            % for game in games:
            % if game:
            <li>
              <a href="/game/{{game.steam_id}}">
                {{game.name}}
              </a>
            </li>
            % else:
            <li class="empty">Jogo não encontrado</li>
            % end
            % end
          </ul>
          % else:
          <p class="empty">Nenhum jogo nesta lista.</p>
          % end
        </div>
        % end
      </div>
      % else:
      <p class="empty">Você ainda não criou nenhuma lista de favoritos.</p>
      % end
    </section>

    <!-- Seção de Reviews -->
    <section class="reviews-section">
      <h2>Minhas Reviews</h2>

      % if reviews:
      <ul class="reviews-list">
        % for rev in reviews:
        <li class="review-item">
          <div class="review-header">
            <strong>Jogo:</strong>
            <a href="/game/{{rev.game_id}}">Steam #{{rev.game_id}}</a>
            <span class="review-rating">{{rev.rating}} / 4</span>
          </div>
          <p class="review-text">{{rev.text}}</p>
        </li>
        % end
      </ul>
      % else:
      <p class="empty">Você ainda não escreveu nenhuma review.</p>
      % end
    </section>
  </main>
</body>
</html>
