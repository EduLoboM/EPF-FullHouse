<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teste API Steam</title>
    <link rel="stylesheet" href="/static/css/game_test.css">
</head>
<body>
    <div class="api-status {{ 'working' if games else 'failed' }}">
        Status API Steam: {{ 'FUNCIONANDO' if games else 'FALHOU' }}
    </div>

    <div class="game-grid">
        % for game in games:
        <div class="game-card">
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
                <p>Lançamento: {{game.release_date}}</p>
                
                <div class="screenshots">
                    % if game.first_image_url:
                    <img src="{{game.first_image_url}}" alt="Screenshot 1" class="screenshot">
                    % end
                    % if game.second_image_url:
                    <img src="{{game.second_image_url}}" alt="Screenshot 2" class="screenshot">
                    % end
                </div>
                
                % if game.trailer_url:
                <div class="trailer-container">
                    <video controls class="trailer">
                        <source src="{{game.trailer_url}}" type="video/mp4">
                        Seu navegador não suporta vídeos.
                    </video>
                </div>
                % end
            </div>
        </div>
        % end
    </div>
</body>
</html>