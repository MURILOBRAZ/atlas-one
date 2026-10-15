# Atlas One · Mobile

Aplicativo Flutter do Atlas One (Android e Web).

A documentação completa (configuração do backend, banco Neon e endereço da API por plataforma) está no [README principal](../README.md).

```bash
flutter pub get
flutter run            # dispositivo/emulador selecionado
flutter run -d chrome  # navegador
flutter analyze
flutter test
```

O app espera a Atlas API rodando em `http://localhost:3333` (Web) ou `http://10.0.2.2:3333` (emulador Android). Veja `lib/core/config/api_config.dart`.
