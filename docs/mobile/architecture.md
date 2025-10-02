# ARCHITECTURE

## Overview
Feature-first MVVM with Riverpod. Feature-first means each feature has its own folder with subfolders for View, ViewModel, and Data. This should ease scaling and simultaneous work. Read more about MVVM pattern in Flutter [here](https://docs.flutter.dev/app-architecture/guide).

Views render UI, ViewModels (Notifiers) hold logic, immutable State carries data. Data access is split into **repositories** (source of truth, caching data) and **services** (data loading, interactions outside app). Localizations via `gen_l10n` (l10n/en.arb, l10n/fi.arb).


## Project Tree
```text
lib/
  api/                # openapi-generator output (do not edit)
  app/
    main.dart
  core/               # shared items, like common widgets and utils
  features/
    <feature>/
      view/           # pages + local widgets
        widgets/
      viewmodel/      # <feature>_state.dart, <feature>_notifier.dart
      data/
        repositories/ # <feature>_repository.dart (interface), <feature>_repository_impl.dart (implementation)
        services/     # <feature>_service.dart
      providers.dart  # Riverpod wiring for the feature
  l10n/               # Localization strings, old values at to legacy/.../translations.dart
    en.arb
    fi.arb
  assets/
```


### Responsibilities
- View: UI only; observes providers and dispatches user intents.
- ViewModel (Notifier): state + UI logic; calls repositories; exposes commands.
- State: immutable snapshot of UI data (copyWith).
- Repository: source of truth; caching, retries, error shaping, mapping.
- Service: stateless IO (HTTP, files, platform); no app state.
- Providers: app's wiring panel; create and expose VM/Repo/Service.
- Core: truly shared utilities.


### Data Flow
View → ViewModel → Repository → Service → Repository → ViewModel → View

### Localization
- Add keys to l10n/en.arb and l10n/fi.arb.
- Wire AppLocalizations in MaterialApp.
- If users can switch language, drive MaterialApp.locale from a provider.

### Notes
- Assets declared in `pubspec.yaml`.