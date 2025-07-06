<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Listas de Jogos – {{ game.name }}</title>
  <link rel="stylesheet" href="/static/css/lists-styles.css">
</head>
<body style="--bg-image: url('{{ game.first_image_url if hasattr(game, 'first_image_url') else '' }}')">
  <div class="container">

    <!-- Header -->
    <header class="header">
      <div class="nav-container">
        <a href="/game/{{ game.steam_id }}" class="btn-back">← Voltar ao jogo</a>
        <h1>Minhas Listas</h1>
      </div>
    </header>

    <!-- Listas Existentes -->
    <section class="lists-section">
      <div class="section-header">
        <h2>Selecione uma lista para {{ game.name }}</h2>
      </div>

      <ul class="lists">
% if user_lists:
  % for lst in user_lists:
    <li class="list-item">
      <form action="/game/{{ game.steam_id }}/lista/{{ lst['id'] }}/adicionar" method="post">
        % if lst['has_game']:
          <button type="submit" class="btn-list remove">
            Remover de {{ lst['name'] }} ({{ lst['count'] }})
          </button>
        % else:
          <button type="submit" class="btn-list add">
            Adicionar em {{ lst['name'] }} ({{ lst['count'] }})
          </button>
        % end
      </form>
    </li>
  % end
% else:
    <p class="empty">Você ainda não possui nenhuma lista. Crie uma abaixo!</p>
% end
      </ul>
    </section>

    <!-- Formulário para criar nova lista -->
    <section class="new-list-section">
      <div class="section-header">
        <h2>Criar nova lista e adicionar</h2>
      </div>
      <form action="/game/{{ game.steam_id }}/lista/criar" method="post" class="new-list-form">
        <input type="text" name="name" placeholder="Nome da lista" required maxlength="50">
        <button type="submit" class="btn-primary">Criar e adicionar</button>
      </form>
    </section>

  </div>
</body>
</html>
