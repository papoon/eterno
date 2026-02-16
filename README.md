# Wedding Guest Manager

**Wedding Guest Manager** é uma aplicação web elegante para gerir convidados de casamentos, RSVP online e check-in no dia do evento.  
A versão B2B suporta wedding planners com múltiplos eventos e planos de assinatura recorrentes.

---

## 🌟 Features

### Fase 1 — MVP (B2C / casamento único)

- Gestão de convidados (CRUD)
- Importação de convidados via CSV
- RSVP online para convidados
- Dashboard de confirmação de convidados
- Check-in no dia do casamento
- Pagamento único por casamento via Stripe
- Estatísticas simples: total de convidados, confirmados, recusados

### Fase 2 — B2B / Multi-evento

- Suporte para wedding planners com múltiplos casamentos
- Limite de eventos por plano de assinatura
- Dashboard multi-evento com métricas agregadas
- Exportação de relatórios CSV/PDF
- Alertas de limite de eventos e pagamento falhado
- Upgrade/downgrade de plano via Stripe
- Recorrência e SaaS para wedding planners

---

## 🧱 Arquitetura

Seguindo padrão **Clean Architecture / Laravel Service Layer**:

- **Controllers**: recebem requests, validam via FormRequest e chamam Actions  
- **Actions**: representam casos de uso (ex: `CreateWeddingAction`, `SubmitRSVPAction`)  
- **Services**: lógica de negócio reutilizável (ex: `RSVPService`, `CheckInService`)  
- **DTOs**: transportam dados entre Controller → Action → Service  
- **Enums**: estados fixos (ex: `RSVPStatus`, `PaymentStatus`)  
- **Policies**: autorização  
- **Blade Components**: UI consistente (Botões, Cards, Forms, Tables, Metrics)  

---

## 🎨 Design System

- Layout centrado (`max-w-5xl`)
- Tipografia elegante e consistente
- Paleta suave: rose-500, gray-50, gray-700
- Botões com `rounded-lg` e padding consistente
- Cards para agrupamento de conteúdo
- Inputs, forms, tabelas, métricas padronizados
- Check-in mode tablet-friendly e dark mode

---

## ⚙️ Stack Tecnológico

- Laravel 11  
- PHP 8+  
- MySQL / PostgreSQL  
- Tailwind CSS  
- Paddle (pagamento único e assinatura)  
- Blade Components  

---

## 🧪 Testes

- PHPUnit (unit + feature tests)  
- Testes por feature seguindo `TESTING_GUIDELINES.md`  
- Cobertura mínima: 80%  
- Actions e Services testados em prioridade  
- Mock de Paddle e emails  

---

## 🚀 Instalação Local

```bash
git clone https://github.com/papoon/eterno.git
cd eterno
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate
npm install
npm run dev
php artisan serve

Webhooks para planos de assinatura
```
🧩 Estrutura de Pastas
```
app/
 ├── Actions/
 ├── Services/
 ├── DTOs/
 ├── Enums/
 ├── Models/
 ├── Policies/
 └── Http/
      ├── Controllers/
      └── Requests/
resources/views/components/
 ├── button.blade.php
 ├── card.blade.php
 ├── input.blade.php
 ├── table.blade.php
 └── metric-card.blade.php
```
📝 Contribuição
Seguir padrões de arquitetura ([Architecture Guidelines](ARCHITECTURES_GUIDELINES.md))

Seguir regras de UI (UI_GUIDELINES.md)

Seguir regras de testes (TESTING_GUIDELINES.md)

Usar Actions → Services → DTOs

Mantém consistência na nomenclatura e estilo de código

📊 Roadmap
 MVP: casamento único, RSVP, check-in, pagamento único

 Fase 2: Multi-evento e B2B para wedding planners

 Upsell de features: SMS, seating planner, notificações avançadas

 Expansão internacional: Espanha, Brasil

💰 Modelo de Negócio
MVP: pagamento único por casamento (149–299€)

B2B: assinatura recorrente por plano (Starter / Pro / Enterprise)

Multi-evento → receita previsível e escalável

📚 Documentação
[Architecture Guidelines](ARCHITECTURES_GUIDELINES.md) — regras de código e camadas

UI_GUIDELINES.md — regras de interface

TESTING_GUIDELINES.md — regras e checklist de testes

[GitHub Copilot Instructions](.github/copilot-instructions.md) — instruções para GitHub Copilot e LLMs
