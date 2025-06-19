% rebase('layout', title='Formulário Usuário')

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="stylesheet" href="/css/user-form.css">

<section class="form-section">
    <div class="form-header">
        <h1>{{'Editar Usuário' if user else 'Criar Usuário'}}</h1>
        <div class="icon-container">
        </div>
    </div>
    
    <form action="{{action}}" method="post" class="form-container">
        % if user:
            <input type="hidden" name="id" value="{{user.id}}">
        % end
        
        <div class="form-grid">
            <div class="form-group">
                <label for="name">Nome Completo:</label>
                <input type="text" id="name" name="name" required 
                    value="{{user.name if user else ''}}"
                    placeholder="Digite seu nome completo">
                <i class="fas fa-user input-icon"></i>
            </div>
            
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required 
                    value="{{user.email if user else ''}}"
                    placeholder="exemplo@email.com">
                <i class="fas fa-envelope input-icon"></i>
            </div>
            
            <div class="form-group">
                <label for="birthdate">Data de Nascimento:</label>
                <input type="date" id="birthdate" name="birthdate" required
                    value="{{user.birthdate if user else ''}}">
                <i class="fas fa-calendar input-icon"></i>
            </div>

            <div class="form-group">
                <label for="password">Senha:</label>
                <input type="password" id="password" name="password" 
                    {{'required' if not user else ''}}
                    placeholder="{{'Deixe em branco para manter atual' if user else 'Digite sua senha'}}">
                <i class="fas fa-lock input-icon"></i>
            </div>
        </div>

        <div class="form-actions">
            <button type="submit" class="btn-submit">
                <i class="fas fa-check"></i> {{'Atualizar' if user else 'Criar Conta'}}
            </button>
            <a href="/users" class="btn-cancel">
                <i class="fas fa-times"></i> Cancelar
            </a>
        </div>
    </form>
</section>