<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>Editar Perfil – {{user['name']}}</title>
  <link rel="stylesheet" href="/css/profile.css">
</head>
<body>
  <header class="profile-header">
    <div class="header-actions-left">
      <a href="/profile" class="btn-back">← Voltar ao Perfil</a>
      <span class="header-title">Editar Perfil</span>
    </div>
    <div class="header-actions-right">
      <a href="/logout" class="btn-logout">Logout</a>
    </div>
  </header>

  <main class="profile-main">
    <section class="edit-profile-section">
      <form action="/profile/edit" method="post" class="edit-profile-form">
        <div class="form-group">
          <label for="name">Nome</label>
          <input id="name" name="name" type="text" required
                 value="{{user['name']}}">
        </div>
        <div class="form-group">
          <label for="email">Email</label>
          <input id="email" name="email" type="email" required
                 value="{{user['email']}}">
        </div>
        <div class="form-group">
          <label for="birthdate">Data de Nascimento</label>
          <input id="birthdate" name="birthdate" type="date" required
                 value="{{user['birthdate']}}">
        </div>
        <div class="form-group">
          <label for="password">Senha (deixe em branco para manter)</label>
          <input id="password" name="password" type="password" placeholder="Nova senha">
        </div>

        <div class="form-actions">
          <button type="submit" class="btn btn-primary">Salvar Alterações</button>
          <a href="/profile" class="btn btn-secondary">Cancelar</a>
        </div>
      </form>
    </section>
  </main>
</body>
</html>
