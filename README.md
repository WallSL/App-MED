# App MED – Playground SwiftUI em um único arquivo

Este repositório traz uma experiência completa de planejamento de estudos para medicina pensada para o **Swift Playgrounds** (iPad ou Mac). Toda a lógica, modelos, dados de exemplo e interface foram condensados dentro de **`Contents.swift`**, o que facilita importar, editar e compartilhar o playground sem se preocupar com estruturas adicionais.

## Recursos prontos para usar

- **Resumo semanal** com metas, sessões do dia, tarefas urgentes e notas recentes.
- **Planejador de tarefas** filtrável por status e agrupado por disciplina.
- **Sessões de estudo** com timer integrado, registro do tempo real e anotações pós-estudo.
- **Relatórios de provas** destacando médias gerais, desempenho por disciplina e histórico de notas.

Os dados exibidos são exemplos inspirados no curso de medicina e podem ser personalizados diretamente dentro do arquivo.

## Estrutura do playground

```
AppMED.playground/
└── Contents.swift   # Código completo do app SwiftUI pronto para rodar
```

## Como importar no Swift Playgrounds (iPad)

1. Envie a pasta `AppMED.playground` para o seu iPad (AirDrop, iCloud Drive ou cabo).
2. Abra o app **Swift Playgrounds** e toque em **Importar Playground**.
3. Escolha `AppMED.playground`. O live view carregará automaticamente as quatro abas reconstruídas.
4. Faça ajustes diretamente em `Contents.swift`, execute o timer, filtre tarefas e explore os relatórios.

> Dica: se preferir começar de um playground em branco no iPad, crie um novo projeto vazio e substitua o `Contents.swift` pelo arquivo deste repositório.

## Executar no Mac

1. Abra `AppMED.playground` no **Xcode 15+** ou no **Swift Playgrounds para macOS**.
2. Ative o painel **Live View** (`Editor > Live View`).
3. Edite `Contents.swift` e veja a interface atualizar instantaneamente.

## Próximos passos sugeridos

- Persistir dados localmente (SwiftData, Core Data ou arquivos JSON).
- Permitir criação e edição de tarefas, sessões e notas direto pela interface.
- Adicionar gráficos com **Swift Charts** para visualizar evolução de notas e carga horária.
- Integrar notificações locais e widgets específicos para iPadOS.

Use esta base 100% compatível com o Swift Playgrounds para evoluir o seu planejamento de estudos no iPad!
