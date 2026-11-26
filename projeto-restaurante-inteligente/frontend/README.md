# Frontend — React + TypeScript

Interface web inicial do projeto, construída com React, TypeScript e Vite.

## Implementado nesta primeira etapa

- Dashboard resumido com contagem de mesas por estado.
- Listagem visual das mesas.
- Alteração do estado de uma mesa pela API.
- Layout responsivo para desktop e celular.

## Como executar

1. Instale Node.js LTS.
2. Na pasta `frontend`, execute:

```bash
npm install
npm run dev
```

3. Acesse o endereço local exibido pelo Vite (normalmente `http://localhost:5173`).
4. Inicie antes a API Spring Boot e configure o MySQL conforme o README do backend.

A URL da API pode ser definida em `.env`:

```env
VITE_API_URL=http://localhost:8080
```

> Esta primeira tela cobre o mapa operacional básico. Comanda de bebidas, painel completo do gestor e telas da equipe ainda estão no planejamento.
