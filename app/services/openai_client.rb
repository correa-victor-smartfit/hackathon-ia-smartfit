require 'openai'
require 'csv'

class OpenaiClient
  def initialize
    @client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
  end

  def gerar_treino(objetivo, nivel, muscle_groups)
    exercises = load_exercises_from_csv('db/exercises.csv')
    selected_exercises = select_exercises(exercises, muscle_groups)

    prompt = <<~PROMPT
      Crie um plano de treino para uma pessoa com o objetivo de #{objetivo} e nível #{nivel}.
      Escolha 6 exercícios da lista a seguir, priorizando os menos usados e respeitando os critérios:
      - 4 exercícios livres (free_weight, calisthenics)
      - 2 exercícios de máquina (pulleys, machine)
      Exercícios disponíveis:
      #{selected_exercises.map { |ex| "#{ex[:exercise_name]} - #{ex[:muscle_group]} - #{ex[:exercise_material]} (#{ex[:weight_training_count]} treinos)" }.join("\n")}
    PROMPT

    response = @client.chat(
      parameters: {
        model: "gpt-4",
        messages: [
          {
            role: "user",
            content: prompt
          }
        ],
        max_tokens: 300,
        temperature: 0.7
      }
    )

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
    filtered_exercises = exercises.select { |ex| muscle_groups&.include?(ex[:muscle_group]) }
    sorted_exercises = filtered_exercises.sort_by { |ex| ex[:weight_training_count] }

    free_weight = sorted_exercises.select { |ex| ["free_weight", "calisthenics"].include?(ex[:exercise_material]) }.first(4)
    machine = sorted_exercises.select { |ex| ["pulleys", "machine"].include?(ex[:exercise_material]) }.first(2)

    free_weight + machine
  end
end
