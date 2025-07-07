<!DOCTYPE html>
<html lang="pt-BR">
% from services.steam_service import SteamService
% steam = SteamService()

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Perfil de {{user['name']}}</title>
  <link rel="stylesheet" href="/static/css/profile.css">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>

<body>
  <div class="container">
    <!-- Header com navegação -->
    <header class="header">
      <div class="nav-container">
        <img src="/static/img/FULL-removebg-preview_1.webp" alt="Full House Logo" class="full-house">
        <a href="/" class="btn-back">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M19 12H5M12 19l-7-7 7-7" />
          </svg>
          Voltar para jogos
        </a>
        <div class="header-actions">
          <a href="/profile/edit" class="btn-edit-profile">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
              <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
            </svg>
          </a>
          <a href="/logout" class="btn-logout">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
              <polyline points="16 17 21 12 16 7" />
              <line x1="21" y1="12" x2="9" y2="12" />
            </svg>
          </a>
        </div>
      </div>
    </header>

    <!-- Hero Section do Perfil -->
    <section class="hero">
      <div class="hero-background">
        <div class="hero-overlay"></div>
      </div>

      <div class="hero-content">
        <div class="hero-main">
          <div class="game-poster">
            <div class="poster-placeholder">
              <img src="/static/img/full-house-v0-aop4c27diq2f1 3.png" alt="Full House">
            </div>
          </div>

          <div class="game-info">
            <h1 class="game-title">{{user['name']}}</h1>

            <div class="action-buttons">
              <a href="/profile/edit" class="btn-primary">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                  <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                </svg>
                Editar Perfil
              </a>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Seção de Listas de Favoritos -->
    <section class="description-section">
      <div class="section-header">
        <h2>Minhas Listas de Favoritos</h2>
      </div>

      <div class="description-content">
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
      </div>
    </section>

    <!-- Seção de Reviews -->
    <section class="description-section">
      <div class="section-header">
        <h2>Minhas Reviews</h2>
      </div>

      <div class="description-content">
        % if reviews:
        <ul class="reviews-list">
          % for rev in reviews:
          <li class="review-item">
            <div class="review-header">
              <strong>Jogo:</strong>
              <a href="/game/{{rev.game_id}}" class="review-name">{{ steam.get_game_details(rev.game_id).name }}</a>
              <span class="review-rating">{{rev.rating}} / 4</span>
            </div>
            <p class="review-text">{{rev.text}}</p>
          </li>
          % end
        </ul>
        % else:
        <p class="empty">Você ainda não escreveu nenhuma review.</p>
        % end
      </div>
    </section>
  </div>
</body>

</html>