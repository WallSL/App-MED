# App MED – Playground SwiftUI do zero

Este repositório entrega uma experiência completa de planejamento de estudos reconstruída especificamente para o **Swift Playgrounds** (iPad ou Mac). Tudo roda inteiramente em memória e não depende de frameworks indisponíveis no iPad, então basta importar o playground e começar a testar.

## O que vem pronto

- **Resumo semanal** com metas, sessões do dia, tarefas urgentes e notas recentes.
- **Planejador de tarefas** filtrável por status, agrupado por disciplina.
- **Sessões de estudo** com timer integrado, registro de tempo real e anotações pós-estudo.
- **Relatórios de notas** com médias gerais e por disciplina.

Todos os dados exibidos são exemplos inspirados no curso de medicina e podem ser usados como ponto de partida para personalizar o seu fluxo.

## Estrutura criada do zero

```
AppMED.playground/
├── Contents.swift                 # Live View apontando para a nova interface
└── Sources/
    ├── Models/                    # Modelos simples: Subject, StudyTask, StudySession, ExamGrade, StudyGoal
    ├── Store/                     # StudyPlannerStore observável com dados de exemplo e automações
    ├── Utilities/                 # Formatadores de data/hora reutilizados nas telas
    └── Views/                     # Novas telas SwiftUI (Overview, Tasks, Sessions, Timer, Reports)
```

## Como importar no Swift Playgrounds (iPad)

1. Envie a pasta `AppMED.playground` para o seu iPad (AirDrop, iCloud Drive ou cabo).
2. Abra o app **Swift Playgrounds** e toque em **Importar Playground**.
3. Escolha `AppMED.playground`. O live view é carregado automaticamente com as quatro abas reconstruídas.
4. Use o timer, filtre tarefas e navegue pelos relatórios. As alterações ficam em memória enquanto o playground estiver aberto.

> Dica: se preferir iniciar um playground em branco no iPad, crie um novo projeto vazio e copie o conteúdo das pastas `Sources` e do `Contents.swift` para ele.

## Executar no Mac

1. Abra `AppMED.playground` no **Xcode 15+** ou no **Swift Playgrounds para macOS**.
2. Garanta que o painel **Live View** esteja ativo (`Editor > Live View`).
3. Faça alterações em `Sources/` e observe a atualização imediata da interface.

## Próximas ideias para evoluir

- Persistir dados localmente (Core Data, SwiftData ou arquivos JSON).
- Permitir criação e edição de tarefas/sessões/notas diretamente pelo usuário.
- Adicionar gráficos com **Swift Charts** para visualizar evolução de notas e carga horária.
- Integrar notificações locais e widgets no iPadOS.

Comece a partir desta base 100% compatível com o Swift Playgrounds e adapte-a às necessidades específicas do seu curso!
