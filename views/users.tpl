%rebase('layout', title='Gestão de Usuários')

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="stylesheet" href="/css/users.css">

<section class="users-management">
    <div class="management-header">
        <div class="header-content">
            <h1>
                <i class="fas fa-users"></i> 
                Gestão de Usuários
            </h1>
        </div>
        <a href="/users/add" class="btn btn-primary">
            <i class="fas fa-plus-circle"></i> Novo Usuário
        </a>
    </div>

    <div class="management-stats">
        <div class="stat-card">
            <div>
                <h3>{{len(users)}}</h3>
                <p>Usuários Cadastrados</p>
            </div>
        </div>
    </div>

    <div class="user-table-container">
        <div class="table-header">
            <h2><i class="fas fa-list"></i> Lista de Usuários</h2>
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" placeholder="Buscar usuário...">
            </div>
        </div>

        <div class="table-responsive">
            <table class="user-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nome</th>
                        <th>Email</th>
                        <th>Data Nasc.</th>
                        <th class="text-center">Ações</th>
                    </tr>
                </thead>
                <tbody>
                    % for u in users:
                    <tr>
                        <td class="user-id">
                            <div class="id-badge">{{u.id}}</div>
                        </td>
                        <td>
                            <div class="user-info">
                                <div class="user-name">{{u.name}}</div>
                            </div>
                        </td>
                        <td><a href="mailto:{{u.email}}" class="email-link">{{u.email}}</a></td>
                        <td>{{u.birthdate}}</td>
                        <td class="text-center">
                            <div class="action-buttons">
                                <a href="/users/edit/{{u.id}}" class="btn-action btn-edit" title="Editar">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <form action="/users/delete/{{u.id}}" method="post" 
                                      onsubmit="return confirm('Tem certeza que deseja excluir este usuário?');">
                                    <button type="submit" class="btn-action btn-delete" title="Excluir">
                                        <i class="fas fa-trash-alt"></i>
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    % end
                </tbody>
            </table>
        </div>

        <div class="table-footer">
            <div class="pagination-info">
                Mostrando 1 a {{len(users)}} de {{len(users)}} registros
            </div>
            <div class="pagination-controls">
                <button class="btn-pagination disabled">
                    <i class="fas fa-chevron-left"></i>
                </button>
                <span class="current-page">1</span>
                <button class="btn-pagination">
                    <i class="fas fa-chevron-right"></i>
                </button>
            </div>
        </div>
    </div>
</section>