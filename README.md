# 📈 Ticker

**Ticker** é um aplicativo Flutter para gerenciamento de ativos financeiros. Com ele, é possível registrar investimentos, acompanhar a evolução da carteira e visualizar gráficos de distribuição. Os dados são armazenados localmente, com suporte para backup e importação do banco de dados.

## 🚀 Funcionalidades

- 📊 Visualização de resumo da carteira (valor investido, valor atual e variação);
- 🧩 Gráfico de pizza para distribuição dos ativos;
- 💾 Armazenamento local com SQLite;
- 📂 Backup e restauração do banco de dados;
- 🔄 Atualização automática dos preços via API [Brapi.dev](https://brapi.dev);
- 🌙 Suporte a temas claro e escuro;
- 🔐 Variáveis sensíveis (.env) para chaves de API;
- 🔀 Navegação com GoRouter;
- 🇧🇷 Formatação e idioma em português do Brasil (pt_BR).

## 🛠️ Tecnologias

- [Flutter](https://flutter.dev) 3.7.0+
- [sqflite](https://pub.dev/packages/sqflite)
- [dio](https://pub.dev/packages/dio)
- [go_router](https://pub.dev/packages/go_router)
- [flutter_dotenv](https://pub.dev/packages/flutter_dotenv)
- [fl_chart](https://pub.dev/packages/fl_chart)
- [file_picker](https://pub.dev/packages/file_picker)
- [share_plus](https://pub.dev/packages/share_plus)

## 📦 Estrutura de Pastas

```
lib/
├── database/                # Camada de persistência
├── services/                # Camada de lógica de negócio/API
├── theme/                   # Temas e paleta de cores
├── screens/                 # Telas principais: Home, Carteira, Configurações
├── widgets/                 # Componentes reutilizáveis
├── routes/                  # Configuração do GoRouter
├── main.dart                # Ponto de entrada do app
```

## 🧪 Como Rodar

1. **Clone o repositório:**

   ```bash
   git clone https://github.com/seu-usuario/ticker.git
   cd ticker
   ```

2. **Configure o arquivo `.env`:**

   Crie um arquivo `.env` na raiz do projeto com sua chave da API:

   ```
   BRAPI_API_KEY=sua-chave-aqui
   ```

3. **Instale as dependências:**

   ```bash
   flutter pub get
   ```

4. **Execute o app:**

   ```bash
   flutter run
   ```

## 🔒 Licença

Este projeto é licenciado sob os termos da **GNU General Public License v2.0 (GPLv2)**.

Você pode ver a licença completa em [`LICENSE`](./LICENSE) ou acessá-la diretamente [aqui](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html).

---

> Projeto desenvolvido com ❤️ por [@carlosxfelipe](https://github.com/carlosxfelipe). Contribuições são bem-vindas!
