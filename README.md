# 🚀 QueroSerMB - Desafio Flutter Mercado Bitcoin

<div align="center">
  <h3>🏆 Aplicativo desenvolvido para o desafio técnico do Mercado Bitcoin</h3>
  <p>Explore exchanges de criptomoedas com dados em tempo real da CoinMarketCap</p>
  
  ![Flutter](https://img.shields.io/badge/Flutter-3.8.1+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
  ![Dart](https://img.shields.io/badge/Dart-3.8.1+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
  ![BLoC](https://img.shields.io/badge/BLoC-8.1.6+-1389FF?style=for-the-badge&logo=flutter&logoColor=white)
  ![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
  
  ![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-blue?style=flat-square)
  ![API](https://img.shields.io/badge/API-CoinMarketCap-orange?style=flat-square)
  ![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-green?style=flat-square)
</div>

---

## 📱 Sobre o Projeto

O **QueroSerMB** é um aplicativo Flutter que permite consultar e visualizar informações detalhadas sobre exchanges de criptomoedas utilizando a API da CoinMarketCap. O projeto foi desenvolvido seguindo as melhores práticas de arquitetura clean. 

### ✨ Funcionalidades

- 📊 **Lista de Exchanges**: Visualize exchanges com scroll infinito e cache otimizado
- 🔍 **Detalhes Completos**: Informações detalhadas com skeleton loading elegante
- 💰 **Assets da Exchange**: Lista de criptomoedas com preços em USD em tempo real
- 🔄 **Pull to Refresh**: Atualize dados puxando para baixo
- 🌐 **Rate Limiting**: Controle de requisições para evitar abuse da API
- 🎨 **Interface Intuitiva**: Design moderno seguindo Material Design 3
- 📱 **Responsivo**: Interface adaptável para diferentes tamanhos de tela
---

## 🏗️ Arquitetura

O projeto segue os princípios da **Clean Architecture** com **Flutter BLoC/Cubit** para gerenciamento de estado, **Dependency Injection** e **modularização por features**:

### 📁 Estrutura do Projeto

```
lib/
├── core/                          
│   ├── api_cache_service.dart     
│   ├── api_urls.dart
│   ├── cache_service.dart        
│   ├── dependency_injection.dart
│   ├── network_service.dart      
│   ├── navigation/   
│   │   └── app_router.dart
│   ├── strings/                 
│   │   └── app_strings.dart
│   └── theme/                   
│       ├── app_colors.dart
│       ├── app_sizes.dart
│       ├── app_text_styles.dart
│       ├── app_theme.dart
│       └── theme.dart
├── features/                 
│   ├── list_exchanges/          
│   │   ├── data/
│   │   │   ├── datasources/       
│   │   │   ├── models/             
│   │   │   └── repositories/      
│   │   ├── domain/
│   │   │   ├── entities/        
│   │   │   ├── repositories/       
│   │   │   └── usecases/           
│   │   └── presentation/
│   │       ├── bloc/               
│   │       ├── pages/             
│   │       └── widgets/            
│   └── detail_exchanges/           
│       ├── data/
│       │   ├── datasources/    
│       │   ├── models/           
│       │   └── repositories/ 
│       ├── domain/
│       │   ├── entities/         
│       │   ├── repositories/     
│       │   └── usecases/         
│       └── presentation/
│           ├── bloc/
│           ├── cubit/
│           ├── pages/
│           └── widgets/
└── main.dart  
```

## 🧪 Testes

O projeto possui uma cobertura abrangente de testes seguindo as melhores práticas:

### 📊 Tipos de Testes

- **✅ Testes Unitários** - 63 testes cobrindo entidades, use cases, blocs/cubits e strings
- **🎨 Testes Golden** - 16 testes de widgets para garantir consistência visual
- **🤖 Testes Robot Pattern** - 24 testes de UI automatizados para fluxos completos
- **🔧 Testes de Widget** - 4 testes automatizados de renderização e interação
- **📱 Testes de Tela** - 1 teste placeholder (golden de telas desabilitados temporariamente)

### 🚀 Executar Testes

```bash
# Todos os testes
flutter test

# Testes específicos
flutter test test/robot/              # Testes Robot
flutter test test/golden/widgets/     # Testes Golden de widgets
flutter test test/features/           # Testes unitários

# Com relatório detalhado
flutter test --reporter=expanded
```

## 🚀 Como Executar

### Pré-requisitos

- Flutter SDK (versão 3.8.1 ou superior)
- Dart SDK
- Android Studio / VS Code com extensões do Flutter
- API Key da CoinMarketCap ([obtenha aqui](https://coinmarketcap.com/api/))

### 📦 Instalação

1. **Clone o repositório**
   ```bash
   git clone https://github.com/feliperius/querosermb.git
   cd querosermb
   ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```
3. **Execute o aplicativo**
   ```bash
   # Para desenvolvimento
   flutter run
   
   # Para release
   flutter run --release
   ```

### 👨🏻‍💻 Sobre mim
Desenvolvedor Mobile com **10+ anos de experiência**, entusiasta do mundo cripto e apaixonado por tecnologia. Já trabalhei em aplicativos de grandes empresas brasileiras como **PagBank**, **XP**, **Rico**, **Caixa Seguros** entre outras.

### 💼 Experiência Técnica
- 📱 **Mobile**: Flutter, React Native, iOS (Swift), Android (Kotlin)
- 🏗️ **Arquitetura**: Clean Architecture, MVVM, MVI, Redux
- 🎯 **Estado**: BLoC, Provider, Riverpod, MobX
- 🧪 **Testes**: Unit, Widget, Integration, TDD
- 🔧 **DevOps**: CI/CD, Firebase, AWS, Docker

### 🌟 Por que Mercado Bitcoin?
Estou **entusiasmado** com a oportunidade de contribuir com o time do Mercado Bitcoin, aplicando minha experiência em fintech e paixão por criptomoedas para construir produtos inovadores que transformem o mercado brasileiro.

---
## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---