require 'openai'

class OpenaiClient
  def initialize
    @client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
  end

  def gerar_treino(objetivo, nivel)
    prompt = "Crie um plano de treino para uma pessoa com o objetivo de #{objetivo} e nível #{nivel}."

    response = @client.completions(
      parameters: {
        model: "text-davinci-003",
        prompt: prompt,
        max_tokens: 300
      }
    )

    response["choices"].first["text"]
  end

  def test_token
    begin
      response = @client.models.list
      if response && response["data"]
        puts "Token válido! Modelos disponíveis:"
        response["data"].each { |model| puts model["id"] }
      else
        puts "Falha ao conectar. Verifique o token e a conexão com a API."
      end
    rescue => e
      puts "Erro ao tentar conectar: #{e.message}"
    end
  end
end
