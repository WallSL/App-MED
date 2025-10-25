# App MED – Gestor de Estudos

Playground SwiftUI pronto para ser aberto no **Swift Playgrounds para iPad** ou no **Xcode**. Ele oferece um painel completo para organizar tarefas, sessões de estudo e notas de provas do curso de Medicina usando dados de exemplo em memória.

## Principais módulos

- **Dashboard** com visão consolidada das sessões do dia, tarefas prioritárias, metas e últimas notas.
- **Lista de tarefas** filtrável por status/prioridade, com criação rápida para novas atividades.
- **Agenda** que agrupa sessões planejadas por dia com detalhes de técnica, duração e observações.
- **Timer de sessão** estilo Pomodoro com registro de notas e salvamento no histórico.
- **Relatórios** com métricas de horas estudadas, progresso das metas e evolução das notas das provas.

## Estrutura do playground

```
AppMED.playground/
├── Contents.swift                 # Live View configurada para o conteúdo principal
└── Sources/
    ├── Models/                    # Dados de domínio: disciplinas, tarefas, sessões, metas, notas
    ├── Store/                     # `StudyDataStore` observável com dados de exemplo e cálculos auxiliares
    ├── Utilities/                 # Extensões de datas para intervalos e formatação
    └── Views/                     # Interfaces SwiftUI (Dashboard, Tarefas, Agenda, Timer, Relatórios)
```

Todo o código é `public` para facilitar reuso em outros Playgrounds ou projetos SwiftUI.

## Como abrir e testar no iPad

1. No iPad, abra o app **Arquivos** e copie a pasta `AppMED.playground` para **On My iPad/Swift Playgrounds** (AirDrop, iCloud Drive ou USB).
2. Abra o aplicativo **Swift Playgrounds** e toque em **Importar Playground** se for a primeira vez.
3. Selecione `AppMED.playground`. O live view carregará automaticamente exibindo as cinco abas (Dashboard, Tarefas, Agenda, Sessão e Relatórios).
4. Interaja com as listas, filtros e timer. Os dados são mantidos em memória durante a execução do Playground.

### Compatibilidade confirmada

- O projeto usa apenas APIs disponíveis no **Swift Playgrounds 4** (iPadOS 16 ou superior).
- Dependências opcionais, como o som de término do timer (`AudioServicesPlaySystemSound`), são encapsuladas em verificações `#if canImport` para que o código compile mesmo que a biblioteca não esteja presente.
- Caso prefira começar do zero no iPad, crie um playground em branco e cole o conteúdo da pasta `Sources` e do `Contents.swift` dentro dele.

> Dica: para multitarefa no iPad, use o Split View do Playgrounds e mantenha suas anotações ou PDFs ao lado.

## Como rodar no Mac

1. Abra `AppMED.playground` diretamente no **Xcode 15+** ou no app **Swift Playgrounds para macOS**.
2. Garanta que a aba **Live View** está visível (menu `Editor > Live View`).
3. Se quiser personalizar, edite os arquivos em `Sources/` e o Playground recompilará automaticamente.

## Próximos passos sugeridos

- Trocar a store em memória por persistência real (Core Data/CloudKit) para sincronização entre dispositivos.
- Permitir cadastro e edição completa de disciplinas, tarefas, sessões e notas diretamente pelo usuário.
- Incluir gráficos interativos (Swift Charts) nos relatórios e exportação de dados para PDF/CSV.
- Adicionar notificações locais para lembrar sessões e revisões.
- Criar widgets ou Atalhos da Siri para iniciar rapidamente uma nova sessão de estudo.

## Notas adicionais

- O timer utiliza `AudioServicesPlaySystemSound` para emitir um alerta padrão ao concluir o ciclo.
- A estrutura continua modular: você pode mover `Sources/` para um pacote SwiftUI tradicional se decidir evoluir para um app completo.

Aproveite o Playground para iterar rapidamente no iPad enquanto valida fluxos de estudo reais!
