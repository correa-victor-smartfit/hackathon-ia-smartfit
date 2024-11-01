require 'openai'
require 'csv'

class OpenaiClient
  def initialize
    @client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
  end

  def gerar_treino(objetivo, nivel, days, muscle_groups)
    exercises = load_exercises_from_csv('db/exercises2.csv')
    selected_exercises = select_exercises(exercises, muscle_groups)

    prompt = <<~PROMPT
      Crie um plano de treino para uma pessoa com o objetivo de #{objetivo} e nível #{nivel}.
      Escolha 6 exercícios da lista a seguir, priorizando os menos usados e respeitando os critérios:
      - 4 exercícios livres (free_weight, calisthenics)
      - 2 exercícios de máquina (pulleys, machine)
      - o aluno tem o desejo de treinar #{days} vezes por semana. Treinos nomeados de A a C.
      - espefique o número de séries, de repetições e tempo de descanso
      Exercícios disponíveis:
      #{selected_exercises.map { |ex| "#{ex[:exercise_name]} - #{ex[:muscle_group]} - #{ex[:exercise_material]} (#{ex[:weight_training_count]} treinos)" }.join("\n")}

    Seguir mais ou menos os seguinte template:
        Plano de Treino para {objetivo} - {nivel}
        Treino A
          {Nome do exercício} - x séries de x repetições
          {Nome do exercício} - x séries de x repetições
          ...
        Treino N
          ...
        Lembrando que é importante manter uma alimentação adequada, descanso suficiente e realizar os exercícios com a postura correta para obter os melhores resultados.
    PROMPT

    response = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [
          {
            "role": "system",
            "content": "Você é um assistente de treinamento. \n
            Você não pode mudar o nome dos exercícios e não pode sugerir novos. \n
            Dever usar apenas o que eu te informar no prompt. \n
            Deve me retornar um resultado em formato Markdown."
          },{
            role: "user",
            content: prompt
          }
        ],
        max_tokens: 1000,
        temperature: 0.7
      }
    )
    # response = {"id"=>"chatcmpl-AOmHt6Qe5ej7UTOU89JxxO7Sx90O9", "object"=>"chat.completion", "created"=>1730468853, "model"=>"gpt-3.5-turbo-0125", "choices"=>[{"index"=>0, "message"=>{"role"=>"assistant", "content"=>"Aqui está um plano de treino para ganho de massa muscular para um nível iniciante, utilizando os critérios estabelecidos:\n\n**Treino para Ganho de Massa Muscular - Nível Iniciante**\n\n**Exercícios Livres:**\n1. Agachamento Livre - 4x12\n2. Barra Fixa - 3x10 (ou até a falha)\n3. Flexão de Braço - 4x15\n4. Levantamento Terra - 4x10\n\n**Exercícios de Máquina:**\n1. Agachamento Smith - 3x12\n2. Gêmeos Máquina em Pé - 4x15\n\n**Observações:**\n- Realize o treino de 3 a 4 vezes por semana, alternando os exercícios a cada treino.\n- Mantenha a carga progressiva, aumentando o peso conforme se sentir mais forte.\n- Descanse de 1 a 2 minutos entre as séries e de 2 a 3 minutos entre os exercícios.\n- Não se esqueça de manter uma alimentação adequada para suportar o crescimento muscular.\n\nLembre-se de sempre realizar um aquecimento adequado antes do treino e consultar um profissional de educação física para ajustar o plano de acordo com suas necessidades individuais.", "refusal"=>nil}, "logprobs"=>nil, "finish_reason"=>"stop"}], "usage"=>{"prompt_tokens"=>152, "completion_tokens"=>294, "total_tokens"=>446, "prompt_tokens_details"=>{"cached_tokens"=>0}, "completion_tokens_details"=>{"reasoning_tokens"=>0}}, "system_fingerprint"=>nil}
    # response = {"id"=>"chatcmpl-AOmp1KpvpvLG4ZrRdGzRdFvS42ZHw", "object"=>"chat.completion", "created"=>1730470907, "model"=>"gpt-3.5-turbo-0125", "choices"=>[{"index"=>0, "message"=>{"role"=>"assistant", "content"=>"# Plano de Treino para Ganho de Massa Muscular - Iniciante\n\n### Treino A - Segunda-feira\n\n1. **Agachamento Smith Sumô** - 4 séries de 12 repetições\n2. **Remada Máquina Neutra** - 4 séries de 12 repetições\n3. **Crucifixo Halteres Inclinado** - 3 séries de 15 repetições\n\n### Treino B - Quarta-feira\n\n1. **Leg Press 45** - 4 séries de 12 repetições\n2. **Puxada Máquina** - 4 séries de 12 repetições\n3. **Rosca Direta Halter** - 3 séries de 15 repetições\n\n### Treino C - Sexta-feira\n\n1. **Supino Máquina** - 4 séries de 12 repetições\n2. **Tríceps Máquina Bilateral** - 4 séries de 12 repetições\n3. **Abdominal Máquina** - 3 séries de 15 repetições\n\nLembrando que é importante manter uma alimentação adequada, descanso suficiente e realizar os exercícios com a postura correta para obter os melhores resultados.", "refusal"=>nil}, "logprobs"=>nil, "finish_reason"=>"stop"}], "usage"=>{"prompt_tokens"=>2726, "completion_tokens"=>287, "total_tokens"=>3013, "prompt_tokens_details"=>{"cached_tokens"=>0}, "completion_tokens_details"=>{"reasoning_tokens"=>0}}, "system_fingerprint"=>nil}
    # binding.pry
    response.dig("choices", 0, "message", "content")
  end

  private

  def load_exercises_from_csv(file_path)
    exercises = []
    CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|
      exercises << {
        exercise_name: row[:exercise_name],
        muscle_group: row[:muscle_group],
        exercise_material: row[:exercise_material],
        weight_training_count: row[:weight_training_count].to_i
      }
    end
    exercises
  end

  def select_exercises(exercises, muscle_groups)
    exercises.select { |ex| muscle_groups&.include?(ex[:muscle_group]) }
  end
end
